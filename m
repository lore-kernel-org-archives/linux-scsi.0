Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FF419049B;
	Tue, 18 Aug 2026 04:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029101; cv=none; b=vEwek9f7nVRja0FeGWC0bhIKnE1yxzUatX4EU0eJMvAK+UD9HB8F2seG0L+rOYtHeGFbzqlzPJRMMDVGu7ru6ZaCnKHRVOV+P0Ir2RTYdNveNEGloa/JYyoWoSxJWMFK9yW80DFjCljYhxt9ssuOjXd+HH/AJWDTPHB1qXVJls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029101; c=relaxed/simple;
	bh=7OVz7dOOrKHJmoXUfbZIey0um5f+c2mye9lnrDg8uYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a+sFoIwEY804MKR53MGoiOQaePJWWS3afF14eDfKJFoGc7ahX56GtOUuSo8Dre+Yb0Lt9W9FkNFZCFz3gxr0YsiwfsuSpZCJLsNLoacosyfhmKnM4RsV57BYpZkUWpL+uI/EJgwLFpFkFIPY7ymhmotMoolQUEX4SY94ZXC+IzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=WUpPntwQ; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="WUpPntwQ"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4a5b56963;
	Tue, 18 Aug 2026 12:58:13 +0800 (GMT+08:00)
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
Subject: [PATCH] scsi: target: file: reject configfs-backed paths in configfs stores
Date: Tue, 18 Aug 2026 12:58:07 +0800
Message-Id: <20260818045807.1519433-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0133bfce303a1kunm5b4c6f7a1004f6
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHkMZVkpPH0IYH0gZHkJOQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=WUpPntwQkB7EIgXC2Cj+ktHJVXq8sHqFC7bTQ2KP/BPlUPHzV0Z9jjMxD0LqXUOlkJhxXAvoOYCv5M1vB+QL4eSCBJZ4Mv9WnMaissrYD5jSd5fRGkiJypcPI5EryZoJw/1el/y24ugDLPEaGu9Can3NN+TycVMaBz4adH+p2t4=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=+qLDLYB5zBcm54HIVhHmOzhqWqYYLYqCzHz/Wk6MAEI=;
	h=date:mime-version:subject:message-id:from;

FILEIO paths can be opened from configfs store callbacks while configfs
holds the item's frag_sem.

target_dev_enable_store() reaches fd_configure_device() and
pi_prot_type_store() reaches fd_init_prot(). Both helpers call
filp_open() on user-controlled FILEIO paths. If either path resolves
inside configfs, the lookup can re-enter __configfs_open_file() and try
to take the same frag_sem again.

Reject configfs-backed FILEIO paths before calling filp_open(). Resolve
existing paths with kern_path(), and when O_CREAT may create the last
component, fall back to checking the parent directory with
kern_path_parent(). Keep reporting ordinary path lookup failures instead
of silently bypassing the existing FILEIO error paths.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Fixes: 0f5e2ec46dd6 ("target/file: Add DIF protection init/format support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/target/target_core_file.c | 50 +++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef7..4351300 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/falloc.h>
+#include <linux/namei.h>
 #include <linux/uio.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_proto.h>
@@ -86,6 +87,33 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static int fd_validate_fileio_path(const char *path)
+{
+	struct path lookup_path = {};
+	struct dentry *dentry;
+	int ret;
+
+	ret = kern_path(path, LOOKUP_FOLLOW, &lookup_path);
+	if (!ret) {
+		ret = !strcmp(lookup_path.dentry->d_sb->s_type->name, "configfs") ?
+			-EINVAL : 0;
+		path_put(&lookup_path);
+		return ret;
+	}
+	if (ret != -ENOENT)
+		return ret;
+
+	dentry = kern_path_parent(path, &lookup_path);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	ret = !strcmp(lookup_path.dentry->d_sb->s_type->name, "configfs") ?
+		-EINVAL : 0;
+	dput(dentry);
+	path_put(&lookup_path);
+	return ret;
+}
+
 static bool fd_configure_unmap(struct se_device *dev)
 {
 	struct file *file = FD_DEV(dev)->fd_file;
@@ -137,6 +165,17 @@ static int fd_configure_device(struct se_device *dev)
 		flags &= ~O_DSYNC;
 	}
 
+	ret = fd_validate_fileio_path(fd_dev->fd_dev_name);
+	if (ret) {
+		if (ret == -EINVAL)
+			pr_err("configfs-backed path is not valid for FILEIO backend: %s\n",
+			       fd_dev->fd_dev_name);
+		else
+			pr_err("FILEIO backend path lookup failed for %s: %d\n",
+			       fd_dev->fd_dev_name, ret);
+		goto fail;
+	}
+
 	file = filp_open(fd_dev->fd_dev_name, flags, 0600);
 	if (IS_ERR(file)) {
 		pr_err("filp_open(%s) failed\n", fd_dev->fd_dev_name);
@@ -847,6 +886,17 @@ static int fd_init_prot(struct se_device *dev)
 	snprintf(buf, FD_MAX_DEV_PROT_NAME, "%s.protection",
 		 fd_dev->fd_dev_name);
 
+	ret = fd_validate_fileio_path(buf);
+	if (ret) {
+		if (ret == -EINVAL)
+			pr_err("configfs-backed path is not valid for FILEIO protection: %s\n",
+			       buf);
+		else
+			pr_err("FILEIO protection path lookup failed for %s: %d\n",
+			       buf, ret);
+		return ret;
+	}
+
 	prot_file = filp_open(buf, flags, 0600);
 	if (IS_ERR(prot_file)) {
 		pr_err("filp_open(%s) failed\n", buf);
-- 
2.34.1
