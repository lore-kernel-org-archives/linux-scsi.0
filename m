From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/18] scsi_dh_alua: simplify sense code handling
Date: Mon,  9 Nov 2015 16:08:19 +0100
Message-ID: <1447081703-110552-15-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbbKIPI2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:28 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Most sense code is already handled in the generic
code, so we shouldn't be adding special cases here.
However, when doing so we need to check for
unit attention whenever we're sending an internal
command.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 45 +++++++++++-------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c9751c9..abf05b4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -85,7 +85,6 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static char print_alua_state(int);
-static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 
 static int realloc_buffer(struct alua_dh_data *h, unsigned len)
 {
@@ -189,8 +188,13 @@ static void stpg_endio(struct request *req, int error)
 
 	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 				 &sense_hdr)) {
-		err = alua_check_sense(h->sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE) {
+		if (sense_hdr.sense_key == NOT_READY &&
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+			/* ALUA state transition already in progress */
+			err = SCSI_DH_OK;
+			goto done;
+		}
+		if (sense_hdr.sense_key == UNIT_ATTENTION) {
 			err = SCSI_DH_RETRY;
 			goto done;
 		}
@@ -399,28 +403,6 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * LUN Not Accessible - ALUA state transition
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b)
-			/*
-			 * LUN Not Accessible -- Target port in standby state
-			 */
-			return SUCCESS;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0c)
-			/*
-			 * LUN Not Accessible -- Target port in unavailable state
-			 */
-			return SUCCESS;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x12)
-			/*
-			 * LUN Not Ready -- Offline
-			 */
-			return SUCCESS;
-		if (sdev->allow_restart &&
-		    sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x02)
-			/*
-			 * if the device is not started, we need to wake
-			 * the error handler to start the motor
-			 */
-			return FAILED;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
@@ -517,9 +499,16 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
-
-		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+		/*
+		 * Retry on ALUA state transition or if any
+		 * UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == NOT_READY &&
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+			err = SCSI_DH_RETRY;
+		else if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = SCSI_DH_RETRY;
+		if (err == SCSI_DH_RETRY && time_before(jiffies, expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-- 
1.8.5.6

