From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Make sure provisioning mode is reported correctly
Date: Mon, 13 Feb 2012 15:39:00 -0500
Message-ID: <yq1sjieh3iz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40170 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab2BMUjH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2012 15:39:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, James.Bottomley@hansenpartnership.com


The provisioning_mode parameter in sysfs did not get updated in the
SD_LBP_DISABLE case. Make sure the provisioning mode is always set
correctly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..8c525aa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -497,6 +497,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		max(sdkp->physical_block_size,
 		    sdkp->unmap_granularity * logical_block_size);
 
+	sdkp->provisioning_mode = mode;
+
 	switch (mode) {
 
 	case SD_LBP_DISABLE:
@@ -524,8 +526,6 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 	q->limits.max_discard_sectors = max_blocks * (logical_block_size >> 9);
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
-
-	sdkp->provisioning_mode = mode;
 }
 
 /**
