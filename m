From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [ConfigFS]: Add struct
	configfs_item_operations->check_link()
Date: Fri, 03 Apr 2009 01:25:07 -0700
Message-ID: <1238747107.4250.448.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:30327 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751893AbZDCIZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 04:25:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Hi Joel and co,

This patch adds struct configfs_item_operations->check_link() and
changes fs/configfs/symlink.c:configfs_unlink() so that
when (*check_link) is present, an ConfigFS unlink will fail, based upon
input by said symlinked struct config_item *parent_item.

If a non zero return is returned from (*check_link), said non zero value is
expected to use include/asm-generic/errno* values, and the failure is returned
to userspace via the unlink(2) system call.

Please consider this patch for v2.6.30.  It requires no changes to existing consumers
of ConfigFS like fs/ocfs2, and I have tested it with running LIO-Target v3.0 code.

Many thanks for your most valuable of time,

--nab

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/configfs/symlink.c    |   13 +++++++++++++
 include/linux/configfs.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 932a92b..a5dede6 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -202,6 +202,19 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
 
+	/*
+	 * See if the underlying struct config_item has dependent
+	 * symlinks, and should return -EACCES here.
+	 */
+	if (type && type->ct_item_ops &&
+	    type->ct_item_ops->check_link) {
+		ret = type->ct_item_ops->check_link(parent_item);
+		if (ret != 0) {
+			config_item_put(parent_item);
+			goto out;
+		}
+	}
+
 	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
 	spin_unlock(&configfs_dirent_lock);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 7f62777..b026f16 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -226,6 +226,7 @@ struct configfs_item_operations {
 	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
 	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
+	int (*check_link)(struct config_item *src);
 	int (*drop_link)(struct config_item *src, struct config_item *target);
 };
 
-- 
1.5.4.1



