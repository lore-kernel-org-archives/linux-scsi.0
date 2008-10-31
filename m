From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 2/2] FC pass through support - revised III
Date: Fri, 31 Oct 2008 08:34:47 -0700
Message-ID: <B125BA56-8293-4C42-AEBC-0C0DCAC365D0@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-56-199468201
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41119 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYJaPeu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Oct 2008 11:34:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>


--Apple-Mail-56-199468201
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Attachment is also available at the bottom.
---
 From 4c6fc04a25afd6dd495975434e9732ede4a1bae1 Mon Sep 17 00:00:00 2001
From: root <root@linux-atl-00.qlogic.com>
Date: Fri, 31 Oct 2008 08:15:56 -0700
Subject: [PATCH] qla2xxx: FC pass through support

This patch will add FC passs through support.
With this patch, the driver support,
- ELS (Extended Link Services)
- FC-CT (Generic Services)

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
  drivers/scsi/qla2xxx/qla_attr.c |  253 ++++++++++++++++++++++++++++++ 
+++++++++
  drivers/scsi/qla2xxx/qla_def.h  |    5 +
  drivers/scsi/qla2xxx/qla_fw.h   |   35 ++++++
  drivers/scsi/qla2xxx/qla_gbl.h  |    4 +
  drivers/scsi/qla2xxx/qla_gs.c   |    2 +-
  drivers/scsi/qla2xxx/qla_init.c |   11 ++
  drivers/scsi/qla2xxx/qla_iocb.c |    9 +-
  drivers/scsi/qla2xxx/qla_isr.c  |   68 +++++++++++
  8 files changed, 380 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/ 
