From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/35] bfa: move bus reset to target reset
Date: Fri, 23 Jun 2017 15:02:30 +0200
Message-ID: <1498222975-71858-11-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754159AbdFWND2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:28 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset handler is just calling target reset on all targets,
which is exactly what SCSI EH will be doing anyway.
So move the bus reset function to target reset and drop the loop.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bfa/bfad_im.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 7eb0eef..24e657a 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -373,32 +373,28 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 }
 
 /*
- * Scsi_Host template entry, resets the bus and abort all commands.
+ * Scsi_Host template entry, resets the target and abort all commands.
  */
 static int
-bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
+bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
+	struct scsi_target *starget = scsi_target(cmnd->device);
 	struct bfad_im_port_s *im_port =
 				(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfad_itnim_s   *itnim;
 	unsigned long   flags;
-	u32        i, rc, err_cnt = 0;
+	u32        rc, rtn = FAILED;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	for (i = 0; i < MAX_FCP_TARGET; i++) {
-		itnim = bfad_get_itnim(im_port, i);
-		if (itnim) {
-			cmnd->SCp.ptr = (char *)&wq;
-			rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
-			if (rc != BFA_STATUS_OK) {
-				err_cnt++;
-				continue;
-			}
-
+	itnim = bfad_get_itnim(im_port, starget->id);
+	if (itnim) {
+		cmnd->SCp.ptr = (char *)&wq;
+		rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
+		if (rc == BFA_STATUS_OK) {
 			/* wait target reset to complete */
 			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 			wait_event(wq, test_bit(IO_DONE_BIT,
@@ -406,20 +402,17 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
 			spin_lock_irqsave(&bfad->bfad_lock, flags);
 
 			task_status = cmnd->SCp.Status >> 1;
-			if (task_status != BFI_TSKIM_STS_OK) {
+			if (task_status != BFI_TSKIM_STS_OK)
 				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 					"target reset failure,"
 					" status: %d\n", task_status);
-				err_cnt++;
-			}
+			else
+				rtn = SUCCESS;
 		}
 	}
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	if (err_cnt)
-		return FAILED;
-
-	return SUCCESS;
+	return rtn;
 }
 
 /*
@@ -816,7 +809,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
-	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+	.eh_target_reset_handler = bfad_im_reset_target_handler,
 
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
@@ -839,7 +832,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
-	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+	.eh_target_reset_handler = bfad_im_reset_target_handler,
 
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
-- 
1.8.5.6
