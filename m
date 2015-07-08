From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/20] scsi_dh_alua: simplify sense code handling
Date: Wed,  8 Jul 2015 11:06:11 +0200
Message-ID: <1436346378-96518-14-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934523AbbGHJGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:33 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Most sense code is already handled in the generic
code, so we shouldn't be adding special cases here.
However, when doing so we need to check for
unit attention whenever we're sending an internal
command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 50 +++++++-----------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e8bfbce..f4d851a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -91,7 +91,6 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static char print_alua_state(int);
-static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 
 static void release_port_group(struct kref *kref)
 {
@@ -321,28 +320,6 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -357,7 +334,7 @@ static int alua_check_sense(struct scsi_device *sdev,
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
 			/*
-			 * Mode Parameters Changed
+			 * Mode Parameter Changed
 			 */
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
@@ -370,18 +347,6 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * Implicit ALUA state transition failed
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
-			/*
-			 * Inquiry data has changed
-			 */
-			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
-			/*
-			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
-			 * when switching controllers on targets like
-			 * Intel Multi-Flex. We can just retry.
-			 */
-			return ADD_TO_MLQUEUE;
 		break;
 	}
 
@@ -449,9 +414,16 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
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
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = SCSI_DH_RETRY;
+		if (err == SCSI_DH_RETRY && time_before(jiffies, expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-- 
1.8.5.2

