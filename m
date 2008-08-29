From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 5/6] Added flush_disk to factor out common buffer cache
	flushing code.
Date: Fri, 29 Aug 2008 17:13:20 -0600
Message-ID: <20080829231320.25065.44013.stgit@bluto.andrew>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37582 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYH2XNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2008 19:13:22 -0400
In-Reply-To: <20080829231254.25065.66052.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

Added flush_disk to factor out common buffer cache flushing code.

We need to be able to flush the buffer cache for for more than
just when a disk is changed, so we factor out common cache flush code
in check_disk_change() to an internal flush_disk() routine.  This
routine will then be used for both disk changes and disk resizes (in a
later patch).

Include the disk name in the text indicating that there are busy
inodes on the device and increase the KERN severity of the message.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index f8df73a..5ce28b1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -868,6 +868,33 @@ struct block_device *open_by_devnum(dev_t dev, unsigned mode)
 
 EXPORT_SYMBOL(open_by_devnum);
 
+
+/**
+ * flush_disk - invalidates all buffer-cache entries on a disk
+ *
+ * @bdev:      struct block device to be flushed
+ *
+ * Invalidates all buffer-cache entries on a disk. It should be called
+ * when a disk has been changed -- either by a media change or online
+ * resize.
+ */
+static void flush_disk(struct block_device *bdev)
+{
+	if (__invalidate_device(bdev)) {
+		char name[BDEVNAME_SIZE] = "";
+
+		if (bdev->bd_disk)
+			disk_name(bdev->bd_disk, 0, name);
+		printk(KERN_WARNING "VFS: busy inodes on changed media %s\n",
+		       name);
+	}
+
+	if (!bdev->bd_disk)
+		return;
+	if (bdev->bd_disk->minors > 1)
+		bdev->bd_invalidated = 1;
+}
+
 /**
  * check_disk_size_change - checks for disk size change and adjusts
  *                          bdev size.
@@ -945,13 +972,9 @@ int check_disk_change(struct block_device *bdev)
 	if (!bdops->media_changed(bdev->bd_disk))
 		return 0;
 
-	if (__invalidate_device(bdev))
-		printk("VFS: busy inodes on changed media.\n");
-
+	flush_disk(bdev);
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
-	if (bdev->bd_disk->minors > 1)
-		bdev->bd_invalidated = 1;
 	return 1;
 }
 

