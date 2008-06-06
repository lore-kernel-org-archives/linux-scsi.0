From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/3] sd: Move scsi_disk() accessor function to sd.h
Date: Fri, 06 Jun 2008 15:26:03 -0400
Message-ID: <yq1ej7al60k.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:17990 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbYFFTbG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 15:31:06 -0400
Received: from agmgw1.us.oracle.com (agmgw1.us.oracle.com [152.68.180.212])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id m56JV4OL022663
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 14:31:04 -0500
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by agmgw1.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id m56DRTLb022307
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 13:31:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sd: Move scsi_disk() accessor function to sd.h

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 51000f654ef3 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sat Jan 26 02:00:13 2008 -0500
+++ b/drivers/scsi/sd.c	Sat Jan 26 02:01:55 2008 -0500
@@ -282,11 +282,6 @@ static int sd_major(int major_idx)
 		BUG();
 		return 0;	/* shut up gcc */
 	}
-}
-
-static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
-{
-	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
 static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
diff -r 51000f654ef3 drivers/scsi/sd.h
--- a/drivers/scsi/sd.h	Sat Jan 26 02:00:13 2008 -0500
+++ b/drivers/scsi/sd.h	Sat Jan 26 02:01:55 2008 -0500
@@ -50,6 +50,11 @@ struct scsi_disk {
 
 extern void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 
+static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
+{
+	return container_of(disk->private_data, struct scsi_disk, driver);
+}
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\

