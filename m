From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/15] qla2xxx: Add QoS support.
Date: Mon,  6 Apr 2009 22:33:40 -0700
Message-ID: <1239082431-19496-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZDGFd4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:33:56 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Set the number of request queues to the module paramater
ql2xmaxqueues.  Each vport gets a request queue. The QoS value
set to the request queues determines priority control for queued
IOs. If QoS value is not specified, the vports use the default
queue 0.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   47 +++++---
 drivers/scsi/qla2xxx/qla_dbg.c  |    7 +-
 drivers/scsi/qla2xxx/qla_def.h  |   23 ++--
 drivers/scsi/qla2xxx/qla_gbl.h  |   27 +++--
 drivers/scsi/qla2xxx/qla_init.c |   30 +++---
 drivers/scsi/qla2xxx/qla_iocb.c |   19 +--
 drivers/scsi/qla2xxx/qla_isr.c  |  242 +++++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_mbx.c  |   63 +++++++----
 drivers/scsi/qla2xxx/qla_mid.c  |  107 +++++++----------
 drivers/scsi/qla2xxx/qla_os.c   |  135 ++++++++++++----------
 drivers/scsi/qla2xxx/qla_sup.c  |    1 +
 11 files changed, 333 insertions(+), 368 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5d44e3e..bda6658 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1469,11 +1469,12 @@ static int
 qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 {
 	int	ret = 0;
-	int	cnt = 0;
-	uint8_t	qos = QLA_DEFAULT_QUE_QOS;
+	uint8_t	qos = 0;
 	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
 	scsi_qla_host_t *vha = NULL;
 	struct qla_hw_data *ha = base_vha->hw;
+	uint16_t options = 0;
+	int	cnt;
 
 	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
 	if (ret) {
@@ -1529,23 +1530,35 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	qla24xx_vport_disable(fc_vport, disable);
 
-	/* Create a queue pair for the vport */
-	if (ha->mqenable) {
-		if (ha->npiv_info) {
-			for (; cnt < ha->nvram_npiv_size; cnt++) {
-				if (ha->npiv_info[cnt].port_name ==
-					vha->port_name &&
-					ha->npiv_info[cnt].node_name ==
-					vha->node_name) {
-					qos = ha->npiv_info[cnt].q_qos;
-					break;
-				}
-			}
+	ret = 0;
+	if (ha->cur_vport_count <= ha->flex_port_count
+		|| ha->max_req_queues == 1 || !ha->npiv_info)
+		goto vport_queue;
+	/* Create a request queue in QoS mode for the vport */
+	for (cnt = ha->flex_port_count; cnt < ha->nvram_npiv_size; cnt++) {
+		if (ha->npiv_info[cnt].port_name == vha->port_name &&
+			ha->npiv_info[cnt].node_name == vha->node_name) {
+			qos = ha->npiv_info[cnt].q_qos;
+			break;
 		}
-		qla25xx_create_queues(vha, qos);
+	}
+	if (qos) {
+		ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, 0,
+			qos);
+		if (!ret)
+			qla_printk(KERN_WARNING, ha,
+			"Can't create request queue for vp_idx:%d\n",
+			vha->vp_idx);
+		else
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			"Request Que:%d created for vp_idx:%d\n",
+			ret, vha->vp_idx));
 	}
 
+vport_queue:
+	vha->req = ha->req_q_map[ret];
 	return 0;
+
 vport_create_failed_2:
 	qla24xx_disable_vp(vha);
 	qla24xx_deallocate_vp_id(vha);
@@ -1586,8 +1599,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    vha->host_no, vha->vp_idx, vha));
         }
 
