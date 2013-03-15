From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Fri, 15 Mar 2013 10:46:11 +0100
Message-ID: <1363340771-46925-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab3COJqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 05:46:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, George Martin <marting@netapp.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

SAM advertises the use of a Well-known LUN (W_LUN) for scanning.
As this avoids exposing LUN 0 (which might be a valid LUN) for
all initiators it is the preferred method for LUN scanning on
some arrays.
So we should be using W_LUN for scanning, too. If the W_LUN is
not supported we'll fall back to use LUN 0.
For broken W_LUN implementations a new blacklist flag
'BLIST_NO_WLUN' is added.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..f4ccdea 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1312,6 +1312,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	unsigned int num_luns;
 	unsigned int retries;
 	int result;
+	int w_lun = SCSI_W_LUN_REPORT_LUNS;
 	struct scsi_lun *lunp, *lun_data;
 	u8 *data;
 	struct scsi_sense_hdr sshdr;
@@ -1337,11 +1338,20 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		return 0;
 	if (starget->no_report_luns)
 		return 1;
+	if (bflags & BLIST_NO_WLUN)
+		w_lun = 0;
 
+retry_report_lun_scan:
 	if (!(sdev = scsi_device_lookup_by_target(starget, 0))) {
-		sdev = scsi_alloc_sdev(starget, 0, NULL);
-		if (!sdev)
-			return 0;
+		sdev = scsi_alloc_sdev(starget, w_lun, NULL);
+		if (!sdev) {
+			if (w_lun != 0) {
+				w_lun = 0;
+				sdev = scsi_alloc_sdev(starget, w_lun, NULL);
+			}
+			if (!sdev)
+				return 0;
+		}
 		if (scsi_device_get(sdev)) {
 			__scsi_remove_device(sdev);
 			return 0;
@@ -1418,6 +1428,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	}
 
 	if (result) {
+		if (w_lun != 0 && scsi_device_created(sdev)) {
+			/*
+			 * W_LUN probably not supported, try with LUN 0
+			 */
+			SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan:"
+					"W_LUN not supported, try LUN 0\n"));
+			kfree(lun_data);
+			scsi_device_put(sdev);
+			__scsi_remove_device(sdev);
+			w_lun = 0;
+			goto retry_report_lun_scan;
+		}
 		/*
 		 * The device probably does not support a REPORT LUN command
 		 */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index cc1f3e7..ffb42b1 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -31,4 +31,5 @@
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
+#define BLIST_NO_WLUN		0x4000000 /* Disable W_LUN scanning */
 #endif
