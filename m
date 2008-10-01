From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Switch kernel printing level for DIF messages
Date: Wed, 01 Oct 2008 01:37:21 -0400
Message-ID: <yq1iqsckh9q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:43787 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYJAFh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 01:37:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com


For some reason these messages ended up being printed with KERN_INFO
rendering them invisible to pretty much everyone.  Switch to
KERN_NOTICE.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -322,10 +322,10 @@ void sd_dif_config_host(struct scsi_disk
 
 	if (type) {
 		if (dif)
-			sd_printk(KERN_INFO, sdkp,
+			sd_printk(KERN_NOTICE, sdkp,
 				  "Enabling DIF Type %d protection\n", type);
 		else
-			sd_printk(KERN_INFO, sdkp,
+			sd_printk(KERN_NOTICE, sdkp,
 				  "Disabling DIF Type %d protection\n", type);
 	}
 
@@ -344,7 +344,7 @@ void sd_dif_config_host(struct scsi_disk
 		else
 			blk_integrity_register(disk, &dif_type1_integrity_crc);
 
-	sd_printk(KERN_INFO, sdkp,
+	sd_printk(KERN_NOTICE, sdkp,
 		  "Enabling DIX %s protection\n", disk->integrity->name);
 
 	/* Signal to block layer that we support sector tagging */
@@ -354,7 +354,7 @@ void sd_dif_config_host(struct scsi_disk
 		else
 			disk->integrity->tag_size = sizeof(u16);
 
-		sd_printk(KERN_INFO, sdkp, "DIF application tag size %u\n",
+		sd_printk(KERN_NOTICE, sdkp, "DIF application tag size %u\n",
 			  disk->integrity->tag_size);
 	}
 }

