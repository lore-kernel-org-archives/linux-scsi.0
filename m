From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/5] qla2xxx: Re-organized BSG interface specific code.
Date: Fri, 19 Mar 2010 17:03:58 -0700
Message-ID: <1269043442-2306-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36572 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752275Ab0CTAEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 20:04:05 -0400
In-Reply-To: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

1. Segregate BSG interface specific code to new files.
2. Handle multiple vendor specific commands indepedently.
3. Reorganised support for reset, management and update FCoE firmware commands.
4. Fixed memory leak issue in Loopback.
5. Added new vendor command to support iiDMA using BSG interface.
6. Proper cleanup of dma mapped and dma allocated buffers for BSG request.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/Makefile   |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c |  701 +--------------------------
 drivers/scsi/qla2xxx/qla_bsg.c  | 1039 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h  |  135 +++++
 drivers/scsi/qla2xxx/qla_def.h  |  125 +-----
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 +
 drivers/scsi/qla2xxx/qla_mbx.c  |   49 ++-
 7 files changed, 1229 insertions(+), 830 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_bsg.c
 create mode 100644 drivers/scsi/qla2xxx/qla_bsg.h

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index c51fd1f..1014db6 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,4 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o
+		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 35a3252..8918c2d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -11,9 +11,7 @@
 #include <linux/delay.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
-static int qla84xx_reset(scsi_qla_host_t *, struct msg_echo_lb *, struct fc_bsg_job *);
-int qla84xx_reset_chip(scsi_qla_host_t *, uint16_t, uint16_t *);
-static int qla84xx_mgmt_cmd(scsi_qla_host_t *, struct msg_echo_lb *, struct fc_bsg_job *);
+
 /* SYSFS attributes --------------------------------------------------------- */
 
 static ssize_t
