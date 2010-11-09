From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Convert backstore ->set_configfs_dev_params() to use parser.h
Date: Tue,  9 Nov 2010 01:48:42 -0800
Message-ID: <1289296122-13152-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ac4.yahoo.com ([98.139.52.204]:41238 "HELO
	nm7.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753071Ab0KIJss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 04:48:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the backend struct se_subsystem_api->set_configfs_dev_params()
callers for IBLOCK, FILEIO, PSCSI, RAMDISK and STGT to use proper kstrdup(), strsep()
and linux/parser.h match_token() logic.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c   |   95 +++++++++++++--------------
 drivers/target/target_core_iblock.c |   81 ++++++++++-------------
 drivers/target/target_core_pscsi.c  |  123 +++++++++++++---------------------
 drivers/target/target_core_rd.c     |   69 +++++++++-----------
 drivers/target/target_core_stgt.c   |  108 ++++++++++++------------------
 5 files changed, 205 insertions(+), 271 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index f9bcaa7..8165cf0 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -28,6 +28,7 @@
 
 #include <linux/version.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/timer.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
@@ -645,80 +646,78 @@ static void fd_free_task(struct se_task *task)
 	kfree(req);
 }
 
+enum {
+	Opt_fd_dev_name, Opt_fd_dev_size, Opt_fd_buffered_io
+};
+
+static match_table_t tokens = {
+	{Opt_fd_dev_name, "fd_dev_name=%s"},
+	{Opt_fd_dev_size, "fd_dev_size=%s"},
+	{Opt_fd_buffered_io, "fd_buffered_id=%d"},
+};
+	
 static ssize_t fd_set_configfs_dev_params(
 	struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
 	const char *page, ssize_t count)
 {
-	struct fd_dev *fd_dev = (struct fd_dev *) se_dev->se_dev_su_ptr;
-	char *buf, *cur, *ptr, *ptr2;
-	int params = 0;
-	/*
-	 * Make sure we take into account the NULL terminator when copying
-	 * the const buffer here..
-	 */
-	buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-				" temporary buffer\n");
-		return 0;
-	}
-	memcpy(buf, page, count);
-	cur = buf;
+	struct fd_dev *fd_dev = se_dev->se_dev_su_ptr;
+	char *orig, *ptr, *arg_p, *opts;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0, arg, token;
 
-	while (cur) {
-		ptr = strstr(cur, "=");
-		if (!(ptr))
-			goto out;
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
 
-		*ptr = '\0';
-		ptr++;
+	orig = opts;
 
-		ptr2 = strstr(cur, "fd_dev_name");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ptr = strstrip(ptr);
+	while ((ptr = strsep(&opts, ",")) != NULL) {
+		if (!*ptr)
+			continue;
+
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_fd_dev_name:
 			snprintf(fd_dev->fd_dev_name, FD_MAX_DEV_NAME,
-					"%s", ptr);
+					"%s", match_strdup(&args[0]));
 			printk(KERN_INFO "FILEIO: Referencing Path: %s\n",
 					fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "fd_dev_size");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			if (strict_strtoull(ptr, 0, &fd_dev->fd_dev_size) < 0) {
+			break;
+		case Opt_fd_dev_size:
+			arg_p = match_strdup(&args[0]);
+			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
+			if (ret < 0) {
 				printk(KERN_ERR "strict_strtoull() failed for"
 						" fd_dev_size=\n");
-				continue;
+				goto out;
 			}
 			printk(KERN_INFO "FILEIO: Referencing Size: %llu"
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "fd_buffered_io");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			if (strncmp(ptr, "1", 1))
-				continue;
+			break;
+		case Opt_fd_buffered_io:
+			match_int(args, &arg);
+			if (arg != 1) {
+				printk(KERN_ERR "bogus fd_buffered_io=%d value\n", arg);
+				ret = -EINVAL;
+				goto out;
+			}
 
 			printk(KERN_INFO "FILEIO: Using buffered I/O"
 				" operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_USE_BUFFERED_IO;
-			params++;
-			continue;
-		} else
-			cur = NULL;
+			break;
+		default:
+			break;
+		}
 	}
 
 out:
-	kfree(buf);
-	return (params) ? count : -EINVAL;
+	kfree(orig);
+	return (!ret) ? count : ret;
 }
 
 static ssize_t fd_check_configfs_dev_params(struct se_hba *hba, struct se_subsystem_dev *se_dev)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 93d8c62..5984cd2 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -29,6 +29,7 @@
 
 #include <linux/version.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/timer.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
