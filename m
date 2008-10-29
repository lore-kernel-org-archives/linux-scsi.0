From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: FC pass through support - revised II
Date: Wed, 29 Oct 2008 05:48:08 -0700
Message-ID: <100CCA84-68CA-4A61-9C7E-CE00C4B1F517@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:46238 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYJ2MsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 08:48:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>

 From 08df89c581e47b9745aa93029948011a7c4d31b0 Mon Sep 17 00:00:00 2001
From: root <root@linux-atl-00.qlogic.com>
Date: Tue, 28 Oct 2008 19:29:30 -0700
Subject: [PATCH] qla2xxx: FC pass through support

This patch will add FC passs through support.
With this patch, the driver support,
- ELS (Extended Link Services)
- FC-CT (Generic Services)

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
  drivers/scsi/qla2xxx/qla_attr.c |  231 ++++++++++++++++++++++++++++++ 
+++++++++
  drivers/scsi/qla2xxx/qla_def.h  |    5 +
  drivers/scsi/qla2xxx/qla_fw.h   |   35 ++++++
  drivers/scsi/qla2xxx/qla_gbl.h  |    4 +
  drivers/scsi/qla2xxx/qla_gs.c   |    2 +-
  drivers/scsi/qla2xxx/qla_init.c |   11 ++
  drivers/scsi/qla2xxx/qla_iocb.c |    9 +-
  drivers/scsi/qla2xxx/qla_isr.c  |   68 ++++++++++++
  8 files changed, 358 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/ 
qla_attr.c
index b223842..357ee3c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1257,6 +1257,231 @@ qla24xx_vport_disable(struct fc_vport  
*fc_vport, bool disable)
  	return 0;
  }

