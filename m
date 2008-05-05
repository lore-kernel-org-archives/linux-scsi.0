From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2/2] Wrapper for lower-level revalidate_disk routines.
Date: Mon, 05 May 2008 17:04:24 -0600
Message-ID: <20080505230424.12905.53073.stgit@bluto.andrew>
References: <20080505230414.12905.15331.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:11103 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760832AbYEEXEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 19:04:25 -0400
In-Reply-To: <20080505230414.12905.15331.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, Andrew Patterson <andrew.patterson@hp.com>

Wrapper for lower-level revalidate_disk routines.

This is a wrapper for the lower-level revalidate_disk call-backs such
as sd_revalidate_disk(). It allows us to perform pre and post
operations when calling them.

We will use this wrapper in a later patch to adjust block device sizes
after an online resize (a _post_ operation).

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c     |   21 +++++++++++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index fcd0398..b510451 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -894,6 +894,27 @@ static void flush_disk(struct block_device *bdev)
 		bdev->bd_invalidated = 1;
 }
 
+/**
+ * revalidate_disk - wrapper for lower-level driver's revalidate_disk
+ *                   call-back
+ *
+ * @disk: struct gendisk to be revalidated
+ *
+ * This routine is a wrapper for lower-level driver's revalidate_disk
+ * call-backs.  It is used to do common pre and post operations needed
+ * for all revalidate_disk operations.
+ */
+int revalidate_disk(struct gendisk *disk)
+{
+	int ret = 0;
+
+	if (disk->fops->revalidate_disk)
+		ret = disk->fops->revalidate_disk(disk);
+
+	return ret;
+}
+EXPORT_SYMBOL(revalidate_disk);
+
 /*
  * This routine checks whether a removable media has been changed,
  * and invalidates all buffer-cache-entries in that case. This
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..278172f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1665,6 +1665,7 @@ extern int fs_may_remount_ro(struct super_block *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
+extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);