@@ -505,74 +506,64 @@ static void iblock_free_task(struct se_task *task)
 	task->transport_req = NULL;
 }
 
+enum {
+	Opt_udev_path, Opt_force
+};
+
+static match_table_t tokens = {
+	{Opt_udev_path, "udev_path=%s"},
+	{Opt_force, "force=%d"},
+};
+
 static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 					       struct se_subsystem_dev *se_dev,
 					       const char *page, ssize_t count)
 {
 	struct iblock_dev *ib_dev = se_dev->se_dev_su_ptr;
-	char *buf, *cur, *ptr, *ptr2;
-	unsigned long force;
-	int params = 0, ret = 0;
-	/*
-	 * Make sure we take into account the NULL terminator when copying
-	 * the const buffer here..
-	 */
-	buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for temporary"
-			" buffer\n");
-		return 0;
-	}
-	memcpy(buf, page, count);
-	cur = buf;
+	char *orig, *ptr, *opts;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0, arg, token;
 
-	while (cur) {
-		ptr = strstr(cur, "=");
-		if (!(ptr))
-			goto out;
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+	
+	orig = opts;
 
-		*ptr = '\0';
-		ptr++;
+	while ((ptr = strsep(&opts, ",")) != NULL) {
+		if (!*ptr)
+			continue;
 
-		ptr2 = strstr(cur, "udev_path");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ptr = strstrip(ptr);
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_udev_path:
 			if (ib_dev->ibd_bd) {
 				printk(KERN_ERR "Unable to set udev_path= while"
 					" ib_dev->ibd_bd exists\n");
-				params = 0;
+				ret = -EEXIST;
 				goto out;
 			}
 
 			ret = snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
-				"%s", ptr);
+				"%s", match_strdup(&args[0]));
 			printk(KERN_INFO "IBLOCK: Referencing UDEV path: %s\n",
 					ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "force");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &force);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed"
-					" for force=\n");
-				break;
-			}
-			ib_dev->ibd_force = (int)force;
+			break;
+		case Opt_force:
+			match_int(args, &arg);
+			ib_dev->ibd_force = arg;
 			printk(KERN_INFO "IBLOCK: Set force=%d\n",
 				ib_dev->ibd_force);
-			params++;
-		} else
-			cur = NULL;
+			break;
+		default:
+			break;
+		}
 	}
 
 out:
-	kfree(buf);
-	return (params) ? count : -EINVAL;
+	kfree(orig);
+	return (!ret) ? count : ret;
 }
 
 static ssize_t iblock_check_configfs_dev_params(
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6a2db0b..6f86175 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -28,6 +28,7 @@
 
 #include <linux/version.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/timer.h>
 #include <linux/blkdev.h>
 #include <linux/blk_types.h>
@@ -804,6 +805,17 @@ static void pscsi_free_task(struct se_task *task)
 	kfree(pt);
 }
 
+enum {
+	Opt_scsi_host_id, Opt_scsi_channel_id, Opt_scsi_target_id, Opt_scsi_lun_id
+};
+
+static match_table_t tokens = {
+	{Opt_scsi_host_id, "scsi_host_id=%d"},
+	{Opt_scsi_channel_id, "scsi_channel_id=%d"},
+	{Opt_scsi_target_id, "scsi_target_id=%d"},
+	{Opt_scsi_lun_id, "scsi_lun_id=%d"},
+};
+
 static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
 	const char *page,
@@ -811,109 +823,68 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
 {
 	struct pscsi_dev_virt *pdv = se_dev->se_dev_su_ptr;
 	struct pscsi_hba_virt *phv = hba->hba_ptr;
-	char *buf, *cur, *ptr, *ptr2;
-	unsigned long scsi_host_id, scsi_channel_id;
-	unsigned long scsi_target_id, scsi_lun_id;
-	int params = 0, ret;
-	/*
-	 * Make sure we take into account the NULL terminator when copying
-	 * the const buffer here..
-	 */
-	buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for temporary"
-				" buffer\n");
+	char *orig, *ptr, *opts;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0, arg, token;
+
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
 		return -ENOMEM;
-	}
-	memcpy(buf, page, count);
-	cur = buf;
 
-	while (cur) {
-		ptr = strstr(cur, "=");
-		if (!(ptr))
-			goto out;
+	orig = opts;
 
-		*ptr = '\0';
-		ptr++;
+	while ((ptr = strsep(&opts, ",")) != NULL) {
+		if (!*ptr)
+			continue;
 
-		ptr2 = strstr(cur, "scsi_host_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_scsi_host_id:
 			if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
 				printk(KERN_ERR "PSCSI[%d]: Unable to accept"
 					" scsi_host_id while phv_mode =="
 					" PHV_LLD_SCSI_HOST_NO\n",
 					phv->phv_host_id);
-				break;
-			}
-			ret = strict_strtoul(ptr, 0, &scsi_host_id);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" scsi_hostl_id=\n");
-				break;
+				ret = -EINVAL;
+				goto out;
 			}
