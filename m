From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] ses: Use vpd information from scsi_device
Date: Mon, 10 Mar 2014 15:28:45 +0100
Message-ID: <1394461725-76203-6-git-send-email-hare@suse.de>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbaCJO2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 10:28:48 -0400
In-Reply-To: <1394461725-76203-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Bart van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The scsi_device now has VPD page83 information attached, so
there is no need to query it again.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ses.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eba183c..80bfece 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/enclosure.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -448,27 +449,18 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
-	unsigned char *buf;
 	unsigned char *desc;
-	unsigned int vpd_len;
 	struct efd efd = {
 		.addr = 0,
 	};
 
-	buf = kmalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
-	if (!buf || scsi_get_vpd_page(sdev, 0x83, buf, INIT_ALLOC_SIZE))
-		goto free;
-
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	vpd_len = ((buf[2] << 8) | buf[3]) + 4;
-	kfree(buf);
-	buf = kmalloc(vpd_len, GFP_KERNEL);
-	if (!buf ||scsi_get_vpd_page(sdev, 0x83, buf, vpd_len))
-		goto free;
+	if (!sdev->vpd_pg83_len)
+		return;
 
-	desc = buf + 4;
-	while (desc < buf + vpd_len) {
+	desc = sdev->vpd_pg83 + 4;
+	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
 		enum scsi_protocol proto = desc[0] >> 4;
 		u8 code_set = desc[0] & 0x0f;
 		u8 piv = desc[1] & 0x80;
@@ -478,25 +470,15 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 		if (piv && code_set == 1 && assoc == 1
 		    && proto == SCSI_PROTOCOL_SAS && type == 3 && len == 8)
-			efd.addr = (u64)desc[4] << 56 |
-				(u64)desc[5] << 48 |
-				(u64)desc[6] << 40 |
-				(u64)desc[7] << 32 |
-				(u64)desc[8] << 24 |
-				(u64)desc[9] << 16 |
-				(u64)desc[10] << 8 |
-				(u64)desc[11];
+			efd.addr = get_unaligned_be64(&desc[4]);
 
 		desc += len + 4;
 	}
-	if (!efd.addr)
-		goto free;
+	if (efd.addr) {
+		efd.dev = &sdev->sdev_gendev;
 
-	efd.dev = &sdev->sdev_gendev;
-
-	enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
- free:
-	kfree(buf);
+		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+	}
 }
 
 static int ses_intf_add(struct device *cdev,
-- 
1.7.12.4