@@ -1824,581 +1822,6 @@ qla24xx_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
-/* BSG support for ELS/CT pass through */
-inline srb_t *
-qla2x00_get_ctx_bsg_sp(scsi_qla_host_t *vha, fc_port_t *fcport, size_t size)
-{
-	srb_t *sp;
-	struct qla_hw_data *ha = vha->hw;
-	struct srb_bsg_ctx *ctx;
-
-	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
-	if (!sp)
-		goto done;
-	ctx = kzalloc(size, GFP_KERNEL);
-	if (!ctx) {
-		mempool_free(sp, ha->srb_mempool);
-		goto done;
-	}
-
-	memset(sp, 0, sizeof(*sp));
-	sp->fcport = fcport;
-	sp->ctx = ctx;
-done:
-	return sp;
-}
-
-static int
-qla2x00_process_els(struct fc_bsg_job *bsg_job)
-{
-	struct fc_rport *rport;
-	fc_port_t *fcport;
-	struct Scsi_Host *host;
-	scsi_qla_host_t *vha;
-	struct qla_hw_data *ha;
-	srb_t *sp;
-	const char *type;
-	int req_sg_cnt, rsp_sg_cnt;
-	int rval =  (DRIVER_ERROR << 16);
-	uint16_t nextlid = 0;
-	struct srb_bsg *els;
-
-	/*  Multiple SG's are not supported for ELS requests */
-        if (bsg_job->request_payload.sg_cnt > 1 ||
-		bsg_job->reply_payload.sg_cnt > 1) {
-		DEBUG2(printk(KERN_INFO
-		    "multiple SG's are not supported for ELS requests"
-		    " [request_sg_cnt: %x reply_sg_cnt: %x]\n",
-		    bsg_job->request_payload.sg_cnt,
-		    bsg_job->reply_payload.sg_cnt));
-		rval = -EPERM;
-		goto done;
-        }
-
-	/* ELS request for rport */
-	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
-		fcport = *(fc_port_t **) rport->dd_data;
-		host = rport_to_shost(rport);
-		vha = shost_priv(host);
-		ha = vha->hw;
-		type = "FC_BSG_RPT_ELS";
-
-		/* make sure the rport is logged in,
-		 * if not perform fabric login
-		 */
-		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "failed to login port %06X for ELS passthru\n",
-			    fcport->d_id.b24));
-			rval = -EIO;
-			goto done;
-		}
-	} else {
-		host = bsg_job->shost;
-		vha = shost_priv(host);
-		ha = vha->hw;
-		type = "FC_BSG_HST_ELS_NOLOGIN";
-
-		/* Allocate a dummy fcport structure, since functions
-		 * preparing the IOCB and mailbox command retrieves port
-		 * specific information from fcport structure. For Host based
-		 * ELS commands there will be no fcport structure allocated
-		 */
-		fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
-		if (!fcport) {
-			rval = -ENOMEM;
-			goto done;
-		}
-
-		/* Initialize all required  fields of fcport */
-		fcport->vha = vha;
-		fcport->vp_idx = vha->vp_idx;
-		fcport->d_id.b.al_pa =
-		    bsg_job->request->rqst_data.h_els.port_id[0];
-		fcport->d_id.b.area =
-		    bsg_job->request->rqst_data.h_els.port_id[1];
-		fcport->d_id.b.domain =
-		    bsg_job->request->rqst_data.h_els.port_id[2];
-		fcport->loop_id =
-		    (fcport->d_id.b.al_pa == 0xFD) ?
-		    NPH_FABRIC_CONTROLLER : NPH_F_PORT;
-	}
-
-	if (!vha->flags.online) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "host not online\n"));
-		rval = -EIO;
-		goto done;
-	}
-
-        req_sg_cnt =
-	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-        if (!req_sg_cnt) {
-		rval = -ENOMEM;
-		goto done_free_fcport;
-	}
-        rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-        if (!rsp_sg_cnt) {
-		rval = -ENOMEM;
-                goto done_free_fcport;
-	}
-
-	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
-	{
-		DEBUG2(printk(KERN_INFO
-		    "dma mapping resulted in different sg counts \
-		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
-		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
-		rval = -EAGAIN;
-                goto done_unmap_sg;
-	}
-
-	/* Alloc SRB structure */
-	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
-	if (!sp) {
-		rval = -ENOMEM;
-                goto done_unmap_sg;
-	}
-
-	els = sp->ctx;
-	els->ctx.type =
-	    (bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
-	    SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
-	els->bsg_job = bsg_job;
-
-	DEBUG2(qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
-	    "portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
-	    bsg_job->request->rqst_data.h_els.command_code,
-	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
-	    fcport->d_id.b.al_pa));
-
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS) {
-		kfree(sp->ctx);
-		mempool_free(sp, ha->srb_mempool);
-		rval = -EIO;
-		goto done_unmap_sg;
-	}
-	return rval;
-
-done_unmap_sg:
-	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-	goto done_free_fcport;
-
-done_free_fcport:
-	if (bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN)
-		kfree(fcport);
-done:
-	return rval;
-}
-
-static int
-qla2x00_process_ct(struct fc_bsg_job *bsg_job)
-{
-	srb_t *sp;
-	struct Scsi_Host *host = bsg_job->shost;
-	scsi_qla_host_t *vha = shost_priv(host);
-	struct qla_hw_data *ha = vha->hw;
-	int rval = (DRIVER_ERROR << 16);
-	int req_sg_cnt, rsp_sg_cnt;
-	uint16_t loop_id;
-	struct fc_port *fcport;
-	char  *type = "FC_BSG_HST_CT";
-	struct srb_bsg *ct;
-
-	/* pass through is supported only for ISP 4Gb or higher */
-        if (!IS_FWI2_CAPABLE(ha)) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "scsi(%ld):Firmware is not capable to support FC "
-		    "CT pass thru\n", vha->host_no));
-		rval = -EPERM;
-                goto done;
-	}
-
-        req_sg_cnt =
-	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-        if (!req_sg_cnt) {
-		rval = -ENOMEM;
-		goto done;
-	}
-
-        rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-            bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-        if (!rsp_sg_cnt) {
-		rval = -ENOMEM;
-                goto done;
-	}
-
-	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
-	{
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "dma mapping resulted in different sg counts \
-		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
-		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
-		rval = -EAGAIN;
-                goto done_unmap_sg;
-	}
-
-	if (!vha->flags.online) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "host not online\n"));
-		rval = -EIO;
-                goto done_unmap_sg;
-	}
-
-	loop_id =
-	    (bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
-	    >> 24;
-	switch (loop_id) {
-		case 0xFC:
-			loop_id = cpu_to_le16(NPH_SNS);
-			break;
-		case 0xFA:
-			loop_id = vha->mgmt_svr_loop_id;
-			break;
-		default:
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "Unknown loop id: %x\n", loop_id));
-			rval = -EINVAL;
-			goto done_unmap_sg;
-	}
-
-	/* Allocate a dummy fcport structure, since functions preparing the
-	 * IOCB and mailbox command retrieves port specific information
-	 * from fcport structure. For Host based ELS commands there will be
-	 * no fcport structure allocated
-	 */
-	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
-	if (!fcport)
-	{
-		rval = -ENOMEM;
-		goto  done_unmap_sg;
-	}
-
-	/* Initialize all required  fields of fcport */
-	fcport->vha = vha;
-	fcport->vp_idx = vha->vp_idx;
-	fcport->d_id.b.al_pa = bsg_job->request->rqst_data.h_ct.port_id[0];
-	fcport->d_id.b.area = bsg_job->request->rqst_data.h_ct.port_id[1];
-	fcport->d_id.b.domain = bsg_job->request->rqst_data.h_ct.port_id[2];
-	fcport->loop_id = loop_id;
-
-	/* Alloc SRB structure */
-	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_bsg));
-	if (!sp) {
-		rval = -ENOMEM;
-		goto done_free_fcport;
-	}
-
-	ct = sp->ctx;
-	ct->ctx.type = SRB_CT_CMD;
-	ct->bsg_job = bsg_job;
-
-	DEBUG2(qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
-	    "portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
-	    (bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
-	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
-	    fcport->d_id.b.al_pa));
-
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS) {
-		kfree(sp->ctx);
-		mempool_free(sp, ha->srb_mempool);
-		rval = -EIO;
-		goto done_free_fcport;
-	}
-	return rval;
-
-done_free_fcport:
-	kfree(fcport);
-done_unmap_sg:
-	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-done:
-	return rval;
-}
-
-static int
-qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
-{
-	struct Scsi_Host *host = bsg_job->shost;
-	scsi_qla_host_t *vha = shost_priv(host);
-	struct qla_hw_data *ha = vha->hw;
-	int rval;
-	uint8_t command_sent;
-	uint32_t vendor_cmd;
-	char *type;
-	struct msg_echo_lb elreq;
-	uint16_t response[MAILBOX_REGISTER_COUNT];
-	uint8_t* fw_sts_ptr;
-	uint8_t *req_data;
-	dma_addr_t req_data_dma;
-	uint32_t req_data_len;
-	uint8_t *rsp_data;
-	dma_addr_t rsp_data_dma;
-	uint32_t rsp_data_len;
-
-	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
-	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
-		rval = -EBUSY;
-		goto done;
-	}
-
-	if (!vha->flags.online) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "host not online\n"));
-		rval = -EIO;
-                goto done;
-	}
-
-        elreq.req_sg_cnt =
-	    dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-        if (!elreq.req_sg_cnt) {
-		rval = -ENOMEM;
-		goto done;
-	}
-        elreq.rsp_sg_cnt =
-	    dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-        if (!elreq.rsp_sg_cnt) {
-		rval = -ENOMEM;
-                goto done;
-	}
-
-	if ((elreq.req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
-	    (elreq.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
-	{
-		DEBUG2(printk(KERN_INFO
-		    "dma mapping resulted in different sg counts \
-		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-		    bsg_job->request_payload.sg_cnt, elreq.req_sg_cnt,
-		    bsg_job->reply_payload.sg_cnt, elreq.rsp_sg_cnt));
-		rval = -EAGAIN;
-                goto done_unmap_sg;
-	}
-	req_data_len = rsp_data_len = bsg_job->request_payload.payload_len;
-	req_data = dma_alloc_coherent(&ha->pdev->dev, req_data_len,
-	    &req_data_dma, GFP_KERNEL);
-
-	rsp_data = dma_alloc_coherent(&ha->pdev->dev, rsp_data_len,
-	    &rsp_data_dma, GFP_KERNEL);
-
-	/* Copy the request buffer in req_data now */
-	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
-	    bsg_job->request_payload.sg_cnt, req_data,
-	    req_data_len);
-
-	elreq.send_dma = req_data_dma;
-	elreq.rcv_dma = rsp_data_dma;
-	elreq.transfer_size = req_data_len;
-
-	/* Vendor cmd : loopback or ECHO diagnostic
-	 * Options:
-	 * 	Loopback : Either internal or external loopback
-	 * 	ECHO: ECHO ELS or Vendor specific FC4  link data
-	 */
-	vendor_cmd = bsg_job->request->rqst_data.h_vendor.vendor_cmd[0];
-	elreq.options =
-	    *(((uint32_t *)bsg_job->request->rqst_data.h_vendor.vendor_cmd)
-	    + 1);
-
-	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
-	case QL_VND_LOOPBACK:
-		if (ha->current_topology != ISP_CFG_F) {
-			type = "FC_BSG_HST_VENDOR_LOOPBACK";
-
-			DEBUG2(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) bsg rqst type: %s vendor rqst type: %x options: %x.\n",
-				vha->host_no, type, vendor_cmd, elreq.options));
-
-			command_sent = INT_DEF_LB_LOOPBACK_CMD;
-			rval = qla2x00_loopback_test(vha, &elreq, response);
-			if (IS_QLA81XX(ha)) {
-				if (response[0] == MBS_COMMAND_ERROR && response[1] == MBS_LB_RESET) {
-					DEBUG2(printk(KERN_ERR "%s(%ld): ABORTing "
-						"ISP\n", __func__, vha->host_no));
-					set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-					qla2xxx_wake_dpc(vha);
-				 }
-			}
-		} else {
-			type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
-			DEBUG2(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) bsg rqst type: %s vendor rqst type: %x options: %x.\n",
-				vha->host_no, type, vendor_cmd, elreq.options));
-
-			command_sent = INT_DEF_LB_ECHO_CMD;
-			rval = qla2x00_echo_test(vha, &elreq, response);
-		}
-		break;
-	case QLA84_RESET:
-		if (!IS_QLA84XX(vha->hw)) {
-			rval = -EINVAL;
-			DEBUG16(printk(
-				"%s(%ld): 8xxx exiting.\n",
-				__func__, vha->host_no));
-			return rval;
-		}
-		rval = qla84xx_reset(vha, &elreq, bsg_job);
-		break;
-	case QLA84_MGMT_CMD:
-		if (!IS_QLA84XX(vha->hw)) {
-			rval = -EINVAL;
-			DEBUG16(printk(
-				"%s(%ld): 8xxx exiting.\n",
-				__func__, vha->host_no));
-			return rval;
-		}
-		rval = qla84xx_mgmt_cmd(vha, &elreq, bsg_job);
-		break;
-	default:
-		rval = -ENOSYS;
-	}
-
-	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-			"scsi(%ld) Vendor request %s failed\n", vha->host_no, type));
-		rval = 0;
-		bsg_job->reply->result = (DID_ERROR << 16);
-		bsg_job->reply->reply_payload_rcv_len = 0;
-		fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
-		memcpy( fw_sts_ptr, response, sizeof(response));
-		fw_sts_ptr += sizeof(response);
-                *fw_sts_ptr = command_sent;
-	} else {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-			"scsi(%ld) Vendor request %s completed\n", vha->host_no, type));
-		rval = bsg_job->reply->result = 0;
-		bsg_job->reply_len = sizeof(struct fc_bsg_reply) + sizeof(response) + sizeof(uint8_t);
-		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
-		fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
-		memcpy(fw_sts_ptr, response, sizeof(response));
-		fw_sts_ptr += sizeof(response);
-		*fw_sts_ptr = command_sent;
-		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
-		bsg_job->reply_payload.sg_cnt, rsp_data,
-		rsp_data_len);
-	}
-	bsg_job->job_done(bsg_job);
-
-done_unmap_sg:
-
-	if(req_data)
-		dma_free_coherent(&ha->pdev->dev, req_data_len,
-			req_data, req_data_dma);
-	dma_unmap_sg(&ha->pdev->dev,
-	    bsg_job->request_payload.sg_list,
-	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-	dma_unmap_sg(&ha->pdev->dev,
-	    bsg_job->reply_payload.sg_list,
-	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-
-done:
-        return rval;
-}
-
-static int
-qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
-{
-        int ret = -EINVAL;
-
-        switch (bsg_job->request->msgcode) {
-		case FC_BSG_RPT_ELS:
-		case FC_BSG_HST_ELS_NOLOGIN:
-			ret = qla2x00_process_els(bsg_job);
-			break;
-		case FC_BSG_HST_CT:
-			ret = qla2x00_process_ct(bsg_job);
-			break;
-		case FC_BSG_HST_VENDOR:
-			ret = qla2x00_process_vendor_specific(bsg_job);
-			break;
-		case FC_BSG_HST_ADD_RPORT:
-		case FC_BSG_HST_DEL_RPORT:
-		case FC_BSG_RPT_CT:
-		default:
-			DEBUG2(printk("qla2xxx: unsupported BSG request\n"));
-			break;
-        }
-	return ret;
-}
-
-static int
-qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
-{
-        scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
-        struct qla_hw_data *ha = vha->hw;
-        srb_t *sp;
-        int cnt, que;
-        unsigned long flags;
-        struct req_que *req;
-	struct srb_bsg *sp_bsg;
-
-	/* find the bsg job from the active list of commands */
-        spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < ha->max_req_queues; que++) {
-		req = ha->req_q_map[que];
-		if (!req)
-			continue;
-
-		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++ ) {
-			sp = req->outstanding_cmds[cnt];
-
-			if (sp) {
-				sp_bsg = (struct srb_bsg*)sp->ctx;
-
-				if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
-				    (sp_bsg->ctx.type == SRB_ELS_CMD_RPT)
-				    || ( sp_bsg->ctx.type == SRB_ELS_CMD_HST)) &&
-				    (sp_bsg->bsg_job == bsg_job)) {
-					if (ha->isp_ops->abort_command(sp)) {
-						DEBUG2(qla_printk(KERN_INFO, ha,
-						"scsi(%ld): mbx abort_command failed\n", vha->host_no));
-						bsg_job->req->errors = bsg_job->reply->result = -EIO;
-					} else {
-						DEBUG2(qla_printk(KERN_INFO, ha,
-						"scsi(%ld): mbx abort_command success\n", vha->host_no));
-						bsg_job->req->errors = bsg_job->reply->result = 0;
-					}
-					goto done;
-				}
-			}
-		}
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	DEBUG2(qla_printk(KERN_INFO, ha,
-		"scsi(%ld) SRB not found to abort\n", vha->host_no));
-	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
-	return 0;
-
-done:
-	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
-		kfree(sp->fcport);
-	kfree(sp->ctx);
-	mempool_free(sp, ha->srb_mempool);
-	return 0;
-}
-
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -2514,125 +1937,3 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 		speed = FC_PORTSPEED_1GBIT;
 	fc_host_supported_speeds(vha->host) = speed;
 }
