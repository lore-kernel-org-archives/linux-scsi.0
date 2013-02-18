From: Rob Evers <revers@redhat.com>
Subject: [PATCH v2 1/3] Encapsulate scsi_do_report_luns
Date: Mon, 18 Feb 2013 14:15:50 -0500
Message-ID: <1361214952-28978-2-git-send-email-revers@redhat.com>
References: <1361214952-28978-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3BRTPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2013 14:15:54 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1IJFskV009148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:54 -0500
Received: from localhost (dhcp-186-142.bos.redhat.com [10.16.186.142])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r1IJFrKS006113
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2013 14:15:53 -0500
In-Reply-To: <1361214952-28978-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 109 +++++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..b2abf22 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1282,6 +1282,64 @@ void int_to_scsilun(unsigned int lun, struct scsi_lun *scsilun)
 }
 EXPORT_SYMBOL(int_to_scsilun);
 
+int scsi_do_report_luns(struct scsi_device *sdev, int length,
+			struct scsi_lun *lun_data, char *devname)
+{
+	unsigned int retries;
+	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
+	struct scsi_sense_hdr sshdr;
+	int result;
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
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sending"
+				  " REPORT LUNS to %s (try %d)\n", devname,
+				  retries));
+		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
+					  lun_data, length, &sshdr,
+					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
+
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: REPORT LUNS"
+				  " %s (try %d) result 0x%x\n", result
+				  ?  "failed" : "successful", retries, result));
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
@@ -1306,15 +1364,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)
 {
 	char devname[64];
-	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	unsigned int lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
 	u8 *data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
@@ -1369,53 +1424,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
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
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
-				" REPORT LUNS to %s (try %d)\n", devname,
-				retries));
-
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
-
-		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n", result
-				?  "failed" : "successful", retries, result));
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
1.7.11.7

