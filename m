Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9EB23EA97;
	Tue, 18 Aug 2026 07:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038568; cv=none; b=HKeSlM9QeI7GfyqJiuGvV/pNc3OviUpqaklYroZ2l3SEAoxSYnQs6RzwHn7Sl6Sb3i3hWfmP5vwLxq2WftY/n7HDRf7yAmINIifsmR1d/0WX4zTmvJKBuyLEt0aAN3NLrdjWn15GVYssy1NBtPjqgXl7qU0pflS2iPW1EYx5TxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038568; c=relaxed/simple;
	bh=uTp+uLto/TEqOTFzZDptyQ6pUb6Frc5lNvFWs20Y3xA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kEmO011sU2NRAzaNbSGXSGxesPR1HRs89QQLGZ6jHDgPVfZu5OJHpJXC9lb2q41nXgSDyPO9aegCUlSnobX8252FCoXMtNVOEw2tRP4giS1Z1CyBZtXZ1oOUZpxpM33Lhd6TGr7WMi5qc6uyYbPWtCQrH4AaYvHMUkaPkt6zAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=mcOYsRl9; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="mcOYsRl9"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4a6132812;
	Tue, 18 Aug 2026 15:35:56 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] scsi: target: file: avoid recursive configfs open in fd_init_prot()
Date: Tue, 18 Aug 2026 15:35:39 +0800
Message-Id: <20260818073539.1555605-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260818045807.1519433-1-runyu.xiao@seu.edu.cn>
References: <20260818045807.1519433-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa013cc61b903a1kunm1ff69152105bd3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTEsdVh0YSkxNSkxLHhhNQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=mcOYsRl9y+9t4ROPQO6DjJeE0KHSxvMtSLQ43Ww4YF4Oey0Vg97BCIYhp5vadPCYH0/CSaAvwAKW0e2P1owXs151xi8qk95NQXd0icxuPNwWCC/Ue+IafdA0HgQ1WwWDwdtxC8TzR2LmHdMebrfxd52ctS+20EuN7czLO+INNcc=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=4IWrbNq7h4KF+lauRZBDNE72SQyrFEFofHbGv3OQkn4=;
	h=date:mime-version:subject:message-id:from;

pi_prot_type_store() runs under the configfs item's frag_sem.  For
FILEIO devices it calls fd_init_prot(), which rebuilds a
"$FILE.protection" pathname from fd_dev_name and opens it with
filp_open().  If that pathname resolves inside configfs, the open path
can re-enter configfs while the store callback still holds frag_sem.

By the time fd_init_prot() runs, the backing file has already been
configured and pinned in fd_dev->fd_file.  Instead of reopening a
user-controlled pathname, derive the protection sidecar from the
configured backing file itself: reject configfs-backed backing files,
take the opened file's parent dentry, and open or create
"<resolved-name>.protection" there with direct dentry operations.

This keeps the PI sidecar tied to the configured backing file, avoids a
new pathname walk from the configfs store path, and also rejects
stacked filesystems whose real backing file lives on configfs.

