Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4B33C4551;
	Tue, 18 Aug 2026 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048206; cv=none; b=oMFAIL08C53oDb8xD+Oc2lBf7lRtTaS7qzwyNH/bV0TW9tnmmOOz2R5YAT1wHECtaRTUvO7Nxbs0UbPDwxydDJGS4Z7NI+fXSW73MXQkmq2T42xtt572+0JIjSN7ydu5dSiPgQ2wRaiyxfQdYwBtdCk1XhwxpBEtt9T7SGJE6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048206; c=relaxed/simple;
	bh=L3b81slb/Ts1+wLK1+uRpbGWlJLkpABY/WhJOUquCVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AcbobZuU0DAQD36L8+2HrbpI3eOD3NOS+JNm4a5jUIwplnUVpe6PRKXyY1iHu+9Nb7HQL29WNeb7ZUS0uMXn3JbKR1rvOHMAFLFcHt6GmSwOVNIhR/jmrQXuAk8A4w477ErJEj+Bx7GXqJUfMnHZ4iL/fdtAgs4/u2zRv+NGp6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=kQOvR5bG; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="kQOvR5bG"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4a686089a;
	Tue, 18 Aug 2026 18:16:36 +0800 (GMT+08:00)
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
Subject: [PATCH v4] scsi: target: file: avoid recursive configfs open in fd_init_prot()
Date: Tue, 18 Aug 2026 18:16:29 +0800
Message-Id: <20260818101629.1605914-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260818091326.1582200-1-runyu.xiao@seu.edu.cn>
References: <20260818091326.1582200-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0145f7b4103a1kunmd0ac088210b3c8
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGhlPVktDSEoZSk1KH0gYHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=kQOvR5bG/R8xvVijFjSNj10y9wzCiOkGfCmKsT5I/5V76Y0V7vEr8EjXZkAwQgesQv5j0DGkKyoBKc5cEBStpEdsx7nS6Ote+pVh/TAKdqRlpuvavOvgUcC6aa4euJd3wBCcGSFir/FGfQkwgtjfYi4ZR3xcCrfXxZMlmrHFgW0=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=O7ActeCoeUSN14a3UrmojewYNhTN9/Gu9QpC33NfHss=;
	h=date:mime-version:subject:message-id:from;

pi_prot_type_store() runs under the configfs item's frag_sem.  For
FILEIO devices it calls fd_init_prot(), which rebuilds a
"$FILE.protection" pathname from fd_dev_name and opens it with
filp_open().  If that pathname resolves inside configfs, the open path
can re-enter configfs while the store callback still holds frag_sem.

By the time fd_init_prot() runs, the backing file has already been
configured and pinned in fd_dev->fd_file, so avoid reopening a
user-controlled pathname.  Instead, derive the protection sidecar from
the opened backing file itself: reject configfs-backed backing files,
take freeze protection before locking the parent directory, snapshot the
stable backing dentry name under that lock, and look up the sibling
sidecar by that stable name.  Create the sidecar directly when it is
absent, but only reopen an existing sidecar if it is a regular file.

If the backing file is itself the root of a mounted file, there is no
in-mount sibling pathname for a ".protection" sidecar.  Reject that
case explicitly instead of reconstructing a pathname from fd_dev_name,
which would reintroduce the same configfs recursion hazard this fix is
trying to remove.

When reopening an existing sidecar, restore the same open-time access
checks that a pathname-based open would have enforced before calling
dentry_open().  This preserves inode_permission() / MAY_OPEN gating for
existing sidecars and continues to reject immutable, append-only, and
otherwise unauthorized files.

This keeps the PI sidecar tied to the opened backing file while closing
the rename, hash initialization, non-regular sidecar, sb_writers
ordering, and existing-sidecar permission-check issues in the earlier
drafts.

