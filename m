From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/4] qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor commands.
Date: Tue, 12 Jan 2010 13:02:47 -0800
Message-ID: <1263330169-347-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1263330169-347-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35940 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753123Ab0ALVCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 16:02:50 -0500
In-Reply-To: <1263330169-347-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Sarang Radke <sarang.radke@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  746 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_def.h  |  155 ++++++++
 drivers/scsi/qla2xxx/qla_fw.h   |   33 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |    5 +
 drivers/scsi/qla2xxx/qla_init.c |   14 +-
 drivers/scsi/qla2xxx/qla_iocb.c |  120 +++++++
 drivers/scsi/qla2xxx/qla_isr.c  |  105 ++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  151 ++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 9 files changed, 1326 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3a9f5b2..6ecbda9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -11,7 +11,9 @@
 #include <linux/delay.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
-
+static int qla84xx_reset(scsi_qla_host_t *, struct msg_echo_lb *, struct fc_bsg_job *);
+int qla84xx_reset_chip(scsi_qla_host_t *, uint16_t, uint16_t *);
+static int qla84xx_mgmt_cmd(scsi_qla_host_t *, struct msg_echo_lb *, struct fc_bsg_job *);
 /* SYSFS attributes --------------------------------------------------------- */
 
 static ssize_t
@@ -1168,6 +1170,28 @@ qla2x00_total_isp_aborts_show(struct device *dev,
 }
 
 static ssize_t