-static int
-qla84xx_reset(scsi_qla_host_t *ha, struct msg_echo_lb *mreq, struct fc_bsg_job *bsg_job)
-{
-	int             ret = 0;
-	int             cmd;
-	uint16_t        cmd_status;
-
-	DEBUG16(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	cmd = (*((bsg_job->request->rqst_data.h_vendor.vendor_cmd) + 2))
-			== A84_RESET_FLAG_ENABLE_DIAG_FW ?
-				A84_ISSUE_RESET_DIAG_FW : A84_ISSUE_RESET_OP_FW;
-	ret = qla84xx_reset_chip(ha, cmd == A84_ISSUE_RESET_DIAG_FW,
-	&cmd_status);
-	return ret;
-}
-
-static int
-qla84xx_mgmt_cmd(scsi_qla_host_t *ha, struct msg_echo_lb *mreq, struct fc_bsg_job *bsg_job)
-{
-	struct access_chip_84xx *mn;
-	dma_addr_t mn_dma, mgmt_dma;
-	void *mgmt_b = NULL;
-	int ret = 0;
-	int rsp_hdr_len, len = 0;
-	struct qla84_msg_mgmt *ql84_mgmt;
-
-	ql84_mgmt = (struct qla84_msg_mgmt *) vmalloc(sizeof(struct qla84_msg_mgmt));
-	ql84_mgmt->cmd =
-		*((uint16_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 2));
-	ql84_mgmt->mgmtp.u.mem.start_addr =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 3));
-	ql84_mgmt->len =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 4));
-	ql84_mgmt->mgmtp.u.config.id =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 5));
-	ql84_mgmt->mgmtp.u.config.param0 =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 6));
-	ql84_mgmt->mgmtp.u.config.param1 =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 7));
-	ql84_mgmt->mgmtp.u.info.type =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 8));
-	ql84_mgmt->mgmtp.u.info.context =
-		*((uint32_t *)(bsg_job->request->rqst_data.h_vendor.vendor_cmd + 9));
-
-	rsp_hdr_len = bsg_job->request_payload.payload_len;
-
-	mn = dma_pool_alloc(ha->hw->s_dma_pool, GFP_KERNEL, &mn_dma);
-	if (mn == NULL) {
-		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw buffer "
-		"failed%lu\n", __func__, ha->host_no));
-		return -ENOMEM;
-	}
-
-	memset(mn, 0, sizeof (struct access_chip_84xx));
-
-	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
-	mn->entry_count = 1;
-
-	switch (ql84_mgmt->cmd) {
-	case QLA84_MGMT_READ_MEM:
-		mn->options = cpu_to_le16(ACO_DUMP_MEMORY);
-		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.mem.start_addr);
-		break;
-	case QLA84_MGMT_WRITE_MEM:
-		mn->options = cpu_to_le16(ACO_LOAD_MEMORY);
-		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.mem.start_addr);
-		break;
-	case QLA84_MGMT_CHNG_CONFIG:
-		mn->options = cpu_to_le16(ACO_CHANGE_CONFIG_PARAM);
-		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.id);
-		mn->parameter2 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.param0);
-		mn->parameter3 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.param1);
-		break;
-	case QLA84_MGMT_GET_INFO:
-		mn->options = cpu_to_le16(ACO_REQUEST_INFO);
-		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.info.type);
-		mn->parameter2 = cpu_to_le32(ql84_mgmt->mgmtp.u.info.context);
-		break;
-	default:
-		ret = -EIO;
-		goto exit_mgmt0;
-	}
-
-	if ((len == ql84_mgmt->len) &&
-		ql84_mgmt->cmd != QLA84_MGMT_CHNG_CONFIG) {
-		mgmt_b = dma_alloc_coherent(&ha->hw->pdev->dev, len,
-				&mgmt_dma, GFP_KERNEL);
-		if (mgmt_b == NULL) {
-			DEBUG2(printk(KERN_ERR "%s: dma alloc mgmt_b "
-			"failed%lu\n", __func__, ha->host_no));
-			ret = -ENOMEM;
-			goto exit_mgmt0;
-		}
-		mn->total_byte_cnt = cpu_to_le32(ql84_mgmt->len);
-		mn->dseg_count = cpu_to_le16(1);
-		mn->dseg_address[0] = cpu_to_le32(LSD(mgmt_dma));
-		mn->dseg_address[1] = cpu_to_le32(MSD(mgmt_dma));
-		mn->dseg_length = cpu_to_le32(len);
-
-		if (ql84_mgmt->cmd == QLA84_MGMT_WRITE_MEM) {
-			memcpy(mgmt_b, ql84_mgmt->payload, len);
-		}
-	}
-
-	ret = qla2x00_issue_iocb(ha, mn, mn_dma, 0);
-	if ((ret != QLA_SUCCESS) || (ql84_mgmt->cmd == QLA84_MGMT_WRITE_MEM)
-		|| (ql84_mgmt->cmd == QLA84_MGMT_CHNG_CONFIG)) {
-			if (ret != QLA_SUCCESS)
-				DEBUG2(printk(KERN_ERR "%s(%lu): failed\n",
-					__func__, ha->host_no));
-	} else if ((ql84_mgmt->cmd == QLA84_MGMT_READ_MEM) ||
-			(ql84_mgmt->cmd == QLA84_MGMT_GET_INFO)) {
-	}
-
-	if (mgmt_b)
-		dma_free_coherent(&ha->hw->pdev->dev, len, mgmt_b, mgmt_dma);
-
-exit_mgmt0:
-	dma_pool_free(ha->hw->s_dma_pool, mn, mn_dma);
-	return ret;
-}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
new file mode 100644
index 0000000..dfad295
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -0,0 +1,1039 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2008 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include "qla_def.h"
+
+#include <linux/kthread.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+
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
+		sp = NULL;
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
+	if (bsg_job->request_payload.sg_cnt > 1 ||
+		bsg_job->reply_payload.sg_cnt > 1) {
+		DEBUG2(printk(KERN_INFO
+			"multiple SG's are not supported for ELS requests"
+			" [request_sg_cnt: %x reply_sg_cnt: %x]\n",
+			bsg_job->request_payload.sg_cnt,
+			bsg_job->reply_payload.sg_cnt));
+		rval = -EPERM;
+		goto done;
+	}
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
+		/* make sure the rport is logged in,
+		 * if not perform fabric login
+		 */
+		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+			"failed to login port %06X for ELS passthru\n",
+			fcport->d_id.b24));
+			rval = -EIO;
+			goto done;
+		}
+	} else {
+		host = bsg_job->shost;
+		vha = shost_priv(host);
+		ha = vha->hw;
+		type = "FC_BSG_HST_ELS_NOLOGIN";
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
+			bsg_job->request->rqst_data.h_els.port_id[0];
+		fcport->d_id.b.area =
+			bsg_job->request->rqst_data.h_els.port_id[1];
+		fcport->d_id.b.domain =
+			bsg_job->request->rqst_data.h_els.port_id[2];
+		fcport->loop_id =
+			(fcport->d_id.b.al_pa == 0xFD) ?
+			NPH_FABRIC_CONTROLLER : NPH_F_PORT;
+	}
+
+	if (!vha->flags.online) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "host not online\n"));
+		rval = -EIO;
+		goto done;
+	}
+
+	req_sg_cnt =
+		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	if (!req_sg_cnt) {
+		rval = -ENOMEM;
+		goto done_free_fcport;
+	}
+        rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+        if (!rsp_sg_cnt) {
+		rval = -ENOMEM;
+		goto done_free_fcport;
+	}
+
+	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
+	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
+	{
+		DEBUG2(printk(KERN_INFO
+			"dma mapping resulted in different sg counts \
+			[request_sg_cnt: %x dma_request_sg_cnt: %x\
+			reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+			bsg_job->request_payload.sg_cnt, req_sg_cnt,
+			bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		rval = -EAGAIN;
+		goto done_unmap_sg;
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
+		(bsg_job->request->msgcode == FC_BSG_RPT_ELS ?
+		SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
+	els->bsg_job = bsg_job;
+
+	DEBUG2(qla_printk(KERN_INFO, ha,
+		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
+		"portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
+		bsg_job->request->rqst_data.h_els.command_code,
+		fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+		fcport->d_id.b.al_pa));
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
+			"scsi(%ld):Firmware is not capable to support FC "
+			"CT pass thru\n", vha->host_no));
+		rval = -EPERM;
+		goto done;
+	}
+
+	req_sg_cnt =
+		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+        if (!req_sg_cnt) {
+		rval = -ENOMEM;
+		goto done;
+	}
+
+	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	if (!rsp_sg_cnt) {
+		rval = -ENOMEM;
+		goto done;
+	}
+
+	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
+		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt))
+	{
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"[request_sg_cnt: %x dma_request_sg_cnt: %x\
+			reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+			bsg_job->request_payload.sg_cnt, req_sg_cnt,
+			bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		rval = -EAGAIN;
+                goto done_unmap_sg;
+	}
+
+	if (!vha->flags.online) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"host not online\n"));
+		rval = -EIO;
+		goto done_unmap_sg;
+	}
+
+	loop_id =
+		(bsg_job->request->rqst_data.h_ct.preamble_word1 & 0xFF000000)
+			>> 24;
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
+		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
+		"portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
+		(bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
+		fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+		fcport->d_id.b.al_pa));
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
+		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+done:
+	return rval;
+}
+
+static int
+qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval;
+	uint8_t command_sent;
+	char *type;
+	struct msg_echo_lb elreq;
+	uint16_t response[MAILBOX_REGISTER_COUNT];
+	uint8_t* fw_sts_ptr;
+	uint8_t *req_data = NULL;
+	dma_addr_t req_data_dma;
+	uint32_t req_data_len;
+	uint8_t *rsp_data = NULL;
+	dma_addr_t rsp_data_dma;
+	uint32_t rsp_data_len;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		return -EBUSY;
+
+	if (!vha->flags.online) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "host not online\n"));
+		return -EIO;
+	}
+
+	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
+		bsg_job->request_payload.sg_list, bsg_job->request_payload.sg_cnt,
+		DMA_TO_DEVICE);
+
+	if (!elreq.req_sg_cnt)
+		return -ENOMEM;
+
+	elreq.rsp_sg_cnt = dma_map_sg(&ha->pdev->dev,
+		bsg_job->reply_payload.sg_list, bsg_job->reply_payload.sg_cnt,
+		DMA_FROM_DEVICE);
+
+	if (!elreq.rsp_sg_cnt) {
+		rval = -ENOMEM;
+		goto done_unmap_req_sg;
+}
+
+	if ((elreq.req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
+		(elreq.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
+		DEBUG2(printk(KERN_INFO
+			"dma mapping resulted in different sg counts "
+			"[request_sg_cnt: %x dma_request_sg_cnt: %x "
+			"reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+			bsg_job->request_payload.sg_cnt, elreq.req_sg_cnt,
+			bsg_job->reply_payload.sg_cnt, elreq.rsp_sg_cnt));
+		rval = -EAGAIN;
+		goto done_unmap_sg;
+	}
+	req_data_len = rsp_data_len = bsg_job->request_payload.payload_len;
+	req_data = dma_alloc_coherent(&ha->pdev->dev, req_data_len,
+		&req_data_dma, GFP_KERNEL);
+	if (!req_data) {
+		DEBUG2(printk(KERN_ERR "%s: dma alloc for req_data "
+			"failed for host=%lu\n", __func__, vha->host_no));
+		rval = -ENOMEM;
+		goto done_unmap_sg;
+	}
+
+	rsp_data = dma_alloc_coherent(&ha->pdev->dev, rsp_data_len,
+		&rsp_data_dma, GFP_KERNEL);
+	if (!rsp_data) {
+		DEBUG2(printk(KERN_ERR "%s: dma alloc for rsp_data "
+			"failed for host=%lu\n", __func__, vha->host_no));
+		rval = -ENOMEM;
+		goto done_free_dma_req;
+	}
+
+	/* Copy the request buffer in req_data now */
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, req_data, req_data_len);
+
+	elreq.send_dma = req_data_dma;
+	elreq.rcv_dma = rsp_data_dma;
+	elreq.transfer_size = req_data_len;
+
+	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+
+	if (ha->current_topology != ISP_CFG_F) {
+		type = "FC_BSG_HST_VENDOR_LOOPBACK";
+		DEBUG2(qla_printk(KERN_INFO, ha,
+			"scsi(%ld) bsg rqst type: %s\n",
+			vha->host_no, type));
+
+		command_sent = INT_DEF_LB_LOOPBACK_CMD;
+		rval = qla2x00_loopback_test(vha, &elreq, response);
+		if (IS_QLA81XX(ha)) {
+			if (response[0] == MBS_COMMAND_ERROR &&
+				response[1] == MBS_LB_RESET) {
+				DEBUG2(printk(KERN_ERR "%s(%ld): ABORTing "
+				"ISP\n", __func__, vha->host_no));
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+			}
+		}
+	} else {
+		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "scsi(%ld) bsg rqst type: %s\n" ,vha->host_no, type));
+		command_sent = INT_DEF_LB_ECHO_CMD;
+		rval = qla2x00_echo_test(vha, &elreq, response);
+	}
+
+	if (rval) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+			"request %s failed\n", vha->host_no, type));
+
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+			sizeof(struct fc_bsg_reply);
+
+		memcpy(fw_sts_ptr, response, sizeof(response));
+		fw_sts_ptr += sizeof(response);
+                *fw_sts_ptr = command_sent;
+		rval = 0;
+		bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_job->reply->result = (DID_ERROR << 16);
+	} else {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+			"request %s completed\n", vha->host_no, type));
+
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
+			sizeof(response) + sizeof(uint8_t);
+		bsg_job->reply->reply_payload_rcv_len =
+			bsg_job->reply_payload.payload_len;
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+			sizeof(struct fc_bsg_reply);
+		memcpy(fw_sts_ptr, response, sizeof(response));
+		fw_sts_ptr += sizeof(response);
+		*fw_sts_ptr = command_sent;
+		bsg_job->reply->result = DID_OK;
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			bsg_job->reply_payload.sg_cnt, rsp_data,
+			rsp_data_len);
+	}
+	bsg_job->job_done(bsg_job);
+
+	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
+		rsp_data, rsp_data_dma);
+done_free_dma_req:
+	dma_free_coherent(&ha->pdev->dev, req_data_len,
+		req_data, req_data_dma);
+done_unmap_sg:
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+done_unmap_req_sg:
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+        return rval;
+}
+
+static int
+qla84xx_reset(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval = 0;
+	uint32_t flag;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		return -EBUSY;
+
+	if (!IS_QLA84XX(ha)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld): Not 84xx, "
+		   "exiting.\n", vha->host_no));
+		return -EINVAL;
+	}
+
+	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+
+	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
+
+	if (rval) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+		    "request 84xx reset failed\n", vha->host_no));
+		rval = bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_job->reply->result = (DID_ERROR << 16);
+
+	} else {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+		    "request 84xx reset completed\n", vha->host_no));
+		bsg_job->reply->result = DID_OK;
+	}
+
+	bsg_job->job_done(bsg_job);
+	return rval;
+}
+
+static int
+qla84xx_updatefw(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct verify_chip_entry_84xx *mn = NULL;
+	dma_addr_t mn_dma, fw_dma;
+	void *fw_buf = NULL;
+	int rval = 0;
+	uint32_t sg_cnt;
+	uint32_t data_len;
+	uint16_t options;
+	uint32_t flag;
+	uint32_t fw_ver;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		return -EBUSY;
+
+	if (!IS_QLA84XX(ha)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld): Not 84xx, "
+			"exiting.\n", vha->host_no));
+		return -EINVAL;
+	}
+
+	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	if (!sg_cnt)
+		return -ENOMEM;
+
+	if (sg_cnt != bsg_job->request_payload.sg_cnt) {
+		DEBUG2(printk(KERN_INFO
+			"dma mapping resulted in different sg counts "
+			"request_sg_cnt: %x dma_request_sg_cnt: %x ",
+			bsg_job->request_payload.sg_cnt, sg_cnt));
+		rval = -EAGAIN;
+		goto done_unmap_sg;
+	}
+
+	data_len = bsg_job->request_payload.payload_len;
+	fw_buf = dma_alloc_coherent(&ha->pdev->dev, data_len,
+		&fw_dma, GFP_KERNEL);
+	if (!fw_buf) {
+		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw_buf "
+			"failed for host=%lu\n", __func__, vha->host_no));
+		rval = -ENOMEM;
+		goto done_unmap_sg;
+	}
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, fw_buf, data_len);
+
+	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
+	if (!mn) {
+		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw buffer "
+			"failed for host=%lu\n", __func__, vha->host_no));
+		rval = -ENOMEM;
+		goto done_free_fw_buf;
+	}
+
+	flag = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	fw_ver = le32_to_cpu(*((uint32_t *)((uint32_t *)fw_buf + 2)));
+
+	memset(mn, 0, sizeof(struct access_chip_84xx));
+	mn->entry_type = VERIFY_CHIP_IOCB_TYPE;
+	mn->entry_count = 1;
+
+	options = VCO_FORCE_UPDATE | VCO_END_OF_DATA;
+	if (flag == A84_ISSUE_UPDATE_DIAGFW_CMD)
+		options |= VCO_DIAG_FW;
+
+	mn->options = cpu_to_le16(options);
+	mn->fw_ver =  cpu_to_le32(fw_ver);
+	mn->fw_size =  cpu_to_le32(data_len);
+	mn->fw_seq_size =  cpu_to_le32(data_len);
+	mn->dseg_address[0] = cpu_to_le32(LSD(fw_dma));
+	mn->dseg_address[1] = cpu_to_le32(MSD(fw_dma));
+	mn->dseg_length = cpu_to_le32(data_len);
+	mn->data_seg_cnt = cpu_to_le16(1);
+
+	rval = qla2x00_issue_iocb_timeout(vha, mn, mn_dma, 0, 120);
+
+	if (rval) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+			"request 84xx updatefw failed\n", vha->host_no));
+
+		rval = bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_job->reply->result = (DID_ERROR << 16);
+
+	} else {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+			"request 84xx updatefw completed\n", vha->host_no));
+
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		bsg_job->reply->result = DID_OK;
+	}
+
+	bsg_job->job_done(bsg_job);
+	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
+
+done_free_fw_buf:
+	dma_free_coherent(&ha->pdev->dev, data_len, fw_buf, fw_dma);
+
+done_unmap_sg:
+	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	return rval;
+}
+
+static int
+qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	struct access_chip_84xx *mn = NULL;
+	dma_addr_t mn_dma, mgmt_dma;
+	void *mgmt_b = NULL;
+	int rval = 0;
+	struct qla_bsg_a84_mgmt *ql84_mgmt;
+	uint32_t sg_cnt;
+	uint32_t data_len;
+	uint32_t dma_direction = DMA_NONE;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		return -EBUSY;
+
+	if (!IS_QLA84XX(ha)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld): Not 84xx, "
+			"exiting.\n", vha->host_no));
+		return -EINVAL;
+	}
+
+	ql84_mgmt = (struct qla_bsg_a84_mgmt *)((char *)bsg_job->request +
+		sizeof(struct fc_bsg_request));
+	if (!ql84_mgmt) {
+		DEBUG2(printk("%s(%ld): mgmt header not provided, exiting.\n",
+			__func__, vha->host_no));
+		return -EINVAL;
+	}
+
+	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
+	if (!mn) {
+		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw buffer "
+			"failed for host=%lu\n", __func__, vha->host_no));
+		return -ENOMEM;
+	}
+
+	memset(mn, 0, sizeof(struct access_chip_84xx));
+	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
+	mn->entry_count = 1;
+
+	switch (ql84_mgmt->mgmt.cmd) {
+	case QLA84_MGMT_READ_MEM:
+	case QLA84_MGMT_GET_INFO:
+		sg_cnt = dma_map_sg(&ha->pdev->dev,
+			bsg_job->reply_payload.sg_list,
+			bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+		if (!sg_cnt) {
+			rval = -ENOMEM;
+			goto exit_mgmt;
+		}
+
+		dma_direction = DMA_FROM_DEVICE;
+
+		if (sg_cnt != bsg_job->reply_payload.sg_cnt) {
+			DEBUG2(printk(KERN_INFO
+				"dma mapping resulted in different sg counts "
+				"reply_sg_cnt: %x dma_reply_sg_cnt: %x\n",
+				bsg_job->reply_payload.sg_cnt, sg_cnt));
+			rval = -EAGAIN;
+			goto done_unmap_sg;
+		}
+
+		data_len = bsg_job->reply_payload.payload_len;
+
+		mgmt_b = dma_alloc_coherent(&ha->pdev->dev, data_len,
+		    &mgmt_dma, GFP_KERNEL);
+		if (!mgmt_b) {
+			DEBUG2(printk(KERN_ERR "%s: dma alloc for mgmt_b "
+				"failed for host=%lu\n",
+				__func__, vha->host_no));
+			rval = -ENOMEM;
+			goto done_unmap_sg;
+		}
+
+		if (ql84_mgmt->mgmt.cmd == QLA84_MGMT_READ_MEM) {
+			mn->options = cpu_to_le16(ACO_DUMP_MEMORY);
+			mn->parameter1 =
+				cpu_to_le32(
+				ql84_mgmt->mgmt.mgmtp.u.mem.start_addr);
+
+		} else if (ql84_mgmt->mgmt.cmd == QLA84_MGMT_GET_INFO) {
+			mn->options = cpu_to_le16(ACO_REQUEST_INFO);
+			mn->parameter1 =
+				cpu_to_le32(ql84_mgmt->mgmt.mgmtp.u.info.type);
+
+			mn->parameter2 =
+				cpu_to_le32(
+				ql84_mgmt->mgmt.mgmtp.u.info.context);
+		}
+		break;
+
+	case QLA84_MGMT_WRITE_MEM:
+		sg_cnt = dma_map_sg(&ha->pdev->dev,
+			bsg_job->request_payload.sg_list,
+			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+		if (!sg_cnt) {
+			rval = -ENOMEM;
+			goto exit_mgmt;
+		}
+
+		dma_direction = DMA_TO_DEVICE;
+
+		if (sg_cnt != bsg_job->request_payload.sg_cnt) {
+			DEBUG2(printk(KERN_INFO
+				"dma mapping resulted in different sg counts "
+				"request_sg_cnt: %x dma_request_sg_cnt: %x ",
+				bsg_job->request_payload.sg_cnt, sg_cnt));
+			rval = -EAGAIN;
+			goto done_unmap_sg;
+		}
+
+		data_len = bsg_job->request_payload.payload_len;
+		mgmt_b = dma_alloc_coherent(&ha->pdev->dev, data_len,
+			&mgmt_dma, GFP_KERNEL);
+		if (!mgmt_b) {
+			DEBUG2(printk(KERN_ERR "%s: dma alloc for mgmt_b "
+				"failed for host=%lu\n",
+				__func__, vha->host_no));
+			rval = -ENOMEM;
+			goto done_unmap_sg;
+		}
+
+		sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			bsg_job->request_payload.sg_cnt, mgmt_b, data_len);
+
+		mn->options = cpu_to_le16(ACO_LOAD_MEMORY);
+		mn->parameter1 =
+			cpu_to_le32(ql84_mgmt->mgmt.mgmtp.u.mem.start_addr);
+		break;
+
+	case QLA84_MGMT_CHNG_CONFIG:
+		mn->options = cpu_to_le16(ACO_CHANGE_CONFIG_PARAM);
+		mn->parameter1 =
+			cpu_to_le32(ql84_mgmt->mgmt.mgmtp.u.config.id);
+
+		mn->parameter2 =
+			cpu_to_le32(ql84_mgmt->mgmt.mgmtp.u.config.param0);
+
+		mn->parameter3 =
+			cpu_to_le32(ql84_mgmt->mgmt.mgmtp.u.config.param1);
+		break;
+
+	default:
+		rval = -EIO;
+		goto exit_mgmt;
+	}
+
+	if (ql84_mgmt->mgmt.cmd != QLA84_MGMT_CHNG_CONFIG) {
+		mn->total_byte_cnt = cpu_to_le32(ql84_mgmt->mgmt.len);
+		mn->dseg_count = cpu_to_le16(1);
+		mn->dseg_address[0] = cpu_to_le32(LSD(mgmt_dma));
+		mn->dseg_address[1] = cpu_to_le32(MSD(mgmt_dma));
+		mn->dseg_length = cpu_to_le32(ql84_mgmt->mgmt.len);
+	}
+
+	rval = qla2x00_issue_iocb(vha, mn, mn_dma, 0);
+
+	if (rval) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+			"request 84xx mgmt failed\n", vha->host_no));
+
+		rval = bsg_job->reply->reply_payload_rcv_len = 0;
+		bsg_job->reply->result = (DID_ERROR << 16);
+
+	} else {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
+			"request 84xx mgmt completed\n", vha->host_no));
+
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		bsg_job->reply->result = DID_OK;
+
+		if ((ql84_mgmt->mgmt.cmd == QLA84_MGMT_READ_MEM) ||
+			(ql84_mgmt->mgmt.cmd == QLA84_MGMT_GET_INFO)) {
+			bsg_job->reply->reply_payload_rcv_len =
+				bsg_job->reply_payload.payload_len;
+
+			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+				bsg_job->reply_payload.sg_cnt, mgmt_b, data_len);
+		}
+	}
+
+	bsg_job->job_done(bsg_job);
+	dma_free_coherent(&ha->pdev->dev, data_len, mgmt_b, mgmt_dma);
+
+done_unmap_sg:
+	if (dma_direction == DMA_TO_DEVICE)
+		dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	else if (dma_direction == DMA_FROM_DEVICE)
+		dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+			bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+exit_mgmt:
+	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
+
+	return rval;
+}
+
+static int
+qla24xx_iidma(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval = 0;
+	struct qla_port_param *port_param = NULL;
+	fc_port_t *fcport = NULL;
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	uint8_t *rsp_ptr = NULL;
+
+	bsg_job->reply->reply_payload_rcv_len = 0;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		return -EBUSY;
+
+	if (!IS_IIDMA_CAPABLE(vha->hw)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha, "%s(%lu): iiDMA not "
+			"supported\n",  __func__, vha->host_no));
+		return -EINVAL;
+	}
+
+	port_param = (struct qla_port_param *)((char *)bsg_job->request +
+		sizeof(struct fc_bsg_request));
+	if (!port_param) {
+		DEBUG2(printk("%s(%ld): port_param header not provided, "
+			"exiting.\n", __func__, vha->host_no));
+		return -EINVAL;
+	}
+
+	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
+		DEBUG2(printk(KERN_ERR "%s(%ld): Invalid destination type\n",
+			__func__, vha->host_no));
+		return -EINVAL;
+	}
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (fcport->port_type != FCT_TARGET)
+			continue;
+
+		if (memcmp(port_param->fc_scsi_addr.dest_addr.wwpn,
+			fcport->port_name, sizeof(fcport->port_name)))
+			continue;
+		break;
+	}
+
+	if (!fcport) {
+		DEBUG2(printk(KERN_ERR "%s(%ld): Failed to find port\n",
+			__func__, vha->host_no));
+		return -EINVAL;
+	}
+
+	if (port_param->mode)
+		rval = qla2x00_set_idma_speed(vha, fcport->loop_id,
+			port_param->speed, mb);
+	else
+		rval = qla2x00_get_idma_speed(vha, fcport->loop_id,
+			&port_param->speed, mb);
+
+	if (rval) {
+		DEBUG16(printk(KERN_ERR "scsi(%ld): iIDMA cmd failed for "
+			"%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x %04x.\n",
+			vha->host_no, fcport->port_name[0],
+			fcport->port_name[1],
+			fcport->port_name[2], fcport->port_name[3],
+			fcport->port_name[4], fcport->port_name[5],
+			fcport->port_name[6], fcport->port_name[7], rval,
+			fcport->fp_speed, mb[0], mb[1]));
+		rval = 0;
+		bsg_job->reply->result = (DID_ERROR << 16);
+
+	} else {
+		if (!port_param->mode) {
+			bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
+				sizeof(struct qla_port_param);
+
+			rsp_ptr = ((uint8_t *)bsg_job->reply) +
+				sizeof(struct fc_bsg_reply);
+
+			memcpy(rsp_ptr, port_param,
+				sizeof(struct qla_port_param));
+		}
+
+		bsg_job->reply->result = DID_OK;
+	}
+
+	bsg_job->job_done(bsg_job);
+	return rval;
+}
+
+static int
+qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
+{
+	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
+	case QL_VND_LOOPBACK:
+		return qla2x00_process_loopback(bsg_job);
+
+	case QL_VND_A84_RESET:
+		return qla84xx_reset(bsg_job);
+
+	case QL_VND_A84_UPDATE_FW:
+		return qla84xx_updatefw(bsg_job);
+
+	case QL_VND_A84_MGMT_CMD:
+		return qla84xx_mgmt_cmd(bsg_job);
+
+	case QL_VND_IIDMA:
+		return qla24xx_iidma(bsg_job);
+
+	default:
+		bsg_job->reply->result = (DID_ERROR << 16);
+		bsg_job->job_done(bsg_job);
+		return -ENOSYS;
+	}
+}
+
+int
+qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
+{
+	int ret = -EINVAL;
+
+	switch (bsg_job->request->msgcode) {
+	case FC_BSG_RPT_ELS:
+	case FC_BSG_HST_ELS_NOLOGIN:
+		ret = qla2x00_process_els(bsg_job);
+		break;
+	case FC_BSG_HST_CT:
+		ret = qla2x00_process_ct(bsg_job);
+		break;
+	case FC_BSG_HST_VENDOR:
+		ret = qla2x00_process_vendor_specific(bsg_job);
+		break;
+	case FC_BSG_HST_ADD_RPORT:
+	case FC_BSG_HST_DEL_RPORT:
+	case FC_BSG_RPT_CT:
+	default:
+		DEBUG2(printk("qla2xxx: unsupported BSG request\n"));
+		break;
+        }
+	return ret;
+}
+
+int
+qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
+{
+	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	int cnt, que;
+	unsigned long flags;
+	struct req_que *req;
+	struct srb_bsg *sp_bsg;
+
+	/* find the bsg job from the active list of commands */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (que = 0; que < ha->max_req_queues; que++) {
+		req = ha->req_q_map[que];
+		if (!req)
+			continue;
+
+		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++ ) {
+			sp = req->outstanding_cmds[cnt];
+
+			if (sp) {
+				sp_bsg = (struct srb_bsg*)sp->ctx;
+
+				if (((sp_bsg->ctx.type == SRB_CT_CMD) ||
+					(sp_bsg->ctx.type == SRB_ELS_CMD_HST))
+					&& (sp_bsg->bsg_job == bsg_job)) {
+					if (ha->isp_ops->abort_command(sp)) {
+						DEBUG2(qla_printk(KERN_INFO, ha,
+						"scsi(%ld): mbx abort_command failed\n", vha->host_no));
+						bsg_job->req->errors =
+						bsg_job->reply->result = -EIO;
+					} else {
+						DEBUG2(qla_printk(KERN_INFO, ha,
+						"scsi(%ld): mbx abort_command success\n", vha->host_no));
+						bsg_job->req->errors =
+						bsg_job->reply->result = 0;
+					}
+					goto done;
+				}
+			}
+		}
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	DEBUG2(qla_printk(KERN_INFO, ha,
+		"scsi(%ld) SRB not found to abort\n", vha->host_no));
+	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
+	return 0;
+
+done:
+	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
+		kfree(sp->fcport);
+	kfree(sp->ctx);
+	mempool_free(sp, ha->srb_mempool);
+	return 0;
+}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
new file mode 100644
index 0000000..76ed92d
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -0,0 +1,135 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2008 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#ifndef __QLA_BSG_H
+#define __QLA_BSG_H
+
+/* BSG Vendor specific commands */
+#define QL_VND_LOOPBACK		0x01
+#define QL_VND_A84_RESET	0x02
+#define QL_VND_A84_UPDATE_FW	0x03
+#define QL_VND_A84_MGMT_CMD	0x04
+#define QL_VND_IIDMA		0x05
+#define QL_VND_FCP_PRIO_CFG_CMD	0x06
+
+/* BSG definations for interpreting CommandSent field */
+#define INT_DEF_LB_LOOPBACK_CMD         0
+#define INT_DEF_LB_ECHO_CMD             1
+
+/* BSG Vendor specific definations */
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
+struct qla_bsg_a84_mgmt {
+	struct qla84_msg_mgmt mgmt;
+} __attribute__ ((packed));
+
+struct qla_scsi_addr {
+	uint16_t bus;
+	uint16_t target;
+} __attribute__ ((packed));
+
+struct qla_ext_dest_addr {
+	union {
+		uint8_t wwnn[8];
+		uint8_t wwpn[8];
+		uint8_t id[4];
+		struct qla_scsi_addr scsi_addr;
+	} dest_addr;
+	uint16_t dest_type;
+#define	EXT_DEF_TYPE_WWPN	2
+	uint16_t lun;
+	uint16_t padding[2];
+} __attribute__ ((packed));
+
+struct qla_port_param {
+	struct qla_ext_dest_addr fc_scsi_addr;
+	uint16_t mode;
+	uint16_t speed;
+} __attribute__ ((packed));
+#endif
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index afa9561..608397b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -33,6 +33,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
 