Link: https://lore.kernel.org/r/20260818091326.1582200-1-runyu.xiao@seu.edu.cn
Fixes: 0f5e2ec46dd6 ("target/file: Add DIF protection init/format support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
v4:
- restore may_open()-equivalent permission checks before dentry_open()
- reject unauthorized existing PI sidecars via inode_permission()
- keep append-only and O_NOATIME open-time checks for existing sidecars

 drivers/target/target_core_file.c | 184 ++++++++++++++++++++++++++++--
 drivers/target/target_core_file.h |   1 -
 2 files changed, 176 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef74633c..3b4f270a913a 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -19,6 +19,10 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/falloc.h>
+#include <linux/dcache.h>
+#include <linux/limits.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
 #include <linux/uio.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_proto.h>
@@ -86,6 +90,162 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static bool fd_backing_file_is_configfs(struct file *file)
+{
+	return !strcmp(d_real(file_dentry(file), D_REAL_DATA)->d_sb->s_type->name,
+		       "configfs");
+}
+
+static int fd_may_open_existing_file(const struct path *path, int flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
+	int acc_mode = ACC_MODE(flags);
+	int ret;
+
+	if (flags & O_APPEND)
+		acc_mode |= MAY_APPEND;
+
+	ret = inode_permission(idmap, inode, MAY_OPEN | acc_mode);
+	if (ret)
+		return ret;
+
+	if (IS_APPEND(inode)) {
+		if ((flags & O_ACCMODE) != O_RDONLY && !(flags & O_APPEND))
+			return -EPERM;
+		if (flags & O_TRUNC)
+			return -EPERM;
+	}
+
+	if (flags & O_NOATIME && !inode_owner_or_capable(idmap, inode))
+		return -EPERM;
+
+	return 0;
+}
+
+static int fd_open_prot_file(struct file *file, int flags, umode_t mode,
+			     struct file **filep)
+{
+	struct dentry *backing_dentry = file_dentry(file);
+	struct name_snapshot backing_name;
+	struct path parent_path;
+	struct path prot_path;
+	struct file *prot_file;
+	struct qstr prot_qname;
+	char *prot_name;
+	size_t prot_name_len;
+	int ret, retries = 0;
+
+	if (fd_backing_file_is_configfs(file))
+		return -EOPNOTSUPP;
+
+	/*
+	 * A regular file used as the root of a mount has no in-mount sibling
+	 * pathname for a ".protection" sidecar.  Reconstructing one from the
+	 * original string path would reopen the configfs recursion hole.
+	 */
+	if (backing_dentry == file->f_path.mnt->mnt_root)
+		return -EXDEV;
+
+retry:
+	parent_path.mnt = mntget(file->f_path.mnt);
+	parent_path.dentry = dget_parent(backing_dentry);
+	prot_path.mnt = parent_path.mnt;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto out_put_parent;
+
+	inode_lock_nested(d_inode(parent_path.dentry), I_MUTEX_PARENT);
+	if (d_unlinked(backing_dentry) ||
+	    backing_dentry->d_parent != parent_path.dentry) {
+		ret = -ESTALE;
+		goto out_unlock;
+	}
+
+	take_dentry_name_snapshot(&backing_name, backing_dentry);
+	prot_name_len = backing_name.name.len + strlen(".protection");
+	if (prot_name_len > NAME_MAX) {
+		ret = -ENAMETOOLONG;
+		goto out_release_name;
+	}
+
+	prot_name = kmalloc(prot_name_len + 1, GFP_KERNEL);
+	if (!prot_name) {
+		ret = -ENOMEM;
+		goto out_release_name;
+	}
+
+	memcpy(prot_name, backing_name.name.name, backing_name.name.len);
+	memcpy(prot_name + backing_name.name.len, ".protection",
+	       strlen(".protection") + 1);
+	prot_qname = QSTR_LEN(prot_name, prot_name_len);
+
+	prot_path.dentry = lookup_one(mnt_idmap(parent_path.mnt), &prot_qname,
+				      parent_path.dentry);
+	if (IS_ERR(prot_path.dentry)) {
+		ret = PTR_ERR(prot_path.dentry);
+		goto out_free_name;
+	}
+
+	if (d_is_negative(prot_path.dentry)) {
+		prot_file = dentry_create(&prot_path, flags, mode, current_cred());
+	} else {
+		if (!d_is_reg(prot_path.dentry)) {
+			ret = -EINVAL;
+			goto out_dput;
+		}
+
+		ret = fd_may_open_existing_file(&prot_path, flags & ~O_CREAT);
+		if (ret)
+			goto out_dput;
+
+		inode_unlock(d_inode(parent_path.dentry));
+		mnt_drop_write_file(file);
+		release_dentry_name_snapshot(&backing_name);
+		kfree(prot_name);
+
+		prot_file = dentry_open(&prot_path, flags & ~O_CREAT,
+					current_cred());
+		if (IS_ERR(prot_file)) {
+			ret = PTR_ERR(prot_file);
+			goto out_dput_nolock;
+		}
+
+		*filep = prot_file;
+		ret = 0;
+		goto out_dput_nolock;
+	}
+
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
+out_free_name:
+	kfree(prot_name);
+out_release_name:
+	release_dentry_name_snapshot(&backing_name);
+out_unlock:
+	inode_unlock(d_inode(parent_path.dentry));
+	mnt_drop_write_file(file);
+out_put_parent:
+	path_put(&parent_path);
+	if (ret == -ESTALE && !retries++)
+		goto retry;
+	return ret;
+
+out_dput_nolock:
+	dput(prot_path.dentry);
+	path_put(&parent_path);
+	return ret;
+}
+
 static bool fd_configure_unmap(struct se_device *dev)
 {
 	struct file *file = FD_DEV(dev)->fd_file;
@@ -827,7 +987,6 @@ static int fd_init_prot(struct se_device *dev)
 	struct file *prot_file, *file = fd_dev->fd_file;
 	struct inode *inode;
 	int ret, flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
-	char buf[FD_MAX_DEV_PROT_NAME];
 
 	if (!file) {
 		pr_err("Unable to locate fd_dev->fd_file\n");
@@ -844,13 +1003,22 @@ static int fd_init_prot(struct se_device *dev)
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
+		if (ret == -EOPNOTSUPP)
+			pr_err("FILEIO PI sidecars are not supported for configfs-backed backends\n");
+		else if (ret == -EXDEV)
+			pr_err("FILEIO PI sidecars are not supported when the backend file is the root of a mount\n");
+		else if (ret == -EINVAL)
+			pr_err("existing FILEIO PI sidecar must be a regular file\n");
+		else if (ret == -ENAMETOOLONG)
+			pr_err("FILEIO PI sidecar name is too long: %pd.protection\n",
+			       file_dentry(file));
+		else if (ret == -ESTALE)
+			pr_err("FILEIO backing file moved during PI sidecar setup\n");
+		else
+			pr_err("failed to open FILEIO PI sidecar for %pd: %d\n",
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