+qla24xx_84xx_fw_version_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int rval = QLA_SUCCESS;
+	uint16_t status[2] = {0, 0};
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA84XX(ha) && ha->cs84xx) {
+		if (ha->cs84xx->op_fw_version == 0) {
+			rval = qla84xx_verify_chip(vha, status);
+	}
+
+	if ((rval == QLA_SUCCESS) && (status[0] == 0))
+		return snprintf(buf, PAGE_SIZE, "%u\n",
+			(uint32_t)ha->cs84xx->op_fw_version);
+	}
+
+	return snprintf(buf, PAGE_SIZE, "\n");
+}
+
+static ssize_t
 qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
     char *buf)
 {
@@ -1281,6 +1305,8 @@ static DEVICE_ATTR(optrom_fcode_version, S_IRUGO,
 		   qla2x00_optrom_fcode_version_show, NULL);
 static DEVICE_ATTR(optrom_fw_version, S_IRUGO, qla2x00_optrom_fw_version_show,
 		   NULL);
+static DEVICE_ATTR(84xx_fw_version, S_IRUGO, qla24xx_84xx_fw_version_show,
+		   NULL);
 static DEVICE_ATTR(total_isp_aborts, S_IRUGO, qla2x00_total_isp_aborts_show,
 		   NULL);
 static DEVICE_ATTR(mpi_version, S_IRUGO, qla2x00_mpi_version_show, NULL);
@@ -1310,6 +1336,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_optrom_efi_version,
 	&dev_attr_optrom_fcode_version,
 	&dev_attr_optrom_fw_version,
+	&dev_attr_84xx_fw_version,
 	&dev_attr_total_isp_aborts,
 	&dev_attr_mpi_version,
 	&dev_attr_phy_version,
@@ -1795,6 +1822,597 @@ qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
+/* BSG support for ELS/CT pass through */
+inline srb_t *
+qla2x00_get_ctx_bsg_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size)
+{
+	srb_t *sp;
+	struct qla_hw_data *ha = vha->hw;
+	struct srb_bsg_ctx *ctx;
+
+	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
+	if (!sp)
+		goto done;
+	ctx = kzalloc(size, GFP_KERNEL);
+	if (!ctx) {
+		mempool_free(sp, ha->srb_mempool);
+		goto done;
+	}
+
+	memset(sp, 0, sizeof(*sp));
+	sp->fcport = fcport;
+	sp->ctx = ctx;
+done:
+	return sp;
+}
+
+static int
+qla2x00_process_els(struct fc_bsg_job *bsg_job)
+{
+	struct fc_rport *rport;
+	fc_port_t *fcport;
+	struct Scsi_Host *host;
+	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha;
+	srb_t *sp;
+	const char *type;
+	int req_sg_cnt, rsp_sg_cnt;
+	int rval =  (DRIVER_ERROR << 16);
+	uint16_t nextlid = 0;
+	struct srb_bsg *els;
+
+	/*  Multiple SG's are not supported for ELS requests */
+        if (bsg_job->request_payload.sg_cnt > 1 ||
+		bsg_job->reply_payload.sg_cnt > 1) {
+		DEBUG2(printk(KERN_INFO
+		    "multiple SG's are not supported for ELS requests"
+		    " [request_sg_cnt: %x reply_sg_cnt: %x]\n",
+		    bsg_job->request_payload.sg_cnt,
+		    bsg_job->reply_payload.sg_cnt));
+		rval = -EPERM;
+		goto done;
+        }
+
+	/* ELS request for rport */
+	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+		rport = bsg_job->rport;
+		fcport = *(fc_port_t **) rport->dd_data;
+		host = rport_to_shost(rport);
+		vha = shost_priv(host);
+		ha = vha->hw;
+		type = "FC_BSG_RPT_ELS";
+
+		DEBUG2(printk(KERN_INFO
+		    "scsi(%ld): loop-id=%x portid=%02x%02x%02x.\n",
+		    fcport->vha->host_no, fcport->loop_id,
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa));
+
+		/* make sure the rport is logged in,
+		 * if not perform fabric login
+		 */
+		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "failed to login port %06X for ELS passthru\n",
+			    fcport->d_id.b24));
+			rval = -EIO;
+			goto done;
+		}
+	} else {
+		host = bsg_job->shost;
+		vha = shost_priv(host);
+		ha = vha->hw;
+		type = "FC_BSG_HST_ELS_NOLOGIN";
+
+		DEBUG2(printk(KERN_INFO
+		    "scsi(%ld): loop-id=%x portid=%02x%02x%02x.\n",
+		    vha->host_no, vha->loop_id,
+		    vha->d_id.b.domain, vha->d_id.b.area, vha->d_id.b.al_pa));
+
+		/* Allocate a dummy fcport structure, since functions
+		 * preparing the IOCB and mailbox command retrieves port
+		 * specific information from fcport structure. For Host based
+		 * ELS commands there will be no fcport structure allocated
+		 */
+		fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
+		if (!fcport) {
+			rval = -ENOMEM;
+			goto done;
+		}
+
+		/* Initialize all required  fields of fcport */
+		fcport->vha = vha;
+		fcport->vp_idx = vha->vp_idx;
+		fcport->d_id.b.al_pa =
+		    bsg_job->request->rqst_data.h_els.port_id[0];
+		fcport->d_id.b.area =
+		    bsg_job->request->rqst_data.h_els.port_id[1];
+		fcport->d_id.b.domain =
+		    bsg_job->request->rqst_data.h_els.port_id[2];
+		fcport->loop_id =
+		    (fcport->d_id.b.al_pa == 0xFD) ?
+		    NPH_FABRIC_CONTROLLER : NPH_F_PORT;
+	}
+
+	DEBUG2(printk(KERN_INFO
+	    "scsi(%ld): vendor-id = %llu\n",
+	    vha->host_no, host->hostt->vendor_id));
+
+        req_sg_cnt =
+	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+        if (!req_sg_cnt) {
+		rval = -ENOMEM;
+		goto done_free_fcport;
+	}
+        rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+        if (!rsp_sg_cnt) {
+		rval = -ENOMEM;
+                goto done_free_fcport;
+	}
+
+	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
+	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
+	{
+		DEBUG2(printk(KERN_INFO
+		    "dma mapping resulted in different sg counts \
+		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
+		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
+		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		rval = -EAGAIN;
+                goto done_unmap_sg;
+	}
+
+	/* Alloc SRB structure */
+	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
+	if (!sp) {
+		rval = -ENOMEM;
+                goto done_unmap_sg;
+	}
+
+	els = sp->ctx;
+	els->ctx.type =
+	    (bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
+	    SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
+	els->bsg_job = bsg_job;
+
+	DEBUG2(qla_printk(KERN_INFO, ha,
+	    "scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
+	    "portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
+	    bsg_job->request->rqst_data.h_els.command_code,
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa));
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS) {
+		kfree(sp->ctx);
+		mempool_free(sp, ha->srb_mempool);
+		rval = -EIO;
+		goto done_unmap_sg;
+	}
+	return rval;
+
+done_unmap_sg:
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	goto done_free_fcport;
+
+done_free_fcport:
+	if (bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN)
+		kfree(fcport);
+done:
+	return rval;
+}
+
+static int
+qla2x00_process_ct(struct fc_bsg_job *bsg_job)
+{
+	srb_t *sp;
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval = (DRIVER_ERROR << 16);
+	int req_sg_cnt, rsp_sg_cnt;
+	uint16_t loop_id;
+	struct fc_port *fcport;
+	char  *type = "FC_BSG_HST_CT";
+	struct srb_bsg *ct;
+
+	/* pass through is supported only for ISP 4Gb or higher */
+        if (!IS_FWI2_CAPABLE(ha)) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "scsi(%ld):Firmware is not capable to support FC "
+		    "CT pass thru\n", vha->host_no));
+		rval = -EPERM;
+                goto done;
+	}
+
+        req_sg_cnt =
+	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+        if (!req_sg_cnt) {
+		rval = -ENOMEM;
+		goto done;
+	}
+
+        rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+            bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+        if (!rsp_sg_cnt) {
+		rval = -ENOMEM;
+                goto done;
+	}
+
+	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
+		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
+	{
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "dma mapping resulted in different sg counts \
+		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
+		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
+		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		rval = -EAGAIN;
+                goto done_unmap_sg;
+	}
+
+	loop_id =
+	    (bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
+	    >> 24;
+	switch (loop_id) {
+		case 0xFC:
+			loop_id = cpu_to_le16(NPH_SNS);
+			break;
+		case 0xFA:
+			loop_id = vha->mgmt_svr_loop_id;
+			break;
+		default:
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "Unknown loop id: %x\n", loop_id));
+			rval = -EINVAL;
+			goto done_unmap_sg;
+	}
+
+	/* Allocate a dummy fcport structure, since functions preparing the
+	 * IOCB and mailbox command retrieves port specific information
+	 * from fcport structure. For Host based ELS commands there will be
+	 * no fcport structure allocated
+	 */
+	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
+	if (!fcport)
+	{
+		rval = -ENOMEM;
+		goto  done_unmap_sg;
+	}
+
+	/* Initialize all required  fields of fcport */
+	fcport->vha = vha;
+	fcport->vp_idx = vha->vp_idx;
+	fcport->d_id.b.al_pa = bsg_job->request->rqst_data.h_ct.port_id[0];
+	fcport->d_id.b.area = bsg_job->request->rqst_data.h_ct.port_id[1];
+	fcport->d_id.b.domain = bsg_job->request->rqst_data.h_ct.port_id[2];
+	fcport->loop_id = loop_id;
+
+	/* Alloc SRB structure */
+	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
+	if (!sp) {
+		rval = -ENOMEM;
+		goto done_free_fcport;
+	}
+
+	ct = sp->ctx;
+	ct->ctx.type = SRB_CT_CMD;
+	ct->bsg_job = bsg_job;
+
+	DEBUG2(qla_printk(KERN_INFO, ha,
+	    "scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
+	    "portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
+	    (bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa));
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS) {
+		kfree(sp->ctx);
+		mempool_free(sp, ha->srb_mempool);
+		rval = -EIO;
+		goto done_free_fcport;
+	}
+	return rval;
+
+done_free_fcport:
+	kfree(fcport);
+done_unmap_sg:
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+done:
+	return rval;
+}
+
+static int
+qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval;
+	uint8_t command_sent;
+	uint32_t vendor_cmd;
+	char *type;
+	struct msg_echo_lb elreq;
+	uint16_t response[MAILBOX_REGISTER_COUNT];
+	uint8_t* fw_sts_ptr;
+	uint8_t *req_data;
+	dma_addr_t req_data_dma;
+	uint32_t req_data_len;
+	uint8_t *rsp_data;
+	dma_addr_t rsp_data_dma;
+	uint32_t rsp_data_len;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+		rval = -EBUSY;
+		goto done;
+	}
+
+        elreq.req_sg_cnt =
+	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+        if (!elreq.req_sg_cnt) {
+		rval = -ENOMEM;
+		goto done;
+	}
+        elreq.rsp_sg_cnt =
+	    dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+        if (!elreq.rsp_sg_cnt) {
+		rval = -ENOMEM;
+                goto done;
+	}
+
+	if ((elreq.req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
+	    (elreq.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
+	{
+		DEBUG2(printk(KERN_INFO
+		    "dma mapping resulted in different sg counts \
+		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
+		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    bsg_job->request_payload.sg_cnt, elreq.req_sg_cnt,
+		    bsg_job->reply_payload.sg_cnt, elreq.rsp_sg_cnt));
+		rval = -EAGAIN;
+                goto done_unmap_sg;
+	}
+	req_data_len = rsp_data_len = bsg_job->request_payload.payload_len;
+	req_data = dma_alloc_coherent(&ha->pdev->dev, req_data_len,
+	    &req_data_dma, GFP_KERNEL);
+
+	rsp_data = dma_alloc_coherent(&ha->pdev->dev, rsp_data_len,
+	    &rsp_data_dma, GFP_KERNEL);
+
+	/* Copy the request buffer in req_data now */
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, req_data,
+	    req_data_len);
+
+	elreq.send_dma = req_data_dma;
+	elreq.rcv_dma = rsp_data_dma;
+	elreq.transfer_size = req_data_len;
+
+	/* Vendor cmd : loopback or ECHO diagnostic
+	 * Options:
+	 * 	Loopback : Either internal or external loopback
+	 * 	ECHO: ECHO ELS or Vendor specific FC4  link data
+	 */
+	vendor_cmd = bsg_job->request->rqst_data.h_vendor.vendor_cmd[0];
+	elreq.options =
+	    *(((uint32_t *)bsg_job->request->rqst_data.h_vendor.vendor_cmd)
+	    + 1);
+
+	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
+	case QL_VND_LOOPBACK:
+		if (ha->current_topology != ISP_CFG_F) {
+			type = "FC_BSG_HST_VENDOR_LOOPBACK";
+
+			if ((IS_QLA81XX(ha)) &&
+				((elreq.options == 0) || (elreq.options == 2))) {
+				DEBUG2(qla_printk(KERN_INFO, ha, "scsi(%ld)"
+				"loopback option:0x%x not supported\n", vha->host_no, elreq.options));
+				rval = -EINVAL;
+				goto done_unmap_sg;
+			}
+
+			DEBUG2(qla_printk(KERN_INFO, ha,
+				"scsi(%ld) bsg rqst type: %s vendor rqst type: %x options: %x.\n",
+				vha->host_no, type, vendor_cmd, elreq.options));
+			DEBUG2(qla_printk(KERN_INFO, ha,
+				"scsi(%ld) tx_addr: 0x%llx rx_addr: 0x%llx tx_sg_cnt: %x rx_sg_cnt: %x\n",
+				vha->host_no, elreq.send_dma, elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
+			command_sent = INT_DEF_LB_LOOPBACK_CMD;
+			rval = qla2x00_loopback_test(vha, &elreq, response);
+			if (IS_QLA81XX(ha)) {
+				if (response[0] == MBS_COMMAND_ERROR && response[1] == MBS_LB_RESET) {
+					DEBUG2(printk(KERN_ERR "%s(%ld): ABORTing "
+						"ISP\n", __func__, vha->host_no));
+					set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+					qla2xxx_wake_dpc(vha);
+				 }
+			}
+		} else {
+			type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
+			DEBUG2(qla_printk(KERN_INFO, ha,
+				"scsi(%ld) bsg rqst type: %s vendor rqst type: %x options: %x.\n",
+				vha->host_no, type, vendor_cmd, elreq.options));
+			DEBUG2(qla_printk(KERN_INFO, ha,
+				"scsi(%ld) tx_addr: 0x%llx rx_addr: 0x%llx tx_sg_cnt: %x rx_sg_cnt: %x\n",
+				vha->host_no, elreq.send_dma, elreq.rcv_dma, elreq.req_sg_cnt, elreq.rsp_sg_cnt));
+			command_sent = INT_DEF_LB_ECHO_CMD;
+			rval = qla2x00_echo_test(vha, &elreq, response);
+		}
+		break;
+	case QLA84_RESET:
+		if (!IS_QLA84XX(vha->hw)) {
+			rval = -EINVAL;
+			DEBUG16(printk(
+				"%s(%ld): 8xxx exiting.\n",
+				__func__, vha->host_no));
+			return rval;
+		}
+		rval = qla84xx_reset(vha, &elreq, bsg_job);
+		break;
+	case QLA84_MGMT_CMD:
+		if (!IS_QLA84XX(vha->hw)) {
+			rval = -EINVAL;
+			DEBUG16(printk(
+				"%s(%ld): 8xxx exiting.\n",
+				__func__, vha->host_no));
+			return rval;
+		}
+		rval = qla84xx_mgmt_cmd(vha, &elreq, bsg_job);
+		break;
+	default:
+		rval = -ENOSYS;
+	}
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"scsi(%ld) Vendor request %s failed\n", vha->host_no, type));
+		rval = 0;
+		bsg_job->reply->result = (DID_ERROR << 16);
+		fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+		memcpy( fw_sts_ptr, response, sizeof(response));
+		fw_sts_ptr += sizeof(response);
+                *fw_sts_ptr = command_sent;
+	} else {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"scsi(%ld) Vendor request %s completed\n", vha->host_no, type));
+		rval = bsg_job->reply->result = 0;
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply) + sizeof(response) + sizeof(uint8_t);
+		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
+		fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+		memcpy(fw_sts_ptr, response, sizeof(response));
+		fw_sts_ptr += sizeof(response);
+		*fw_sts_ptr = command_sent;
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+		bsg_job->reply_payload.sg_cnt, rsp_data,
+		rsp_data_len);
+	}
+	bsg_job->job_done(bsg_job);
+
+done_unmap_sg:
+
+	if(req_data)
+		dma_free_coherent(&ha->pdev->dev, req_data_len,
+			req_data, req_data_dma);
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+done:
+        return rval;
+}
+
+static int
+qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
+{
+        int ret = -EINVAL;
+
+        switch (bsg_job->request->msgcode) {
+		case FC_BSG_RPT_ELS:
+		case FC_BSG_HST_ELS_NOLOGIN:
+			ret = qla2x00_process_els(bsg_job);
+			break;
+		case FC_BSG_HST_CT:
+			ret = qla2x00_process_ct(bsg_job);
+			break;
+		case FC_BSG_HST_VENDOR:
+			ret = qla2x00_process_vendor_specific(bsg_job);
+			break;
+		case FC_BSG_HST_ADD_RPORT:
+		case FC_BSG_HST_DEL_RPORT:
+		case FC_BSG_RPT_CT:
+		default:
+			DEBUG2(printk("qla2xxx: unsupported BSG request\n"));
+			break;
+        }
+	return ret;
+}
+
+static int
+qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
+{
+        scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
+        struct qla_hw_data *ha = vha->hw;
+        srb_t *sp;
+        int i;
+        unsigned long flags;
+        uint16_t que_id;
+        struct req_que *req;
+        struct rsp_que *rsp;
+	int found = 0;
+	struct srb_bsg *sp_bsg;
+
+	/* find the bsg job from the active list of commands */
+        spin_lock_irqsave(&ha->hardware_lock, flags);
+	req = ha->req_q_map[0];
+        que_id = req->id;
+        if (req->rsp)
+                rsp = req->rsp;
+        else
+                rsp = ha->rsp_q_map[que_id];
+
+	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++ ) {
+                sp = req->outstanding_cmds[i];
+
+                if (sp == NULL)
+                        continue;
+
+		sp_bsg = (struct srb_bsg*)sp->ctx;
+
+		if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
+		    (sp_bsg->ctx.type == SRB_ELS_CMD_RPT)
+		    || ( sp_bsg->ctx.type == SRB_ELS_CMD_HST)) &&
+		    (sp_bsg->bsg_job == bsg_job)) {
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "scsi(%ld) req_q: %p rsp_q: %p que_id: %x sp: %p\n",
+			    vha->host_no, req, rsp, que_id, sp));
+			found = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (!found) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+			"scsi(%ld) SRB not found to abort\n", vha->host_no));
+		bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
+		return 0;
+	}
+
+	if (ha->isp_ops->abort_command(sp)) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		"scsi(%ld): mbx abort_command failed\n", vha->host_no));
+		bsg_job->req->errors = bsg_job->reply->result = -EIO;
+	} else {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		"scsi(%ld): mbx abort_command success\n", vha->host_no));
+		bsg_job->req->errors = bsg_job->reply->result = 0;
+	}
+
+	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
+		kfree(sp->fcport);
+	kfree(sp->ctx);
+	mempool_free(sp, ha->srb_mempool);
+	return 0;
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -1838,6 +2456,8 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.vport_create = qla24xx_vport_create,
 	.vport_disable = qla24xx_vport_disable,
 	.vport_delete = qla24xx_vport_delete,
