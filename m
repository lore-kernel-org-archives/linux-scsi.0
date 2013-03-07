From: Rob Evers <revers@redhat.com>
Subject: [PATCH V3 4/4] Use set/get_unaligned_be32 in report_luns
Date: Thu,  7 Mar 2013 08:38:35 -0500
Message-ID: <1362663515-3476-5-git-send-email-revers@redhat.com>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab3CGNim (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 08:38:42 -0500
In-Reply-To: <1362663515-3476-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: revers@redhat.com, michaelc@cs.wisc.edu, bvanassche@acm.org, emilne@redhat.com

---
 drivers/scsi/scsi_scan.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1d41730..31bda4b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1301,10 +1302,7 @@ int scsi_do_report_luns(struct scsi_device *sdev, int length,
 	/*
 	 * bytes 6 - 9: length of the command.
 	 */
-	scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
-	scsi_cmd[7] = (unsigned char) (length >> 16) & 0xff;
-	scsi_cmd[8] = (unsigned char) (length >> 8) & 0xff;
-	scsi_cmd[9] = (unsigned char) length & 0xff;
+	put_unaligned_be32(0xffffffff, &scsi_cmd[6]);
 
 	scsi_cmd[10] = 0;	/* reserved */
 	scsi_cmd[11] = 0;	/* control */
@@ -1441,10 +1439,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
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
@@ -1486,10 +1481,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				 * Get the length from the first four bytes
 				 * of second_lun_data.
 				 */
-				data = (u8 *) lun_data->scsi_lun;
-				length = ((data[0] << 24) | (data[1] << 16) |
-				  (data[2] << 8) | (data[3] << 0));
-
+				length = get_unaligned_be32(lun_data->scsi_lun);
 				num_luns = (length / sizeof(struct scsi_lun));
 			}
 		}
-- 
1.7.11.7