-			pdv->pdv_host_id = (int)scsi_host_id;
+			match_int(args, &arg);
+			pdv->pdv_host_id = arg;
 			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI Host ID:"
 				" %d\n", phv->phv_host_id, pdv->pdv_host_id);
 			pdv->pdv_flags |= PDF_HAS_VIRT_HOST_ID;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "scsi_channel_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &scsi_channel_id);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" scsi_channel_id=\n");
-				break;
-			}
-			pdv->pdv_channel_id = (int)scsi_channel_id;
+			break;
+		case Opt_scsi_channel_id:
+			match_int(args, &arg);
+			pdv->pdv_channel_id = arg;
 			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI Channel"
 				" ID: %d\n",  phv->phv_host_id,
 				pdv->pdv_channel_id);
 			pdv->pdv_flags |= PDF_HAS_CHANNEL_ID;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "scsi_target_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &scsi_target_id);
-			if (ret < 0) {
-				printk("strict_strtoul() failed for"
-					" strict_strtoul()\n");
-				break;
-			}
-			pdv->pdv_target_id = (int)scsi_target_id;
+			break;
+		case Opt_scsi_target_id:
+			match_int(args, &arg);
+			pdv->pdv_target_id = arg;
 			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI Target"
 				" ID: %d\n", phv->phv_host_id,
 				pdv->pdv_target_id);
 			pdv->pdv_flags |= PDF_HAS_TARGET_ID;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "scsi_lun_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &scsi_lun_id);
-			if (ret < 0) {
-				printk("strict_strtoul() failed for"
-					" scsi_lun_id=\n");
-				break;
-			}
-			pdv->pdv_lun_id = (int)scsi_lun_id;
+			break;
+		case Opt_scsi_lun_id:
+			match_int(args, &arg);
+			pdv->pdv_lun_id = arg;
 			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI LUN ID:"
 				" %d\n", phv->phv_host_id, pdv->pdv_lun_id);
 			pdv->pdv_flags |= PDF_HAS_LUN_ID;
-			params++;
-		} else
-			cur = NULL;
+			break;
+		default:
+			break;
+		}
 	}
 
 out:
-	kfree(buf);
-	return (params) ? count : -EINVAL;
+	kfree(orig);
+	return (!ret) ? count : ret;
 }
 
 static ssize_t pscsi_check_configfs_dev_params(
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 9740e32..d21ef0f 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -29,6 +29,7 @@
 
 #include <linux/version.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/timer.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
@@ -990,6 +991,14 @@ static void rd_free_task(struct se_task *task)
 	kfree(req);
 }
 
+enum {
+	Opt_rd_pages
+};
+
+static match_table_t tokens = {
+	{Opt_rd_pages, "rd_pages=%d"},
+};
+
 static ssize_t rd_set_configfs_dev_params(
 	struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
@@ -997,50 +1006,36 @@ static ssize_t rd_set_configfs_dev_params(
 	ssize_t count)
 {
 	struct rd_dev *rd_dev = se_dev->se_dev_su_ptr;
-	char *buf, *cur, *ptr, *ptr2;
-	unsigned long rd_pages;
-	int params = 0, ret;
-	/*
-	 * Make sure we take into account the NULL terminator when copying
-	 * the const buffer here..
-	 */
-	buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for temporary buffer\n");
-		return 0;
-	}
-	memcpy(buf, page, count);
-	cur = buf;
+	char *orig, *ptr, *opts;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0, arg, token;
 
-	while (cur) {
-		ptr = strstr(cur, "=");
-		if (!(ptr))
-			goto out;
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
 
-		*ptr = '\0';
-		ptr++;
-
-		ptr2 = strstr(cur, "rd_pages");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &rd_pages);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" rd_pages=\n");
-				break;
-			}
-			rd_dev->rd_page_count = (u32)rd_pages;
+	orig = opts;
+
+	while ((ptr = strsep(&opts, ",")) != NULL) {
+		if (!*ptr)
+			continue;
+
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_rd_pages:
+			match_int(args, &arg);
+			rd_dev->rd_page_count = arg;
 			printk(KERN_INFO "RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
-			params++;
-		} else
-			cur = NULL;
+			break;
+		default:
+			break;
+		}
 	}
 
