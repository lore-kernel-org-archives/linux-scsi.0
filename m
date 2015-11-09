From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/18] scsi_dh_alua: return standard SCSI return codes in submit_rtpg
Date: Mon,  9 Nov 2015 16:08:13 +0100
Message-ID: <1447081703-110552-9-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbKIPI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:27 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Fixup submit_rtpg() to always return a standard SCSI return code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 33 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index b817963..50fe87c 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -138,11 +138,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 			    bool rtpg_ext_hdr_req)
 {
 	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err = 0;
 
 	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
+	if (!rq) {
+		err = DRIVER_BUSY << 24;
 		goto done;
+	}
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
@@ -160,13 +162,9 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
-		err = SCSI_DH_IO;
-	}
+	blk_execute_rq(rq->q, NULL, rq, 1);
+	if (rq->errors)
+		err = rq->errors;
 	blk_put_request(rq);
 done:
 	return err;
@@ -493,7 +491,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
-	unsigned err;
+	unsigned err, retval;
 	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -505,12 +503,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
-
-	if (err == SCSI_DH_IO) {
+	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
+	if (retval) {
 		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					  &sense_hdr))
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: rtpg failed, result %d\n",
+				    ALUA_DH_NAME, retval);
+			if (driver_byte(retval) == DRIVER_BUSY)
+				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
+		}
 
 		/*
 		 * submit_rtpg() has failed on existing arrays
@@ -539,8 +542,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 		return SCSI_DH_IO;
 	}
-	if (err != SCSI_DH_OK)
-		return err;
 
 	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
 		(h->buff[2] << 8) + h->buff[3] + 4;
-- 
1.8.5.6

