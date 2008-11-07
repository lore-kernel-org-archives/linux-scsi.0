From: Paul Mackerras <paulus@samba.org>
Subject: [PATCH] scsi: Eliminate compile warning in ibmvfc.c
Date: Fri, 7 Nov 2008 14:16:30 +1100
Message-ID: <18707.45838.704492.589455@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:58225 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYKGDQr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2008 22:16:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, sfr@canb.auug.org.au

Recent gcc (4.3.2) gives this compile warning on
drivers/scsi/ibmvscsi/ibmvfc.o:

  CC      drivers/scsi/ibmvscsi/ibmvfc.o
.../drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_reset_device':
.../drivers/scsi/ibmvscsi/ibmvfc.c:1630: warning: 'evt' may be used uninitialized in this function

This fixes it by rearranging the code a little.  This makes no
semantic change to the code except that the error message in the
vhost->state != IBMVFC_ACTIVE case is a little more explicit.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 7650707..e6c149f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1630,32 +1630,37 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp_iu;
 	struct ibmvfc_fcp_rsp *fc_rsp = &rsp_iu.cmd.rsp;
-	int rsp_rc = -EBUSY;
+	int rsp_rc;
 	unsigned long flags;
 	int rsp_code = 0;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	if (vhost->state == IBMVFC_ACTIVE) {
-		evt = ibmvfc_get_event(vhost);
-		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
-
-		tmf = &evt->iu.cmd;
-		memset(tmf, 0, sizeof(*tmf));
-		tmf->resp.va = (u64)evt->crq.ioba + offsetof(struct ibmvfc_cmd, rsp);
-		tmf->resp.len = sizeof(tmf->rsp);
-		tmf->frame_type = IBMVFC_SCSI_FCP_TYPE;
-		tmf->payload_len = sizeof(tmf->iu);
-		tmf->resp_len = sizeof(tmf->rsp);
-		tmf->cancel_key = (unsigned long)sdev->hostdata;
-		tmf->tgt_scsi_id = rport->port_id;
-		int_to_scsilun(sdev->lun, &tmf->iu.lun);
-		tmf->flags = (IBMVFC_NO_MEM_DESC | IBMVFC_TMF);
-		tmf->iu.tmf_flags = type;
-		evt->sync_iu = &rsp_iu;
-
-		init_completion(&evt->comp);
-		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
+	if (vhost->state != IBMVFC_ACTIVE) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		sdev_printk(KERN_ERR, sdev,
+			"Failed to send %s reset event; not active\n", desc);
+		return -EIO;
 	}
+	evt = ibmvfc_get_event(vhost);
+	ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
+
+	tmf = &evt->iu.cmd;
+	memset(tmf, 0, sizeof(*tmf));
+	tmf->resp.va = (u64)evt->crq.ioba + offsetof(struct ibmvfc_cmd, rsp);
+	tmf->resp.len = sizeof(tmf->rsp);
+	tmf->frame_type = IBMVFC_SCSI_FCP_TYPE;
+	tmf->payload_len = sizeof(tmf->iu);
+	tmf->resp_len = sizeof(tmf->rsp);
+	tmf->cancel_key = (unsigned long)sdev->hostdata;
+	tmf->tgt_scsi_id = rport->port_id;
+	int_to_scsilun(sdev->lun, &tmf->iu.lun);
+	tmf->flags = (IBMVFC_NO_MEM_DESC | IBMVFC_TMF);
+	tmf->iu.tmf_flags = type;
+	evt->sync_iu = &rsp_iu;
+
+	init_completion(&evt->comp);
+	rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
+
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