Fixes: 0f5e2ec46dd6 ("target/file: Add DIF protection init/format support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

v2:
- narrow the scope to 022 / fd_init_prot() only
- drop the earlier shared 022/023 pathname helper attempt
- use LOOKUP_CREATE so a missing sidecar can actually be created
- open or create the PI sidecar next to the configured backing file
---
 drivers/target/target_core_file.c | 102 +++++++++++++++++++++++++++---
 drivers/target/target_core_file.h |   1 -
 2 files changed, 94 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef74633c..b7810ccceb44 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -19,6 +19,10 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/falloc.h>
+#include <linux/limits.h>
+#include <linux/magic.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
 #include <linux/uio.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_proto.h>
@@ -86,6 +90,86 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static bool fd_backing_file_is_configfs(struct file *file)
+{
+	return d_real(file_dentry(file), D_REAL_DATA)->d_sb->s_magic ==
+	       CONFIGFS_MAGIC;
+}
+
+static int fd_open_prot_file(struct file *file, int flags, umode_t mode,
+			     struct file **filep)
+{
+	struct dentry *backing_dentry = file_dentry(file);
+	struct path parent_path = {
+		.mnt = mntget(file->f_path.mnt),
+		.dentry = dget_parent(backing_dentry),
+	};
+	struct path prot_path = { .mnt = parent_path.mnt };
+	struct file *prot_file;
+	struct qstr prot_qname;
+	char *prot_name;
+	size_t prot_name_len;
+	int ret;
+
+	if (fd_backing_file_is_configfs(file)) {
+		ret = -EINVAL;
+		goto out_put_parent;
+	}
+
+	prot_name_len = backing_dentry->d_name.len + strlen(".protection");
+	if (prot_name_len > NAME_MAX) {
+		ret = -ENAMETOOLONG;
+		goto out_put_parent;
+	}
+
+	prot_name = kmalloc(prot_name_len + 1, GFP_KERNEL);
+	if (!prot_name) {
+		ret = -ENOMEM;
+		goto out_put_parent;
+	}
+
+	memcpy(prot_name, backing_dentry->d_name.name, backing_dentry->d_name.len);
+	memcpy(prot_name + backing_dentry->d_name.len, ".protection",
+	       strlen(".protection") + 1);
+	prot_qname = QSTR_INIT(prot_name, prot_name_len);
+
+	inode_lock_nested(d_inode(parent_path.dentry), I_MUTEX_PARENT);
+	prot_path.dentry = lookup_one_qstr_excl(&prot_qname, parent_path.dentry,
+						LOOKUP_CREATE);
+	if (IS_ERR(prot_path.dentry)) {
+		ret = PTR_ERR(prot_path.dentry);
+		goto out_unlock;
+	}
+
+	if (d_is_negative(prot_path.dentry)) {
+		ret = mnt_want_write_file(file);
+		if (ret)
+			goto out_dput;
+
+		prot_file = dentry_create(&prot_path, flags, mode, current_cred());
+		mnt_drop_write_file(file);
+	} else {
+		prot_file = dentry_open(&prot_path, flags & ~O_CREAT,
+					current_cred());
+	}
+	if (IS_ERR(prot_file)) {
+		ret = PTR_ERR(prot_file);
+		goto out_dput;
+	}
+
+	*filep = prot_file;
+	ret = 0;
+
+out_dput:
+	dput(prot_path.dentry);
+out_unlock:
+	inode_unlock(d_inode(parent_path.dentry));
+	kfree(prot_name);
+out_put_parent:
+	path_put(&parent_path);
+	return ret;
+}
+
 static bool fd_configure_unmap(struct se_device *dev)
 {
 	struct file *file = FD_DEV(dev)->fd_file;
@@ -827,7 +911,6 @@ static int fd_init_prot(struct se_device *dev)
 	struct file *prot_file, *file = fd_dev->fd_file;
 	struct inode *inode;
 	int ret, flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
-	char buf[FD_MAX_DEV_PROT_NAME];
 
 	if (!file) {
 		pr_err("Unable to locate fd_dev->fd_file\n");
@@ -844,13 +927,16 @@ static int fd_init_prot(struct se_device *dev)
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE)
 		flags &= ~O_DSYNC;
 
-	snprintf(buf, FD_MAX_DEV_PROT_NAME, "%s.protection",
-		 fd_dev->fd_dev_name);
-
-	prot_file = filp_open(buf, flags, 0600);
-	if (IS_ERR(prot_file)) {
-		pr_err("filp_open(%s) failed\n", buf);
-		ret = PTR_ERR(prot_file);
+	ret = fd_open_prot_file(file, flags, 0600, &prot_file);
+	if (ret) {
+		if (ret == -EINVAL)
+			pr_err("configfs-backed FILEIO backends cannot store PI metadata\n");
+		else if (ret == -ENAMETOOLONG)
+			pr_err("protection sidecar name is too long for FILEIO backend: %pd.protection\n",
+			       file_dentry(file));
+		else
+			pr_err("failed to open FILEIO protection sidecar for %pd: %d\n",
+			       file_dentry(file), ret);
 		return ret;
 	}
 	fd_dev->fd_prot_file = prot_file;
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 929b1ecd544e..1b4c1b43827f 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -7,7 +7,6 @@
 #define FD_VERSION		"4.0"
 
 #define FD_MAX_DEV_NAME		256
-#define FD_MAX_DEV_PROT_NAME	FD_MAX_DEV_NAME + 16
 #define FD_DEVICE_QUEUE_DEPTH	32
 #define FD_MAX_DEVICE_QUEUE_DEPTH 128
 #define FD_BLOCKSIZE		512
-- 
2.34.1