+	.bsg_request = qla24xx_bsg_request,
+	.bsg_timeout = qla24xx_bsg_timeout,
 };
 
 struct fc_function_template qla2xxx_transport_vport_functions = {
@@ -1878,6 +2498,8 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
 	.terminate_rport_io = qla2x00_terminate_rport_io,
 	.get_fc_host_stats = qla2x00_get_fc_host_stats,
+	.bsg_request = qla24xx_bsg_request,
+	.bsg_timeout = qla24xx_bsg_timeout,
 };
 
 void
@@ -1906,3 +2528,125 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 		speed = FC_PORTSPEED_1GBIT;
 	fc_host_supported_speeds(vha->host) = speed;
 }
+static int
+qla84xx_reset(scsi_qla_host_t *ha, struct msg_echo_lb *mreq, struct fc_bsg_job *bsg_job)
+{
+	int             ret = 0;
+	int             cmd;
+	uint16_t        cmd_status;
+
+	DEBUG16(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	cmd = (*((bsg_job->request->rqst_data.h_vendor.vendor_cmd) + 2))
+			== A84_RESET_FLAG_ENABLE_DIAG_FW ?
+				A84_ISSUE_RESET_DIAG_FW : A84_ISSUE_RESET_OP_FW;
+	ret = qla84xx_reset_chip(ha, cmd == A84_ISSUE_RESET_DIAG_FW,
+	&cmd_status);
+	return ret;
+}
+
+static int
+qla84xx_mgmt_cmd(scsi_qla_host_t *ha, struct msg_echo_lb *mreq, struct fc_bsg_job *bsg_job)
+{
+	struct access_chip_84xx *mn;
+	dma_addr_t mn_dma, mgmt_dma;
+	void *mgmt_b = NULL;
+	int ret = 0;
+	int rsp_hdr_len, len = 0;
+	struct qla84_msg_mgmt *ql84_mgmt;
+
+	ql84_mgmt = (struct qla84_msg_mgmt *) vmalloc(sizeof(struct qla84_msg_mgmt));
+	ql84_mgmt->cmd =
+		*((uint16_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 2));
+	ql84_mgmt->mgmtp.u.mem.start_addr =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 3));
+	ql84_mgmt->len =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 4));
+	ql84_mgmt->mgmtp.u.config.id =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 5));
+	ql84_mgmt->mgmtp.u.config.param0 =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 6));
+	ql84_mgmt->mgmtp.u.config.param1 =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 7));
+	ql84_mgmt->mgmtp.u.info.type =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 8));
+	ql84_mgmt->mgmtp.u.info.context =
+		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 9));
+
+	rsp_hdr_len = bsg_job->request_payload.payload_len;
+
+	mn = dma_pool_alloc(ha->hw->s_dma_pool, GFP_KERNEL, &mn_dma);
+	if (mn == NULL) {
+		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw buffer "
+		"failed%lu\n", __func__, ha->host_no));
+		return -ENOMEM;
+	}
+
+	memset(mn, 0, sizeof (struct access_chip_84xx));
+
+	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
+	mn->entry_count = 1;
+
+	switch (ql84_mgmt->cmd) {
+	case QLA84_MGMT_READ_MEM:
+		mn->options = cpu_to_le16(ACO_DUMP_MEMORY);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.mem.start_addr);
+		break;
+	case QLA84_MGMT_WRITE_MEM:
+		mn->options = cpu_to_le16(ACO_LOAD_MEMORY);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.mem.start_addr);
+		break;
+	case QLA84_MGMT_CHNG_CONFIG:
+		mn->options = cpu_to_le16(ACO_CHANGE_CONFIG_PARAM);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.id);
+		mn->parameter2 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.param0);
+		mn->parameter3 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.param1);
+		break;
+	case QLA84_MGMT_GET_INFO:
+		mn->options = cpu_to_le16(ACO_REQUEST_INFO);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.info.type);
+		mn->parameter2 = cpu_to_le32(ql84_mgmt->mgmtp.u.info.context);
+		break;
+	default:
+		ret = -EIO;
+		goto exit_mgmt0;
+	}
+
+	if ((len == ql84_mgmt->len) &&
+		ql84_mgmt->cmd != QLA84_MGMT_CHNG_CONFIG) {
+		mgmt_b = dma_alloc_coherent(&ha->hw->pdev->dev, len,
+				&mgmt_dma, GFP_KERNEL);
+		if (mgmt_b == NULL) {
+			DEBUG2(printk(KERN_ERR "%s: dma alloc mgmt_b "
+			"failed%lu\n", __func__, ha->host_no));
+			ret = -ENOMEM;
+			goto exit_mgmt0;
+		}
+		mn->total_byte_cnt = cpu_to_le32(ql84_mgmt->len);
+		mn->dseg_count = cpu_to_le16(1);
+		mn->dseg_address[0] = cpu_to_le32(LSD(mgmt_dma));
+		mn->dseg_address[1] = cpu_to_le32(MSD(mgmt_dma));
+		mn->dseg_length = cpu_to_le32(len);
+
+		if (ql84_mgmt->cmd == QLA84_MGMT_WRITE_MEM) {
+			memcpy(mgmt_b, ql84_mgmt->payload, len);
+		}
+	}
+
+	ret = qla2x00_issue_iocb(ha, mn, mn_dma, 0);
+	if ((ret != QLA_SUCCESS) || (ql84_mgmt->cmd == QLA84_MGMT_WRITE_MEM)
+		|| (ql84_mgmt->cmd == QLA84_MGMT_CHNG_CONFIG)) {
+			if (ret != QLA_SUCCESS)
+				DEBUG2(printk(KERN_ERR "%s(%lu): failed\n",
+					__func__, ha->host_no));
+	} else if ((ql84_mgmt->cmd == QLA84_MGMT_READ_MEM) ||
+			(ql84_mgmt->cmd == QLA84_MGMT_GET_INFO)) {
+	}
+
+	if (mgmt_b)
+		dma_free_coherent(&ha->hw->pdev->dev, len, mgmt_b, mgmt_dma);
+
+exit_mgmt0:
+	dma_pool_free(ha->hw->s_dma_pool, mn, mn_dma);
+	return ret;
+}
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1263d97..afa9561 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -31,6 +31,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_bsg_fc.h>
 
 #define QLA2XXX_DRIVER_NAME  "qla2xxx"
 
