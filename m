From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [15/22] Remove GFP_DMA use in sr_ioctl
Date: Mon, 25 Feb 2008 00:35:28 +0100 (CET)
Message-ID: <20080224233528.409161B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:51515 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYBXXvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:39 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


Everything should be bounced by the block layer now

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/sr_ioctl.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux/drivers/scsi/sr_ioctl.c
===================================================================
--- linux.orig/drivers/scsi/sr_ioctl.c
+++ linux/drivers/scsi/sr_ioctl.c
@@ -30,11 +30,6 @@ static int xa_test = 0;
 
 module_param(xa_test, int, S_IRUGO | S_IWUSR);
 
-/* primitive to determine whether we need to have GFP_DMA set based on
- * the status of the unchecked_isa_dma flag in the host structure */
-#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
-
-
 static int sr_read_tochdr(struct cdrom_device_info *cdi,
 		struct cdrom_tochdr *tochdr)
 {
@@ -43,7 +38,7 @@ static int sr_read_tochdr(struct cdrom_d
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kmalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -73,7 +68,7 @@ static int sr_read_tocentry(struct cdrom
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	buffer = kmalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -385,7 +380,7 @@ int sr_get_mcn(struct cdrom_device_info 
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	char *buffer = kmalloc(32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -564,7 +559,7 @@ int sr_is_xa(Scsi_CD *cd)
 	if (!xa_test)
 		return 0;
 
-	raw_sector = kmalloc(2048, GFP_KERNEL | SR_GFP_DMA(cd));
+	raw_sector = kmalloc(2048, GFP_KERNEL);
 	if (!raw_sector)
 		return -ENOMEM;
 	if (0 == sr_read_sector(cd, cd->ms_offset + 16,