qla_attr.c
index b223842..945c840 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1257,6 +1257,253 @@ qla24xx_vport_disable(struct fc_vport  
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
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+	struct req_que *req = ha->req;
+	struct els_entry_24xx *els_iocb;
+	struct ct_entry_24xx *ct_iocb;
+	request_t *iocb;
+	srb_t *sp;
+	unsigned long flags;
+	uint32_t  handle;
+	int  index;
+	int  req_sg_cnt, rsp_sg_cnt;
+	uint8_t  els_pkt[20];
+	size_t   copy_size;
+	uint16_t avail_dsds;
+	uint32_t *cur_dsd;
+	struct scatterlist *sg;
+
+	/* At this time, pass throug supported by 4Gb or higher */
+	if (!IS_FWI2_CAPABLE(ha))
+		goto pt_error0;
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
+	    (service->req_sg_cnt > 1 || service->rsp_sg_cnt > 1)) {
+		printk(KERN_WARNING "ERROR: multiple SG of request/response "
+		    "[%u/%u]  are not supported for ELS services\n",
+		    service->req_sg_cnt, service->rsp_sg_cnt);
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
+	iocb = qla2x00_req_pkt(base_vha);
+	if (iocb == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Passthru request failed to get request packet\n");
+		goto pt_error1;
+	}
+
+	req_sg_cnt = dma_map_sg(&ha->pdev->dev, service->sg_req,
+	    service->req_sg_cnt, DMA_TO_DEVICE);
+	if (!req_sg_cnt)
+		goto pt_error1;
+	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, service->sg_rsp,
+	    service->rsp_sg_cnt, DMA_FROM_DEVICE);
+	if (!rsp_sg_cnt)
+		goto pt_error2;
+
+	copy_size = sg_copy_to_buffer(service->sg_req, req_sg_cnt,
+	    els_pkt, 20);
+	if (!copy_size)
+		goto pt_error3;
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
+		els_iocb->rx_byte_count = cpu_to_le32(service->rsp_size);
+		els_iocb->tx_byte_count = cpu_to_le32(service->req_size);
+		els_iocb->tx_address[0] = cpu_to_le32(LSD(sg_dma_address
+		    (&service->sg_req[0])));
+		els_iocb->tx_address[1] = cpu_to_le32(MSD(sg_dma_address
+		    (&service->sg_req[0])));
+
+		els_iocb->tx_len = cpu_to_le32(sg_dma_len
+		    (&service->sg_req[0]));
+
+		els_iocb->rx_address[0] = cpu_to_le32(LSD(sg_dma_address
+		    (&service->sg_rsp[0])));
+		els_iocb->rx_address[1] = cpu_to_le32(MSD(sg_dma_address
+		    (&service->sg_rsp[0])));
+
+		els_iocb->rx_len = cpu_to_le32(sg_dma_len
+		    (&service->sg_rsp[0]));
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
+		    __constant_cpu_to_le16(req_sg_cnt);
+		ct_iocb->vp_index = vha->vp_idx;
+		ct_iocb->timeout = 0;
+		ct_iocb->rsp_dsd_count =
+		    __constant_cpu_to_le16(rsp_sg_cnt);
+		ct_iocb->rsp_byte_count =
+		    cpu_to_le32(service->rsp_size);
+		ct_iocb->cmd_byte_count =
+		    cpu_to_le32(service->req_size);
+		ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(sg_dma_address
+		    (&service->sg_req[0])));
+		ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(sg_dma_address
+		    (&service->sg_req[0])));
+
+		ct_iocb->dseg_0_len = cpu_to_le32(sg_dma_len
+		    (&service->sg_req[0]));
+
+		rsp_sg_cnt = service->rsp_sg_cnt;
+		avail_dsds = 1;
+		cur_dsd = (uint32_t *)ct_iocb->dseg_1_address;
+		index = 0;
+		for_each_sg(service->sg_rsp, sg, rsp_sg_cnt, index) {
+			dma_addr_t       sle_dma;
+			cont_a64_entry_t *cont_pkt;
+
+			/* Allocate additional continuation packets? */
+			if (avail_dsds == 0) {
+				/*
+				 * Five DSDs are available in the Cont.
+				 * Type 1 IOCB.
+				 */
+				cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+				cur_dsd =
+				    (uint32_t *) cont_pkt->dseg_0_address;
+				avail_dsds = 5;
+			}
+
+			sle_dma = sg_dma_address(sg);
+			*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+			*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
+			avail_dsds--;
+		}
+	}
+
+	wmb();
+	qla2x00_isp_cmd(vha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return 0;
+pt_error3:
+	dma_unmap_sg(&ha->pdev->dev, service->sg_rsp,
+	    service->rsp_sg_cnt, DMA_FROM_DEVICE);
+pt_error2:
+	dma_unmap_sg(&ha->pdev->dev, service->sg_req,
+	    service->req_sg_cnt, DMA_TO_DEVICE);
+pt_error1:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	mempool_free(sp, ha->srb_mempool);
+pt_error0:
+	qla_printk(KERN_WARNING, ha, "Passthru ELS failed\n");
+	service->srv_reply.status = FC_SERVICE_UNSUPPORTED;
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
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
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
+	abort_iocb = (struct abort_entry_24xx *)qla2x00_req_pkt(base_vha);
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
@@ -1300,6 +1547,9 @@ struct fc_function_template  
qla2xxx_transport_functions = {
  	.vport_create = qla24xx_vport_create,
  	.vport_disable = qla24xx_vport_disable,
  	.vport_delete = qla24xx_vport_delete,
+
+	.execute_fc_service = qla2x00_execute_fc_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
  };

  struct fc_function_template qla2xxx_transport_vport_functions = {
@@ -1340,6 +1590,9 @@ struct fc_function_template  
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
index 89d3271..cfbb93b 100644
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
+			dma_unmap_sg(&ha->pdev->dev, service->sg_req,
+			    service->req_sg_cnt, DMA_TO_DEVICE);
+			dma_unmap_sg(&ha->pdev->dev, service->sg_rsp,
+			    service->rsp_sg_cnt, DMA_FROM_DEVICE);
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


--Apple-Mail-56-199468201
Content-Disposition: attachment;
	filename=0002-qla2xxx-FC-pass-through-support.patch
Content-Type: application/octet-stream;
	x-unix-mode=0755;
	name="0002-qla2xxx-FC-pass-through-support.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=204c6fc04a25afd6dd495975434e9732ede4a1bae1=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20root=20<root@linux-atl-00.qlogic.com>=0ADate:=20=
Fri,=2031=20Oct=202008=2008:15:56=20-0700=0ASubject:=20[PATCH]=20=
qla2xxx:=20FC=20pass=20through=20support=0A=0AThis=20patch=20will=20add=20=
FC=20passs=20through=20support.=0AWith=20this=20patch,=20the=20driver=20=
support,=0A-=20ELS=20(Extended=20Link=20Services)=0A-=20FC-CT=20(Generic=20=
Services)=0A=0ASigned-off-by:=20Seokmann=20Ju=20<seokmann.ju@qlogic.com>=0A=
---=0A=20drivers/scsi/qla2xxx/qla_attr.c=20|=20=20253=20=
+++++++++++++++++++++++++++++++++++++++=0A=20=
drivers/scsi/qla2xxx/qla_def.h=20=20|=20=20=20=205=20+=0A=20=
drivers/scsi/qla2xxx/qla_fw.h=20=20=20|=20=20=2035=20++++++=0A=20=
drivers/scsi/qla2xxx/qla_gbl.h=20=20|=20=20=20=204=20+=0A=20=
drivers/scsi/qla2xxx/qla_gs.c=20=20=20|=20=20=20=202=20+-=0A=20=
drivers/scsi/qla2xxx/qla_init.c=20|=20=20=2011=20++=0A=20=
drivers/scsi/qla2xxx/qla_iocb.c=20|=20=20=20=209=20+-=0A=20=
drivers/scsi/qla2xxx/qla_isr.c=20=20|=20=20=2068=20+++++++++++=0A=208=20=
files=20changed,=20380=20insertions(+),=207=20deletions(-)=0A=0Adiff=20=
--git=20a/drivers/scsi/qla2xxx/qla_attr.c=20=
b/drivers/scsi/qla2xxx/qla_attr.c=0Aindex=20b223842..945c840=20100644=0A=
---=20a/drivers/scsi/qla2xxx/qla_attr.c=0A+++=20=
b/drivers/scsi/qla2xxx/qla_attr.c=0A@@=20-1257,6=20+1257,253=20@@=20=
qla24xx_vport_disable(struct=20fc_vport=20*fc_vport,=20bool=20disable)=0A=
=20=09return=200;=0A=20}=0A=20=0A+static=20int=0A=
+qla2x00_execute_fc_service(struct=20fc_service=20*service)=0A+{=0A+=09=
struct=20fc_rport=20*rport=20=3D=20service->rport;=0A+=09fc_port_t=20=
*fcport=20=3D=20*(fc_port_t=20**)=20rport->dd_data;=0A+=09struct=20=
Scsi_Host=20*host=20=3D=20rport_to_shost(rport);=0A+=09scsi_qla_host_t=20=
*vha=20=3D=20shost_priv(host);=0A+=09struct=20qla_hw_data=20*ha=20=3D=20=
vha->hw;=0A+=09scsi_qla_host_t=20*base_vha=20=3D=20=
pci_get_drvdata(ha->pdev);=0A+=09struct=20req_que=20*req=20=3D=20=
ha->req;=0A+=09struct=20els_entry_24xx=20*els_iocb;=0A+=09struct=20=
ct_entry_24xx=20*ct_iocb;=0A+=09request_t=20*iocb;=0A+=09srb_t=20*sp;=0A=
+=09unsigned=20long=20flags;=0A+=09uint32_t=20=20handle;=0A+=09int=20=20=
index;=0A+=09int=20=20req_sg_cnt,=20rsp_sg_cnt;=0A+=09uint8_t=20=20=
els_pkt[20];=0A+=09size_t=20=20=20copy_size;=0A+=09uint16_t=20=
avail_dsds;=0A+=09uint32_t=20*cur_dsd;=0A+=09struct=20scatterlist=20*sg;=0A=
+=0A+=09/*=20At=20this=20time,=20pass=20throug=20supported=20by=204Gb=20=
or=20higher=20*/=0A+=09if=20(!IS_FWI2_CAPABLE(ha))=0A+=09=09goto=20=
pt_error0;=0A+=0A+=09if=20(rport->port_state=20!=3D=20=
FC_PORTSTATE_ONLINE=20||=20!fcport)=0A+=09=09goto=20pt_error0;=0A+=0A+=09=
if=20((service->srv_request->request_type=20!=3D=20FC_FRAME_TYPE_ELS)=20=
&&=0A+=09=20=20=20=20(service->srv_request->request_type=20!=3D=20=
FC_FRAME_TYPE_FC_CT))=0A+=09=09goto=20pt_error0;=0A+=0A+=09/*=20ELS=20=
doesn't=20support=20multiple=20SG=20*/=0A+=09if=20=
((service->srv_request->request_type=20=3D=3D=20FC_FRAME_TYPE_ELS)=20&&=0A=
+=09=20=20=20=20(service->req_sg_cnt=20>=201=20||=20service->rsp_sg_cnt=20=
>=201))=20{=0A+=09=09printk(KERN_WARNING=20"ERROR:=20multiple=20SG=20of=20=
request/response=20"=0A+=09=09=20=20=20=20"[%u/%u]=20=20are=20not=20=
supported=20for=20ELS=20services\n",=0A+=09=09=20=20=20=20=
service->req_sg_cnt,=20service->rsp_sg_cnt);=0A+=09=09=
service->srv_reply.status=20=3D=20FC_SERVICE_UNSUPPORTED;=0A+=09=09goto=20=
pt_error0;=0A+=09}=0A+=0A+=09sp=20=3D=20mempool_alloc(ha->srb_mempool,=20=
GFP_ATOMIC);=0A+=09if=20(!sp)=0A+=09=09goto=20pt_error0;=0A+=0A+=09=
sp->vha=20=3D=20vha;=0A+=09sp->fcport=20=3D=20fcport;=0A+=09sp->cmd=20=3D=20=
(struct=20scsi_cmnd=20*)service;=0A+=09sp->flags=20=3D=20SRB_ELS_CT;=0A+=0A=
+=09spin_lock_irqsave(&ha->hardware_lock,=20flags);=0A+=09iocb=20=3D=20=
qla2x00_req_pkt(base_vha);=0A+=09if=20(iocb=20=3D=3D=20NULL)=20{=0A+=09=09=
qla_printk(KERN_WARNING,=20ha,=0A+=09=09=20=20=20=20"Passthru=20request=20=
failed=20to=20get=20request=20packet\n");=0A+=09=09goto=20pt_error1;=0A+=09=
}=0A+=0A+=09req_sg_cnt=20=3D=20dma_map_sg(&ha->pdev->dev,=20=
service->sg_req,=0A+=09=20=20=20=20service->req_sg_cnt,=20=
DMA_TO_DEVICE);=0A+=09if=20(!req_sg_cnt)=0A+=09=09goto=20pt_error1;=0A+=09=
rsp_sg_cnt=20=3D=20dma_map_sg(&ha->pdev->dev,=20service->sg_rsp,=0A+=09=20=
=20=20=20service->rsp_sg_cnt,=20DMA_FROM_DEVICE);=0A+=09if=20=
(!rsp_sg_cnt)=0A+=09=09goto=20pt_error2;=0A+=0A+=09copy_size=20=3D=20=
sg_copy_to_buffer(service->sg_req,=20req_sg_cnt,=0A+=09=20=20=20=20=
els_pkt,=2020);=0A+=09if=20(!copy_size)=0A+=09=09goto=20pt_error3;=0A+=0A=
+=09/*=20Check=20for=20room=20in=20outstanding=20command=20list.=20*/=0A=
+=09handle=20=3D=20req->current_outstanding_cmd;=0A+=09for=20(index=20=3D=20=
1;=20index=20<=20MAX_OUTSTANDING_COMMANDS;=20index++)=20{=0A+=09=09=
handle++;=0A+=09=09if=20(handle=20=3D=3D=20MAX_OUTSTANDING_COMMANDS)=0A+=09=
=09=09handle=20=3D=201;=0A+=09=09if=20(!req->outstanding_cmds[handle])=0A=
+=09=09=09break;=0A+=09}=0A+=0A+=09req->current_outstanding_cmd=20=3D=20=
handle;=0A+=09req->outstanding_cmds[handle]=20=3D=20(srb_t=20*)=20sp;=0A=
+=0A+=09iocb->handle=20=3D=20handle;=0A+=0A+=09if=20=
(service->srv_request->request_type=20=3D=3D=20FC_FRAME_TYPE_ELS)=20{=0A=
+=09=09els_iocb=20=3D=20(struct=20els_entry_24xx=20*)iocb;=0A+=09=09=
els_iocb->entry_type=20=3D=20ELS_IOCB_TYPE;=0A+=09=09=
els_iocb->entry_count=20=3D=201;=0A+=09=09els_iocb->sys_define=20=3D=20=
0;=0A+=09=09els_iocb->entry_status=20=3D=200;=0A+=09=09=
els_iocb->nport_handle=20=3D=20cpu_to_le16(fcport->loop_id);=0A+=09=09=
els_iocb->tx_dsd_count=20=3D=20__constant_cpu_to_le16(1);=0A+=09=09=
els_iocb->vp_index=20=3D=20vha->vp_idx;=0A+=09=09els_iocb->sof_type=20=3D=20=
EST_SOFI3;=0A+=09=09els_iocb->rx_dsd_count=20=3D=20=
__constant_cpu_to_le16(1);=0A+=09=09els_iocb->opcode=20=3D=20els_pkt[0];=0A=
+=09=09els_iocb->port_id[0]=20=3D=20fcport->d_id.b.al_pa;=0A+=09=09=
els_iocb->port_id[1]=20=3D=20fcport->d_id.b.area;=0A+=09=09=
els_iocb->port_id[2]=20=3D=20fcport->d_id.b.domain;=0A+=09=09=
els_iocb->control_flags=20=3D=200;=0A+=09=09els_iocb->rx_byte_count=20=3D=20=
cpu_to_le32(service->rsp_size);=0A+=09=09els_iocb->tx_byte_count=20=3D=20=
cpu_to_le32(service->req_size);=0A+=09=09els_iocb->tx_address[0]=20=3D=20=
cpu_to_le32(LSD(sg_dma_address=0A+=09=09=20=20=20=20=
(&service->sg_req[0])));=0A+=09=09els_iocb->tx_address[1]=20=3D=20=
cpu_to_le32(MSD(sg_dma_address=0A+=09=09=20=20=20=20=
(&service->sg_req[0])));=0A+=0A+=09=09els_iocb->tx_len=20=3D=20=
cpu_to_le32(sg_dma_len=0A+=09=09=20=20=20=20(&service->sg_req[0]));=0A+=0A=
+=09=09els_iocb->rx_address[0]=20=3D=20cpu_to_le32(LSD(sg_dma_address=0A=
+=09=09=20=20=20=20(&service->sg_rsp[0])));=0A+=09=09=
els_iocb->rx_address[1]=20=3D=20cpu_to_le32(MSD(sg_dma_address=0A+=09=09=20=
=20=20=20(&service->sg_rsp[0])));=0A+=0A+=09=09els_iocb->rx_len=20=3D=20=
cpu_to_le32(sg_dma_len=0A+=09=09=20=20=20=20(&service->sg_rsp[0]));=0A+=09=
=0A+=09=09/*=20lld_pkt=20is=20only=20for=20ELS=20services=20in=20case=20=
of=20abort=20*/=0A+=09=09service->lld_pkt=20=3D=20(void=20*)=20els_iocb;=0A=
+=09}=20else=20{=0A+=09=09ct_iocb=20=3D=20(struct=20ct_entry_24xx=20=
*)iocb;=0A+=09=09ct_iocb->entry_type=20=3D=20CT_IOCB_TYPE;=0A+=09=09=
ct_iocb->entry_count=20=3D=201;=0A+=09=09ct_iocb->entry_status=20=3D=20=
0;=0A+=09=09ct_iocb->comp_status=20=3D=20__constant_cpu_to_le16(0);=0A+=09=
=09if=20(IS_FWI2_CAPABLE(ha))=0A+=09=09=09ct_iocb->nport_handle=20=3D=20=
cpu_to_le16(NPH_SNS);=0A+=09=09else=0A+=09=09=09ct_iocb->nport_handle=20=
=3D=0A+=09=09=09=20=20=20=20cpu_to_le16(SIMPLE_NAME_SERVER);=0A+=09=09=
ct_iocb->cmd_dsd_count=20=3D=0A+=09=09=20=20=20=20=
__constant_cpu_to_le16(req_sg_cnt);=0A+=09=09ct_iocb->vp_index=20=3D=20=
vha->vp_idx;=0A+=09=09ct_iocb->timeout=20=3D=200;=0A+=09=09=
ct_iocb->rsp_dsd_count=20=3D=0A+=09=09=20=20=20=20=
__constant_cpu_to_le16(rsp_sg_cnt);=0A+=09=09ct_iocb->rsp_byte_count=20=3D=
=0A+=09=09=20=20=20=20cpu_to_le32(service->rsp_size);=0A+=09=09=
ct_iocb->cmd_byte_count=20=3D=0A+=09=09=20=20=20=20=
cpu_to_le32(service->req_size);=0A+=09=09ct_iocb->dseg_0_address[0]=20=3D=20=
cpu_to_le32(LSD(sg_dma_address=0A+=09=09=20=20=20=20=
(&service->sg_req[0])));=0A+=09=09ct_iocb->dseg_0_address[1]=20=3D=20=
cpu_to_le32(MSD(sg_dma_address=0A+=09=09=20=20=20=20=
(&service->sg_req[0])));=0A+=0A+=09=09ct_iocb->dseg_0_len=20=3D=20=
cpu_to_le32(sg_dma_len=0A+=09=09=20=20=20=20(&service->sg_req[0]));=0A+=0A=
+=09=09rsp_sg_cnt=20=3D=20service->rsp_sg_cnt;=0A+=09=09avail_dsds=20=3D=20=
1;=0A+=09=09cur_dsd=20=3D=20(uint32_t=20*)ct_iocb->dseg_1_address;=0A+=09=
=09index=20=3D=200;=0A+=09=09for_each_sg(service->sg_rsp,=20sg,=20=
rsp_sg_cnt,=20index)=20{=0A+=09=09=09dma_addr_t=20=20=20=20=20=20=20=
sle_dma;=0A+=09=09=09cont_a64_entry_t=20*cont_pkt;=0A+=0A+=09=09=09/*=20=
Allocate=20additional=20continuation=20packets?=20*/=0A+=09=09=09if=20=
(avail_dsds=20=3D=3D=200)=20{=0A+=09=09=09=09/*=0A+=09=09=09=09=20*=20=
Five=20DSDs=20are=20available=20in=20the=20Cont.=0A+=09=09=09=09=20*=20=
Type=201=20IOCB.=0A+=09=09=09=09=20*/=0A+=09=09=09=09cont_pkt=20=3D=20=
qla2x00_prep_cont_type1_iocb(vha);=0A+=09=09=09=09cur_dsd=20=3D=0A+=09=09=
=09=09=20=20=20=20(uint32_t=20*)=20cont_pkt->dseg_0_address;=0A+=09=09=09=
=09avail_dsds=20=3D=205;=0A+=09=09=09}=0A+=0A+=09=09=09sle_dma=20=3D=20=
sg_dma_address(sg);=0A+=09=09=09*cur_dsd++=20=3D=20=
cpu_to_le32(LSD(sle_dma));=0A+=09=09=09*cur_dsd++=20=3D=20=
cpu_to_le32(MSD(sle_dma));=0A+=09=09=09*cur_dsd++=20=3D=20=
cpu_to_le32(sg_dma_len(sg));=0A+=09=09=09avail_dsds--;=0A+=09=09}=0A+=09=
}=0A+=0A+=09wmb();=0A+=09qla2x00_isp_cmd(vha);=0A+=0A+=09=
spin_unlock_irqrestore(&ha->hardware_lock,=20flags);=0A+=09return=200;=0A=
+pt_error3:=0A+=09dma_unmap_sg(&ha->pdev->dev,=20service->sg_rsp,=0A+=09=20=
=20=20=20service->rsp_sg_cnt,=20DMA_FROM_DEVICE);=0A+pt_error2:=0A+=09=
dma_unmap_sg(&ha->pdev->dev,=20service->sg_req,=0A+=09=20=20=20=20=
service->req_sg_cnt,=20DMA_TO_DEVICE);=0A+pt_error1:=0A+=09=
spin_unlock_irqrestore(&ha->hardware_lock,=20flags);=0A+=09=
mempool_free(sp,=20ha->srb_mempool);=0A+pt_error0:=0A+=09=
qla_printk(KERN_WARNING,=20ha,=20"Passthru=20ELS=20failed\n");=0A+=09=
service->srv_reply.status=20=3D=20FC_SERVICE_UNSUPPORTED;=0A+=0A+=09=
return=20-EINVAL;=0A+}=0A+=0A+static=20int=0A=
+qla2x00_abort_fc_service(struct=20fc_service=20*service)=0A+{=0A+=09=
unsigned=20long=20flags;=0A+=09struct=20fc_rport=20*rport=20=3D=20=
service->rport;=0A+=09struct=20Scsi_Host=20*host=20=3D=20=
rport_to_shost(rport);=0A+=09scsi_qla_host_t=20*vha=20=3D=20=
shost_priv(host);=0A+=09struct=20qla_hw_data=20*ha=20=3D=20vha->hw;=0A+=09=
scsi_qla_host_t=20*base_vha=20=3D=20pci_get_drvdata(ha->pdev);=0A+=09=
struct=20abort_entry_24xx=20*abort_iocb;=0A+=09struct=20els_entry_24xx=20=
*els_iocb=20=3D=20service->lld_pkt;=0A+=0A+=09printk("ELS/CT:=20DEBUG:=20=
%s=20is=20called...\n",=20__func__);=0A+=09if=20=
(service->srv_request->request_type=20!=3D=20FC_FRAME_TYPE_ELS)=20{=0A+=09=
=09printk(KERN_ERR=20"abort=20frame=20is=20not=20supported\n");=0A+=09=09=
return=20-EINVAL;=0A+=09}=0A+=0A+=09=
spin_lock_irqsave(&ha->hardware_lock,=20flags);=0A+=09abort_iocb=20=3D=20=
(struct=20abort_entry_24xx=20*)qla2x00_req_pkt(base_vha);=0A+=0A+=09=
abort_iocb->entry_type=20=3D=20ABORT_IOCB_TYPE;=0A+=09=
abort_iocb->entry_count=20=3D=201;=0A+=09abort_iocb->handle_count=20=3D=20=
0;=0A+=09abort_iocb->entry_status=20=3D=200;=0A+=09abort_iocb->options=20=
=3D=200;=0A+=09abort_iocb->handle_to_abort=20=3D=20els_iocb->handle;=0A+=09=
abort_iocb->port_id[0]=20=3D=20els_iocb->port_id[0];=0A+=09=
abort_iocb->port_id[1]=20=3D=20els_iocb->port_id[1];=0A+=09=
abort_iocb->port_id[2]=20=3D=20els_iocb->port_id[2];=0A+=09=
abort_iocb->vp_index=20=3D=20vha->vp_idx;=0A+=0A+=09wmb();=0A+=09=
qla2x00_isp_cmd(vha);=0A+=0A+=09=
spin_unlock_irqrestore(&ha->hardware_lock,=20flags);=0A+=0A+=09=
service->service_state_flag=20=3D=20FC_SERVICE_STATE_ABORTED;=0A+=0A+=09=
return=200;=0A+}=0A+=0A=20struct=20fc_function_template=20=
qla2xxx_transport_functions=20=3D=20{=0A=20=0A=20=09.show_host_node_name=20=
=3D=201,=0A@@=20-1300,6=20+1547,9=20@@=20struct=20fc_function_template=20=
qla2xxx_transport_functions=20=3D=20{=0A=20=09.vport_create=20=3D=20=
qla24xx_vport_create,=0A=20=09.vport_disable=20=3D=20=
qla24xx_vport_disable,=0A=20=09.vport_delete=20=3D=20=
qla24xx_vport_delete,=0A+=0A+=09.execute_fc_service=20=3D=20=
qla2x00_execute_fc_service,=0A+=09.abort_fc_service=20=3D=20=
qla2x00_abort_fc_service,=0A=20};=0A=20=0A=20struct=20=
fc_function_template=20qla2xxx_transport_vport_functions=20=3D=20{=0A@@=20=
-1340,6=20+1590,9=20@@=20struct=20fc_function_template=20=
qla2xxx_transport_vport_functions=20=3D=20{=0A=20=09.dev_loss_tmo_callbk=20=
=3D=20qla2x00_dev_loss_tmo_callbk,=0A=20=09.terminate_rport_io=20=3D=20=
qla2x00_terminate_rport_io,=0A=20=09.get_fc_host_stats=20=3D=20=
qla2x00_get_fc_host_stats,=0A+=0A+=09.execute_fc_service=20=3D=20=
qla2x00_execute_fc_service,=0A+=09.abort_fc_service=20=3D=20=
qla2x00_abort_fc_service,=0A=20};=0A=20=0A=20void=0Adiff=20--git=20=
a/drivers/scsi/qla2xxx/qla_def.h=20b/drivers/scsi/qla2xxx/qla_def.h=0A=
index=20edead28..4cf8b1b=20100644=0A---=20=
a/drivers/scsi/qla2xxx/qla_def.h=0A+++=20=
b/drivers/scsi/qla2xxx/qla_def.h=0A@@=20-93,6=20+93,10=20@@=0A=20#define=20=
LSD(x)=09((uint32_t)((uint64_t)(x)))=0A=20#define=20MSD(x)=09=
((uint32_t)((((uint64_t)(x))=20>>=2016)=20>>=2016))=0A=20=0A+/*=20ELS=20=
PT=20request=20buffer=20=3D=2032=20bytes=20*/=0A+#define=20=
EXT_ELS_PT_REQ_WWPN_VALID=090x1=0A+#define=20EXT_ELS_PT_REQ_WWNN_VALID=09=
0x2=0A+#define=20EXT_ELS_PT_REQ_PID_VALID=090x4=0A=20=0A=20/*=0A=20=20*=20=
I/O=20register=0A@@=20-213,6=20+217,7=20@@=20typedef=20struct=20srb=20{=0A=
=20#define=20SRB_FO_CANCEL=09=09BIT_9=09/*=20Command=20don't=20need=20to=20=
do=20failover=20*/=0A=20#define=20SRB_IOCTL=09=09BIT_10=09/*=20IOCTL=20=
command.=20*/=0A=20#define=20SRB_TAPE=09=09BIT_11=09/*=20FCP2=20(Tape)=20=
command.=20*/=0A+#define=20SRB_ELS_CT=09=09BIT_12=09/*=20Link/Generic=20=
Service=20request.=20*/=0A=20=0A=20/*=0A=20=20*=20ISP=20I/O=20Register=20=
Set=20structure=20definitions.=0Adiff=20--git=20=
a/drivers/scsi/qla2xxx/qla_fw.h=20b/drivers/scsi/qla2xxx/qla_fw.h=0A=
index=20d1d1420..05b6910=20100644=0A---=20=
a/drivers/scsi/qla2xxx/qla_fw.h=0A+++=20b/drivers/scsi/qla2xxx/qla_fw.h=0A=
@@=20-625,6=20+625,41=20@@=20struct=20els_entry_24xx=20{=0A=20=09=
uint32_t=20rx_len;=09=09/*=20Data=20segment=201=20length.=20*/=0A=20};=0A=
=20=0A+struct=20els_status_24xx=20{=0A+=09uint8_t=20entry_type;=09=09/*=20=
Entry=20type.=20*/=0A+=09uint8_t=20entry_count;=09=09/*=20Entry=20count.=20=
*/=0A+=09uint8_t=20sys_define;=09=09/*=20System=20Defined.=20*/=0A+=09=
uint8_t=20entry_status;=09=09/*=20Entry=20Status.=20*/=0A+=0A+=09=
uint32_t=20handle;=09=09/*=20System=20handle.=20*/=0A+=0A+=09uint16_t=20=
comp_status;=0A+=0A+=09uint16_t=20nport_handle;=09=09/*=20N_PORT=20=
handle.=20*/=0A+=0A+=09uint16_t=20tx_dsd_count;=0A+=0A+=09uint8_t=20=
vp_index;=0A+=09uint8_t=20sof_type;=0A+=0A+=09uint32_t=20=
rx_xchg_address;=09/*=20Receive=20exchange=20address.=20*/=0A+=09=
uint16_t=20rx_dsd_count;=0A+=0A+=09uint8_t=20opcode;=0A+=09uint8_t=20=
reserved_2;=0A+=0A+=09uint8_t=20port_id[3];=0A+=09uint8_t=20reserved_3;=0A=
+=0A+=09uint16_t=20reserved_4;=0A+=0A+=09uint16_t=20control_flags;=09=09=
/*=20Control=20flags.=20*/=0A+=0A+=09uint32_t=20total_byte_count;=0A+=09=
uint32_t=20err_subcode1;=0A+=09uint32_t=20err_subcode2;=0A+};=0A+=0A=20=
/*=0A=20=20*=20ISP=20queue=20-=20Mailbox=20Command=20entry=20structure=20=
definition.=0A=20=20*/=0Adiff=20--git=20a/drivers/scsi/qla2xxx/qla_gbl.h=20=
b/drivers/scsi/qla2xxx/qla_gbl.h=0Aindex=20c0cc686..7e71cdf=20100644=0A=
---=20a/drivers/scsi/qla2xxx/qla_gbl.h=0A+++=20=
b/drivers/scsi/qla2xxx/qla_gbl.h=0A@@=20-124,6=20+124,9=20@@=20extern=20=
int=20qla2x00_start_scsi(srb_t=20*sp);=0A=20extern=20int=20=
qla24xx_start_scsi(srb_t=20*sp);=0A=20int=20=
qla2x00_marker(scsi_qla_host_t=20*,=20uint16_t,=20uint16_t,=20uint8_t);=0A=
=20int=20__qla2x00_marker(scsi_qla_host_t=20*,=20uint16_t,=20uint16_t,=20=
uint8_t);=0A+extern=20request_t=20*=20qla2x00_req_pkt(scsi_qla_host_t=20=
*);=0A+extern=20void=20qla2x00_isp_cmd(scsi_qla_host_t=20*);=0A+extern=20=
cont_a64_entry_t=20*qla2x00_prep_cont_type1_iocb(scsi_qla_host_t=20*);=0A=
=20=0A=20/*=0A=20=20*=20Global=20Function=20Prototypes=20in=20qla_mbx.c=20=
source=20file.=0A@@=20-350,6=20+353,7=20@@=20extern=20int=20=
qla2x00_fdmi_register(scsi_qla_host_t=20*);=0A=20extern=20int=20=
qla2x00_gfpn_id(scsi_qla_host_t=20*,=20sw_info_t=20*);=0A=20extern=20int=20=
qla2x00_gpsc(scsi_qla_host_t=20*,=20sw_info_t=20*);=0A=20extern=20void=20=
qla2x00_get_sym_node_name(scsi_qla_host_t=20*,=20uint8_t=20*);=0A+extern=20=
int=20qla2x00_mgmt_svr_login(scsi_qla_host_t=20*);=0A=20=0A=20/*=0A=20=20=
*=20Global=20Function=20Prototypes=20in=20qla_attr.c=20source=20file.=0A=
diff=20--git=20a/drivers/scsi/qla2xxx/qla_gs.c=20=
b/drivers/scsi/qla2xxx/qla_gs.c=0Aindex=20db8de06..201ed93=20100644=0A=
---=20a/drivers/scsi/qla2xxx/qla_gs.c=0A+++=20=
b/drivers/scsi/qla2xxx/qla_gs.c=0A@@=20-1096,7=20+1096,7=20@@=20=
qla2x00_sns_rnn_id(scsi_qla_host_t=20*vha)=0A=20=20*=0A=20=20*=20Returns=20=
0=20on=20success.=0A=20=20*/=0A-static=20int=0A+int=0A=20=
qla2x00_mgmt_svr_login(scsi_qla_host_t=20*vha)=0A=20{=0A=20=09int=20ret;=0A=
diff=20--git=20a/drivers/scsi/qla2xxx/qla_init.c=20=
b/drivers/scsi/qla2xxx/qla_init.c=0Aindex=207bee87f..2a92f6b=20100644=0A=
---=20a/drivers/scsi/qla2xxx/qla_init.c=0A+++=20=
b/drivers/scsi/qla2xxx/qla_init.c=0A@@=20-2400,6=20+2400,17=20@@=20=
qla2x00_configure_fabric(scsi_qla_host_t=20*vha)=0A=20=09=09=09return=20=
(QLA_SUCCESS);=0A=20=09=09}=0A=20=0A+=09=09/*=20allocate=20fc_port_t=20=
structure=20for=20name/directory=20server=20*/=0A+=09=09fcptemp=20=3D=20=
qla2x00_alloc_fcport(vha,=20GFP_KERNEL);=0A+=09=09fcptemp->flags=20|=3D=20=
(FCF_FABRIC_DEVICE=20|=20FCF_LOGIN_NEEDED);=0A+=09=09fcptemp->loop_id=20=
=3D=20loop_id;=0A+=09=09fcptemp->d_id.b.domain=20=3D=200xff;=0A+=09=09=
fcptemp->d_id.b.area=20=3D=200xff;=0A+=09=09fcptemp->d_id.b.al_pa=20=3D=20=
0xfc;=0A+=09=09list_add_tail(&fcptemp->list,=20&vha->vp_fcports);=0A+=09=09=
atomic_set(&fcptemp->state,=20FCS_ONLINE);=0A+=09=09=
qla2x00_reg_remote_port(vha,=20fcptemp);=0A+=0A=20=09=09if=20=
(test_and_clear_bit(REGISTER_FC4_NEEDED,=20&vha->dpc_flags))=20{=0A=20=09=
=09=09if=20(qla2x00_rft_id(vha))=20{=0A=20=09=09=09=09/*=20EMPTY=20*/=0A=
diff=20--git=20a/drivers/scsi/qla2xxx/qla_iocb.c=20=
b/drivers/scsi/qla2xxx/qla_iocb.c=0Aindex=200c145c9..996bfe9=20100644=0A=
---=20a/drivers/scsi/qla2xxx/qla_iocb.c=0A+++=20=
b/drivers/scsi/qla2xxx/qla_iocb.c=0A@@=20-11,9=20+11,6=20@@=0A=20=0A=20=
#include=20<scsi/scsi_tcq.h>=0A=20=0A-static=20request_t=20=
*qla2x00_req_pkt(scsi_qla_host_t=20*);=0A-static=20void=20=
qla2x00_isp_cmd(scsi_qla_host_t=20*);=0A-=0A=20/**=0A=20=20*=20=
qla2x00_get_cmd_direction()=20-=20Determine=20control_flag=20data=20=
direction.=0A=20=20*=20@cmd:=20SCSI=20command=0A@@=20-119,7=20+116,7=20=
@@=20qla2x00_prep_cont_type0_iocb(scsi_qla_host_t=20*vha)=0A=20=20*=0A=20=
=20*=20Returns=20a=20pointer=20to=20the=20continuation=20type=201=20IOCB=20=
packet.=0A=20=20*/=0A-static=20inline=20cont_a64_entry_t=20*=0A+inline=20=
cont_a64_entry_t=20*=0A=20qla2x00_prep_cont_type1_iocb(scsi_qla_host_t=20=
*vha)=0A=20{=0A=20=09cont_a64_entry_t=20*cont_pkt;=0A@@=20-481,7=20=
+478,7=20@@=20qla2x00_marker(scsi_qla_host_t=20*vha,=20uint16_t=20=
loop_id,=20uint16_t=20lun,=0A=20=20*=0A=20=20*=20Returns=20NULL=20if=20=
function=20failed,=20else,=20a=20pointer=20to=20the=20request=20packet.=0A=
=20=20*/=0A-static=20request_t=20*=0A+request_t=20*=0A=20=
qla2x00_req_pkt(scsi_qla_host_t=20*vha)=0A=20{=0A=20=09struct=20=
qla_hw_data=20*ha=20=3D=20vha->hw;=0A@@=20-552,7=20+549,7=20@@=20=
qla2x00_req_pkt(scsi_qla_host_t=20*vha)=0A=20=20*=0A=20=20*=20Note:=20=
The=20caller=20must=20hold=20the=20hardware=20lock=20before=20calling=20=
this=20routine.=0A=20=20*/=0A-static=20void=0A+void=0A=20=
qla2x00_isp_cmd(scsi_qla_host_t=20*vha)=0A=20{=0A=20=09struct=20=
qla_hw_data=20*ha=20=3D=20vha->hw;=0Adiff=20--git=20=
a/drivers/scsi/qla2xxx/qla_isr.c=20b/drivers/scsi/qla2xxx/qla_isr.c=0A=
index=2089d3271..cfbb93b=20100644=0A---=20=
a/drivers/scsi/qla2xxx/qla_isr.c=0A+++=20=
b/drivers/scsi/qla2xxx/qla_isr.c=0A@@=20-1431,9=20+1431,13=20@@=20void=0A=
=20qla24xx_process_response_queue(struct=20scsi_qla_host=20*vha)=0A=20{=0A=
=20=09struct=20qla_hw_data=20*ha=20=3D=20vha->hw;=0A+=09struct=20req_que=20=
*req=20=3D=20ha->req;=0A=20=09struct=20device_reg_24xx=20__iomem=20*reg=20=
=3D=20&ha->iobase->isp24;=0A=20=09struct=20sts_entry_24xx=20*pkt;=0A=20=09=
struct=20rsp_que=20*rsp=20=3D=20ha->rsp;=0A+=09struct=20els_status_24xx=20=
*els_status;=0A+=09struct=20fc_service=20*service;=0A+=09srb_t=20*sp;=0A=20=
=0A=20=09if=20(!vha->flags.online)=0A=20=09=09return;=0A@@=20-1466,10=20=
+1470,74=20@@=20qla24xx_process_response_queue(struct=20scsi_qla_host=20=
*vha)=0A=20=09=09case=20STATUS_CONT_TYPE:=0A=20=09=09=09=
qla2x00_status_cont_entry(vha,=20(sts_cont_entry_t=20*)pkt);=0A=20=09=09=09=
break;=0A+=20=09=09case=20MS_IOCB_TYPE:=0A+=09=09case=20ELS_IOCB_TYPE:=0A=
+=09=09=09if=20(pkt->handle=20<=20MAX_OUTSTANDING_COMMANDS)=20{=0A+=09=09=
=09=09sp=20=3D=20req->outstanding_cmds[pkt->handle];=0A+=09=09=09=09=
service=20=3D=20(struct=20fc_service=20*)=20sp->cmd;=0A+=09=09=09=09=
req->outstanding_cmds[pkt->handle]=20=3D=20NULL;=0A+=09=09=09}=20else=20=
{=0A+=09=09=09=09service=20=3D=20NULL;=0A+=09=09=09=09break;=0A+=09=09=09=
}=0A+=0A+=09=09=09service->service_state_flag=20=3D=20=
FC_SERVICE_STATE_DONE;=0A+=09=09=09service->srv_reply.status=20=3D=20=
FC_SERVICE_COMPLETE;=0A+=09=09=09service->srv_reply.error_code=20=3D=20=
pkt->comp_status;=0A+=0A+=09=09=09if=20(pkt->comp_status)=20{=0A+=09=09=09=
=09printk(KERN_WARNING=20"scsi(%ld):=20ELS/CT:=20"=0A+=09=09=09=09=20=20=20=
=20"comp_status=20=3D=20%x\n",=20vha->host_no,=0A+=09=09=09=09=20=20=20=20=
pkt->comp_status);=0A+=09=09=09=09els_status=20=3D=20(struct=20=
els_status_24xx=20*)pkt;=0A+=09=09=09=09service->srv_reply.residual=20=3D=20=
0;=0A+=09=09=09=09if=20(pkt->comp_status=20=3D=3D=20CS_DATA_UNDERRUN)=0A=
+=09=09=09=09=09service->srv_reply.residual=20=3D=0A+=09=09=09=09=09=20=20=
=20=20els_status->total_byte_count;=0A+=09=09=09=09else=20if=20=
(pkt->comp_status=20=3D=3D=20CS_ABORTED)=20{=0A+=09=09=09=09=09=
service->service_state_flag=20=3D=0A+=09=09=09=09=09=20=20=20=20=
FC_SERVICE_STATE_ABORTED;=0A+=09=09=09=09=09service->srv_reply.status=20=
=3D=0A+=09=09=09=09=09=20=20=20=20FC_SERVICE_ABORT;=0A+=09=09=09=09}=20=
else=0A+=09=09=09=09service->srv_reply.status=20=3D=20FC_SERVICE_ERROR;=0A=
+=09=09=09}=0A+=0A+=09=09=09dma_unmap_sg(&ha->pdev->dev,=20=
service->sg_req,=0A+=09=09=09=20=20=20=20service->req_sg_cnt,=20=
DMA_TO_DEVICE);=0A+=09=09=09dma_unmap_sg(&ha->pdev->dev,=20=
service->sg_rsp,=0A+=09=09=09=20=20=20=20service->rsp_sg_cnt,=20=
DMA_FROM_DEVICE);=0A+=0A+=09=09=09mempool_free(sp,=20ha->srb_mempool);=0A=
+=09=09=09service->service_done(service);=0A+=20=09=09=09break;=0A=20=09=09=
case=20VP_RPT_ID_IOCB_TYPE:=0A=20=09=09=09=
qla24xx_report_id_acquisition(vha,=0A=20=09=09=09=20=20=20=20(struct=20=
vp_rpt_id_entry_24xx=20*)pkt);=0A=20=09=09=09break;=0A+=09=09case=20=
ABORT_IOCB_TYPE:=0A+=09=09=09if=20(pkt->comp_status)=20{=0A+=09=09=09=09=
if=20(pkt->handle=20<=20MAX_OUTSTANDING_COMMANDS)=20{=0A+=09=09=09=09=09=
sp=20=3D=20req->outstanding_cmds[pkt->handle];=0A+=09=09=09=09=09=
req->outstanding_cmds[pkt->handle]=20=3D=0A+=09=09=09=09=09=20=20=20=20=
NULL;=0A+=09=09=09=09=09if=20(sp->flags=20&=20SRB_ELS_CT)=20{=0A+=09=09=09=
=09=09=09service=20=3D=20(struct=20fc_service=20*)=0A+=09=09=09=09=09=09=20=
=20=20=20sp->cmd;=0A+=09=09=09=09=09=09qla_printk(KERN_ERR,=20ha,=0A+=09=09=
=09=09=09=09=20=20=20=20"failed=20to=20abort"=0A+=09=09=09=09=09=09=20=20=
=20=20"=20FC=20service=20%p\n",=0A+=09=09=09=09=09=09=20=20=20=20=
service);=0A+=0A+=09=09=09=09=09}=20else=0A+=09=09=09=09=09=09=
qla_printk(KERN_ERR,=20ha,=0A+=09=09=09=09=09=09=20=20=20=20"failed=20to=20=
abort"=0A+=09=09=09=09=09=09=20=20=20=20"=20SCSI=20CMD[0]=20=3D=20=
%2x\n",=0A+=09=09=09=09=09=09=20=20=20=20sp->cmd->cmnd[0]);=0A+=09=09=09=09=
}=0A+=09=09=09}=0A+=09=09=09=0A+=09=09=09break;=0A=20=09=09default:=0A=20=
=09=09=09/*=20Type=20Not=20Supported.=20*/=0A=20=09=09=09=
DEBUG4(printk(KERN_WARNING=0A--=20=0A1.6.0.2=0A=0A=

--Apple-Mail-56-199468201--