@@ -228,6 +229,27 @@ struct srb_logio {
 	uint16_t flags;
 };
 
+struct srb_bsg_ctx {
+#define SRB_ELS_CMD_RPT 3
+#define SRB_ELS_CMD_HST 4
+#define SRB_CT_CMD 5
+	uint16_t type;
+};
+
+struct srb_bsg {
+	struct srb_bsg_ctx ctx;
+	struct fc_bsg_job *bsg_job;
+};
+
+struct msg_echo_lb {
+	dma_addr_t send_dma;
+	dma_addr_t rcv_dma;
+	uint16_t req_sg_cnt;
+	uint16_t rsp_sg_cnt;
+	uint16_t options;
+	uint32_t transfer_size;
+};
+
 /*
  * ISP I/O Register Set structure definitions.
  */
@@ -522,6 +544,8 @@ typedef struct {
 #define MBA_DISCARD_RND_FRAME	0x8048	/* discard RND frame due to error. */
 #define MBA_REJECTED_FCP_CMD	0x8049	/* rejected FCP_CMD. */
 
+/* ISP mailbox loopback echo diagnostic error code */
+#define MBS_LB_RESET	0x17
 /*
  * Firmware options 1, 2, 3.
  */
@@ -2230,6 +2254,13 @@ struct req_que {
 	int max_q_depth;
 };
 
+/* Place holder for FW buffer parameters */
+struct qlfc_fw {
+	void *fw_buf;
+	dma_addr_t fw_dma;
+	uint32_t len;
+};
+
 /*
  * Qlogic host adapter specific data structure.
 */
@@ -2594,6 +2625,7 @@ struct qla_hw_data {
 	struct qla_statistics qla_stats;
 	struct isp_operations *isp_ops;
 	struct workqueue_struct *wq;
+	struct qlfc_fw fw_buf;
 };
 
 /*
@@ -2766,4 +2798,127 @@ typedef struct scsi_qla_host {
 
 #define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
 
+/*
+ * BSG Vendor specific commands
+ */
+
+#define QL_VND_LOOPBACK		0x01
+#define QLA84_RESET		0x02
+#define QLA84_UPDATE_FW		0x03
+#define QLA84_MGMT_CMD		0x04
+
+/* BSG definations for interpreting CommandSent field */
+#define INT_DEF_LB_LOOPBACK_CMD         0
+#define INT_DEF_LB_ECHO_CMD             1
+
+/* BSG Vendor specific definations */
+typedef struct _A84_RESET {
+	uint16_t Flags;
+	uint16_t Reserved;
+#define A84_RESET_FLAG_ENABLE_DIAG_FW   1
+} __attribute__((packed)) A84_RESET, *PA84_RESET;
+
+#define A84_ISSUE_WRITE_TYPE_CMD        0
+#define A84_ISSUE_READ_TYPE_CMD         1
+#define A84_CLEANUP_CMD                 2
+#define A84_ISSUE_RESET_OP_FW           3
+#define A84_ISSUE_RESET_DIAG_FW         4
+#define A84_ISSUE_UPDATE_OPFW_CMD       5
+#define A84_ISSUE_UPDATE_DIAGFW_CMD     6
+
+struct qla84_mgmt_param {
+	union {
+		struct {
+			uint32_t start_addr;
+		} mem; /* for QLA84_MGMT_READ/WRITE_MEM */
+		struct {
+			uint32_t id;
+#define QLA84_MGMT_CONFIG_ID_UIF        1
+#define QLA84_MGMT_CONFIG_ID_FCOE_COS   2
+#define QLA84_MGMT_CONFIG_ID_PAUSE      3
+#define QLA84_MGMT_CONFIG_ID_TIMEOUTS   4
+
+		uint32_t param0;
+		uint32_t param1;
+	} config; /* for QLA84_MGMT_CHNG_CONFIG */
+
+	struct {
+		uint32_t type;
+#define QLA84_MGMT_INFO_CONFIG_LOG_DATA         1 /* Get Config Log Data */
+#define QLA84_MGMT_INFO_LOG_DATA                2 /* Get Log Data */
+#define QLA84_MGMT_INFO_PORT_STAT               3 /* Get Port Statistics */
+#define QLA84_MGMT_INFO_LIF_STAT                4 /* Get LIF Statistics  */
+#define QLA84_MGMT_INFO_ASIC_STAT               5 /* Get ASIC Statistics */
+#define QLA84_MGMT_INFO_CONFIG_PARAMS           6 /* Get Config Parameters */
+#define QLA84_MGMT_INFO_PANIC_LOG               7 /* Get Panic Log */
+
+		uint32_t context;
+/*
+* context definitions for QLA84_MGMT_INFO_CONFIG_LOG_DATA
+*/
+#define IC_LOG_DATA_LOG_ID_DEBUG_LOG                    0
+#define IC_LOG_DATA_LOG_ID_LEARN_LOG                    1
+#define IC_LOG_DATA_LOG_ID_FC_ACL_INGRESS_LOG           2
+#define IC_LOG_DATA_LOG_ID_FC_ACL_EGRESS_LOG            3
+#define IC_LOG_DATA_LOG_ID_ETHERNET_ACL_INGRESS_LOG     4
+#define IC_LOG_DATA_LOG_ID_ETHERNET_ACL_EGRESS_LOG      5
+#define IC_LOG_DATA_LOG_ID_MESSAGE_TRANSMIT_LOG         6
+#define IC_LOG_DATA_LOG_ID_MESSAGE_RECEIVE_LOG          7
+#define IC_LOG_DATA_LOG_ID_LINK_EVENT_LOG               8
+#define IC_LOG_DATA_LOG_ID_DCX_LOG                      9
+
+/*
+* context definitions for QLA84_MGMT_INFO_PORT_STAT
+*/
+#define IC_PORT_STATISTICS_PORT_NUMBER_ETHERNET_PORT0   0
+#define IC_PORT_STATISTICS_PORT_NUMBER_ETHERNET_PORT1   1
+#define IC_PORT_STATISTICS_PORT_NUMBER_NSL_PORT0        2
+#define IC_PORT_STATISTICS_PORT_NUMBER_NSL_PORT1        3
+#define IC_PORT_STATISTICS_PORT_NUMBER_FC_PORT0         4
+#define IC_PORT_STATISTICS_PORT_NUMBER_FC_PORT1         5
+
+
+/*
+* context definitions for QLA84_MGMT_INFO_LIF_STAT
+*/
+#define IC_LIF_STATISTICS_LIF_NUMBER_ETHERNET_PORT0     0
+#define IC_LIF_STATISTICS_LIF_NUMBER_ETHERNET_PORT1     1
+#define IC_LIF_STATISTICS_LIF_NUMBER_FC_PORT0           2
+#define IC_LIF_STATISTICS_LIF_NUMBER_FC_PORT1           3
+#define IC_LIF_STATISTICS_LIF_NUMBER_CPU                6
+
+		} info; /* for QLA84_MGMT_GET_INFO */
+	} u;
+};
+
+struct qla84_msg_mgmt {
+	uint16_t cmd;
+#define QLA84_MGMT_READ_MEM     0x00
+#define QLA84_MGMT_WRITE_MEM    0x01
+#define QLA84_MGMT_CHNG_CONFIG  0x02
+#define QLA84_MGMT_GET_INFO     0x03
+	uint16_t rsrvd;
+	struct qla84_mgmt_param mgmtp;/* parameters for cmd */
+	uint32_t len; /* bytes in payload following this struct */
+	uint8_t payload[0]; /* payload for cmd */
+};
+
+struct msg_update_fw {
+	/*
+	* diag_fw = 0  operational fw
+	*      otherwise diagnostic fw
+	* offset, len, fw_len are present to overcome the current limitation
+	* of 128Kb xfer size. The fw is sent in smaller chunks. Each chunk
+	* specifies the byte "offset" where it fits in the fw buffer. The
+	* number of bytes in each chunk is specified in "len". "fw_len"
+	* is the total size of fw. The first chunk should start at offset = 0.
+	* When offset+len == fw_len, the fw is written to the HBA.
+	*/
+	uint32_t diag_fw;
+	uint32_t offset;/* start offset */
+	uint32_t len;   /* num bytes in cur xfer */
+	uint32_t fw_len; /* size of fw in bytes */
+	uint8_t fw_bytes[0];
+};
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 66a8da5..cebf4f1 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -627,6 +627,39 @@ struct els_entry_24xx {
 	uint32_t rx_len;		/* Data segment 1 length. */
 };
 
+struct els_sts_entry_24xx {
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
+	uint16_t reserved_1;
+
+	uint8_t vp_index;
+	uint8_t sof_type;
+
+	uint32_t rx_xchg_address;	/* Receive exchange address. */
+	uint16_t reserved_2;
+
+	uint8_t opcode;
+	uint8_t reserved_3;
+
+	uint8_t port_id[3];
+	uint8_t reserved_4;
+
+	uint16_t reserved_5;
+
+	uint16_t control_flags;		/* Control flags. */
+	uint32_t total_byte_count;
+	uint32_t error_subcode_1;
+	uint32_t error_subcode_2;
+};
 /*
  * ISP queue - Mailbox Command entry structure definition.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f61fb8d..b42e704 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -60,6 +60,8 @@ extern int qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
 extern int qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 
+extern fc_port_t *
+qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t );
 /*
  * Global Data in qla_os.c source file.
  */
@@ -154,6 +156,7 @@ int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 int __qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 						uint16_t, uint16_t, uint8_t);
 extern int qla2x00_start_sp(srb_t *);
