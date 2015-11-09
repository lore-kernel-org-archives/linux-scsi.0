From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/18] scsi_dh_alua: Use vpd_pg83 information
Date: Mon,  9 Nov 2015 16:08:09 +0100
Message-ID: <1447081703-110552-5-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbKIPI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:26 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

The SCSI device now has the VPD page 0x83 information attached,
so there is no need to query it again.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 87 +++++++-----------------------
 1 file changed, 18 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7d01ef0..9b3b2f7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -131,43 +131,6 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 }
 
 /*
- * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
- * @sdev: sdev the command should be sent to
- */
-static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
-{
-	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
-		goto done;
-
-	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 1;
-	rq->cmd[2] = 0x83;
-	rq->cmd[4] = h->bufflen;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
-
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: evpd inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
-	}
-	blk_put_request(rq);
-done:
-	return err;
-}
-
-/*
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
@@ -359,43 +322,29 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 }
 
 /*
- * alua_vpd_inquiry - Evaluate INQUIRY vpd page 0x83
+ * alua_check_vpd - Evaluate INQUIRY vpd page 0x83
  * @sdev: device to be checked
  *
  * Extract the relative target port and the target port group
  * descriptor from the list of identificators.
  */
-static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int len;
-	unsigned err;
 	unsigned char *d;
+	unsigned char __rcu *vpd_pg83;
 
- retry:
-	err = submit_vpd_inquiry(sdev, h);
-
-	if (err != SCSI_DH_OK)
-		return err;
-
-	/* Check if vpd page exceeds initial buffer */
-	len = (h->buff[2] << 8) + h->buff[3] + 4;
-	if (len > h->bufflen) {
-		/* Resubmit with the correct length */
-		if (realloc_buffer(h, len)) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: kmalloc buffer failed\n",
-				    ALUA_DH_NAME);
-			/* Temporary failure, bypass */
-			return SCSI_DH_DEV_TEMP_BUSY;
-		}
-		goto retry;
+	rcu_read_lock();
+	if (!rcu_dereference(sdev->vpd_pg83)){
+		rcu_read_unlock();
+		return SCSI_DH_DEV_UNSUPP;
 	}
 
 	/*
-	 * Now look for the correct descriptor.
+	 * Look for the correct descriptor.
 	 */
-	d = h->buff + 4;
-	while (d < h->buff + len) {
+	vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
+	d = vpd_pg83 + 4;
+	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
@@ -410,6 +359,7 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 		}
 		d += d[3] + 4;
 	}
+	rcu_read_unlock();
 
 	if (h->group_id == -1) {
 		/*
@@ -422,14 +372,13 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME);
 		h->state = TPGS_STATE_OPTIMIZED;
 		h->tpgs = TPGS_MODE_NONE;
-		err = SCSI_DH_DEV_UNSUPP;
-	} else {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: port group %02x rel port %02x\n",
-			    ALUA_DH_NAME, h->group_id, h->rel_port);
+		return SCSI_DH_DEV_UNSUPP;
 	}
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x rel port %02x\n",
+		    ALUA_DH_NAME, h->group_id, h->rel_port);
 
-	return err;
+	return 0;
 }
 
 static char print_alua_state(int state)
@@ -692,7 +641,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	if (err != SCSI_DH_OK)
 		goto out;
 
-	err = alua_vpd_inquiry(sdev, h);
+	err = alua_check_vpd(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto out;
 
-- 
1.8.5.6

