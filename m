From: Rob Evers <revers@redhat.com>
Subject: [PATCH V4 3/5] scsi: Encapsulate scsi_do_report_luns
Date: Mon, 17 Nov 2014 10:22:08 -0500
Message-ID: <1416237730-1862-4-git-send-email-revers@redhat.com>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaKQPWN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 10:22:13 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMC63020991
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:13 -0500
Received: from localhost ([10.18.25.106])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMCYc008021
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:12 -0500
In-Reply-To: <1416237730-1862-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Report luns functionality is encapsulated as it will be re-used in the next
patch in this series if a large number of LUs are present.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 114 ++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 69291bf3..193c20c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1328,6 +1328,67 @@ void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
 }
 EXPORT_SYMBOL(int_to_scsilun);
 
+int scsi_do_report_luns(struct scsi_device *sdev, int length,
+			struct scsi_lun *lun_data, char *devname)
+{
+	unsigned int retries;
+	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
+	struct scsi_sense_hdr sshdr;
+	int result = 0;
+
+	scsi_cmd[0] = REPORT_LUNS;
+
+	/*
+	 * bytes 1 - 5: reserved, set to zero.
+	 */
+	memset(&scsi_cmd[1], 0, 5);
+
+	/*
+	 * bytes 6 - 9: length of the command.
+	 */
+	scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
+	scsi_cmd[7] = (unsigned char) (length >> 16) & 0xff;
+	scsi_cmd[8] = (unsigned char) (length >> 8) & 0xff;
+	scsi_cmd[9] = (unsigned char) length & 0xff;
+
+	scsi_cmd[10] = 0;	/* reserved */
+	scsi_cmd[11] = 0;	/* control */
+
+	/*
+	 * We can get a UNIT ATTENTION, for example a power on/reset, so
+	 * retry a few times (like sd.c does for TEST UNIT READY).
+	 * Experience shows some combinations of adapter/devices get at
+	 * least two power on/resets.
+	 *
+	 * Illegal requests (for devices that do not support REPORT LUNS)
+	 * should come through as a check condition, and will not generate
+	 * a retry.
+	 */
+	for (retries = 0; retries < 3; retries++) {
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: Sending REPORT LUNS to (try %d)\n",
+				retries));
+
+		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
+					  lun_data, length, &sshdr,
+					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
+
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				  "scsi scan: REPORT LUNS"
+				  " %s (try %d) result 0x%x\n",
+				  result ?  "failed" : "successful",
+				  retries, result));
+		if (result == 0)
+			break;
+		else if (scsi_sense_valid(&sshdr)) {
+			if (sshdr.sense_key != UNIT_ATTENTION)
+				break;
+		}
+	}
+
+	return result;
+}
+
 /**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
  * @starget: which target
@@ -1352,15 +1413,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)
 {
 	char devname[64];
-	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
 	u8 *data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
@@ -1416,55 +1474,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		goto out;
 	}
 
-	scsi_cmd[0] = REPORT_LUNS;
-
-	/*
-	 * bytes 1 - 5: reserved, set to zero.
-	 */
-	memset(&scsi_cmd[1], 0, 5);
-
-	/*
-	 * bytes 6 - 9: length of the command.
-	 */
-	scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
-	scsi_cmd[7] = (unsigned char) (length >> 16) & 0xff;
-	scsi_cmd[8] = (unsigned char) (length >> 8) & 0xff;
-	scsi_cmd[9] = (unsigned char) length & 0xff;
-
-	scsi_cmd[10] = 0;	/* reserved */
-	scsi_cmd[11] = 0;	/* control */
-
-	/*
-	 * We can get a UNIT ATTENTION, for example a power on/reset, so
-	 * retry a few times (like sd.c does for TEST UNIT READY).
-	 * Experience shows some combinations of adapter/devices get at
-	 * least two power on/resets.
-	 *
-	 * Illegal requests (for devices that do not support REPORT LUNS)
-	 * should come through as a check condition, and will not generate
-	 * a retry.
-	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
-
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	result = scsi_do_report_luns(sdev, length, lun_data, devname);
 
 	if (result) {
 		/*
-- 
1.8.3.1

