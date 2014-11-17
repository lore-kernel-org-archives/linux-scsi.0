From: Rob Evers <revers@redhat.com>
Subject: [PATCH V4 5/5] scsi: Use set/get_unaligned_be32 in report_luns
Date: Mon, 17 Nov 2014 10:22:10 -0500
Message-ID: <1416237730-1862-6-git-send-email-revers@redhat.com>
References: <1416237730-1862-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaKQPWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 10:22:14 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMEBt030678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:14 -0500
Received: from localhost ([10.18.25.106])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sAHFMDHc008039
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2014 10:22:13 -0500
In-Reply-To: <1416237730-1862-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_scan.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0d9108e..fa6ac51 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1329,7 +1330,7 @@ void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
 }
 EXPORT_SYMBOL(int_to_scsilun);
 
-int scsi_do_report_luns(struct scsi_device *sdev, int length,
+int scsi_do_report_luns(struct scsi_device *sdev, u32 length,
 			struct scsi_lun *lun_data, char *devname)
 {
 	unsigned int retries;
@@ -1347,10 +1348,7 @@ int scsi_do_report_luns(struct scsi_device *sdev, int length,
 	/*
 	 * bytes 6 - 9: length of the command.
 	 */
-	scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
-	scsi_cmd[7] = (unsigned char) (length >> 16) & 0xff;
-	scsi_cmd[8] = (unsigned char) (length >> 8) & 0xff;
-	scsi_cmd[9] = (unsigned char) length & 0xff;
+	put_unaligned_be32(length, &scsi_cmd[6]);
 
 	scsi_cmd[10] = 0;	/* reserved */
 	scsi_cmd[11] = 0;	/* control */
@@ -1414,13 +1412,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)
 {
 	char devname[64];
-	unsigned int length;
+	u32 length;
 	u64 lun;
 	unsigned int num_luns, num_luns_reported;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
 	struct scsi_lun *first_lun_data, *second_lun_data;
-	u8 *data;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
@@ -1492,10 +1489,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	/*
 	 * Get the length from the first four bytes of first_lun_data.
 	 */
-	data = (u8 *) first_lun_data->scsi_lun;
-	length = ((data[0] << 24) | (data[1] << 16) |
-		  (data[2] << 8) | (data[3] << 0));
-
+	length = get_unaligned_be32(first_lun_data->scsi_lun);
 	num_luns_reported = (length / sizeof(struct scsi_lun));
 
 	if (num_luns_reported > max_scsi_report_luns) {
@@ -1537,10 +1531,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				 * Get the length from the first four bytes
 				 * of second_lun_data.
 				 */
-				data = (u8 *) lun_data->scsi_lun;
-				length = ((data[0] << 24) | (data[1] << 16) |
-					  (data[2] << 8) | (data[3] << 0));
-
+				length = get_unaligned_be32(lun_data->scsi_lun);
 				num_luns = (length / sizeof(struct scsi_lun));
 			}
 		}
-- 
1.8.3.1