+#include "qla_bsg.h"
 #define QLA2XXX_DRIVER_NAME  "qla2xxx"
 
 /*
@@ -2797,128 +2798,4 @@ typedef struct scsi_qla_host {
 #include "qla_inline.h"
 
 #define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
-
-/*
- * BSG Vendor specific commands
- */
-
-#define QL_VND_LOOPBACK		0x01
-#define QLA84_RESET		0x02
-#define QLA84_UPDATE_FW		0x03
-#define QLA84_MGMT_CMD		0x04
-
-/* BSG definations for interpreting CommandSent field */
-#define INT_DEF_LB_LOOPBACK_CMD         0
-#define INT_DEF_LB_ECHO_CMD             1
-
-/* BSG Vendor specific definations */
-typedef struct _A84_RESET {
-	uint16_t Flags;
-	uint16_t Reserved;
-#define A84_RESET_FLAG_ENABLE_DIAG_FW   1
-} __attribute__((packed)) A84_RESET, *PA84_RESET;
-
-#define A84_ISSUE_WRITE_TYPE_CMD        0
-#define A84_ISSUE_READ_TYPE_CMD         1
-#define A84_CLEANUP_CMD                 2
-#define A84_ISSUE_RESET_OP_FW           3
-#define A84_ISSUE_RESET_DIAG_FW         4
-#define A84_ISSUE_UPDATE_OPFW_CMD       5
-#define A84_ISSUE_UPDATE_DIAGFW_CMD     6
-
-struct qla84_mgmt_param {
-	union {
-		struct {
-			uint32_t start_addr;
-		} mem; /* for QLA84_MGMT_READ/WRITE_MEM */
-		struct {
-			uint32_t id;
-#define QLA84_MGMT_CONFIG_ID_UIF        1
-#define QLA84_MGMT_CONFIG_ID_FCOE_COS   2
-#define QLA84_MGMT_CONFIG_ID_PAUSE      3
-#define QLA84_MGMT_CONFIG_ID_TIMEOUTS   4
-
-		uint32_t param0;
-		uint32_t param1;
-	} config; /* for QLA84_MGMT_CHNG_CONFIG */
-
-	struct {
-		uint32_t type;
-#define QLA84_MGMT_INFO_CONFIG_LOG_DATA         1 /* Get Config Log Data */
-#define QLA84_MGMT_INFO_LOG_DATA                2 /* Get Log Data */
-#define QLA84_MGMT_INFO_PORT_STAT               3 /* Get Port Statistics */
-#define QLA84_MGMT_INFO_LIF_STAT                4 /* Get LIF Statistics  */
-#define QLA84_MGMT_INFO_ASIC_STAT               5 /* Get ASIC Statistics */
-#define QLA84_MGMT_INFO_CONFIG_PARAMS           6 /* Get Config Parameters */
-#define QLA84_MGMT_INFO_PANIC_LOG               7 /* Get Panic Log */
-
-		uint32_t context;
-/*
-* context definitions for QLA84_MGMT_INFO_CONFIG_LOG_DATA
-*/
-#define IC_LOG_DATA_LOG_ID_DEBUG_LOG                    0
-#define IC_LOG_DATA_LOG_ID_LEARN_LOG                    1
-#define IC_LOG_DATA_LOG_ID_FC_ACL_INGRESS_LOG           2
-#define IC_LOG_DATA_LOG_ID_FC_ACL_EGRESS_LOG            3
-#define IC_LOG_DATA_LOG_ID_ETHERNET_ACL_INGRESS_LOG     4
-#define IC_LOG_DATA_LOG_ID_ETHERNET_ACL_EGRESS_LOG      5
-#define IC_LOG_DATA_LOG_ID_MESSAGE_TRANSMIT_LOG         6
-#define IC_LOG_DATA_LOG_ID_MESSAGE_RECEIVE_LOG          7
-#define IC_LOG_DATA_LOG_ID_LINK_EVENT_LOG               8
-#define IC_LOG_DATA_LOG_ID_DCX_LOG                      9
-
-/*
-* context definitions for QLA84_MGMT_INFO_PORT_STAT
-*/
-#define IC_PORT_STATISTICS_PORT_NUMBER_ETHERNET_PORT0   0
-#define IC_PORT_STATISTICS_PORT_NUMBER_ETHERNET_PORT1   1
-#define IC_PORT_STATISTICS_PORT_NUMBER_NSL_PORT0        2
-#define IC_PORT_STATISTICS_PORT_NUMBER_NSL_PORT1        3
-#define IC_PORT_STATISTICS_PORT_NUMBER_FC_PORT0         4
-#define IC_PORT_STATISTICS_PORT_NUMBER_FC_PORT1         5
-
-
-/*
-* context definitions for QLA84_MGMT_INFO_LIF_STAT
-*/
-#define IC_LIF_STATISTICS_LIF_NUMBER_ETHERNET_PORT0     0
-#define IC_LIF_STATISTICS_LIF_NUMBER_ETHERNET_PORT1     1
-#define IC_LIF_STATISTICS_LIF_NUMBER_FC_PORT0           2
-#define IC_LIF_STATISTICS_LIF_NUMBER_FC_PORT1           3
-#define IC_LIF_STATISTICS_LIF_NUMBER_CPU                6
-
-		} info; /* for QLA84_MGMT_GET_INFO */
-	} u;
-};
-
-struct qla84_msg_mgmt {
-	uint16_t cmd;
-#define QLA84_MGMT_READ_MEM     0x00
-#define QLA84_MGMT_WRITE_MEM    0x01
-#define QLA84_MGMT_CHNG_CONFIG  0x02
-#define QLA84_MGMT_GET_INFO     0x03
-	uint16_t rsrvd;
-	struct qla84_mgmt_param mgmtp;/* parameters for cmd */
-	uint32_t len; /* bytes in payload following this struct */
-	uint8_t payload[0]; /* payload for cmd */
-};
-
-struct msg_update_fw {
-	/*
-	* diag_fw = 0  operational fw
-	*      otherwise diagnostic fw
-	* offset, len, fw_len are present to overcome the current limitation
-	* of 128Kb xfer size. The fw is sent in smaller chunks. Each chunk
-	* specifies the byte "offset" where it fits in the fw buffer. The
-	* number of bytes in each chunk is specified in "len". "fw_len"
-	* is the total size of fw. The first chunk should start at offset = 0.
-	* When offset+len == fw_len, the fw is written to the HBA.
-	*/
-	uint32_t diag_fw;
-	uint32_t offset;/* start offset */
-	uint32_t len;   /* num bytes in cur xfer */
-	uint32_t fw_len; /* size of fw in bytes */
-	uint8_t fw_bytes[0];
-};
-
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3a89bc5..c1f1736 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -459,4 +459,12 @@ extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 
+/* BSG related functions */
+extern int qla24xx_bsg_request(struct fc_bsg_job *);
+extern int qla24xx_bsg_timeout(struct fc_bsg_job *);
+extern int qla84xx_reset_chip(scsi_qla_host_t *, uint16_t);
+extern int qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *,
+	dma_addr_t, size_t, uint32_t);
+extern int qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t,
+	uint16_t *, uint16_t *);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3ba9a2b..b9e5ea3 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -710,7 +710,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *vha, uint32_t risc_addr)
  * Context:
  *	Kernel context.
  */
