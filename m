Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B260E3D3CEE;
	Tue, 18 Aug 2026 05:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787030098; cv=none; b=NeaXoX+WmdAUBrW81JJhLK7HKd7h5TQD1ojDIYRVfcMNYD+8eL3BCHFK11Ir9OCp9r4icHgBcMCOOkzN4ledB8ragM0Xok2OutCyLjfbpjOzKy0cINs5aTGKUUbEixUBsB2wcRXoZJ63puiAPKfxM1DzmGm+wkKX77ks2ymWMtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787030098; c=relaxed/simple;
	bh=xcCrXBRJwwJIVxDb8wMsZi0W8TTSs3hoL4lt0ROqKV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oXQXFRXcV919wn/t5AKoOVxJDcAyBAP5k+yT5sxhPv1f+P9hy8sVx4Gy39H2aPWhcR+MGFEYHLQaebP6hdqUQcpR84ajD+CADSKH63vVcI+6vXF8Fyj7PDW3AQ5BBu8gd/3lbAywIq3ByM7D9REeYJ791R6Q/ybOAq6327rg/xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=YHK7qeTg; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="YHK7qeTg"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4a5c35185;
	Tue, 18 Aug 2026 13:14:49 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
	Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] scsi: target: pin db_root for metadata writes
Date: Tue, 18 Aug 2026 13:14:42 +0800
Message-Id: <20260818051442.1523210-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260818042720.1511778-1-runyu.xiao@seu.edu.cn>
References: <20260818042720.1511778-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0134b2d2d03a1kunmd19dcf4f100ddd
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHksYVhpIQxpLGENPGBkdS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=YHK7qeTgrxapvlvXZqIEQa4abNhb9XVZrTVqPmlA3OLtxf+clBzPiyeLqWydncjWocUR+CCLUKaZ8cgffucmV2mP1cQs9EZEGSvIUQzUx8JC+PtIhtHrlPeWODFikW+yGV5DU5aChgfvJEPwd3mxsGeqScQC4tIQl0vST4mmBlY=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=DBZXc7HLX9/pYjM/ke+KsiHNFOie7BrTQqBdvFxmdp0=;
	h=date:mime-version:subject:message-id:from;

db_root is configured from configfs as a pathname string. ALUA and
APTPL later build metadata filenames under that string and open them
with filp_open().

Validating db_root once in target_core_item_dbroot_store() is not
enough. A later symlink retarget can bypass a one-time check, and doing
path resolution under target_devices_lock keeps the VFS lock-order
concern in the configfs store path.

Resolve db_root to a directory path once, keep a pinned struct path
reference, and open metadata files relative to that fixed root with
file_open_root(). Also reject configfs-backed roots before publishing
them and move the path walk out from under target_devices_lock.

This closes the ALUA recursive configfs re-entry path without leaving a
string-based TOCTOU gap, and keeps the same fixed-root semantics for
APTPL metadata writes.

