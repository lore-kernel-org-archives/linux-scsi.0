From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/16] scsi_dh_alua: simplify sense code handling
Date: Fri, 20 Dec 2013 13:13:34 +0100
Message-ID: <1387541621-54967-10-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

Most sense code is already handled in the generic
code, so we shouldn't be adding special cases here.
However, when doing so we need to check for
unit attention whenever we're sending an internal
command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 33 +++++-------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 9d712be..e297851 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -388,6 +388,8 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			goto out;
 		}
 		err = alua_check_sense(sdev, &sense_hdr);
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = ADD_TO_MLQUEUE;
 		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
 			goto retry;
 		if (err != SUCCESS) {
@@ -617,21 +619,6 @@ static int alua_check_sense(struct scsi_device *sdev,
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
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
@@ -646,7 +633,7 @@ static int alua_check_sense(struct scsi_device *sdev,
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
 			/*
-			 * Mode Parameters Changed
+			 * Mode parameter changed
 			 */
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
@@ -659,18 +646,6 @@ static int alua_check_sense(struct scsi_device *sdev,
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
 
@@ -735,6 +710,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 		}
 
 		err = alua_check_sense(sdev, &sense_hdr);
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = ADD_TO_MLQUEUE;
 		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry, ",
 				    ALUA_DH_NAME);
-- 
1.7.12.4

