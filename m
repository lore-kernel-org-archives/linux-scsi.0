From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 17/68] vfs: Convert ocxlflash to use the new mount API
Date: Wed, 27 Mar 2019 23:42:40 +0000
Message-ID: <155373016082.7602.4120889926195878627.stgit@warthog.procyon.org.uk>
References: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-scsi@vger.kernel.org

Convert the ocxlflash filesystem to the new internal mount API as the old
one will be obsoleted and removed.  This allows greater flexibility in
communication of mount parameters between userspace, the VFS and the
filesystem.

See Documentation/filesystems/mount_api.txt for more information.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
cc: "Manoj N. Kumar" <manoj@linux.ibm.com>
cc: Uma Krishnan <ukrishn@linux.ibm.com>
cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
cc: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: linux-scsi@vger.kernel.org
---

 drivers/scsi/cxlflash/ocxl_hw.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 37b8dc60f5f6..a8d2cc6390c7 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/module.h>
 #include <linux/mount.h>
+#include <linux/fs_context.h>
 #include <linux/poll.h>
 #include <linux/sched/signal.h>
 
@@ -39,27 +40,17 @@ static const struct dentry_operations ocxlflash_fs_dops = {
 	.d_dname	= simple_dname,
 };
 
-/*
- * ocxlflash_fs_mount() - mount the pseudo-filesystem
- * @fs_type:	File system type.
- * @flags:	Flags for the filesystem.
- * @dev_name:	Device name associated with the filesystem.
- * @data:	Data pointer.
- *
- * Return: pointer to the directory entry structure
- */
-static struct dentry *ocxlflash_fs_mount(struct file_system_type *fs_type,
-					 int flags, const char *dev_name,
-					 void *data)
+static int ocxlflash_fs_init_fs_context(struct fs_context *fc)
 {
-	return mount_pseudo(fs_type, "ocxlflash:", NULL, &ocxlflash_fs_dops,
-			    OCXLFLASH_FS_MAGIC);
+	return vfs_init_pseudo_fs_context(fc, "ocxlflash:",
+					  NULL, NULL,
+					  &ocxlflash_fs_dops, OCXLFLASH_FS_MAGIC);
 }
 
 static struct file_system_type ocxlflash_fs_type = {
 	.name		= "ocxlflash",
 	.owner		= THIS_MODULE,
-	.mount		= ocxlflash_fs_mount,
+	.init_fs_context = ocxlflash_fs_init_fs_context,
 	.kill_sb	= kill_anon_super,
 };
 