Fixes: a96e9783e058 ("target: make target db location configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
v2:
- replace one-time store-path validation with a pinned db_root path
- move db_root path resolution out from under target_devices_lock
- open ALUA and APTPL metadata files relative to the pinned root
- close the string-based TOCTOU gap raised in review

 drivers/target/target_core_alua.c     | 40 ++++++++-----
 drivers/target/target_core_configfs.c | 83 ++++++++++++++++++---------
 drivers/target/target_core_internal.h |  3 +
 drivers/target/target_core_pr.c       | 19 ++++--
 4 files changed, 96 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 10250aca5a81..cfe4c30e534a 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -856,17 +856,27 @@ static int core_alua_write_tpg_metadata(
 	unsigned char *md_buf,
 	u32 md_buf_len)
 {
-	struct file *file = filp_open(path, O_RDWR | O_CREAT | O_TRUNC, 0600);
+	struct file *file;
 	loff_t pos = 0;
 	int ret;
 
+	if (!db_root_path.dentry) {
+		pr_err("db_root is not initialized for ALUA metadata path: %s/%s\n",
+		       db_root, path);
+		return -ENODEV;
+	}
+
+	file = file_open_root(&db_root_path, path, O_RDWR | O_CREAT | O_TRUNC,
+			      0600);
 	if (IS_ERR(file)) {
-		pr_err("filp_open(%s) for ALUA metadata failed\n", path);
+		pr_err("file_open_root(%s/%s) for ALUA metadata failed\n",
+		       db_root, path);
 		return -ENODEV;
 	}
 	ret = kernel_write(file, md_buf, md_buf_len, &pos);
 	if (ret < 0)
-		pr_err("Error writing ALUA metadata file: %s\n", path);
+		pr_err("Error writing ALUA metadata file: %s/%s\n", db_root,
+		       path);
 	fput(file);
 	return (ret < 0) ? -EIO : 0;
 }
@@ -896,9 +906,9 @@ static int core_alua_update_tpg_primary_metadata(
 			tg_pt_gp->tg_pt_gp_alua_access_status);
 
 	rc = -ENOMEM;
-	path = kasprintf(GFP_KERNEL, "%s/alua/tpgs_%s/%s", db_root,
-			&wwn->unit_serial[0],
-			config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
+	path = kasprintf(GFP_KERNEL, "alua/tpgs_%s/%s",
+			 &wwn->unit_serial[0],
+			 config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
 	if (path) {
 		rc = core_alua_write_tpg_metadata(path, md_buf, len);
 		kfree(path);
@@ -1187,16 +1197,16 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 			lun->lun_tg_pt_secondary_stat);
 
 	if (se_tpg->se_tpg_tfo->tpg_get_tag != NULL) {
-		path = kasprintf(GFP_KERNEL, "%s/alua/%s/%s+%hu/lun_%llu",
-				db_root, se_tpg->se_tpg_tfo->fabric_name,
-				se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
-				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
-				lun->unpacked_lun);
+		path = kasprintf(GFP_KERNEL, "alua/%s/%s+%hu/lun_%llu",
+				 se_tpg->se_tpg_tfo->fabric_name,
+				 se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
+				 se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
+				 lun->unpacked_lun);
 	} else {
-		path = kasprintf(GFP_KERNEL, "%s/alua/%s/%s/lun_%llu",
-				db_root, se_tpg->se_tpg_tfo->fabric_name,
-				se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
-				lun->unpacked_lun);
+		path = kasprintf(GFP_KERNEL, "alua/%s/%s/lun_%llu",
+				 se_tpg->se_tpg_tfo->fabric_name,
+				 se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
+				 lun->unpacked_lun);
 	}
 	if (!path) {
 		rc = -ENOMEM;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a2bd2e81d2c6..7788db0c64eb 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -96,8 +96,31 @@ static ssize_t target_core_item_version_show(struct config_item *item,
 CONFIGFS_ATTR_RO(target_core_item_, version);
 
 char db_root[DB_ROOT_LEN] = DB_ROOT_DEFAULT;
+struct path db_root_path;
 static char db_root_stage[DB_ROOT_LEN];
 
+static int target_validate_db_root(const char *path_str, struct path *path)
+{
+	int ret;
+
+	ret = kern_path(path_str, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, path);
+	if (ret) {
+		pr_err("db_root: cannot open: %s\n", path_str);
+		if (ret == -ENOTDIR)
+			pr_err("db_root: not a directory: %s\n", path_str);
+		return ret;
+	}
+
+	if (!strcmp(path->dentry->d_sb->s_type->name, "configfs")) {
+		pr_err("db_root: configfs is not a valid target database root: %s\n",
+		       path_str);
+		path_put(path);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static ssize_t target_core_item_dbroot_show(struct config_item *item,
 					    char *page)
 {
@@ -110,43 +133,49 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	ssize_t read_bytes;
 	ssize_t r = -EINVAL;
 	struct path path = {};
-
-	mutex_lock(&target_devices_lock);
-	if (target_devices) {
-		pr_err("db_root: cannot be changed because it's in use\n");
-		goto unlock;
-	}
+	struct path old_path = {};
+	bool have_old_path = false;
 
 	if (count > (DB_ROOT_LEN - 1)) {
 		pr_err("db_root: count %d exceeds DB_ROOT_LEN-1: %u\n",
 		       (int)count, DB_ROOT_LEN - 1);
-		goto unlock;
+		return r;
 	}
 
 	read_bytes = scnprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
 	if (!read_bytes)
-		goto unlock;
+		return r;
 
 	if (db_root_stage[read_bytes - 1] == '\n')
 		db_root_stage[read_bytes - 1] = '\0';
 
 	/* validate new db root before accepting it */
-	r = kern_path(db_root_stage, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
-	if (r) {
-		pr_err("db_root: cannot open: %s\n", db_root_stage);
-		if (r == -ENOTDIR)
-			pr_err("db_root: not a directory: %s\n", db_root_stage);
-		goto unlock;
+	r = target_validate_db_root(db_root_stage, &path);
+	if (r)
+		return r;
+
+	mutex_lock(&target_devices_lock);
+	if (target_devices) {
+		pr_err("db_root: cannot be changed because it's in use\n");
+		goto unlock_put;
 	}
-	path_put(&path);
 
+	have_old_path = db_root_path.dentry;
+	if (have_old_path)
+		old_path = db_root_path;
+	db_root_path = path;
+	path = (struct path){};
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
 
-unlock:
+unlock_put:
 	mutex_unlock(&target_devices_lock);
+	if (path.dentry)
+		path_put(&path);
+	if (have_old_path)
+		path_put(&old_path);
 	return r;
 }
 
@@ -3643,21 +3672,19 @@ void target_setup_backend_cits(struct target_backend *tb)
 
 static void target_init_dbroot(void)
 {
-	struct file *fp;
+	struct path path = {};
+	int ret;
 
-	snprintf(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
-	fp = filp_open(db_root_stage, O_RDONLY, 0);
-	if (IS_ERR(fp)) {
-		pr_err("db_root: cannot open: %s\n", db_root_stage);
-		return;
-	}
-	if (!S_ISDIR(file_inode(fp)->i_mode)) {
-		filp_close(fp, NULL);
-		pr_err("db_root: not a valid directory: %s\n", db_root_stage);
-		return;
+	strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
+	ret = target_validate_db_root(db_root_stage, &path);
+	if (ret) {
+		strscpy(db_root_stage, DB_ROOT_LEN, DB_ROOT_DEFAULT);
+		ret = target_validate_db_root(db_root_stage, &path);
+		if (ret)
+			return;
 	}
-	filp_close(fp, NULL);
 
+	db_root_path = path;
 	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 20aab1f50565..4cbc6218d4de 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -169,6 +169,9 @@ extern struct se_portal_group xcopy_pt_tpg;
 #define	DB_ROOT_DEFAULT		"/var/target"
 #define	DB_ROOT_PREFERRED	"/etc/target"
 
+struct path;
+
 extern char db_root[];
+extern struct path db_root_path;
 
 #endif /* TARGET_CORE_INTERNAL_H */
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 83e172c92238..35ec38c6f528 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1965,15 +1965,21 @@ static int __core_scsi3_write_aptpl_to_file(
 	int ret;
 	loff_t pos = 0;
 
-	path = kasprintf(GFP_KERNEL, "%s/pr/aptpl_%s", db_root,
-			&wwn->unit_serial[0]);
+	path = kasprintf(GFP_KERNEL, "pr/aptpl_%s", &wwn->unit_serial[0]);
 	if (!path)
 		return -ENOMEM;
 
-	file = filp_open(path, flags, 0600);
+	if (!db_root_path.dentry) {
+		pr_err("db_root is not initialized for APTPL metadata path: %s/%s\n",
+		       db_root, path);
+		kfree(path);
+		return -ENODEV;
+	}
+
+	file = file_open_root(&db_root_path, path, flags, 0600);
 	if (IS_ERR(file)) {
-		pr_err("filp_open(%s) for APTPL metadata"
-			" failed\n", path);
+		pr_err("file_open_root(%s/%s) for APTPL metadata failed\n",
+		       db_root, path);
 		kfree(path);
 		return PTR_ERR(file);
 	}
@@ -1983,7 +1989,8 @@ static int __core_scsi3_write_aptpl_to_file(
 	ret = kernel_write(file, buf, pr_aptpl_buf_len, &pos);
 
 	if (ret < 0)
-		pr_debug("Error writing APTPL metadata file: %s\n", path);
+		pr_debug("Error writing APTPL metadata file: %s/%s\n", db_root,
+			 path);
 	fput(file);
 	kfree(path);
 
-- 
2.34.1