+extern void qla2x00_ctx_sp_free(srb_t *);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -426,6 +429,8 @@ extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_init_host_attr(scsi_qla_host_t *);
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
+extern int qla2x00_loopback_test(scsi_qla_host_t *, struct msg_echo_lb *, uint16_t *);
+extern int qla2x00_echo_test(scsi_qla_host_t *, struct msg_echo_lb *, uint16_t *);
 
 /*
  * Global Function Prototypes in qla_dfs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f8e849..1128c8d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -62,7 +62,7 @@ qla2x00_ctx_sp_timeout(unsigned long __data)
 	ctx->free(sp);
 }
 
-static void
+void
 qla2x00_ctx_sp_free(srb_t *sp)
 {
 	struct srb_ctx *ctx = sp->ctx;
@@ -338,6 +338,16 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	rval = qla2x00_init_rings(vha);
 	ha->flags.chip_reset_done = 1;
 
+	if (rval == QLA_SUCCESS && IS_QLA84XX(ha)) {
+	/* Issue verify 84xx FW IOCB to complete 84xx initialization */
+		rval = qla84xx_init_chip(vha);
+		if (rval != QLA_SUCCESS) {
+			qla_printk(KERN_ERR, ha,
+				"Unable to initialize ISP84XX.\n");
+		qla84xx_put_chip(vha);
+		}
+	}
+
 	return (rval);
 }
 
