From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/2] scsi: scsi_dh check_sense return ADD_TO_MLQUEUE
Date: Tue, 12 Aug 2008 12:11:57 -0700
Message-ID: <1218568318-4065-2-git-send-email-andmike@linux.vnet.ibm.com>
References: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:45871 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYHLTMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 15:12:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CJC4fs014637
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 15:12:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CJC3F0165610
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:12:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CJC1WB018394
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:12:03 -0600
In-Reply-To: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Hannes Reinecke <hare@suse.de>

Change scsi_dh check_sense functions to return ADD_TO_MLQUEUE
to allow retries to occur without restriction of blk_noretry_request
check.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   12 ++++++------
 drivers/scsi/device_handler/scsi_dh_emc.c  |    4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c |    4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fcdd73f..2eb9edd 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -425,7 +425,7 @@ static int alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b)
 			/*
 			 * LUN Not Accessible -- Target port in standby state
@@ -447,18 +447,18 @@ static int alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
 			/*
 			 * ALUA state changed
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		}
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
 			/*
 			 * Implicit ALUA state transition failed
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		}
 		break;
 	}
@@ -490,7 +490,7 @@ static int alua_stpg(struct scsi_device *sdev, int state,
 		if (!err)
 			return SCSI_DH_IO;
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (retry > 0 && err == NEEDS_RETRY) {
+		if (retry > 0 && err == ADD_TO_MLQUEUE) {
 			retry--;
 			goto retry;
 		}
@@ -535,7 +535,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			return SCSI_DH_IO;
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == NEEDS_RETRY)
+		if (err == ADD_TO_MLQUEUE)
 			goto retry;
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg sense code %02x/%02x/%02x\n",
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index aa46b13..7796d65 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -439,7 +439,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Unit Attention Code. This is the first IO
 			 * to the new path, so just retry.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		break;
 	}
 
@@ -514,7 +514,7 @@ retry:
 			return SCSI_DH_IO;
 
 		err = clariion_check_sense(sdev, &sshdr);
-		if (retry > 0 && err == NEEDS_RETRY) {
+		if (retry > 0 && err == ADD_TO_MLQUEUE) {
 			retry--;
 			goto retry;
 		}
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..f5ff950 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -550,7 +550,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			 *
 			 * Just retry and wait.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
@@ -567,7 +567,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		break;
 	}
 	/* success just means we do not care what scsi-ml does */
-- 
1.5.5.1