-static int
+int
 qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
     dma_addr_t phys_addr, size_t size, uint32_t tov)
 {
@@ -2739,6 +2739,48 @@ qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint16_t addr,
 }
 
 int
+qla2x00_get_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
+	uint16_t *port_speed, uint16_t *mb)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_IIDMA_CAPABLE(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_PORT_PARAMS;
+	mcp->mb[1] = loop_id;
+	mcp->mb[2] = mcp->mb[3] = 0;
+	mcp->mb[9] = vha->vp_idx;
+	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_3|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	/* Return mailbox statuses. */
+	if (mb != NULL) {
+		mb[0] = mcp->mb[0];
+		mb[1] = mcp->mb[1];
+		mb[3] = mcp->mb[3];
+	}
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    vha->host_no, rval));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		if (port_speed)
+			*port_speed = mcp->mb[3];
+	}
+
+	return rval;
+}
+
+int
 qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
     uint16_t port_speed, uint16_t *mb)
 {
@@ -3763,8 +3805,7 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq, uint16_t *mres
 	return rval;
 }
 int
-qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic,
-    uint16_t *cmd_status)
+qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -3781,8 +3822,6 @@ qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic,
 	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN|IOCTL_CMD;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
-	/* Return mailbox statuses. */
-	*cmd_status = mcp->mb[0];
 	if (rval != QLA_SUCCESS)
 		DEBUG16(printk("%s(%ld): failed=%x.\n", __func__, ha->host_no,
 			rval));
-- 
1.6.2.rc1.30.gd43c