@@ -2216,7 +2226,7 @@ qla2x00_rport_del(void *data)
  *
  * Returns a pointer to the allocated fcport, or NULL, if none available.
  */
-static fc_port_t *
+fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 {
 	fc_port_t *fcport;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c5ccac0..8299a98 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1025,6 +1025,119 @@ qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
 	/* Implicit: mbx->mbx10 = 0. */
 }
 
+static void
+qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
+{
+	struct fc_bsg_job *bsg_job = ((struct srb_bsg*)sp->ctx)->bsg_job;
+
+        els_iocb->entry_type = ELS_IOCB_TYPE;
+        els_iocb->entry_count = 1;
+        els_iocb->sys_define = 0;
+        els_iocb->entry_status = 0;
+        els_iocb->handle = sp->handle;
+        els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+        els_iocb->tx_dsd_count = __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt);
+        els_iocb->vp_index = sp->fcport->vp_idx;
+        els_iocb->sof_type = EST_SOFI3;
+        els_iocb->rx_dsd_count = __constant_cpu_to_le16(bsg_job->reply_payload.sg_cnt);
+
+        els_iocb->opcode =(((struct srb_bsg*)sp->ctx)->ctx.type == SRB_ELS_CMD_RPT) ?
+	    bsg_job->request->rqst_data.r_els.els_code : bsg_job->request->rqst_data.h_els.command_code;
+        els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
+        els_iocb->port_id[1] = sp->fcport->d_id.b.area;
+        els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+        els_iocb->control_flags = 0;
+        els_iocb->rx_byte_count =
+            cpu_to_le32(bsg_job->reply_payload.payload_len);
+        els_iocb->tx_byte_count =
+            cpu_to_le32(bsg_job->request_payload.payload_len);
+
+        els_iocb->tx_address[0] = cpu_to_le32(LSD(sg_dma_address
+            (bsg_job->request_payload.sg_list)));
+        els_iocb->tx_address[1] = cpu_to_le32(MSD(sg_dma_address
+            (bsg_job->request_payload.sg_list)));
+        els_iocb->tx_len = cpu_to_le32(sg_dma_len
+            (bsg_job->request_payload.sg_list));
+
+        els_iocb->rx_address[0] = cpu_to_le32(LSD(sg_dma_address
+            (bsg_job->reply_payload.sg_list)));
+        els_iocb->rx_address[1] = cpu_to_le32(MSD(sg_dma_address
+            (bsg_job->reply_payload.sg_list)));
+        els_iocb->rx_len = cpu_to_le32(sg_dma_len
+            (bsg_job->reply_payload.sg_list));
+}
+
+static void
+qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
+{
+	uint16_t        avail_dsds;
+	uint32_t        *cur_dsd;
+	struct scatterlist *sg;
+	int index;
+	uint16_t tot_dsds;
+        scsi_qla_host_t *vha = sp->fcport->vha;
+	struct fc_bsg_job *bsg_job = ((struct srb_bsg*)sp->ctx)->bsg_job;
+	int loop_iterartion = 0;
+	int cont_iocb_prsnt = 0;
+	int entry_count = 1;
+
+	ct_iocb->entry_type = CT_IOCB_TYPE;
+        ct_iocb->entry_status = 0;
+        ct_iocb->sys_define = 0;
+        ct_iocb->handle = sp->handle;
+
+	ct_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	ct_iocb->vp_index = sp->fcport->vp_idx;
+        ct_iocb->comp_status = __constant_cpu_to_le16(0);
+
+	ct_iocb->cmd_dsd_count =
+            __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt);
+        ct_iocb->timeout = 0;
+        ct_iocb->rsp_dsd_count =
+            __constant_cpu_to_le16(bsg_job->reply_payload.sg_cnt);
+        ct_iocb->rsp_byte_count =
+            cpu_to_le32(bsg_job->reply_payload.payload_len);
+        ct_iocb->cmd_byte_count =
+            cpu_to_le32(bsg_job->request_payload.payload_len);
+        ct_iocb->dseg_0_address[0] = cpu_to_le32(LSD(sg_dma_address
+            (bsg_job->request_payload.sg_list)));
+        ct_iocb->dseg_0_address[1] = cpu_to_le32(MSD(sg_dma_address
+           (bsg_job->request_payload.sg_list)));
+        ct_iocb->dseg_0_len = cpu_to_le32(sg_dma_len
+            (bsg_job->request_payload.sg_list));
+
+	avail_dsds = 1;
+	cur_dsd = (uint32_t *)ct_iocb->dseg_1_address;
+	index = 0;
+	tot_dsds = bsg_job->reply_payload.sg_cnt;
+
+	for_each_sg(bsg_job->reply_payload.sg_list, sg, tot_dsds, index) {
+		dma_addr_t       sle_dma;
+		cont_a64_entry_t *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			* Five DSDs are available in the Cont.
+			* Type 1 IOCB.
+			       */
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
+			cur_dsd = (uint32_t *) cont_pkt->dseg_0_address;
+			avail_dsds = 5;
+			cont_iocb_prsnt = 1;
+			entry_count++;
+		}
+
+		sle_dma = sg_dma_address(sg);
+		*cur_dsd++   = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++   = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++   = cpu_to_le32(sg_dma_len(sg));
+		loop_iterartion++;
+		avail_dsds--;
+	}
+        ct_iocb->entry_count = entry_count;
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -1052,6 +1165,13 @@ qla2x00_start_sp(srb_t *sp)
 		    qla24xx_logout_iocb(sp, pkt):
 		    qla2x00_logout_iocb(sp, pkt);
 		break;
