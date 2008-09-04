From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [RFC 2/2] qla2xxx: pass through support through bsg interface
Date: Wed, 3 Sep 2008 19:55:40 -0700
Message-ID: <E2859F0D-AFB4-473C-9599-8F963ED365BD@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: multipart/mixed; boundary=Apple-Mail-6--475911475
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:39148 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYIDCzn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2008 22:55:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Robert W Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>


--Apple-Mail-6--475911475
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/ 
qla_attr.c
index 0ddfe71..5ae948e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1233,6 +1233,270 @@ qla24xx_vport_disable(struct fc_vport  
*fc_vport, bool disable)
  	return 0;
  }

+static int
+qla2x00_execute_fc_els_service(struct fc_service *service)
+{
+	int count = service->req_size;
+	struct fc_els_frame *frame_backup;
+	struct fc_els_frame *frame = service->els_frame;
+	struct fc_rport *rport = service->rport;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *ha = shost_priv(host);
+	struct els_entry_24xx *els_iocb;
+	unsigned long flags;
+	fc_port_t *fcport = *(fc_port_t **) rport->dd_data;
+	dma_addr_t req_dma;
+	dma_addr_t resp_dma;
+
+	count -= sizeof(frame->fc_hdr);
+
+	if (count < sizeof(frame->els_hdr) || ha->pass_thru_cmd_in_process ||
+	    ha->pass_thru_cmd_result)
+		goto els_error0;
+
+	if (rport->port_state != FC_PORTSTATE_ONLINE || !fcport)
+		goto els_error0;
+
+	memset(service->response, 0, service->resp_size);
+	frame_backup = kzalloc(service->req_size, GFP_KERNEL);
+	if (!frame_backup)
+		goto els_error0;
+
+	memcpy(frame_backup, frame, service->req_size);
+	memset(frame, 0, service->req_size);
+	memcpy(frame, &frame_backup->els_hdr, count);
+
+	req_dma = dma_map_single(&ha->pdev->dev, (void *) service->els_frame,
+	    service->req_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, req_dma))
+		goto els_error0;
+	resp_dma = dma_map_single(&ha->pdev->dev, (void *) service->response,
+	    service->resp_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, resp_dma))
+		goto els_error1;
+
+	ha->pass_thru_cmd_in_process = 1;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	els_iocb = (struct els_entry_24xx *)qla2x00_req_pkt(ha);
+
+	if (els_iocb == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Passthru ELS request failed to get request packet\n");
+		goto els_error3;
+	}
+
+	els_iocb->entry_type = ELS_IOCB_TYPE;
+	els_iocb->entry_count = 1;
+	els_iocb->sys_define = 0;
+	els_iocb->entry_status = 0;
+	els_iocb->handle = fcport->d_id.b24;
+	els_iocb->nport_handle = cpu_to_le16(fcport->loop_id);
+	els_iocb->tx_dsd_count = __constant_cpu_to_le16(1);
+	els_iocb->vp_index = ha->vp_idx;
+	els_iocb->sof_type = EST_SOFI3;
+	els_iocb->rx_dsd_count = __constant_cpu_to_le16(1);
+	els_iocb->opcode = frame_backup->els_hdr.els_cmd;
+	els_iocb->port_id[0] = fcport->d_id.b.al_pa;
+	els_iocb->port_id[1] = fcport->d_id.b.area;
+	els_iocb->port_id[2] = fcport->d_id.b.domain;
+	els_iocb->control_flags = 0;
+	els_iocb->rx_byte_count = cpu_to_le32(service->resp_size);
+	els_iocb->tx_byte_count = cpu_to_le32(count);
+	els_iocb->tx_address[0] = cpu_to_le32(LSD(req_dma));
+	els_iocb->tx_address[1] = cpu_to_le32(MSD(req_dma));
+	els_iocb->tx_len = els_iocb->tx_byte_count;
+	els_iocb->rx_address[0] = cpu_to_le32(LSD(resp_dma));
+	els_iocb->rx_address[1] = cpu_to_le32(MSD(resp_dma));
+	els_iocb->rx_len = els_iocb->rx_byte_count;
+
+	service->lld_pkt = (void *) els_iocb;
+
+	ha->active_els_service = service;
+
+	wmb();
+	qla2x00_isp_cmd(ha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (!wait_for_completion_timeout(&ha->pass_thru_intr_comp, 10 * HZ))
+		goto els_error2;
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+
+	memcpy(frame, frame_backup, service->req_size);
+
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+
+	service->lld_pkt = (void *) 0;
+	ha->active_els_service = (struct fc_service *)0;
+	service->service_done(service);
+	return service->status.residual;
+
+els_error3:
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+els_error2:
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+els_error1:
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+els_error0:
+	qla_printk(KERN_WARNING, ha, "Passthru ELS failed\n");
+
+	return -EINVAL;
+}
+
+static int
+qla2x00_execute_fc_ct_service(struct fc_service *service)
+{
+	int count = service->req_size;
+	struct fc_ct_frame *frame_backup;
+	struct fc_ct_frame *frame = service->ct_frame;
+	struct fc_rport *rport = service->rport;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *ha = shost_priv(host);
+	struct ct_entry_24xx *ct_iocb;
+	unsigned long flags;
+	dma_addr_t req_dma;
+	dma_addr_t resp_dma;
+
+	count -= sizeof(frame->fc_hdr);
+
+	if (count < sizeof(frame->ct_hdr) ||
+	    (ha->pass_thru_cmd_in_process || ha->pass_thru_cmd_result))
+		goto ct_error0;
+
+	if (qla2x00_mgmt_svr_login(ha))
+		goto ct_error0;
+
+	memset(service->response, 0, service->resp_size);
+	frame_backup = kzalloc(service->req_size, GFP_KERNEL);
+	if (!frame_backup)
+		goto ct_error0;
+
+	memcpy(frame_backup, frame, service->req_size);
+	memset(frame, 0, service->req_size);
+	memcpy(frame, &frame_backup->ct_hdr, count);
+	req_dma = dma_map_single(&ha->pdev->dev, (void *) service->els_frame,
+	    service->req_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, req_dma))
+		goto ct_error0;
+	resp_dma = dma_map_single(&ha->pdev->dev, (void *) service->response,
+	    service->resp_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, resp_dma))
+		goto ct_error1;
+
+	ha->pass_thru_cmd_in_process = 1;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	ct_iocb = (struct ct_entry_24xx *)qla2x00_req_pkt(ha);
+	if (ct_iocb == NULL)
+		goto ct_error3;
+
+	ct_iocb->entry_type = CT_IOCB_TYPE;
+	ct_iocb->entry_count = 1;
+	ct_iocb->entry_status = 0;
+	ct_iocb->comp_status = __constant_cpu_to_le16(0);
+	if (IS_FWI2_CAPABLE(ha))
+		ct_iocb->nport_handle = cpu_to_le16(NPH_SNS);
+	else
+		ct_iocb->nport_handle = cpu_to_le16(SIMPLE_NAME_SERVER);
+	ct_iocb->cmd_dsd_count = __constant_cpu_to_le16(1);
+	ct_iocb->vp_index = ha->vp_idx;
+	ct_iocb->timeout = __constant_cpu_to_le16(20);  /* R_A_TOV * 2 */
+	ct_iocb->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_iocb->rsp_byte_count = cpu_to_le32(service->resp_size);
+	ct_iocb->cmd_byte_count = cpu_to_le32(count);
+	ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(req_dma));
+	ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(req_dma));
+	ct_iocb->dseg_0_len = ct_iocb->cmd_byte_count;
+	ct_iocb->dseg_1_address[0] = cpu_to_le32(LSD(resp_dma));
+	ct_iocb->dseg_1_address[1] = cpu_to_le32(MSD(resp_dma));
+	ct_iocb->dseg_1_len = ct_iocb->rsp_byte_count;
+
+	ha->active_ct_service = service;
+
+	wmb();
+	qla2x00_isp_cmd(ha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (!wait_for_completion_timeout(&ha->pass_thru_intr_comp, 20 * HZ))
+		goto ct_error2;
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+
+	memcpy(frame, frame_backup, service->req_size);
+
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+
+	ha->active_ct_service = (struct fc_service *) 0;
+
+	service->service_done(service);
+	return service->status.residual;
+
+ct_error3:
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+ct_error2:
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+ct_error1:
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+ct_error0:
+	qla_printk(KERN_WARNING, ha, "Passthru CT failed\n");
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
+	scsi_qla_host_t *ha = shost_priv(host);
+	struct fc_frame_header *frame = (struct fc_frame_header *)
+		service->els_frame;
+	struct abort_entry_24xx *abort_iocb;
+	struct els_entry_24xx *els_iocb = service->lld_pkt;
+
+	if (frame->fh_type != FC_FRAME_TYPE_ELS) {
+		printk(KERN_ERR "abort frame is not supported\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	abort_iocb = (struct abort_entry_24xx *)qla2x00_req_pkt(ha);
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
+	abort_iocb->vp_index = ha->vp_idx;
+
+	wmb();
+	qla2x00_isp_cmd(ha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return 0;
+}
+
  struct fc_function_template qla2xxx_transport_functions = {

  	.show_host_node_name = 1,
@@ -1276,6 +1540,10 @@ struct fc_function_template  
qla2xxx_transport_functions = {
  	.vport_create = qla24xx_vport_create,
  	.vport_disable = qla24xx_vport_disable,
  	.vport_delete = qla24xx_vport_delete,
+
+	.execute_fc_els_service = qla2x00_execute_fc_els_service,
+	.execute_fc_ct_service = qla2x00_execute_fc_ct_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
  };

  struct fc_function_template qla2xxx_transport_vport_functions = {
@@ -1316,6 +1584,10 @@ struct fc_function_template  
qla2xxx_transport_vport_functions = {
  	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
  	.terminate_rport_io = qla2x00_terminate_rport_io,
  	.get_fc_host_stats = qla2x00_get_fc_host_stats,
+
+	.execute_fc_els_service = qla2x00_execute_fc_els_service,
+	.execute_fc_ct_service = qla2x00_execute_fc_ct_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
  };

  void
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/ 
qla_def.h
index ab802e9..957b077 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -95,6 +95,11 @@
  #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))


+/* ELS PT request buffer = 32 bytes */
+#define EXT_ELS_PT_REQ_WWPN_VALID	0x1
+#define EXT_ELS_PT_REQ_WWNN_VALID	0x2
+#define EXT_ELS_PT_REQ_PID_VALID	0x4
+
  /*
   * I/O register
  */
@@ -2426,6 +2431,8 @@ typedef struct scsi_qla_host {
  	/* SNS command interfaces for 2200. */
  	struct sns_cmd_pkt	*sns_cmd;
  	dma_addr_t		sns_cmd_dma;
+	char			*pass_thru;
+	dma_addr_t		pass_thru_dma;

  #define SFP_DEV_SIZE	256
  #define SFP_BLOCK_SIZE	64
@@ -2467,6 +2474,7 @@ typedef struct scsi_qla_host {
  	struct mutex vport_lock;	/* Virtual port synchronization */
  	struct completion mbx_cmd_comp;	/* Serialize mbx access */
  	struct completion mbx_intr_comp;  /* Used for completion  
notification */
+	struct completion pass_thru_intr_comp;

  	uint32_t	mbx_flags;
  #define  MBX_IN_PROGRESS	BIT_0
@@ -2611,6 +2619,12 @@ typedef struct scsi_qla_host {

  	struct qla_chip_state_84xx *cs84xx;
  	struct qla_statistics qla_stats;
+
+	/* pass through support */
+	int		pass_thru_cmd_result;
+	int		pass_thru_cmd_in_process;
+	struct fc_service *active_els_service;
+	struct fc_service *active_ct_service;
  } scsi_qla_host_t;


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
index 753dbe6..d0b6ac9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -121,6 +121,8 @@ extern int qla2x00_start_scsi(srb_t *sp);
  extern int qla24xx_start_scsi(srb_t *sp);
  int qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
  int __qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
+extern request_t * qla2x00_req_pkt(scsi_qla_host_t *);
+extern void qla2x00_isp_cmd(scsi_qla_host_t *ha);

  /*
   * Global Function Prototypes in qla_mbx.c source file.
@@ -347,6 +349,7 @@ extern int qla2x00_fdmi_register(scsi_qla_host_t *);
  extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
  extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
  extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *);
+extern int qla2x00_mgmt_svr_login(scsi_qla_host_t *);

  /*
   * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/ 
qla_gs.c
index c2a4bfb..ceef231 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1093,7 +1093,7 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
   *
   * Returns 0 on success.
   */
-static int
+int
  qla2x00_mgmt_svr_login(scsi_qla_host_t *ha)
  {
  	int ret;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/ 
qla_init.c
index 20847fb..be06132 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2392,6 +2392,18 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
  			return (QLA_SUCCESS);
  		}

+		/* allocate fc_port_t structure for name/directory server */
+		fcptemp = qla2x00_alloc_fcport(ha, GFP_KERNEL);
+		fcptemp->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
+		fcptemp->loop_id = loop_id;
+		fcptemp->d_id.b.domain = 0xff;
+		fcptemp->d_id.b.area = 0xff;
+		fcptemp->d_id.b.al_pa = 0xfc;
+		list_add_tail(&fcptemp->list, &pha->fcports);
+		atomic_set(&fcptemp->state, FCS_ONLINE);
+		qla2x00_reg_remote_port(ha, fcptemp);
+
+
  		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags)) {
  			if (qla2x00_rft_id(ha)) {
  				/* EMPTY */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/ 
qla_iocb.c
index 9778f0b..9e7f636 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,8 +11,6 @@

  #include <scsi/scsi_tcq.h>

-static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
-static void qla2x00_isp_cmd(scsi_qla_host_t *ha);

  /**
   * qla2x00_get_cmd_direction() - Determine control_flag data  
direction.
@@ -476,7 +474,7 @@ qla2x00_marker(scsi_qla_host_t *ha, uint16_t  
loop_id, uint16_t lun,
   *
   * Returns NULL if function failed, else, a pointer to the request  
packet.
   */
-static request_t *
+request_t *
  qla2x00_req_pkt(scsi_qla_host_t *ha)
  {
  	device_reg_t __iomem *reg = ha->iobase;
@@ -546,7 +544,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
   *
   * Note: The caller must hold the hardware lock before calling this  
routine.
   */
-static void
+void
  qla2x00_isp_cmd(scsi_qla_host_t *ha)
  {
  	device_reg_t __iomem *reg = ha->iobase;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ 
qla_isr.c
index 45a3b93..749e3ed 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1398,6 +1398,9 @@ qla24xx_process_response_queue(struct  
scsi_qla_host *ha)
  {
  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
  	struct sts_entry_24xx *pkt;
+	struct els_status_24xx *els_status;
+	struct abort_entry_24xx *abort_iocb;
+	struct fc_service *service;

  	if (!ha->flags.online)
  		return;
@@ -1430,10 +1433,47 @@ qla24xx_process_response_queue(struct  
scsi_qla_host *ha)
  		case STATUS_CONT_TYPE:
  			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
  			break;
+ 		case MS_IOCB_TYPE:
+		case ELS_IOCB_TYPE:
+			els_status = (struct els_status_24xx *)pkt;
+
+			if (pkt->entry_type == MS_IOCB_TYPE)
+				service = ha->active_ct_service;
+			else
+				service = ha->active_els_service;
+
+			service->status.resp = FC_SERVICE_COMPLETE;
+			service->status.error = els_status->comp_status;
+
+			if (els_status->comp_status) {
+				if (els_status->comp_status == CS_DATA_UNDERRUN)
+					service->status.residual =
+					    els_status->total_byte_count;
+				else
+					service->status.residual = 0;
+				service->status.resp = FC_SERVICE_ERROR;
+			}
+
+			if (ha->pass_thru_cmd_result)
+				qla_printk(KERN_INFO, ha,
+				    "Passthru cmd result on.\n");
+			if (!ha->pass_thru_cmd_in_process)
+				qla_printk(KERN_INFO, ha,
+				    "Passthru in process off.\n");
+
+			ha->pass_thru_cmd_result = 1;
+			complete(&ha->pass_thru_intr_comp);
+ 			break;
  		case VP_RPT_ID_IOCB_TYPE:
  			qla24xx_report_id_acquisition(ha,
  			    (struct vp_rpt_id_entry_24xx *)pkt);
  			break;
+		case ABORT_IOCB_TYPE:
+			abort_iocb = (struct abort_entry_24xx *)pkt;
+			if (abort_iocb->nport_handle)
+				qla_printk(KERN_ERR, ha,
+				    "failed to abort ELS service\n");
+			break;
  		default:
  			/* Type Not Supported. */
  			DEBUG4(printk(KERN_WARNING
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/ 
qla_os.c
index 62fe267..e7586d9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1669,6 +1669,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const  
struct pci_device_id *id)
  	init_completion(&ha->mbx_cmd_comp);
  	complete(&ha->mbx_cmd_comp);
  	init_completion(&ha->mbx_intr_comp);
+	init_completion(&ha->pass_thru_intr_comp);
+

  	INIT_LIST_HEAD(&ha->list);
  	INIT_LIST_HEAD(&ha->fcports);
@@ -2017,6 +2019,8 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
  		    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
  		if (!ha->ct_sns)
  			goto fail_free_ms_iocb;
+		ha->pass_thru = dma_alloc_coherent(&ha->pdev->dev,
+		    PAGE_SIZE, &ha->pass_thru_dma, GFP_KERNEL);
  	}

  	return 0;
---

--Apple-Mail-6--475911475
Content-Disposition: attachment;
	filename=bidi-support-qla2xxx.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="bidi-support-qla2xxx.patch"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0ddfe71..5ae948e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1233,6 +1233,270 @@ qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
+static int
+qla2x00_execute_fc_els_service(struct fc_service *service)
+{
+	int count = service->req_size;
+	struct fc_els_frame *frame_backup;
+	struct fc_els_frame *frame = service->els_frame;
+	struct fc_rport *rport = service->rport;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *ha = shost_priv(host);
+	struct els_entry_24xx *els_iocb;
+	unsigned long flags;
+	fc_port_t *fcport = *(fc_port_t **) rport->dd_data;
+	dma_addr_t req_dma;
+	dma_addr_t resp_dma;
+
+	count -= sizeof(frame->fc_hdr);
+
+	if (count < sizeof(frame->els_hdr) || ha->pass_thru_cmd_in_process ||
+	    ha->pass_thru_cmd_result)
+		goto els_error0;
+
+	if (rport->port_state != FC_PORTSTATE_ONLINE || !fcport)
+		goto els_error0;
+
+	memset(service->response, 0, service->resp_size);
+	frame_backup = kzalloc(service->req_size, GFP_KERNEL);
+	if (!frame_backup)
+		goto els_error0;
+
+	memcpy(frame_backup, frame, service->req_size);
+	memset(frame, 0, service->req_size);
+	memcpy(frame, &frame_backup->els_hdr, count);
+
+	req_dma = dma_map_single(&ha->pdev->dev, (void *) service->els_frame,
+	    service->req_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, req_dma))
+		goto els_error0;
+	resp_dma = dma_map_single(&ha->pdev->dev, (void *) service->response,
+	    service->resp_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, resp_dma))
+		goto els_error1;
+
+	ha->pass_thru_cmd_in_process = 1;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	els_iocb = (struct els_entry_24xx *)qla2x00_req_pkt(ha);
+
+	if (els_iocb == NULL) {
+		qla_printk(KERN_WARNING, ha,
+		    "Passthru ELS request failed to get request packet\n");
+		goto els_error3;
+	}
+
+	els_iocb->entry_type = ELS_IOCB_TYPE;
+	els_iocb->entry_count = 1;
+	els_iocb->sys_define = 0;
+	els_iocb->entry_status = 0;
+	els_iocb->handle = fcport->d_id.b24;
+	els_iocb->nport_handle = cpu_to_le16(fcport->loop_id);
+	els_iocb->tx_dsd_count = __constant_cpu_to_le16(1);
+	els_iocb->vp_index = ha->vp_idx;
+	els_iocb->sof_type = EST_SOFI3;
+	els_iocb->rx_dsd_count = __constant_cpu_to_le16(1);
+	els_iocb->opcode = frame_backup->els_hdr.els_cmd;
+	els_iocb->port_id[0] = fcport->d_id.b.al_pa;
+	els_iocb->port_id[1] = fcport->d_id.b.area;
+	els_iocb->port_id[2] = fcport->d_id.b.domain;
+	els_iocb->control_flags = 0;
+	els_iocb->rx_byte_count = cpu_to_le32(service->resp_size);
+	els_iocb->tx_byte_count = cpu_to_le32(count);
+	els_iocb->tx_address[0] = cpu_to_le32(LSD(req_dma));
+	els_iocb->tx_address[1] = cpu_to_le32(MSD(req_dma));
+	els_iocb->tx_len = els_iocb->tx_byte_count;
+	els_iocb->rx_address[0] = cpu_to_le32(LSD(resp_dma));
+	els_iocb->rx_address[1] = cpu_to_le32(MSD(resp_dma));
+	els_iocb->rx_len = els_iocb->rx_byte_count;
+
+	service->lld_pkt = (void *) els_iocb;
+
+	ha->active_els_service = service;
+
+	wmb();
+	qla2x00_isp_cmd(ha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (!wait_for_completion_timeout(&ha->pass_thru_intr_comp, 10 * HZ))
+		goto els_error2;
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+
+	memcpy(frame, frame_backup, service->req_size);
+
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+
+	service->lld_pkt = (void *) 0;
+	ha->active_els_service = (struct fc_service *)0;
+	service->service_done(service);
+	return service->status.residual;
+
+els_error3:
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+els_error2:
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+els_error1:
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+els_error0:
+	qla_printk(KERN_WARNING, ha, "Passthru ELS failed\n");
+
+	return -EINVAL;
+}
+
+static int
+qla2x00_execute_fc_ct_service(struct fc_service *service)
+{
+	int count = service->req_size;
+	struct fc_ct_frame *frame_backup;
+	struct fc_ct_frame *frame = service->ct_frame;
+	struct fc_rport *rport = service->rport;
+	struct Scsi_Host *host = rport_to_shost(rport);
+	scsi_qla_host_t *ha = shost_priv(host);
+	struct ct_entry_24xx *ct_iocb;
+	unsigned long flags;
+	dma_addr_t req_dma;
+	dma_addr_t resp_dma;
+
+	count -= sizeof(frame->fc_hdr);
+
+	if (count < sizeof(frame->ct_hdr) ||
+	    (ha->pass_thru_cmd_in_process || ha->pass_thru_cmd_result))
+		goto ct_error0;
+
+	if (qla2x00_mgmt_svr_login(ha))
+		goto ct_error0;
+
+	memset(service->response, 0, service->resp_size);
+	frame_backup = kzalloc(service->req_size, GFP_KERNEL);
+	if (!frame_backup)
+		goto ct_error0;
+
+	memcpy(frame_backup, frame, service->req_size);
+	memset(frame, 0, service->req_size);
+	memcpy(frame, &frame_backup->ct_hdr, count);
+	req_dma = dma_map_single(&ha->pdev->dev, (void *) service->els_frame,
+	    service->req_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, req_dma))
+		goto ct_error0;
+	resp_dma = dma_map_single(&ha->pdev->dev, (void *) service->response,
+	    service->resp_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ha->pdev->dev, resp_dma))
+		goto ct_error1;
+
+	ha->pass_thru_cmd_in_process = 1;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	ct_iocb = (struct ct_entry_24xx *)qla2x00_req_pkt(ha);
+	if (ct_iocb == NULL)
+		goto ct_error3;
+
+	ct_iocb->entry_type = CT_IOCB_TYPE;
+	ct_iocb->entry_count = 1;
+	ct_iocb->entry_status = 0;
+	ct_iocb->comp_status = __constant_cpu_to_le16(0);
+	if (IS_FWI2_CAPABLE(ha))
+		ct_iocb->nport_handle = cpu_to_le16(NPH_SNS);
+	else
+		ct_iocb->nport_handle = cpu_to_le16(SIMPLE_NAME_SERVER);
+	ct_iocb->cmd_dsd_count = __constant_cpu_to_le16(1);
+	ct_iocb->vp_index = ha->vp_idx;
+	ct_iocb->timeout = __constant_cpu_to_le16(20);  /* R_A_TOV * 2 */
+	ct_iocb->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_iocb->rsp_byte_count = cpu_to_le32(service->resp_size);
+	ct_iocb->cmd_byte_count = cpu_to_le32(count);
+	ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(req_dma));
+	ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(req_dma));
+	ct_iocb->dseg_0_len = ct_iocb->cmd_byte_count;
+	ct_iocb->dseg_1_address[0] = cpu_to_le32(LSD(resp_dma));
+	ct_iocb->dseg_1_address[1] = cpu_to_le32(MSD(resp_dma));
+	ct_iocb->dseg_1_len = ct_iocb->rsp_byte_count;
+
+	ha->active_ct_service = service;
+
+	wmb();
+	qla2x00_isp_cmd(ha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (!wait_for_completion_timeout(&ha->pass_thru_intr_comp, 20 * HZ))
+		goto ct_error2;
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+
+	memcpy(frame, frame_backup, service->req_size);
+
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+
+	ha->active_ct_service = (struct fc_service *) 0;
+
+	service->service_done(service);
+	return service->status.residual;
+
+ct_error3:
+	ha->pass_thru_cmd_result = 0;
+	ha->pass_thru_cmd_in_process = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+ct_error2:
+	dma_unmap_single(&ha->pdev->dev, resp_dma, service->resp_size,
+	    DMA_FROM_DEVICE);
+ct_error1:
+	dma_unmap_single(&ha->pdev->dev, req_dma, service->req_size,
+	    DMA_TO_DEVICE);
+ct_error0:
+	qla_printk(KERN_WARNING, ha, "Passthru CT failed\n");
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
+	scsi_qla_host_t *ha = shost_priv(host);
+	struct fc_frame_header *frame = (struct fc_frame_header *)
+		service->els_frame;
+	struct abort_entry_24xx *abort_iocb;
+	struct els_entry_24xx *els_iocb = service->lld_pkt;
+
+	if (frame->fh_type != FC_FRAME_TYPE_ELS) {
+		printk(KERN_ERR "abort frame is not supported\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	abort_iocb = (struct abort_entry_24xx *)qla2x00_req_pkt(ha);
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
+	abort_iocb->vp_index = ha->vp_idx;
+
+	wmb();
+	qla2x00_isp_cmd(ha);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return 0;
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -1276,6 +1540,10 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.vport_create = qla24xx_vport_create,
 	.vport_disable = qla24xx_vport_disable,
 	.vport_delete = qla24xx_vport_delete,
+
+	.execute_fc_els_service = qla2x00_execute_fc_els_service,
+	.execute_fc_ct_service = qla2x00_execute_fc_ct_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
 };
 
 struct fc_function_template qla2xxx_transport_vport_functions = {
@@ -1316,6 +1584,10 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
 	.terminate_rport_io = qla2x00_terminate_rport_io,
 	.get_fc_host_stats = qla2x00_get_fc_host_stats,
+
+	.execute_fc_els_service = qla2x00_execute_fc_els_service,
+	.execute_fc_ct_service = qla2x00_execute_fc_ct_service,
+	.abort_fc_service = qla2x00_abort_fc_service,
 };
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ab802e9..957b077 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -95,6 +95,11 @@
 #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))
 
 
+/* ELS PT request buffer = 32 bytes */
+#define EXT_ELS_PT_REQ_WWPN_VALID	0x1
+#define EXT_ELS_PT_REQ_WWNN_VALID	0x2
+#define EXT_ELS_PT_REQ_PID_VALID	0x4
+
 /*
  * I/O register
 */
@@ -2426,6 +2431,8 @@ typedef struct scsi_qla_host {
 	/* SNS command interfaces for 2200. */
 	struct sns_cmd_pkt	*sns_cmd;
 	dma_addr_t		sns_cmd_dma;
+	char			*pass_thru;
+	dma_addr_t		pass_thru_dma;
 
 #define SFP_DEV_SIZE	256
 #define SFP_BLOCK_SIZE	64
@@ -2467,6 +2474,7 @@ typedef struct scsi_qla_host {
 	struct mutex vport_lock;	/* Virtual port synchronization */
 	struct completion mbx_cmd_comp;	/* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
+	struct completion pass_thru_intr_comp;
 
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
@@ -2611,6 +2619,12 @@ typedef struct scsi_qla_host {
 
 	struct qla_chip_state_84xx *cs84xx;
 	struct qla_statistics qla_stats;
+
+	/* pass through support */
+	int		pass_thru_cmd_result;
+	int		pass_thru_cmd_in_process;
+	struct fc_service *active_els_service;
+	struct fc_service *active_ct_service;
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
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
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 753dbe6..d0b6ac9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -121,6 +121,8 @@ extern int qla2x00_start_scsi(srb_t *sp);
 extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
 int __qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
+extern request_t * qla2x00_req_pkt(scsi_qla_host_t *);
+extern void qla2x00_isp_cmd(scsi_qla_host_t *ha);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -347,6 +349,7 @@ extern int qla2x00_fdmi_register(scsi_qla_host_t *);
 extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
 extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *);
+extern int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c2a4bfb..ceef231 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1093,7 +1093,7 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
  *
  * Returns 0 on success.
  */
-static int
+int
 qla2x00_mgmt_svr_login(scsi_qla_host_t *ha)
 {
 	int ret;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 20847fb..be06132 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2392,6 +2392,18 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 			return (QLA_SUCCESS);
 		}
 
+		/* allocate fc_port_t structure for name/directory server */
+		fcptemp = qla2x00_alloc_fcport(ha, GFP_KERNEL);
+		fcptemp->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
+		fcptemp->loop_id = loop_id;
+		fcptemp->d_id.b.domain = 0xff;
+		fcptemp->d_id.b.area = 0xff;
+		fcptemp->d_id.b.al_pa = 0xfc;
+		list_add_tail(&fcptemp->list, &pha->fcports);
+		atomic_set(&fcptemp->state, FCS_ONLINE);
+		qla2x00_reg_remote_port(ha, fcptemp);
+
+
 		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags)) {
 			if (qla2x00_rft_id(ha)) {
 				/* EMPTY */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9778f0b..9e7f636 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,8 +11,6 @@
 
 #include <scsi/scsi_tcq.h>
 
-static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
-static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -476,7 +474,7 @@ qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
  *
  * Returns NULL if function failed, else, a pointer to the request packet.
  */
-static request_t *
+request_t *
 qla2x00_req_pkt(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
@@ -546,7 +544,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
  *
  * Note: The caller must hold the hardware lock before calling this routine.
  */
-static void
+void
 qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 45a3b93..749e3ed 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1398,6 +1398,9 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 {
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	struct sts_entry_24xx *pkt;
+	struct els_status_24xx *els_status;
+	struct abort_entry_24xx *abort_iocb;
+	struct fc_service *service;
 
 	if (!ha->flags.online)
 		return;
@@ -1430,10 +1433,47 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 		case STATUS_CONT_TYPE:
 			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
 			break;
+ 		case MS_IOCB_TYPE:
+		case ELS_IOCB_TYPE:
+			els_status = (struct els_status_24xx *)pkt;
+
+			if (pkt->entry_type == MS_IOCB_TYPE)
+				service = ha->active_ct_service;
+			else
+				service = ha->active_els_service;
+
+			service->status.resp = FC_SERVICE_COMPLETE;
+			service->status.error = els_status->comp_status;
+
+			if (els_status->comp_status) {
+				if (els_status->comp_status == CS_DATA_UNDERRUN)
+					service->status.residual =
+					    els_status->total_byte_count;
+				else
+					service->status.residual = 0;
+				service->status.resp = FC_SERVICE_ERROR;
+			}
+
+			if (ha->pass_thru_cmd_result)
+				qla_printk(KERN_INFO, ha,
+				    "Passthru cmd result on.\n");
+			if (!ha->pass_thru_cmd_in_process)
+				qla_printk(KERN_INFO, ha,
+				    "Passthru in process off.\n");
+
+			ha->pass_thru_cmd_result = 1;
+			complete(&ha->pass_thru_intr_comp);
+ 			break;
 		case VP_RPT_ID_IOCB_TYPE:
 			qla24xx_report_id_acquisition(ha,
 			    (struct vp_rpt_id_entry_24xx *)pkt);
 			break;
+		case ABORT_IOCB_TYPE:
+			abort_iocb = (struct abort_entry_24xx *)pkt;
+			if (abort_iocb->nport_handle)
+				qla_printk(KERN_ERR, ha,
+				    "failed to abort ELS service\n");
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 62fe267..e7586d9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1669,6 +1669,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);
+	init_completion(&ha->pass_thru_intr_comp);
+
 
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
@@ -2017,6 +2019,8 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 		    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma, GFP_KERNEL);
 		if (!ha->ct_sns)
 			goto fail_free_ms_iocb;
+		ha->pass_thru = dma_alloc_coherent(&ha->pdev->dev,
+		    PAGE_SIZE, &ha->pass_thru_dma, GFP_KERNEL);
 	}
 
 	return 0;

--Apple-Mail-6--475911475
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-6--475911475--