-out:
-	kfree(buf);
-	return (params) ? count : -EINVAL;
+	kfree(orig);
+	return (!ret) ? count : ret;
 }
 
 static ssize_t rd_check_configfs_dev_params(struct se_hba *hba, struct se_subsystem_dev *se_dev)
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index 3b78333..ee8eb9a 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -26,6 +26,7 @@
 
 #include <linux/version.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/timer.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
@@ -418,6 +419,16 @@ static void stgt_free_task(struct se_task *task)
 	kfree(st);
 }
 
+enum {
+	Opt_scsi_channel_id, Opt_scsi_target_id, Opt_scsi_lun_id
+};
+
+static match_table_t tokens = {
+	{Opt_scsi_channel_id, "scsi_channel_id=%d"},
+	{Opt_scsi_target_id, "scsi_target_id=%d"},
+	{Opt_scsi_lun_id, "scsi_lun_id=%d"},
+};
+
 static ssize_t stgt_set_configfs_dev_params(struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
 	const char *page,
@@ -425,83 +436,50 @@ static ssize_t stgt_set_configfs_dev_params(struct se_hba *hba,
 {
 	struct stgt_dev_virt *sdv = se_dev->se_dev_su_ptr;
 	struct Scsi_Host *sh = hba->hba_ptr;
-	char *buf, *cur, *ptr, *ptr2;
-	unsigned long scsi_channel_id, scsi_target_id, scsi_lun_id;
-	int params = 0, ret;
-	/*
-	 * Make sure we take into account the NULL terminator when copying
-	 * the const buffer here..
-	 */
-	buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for temporary"
-				" buffer\n");
+	char *orig, *ptr, *opts;
+	substring_t args[MAX_OPT_ARGS];
+	int ret = 0, arg, token;
+
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
 		return -ENOMEM;
-	}
-	memcpy(buf, page, count);
-	cur = buf;
-
-	while (cur) {
-		ptr = strstr(cur, "=");
-		if (!(ptr))
-			goto out;
-
-		*ptr = '\0';
-		ptr++;
-
-		ptr2 = strstr(cur, "scsi_channel_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &scsi_channel_id);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" scsi_channel_id=\n");
-				break;
-			}
-			sdv->sdv_channel_id = (int)scsi_channel_id;
+
+	orig = opts;
+
+	while ((ptr = strsep(&opts, ",")) != NULL) {
+		if (!*ptr)
+			continue;
+
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_scsi_channel_id:
+			match_int(args, &arg);
+			sdv->sdv_channel_id = arg;
 			printk(KERN_INFO "STGT[%d]: Referencing SCSI Channel"
 				" ID: %d\n",  sh->host_no, sdv->sdv_channel_id);
 			sdv->sdv_flags |= PDF_HAS_CHANNEL_ID;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "scsi_target_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &scsi_target_id);
-			if (ret < 0) {
-				printk("strict_strtoul() failed for"
-					" strict_strtoul()\n");
-				break;
-			}
-			sdv->sdv_target_id = (int)scsi_target_id;
+			break;
+		case Opt_scsi_target_id:
+			match_int(args, &arg);
+			sdv->sdv_target_id = arg;
 			printk(KERN_INFO "STGT[%d]: Referencing SCSI Target"
 				" ID: %d\n", sh->host_no, sdv->sdv_target_id);
 			sdv->sdv_flags |= PDF_HAS_TARGET_ID;
-			params++;
-			continue;
-		}
-		ptr2 = strstr(cur, "scsi_lun_id");
-		if ((ptr2)) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &scsi_lun_id);
-			if (ret < 0) {
-				printk("strict_strtoul() failed for"
-					" scsi_lun_id=\n");
-				break;
-			}
-			sdv->sdv_lun_id = (int)scsi_lun_id;
+			break;
+		case Opt_scsi_lun_id:
+			match_int(args, &arg);
+			sdv->sdv_lun_id = arg;
 			printk(KERN_INFO "STGT[%d]: Referencing SCSI LUN ID:"
 				" %d\n", sh->host_no, sdv->sdv_lun_id);
 			sdv->sdv_flags |= PDF_HAS_LUN_ID;
-			params++;
-		} else
-			cur = NULL;
+			break;
+		default:
+			break;
+		}
 	}
 
-out:
-	kfree(buf);
-	return (params) ? count : -EINVAL;
+	kfree(orig);
+	return (!ret) ? count : ret;
 }
 
 static ssize_t stgt_check_configfs_dev_params(
-- 
1.5.6.5

