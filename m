From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 02/14] target: Fix match_strdup() memory leaks
Date: Fri, 25 Feb 2011 11:49:54 -0800
Message-ID: <1298663406-5118-3-git-send-email-nab@linux-iscsi.org>
References: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ne1.yahoo.com ([98.138.90.68]:26111 "HELO
	nm5.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:20 -0500
In-Reply-To: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jesper Juhl <jj@chaosbits.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Jesper Juhl <jj@chaosbits.net>

match_strdup() dynamically allocates memory and it is the responsabillity
of the caller to free that memory. The following three cases:

drivers/target/target_core_file.c:fd_set_configfs_dev_params()
drivers/target/target_core_iblock.c:iblock_set_configfs_dev_params()
drivers/target/target_core_configfs.c:target_core_dev_pr_store_attr_res_aptpl_metadata()

should be kfree()'ing the allocated memory once it is no longer needed.
It also makes sure to return -ENOMEM if the memory allocation in match_strdup()
should fail.  For target_core_configfs.c, this patch adds kfree()'s around
Opt_initiator_fabric, Opt_initiator_node, Opt_initiator_sid, Opt_sa_res_key,
Opt_target_fabric, and Opt_target_node for the Persistent Reservations
Activate Persistence across Target Power Loss (APTPL=1) token parsing.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   33 +++++++++++++++++++++++++++++++--
 drivers/target/target_core_file.c     |   13 ++++++++++++-
 drivers/target/target_core_iblock.c   |   13 +++++++++----
 3 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index caf8dc1..c9254d7 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1451,8 +1451,8 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	size_t count)
 {
 	struct se_device *dev;
-	unsigned char *i_fabric, *t_fabric, *i_port = NULL, *t_port = NULL;
-	unsigned char *isid = NULL;
+	unsigned char *i_fabric = NULL, *i_port = NULL, *isid = NULL;
+	unsigned char *t_fabric = NULL, *t_port = NULL;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
 	unsigned long long tmp_ll;
@@ -1488,9 +1488,17 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 		switch (token) {
 		case Opt_initiator_fabric:
 			i_fabric = match_strdup(&args[0]);
+			if (!i_fabric) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			break;
 		case Opt_initiator_node:
 			i_port = match_strdup(&args[0]);
+			if (!i_port) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			if (strlen(i_port) > PR_APTPL_MAX_IPORT_LEN) {
 				printk(KERN_ERR "APTPL metadata initiator_node="
 					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
@@ -1501,6 +1509,10 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			break;
 		case Opt_initiator_sid:
 			isid = match_strdup(&args[0]);
+			if (!isid) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			if (strlen(isid) > PR_REG_ISID_LEN) {
 				printk(KERN_ERR "APTPL metadata initiator_isid"
 					"= exceeds PR_REG_ISID_LEN: %d\n",
@@ -1511,6 +1523,10 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			break;
 		case Opt_sa_res_key:
 			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			ret = strict_strtoull(arg_p, 0, &tmp_ll);
 			if (ret < 0) {
 				printk(KERN_ERR "strict_strtoull() failed for"
@@ -1547,9 +1563,17 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 		 */
 		case Opt_target_fabric:
 			t_fabric = match_strdup(&args[0]);
+			if (!t_fabric) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			break;
 		case Opt_target_node:
 			t_port = match_strdup(&args[0]);
+			if (!t_port) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			if (strlen(t_port) > PR_APTPL_MAX_TPORT_LEN) {
 				printk(KERN_ERR "APTPL metadata target_node="
 					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
@@ -1592,6 +1616,11 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			i_port, isid, mapped_lun, t_port, tpgt, target_lun,
 			res_holder, all_tg_pt, type);
 out:
+	kfree(i_fabric);
+	kfree(i_port);
+	kfree(isid);
+	kfree(t_fabric);
+	kfree(t_port);
 	kfree(orig);
 	return (ret == 0) ? count : ret;
 }
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0aaca88..676a010 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -537,15 +537,26 @@ static ssize_t fd_set_configfs_dev_params(
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_fd_dev_name:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
 			snprintf(fd_dev->fd_dev_name, FD_MAX_DEV_NAME,
-					"%s", match_strdup(&args[0]));
+					"%s", arg_p);
+			kfree(arg_p);
 			printk(KERN_INFO "FILEIO: Referencing Path: %s\n",
 					fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
 			break;
 		case Opt_fd_dev_size:
 			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
 			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
+			kfree(arg_p);
 			if (ret < 0) {
 				printk(KERN_ERR "strict_strtoull() failed for"
 						" fd_dev_size=\n");
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 67f0c09..422187b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -469,7 +469,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 					       const char *page, ssize_t count)
 {
 	struct iblock_dev *ib_dev = se_dev->se_dev_su_ptr;
-	char *orig, *ptr, *opts;
+	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
 	int ret = 0, arg, token;
 
@@ -492,9 +492,14 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 				ret = -EEXIST;
 				goto out;
 			}
-
-			ret = snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
-				"%s", match_strdup(&args[0]));
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
+					"%s", arg_p);
+			kfree(arg_p);
 			printk(KERN_INFO "IBLOCK: Referencing UDEV path: %s\n",
 					ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
-- 
1.7.4.1

