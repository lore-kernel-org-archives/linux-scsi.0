From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 11 of 16] Move scsi_disk() accessor function to sd.h
Date: Fri, 25 Apr 2008 19:12:13 -0400
Message-ID: <b512cd02f8b0de20d093.1209165133@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44318 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759909AbYDYXR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:29 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2 files changed, 5 insertions(+), 5 deletions(-)
drivers/scsi/sd.c |    5 -----
include/scsi/sd.h |    5 +++++


Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r d13d7571165e -r b512cd02f8b0 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/sd.c	Fri Apr 25 17:39:29 2008 -0400
@@ -292,11 +292,6 @@
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
diff -r d13d7571165e -r b512cd02f8b0 include/scsi/sd.h
--- a/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
@@ -50,6 +50,11 @@
 
 extern void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 
+static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
+{
+	return container_of(disk->private_data, struct scsi_disk, driver);
+}
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\


