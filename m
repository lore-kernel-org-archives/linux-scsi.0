From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 1/6] Wrapper for lower-level revalidate_disk routines.
Date: Thu, 04 Sep 2008 14:27:20 -0600
Message-ID: <20080904202720.10456.50628.stgit@bob.kio>
References: <20080904202714.10456.88061.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:42165 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653AbYIDU1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 16:27:21 -0400
In-Reply-To: <20080904202714.10456.88061.stgit@bob.kio>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

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
index c3fa19b..4eeb69a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -852,6 +852,27 @@ struct block_device *open_by_devnum(dev_t dev, unsigned mode)
 
 EXPORT_SYMBOL(open_by_devnum);
 
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
index 02a9fb5..d63461f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1722,6 +1722,7 @@ extern int fs_may_remount_ro(struct super_block *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
+extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);

