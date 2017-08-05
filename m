From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 2/2] lpfc: support nvmet_fc defer_rcv callback
Date: Fri,  4 Aug 2017 17:29:33 -0700
Message-ID: <20170805002933.23397-3-jsmart2021@gmail.com>
References: <20170805002933.23397-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36495 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdHEA3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:29:45 -0400
Received: by mail-pg0-f68.google.com with SMTP id y129so3088338pgy.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:29:45 -0700 (PDT)
In-Reply-To: <20170805002933.23397-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Currently, calls to nvmet_fc_rcv_fcp_req() always copied the
FC-NVME cmd iu to a temporary buffer before returning, allowing
the driver to immediately repost the buffer to the hardware.

To address timing conditions on queue element structures vs async
command reception, the nvmet_fc transport occasionally may need to
hold on to the command iu buffer for a short period. In these cases,
the nvmet_fc_rcv_fcp_req() will return a special return code
(-EOVERFLOW). In these cases, the LLDD must delay until the new
defer_rcv lldd callback is called before recycling the buffer back
to the hw.

This patch adds support for the new nvmet_fc transport defer_rcv
callback and recognition of the new error code when passing commands
to the transport.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
This patch is intended to enter the kernel through the nvme block
tree which pulls in the nvmet_fc api change at the same time. It is
not to be merged via the scsi trees without the latest nvme support
in it.

v2:
  removed unnecessary casts 

 drivers/scsi/lpfc/lpfc_attr.c    |  4 +++-
 drivers/scsi/lpfc/lpfc_debugfs.c |  5 ++++-
 drivers/scsi/lpfc/lpfc_nvmet.c   | 30 ++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h   |  1 +
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4ed48ed38e79..7ee1a94c0b33 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -205,8 +205,10 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 				atomic_read(&tgtp->xmt_ls_rsp_error));
 
 		len += snprintf(buf+len, PAGE_SIZE-len,
-				"FCP: Rcv %08x Release %08x Drop %08x\n",
+				"FCP: Rcv %08x Defer %08x Release %08x "
+				"Drop %08x\n",
 				atomic_read(&tgtp->rcv_fcp_cmd_in),
+				atomic_read(&tgtp->rcv_fcp_cmd_defer),
 				atomic_read(&tgtp->xmt_fcp_release),
 				atomic_read(&tgtp->rcv_fcp_cmd_drop));
 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 5cc8b0f7d885..744f3f395b64 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -782,8 +782,11 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 				atomic_read(&tgtp->xmt_ls_rsp_error));
 
 		len += snprintf(buf + len, size - len,
-				"FCP: Rcv %08x Drop %08x\n",
+				"FCP: Rcv %08x Defer %08x Release %08x "
+				"Drop %08x\n",
 				atomic_read(&tgtp->rcv_fcp_cmd_in),
+				atomic_read(&tgtp->rcv_fcp_cmd_defer),
+				atomic_read(&tgtp->xmt_fcp_release),
 				atomic_read(&tgtp->rcv_fcp_cmd_drop));
 
 		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fbeec344c6cc..bbbd0f84160d 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -841,12 +841,31 @@ lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 	lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
 }
 
+static void
+lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
+		     struct nvmefc_tgt_fcp_req *rsp)
+{
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct lpfc_nvmet_rcv_ctx *ctxp =
+		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
+	struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
+	struct lpfc_hba *phba = ctxp->phba;
+
+	lpfc_nvmeio_data(phba, "NVMET DEFERRCV: xri x%x sz %d CPU %02x\n",
+			 ctxp->oxid, ctxp->size, smp_processor_id());
+
+	tgtp = phba->targetport->private;
+	atomic_inc(&tgtp->rcv_fcp_cmd_defer);
+	lpfc_rq_buf_free(phba, &nvmebuf->hbuf); /* repost */
+}
+
 static struct nvmet_fc_target_template lpfc_tgttemplate = {
 	.targetport_delete = lpfc_nvmet_targetport_delete,
 	.xmt_ls_rsp     = lpfc_nvmet_xmt_ls_rsp,
 	.fcp_op         = lpfc_nvmet_xmt_fcp_op,
 	.fcp_abort      = lpfc_nvmet_xmt_fcp_abort,
 	.fcp_req_release = lpfc_nvmet_xmt_fcp_release,
+	.defer_rcv	= lpfc_nvmet_defer_rcv,
 
 	.max_hw_queues  = 1,
 	.max_sgl_segments = LPFC_NVMET_DEFAULT_SEGS,
@@ -1504,6 +1523,17 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 		return;
 	}
 
+	/* Processing of FCP command is deferred */
+	if (rc == -EOVERFLOW) {
+		lpfc_nvmeio_data(phba,
+				 "NVMET RCV BUSY: xri x%x sz %d from %06x\n",
+				 oxid, size, sid);
+		/* defer reposting rcv buffer till .defer_rcv callback */
+		ctxp->rqb_buffer = nvmebuf;
+		atomic_inc(&tgtp->rcv_fcp_cmd_out);
+		return;
+	}
+
 	atomic_inc(&tgtp->rcv_fcp_cmd_drop);
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 			"6159 FCP Drop IO x%x: err x%x: x%x x%x x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index e675ef17be08..48a76788b003 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -49,6 +49,7 @@ struct lpfc_nvmet_tgtport {
 	atomic_t rcv_fcp_cmd_in;
 	atomic_t rcv_fcp_cmd_out;
 	atomic_t rcv_fcp_cmd_drop;
+	atomic_t rcv_fcp_cmd_defer;
 	atomic_t xmt_fcp_release;
 
 	/* Stats counters - lpfc_nvmet_xmt_fcp_op */
-- 
2.13.1
