Received: from alt2.a-painless.mh.aa.net.uk (alt2.a-painless.mh.aa.net.uk [81.187.30.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E317204C2A;
	Tue, 18 Mar 2025 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.187.30.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742313431; cv=none; b=J00c6uNEwxrzFrmZP5Dpmj3A8J4O4KKc79DvqYfR7VY8Q7/ogAjZt4J/dRbxGV9erLXjxQRTFArVsNnys+ytCNbh1vwNDxh1sY8mfgQSsAnm5lkTx3Qx04uCPOotytwjHFjmjGUgaIrrlpRKhZd1CMrSEDCHpRxQjwzF7NIRYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742313431; c=relaxed/simple;
	bh=i0dvlcEXvSCIALEo0mBL09rkA17hEMVdBBxTR5ldyQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R1Ygnd3w1MzIFOMhZk6TGcOWtX1oSVQTn9kCgIDYssZkXdYycgrw0pCTrjB0QYcq9/p7Yjg8tMBnl44L83bGhe5t4jpcKjox6OqNzIGwjTH+UYf+1OQxM/8ZrXVxli6W9ucStfutvB9kBgi0Fq/cz5x+wvYL0xU0+5CnO6fFXvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pileofstuff.org; spf=pass smtp.mailfrom=pileofstuff.org; arc=none smtp.client-ip=81.187.30.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pileofstuff.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pileofstuff.org
Received: from 6.1.e.8.1.c.e.a.2.2.4.2.8.e.4.a.0.5.8.0.9.1.8.0.0.b.8.0.1.0.0.2.ip6.arpa ([2001:8b0:819:850:a4e8:2422:aec1:8e16] helo=andrews-2024-laptop.lan)
	by painless-a.thn.aa.net.uk with esmtp (Exim 4.96)
	(envelope-from <kernel.org@pileofstuff.org>)
	id 1tuZJR-00EYj0-2C;
	Tue, 18 Mar 2025 15:57:05 +0000
From: Andrew Sayers <kernel.org@pileofstuff.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Sayers <kernel.org@pileofstuff.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Change log level of progress messages to INFO
Date: Tue, 18 Mar 2025 15:56:45 +0000
Message-ID: <20250318155647.1078829-1-kernel.org@pileofstuff.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are normal progress messages that don't indicate anything unusual.
Reducing the level of these messages frees up user attention for when
we need them to do something.

Signed-off-by: Andrew Sayers <kernel.org@pileofstuff.org>
---
 drivers/scsi/scsi_scan.c |  2 +-
 drivers/scsi/sd.c        | 40 ++++++++++++++++++++--------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4833b8fe251b..9580982c5700 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -977,7 +977,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (inq_result[7] & 0x10)
 		sdev->sdtr = 1;
 
-	sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
+	sdev_printk(KERN_INFO, sdev, "%s %.8s %.16s %.4s PQ: %d "
 			"ANSI: %d%s\n", scsi_device_type(sdev->type),
 			sdev->vendor, sdev->model, sdev->rev,
 			sdev->inq_periph_qual, inq_result[2] & 0x07,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..ad7d931bbbc9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2447,7 +2447,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 */
 			if (media_not_present(sdkp, &sshdr)) {
 				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp,
+					sd_printk(KERN_INFO, sdkp,
 						  "Media removed, stopped polling\n");
 				return;
 			}
@@ -2495,7 +2495,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 						0x11 : 1,
 				};
 
-				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
+				sd_printk(KERN_INFO, sdkp, "Spinning up disk...");
 				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
@@ -2700,7 +2700,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
 	lim->alignment_offset = alignment;
 	if (alignment && sdkp->first_scan)
-		sd_printk(KERN_NOTICE, sdkp,
+		sd_printk(KERN_INFO, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
 
 	if (buffer[14] & 0x80) { /* LBPME */
@@ -2835,7 +2835,7 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 		if ((sizeof(sdkp->capacity) > 4) &&
 		    (sdkp->capacity > 0xffffffffULL)) {
 			int old_sector_size = sector_size;
-			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
+			sd_printk(KERN_INFO, sdkp, "Very big device. "
 					"Trying to use READ CAPACITY(16).\n");
 			sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
 			if (sector_size < 0) {
@@ -2923,13 +2923,13 @@ sd_print_capacity(struct scsi_disk *sdkp,
 	string_get_size(sdkp->capacity, sector_size,
 			STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
 
-	sd_printk(KERN_NOTICE, sdkp,
+	sd_printk(KERN_INFO, sdkp,
 		  "%llu %d-byte logical blocks: (%s/%s)\n",
 		  (unsigned long long)sdkp->capacity,
 		  sector_size, cap_str_10, cap_str_2);
 
 	if (sdkp->physical_block_size != sector_size)
-		sd_printk(KERN_NOTICE, sdkp,
+		sd_printk(KERN_INFO, sdkp,
 			  "%u-byte physical blocks\n",
 			  sdkp->physical_block_size);
 }
@@ -3003,7 +3003,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
-			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
+			sd_printk(KERN_INFO, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");
 			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
 		}
@@ -3154,7 +3154,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 		if (sdkp->first_scan || old_wce != sdkp->WCE ||
 		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
-			sd_printk(KERN_NOTICE, sdkp,
+			sd_printk(KERN_INFO, sdkp,
 				  "Write cache: %s, read cache: %s, %s\n",
 				  sdkp->WCE ? "enabled" : "disabled",
 				  sdkp->RCD ? "disabled" : "enabled",
@@ -3415,11 +3415,11 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp,
 		return;
 
 	if (sdkp->device->type == TYPE_ZBC)
-		sd_printk(KERN_NOTICE, sdkp, "Host-managed zoned block device\n");
+		sd_printk(KERN_INFO, sdkp, "Host-managed zoned block device\n");
 	else if (sdkp->zoned == 1)
-		sd_printk(KERN_NOTICE, sdkp, "Host-aware SMR disk used as regular disk\n");
+		sd_printk(KERN_INFO, sdkp, "Host-aware SMR disk used as regular disk\n");
 	else if (sdkp->zoned == 2)
-		sd_printk(KERN_NOTICE, sdkp, "Drive-managed SMR disk\n");
+		sd_printk(KERN_INFO, sdkp, "Drive-managed SMR disk\n");
 }
 
 /**
@@ -3567,7 +3567,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
 out:
 	disk_set_independent_access_ranges(sdkp->disk, iars);
 	if (nr_cpr && sdkp->nr_actuators != nr_cpr) {
-		sd_printk(KERN_NOTICE, sdkp,
+		sd_printk(KERN_INFO, sdkp,
 			  "%u concurrent positioning ranges\n", nr_cpr);
 		sdkp->nr_actuators = nr_cpr;
 	}
@@ -4025,10 +4025,10 @@ static int sd_probe(struct device *dev)
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
-			sd_printk(KERN_NOTICE, sdkp, "supports TCG Opal\n");
+			sd_printk(KERN_INFO, sdkp, "supports TCG Opal\n");
 	}
 
-	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
+	sd_printk(KERN_INFO, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 	scsi_autopm_put_device(sdp);
 
@@ -4166,7 +4166,7 @@ static void sd_shutdown(struct device *dev)
 		return;
 
 	if (sdkp->WCE && sdkp->media_present) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		sd_printk(KERN_INFO, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
 	}
 
@@ -4174,7 +4174,7 @@ static void sd_shutdown(struct device *dev)
 	     sdkp->device->manage_system_start_stop) ||
 	    (system_state == SYSTEM_POWER_OFF &&
 	     sdkp->device->manage_shutdown)) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		sd_printk(KERN_INFO, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
 }
@@ -4195,7 +4195,7 @@ static int sd_suspend_common(struct device *dev, bool runtime)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
-			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+			sd_printk(KERN_INFO, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
 		/* ignore OFFLINE device */
 		if (ret == -ENODEV)
@@ -4207,7 +4207,7 @@ static int sd_suspend_common(struct device *dev, bool runtime)
 
 	if (sd_do_start_stop(sdkp->device, runtime)) {
 		if (!sdkp->device->silence_suspend)
-			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+			sd_printk(KERN_INFO, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
 		if (!runtime)
@@ -4237,7 +4237,7 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+	sd_printk(KERN_INFO, sdkp, "Starting disk\n");
 
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
@@ -4260,7 +4260,7 @@ static int sd_resume_common(struct device *dev, bool runtime)
 		return 0;
 	}
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+	sd_printk(KERN_INFO, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
-- 
2.49.0