+	case SRB_ELS_CMD_RPT:
+	case SRB_ELS_CMD_HST:
+		qla24xx_els_iocb(sp, pkt);
+		break;
+	case SRB_CT_CMD:
+		qla24xx_ct_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5613456..09ba26b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -8,6 +8,7 @@
 
 #include <linux/delay.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_bsg_fc.h>
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_process_completed_request(struct scsi_qla_host *,
@@ -881,7 +882,9 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 		    index);
 		return NULL;
 	}
+
 	req->outstanding_cmds[index] = NULL;
+
 done:
 	return sp;
 }
@@ -982,6 +985,100 @@ done_post_logio_done_work:
 }
 
 static void
+qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
+    struct sts_entry_24xx *pkt, int iocb_type)
+{
+	const char func[] = "ELS_CT_IOCB";
+	const char *type;
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	struct srb_bsg *sp_bsg;
+	struct fc_bsg_job *bsg_job;
+	uint16_t comp_status;
+	uint32_t fw_status[3];
+	uint8_t* fw_sts_ptr;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	if (!sp)
+		return;
+	sp_bsg = (struct srb_bsg*)sp->ctx;
+	bsg_job = sp_bsg->bsg_job;
+
+	type = NULL;
+	switch (sp_bsg->ctx.type) {
+	case SRB_ELS_CMD_RPT:
+	case SRB_ELS_CMD_HST:
+		type = "els";
+		break;
+	case SRB_CT_CMD:
+		type = "ct pass-through";
+		break;
+	default:
+		qla_printk(KERN_WARNING, ha,
+		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
+		    sp_bsg->ctx.type);
+		return;
+	}
+
+	comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
+	fw_status[1] = le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_1);
+	fw_status[2] = le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_2);
+
+	/* return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
+	 * fc payload  to the caller
+	 */
+	bsg_job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply) + sizeof(fw_status);
+
+	if (comp_status != CS_COMPLETE) {
+		if (comp_status == CS_DATA_UNDERRUN) {
+			bsg_job->reply->result = DID_OK << 16;
+			bsg_job->reply->reply_payload_rcv_len =
+				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->total_byte_count);
+
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "scsi(%ld:0x%x): ELS-CT pass-through-%s error comp_status-status=0x%x "
+			    "error subcode 1=0x%x error subcode 2=0x%x total_byte = 0x%x.\n",
+				vha->host_no, sp->handle, type, comp_status, fw_status[1], fw_status[2],
+				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->total_byte_count)));
+			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
+		}
+		else {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			    "scsi(%ld:0x%x): ELS-CT pass-through-%s error comp_status-status=0x%x "
+			    "error subcode 1=0x%x error subcode 2=0x%x.\n",
+				vha->host_no, sp->handle, type, comp_status,
+				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_1),
+				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_2)));
+			bsg_job->reply->result = DID_ERROR << 16;
+			bsg_job->reply->reply_payload_rcv_len = 0;
+			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
+		}
+		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
+	}
+	else {
+		bsg_job->reply->result =  DID_OK << 16;;
+		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
+		bsg_job->reply_len = 0;
+	}
+
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	if ((sp_bsg->ctx.type == SRB_ELS_CMD_HST) ||
+	    (sp_bsg->ctx.type == SRB_CT_CMD))
+		kfree(sp->fcport);
+	kfree(sp->ctx);
+	mempool_free(sp, ha->srb_mempool);
+	bsg_job->job_done(bsg_job);
+}
+
+static void
 qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct logio_entry_24xx *logio)
 {
@@ -1749,6 +1846,13 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_logio_entry(vha, rsp->req,
 			    (struct logio_entry_24xx *)pkt);
 			break;
+                case CT_IOCB_TYPE:
+			qla24xx_els_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
+			clear_bit(MBX_INTERRUPT, &vha->hw->mbx_cmd_flags);
+			break;
+                case ELS_IOCB_TYPE:
+			qla24xx_els_ct_entry(vha, rsp->req, pkt, ELS_IOCB_TYPE);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -2046,7 +2150,6 @@ qla24xx_msix_default(int irq, void *dev_id)
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 		complete(&ha->mbx_intr_comp);
 	}
