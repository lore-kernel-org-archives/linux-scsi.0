From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH] [SCSI] remove arbitrary SD_MAX_DISKS namespace limit
Date: Mon, 03 Oct 2011 11:47:29 -0500
Message-ID: <4E89E721.7000308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:56385 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1JCQrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 12:47:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

I see no reason to limit the SCSI disk namespace to sdXXX. We test
systems with more than 18278 LUNs.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..741c7f7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2592,12 +2592,6 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
-	if (index >= SD_MAX_DISKS) {
-		error = -ENODEV;
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
-		goto out_free_index;
-	}
-
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error)
 		goto out_free_index;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ad798b..4163f29 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -9,12 +9,6 @@
 #define SD_MAJORS	16
 
 /*
- * This is limited by the naming scheme enforced in sd_probe,
- * add another character to it if you really need more disks.
- */
-#define SD_MAX_DISKS	(((26 * 26) + 26 + 1) * 26)
-
-/*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
  */
 #define SD_TIMEOUT		(30 * HZ)
