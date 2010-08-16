From: realrichardsharpe@gmail.com
Subject: [PATCH 1/1] Remove LUNs that no longer exist when we scan a target with REPORT LUNS.
Date: Sun, 15 Aug 2010 17:08:33 -0700
Message-ID: <1281917313-1855-2-git-send-email-realrichardsharpe@gmail.com>
References: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49016 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0HPAJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Aug 2010 20:09:12 -0400
Received: by pwi4 with SMTP id 4so1380154pwi.19
        for <linux-scsi@vger.kernel.org>; Sun, 15 Aug 2010 17:09:12 -0700 (PDT)
In-Reply-To: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Richard Sharpe <realrichardsharpe@gmail.com>

From: Richard Sharpe <realrichardsharpe@gmail.com>

If the target returns logical_unit_not_supported when we send REPORT LUNS
it means that it supports REPORT LUNS but there really are no LUNs there.
Delete LUN 0 in that case.

Also, when parsing the LUNs reported, remove any LUNs that used to exist
in the gaps, and remove LUNs beyond the end of those reported. They no
longer exist.

Also don't scan a target where the ID is too large or the channel is
too large.

Tested by adding four LUNs with scst_local and then deleting them in
various combinations, including deleting from LUN 0, deleting from last
LUN and deleting in the middle out.

Signed-off-by: Richard Sharpe <realrichardsharpe@gmail.com>
---
 drivers/scsi/scsi_scan.c |   65 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1c027a9..d0f5d30 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1309,7 +1309,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
-	unsigned int lun;
+	unsigned int lun, old_lun = 0;
 	unsigned int num_luns;
 	unsigned int retries;
 	int result;
@@ -1410,6 +1410,22 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		if (result == 0)
 			break;
 		else if (scsi_sense_valid(&sshdr)) {
+			/* 
+			 * This is awful. We should use a named constant!
+			 * If the target returns logical_unit_not_supported
+			 * then there really are zero LUNs there, so delete
+			 * LUN 0 if it exists. 
+			 */
+			if (sshdr.asc == 0x25) {
+				struct scsi_device *sdev = NULL;
+				sdev = scsi_device_lookup_by_target(starget, 0);
+				if (sdev) {
+					scsi_device_put(sdev);
+					__scsi_remove_device(sdev);
+					SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+						"Removing LUN 0\n"));
+				}
+			}
 			if (sshdr.sense_key != UNIT_ATTENTION)
 				break;
 		}
@@ -1473,6 +1489,27 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		} else {
 			int res;
 
+			/*
+			 * First, check for and remove any missing LUNs, as
+			 * they have been removed on the target.
+			 */
+			if (lun > old_lun + 1) {
+				unsigned int i;
+				for (i = old_lun + 1; i < lun; i++) {
+					struct scsi_device *sdev;
+					sdev = scsi_device_lookup_by_target(
+							starget, i);
+					if (sdev) {
+						scsi_device_put(sdev);
+						__scsi_remove_device(sdev);
+						SCSI_LOG_SCAN_BUS(3, 
+							printk(KERN_INFO
+							"Removing LUN %d\n", 
+							i));
+					}
+				}
+			}
+
 			res = scsi_probe_and_add_lun(starget,
 				lun, NULL, NULL, rescan, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
@@ -1485,6 +1522,26 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				        " aborted\n", lun);
 				break;
 			}
+
+			old_lun = lun;
+		}
+	}
+
+	/*
+	 * Remove any device that no longer exist. Does not work for LUN 0.
+	 * See above.
+	 */
+	if (lun < shost->max_lun) {
+		int i = 0;
+		for (i = lun + 1; i < shost->max_lun; i++) {
+			struct scsi_device *sdev;
+			sdev = scsi_device_lookup_by_target(starget, i);
+			if (sdev) {
+				scsi_device_put(sdev);
+				__scsi_remove_device(sdev);
+				SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+					"Removed LUN %d\n", i));
+			}
 		}
 	}
 
@@ -1565,9 +1622,11 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 	int res;
 	struct scsi_target *starget;
 
-	if (shost->this_id == id)
+	if (shost->this_id == id ||
+		id > shost->max_id ||
+		channel > shost->max_channel)
 		/*
-		 * Don't scan the host adapter
+		 * Don't scan the host adapter or dis-allowed ones.
 		 */
 		return;
 
-- 
1.6.6.1

