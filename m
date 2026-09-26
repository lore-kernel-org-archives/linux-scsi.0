Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C733AD50B;
	Sat, 26 Sep 2026 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790414551; cv=none; b=a6ZVu+687R3Cf6xlwqS0eoAljN+awXUZ6ZWwLr3tumSAo1hTfbU3FytiAu1kHdD7qbqXVnfY1BozBpeIWWl1Syb63a2huuzOG4hbJnCRLvGbPs4qxGQh15qyvd0m0t5pbupoqlPx9SSiC9aCPbDzPDvUn/EDSdn0WfRKdkoQSWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790414551; c=relaxed/simple;
	bh=6ZxI2uq3/Zdrw8YOFkyzf6CQQfI+or4nqVou7H/qG5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iZeF8+kUnxleGv86bh0qs1l7E1zFZ6PDxilaKcPhALtFH6isEqKxkwjPlBoT8UnqtYOnEmd3i9OSmJGGdqwhzmnZhWUPaegF6Ws3T1YAADqGaahEuMfjyjsxzsdyfSVVubRz+hgqJPH3BMrrGeYslK8WW9B39+P5vNSoIN/k1hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=hyFL+os7; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="hyFL+os7"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f2ff7122;
	Sat, 26 Sep 2026 17:21:56 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Christoph Hellwig <hch@lst.de>
Cc: Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
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
Subject: [PATCH v6 1/4] fs: configfs: add helpers for opening non-configfs paths
Date: Sat, 26 Sep 2026 17:21:45 +0800
Message-Id: <20260926092148.128937-2-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
References: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0dd05717e03a1kunmac953e9e17aa24
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZS0lPVkwaQ08dQkkaQxgaSFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=hyFL+os741eMXAWAXvGZBqScxm5JXqKOxJeZ7xm99Bqj/rC3b6nodOG1/lRJB2xoOlq2KSEE1StzqkXBHrXplT0nW6NSDgc2nyVAs5QnyzM83iKJRJEkBlrSX3n85O2gMlgLdHHvDANDzxzWYZdgKNqpyboliP0ontqvVNzpFA4=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=1vMLLP4ZyZxRv4arS6g92BBNchtr6oK5Gki/E2MpdK4=;
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
 fs/configfs/mount.c      | 50 ++++++++++++++++++++++++++++++++++++++++
 include/linux/configfs.h |  5 ++++
 2 files changed, 58 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd5..8d3c809676640 100644
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
@@ -118,6 +119,58 @@ static struct file_system_type configfs_fs_type = {
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
+ * store callbacks for existing configured paths.
+ *
+ * Return: opened file, or an ERR_PTR() value.  Returns -EINVAL if the
+ * resolved path is on configfs.
+ */
+struct file *configfs_file_open(const char *filename, int flags, umode_t mode)
+{
+	struct file *file;
+	struct path path;
+	int ret;
+
+	ret = kern_path(filename, LOOKUP_FOLLOW, &path);
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
