Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957EB2F8EAA;
	Sun, 27 Sep 2026 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790497236; cv=none; b=H0on87v+EZLGMTyr2ZSEakFd+bjobJb/rwNiTnovB1Gs5EESJwZIlCZ+N9UMtAWda7PTswqdJXahUBGHl4n/5C6sys8IAK9zLQbImE4VFcFDPBdnwRcNEfE7yDaaXtQI9yasJUOtzynpdK+hi/tnFq/4fhJWq6ISKMHaag3xy+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790497236; c=relaxed/simple;
	bh=UxRIepd9CwHfhzVnTwJXcA5lIX7ZBdjXk0+/LMHOYF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CgBJsLEzmuGQbNCEsMHCKHPlMrKNB+ap0ivl4vikiyN9vWDlw8N5GbEzuZeUJHeTI2/jo+YriRDJ7c/psaDPXLREQU0WeLN2J0RxVYVY20r6j6jXft7DA2/9m6xKpuSKNqNx9yDr/aGSN+YkGLNGw1ZR06HLCGBohkmK85iqQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=VZHAPQrn; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="VZHAPQrn"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f3a443fa;
	Sun, 27 Sep 2026 16:20:24 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Christoph Hellwig <hch@lst.de>
Cc: Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Lee Duncan <lduncan@suse.com>,
	Hannes Reinecke <hare@suse.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v7 1/4] fs: configfs: add helpers for opening non-configfs paths
Date: Sun, 27 Sep 2026 16:20:08 +0800
Message-Id: <20260927082011.638723-2-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
References: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0e1f377d203a1kunm12f6b69c1ac336
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGBkZVk4aHkhJQx5LSE5CGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=VZHAPQrn96pCV7pTnfuY6/AdqV/6JKT6ykY8D5GikQ0gvRv5efzXtxhlT4GRiuxYrsLq00MEmqRdTZPSxCSrdOe6wO3eAusLhf1G0blildWHc31P145qDG/tIXY7uU27DRWBe7nSzsvFiiFb2RTJim0YMOPfuPAyB+ilcU5lOzk=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=d5JnXFH+gOpA+ULZ4kh2lFWrt905jPAi3bCsy9qIaq0=;
	h=date:mime-version:subject:message-id:from;

Configfs store callbacks hold frag_sem while they run.  Reopening a path
that resolves to configfs from such a callback can acquire the same
non-recursive semaphore again.

Add configfs_file_open() for configured pathnames and configfs_open_root()
for paths relative to a resolved root.  Reject configfs roots before using
file_open_root() so the normal open checks remain in place.

Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 fs/configfs/mount.c      | 57 ++++++++++++++++++++++++++++++++++++++++
 include/linux/configfs.h |  5 ++++
 2 files changed, 62 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd5..aa79be05dd5bc 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -118,6 +119,62 @@ static struct file_system_type configfs_fs_type = {
 };
 MODULE_ALIAS_FS("configfs");
 
+/**
+ * configfs_open_root - open a path below a non-configfs root
+ * @root: resolved root path
+ * @name: path relative to @root
+ * @flags: open flags
+ * @mode: mode for a newly created file
+ *
+ * Use this from configfs store callbacks with a resolved non-configfs root
+ * to avoid re-entering configfs while the callback holds its fragment
+ * semaphore.
+ *
+ * Return: opened file, or an ERR_PTR() value.  Returns -EINVAL if @root
+ * is on configfs.
+ */
+struct file *configfs_open_root(const struct path *root, const char *name,
+				int flags, umode_t mode)
+{
+	if (root->dentry->d_sb->s_type == &configfs_fs_type)
+		return ERR_PTR(-EINVAL);
+
+	return file_open_root(root, name, flags, mode);
+}
+EXPORT_SYMBOL_GPL(configfs_open_root);
+
+/**
+ * configfs_file_open - open an existing non-configfs pathname
+ * @filename: pathname to open; it must already exist
+ * @flags: open flags for the existing pathname
+ * @mode: unused; creation is not supported
+ *
+ * Resolve @filename and reject configfs paths.  Use this from configfs
+ * store callbacks for existing configured paths.  O_NOFOLLOW is honored
+ * when resolving the final path component.
+ *
+ * Return: opened file, or an ERR_PTR() value.  Returns -EINVAL if the
+ * resolved path is on configfs.
+ */
+struct file *configfs_file_open(const char *filename, int flags, umode_t mode)
+{
+	struct file *file;
+	struct path path;
+	unsigned int lookup_flags = 0;
+	int ret;
+
+	if (!(flags & O_NOFOLLOW))
+		lookup_flags = LOOKUP_FOLLOW;
+	ret = kern_path(filename, lookup_flags, &path);
+	if (ret)
+		return ERR_PTR(ret);
+
+	file = configfs_open_root(&path, "", flags, mode);
+	path_put(&path);
+	return file;
+}
+EXPORT_SYMBOL_GPL(configfs_file_open);
+
 struct dentry *configfs_pin_fs(void)
 {
 	int err = simple_pin_fs(&configfs_fs_type, &configfs_mount,
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index ef65c75beeaad..2a803bb836b4d 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -34,6 +34,8 @@ struct configfs_group_operations;
 struct configfs_attribute;
 struct configfs_bin_attribute;
 struct configfs_subsystem;
+struct file;
+struct path;
 
 struct config_item {
 	char			*ci_name;
@@ -243,6 +245,9 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 int configfs_register_group(struct config_group *parent_group,
 			    struct config_group *group);
 void configfs_unregister_group(struct config_group *group);
+struct file *configfs_open_root(const struct path *root, const char *name,
+				int flags, umode_t mode);
+struct file *configfs_file_open(const char *filename, int flags, umode_t mode);
 
 void configfs_remove_default_groups(struct config_group *group);
 
-- 
2.34.1