-	if (ha->mqenable) {
-		if (qla25xx_delete_queues(vha, 0) != QLA_SUCCESS)
+	if (vha->req->id) {
+		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
 			qla_printk(KERN_WARNING, ha,
 				"Queue delete failed.\n");
 	}
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 34760f8..68671a2 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -351,7 +351,7 @@ static inline void *
 qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 {
 	uint32_t cnt, que_idx;
-	uint8_t req_cnt, rsp_cnt, que_cnt;
+	uint8_t que_cnt;
 	struct qla2xxx_mq_chain *mq = ptr;
 	struct device_reg_25xxmq __iomem *reg;
 
@@ -363,9 +363,8 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	mq->type = __constant_htonl(DUMP_CHAIN_MQ);
 	mq->chain_size = __constant_htonl(sizeof(struct qla2xxx_mq_chain));
 
-	req_cnt = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
-	rsp_cnt = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
-	que_cnt = req_cnt > rsp_cnt ? req_cnt : rsp_cnt;
+	que_cnt = ha->max_req_queues > ha->max_rsp_queues ?
+		ha->max_req_queues : ha->max_rsp_queues;
 	mq->count = htonl(que_cnt);
 	for (cnt = 0; cnt < que_cnt; cnt++) {
 		reg = (struct device_reg_25xxmq *) ((void *)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 645cfd9..57d659c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -93,6 +93,7 @@
 #define LSD(x)	((uint32_t)((uint64_t)(x)))
 #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))
 
+#define MAKE_HANDLE(x, y) ((uint32_t)((((uint32_t)(x)) << 16) | (uint32_t)(y)))
 
 /*
  * I/O register
@@ -179,6 +180,7 @@
 #define REQUEST_ENTRY_CNT_24XX		2048	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
+#define RESPONSE_ENTRY_CNT_MQ		128	/* Number of response entries.*/
 
 struct req_que;
 
@@ -2008,7 +2010,8 @@ typedef struct vport_params {
 #define VP_RET_CODE_NOT_FOUND		6
 
 struct qla_hw_data;
-
+struct req_que;
+struct rsp_que;
 /*
  * ISP operations
  */
@@ -2030,10 +2033,9 @@ struct isp_operations {
 	void (*enable_intrs) (struct qla_hw_data *);
 	void (*disable_intrs) (struct qla_hw_data *);
 
-	int (*abort_command) (struct scsi_qla_host *, srb_t *,
-		struct req_que *);
-	int (*target_reset) (struct fc_port *, unsigned int);
-	int (*lun_reset) (struct fc_port *, unsigned int);
+	int (*abort_command) (srb_t *);
+	int (*target_reset) (struct fc_port *, unsigned int, int);
+	int (*lun_reset) (struct fc_port *, unsigned int, int);
 	int (*fabric_login) (struct scsi_qla_host *, uint16_t, uint8_t,
 		uint8_t, uint8_t, uint16_t *, uint8_t);
 	int (*fabric_logout) (struct scsi_qla_host *, uint16_t, uint8_t,
@@ -2079,7 +2081,6 @@ struct isp_operations {
 #define QLA_PCI_MSIX_CONTROL	0xa2
 
 struct scsi_qla_host;
-struct rsp_que;
 
 struct qla_msix_entry {
 	int have_irq;
@@ -2140,7 +2141,6 @@ struct qla_statistics {
 #define MBC_INITIALIZE_MULTIQ 0x1f
 #define QLA_QUE_PAGE 0X1000
 #define QLA_MQ_SIZE 32
-#define QLA_MAX_HOST_QUES 16
 #define QLA_MAX_QUEUES 256
 #define ISP_QUE_REG(ha, id) \
 	((ha->mqenable) ? \
@@ -2170,6 +2170,7 @@ struct rsp_que {
 	struct qla_hw_data *hw;
 	struct qla_msix_entry *msix;
 	struct req_que *req;
+	srb_t *status_srb; /* status continuation entry */
 };
 
 /* Request queue data structure */
@@ -2246,7 +2247,8 @@ struct qla_hw_data {
 	struct rsp_que **rsp_q_map;
 	unsigned long req_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
 	unsigned long rsp_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
-	uint16_t 	max_queues;
+	uint8_t 	max_req_queues;
+	uint8_t 	max_rsp_queues;
 	struct qla_npiv_entry *npiv_info;
 	uint16_t	nvram_npiv_size;
 
@@ -2532,6 +2534,7 @@ struct qla_hw_data {
 	uint16_t        num_vsans;      /* number of vsan created */
 	uint16_t        max_npiv_vports;        /* 63 or 125 per topoloty */
 	int             cur_vport_count;
+	uint16_t	flex_port_count;
 
 	struct qla_chip_state_84xx *cs84xx;
 	struct qla_statistics qla_stats;
@@ -2591,8 +2594,6 @@ typedef struct scsi_qla_host {
 #define SWITCH_FOUND		BIT_0
 #define DFLG_NO_CABLE		BIT_1
 
-	srb_t		*status_srb;	/* Status continuation entry. */
-
 	/* ISP configuration data. */
 	uint16_t	loop_id;		/* Host adapter loop id */
 
@@ -2648,7 +2649,7 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
 	struct qla_hw_data *hw;
-	int	req_ques[QLA_MAX_HOST_QUES];
+	struct req_que *req;
 } scsi_qla_host_t;
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 528913f..b12de01 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -67,6 +67,7 @@ extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
 extern int ql2xiidmaenable;
 extern int ql2xmaxqueues;
+extern int ql2xmultique_tag;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -165,13 +166,13 @@ extern int
 qla2x00_issue_iocb(scsi_qla_host_t *, void *, dma_addr_t, size_t);
 
 extern int
-qla2x00_abort_command(scsi_qla_host_t *, srb_t *, struct req_que *);
+qla2x00_abort_command(srb_t *);
 
 extern int
-qla2x00_abort_target(struct fc_port *, unsigned int);
+qla2x00_abort_target(struct fc_port *, unsigned int, int);
 
 extern int
-qla2x00_lun_reset(struct fc_port *, unsigned int);
+qla2x00_lun_reset(struct fc_port *, unsigned int, int);
 
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
@@ -236,9 +237,11 @@ extern int
 qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
     dma_addr_t);
 
-extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *, struct req_que *);
-extern int qla24xx_abort_target(struct fc_port *, unsigned int);
-extern int qla24xx_lun_reset(struct fc_port *, unsigned int);
+extern int qla24xx_abort_command(srb_t *);
+extern int
+qla24xx_abort_target(struct fc_port *, unsigned int, int);
+extern int
+qla24xx_lun_reset(struct fc_port *, unsigned int, int);
 
 extern int
 qla2x00_system_error(scsi_qla_host_t *);
@@ -295,8 +298,8 @@ extern irqreturn_t qla2100_intr_handler(int, void *);
 extern irqreturn_t qla2300_intr_handler(int, void *);
 extern irqreturn_t qla24xx_intr_handler(int, void *);
 extern void qla2x00_process_response_queue(struct rsp_que *);
-extern void qla24xx_process_response_queue(struct rsp_que *);
-
+extern void
+qla24xx_process_response_queue(struct scsi_qla_host *, struct rsp_que *);
 extern int qla2x00_request_irqs(struct qla_hw_data *, struct rsp_que *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
 
@@ -401,19 +404,21 @@ extern int qla25xx_request_irq(struct rsp_que *);
 extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
-	uint16_t, uint8_t, uint8_t);
+	uint16_t, int, uint8_t);
 extern int qla25xx_create_rsp_que(struct qla_hw_data *, uint16_t, uint8_t,
-	uint16_t);
+	uint16_t, int);
 extern int qla25xx_update_req_que(struct scsi_qla_host *, uint8_t, uint8_t);
 extern void qla2x00_init_response_q_entries(struct rsp_que *);
 extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_queues(struct scsi_qla_host *, uint8_t);
-extern int qla25xx_delete_queues(struct scsi_qla_host *, uint8_t);
+extern int qla25xx_delete_queues(struct scsi_qla_host *);
 extern uint16_t qla24xx_rd_req_reg(struct qla_hw_data *, uint16_t);
 extern uint16_t qla25xx_rd_req_reg(struct qla_hw_data *, uint16_t);
 extern void qla24xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
+extern struct scsi_qla_host * qla25xx_get_host(struct rsp_que *);
+
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9a343ec..059909c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -786,7 +786,6 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		    sizeof(uint32_t);
 		if (ha->mqenable)
 			mq_size = sizeof(struct qla2xxx_mq_chain);
-
 		/* Allocate memory for Fibre Channel Event Buffer. */
 		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 			goto try_eft;
@@ -850,8 +849,7 @@ cont_alloc:
 	rsp_q_size = rsp->length * sizeof(response_t);
 
 	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
-	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
-	    eft_size;
+	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size + eft_size;
 	ha->chain_offset = dump_size;
 	dump_size += mq_size + fce_size;
 
@@ -1013,12 +1011,14 @@ qla2x00_init_response_q_entries(struct rsp_que *rsp)
 	uint16_t cnt;
 	response_t *pkt;
 
+	rsp->ring_ptr = rsp->ring;
+	rsp->ring_index    = 0;
+	rsp->status_srb = NULL;
 	pkt = rsp->ring_ptr;
 	for (cnt = 0; cnt < rsp->length; cnt++) {
 		pkt->signature = RESPONSE_PROCESSED;
 		pkt++;
 	}
-
 }
 
 /**
@@ -1176,7 +1176,7 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		if (ha->flags.msix_enabled) {
 			msix = &ha->msix_entries[1];
 			DEBUG2_17(printk(KERN_INFO
-			"Reistering vector 0x%x for base que\n", msix->entry));
+			"Registering vector 0x%x for base que\n", msix->entry));
 			icb->msix = cpu_to_le16(msix->entry);
 		}
 		/* Use alternate PCI bus number */
@@ -1230,14 +1230,14 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Clear outstanding commands array. */
-	for (que = 0; que < ha->max_queues; que++) {
+	for (que = 0; que < ha->max_req_queues; que++) {
 		req = ha->req_q_map[que];
 		if (!req)
 			continue;
-		for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
+		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
 			req->outstanding_cmds[cnt] = NULL;
 
-		req->current_outstanding_cmd = 0;
+		req->current_outstanding_cmd = 1;
 
 		/* Initialize firmware. */
 		req->ring_ptr  = req->ring;
@@ -1245,13 +1245,10 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		req->cnt      = req->length;
 	}
 
-	for (que = 0; que < ha->max_queues; que++) {
+	for (que = 0; que < ha->max_rsp_queues; que++) {
 		rsp = ha->rsp_q_map[que];
 		if (!rsp)
 			continue;
-		rsp->ring_ptr = rsp->ring;
-		rsp->ring_index    = 0;
-
 		/* Initialize response queue entries */
 		qla2x00_init_response_q_entries(rsp);
 	}
@@ -3180,8 +3177,7 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
 	uint32_t wait_time;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct req_que *req = vha->req;
 	struct rsp_que *rsp = req->rsp;
 
 	atomic_set(&vha->loop_state, LOOP_UPDATE);
@@ -3448,7 +3444,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 	int ret = -1;
 	int i;
 
-	for (i = 1; i < ha->max_queues; i++) {
+	for (i = 1; i < ha->max_rsp_queues; i++) {
 		rsp = ha->rsp_q_map[i];
 		if (rsp) {
 			rsp->options &= ~BIT_0;
@@ -3462,6 +3458,8 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 					"%s Rsp que:%d inited\n", __func__,
 						rsp->id));
 		}
+	}
+	for (i = 1; i < ha->max_req_queues; i++) {
 		req = ha->req_q_map[i];
 		if (req) {
 		/* Clear outstanding commands array. */
@@ -4165,7 +4163,7 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct req_que *req = vha->req;
 	struct rsp_que *rsp = req->rsp;
 
 	if (!vha->vp_idx)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a8abbb9..94b69d8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -453,6 +453,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 			mrk24->lun[2] = MSB(lun);
 			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
 			mrk24->vp_index = vha->vp_idx;
+			mrk24->handle = MAKE_HANDLE(req->id, mrk24->handle);
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun = cpu_to_le16(lun);
@@ -531,9 +532,6 @@ qla2x00_req_pkt(struct scsi_qla_host *vha, struct req_que *req,
 			for (cnt = 0; cnt < REQUEST_ENTRY_SIZE / 4; cnt++)
 				*dword_ptr++ = 0;
 
-			/* Set system defined field. */
-			pkt->sys_define = (uint8_t)req->ring_index;
-
 			/* Set entry count. */
 			pkt->entry_count = 1;
 
@@ -724,19 +722,14 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	uint16_t que_id;
 
 	/* Setup device pointers. */
 	ret = 0;
-	que_id = vha->req_ques[0];
 
-	req = ha->req_q_map[que_id];
+	req = vha->req;
+	rsp = ha->rsp_q_map[0];
 	sp->que = req;
 
-	if (req->rsp)
-		rsp = req->rsp;
-	else
-		rsp = ha->rsp_q_map[que_id];
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
@@ -794,7 +787,7 @@ qla24xx_start_scsi(srb_t *sp)
 	req->cnt -= req_cnt;
 
 	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
-	cmd_pkt->handle = handle;
+	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
 
 	/* Zero out remaining portion of packet. */
 	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
@@ -823,6 +816,8 @@ qla24xx_start_scsi(srb_t *sp)
 
 	/* Set total data segment count. */
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	/* Specify response queue number where completion should happen */
+	cmd_pkt->entry_status = (uint8_t) rsp->id;
 	wmb();
 
 	/* Adjust ring index. */
@@ -842,7 +837,7 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
 		rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla24xx_process_response_queue(rsp);
+		qla24xx_process_response_queue(vha, rsp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_SUCCESS;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d049818..c8e906c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -13,10 +13,9 @@ static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_process_completed_request(struct scsi_qla_host *,
 	struct req_que *, uint32_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
-static void qla2x00_status_cont_entry(scsi_qla_host_t *, sts_cont_entry_t *);
+static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
-static struct scsi_qla_host *qla2x00_get_rsp_host(struct rsp_que *);
 
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
@@ -51,7 +50,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
 		if (hccr & HCCR_RISC_PAUSE) {
@@ -147,7 +146,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
 		if (stat & HSR_RISC_PAUSED) {
@@ -685,7 +684,7 @@ skip_rio:
 		    vha->host_no));
 
 		if (IS_FWI2_CAPABLE(ha))
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 		else
 			qla2x00_process_response_queue(rsp);
 		break;
@@ -766,7 +765,7 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 
-	req = ha->req_q_map[vha->req_ques[0]];
+	req = vha->req;
 	if (!req)
 		return;
 	if (req->max_q_depth <= sdev->queue_depth)
@@ -858,8 +857,8 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		qla2x00_ramp_up_queue_depth(vha, req, sp);
 		qla2x00_sp_compl(ha, sp);
 	} else {
-		DEBUG2(printk("scsi(%ld): Invalid ISP SCSI completion handle\n",
-		    vha->host_no));
+		DEBUG2(printk("scsi(%ld) Req:%d: Invalid ISP SCSI completion"
+			" handle(%d)\n", vha->host_no, req->id, index));
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid ISP SCSI completion handle\n");
 
@@ -881,7 +880,7 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
 
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 
 	if (!vha->flags.online)
 		return;
@@ -926,7 +925,7 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 			}
 			break;
 		case STATUS_CONT_TYPE:
-			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
+			qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
 			break;
 		default:
 			/* Type Not Supported. */
@@ -945,7 +944,8 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 }
 
 static inline void
-qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
+qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len,
+	struct rsp_que *rsp)
 {
 	struct scsi_cmnd *cp = sp->cmd;
 
@@ -962,7 +962,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	sp->request_sense_ptr += sense_len;
 	sp->request_sense_length -= sense_len;
 	if (sp->request_sense_length != 0)
-		sp->fcport->vha->status_srb = sp;
+		rsp->status_srb = sp;
 
 	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
 	    "cmd=%p pid=%ld\n", __func__, sp->fcport->vha->host_no,
@@ -992,7 +992,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	uint32_t	sense_len, rsp_info_len, resid_len, fw_resid_len;
 	uint8_t		*rsp_info, *sense_data;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = rsp->req;
+	uint32_t handle;
+	uint16_t que;
+	struct req_que *req;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -1003,18 +1005,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		comp_status = le16_to_cpu(sts->comp_status);
 		scsi_status = le16_to_cpu(sts->scsi_status) & SS_MASK;
 	}
-
+	handle = (uint32_t) LSW(sts->handle);
+	que = MSW(sts->handle);
+	req = ha->req_q_map[que];
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
-		qla2x00_process_completed_request(vha, req, sts->handle);
+		qla2x00_process_completed_request(vha, req, handle);
 
 		return;
 	}
 
 	/* Validate handle. */
-	if (sts->handle < MAX_OUTSTANDING_COMMANDS) {
-		sp = req->outstanding_cmds[sts->handle];
-		req->outstanding_cmds[sts->handle] = NULL;
+	if (handle < MAX_OUTSTANDING_COMMANDS) {
+		sp = req->outstanding_cmds[handle];
+		req->outstanding_cmds[handle] = NULL;
 	} else
 		sp = NULL;
 
@@ -1030,7 +1034,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	cp = sp->cmd;
 	if (cp == NULL) {
 		DEBUG2(printk("scsi(%ld): Command already returned back to OS "
-		    "pkt->handle=%d sp=%p.\n", vha->host_no, sts->handle, sp));
+		    "pkt->handle=%d sp=%p.\n", vha->host_no, handle, sp));
 		qla_printk(KERN_WARNING, ha,
 		    "Command is NULL: already returned to OS (sp=%p)\n", sp);
 
@@ -1133,7 +1137,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
-		qla2x00_handle_sense(sp, sense_data, sense_len);
+		qla2x00_handle_sense(sp, sense_data, sense_len, rsp);
 		break;
 
 	case CS_DATA_UNDERRUN:
@@ -1192,7 +1196,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
-			qla2x00_handle_sense(sp, sense_data, sense_len);
+			qla2x00_handle_sense(sp, sense_data, sense_len, rsp);
 		} else {
 			/*
 			 * If RISC reports underrun and target does not report
@@ -1334,7 +1338,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 
 	/* Place command on done queue. */
-	if (vha->status_srb == NULL)
+	if (rsp->status_srb == NULL)
 		qla2x00_sp_compl(ha, sp);
 }
 
@@ -1346,11 +1350,11 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
  * Extended sense data.
  */
 static void
-qla2x00_status_cont_entry(scsi_qla_host_t *vha, sts_cont_entry_t *pkt)
+qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 {
 	uint8_t		sense_sz = 0;
-	struct qla_hw_data *ha = vha->hw;
-	srb_t		*sp = vha->status_srb;
+	struct qla_hw_data *ha = rsp->hw;
+	srb_t		*sp = rsp->status_srb;
 	struct scsi_cmnd *cp;
 
 	if (sp != NULL && sp->request_sense_length != 0) {
@@ -1362,7 +1366,7 @@ qla2x00_status_cont_entry(scsi_qla_host_t *vha, sts_cont_entry_t *pkt)
 			    "cmd is NULL: already returned to OS (sp=%p)\n",
 			    sp);
 
-			vha->status_srb = NULL;
+			rsp->status_srb = NULL;
 			return;
 		}
 
@@ -1383,7 +1387,7 @@ qla2x00_status_cont_entry(scsi_qla_host_t *vha, sts_cont_entry_t *pkt)
 
 		/* Place command on done queue. */
 		if (sp->request_sense_length == 0) {
-			vha->status_srb = NULL;
+			rsp->status_srb = NULL;
 			qla2x00_sp_compl(ha, sp);
 		}
 	}
@@ -1399,7 +1403,9 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = rsp->req;
+	uint32_t handle = LSW(pkt->handle);
+	uint16_t que = MSW(pkt->handle);
+	struct req_que *req = ha->req_q_map[que];
 #if defined(QL_DEBUG_LEVEL_2)
 	if (pkt->entry_status & RF_INV_E_ORDER)
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Order\n", __func__);
@@ -1417,14 +1423,14 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 #endif
 
 	/* Validate handle. */
-	if (pkt->handle < MAX_OUTSTANDING_COMMANDS)
-		sp = req->outstanding_cmds[pkt->handle];
+	if (handle < MAX_OUTSTANDING_COMMANDS)
+		sp = req->outstanding_cmds[handle];
 	else
 		sp = NULL;
 
 	if (sp) {
 		/* Free outstanding command slot. */
-		req->outstanding_cmds[pkt->handle] = NULL;
+		req->outstanding_cmds[handle] = NULL;
 
 		/* Bad payload or header */
 		if (pkt->entry_status &
@@ -1486,13 +1492,10 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
  * qla24xx_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
  */
-void
-qla24xx_process_response_queue(struct rsp_que *rsp)
+void qla24xx_process_response_queue(struct scsi_qla_host *vha,
+	struct rsp_que *rsp)
 {
 	struct sts_entry_24xx *pkt;
-	struct scsi_qla_host *vha;
-
-	vha = qla2x00_get_rsp_host(rsp);
 
 	if (!vha->flags.online)
 		return;
@@ -1523,7 +1526,7 @@ qla24xx_process_response_queue(struct rsp_que *rsp)
 			qla2x00_status_entry(vha, rsp, pkt);
 			break;
 		case STATUS_CONT_TYPE:
-			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
+			qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
 			break;
 		case VP_RPT_ID_IOCB_TYPE:
 			qla24xx_report_id_acquisition(vha,
@@ -1626,7 +1629,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1664,7 +1667,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			break;
 		case 0x13:
 		case 0x14:
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -1692,6 +1695,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	struct scsi_qla_host *vha;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1704,7 +1708,8 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	qla24xx_process_response_queue(rsp);
+	vha = qla25xx_get_host(rsp);
+	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
 	spin_unlock_irq(&ha->hardware_lock);
@@ -1713,31 +1718,6 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 }
 
 static irqreturn_t
-qla25xx_msix_rsp_q(int irq, void *dev_id)
-{
-	struct qla_hw_data *ha;
-	struct rsp_que *rsp;
-	struct device_reg_24xx __iomem *reg;
-
-	rsp = (struct rsp_que *) dev_id;
-	if (!rsp) {
-		printk(KERN_INFO
-			"%s(): NULL response queue pointer\n", __func__);
-		return IRQ_NONE;
-	}
-	ha = rsp->hw;
-	reg = &ha->iobase->isp24;
-
-	spin_lock_irq(&ha->hardware_lock);
-
-	qla24xx_process_response_queue(rsp);
-
-	spin_unlock_irq(&ha->hardware_lock);
-
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t
 qla24xx_msix_default(int irq, void *dev_id)
 {
 	scsi_qla_host_t	*vha;
@@ -1760,7 +1740,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	status = 0;
 
 	spin_lock_irq(&ha->hardware_lock);
-	vha = qla2x00_get_rsp_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1798,7 +1778,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 			break;
 		case 0x13:
 		case 0x14:
-			qla24xx_process_response_queue(rsp);
+			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
@@ -1822,31 +1802,13 @@ qla24xx_msix_default(int irq, void *dev_id)
 /* Interrupt handling helpers. */
 
 struct qla_init_msix_entry {
-	uint16_t entry;
-	uint16_t index;
 	const char *name;
 	irq_handler_t handler;
 };
 
-static struct qla_init_msix_entry base_queue = {
-	.entry = 0,
-	.index = 0,
-	.name = "qla2xxx (default)",
-	.handler = qla24xx_msix_default,
-};
-
-static struct qla_init_msix_entry base_rsp_queue = {
-	.entry = 1,
-	.index = 1,
-	.name = "qla2xxx (rsp_q)",
-	.handler = qla24xx_msix_rsp_q,
-};
-
-static struct qla_init_msix_entry multi_rsp_queue = {
-	.entry = 1,
-	.index = 1,
-	.name = "qla2xxx (multi_q)",
-	.handler = qla25xx_msix_rsp_q,
+static struct qla_init_msix_entry msix_entries[2] = {
+	{ "qla2xxx (default)", qla24xx_msix_default },
+	{ "qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
 };
 
 static void
@@ -1873,7 +1835,6 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
-	struct qla_init_msix_entry *msix_queue;
 
 	entries = kzalloc(sizeof(struct msix_entry) * ha->msix_count,
 					GFP_KERNEL);
@@ -1900,7 +1861,7 @@ msix_failed:
 				ha->msix_count, ret);
 			goto msix_out;
 		}
-		ha->max_queues = ha->msix_count - 1;
+		ha->max_rsp_queues = ha->msix_count - 1;
 	}
 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
 				ha->msix_count, GFP_KERNEL);
@@ -1918,45 +1879,27 @@ msix_failed:
 		qentry->rsp = NULL;
 	}
 
-	/* Enable MSI-X for AENs for queue 0 */
-	qentry = &ha->msix_entries[0];
-	ret = request_irq(qentry->vector, base_queue.handler, 0,
-					base_queue.name, rsp);
-	if (ret) {
-		qla_printk(KERN_WARNING, ha,
+	/* Enable MSI-X vectors for the base queue */
+	for (i = 0; i < 2; i++) {
+		qentry = &ha->msix_entries[i];
+		ret = request_irq(qentry->vector, msix_entries[i].handler,
+					0, msix_entries[i].name, rsp);
+		if (ret) {
+			qla_printk(KERN_WARNING, ha,
 			"MSI-X: Unable to register handler -- %x/%d.\n",
 			qentry->vector, ret);
-		qla24xx_disable_msix(ha);
-		goto msix_out;
+			qla24xx_disable_msix(ha);
+			ha->mqenable = 0;
+			goto msix_out;
+		}
+		qentry->have_irq = 1;
+		qentry->rsp = rsp;
+		rsp->msix = qentry;
 	}
-	qentry->have_irq = 1;
-	qentry->rsp = rsp;
 
 	/* Enable MSI-X vector for response queue update for queue 0 */
-	if (ha->max_queues > 1 && ha->mqiobase) {
+	if (ha->mqiobase &&  (ha->max_rsp_queues > 1 || ha->max_req_queues > 1))
 		ha->mqenable = 1;
-		msix_queue = &multi_rsp_queue;
-		qla_printk(KERN_INFO, ha,
-				"MQ enabled, Number of Queue Resources: %d \n",
-				ha->max_queues);
-	} else {
-		ha->mqenable = 0;
-		msix_queue = &base_rsp_queue;
-	}
-
-	qentry = &ha->msix_entries[1];
-	ret = request_irq(qentry->vector, msix_queue->handler, 0,
-						msix_queue->name, rsp);
-	if (ret) {
-		qla_printk(KERN_WARNING, ha,
-			"MSI-X: Unable to register handler -- %x/%d.\n",
-			qentry->vector, ret);
-		qla24xx_disable_msix(ha);
-		ha->mqenable = 0;
-		goto msix_out;
-	}
-	qentry->have_irq = 1;
-	qentry->rsp = rsp;
 
 msix_out:
 	kfree(entries);
@@ -2063,35 +2006,11 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 	}
 }
 
-static struct scsi_qla_host *
-qla2x00_get_rsp_host(struct rsp_que *rsp)
-{
-	srb_t *sp;
-	struct qla_hw_data *ha = rsp->hw;
-	struct scsi_qla_host *vha = NULL;
-	struct sts_entry_24xx *pkt;
-	struct req_que *req;
-
-	if (rsp->id) {
-		pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
-		req = rsp->req;
-		if (pkt && pkt->handle < MAX_OUTSTANDING_COMMANDS) {
-			sp = req->outstanding_cmds[pkt->handle];
-			if (sp)
-				vha = sp->fcport->vha;
-		}
-	}
-	if (!vha)
-	/* handle it in base queue */
-		vha = pci_get_drvdata(ha->pdev);
-
-	return vha;
-}
 
 int qla25xx_request_irq(struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = rsp->hw;
-	struct qla_init_msix_entry *intr = &multi_rsp_queue;
+	struct qla_init_msix_entry *intr = &msix_entries[2];
 	struct qla_msix_entry *msix = rsp->msix;
 	int ret;
 
@@ -2106,3 +2025,30 @@ int qla25xx_request_irq(struct rsp_que *rsp)
 	msix->rsp = rsp;
 	return ret;
 }
+
+struct scsi_qla_host *
+qla25xx_get_host(struct rsp_que *rsp)
+{
+	srb_t *sp;
+	struct qla_hw_data *ha = rsp->hw;
+	struct scsi_qla_host *vha = NULL;
+	struct sts_entry_24xx *pkt;
+	struct req_que *req;
+	uint16_t que;
+	uint32_t handle;
+
+	pkt = (struct sts_entry_24xx *) rsp->ring_ptr;
+	que = MSW(pkt->handle);
+	handle = (uint32_t) LSW(pkt->handle);
+	req = ha->req_q_map[que];
+	if (handle < MAX_OUTSTANDING_COMMANDS) {
+		sp = req->outstanding_cmds[handle];
+		if (sp)
+			return  sp->fcport->vha;
+		else
+			goto base_que;
+	}
+base_que:
+	vha = pci_get_drvdata(ha->pdev);
+	return vha;
+}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4f7e94c..bfdc89f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -748,20 +748,20 @@ qla2x00_issue_iocb(scsi_qla_host_t *vha, void *buffer, dma_addr_t phys_addr,
  *	Kernel context.
  */
 int
-qla2x00_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
+qla2x00_abort_command(srb_t *sp)
 {
 	unsigned long   flags = 0;
-	fc_port_t	*fcport;
 	int		rval;
 	uint32_t	handle = 0;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
+	fc_port_t	*fcport = sp->fcport;
+	scsi_qla_host_t *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = vha->req;
 
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", vha->host_no));
 
-	fcport = sp->fcport;
-
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
 		if (req->outstanding_cmds[handle] == sp)
@@ -800,7 +800,7 @@ qla2x00_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
 }
 
 int
-qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
+qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 {
 	int rval, rval2;
 	mbx_cmd_t  mc;
@@ -813,8 +813,8 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 
 	l = l;
 	vha = fcport->vha;
-	req = vha->hw->req_q_map[0];
-	rsp = vha->hw->rsp_q_map[0];
+	req = vha->hw->req_q_map[tag];
+	rsp = vha->hw->rsp_q_map[tag];
 	mcp->mb[0] = MBC_ABORT_TARGET;
 	mcp->out_mb = MBX_9|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(vha->hw)) {
@@ -850,7 +850,7 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 }
 
 int
-qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
+qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 {
 	int rval, rval2;
 	mbx_cmd_t  mc;
@@ -862,8 +862,8 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	vha = fcport->vha;
-	req = vha->hw->req_q_map[0];
-	rsp = vha->hw->rsp_q_map[0];
+	req = vha->hw->req_q_map[tag];
+	rsp = vha->hw->rsp_q_map[tag];
 	mcp->mb[0] = MBC_LUN_RESET;
 	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
 	if (HAS_EXTENDED_IDS(vha->hw))
@@ -1492,9 +1492,14 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	dma_addr_t	lg_dma;
 	uint32_t	iop[2];
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req;
+	struct rsp_que *rsp;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
+	req = vha->req;
+	rsp = req->rsp;
+
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Login IOCB.\n",
@@ -1505,6 +1510,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
+	lg->handle = MAKE_HANDLE(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags = __constant_cpu_to_le16(LCF_COMMAND_PLOGI);
 	if (opt & BIT_0)
@@ -1753,6 +1759,8 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req;
+	struct rsp_que *rsp;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
@@ -1764,8 +1772,14 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
 
+	if (ql2xmaxqueues > 1)
+		req = ha->req_q_map[0];
+	else
+		req = vha->req;
+	rsp = req->rsp;
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
+	lg->handle = MAKE_HANDLE(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags =
 	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
@@ -2204,21 +2218,21 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 }
 
 int
-qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
+qla24xx_abort_command(srb_t *sp)
 {
 	int		rval;
-	fc_port_t	*fcport;
 	unsigned long   flags = 0;
 
 	struct abort_entry_24xx *abt;
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
+	fc_port_t	*fcport = sp->fcport;
+	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = sp->que;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	fcport = sp->fcport;
-
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
 		if (req->outstanding_cmds[handle] == sp)
@@ -2240,6 +2254,7 @@ qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
 
 	abt->entry_type = ABORT_IOCB_TYPE;
 	abt->entry_count = 1;
+	abt->handle = MAKE_HANDLE(req->id, abt->handle);
 	abt->nport_handle = cpu_to_le16(fcport->loop_id);
 	abt->handle_to_abort = handle;
 	abt->port_id[0] = fcport->d_id.b.al_pa;
@@ -2281,7 +2296,7 @@ struct tsk_mgmt_cmd {
 
 static int
 __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
-    unsigned int l)
+    unsigned int l, int tag)
 {
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
@@ -2295,8 +2310,8 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 
 	vha = fcport->vha;
 	ha = vha->hw;
-	req = ha->req_q_map[0];
-	rsp = ha->rsp_q_map[0];
+	req = vha->req;
+	rsp = req->rsp;
 	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
@@ -2307,6 +2322,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 
 	tsk->p.tsk.entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->p.tsk.entry_count = 1;
+	tsk->p.tsk.handle = MAKE_HANDLE(req->id, tsk->p.tsk.handle);
 	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->p.tsk.timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->p.tsk.control_flags = cpu_to_le32(type);
@@ -2353,15 +2369,15 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 }
 
 int
-qla24xx_abort_target(struct fc_port *fcport, unsigned int l)
+qla24xx_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 {
-	return __qla24xx_issue_tmf("Target", TCF_TARGET_RESET, fcport, l);
+	return __qla24xx_issue_tmf("Target", TCF_TARGET_RESET, fcport, l, tag);
 }
 
 int
-qla24xx_lun_reset(struct fc_port *fcport, unsigned int l)
+qla24xx_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 {
-	return __qla24xx_issue_tmf("Lun", TCF_LUN_RESET, fcport, l);
+	return __qla24xx_issue_tmf("Lun", TCF_LUN_RESET, fcport, l, tag);
 }
 
 int
@@ -3150,6 +3166,8 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 		WRT_REG_DWORD(&reg->req_q_in, 0);
 		WRT_REG_DWORD(&reg->req_q_out, 0);
 	}
+	req->req_q_in = &reg->req_q_in;
+	req->req_q_out = &reg->req_q_out;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -3176,7 +3194,6 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	mcp->mb[6] = MSW(MSD(rsp->dma));
 	mcp->mb[7] = LSW(MSD(rsp->dma));
 	mcp->mb[5] = rsp->length;
-	mcp->mb[11] = rsp->vp_idx;
 	mcp->mb[14] = rsp->msix->entry;
 	mcp->mb[13] = rsp->rid;
 
@@ -3188,7 +3205,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	mcp->mb[8] = 0;
 	/* que out ptr index */
 	mcp->mb[9] = 0;
-	mcp->out_mb = MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8|MBX_7
+	mcp->out_mb = MBX_14|MBX_13|MBX_9|MBX_8|MBX_7
 			|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->flags = MBX_DMA_OUT;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 51716c7..9c08479 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -398,9 +398,8 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	memset(vha->req_ques, 0, sizeof(vha->req_ques));
-	vha->req_ques[0] = ha->req_q_map[0]->id;
-	host->can_queue = ha->req_q_map[0]->length + 128;
+	vha->req = base_vha->req;
+	host->can_queue = base_vha->req->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->max_cmd_len = MAX_CMDSZ;
@@ -515,76 +514,53 @@ int qla25xx_update_req_que(struct scsi_qla_host *vha, uint8_t que, uint8_t qos)
 
 /* Delete all queues for a given vhost */
 int
-qla25xx_delete_queues(struct scsi_qla_host *vha, uint8_t que_no)
+qla25xx_delete_queues(struct scsi_qla_host *vha)
 {
 	int cnt, ret = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (que_no) {
-	/* Delete request queue */
-		req = ha->req_q_map[que_no];
+	/* Delete request queues */
+	for (cnt = 1; cnt < ha->max_req_queues; cnt++) {
+		req = ha->req_q_map[cnt];
 		if (req) {
-			rsp = req->rsp;
 			ret = qla25xx_delete_req_que(vha, req);
 			if (ret != QLA_SUCCESS) {
 				qla_printk(KERN_WARNING, ha,
-				"Couldn't delete req que %d\n", req->id);
+				"Couldn't delete req que %d\n",
+				req->id);
 				return ret;
 			}
-			/* Delete associated response queue */
-			if (rsp) {
-				ret = qla25xx_delete_rsp_que(vha, rsp);
-				if (ret != QLA_SUCCESS) {
-					qla_printk(KERN_WARNING, ha,
-						"Couldn't delete rsp que %d\n",
-						rsp->id);
-					return ret;
-				}
-			}
 		}
-	} else {  /* delete all queues of this host */
-		for (cnt = 0; cnt < QLA_MAX_HOST_QUES; cnt++) {
-			/* Delete request queues */
-			req = ha->req_q_map[vha->req_ques[cnt]];
-			if (req && req->id) {
-				rsp = req->rsp;
-				ret = qla25xx_delete_req_que(vha, req);
-				if (ret != QLA_SUCCESS) {
-					qla_printk(KERN_WARNING, ha,
-						"Couldn't delete req que %d\n",
-						vha->req_ques[cnt]);
-					return ret;
-				}
-				vha->req_ques[cnt] = ha->req_q_map[0]->id;
-			/* Delete associated response queue */
-				if (rsp && rsp->id) {
-					ret = qla25xx_delete_rsp_que(vha, rsp);
-					if (ret != QLA_SUCCESS) {
-						qla_printk(KERN_WARNING, ha,
-						"Couldn't delete rsp que %d\n",
-						rsp->id);
-						return ret;
-					}
-				}
+	}
+
+	/* Delete response queues */
+	for (cnt = 1; cnt < ha->max_rsp_queues; cnt++) {
+		rsp = ha->rsp_q_map[cnt];
+		if (rsp) {
+			ret = qla25xx_delete_rsp_que(vha, rsp);
+			if (ret != QLA_SUCCESS) {
+				qla_printk(KERN_WARNING, ha,
+				"Couldn't delete rsp que %d\n",
+				rsp->id);
+				return ret;
 			}
 		}
 	}
-	qla_printk(KERN_INFO, ha, "Queues deleted for vport:%d\n",
-		vha->vp_idx);
 	return ret;
 }
 
 int
 qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
-	uint8_t vp_idx, uint16_t rid, uint8_t rsp_que, uint8_t qos)
+	uint8_t vp_idx, uint16_t rid, int rsp_que, uint8_t qos)
 {
 	int ret = 0;
 	struct req_que *req = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	uint16_t que_id = 0;
 	device_reg_t __iomem *reg;
+	uint32_t cnt;
 
 	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
 	if (req == NULL) {
@@ -604,8 +580,8 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	}
 
 	mutex_lock(&ha->vport_lock);
-	que_id = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
-	if (que_id >= ha->max_queues) {
+	que_id = find_first_zero_bit(ha->req_qid_map, ha->max_req_queues);
+	if (que_id >= ha->max_req_queues) {
 		mutex_unlock(&ha->vport_lock);
 		qla_printk(KERN_INFO, ha, "No resources to create "
 			 "additional request queue\n");
@@ -617,10 +593,10 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->vp_idx = vp_idx;
 	req->qos = qos;
 
-	if (ha->rsp_q_map[rsp_que]) {
+	if (rsp_que < 0)
+		req->rsp = NULL;
+	else
 		req->rsp = ha->rsp_q_map[rsp_que];
-		req->rsp->req = req;
-	}
 	/* Use alternate PCI bus number */
 	if (MSB(req->rid))
 		options |= BIT_4;
@@ -628,13 +604,16 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	if (LSB(req->rid))
 		options |= BIT_5;
 	req->options = options;
+
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
+		req->outstanding_cmds[cnt] = NULL;
+	req->current_outstanding_cmd = 1;
+
 	req->ring_ptr = req->ring;
 	req->ring_index = 0;
 	req->cnt = req->length;
 	req->id = que_id;
 	reg = ISP_QUE_REG(ha, que_id);
-	req->req_q_in = &reg->isp25mq.req_q_in;
-	req->req_q_out = &reg->isp25mq.req_q_out;
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
 
@@ -657,7 +636,7 @@ que_failed:
 /* create response queue */
 int
 qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
-	uint8_t vp_idx, uint16_t rid)
+	uint8_t vp_idx, uint16_t rid, int req)
 {
 	int ret = 0;
 	struct rsp_que *rsp = NULL;
@@ -672,7 +651,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		goto que_failed;
 	}
 
-	rsp->length = RESPONSE_ENTRY_CNT_2300;
+	rsp->length = RESPONSE_ENTRY_CNT_MQ;
 	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
 			(rsp->length + 1) * sizeof(response_t),
 			&rsp->dma, GFP_KERNEL);
@@ -683,8 +662,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	}
 
 	mutex_lock(&ha->vport_lock);
-	que_id = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
-	if (que_id >= ha->max_queues) {
+	que_id = find_first_zero_bit(ha->rsp_qid_map, ha->max_rsp_queues);
+	if (que_id >= ha->max_rsp_queues) {
 		mutex_unlock(&ha->vport_lock);
 		qla_printk(KERN_INFO, ha, "No resources to create "
 			 "additional response queue\n");
@@ -708,8 +687,6 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (LSB(rsp->rid))
 		options |= BIT_5;
 	rsp->options = options;
-	rsp->ring_ptr = rsp->ring;
-	rsp->ring_index = 0;
 	rsp->id = que_id;
 	reg = ISP_QUE_REG(ha, que_id);
 	rsp->rsp_q_in = &reg->isp25mq.rsp_q_in;
@@ -728,9 +705,12 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		mutex_unlock(&ha->vport_lock);
 		goto que_failed;
 	}
+	if (req >= 0)
+		rsp->req = ha->req_q_map[req];
+	else
+		rsp->req = NULL;
 
 	qla2x00_init_response_q_entries(rsp);
-
 	return rsp->id;
 
 que_failed:
@@ -744,14 +724,16 @@ qla25xx_create_queues(struct scsi_qla_host *vha, uint8_t qos)
 	uint16_t options = 0;
 	uint8_t ret = 0;
 	struct qla_hw_data *ha = vha->hw;
+	struct rsp_que *rsp;
 
 	options |= BIT_1;
-	ret = qla25xx_create_rsp_que(ha, options, vha->vp_idx, 0);
+	ret = qla25xx_create_rsp_que(ha, options, vha->vp_idx, 0, -1);
 	if (!ret) {
 		qla_printk(KERN_WARNING, ha, "Response Que create failed\n");
 		return ret;
 	} else
 		qla_printk(KERN_INFO, ha, "Response Que:%d created.\n", ret);
+	rsp = ha->rsp_q_map[ret];
 
 	options = 0;
 	if (qos & BIT_7)
@@ -759,10 +741,11 @@ qla25xx_create_queues(struct scsi_qla_host *vha, uint8_t qos)
 	ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, ret,
 					qos & ~BIT_7);
 	if (ret) {
-		vha->req_ques[0] = ret;
+		vha->req = ha->req_q_map[ret];
 		qla_printk(KERN_INFO, ha, "Request Que:%d created.\n", ret);
 	} else
 		qla_printk(KERN_WARNING, ha, "Request Que create failed\n");
+	rsp->req = ha->req_q_map[ret];
 
 	return ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f67c842..a64a094 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -187,7 +187,7 @@ static void qla2x00_sp_free_dma(srb_t *);
 /* -------------------------------------------------------------------------- */
 static int qla2x00_alloc_queues(struct qla_hw_data *ha)
 {
-	ha->req_q_map = kzalloc(sizeof(struct req_que *) * ha->max_queues,
+	ha->req_q_map = kzalloc(sizeof(struct req_que *) * ha->max_req_queues,
 				GFP_KERNEL);
 	if (!ha->req_q_map) {
 		qla_printk(KERN_WARNING, ha,
@@ -195,7 +195,7 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha)
 		goto fail_req_map;
 	}
 
-	ha->rsp_q_map = kzalloc(sizeof(struct rsp_que *) * ha->max_queues,
+	ha->rsp_q_map = kzalloc(sizeof(struct rsp_que *) * ha->max_rsp_queues,
 				GFP_KERNEL);
 	if (!ha->rsp_q_map) {
 		qla_printk(KERN_WARNING, ha,
@@ -213,16 +213,8 @@ fail_req_map:
 	return -ENOMEM;
 }
 
-static void qla2x00_free_que(struct qla_hw_data *ha, struct req_que *req,
-	struct rsp_que *rsp)
+static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 {
-	if (rsp && rsp->ring)
-		dma_free_coherent(&ha->pdev->dev,
-		(rsp->length + 1) * sizeof(response_t),
-		rsp->ring, rsp->dma);
-
-	kfree(rsp);
-	rsp = NULL;
 	if (req && req->ring)
 		dma_free_coherent(&ha->pdev->dev,
 		(req->length + 1) * sizeof(request_t),
@@ -232,22 +224,36 @@ static void qla2x00_free_que(struct qla_hw_data *ha, struct req_que *req,
 	req = NULL;
 }
 
+static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
+{
+	if (rsp && rsp->ring)
+		dma_free_coherent(&ha->pdev->dev,
+		(rsp->length + 1) * sizeof(response_t),
+		rsp->ring, rsp->dma);
+
+	kfree(rsp);
+	rsp = NULL;
+}
+
 static void qla2x00_free_queues(struct qla_hw_data *ha)
 {
 	struct req_que *req;
 	struct rsp_que *rsp;
 	int cnt;
 
-	for (cnt = 0; cnt < ha->max_queues; cnt++) {
-		rsp = ha->rsp_q_map[cnt];
+	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
 		req = ha->req_q_map[cnt];
-		qla2x00_free_que(ha, req, rsp);
+		qla2x00_free_req_que(ha, req);
 	}
-	kfree(ha->rsp_q_map);
-	ha->rsp_q_map = NULL;
-
 	kfree(ha->req_q_map);
 	ha->req_q_map = NULL;
+
+	for (cnt = 0; cnt < ha->max_rsp_queues; cnt++) {
+		rsp = ha->rsp_q_map[cnt];
+		qla2x00_free_rsp_que(ha, rsp);
+	}
+	kfree(ha->rsp_q_map);
+	ha->rsp_q_map = NULL;
 }
 
 static char *
@@ -612,7 +618,7 @@ qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 void
 qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 {
-	int cnt, que, id;
+	int cnt;
 	unsigned long flags;
 	srb_t *sp;
 	scsi_qla_host_t *vha = fcport->vha;
@@ -620,32 +626,27 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcport)
 	struct req_que *req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
-		id = vha->req_ques[que];
-		req = ha->req_q_map[id];
-		if (!req)
+	req = vha->req;
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (!sp)
+			continue;
+		if (sp->fcport != fcport)
 			continue;
-		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (!sp)
-				continue;
-			if (sp->fcport != fcport)
-				continue;
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (ha->isp_ops->abort_command(vha, sp, req)) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(sp)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			"Abort failed --  %lx\n",
+			sp->cmd->serial_number));
+		} else {
+			if (qla2x00_eh_wait_on_command(sp->cmd) !=
+				QLA_SUCCESS)
 				DEBUG2(qla_printk(KERN_WARNING, ha,
-				"Abort failed --  %lx\n",
+				"Abort failed while waiting --  %lx\n",
 				sp->cmd->serial_number));
-			} else {
-				if (qla2x00_eh_wait_on_command(sp->cmd) !=
-					QLA_SUCCESS)
-					DEBUG2(qla_printk(KERN_WARNING, ha,
-					"Abort failed while waiting --  %lx\n",
-					sp->cmd->serial_number));
-			}
-			spin_lock_irqsave(&ha->hardware_lock, flags);
 		}
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -726,7 +727,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		" pid=%ld.\n", __func__, vha->host_no, sp, serial));
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(vha, sp, req)) {
+		if (ha->isp_ops->abort_command(sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			"mbx failed.\n", __func__, vha->host_no));
 			ret = FAILED;
@@ -820,7 +821,7 @@ static char *reset_errors[] = {
 
 static int
 __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
-    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int))
+    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, unsigned int, int))
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -841,7 +842,8 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	if (qla2x00_wait_for_loop_ready(vha) != QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 2;
-	if (do_reset(fcport, cmd->device->lun) != QLA_SUCCESS)
+	if (do_reset(fcport, cmd->device->lun, cmd->request->cpu + 1)
+		!= QLA_SUCCESS)
 		goto eh_reset_failed;
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
@@ -1065,7 +1067,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			ret = ha->isp_ops->target_reset(fcport, 0);
+			ret = ha->isp_ops->target_reset(fcport, 0, 0);
 			if (ret != QLA_SUCCESS) {
 				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
 				    "target_reset=%d d_id=%x.\n", __func__,
@@ -1089,7 +1091,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 	struct req_que *req;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < ha->max_queues; que++) {
+	for (que = 0; que < ha->max_req_queues; que++) {
 		req = ha->req_q_map[que];
 		if (!req)
 			continue;
@@ -1124,7 +1126,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
-	struct req_que *req = ha->req_q_map[vha->req_ques[0]];
+	struct req_que *req = vha->req;
 
 	if (sdev->tagged_supported)
 		scsi_activate_tcq(sdev, req->max_q_depth);
@@ -1572,8 +1574,9 @@ skip_pio:
 	}
 
 	/* Determine queue resources */
-	ha->max_queues = 1;
-	if (ql2xmaxqueues <= 1 || (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
+	ha->max_req_queues = ha->max_rsp_queues = 1;
+	if (ql2xmaxqueues <= 1  &&
+		(!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
 			pci_resource_len(ha->pdev, 3));
@@ -1581,20 +1584,17 @@ skip_pio:
 		/* Read MSIX vector size of the board */
 		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
 		ha->msix_count = msix;
-		/* Max queues are bounded by available msix vectors */
-		/* queue 0 uses two msix vectors */
-		if (ha->msix_count - 1 < ql2xmaxqueues)
-			ha->max_queues = ha->msix_count - 1;
-		else if (ql2xmaxqueues > QLA_MQ_SIZE)
-			ha->max_queues = QLA_MQ_SIZE;
-		else
-			ha->max_queues = ql2xmaxqueues;
-		qla_printk(KERN_INFO, ha,
-			"MSI-X vector count: %d\n", msix);
-	}
+		if (ql2xmaxqueues > 1) {
+			ha->max_req_queues = ql2xmaxqueues > QLA_MQ_SIZE ?
+						QLA_MQ_SIZE : ql2xmaxqueues;
+			DEBUG2(qla_printk(KERN_INFO, ha, "QoS mode set, max no"
+			" of request queues:%d\n", ha->max_req_queues));
+		}
+	} else
+		qla_printk(KERN_INFO, ha, "BAR 3 not enabled\n");
 
 mqiobase_exit:
-	ha->msix_count = ha->max_queues + 1;
+	ha->msix_count = ha->max_rsp_queues + 1;
 	return (0);
 
 iospace_error_exit:
@@ -1804,14 +1804,15 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		ret = -ENOMEM;
 		qla2x00_mem_free(ha);
-		qla2x00_free_que(ha, req, rsp);
+		qla2x00_free_req_que(ha, req);
+		qla2x00_free_rsp_que(ha, rsp);
 		goto probe_hw_failed;
 	}
 
 	pci_set_drvdata(pdev, base_vha);
 
 	host = base_vha->host;
-	base_vha->req_ques[0] = req->id;
+	base_vha->req = req;
 	host->can_queue = req->length + 128;
 	if (IS_QLA2XXX_MIDTYPE(ha))
 		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
@@ -1842,7 +1843,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	ha->rsp_q_map[0] = rsp;
 	ha->req_q_map[0] = req;
-
+	rsp->req = req;
+	req->rsp = rsp;
+	set_bit(0, ha->req_qid_map);
+	set_bit(0, ha->rsp_qid_map);
 	/* FWI2-capable only. */
 	req->req_q_in = &ha->iobase->isp24.req_q_in;
 	req->req_q_out = &ha->iobase->isp24.req_q_out;
@@ -1918,8 +1922,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 probe_init_failed:
-	qla2x00_free_que(ha, req, rsp);
-	ha->max_queues = 0;
+	qla2x00_free_req_que(ha, req);
+	qla2x00_free_rsp_que(ha, rsp);
+	ha->max_req_queues = ha->max_rsp_queues = 0;
 
 probe_failed:
 	if (base_vha->timer_active)
@@ -2018,6 +2023,8 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	qla25xx_delete_queues(vha);
+
 	if (ha->flags.fce_enabled)
 		qla2x00_disable_fce_trace(vha, NULL, NULL);
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 81187a0..2a9b3f8 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -920,6 +920,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 
 	entry = data + sizeof(struct qla_npiv_header);
 	cnt = le16_to_cpu(hdr.entries);
+	ha->flex_port_count = cnt;
 	for (i = 0; cnt; cnt--, entry++, i++) {
 		uint16_t flags;
 		struct fc_vport_identifiers vid;
-- 
1.6.2.2.404.ge96f3

