From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 1/2] Added flush_disk to factor out common buffer cache
	flushing code.
Date: Mon, 05 May 2008 17:04:19 -0600
Message-ID: <20080505230419.12905.36939.stgit@bluto.andrew>
References: <20080505230414.12905.15331.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763241AbYEEXEt@vger.kernel.org>
In-Reply-To: <20080505230414.12905.15331.stgit@bluto.andrew>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, Andrew Patterson <andrew.patterson@hp.com>
List-Id: linux-scsi@vger.kernel.org

Added flush_disk to factor out common buffer cache flushing code.

We need to be able to flush the buffer cache for more than just when a
disk is changed, so we factor out common cache flush code in
check_disk_change() to an internal flush_disk() routine.  This routine
will then be used for both disk changes and disk resizes (in a later
patch).

Include the disk name in the text indicating that there are busy
inodes on the device and increase the KERN severity of the message.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7d822fa..fcd0398 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -867,6 +867,33 @@ struct block_device *open_by_devnum(dev_t dev, unsigned mode)
 
 EXPORT_SYMBOL(open_by_devnum);
 
+
+/**
+ * flush_disk - invalidates all buffer-cache entries on a disk
+ *
+ * @bdev:	struct block device to be flushed
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
 /*
  * This routine checks whether a removable media has been changed,
  * and invalidates all buffer-cache-entries in that case. This
@@ -886,13 +913,9 @@ int check_disk_change(struct block_device *bdev)
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
 