-
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 056e4d4..6e53bdb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3636,6 +3636,157 @@ qla2x00_read_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t *data)
 }
 
 int
+qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mresp)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	uint32_t iter_cnt = 0x1;
+
+	DEBUG11(printk("scsi(%ld): entered.\n", vha->host_no));
+
+	memset(mcp->mb, 0 , sizeof(mcp->mb));
+	mcp->mb[0] = MBC_DIAGNOSTIC_LOOP_BACK;
+	mcp->mb[1] = mreq->options | BIT_6;	// BIT_6 specifies 64 bit addressing
+
+	/* transfer count */
+	mcp->mb[10] = LSW(mreq->transfer_size);
+	mcp->mb[11] = MSW(mreq->transfer_size);
+
+	/* send data address */
+	mcp->mb[14] = LSW(mreq->send_dma);
+	mcp->mb[15] = MSW(mreq->send_dma);
+	mcp->mb[20] = LSW(MSD(mreq->send_dma));
+	mcp->mb[21] = MSW(MSD(mreq->send_dma));
+
+	/* recieve data address */
+	mcp->mb[16] = LSW(mreq->rcv_dma);
+	mcp->mb[17] = MSW(mreq->rcv_dma);
+	mcp->mb[6] = LSW(MSD(mreq->rcv_dma));
+	mcp->mb[7] = MSW(MSD(mreq->rcv_dma));
+
+	/* Iteration count */
+	mcp->mb[18] = LSW(iter_cnt);
+	mcp->mb[19] = MSW(iter_cnt);
+
+	mcp->out_mb = MBX_21|MBX_20|MBX_19|MBX_18|MBX_17|MBX_16|MBX_15|
+	    MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_7|MBX_6|MBX_1|MBX_0;
+	if (IS_QLA81XX(vha->hw))
+		mcp->out_mb |= MBX_2;
+	mcp->in_mb = MBX_19|MBX_18|MBX_3|MBX_2|MBX_1|MBX_0;
+
+	mcp->buf_size = mreq->transfer_size;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN|IOCTL_CMD;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(printk(KERN_WARNING
+		    "(%ld): failed=%x mb[0]=0x%x "
+			"mb[1]=0x%x mb[2]=0x%x mb[3]=0x%x mb[18]=0x%x mb[19]=0x%x. \n", vha->host_no, rval,
+			mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[18], mcp->mb[19]));
+	} else {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld): done.\n", vha->host_no));
+	}
+
+	/* Copy mailbox information */
+	memcpy( mresp, mcp->mb, 64);
+	mresp[3] = mcp->mb[18];
+	mresp[4] = mcp->mb[19];
+	return rval;
+}
+
+int
+qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mresp)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	DEBUG11(printk("scsi(%ld): entered.\n", vha->host_no));
+
+	memset(mcp->mb, 0 , sizeof(mcp->mb));
+	mcp->mb[0] = MBC_DIAGNOSTIC_ECHO;
+	mcp->mb[1] = mreq->options | BIT_6;	/* BIT_6 specifies 64bit address */
+	if (IS_QLA81XX(ha))
+		mcp->mb[1] |= BIT_15;
+	mcp->mb[2] = IS_QLA81XX(ha) ? vha->fcoe_fcf_idx : 0;
+	mcp->mb[16] = LSW(mreq->rcv_dma);
+	mcp->mb[17] = MSW(mreq->rcv_dma);
+	mcp->mb[6] = LSW(MSD(mreq->rcv_dma));
+	mcp->mb[7] = MSW(MSD(mreq->rcv_dma));
+
+	mcp->mb[10] = LSW(mreq->transfer_size);
+
+	mcp->mb[14] = LSW(mreq->send_dma);
+	mcp->mb[15] = MSW(mreq->send_dma);
+	mcp->mb[20] = LSW(MSD(mreq->send_dma));
+	mcp->mb[21] = MSW(MSD(mreq->send_dma));
+
+	mcp->out_mb = MBX_21|MBX_20|MBX_17|MBX_16|MBX_15|
+	    MBX_14|MBX_10|MBX_7|MBX_6|MBX_1|MBX_0;
+	if (IS_QLA81XX(ha))
+		mcp->out_mb |= MBX_2;
+
+	mcp->in_mb = MBX_0;
+	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) || IS_QLA81XX(ha))
+		mcp->in_mb |= MBX_1;
+	if (IS_QLA81XX(ha))
+		mcp->in_mb |= MBX_3;
+
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN|IOCTL_CMD;
+	mcp->buf_size = mreq->transfer_size;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(printk(KERN_WARNING
+		    "(%ld): failed=%x mb[0]=0x%x mb[1]=0x%x.\n",
+		    vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+	} else {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi(%ld): done.\n", vha->host_no));
+	}
+
+	/* Copy mailbox information */
+	memcpy( mresp, mcp->mb, 32);
+	return rval;
+}
+int
+qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic,
+    uint16_t *cmd_status)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG16(printk("%s(%ld): enable_diag=%d entered.\n", __func__,
+		ha->host_no, enable_diagnostic));
+
+	mcp->mb[0] = MBC_ISP84XX_RESET;
+	mcp->mb[1] = enable_diagnostic;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN|IOCTL_CMD;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	/* Return mailbox statuses. */
+	*cmd_status = mcp->mb[0];
+	if (rval != QLA_SUCCESS)
+		DEBUG16(printk("%s(%ld): failed=%x.\n", __func__, ha->host_no,
+			rval));
+	else
+		DEBUG16(printk("%s(%ld): done.\n", __func__, ha->host_no));
+
+	return rval;
+}
+
+int
 qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 {
 	int rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fe34b7f..15ddfc4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1969,6 +1969,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->max_channel = MAX_BUSES - 1;
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
+	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
 
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
-- 
1.6.2.rc1.30.gd43c