+static int
+qla2x00_execute_fc_service(struct fc_service *service)
+{
+	struct fc_rport *rport = service->rport;
+	fc_port_t *fcport = *(fc_port_t **) rport->dd_data;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
+	struct els_entry_24xx *els_iocb;
+	struct ct_entry_24xx *ct_iocb;
+	request_t *iocb;
+	srb_t *sp;
+	unsigned long flags;
+	uint32_t  handle;
+	int  index, sg_cnt;
+	uint8_t  *els_pkt = service->payload;
+	uint16_t avail_dsds;
+	uint32_t *cur_dsd;
+
+	if (rport->port_state != FC_PORTSTATE_ONLINE || !fcport)
+		goto pt_error0;
+
+	if ((service->srv_request->request_type != FC_FRAME_TYPE_ELS) &&
+	    (service->srv_request->request_type != FC_FRAME_TYPE_FC_CT))
+		goto pt_error0;
+
+	/* ELS doesn't support multiple SG */
+	if ((service->srv_request->request_type == FC_FRAME_TYPE_ELS) &&
+	    (service->payload_sg_cnt > 1 || service->response_sg_cnt > 1)) {
+		printk(KERN_WARNING "ERROR: multiple SG of payload/response "
+		    "[%u/%u]  are not supported for ELS services\n",
+		    service->payload_sg_cnt, service->response_sg_cnt);
+		service->srv_reply.status = FC_SERVICE_UNSUPPORTED;
+		goto pt_error0;
+	}
+
+	sp = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
+	if (!sp)
+		goto pt_error0;
+
+	sp->vha = vha;
+	sp->fcport = fcport;
+	sp->cmd = (struct scsi_cmnd *)service;
+	sp->flags = SRB_ELS_CT;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	iocb = qla2x00_req_pkt(vha);
+	if (iocb == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Passthru request failed to get request packet\n");
+		goto pt_error1;
+	}
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = (srb_t *) sp;
+
+	iocb->handle = handle;
+
+	service->payload_sg_cnt = dma_map_sg(&rport->dev,
+	    service->payload_dma, service->payload_sg_cnt, DMA_TO_DEVICE);
+	service->response_sg_cnt = dma_map_sg(&rport->dev,
+	    service->response_dma, service->response_sg_cnt, DMA_FROM_DEVICE);
+
+	if (service->srv_request->request_type == FC_FRAME_TYPE_ELS) {
+		els_iocb = (struct els_entry_24xx *)iocb;
+		els_iocb->entry_type = ELS_IOCB_TYPE;
+		els_iocb->entry_count = 1;
+		els_iocb->sys_define = 0;
+		els_iocb->entry_status = 0;
+		els_iocb->nport_handle = cpu_to_le16(fcport->loop_id);
+		els_iocb->tx_dsd_count = __constant_cpu_to_le16(1);
+		els_iocb->vp_index = vha->vp_idx;
+		els_iocb->sof_type = EST_SOFI3;
+		els_iocb->rx_dsd_count = __constant_cpu_to_le16(1);
+		els_iocb->opcode = els_pkt[0];
+		els_iocb->port_id[0] = fcport->d_id.b.al_pa;
+		els_iocb->port_id[1] = fcport->d_id.b.area;
+		els_iocb->port_id[2] = fcport->d_id.b.domain;
+		els_iocb->control_flags = 0;
+		els_iocb->rx_byte_count = cpu_to_le32(service->response_size);
+		els_iocb->tx_byte_count = cpu_to_le32(service->payload_size);
+		els_iocb->tx_address[0] = cpu_to_le32(LSD(sg_dma_address
+		    (&service->payload_dma[0])));
+		els_iocb->tx_address[1] = cpu_to_le32(MSD(sg_dma_address
+		    (&service->payload_dma[0])));
+
+		els_iocb->tx_len = cpu_to_le32(sg_dma_len
+		    (&service->payload_dma[0]));
+
+		els_iocb->rx_address[0] = cpu_to_le32(LSD(sg_dma_address
+		    (&service->response_dma[0])));
+		els_iocb->rx_address[1] = cpu_to_le32(MSD(sg_dma_address
+		    (&service->response_dma[0])));
+
+		els_iocb->rx_len = cpu_to_le32(sg_dma_len
+		    (&service->response_dma[0]));
+	
+		/* lld_pkt is only for ELS services in case of abort */
+		service->lld_pkt = (void *) els_iocb;
+	} else {
+		ct_iocb = (struct ct_entry_24xx *)iocb;
+		ct_iocb->entry_type = CT_IOCB_TYPE;
+		ct_iocb->entry_count = 1;
+		ct_iocb->entry_status = 0;
+		ct_iocb->comp_status = __constant_cpu_to_le16(0);
+		if (IS_FWI2_CAPABLE(ha))
+			ct_iocb->nport_handle = cpu_to_le16(NPH_SNS);
+		else
+			ct_iocb->nport_handle =
+			    cpu_to_le16(SIMPLE_NAME_SERVER);
+		ct_iocb->cmd_dsd_count =
+		    __constant_cpu_to_le16(service->payload_sg_cnt);
+		ct_iocb->vp_index = vha->vp_idx;
+		ct_iocb->timeout =
+		    __constant_cpu_to_le16(service->timeout);
+		ct_iocb->rsp_dsd_count =
+		    __constant_cpu_to_le16(service->response_sg_cnt);
+		ct_iocb->rsp_byte_count =
+		    cpu_to_le32(service->response_size);
+		ct_iocb->cmd_byte_count =
+		    cpu_to_le32(service->payload_size);
+		ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(sg_dma_address
+		    (&service->payload_dma[0])));
+		ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(sg_dma_address
+		    (&service->payload_dma[0])));
+
+		ct_iocb->dseg_0_len = cpu_to_le32(sg_dma_len
+		    (&service->payload_dma[0]));
+
+		sg_cnt = service->response_sg_cnt;
+		avail_dsds = 1;
+		cur_dsd = (uint32_t *)ct_iocb->dseg_1_address;
+		index = 0;
+		while (sg_cnt) {
+			cont_a64_entry_t *cont_pkt;
+
+			/* Allocate additional continuation packets? */
+			if (avail_dsds == 0) {
+				/*
+				 * Five DSDs are available in the Continuation
+				 * Type 1 IOCB.
+				 */
+				cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+				cur_dsd =
+				    (uint32_t *) cont_pkt->dseg_0_address;
+				avail_dsds = 5;
+			}
+
+			*cur_dsd++ = cpu_to_le32(LSD(sg_dma_address
+			    (&service->response_dma[index])));
+			*cur_dsd++ = cpu_to_le32(MSD(sg_dma_address
+			    (&service->response_dma[index])));
+			*cur_dsd++ = cpu_to_le32(sg_dma_len
+			    (&service->response_dma[index]));
+			avail_dsds--;
+			sg_cnt--;
+			index++;
+		}
+	}
+
+	wmb();
+	qla2x00_isp_cmd(vha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return 0;
+pt_error1:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+pt_error0:
+	qla_printk(KERN_WARNING, ha, "Passthru ELS failed\n");
+
+	return -EINVAL;
+}
+
+static int
+qla2x00_abort_fc_service(struct fc_service *service)
+{
+	unsigned long flags;
+	struct fc_rport *rport = service->rport;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct abort_entry_24xx *abort_iocb;
+	struct els_entry_24xx *els_iocb = service->lld_pkt;
+
+	printk("ELS/CT: DEBUG: %s is called...\n", __func__);
+	if (service->srv_request->request_type != FC_FRAME_TYPE_ELS) {
+		printk(KERN_ERR "abort frame is not supported\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	abort_iocb = (struct abort_entry_24xx *)qla2x00_req_pkt(vha);
+
+	abort_iocb->entry_type = ABORT_IOCB_TYPE;
+	abort_iocb->entry_count = 1;
+	abort_iocb->handle_count = 0;
+	abort_iocb->entry_status = 0;
+	abort_iocb->options = 0;
+	abort_iocb->handle_to_abort = els_iocb->handle;
+	abort_iocb->port_id[0] = els_iocb->port_id[0];
+	abort_iocb->port_id[1] = els_iocb->port_id[1];
+	abort_iocb->port_id[2] = els_iocb->port_id[2];
+	abort_iocb->vp_index = vha->vp_idx;
+
+	wmb();
+	qla2x00_isp_cmd(vha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	service->service_state_flag = FC_SERVICE_STATE_ABORTED;
+
+	return 0;
+}
+
  struct fc_function_template qla2xxx_transport_functions = {

  	.show_host_node_name = 1,
@@ -1300,6 +1525,9 @@ struct fc_function_template  
qla2xxx_transport_functions = {
  	.vport_create = qla24xx_vport_create,
  	.vport_disable = qla24xx_vport_disable,
  	.vport_delete = qla24xx_vport_delete,
+
+	.execute_fc_service = qla2x00_execute_fc_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
  };

  struct fc_function_template qla2xxx_transport_vport_functions = {
@@ -1340,6 +1568,9 @@ struct fc_function_template  
qla2xxx_transport_vport_functions = {
  	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
  	.terminate_rport_io = qla2x00_terminate_rport_io,
  	.get_fc_host_stats = qla2x00_get_fc_host_stats,
+
+	.execute_fc_service = qla2x00_execute_fc_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
  };

  void
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/ 
qla_def.h
index edead28..4cf8b1b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -93,6 +93,10 @@
  #define LSD(x)	((uint32_t)((uint64_t)(x)))
  #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))

+/* ELS PT request buffer = 32 bytes */
+#define EXT_ELS_PT_REQ_WWPN_VALID	0x1
+#define EXT_ELS_PT_REQ_WWNN_VALID	0x2
+#define EXT_ELS_PT_REQ_PID_VALID	0x4

  /*
   * I/O register
@@ -213,6 +217,7 @@ typedef struct srb {
  #define SRB_FO_CANCEL		BIT_9	/* Command don't need to do failover */
  #define SRB_IOCTL		BIT_10	/* IOCTL command. */
  #define SRB_TAPE		BIT_11	/* FCP2 (Tape) command. */
+#define SRB_ELS_CT		BIT_12	/* Link/Generic Service request. */

  /*
   * ISP I/O Register Set structure definitions.
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/ 
qla_fw.h
index d1d1420..05b6910 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -625,6 +625,41 @@ struct els_entry_24xx {
  	uint32_t rx_len;		/* Data segment 1 length. */
  };

+struct els_status_24xx {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System Defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+
+	uint16_t comp_status;
+
+	uint16_t nport_handle;		/* N_PORT handle. */
+
+	uint16_t tx_dsd_count;
+
+	uint8_t vp_index;
+	uint8_t sof_type;
+
+	uint32_t rx_xchg_address;	/* Receive exchange address. */
+	uint16_t rx_dsd_count;
+
+	uint8_t opcode;
+	uint8_t reserved_2;
+
+	uint8_t port_id[3];
+	uint8_t reserved_3;
+
+	uint16_t reserved_4;
+
+	uint16_t control_flags;		/* Control flags. */
+
+	uint32_t total_byte_count;
+	uint32_t err_subcode1;
+	uint32_t err_subcode2;
+};
+
  /*
   * ISP queue - Mailbox Command entry structure definition.
   */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/ 
qla_gbl.h
index c0cc686..7e71cdf 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -124,6 +124,9 @@ extern int qla2x00_start_scsi(srb_t *sp);
  extern int qla24xx_start_scsi(srb_t *sp);
  int qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
  int __qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
+extern request_t * qla2x00_req_pkt(scsi_qla_host_t *);
+extern void qla2x00_isp_cmd(scsi_qla_host_t *);
+extern cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t  
*);

  /*
   * Global Function Prototypes in qla_mbx.c source file.
@@ -350,6 +353,7 @@ extern int qla2x00_fdmi_register(scsi_qla_host_t *);
  extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
  extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
  extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *);
+extern int qla2x00_mgmt_svr_login(scsi_qla_host_t *);

  /*
   * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/ 
qla_gs.c
index db8de06..201ed93 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1096,7 +1096,7 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *vha)
   *
   * Returns 0 on success.
   */
-static int
+int
  qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
  {
  	int ret;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/ 
qla_init.c
index 7bee87f..2a92f6b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2400,6 +2400,17 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
  			return (QLA_SUCCESS);
  		}

+		/* allocate fc_port_t structure for name/directory server */
+		fcptemp = qla2x00_alloc_fcport(vha, GFP_KERNEL);
+		fcptemp->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
+		fcptemp->loop_id = loop_id;
+		fcptemp->d_id.b.domain = 0xff;
+		fcptemp->d_id.b.area = 0xff;
+		fcptemp->d_id.b.al_pa = 0xfc;
+		list_add_tail(&fcptemp->list, &vha->vp_fcports);
+		atomic_set(&fcptemp->state, FCS_ONLINE);
+		qla2x00_reg_remote_port(vha, fcptemp);
+
  		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags)) {
  			if (qla2x00_rft_id(vha)) {
  				/* EMPTY */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/ 
qla_iocb.c
index 0c145c9..996bfe9 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,9 +11,6 @@

  #include <scsi/scsi_tcq.h>

-static request_t *qla2x00_req_pkt(scsi_qla_host_t *);
-static void qla2x00_isp_cmd(scsi_qla_host_t *);
-
  /**
   * qla2x00_get_cmd_direction() - Determine control_flag data  
direction.
   * @cmd: SCSI command
@@ -119,7 +116,7 @@ qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *vha)
   *
   * Returns a pointer to the continuation type 1 IOCB packet.
   */
-static inline cont_a64_entry_t *
+inline cont_a64_entry_t *
  qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha)
  {
  	cont_a64_entry_t *cont_pkt;
@@ -481,7 +478,7 @@ qla2x00_marker(scsi_qla_host_t *vha, uint16_t  
loop_id, uint16_t lun,
   *
   * Returns NULL if function failed, else, a pointer to the request  
packet.
   */
-static request_t *
+request_t *
  qla2x00_req_pkt(scsi_qla_host_t *vha)
  {
  	struct qla_hw_data *ha = vha->hw;
@@ -552,7 +549,7 @@ qla2x00_req_pkt(scsi_qla_host_t *vha)
   *
   * Note: The caller must hold the hardware lock before calling this  
routine.
   */
-static void
+void
  qla2x00_isp_cmd(scsi_qla_host_t *vha)
  {
  	struct qla_hw_data *ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ 
qla_isr.c
index 89d3271..3594bae 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1431,9 +1431,13 @@ void
  qla24xx_process_response_queue(struct scsi_qla_host *vha)
  {
  	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
  	struct sts_entry_24xx *pkt;
  	struct rsp_que *rsp = ha->rsp;
+	struct els_status_24xx *els_status;
+	struct fc_service *service;
+	srb_t *sp;

  	if (!vha->flags.online)
  		return;
@@ -1466,10 +1470,74 @@ qla24xx_process_response_queue(struct  
scsi_qla_host *vha)
  		case STATUS_CONT_TYPE:
  			qla2x00_status_cont_entry(vha, (sts_cont_entry_t *)pkt);
  			break;
+ 		case MS_IOCB_TYPE:
+		case ELS_IOCB_TYPE:
+			if (pkt->handle < MAX_OUTSTANDING_COMMANDS) {
+				sp = req->outstanding_cmds[pkt->handle];
+				service = (struct fc_service *) sp->cmd;
+				req->outstanding_cmds[pkt->handle] = NULL;
+			} else {
+				service = NULL;
+				break;
+			}
+
+			service->service_state_flag = FC_SERVICE_STATE_DONE;
+			service->srv_reply.status = FC_SERVICE_COMPLETE;
+			service->srv_reply.error_code = pkt->comp_status;
+
+			if (pkt->comp_status) {
+				printk(KERN_WARNING "scsi(%ld): ELS/CT: "
+				    "comp_status = %x\n", vha->host_no,
+				    pkt->comp_status);
+				els_status = (struct els_status_24xx *)pkt;
+				service->srv_reply.residual = 0;
+				if (pkt->comp_status == CS_DATA_UNDERRUN)
+					service->srv_reply.residual =
+					    els_status->total_byte_count;
+				else if (pkt->comp_status == CS_ABORTED) {
+					service->service_state_flag =
+					    FC_SERVICE_STATE_ABORTED;
+					service->srv_reply.status =
+					    FC_SERVICE_ABORT;
+				} else
+				service->srv_reply.status = FC_SERVICE_ERROR;
+			}
+
+			dma_unmap_sg(&ha->pdev->dev, service->payload_dma,
+			    service->payload_sg_cnt, DMA_TO_DEVICE);
+			dma_unmap_sg(&ha->pdev->dev, service->response_dma,
+			    service->response_sg_cnt, DMA_FROM_DEVICE);
+
+			mempool_free(sp, ha->srb_mempool);
+			service->service_done(service);
+ 			break;
  		case VP_RPT_ID_IOCB_TYPE:
  			qla24xx_report_id_acquisition(vha,
  			    (struct vp_rpt_id_entry_24xx *)pkt);
  			break;
+		case ABORT_IOCB_TYPE:
+			if (pkt->comp_status) {
+				if (pkt->handle < MAX_OUTSTANDING_COMMANDS) {
+					sp = req->outstanding_cmds[pkt->handle];
+					req->outstanding_cmds[pkt->handle] =
+					    NULL;
+					if (sp->flags & SRB_ELS_CT) {
+						service = (struct fc_service *)
+						    sp->cmd;
+						qla_printk(KERN_ERR, ha,
+						    "failed to abort"
+						    " FC service %p\n",
+						    service);
+
+					} else
+						qla_printk(KERN_ERR, ha,
+						    "failed to abort"
+						    " SCSI CMD[0] = %2x\n",
+						    sp->cmd->cmnd[0]);
+				}
+			}
+			
+			break;
  		default:
  			/* Type Not Supported. */
  			DEBUG4(printk(KERN_WARNING
-- 
1.6.0.2


