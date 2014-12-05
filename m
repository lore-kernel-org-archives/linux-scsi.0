From: Rob Evers <revers@redhat.com>
Subject: [PATCH V5 2/3] scsi: Use set/get_unaligned_be32 in report_luns
Date: Fri,  5 Dec 2014 14:37:42 -0500
Message-ID: <1417808263-5632-3-git-send-email-revers@redhat.com>
References: <1417808263-5632-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLEThp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 14:37:45 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB5JbjTt019677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2014 14:37:45 -0500
Received: from localhost ([10.18.25.106])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB5Jbjv0010973
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2014 14:37:45 -0500
In-Reply-To: <1417808263-5632-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

---
 drivers/scsi/scsi_scan.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e460b35..8db1f6f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1359,7 +1360,6 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	u8 *data;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
@@ -1425,10 +1425,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
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
@@ -1476,9 +1473,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	/*
 	 * Get the length from the first four bytes of lun_data.
 	 */
-	data = (u8 *) lun_data->scsi_lun;
-	length = ((data[0] << 24) | (data[1] << 16) |
-		  (data[2] << 8) | (data[3] << 0));
+	length = get_unaligned_be32(lun_data->scsi_lun);
 
 	num_luns = (length / sizeof(struct scsi_lun));
 	if (num_luns > max_scsi_report_luns) {
-- 
1.8.3.1

