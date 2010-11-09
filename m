From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Convert target_core_dev_pr_store_attr_res_aptpl_metadata() to use parser.h
Date: Tue,  9 Nov 2010 01:48:51 -0800
Message-ID: <1289296131-13175-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm17.bullet.mail.ne1.yahoo.com ([98.138.90.80]:37011 "HELO
	nm17.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754256Ab0KIJsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 04:48:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the persistent reservations APTPL (activate persistence across
target power loss) parsing logic in target_core_dev_pr_store_attr_res_aptpl_metadata()
to use proper kstrdup(), strsep() and linux/parser.h match_token() logic.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_configfs.c |  262 +++++++++++++--------------------
 1 files changed, 101 insertions(+), 161 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bd2d4af..10c8c75 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/unistd.h>
 #include <linux/string.h>
+#include <linux/parser.h>
 #include <linux/syscalls.h>
 #include <linux/configfs.h>
 #include <linux/proc_fs.h>
@@ -1455,6 +1456,30 @@ static ssize_t target_core_dev_pr_show_attr_res_aptpl_metadata(
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
 }
 
+enum {
+	Opt_initiator_fabric, Opt_initiator_node, Opt_initiator_sid,
+	Opt_sa_res_key, Opt_res_holder, Opt_res_type, Opt_res_scope,
+	Opt_res_all_tg_pt, Opt_mapped_lun, Opt_target_fabric,
+	Opt_target_node, Opt_tpgt, Opt_port_rtpi, Opt_target_lun
+};
+
+static match_table_t tokens = {
+	{Opt_initiator_fabric, "initiator_fabric=%s"},
+	{Opt_initiator_node, "initiator_node=%s"},
+	{Opt_initiator_sid, "initiator_sid=%s"},
+	{Opt_sa_res_key, "sa_res_key=%s"},
+	{Opt_res_holder, "res_holder=%d"},
+	{Opt_res_type, "res_type=%d"},
+	{Opt_res_scope, "res_scope=%d"},
+	{Opt_res_all_tg_pt, "res_all_tg_pt=%d"},
+	{Opt_mapped_lun, "mapped_lun=%d"},
+	{Opt_target_fabric, "target_fabric=%s"},
+	{Opt_target_node, "target_node=%s"},
+	{Opt_tpgt, "tpgt=%d"},
+	{Opt_port_rtpi, "port_rtpi=%d"},
+	{Opt_target_lun, "target_lun=%d"},
+};
+
 static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	struct se_subsystem_dev *su_dev,
 	const char *page,
@@ -1463,12 +1488,12 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	struct se_device *dev;
 	unsigned char *i_fabric, *t_fabric, *i_port = NULL, *t_port = NULL;
 	unsigned char *isid = NULL;
-	char *ptr, *ptr2, *cur, *buf;
+	char *orig, *ptr, *arg_p, *opts;
+	substring_t args[MAX_OPT_ARGS];
 	unsigned long long tmp_ll;
-	unsigned long tmp_l;
 	u64 sa_res_key = 0;
 	u32 mapped_lun = 0, target_lun = 0;
-	int ret = -1, res_holder = 0, all_tg_pt = 0;
+	int ret = -1, res_holder = 0, all_tg_pt = 0, arg, token;
 	u16 port_rpti = 0, tpgt = 0;
 	u8 type = 0, scope;
 
@@ -1484,202 +1509,117 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			" active fabric exports exist\n");
 		return -EINVAL;
 	}
-	/*
-	 * Allocate and copy input to our own buffer so that we can setup
-	 * NULL terminators later for incoming PR APTPL metadata..
-	 */
-	buf = kzalloc(count, GFP_KERNEL);
-	memcpy(buf, page, count);
-	cur = &buf[0];
 
-	while (cur) {
-		ptr = strstr(cur, "=");
-		if (!(ptr))
-			goto out;
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
 
-		*ptr = '\0';
-		ptr++;
-		/*
-		 * PR APTPL Metadata for Initiator Port
-		 */
-		ptr2 = strstr(cur, "initiator_fabric");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			i_fabric = ptr;
+	orig = opts;
+	while ((ptr = strsep(&opts, ",")) != NULL) {
+		if (!*ptr)
 			continue;
-		}
-		ptr2 = strstr(cur, "initiator_node");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			if (strlen(ptr) > PR_APTPL_MAX_IPORT_LEN) {
+
+		token = match_token(ptr, tokens, args);
+		switch (token) {
+		case Opt_initiator_fabric:
+			i_fabric = match_strdup(&args[0]);
+			break;
+		case Opt_initiator_node:
+			i_port = match_strdup(&args[0]);
+			if (strlen(i_port) > PR_APTPL_MAX_IPORT_LEN) {
 				printk(KERN_ERR "APTPL metadata initiator_node="
 					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
 					PR_APTPL_MAX_IPORT_LEN);
-				ret = -1;
+				ret = -EINVAL;
 				break;
 			}
-			i_port = ptr;
-			continue;
-		}
-		ptr2 = strstr(cur, "initiator_sid");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			if (strlen(ptr) > PR_REG_ISID_LEN) {
+			break;
+		case Opt_initiator_sid:
+			isid = match_strdup(&args[0]);
+			if (strlen(isid) > PR_REG_ISID_LEN) {
 				printk(KERN_ERR "APTPL metadata initiator_isid"
 					"= exceeds PR_REG_ISID_LEN: %d\n",
 					PR_REG_ISID_LEN);
-				ret = -1;
+				ret = -EINVAL;
 				break;
 			}
-			isid = ptr;
-			continue;
-		}
-		ptr2 = strstr(cur, "sa_res_key");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoull(ptr, 0, &tmp_ll);
+			break;
+		case Opt_sa_res_key:
+			arg_p = match_strdup(&args[0]);
+			ret = strict_strtoull(arg_p, 0, &tmp_ll);
 			if (ret < 0) {
 				printk(KERN_ERR "strict_strtoull() failed for"
 					" sa_res_key=\n");
-				break;
+				goto out;
 			}
 			sa_res_key = (u64)tmp_ll;
-			continue;
-		}
+			break;
 		/*
 		 * PR APTPL Metadata for Reservation
 		 */
-		ptr2 = strstr(cur, "res_holder");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" res_holder=\n");
-				break;
-			}
-			res_holder = (int)tmp_l;
-			continue;
-		}
-		ptr2 = strstr(cur, "res_type");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" res_type=\n");
-				break;
-			}
-			type = (u8)tmp_l;
-			continue;
-		}
-		ptr2 = strstr(cur, "res_scope");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" res_scope=\n");
-				break;
-			}
-			scope = (u8)tmp_l;
-			continue;
-		}
-		ptr2 = strstr(cur, "res_all_tg_pt");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" res_all_tg_pt=\n");
-				break;
-			}
-			all_tg_pt = (int)tmp_l;
-			continue;
-		}
-		ptr2 = strstr(cur, "mapped_lun");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" mapped_lun=\n");
-				break;
-			}
-			mapped_lun = (u32)tmp_l;
-			continue;
-		}
+		case Opt_res_holder:
+			match_int(args, &arg);
+			res_holder = arg;
+			break;
+		case Opt_res_type:
+			match_int(args, &arg);
+			type = (u8)arg;
+			break;
+		case Opt_res_scope:
+			match_int(args, &arg);
+			scope = (u8)arg;
+			break;
+		case Opt_res_all_tg_pt:
+			match_int(args, &arg);
+			all_tg_pt = (int)arg;
+			break;
+		case Opt_mapped_lun:
+			match_int(args, &arg);
+			mapped_lun = (u32)arg;
+			break;
 		/*
 		 * PR APTPL Metadata for Target Port
 		 */
-		ptr2 = strstr(cur, "target_fabric");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			t_fabric = ptr;
-			continue;
-		}
-		ptr2 = strstr(cur, "target_node");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			if (strlen(ptr) > PR_APTPL_MAX_TPORT_LEN) {
+		case Opt_target_fabric:
+			t_fabric = match_strdup(&args[0]);
+			break;
+		case Opt_target_node:
+			t_port = match_strdup(&args[0]);
+			if (strlen(t_port) > PR_APTPL_MAX_TPORT_LEN) {
 				printk(KERN_ERR "APTPL metadata target_node="
 					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
 					PR_APTPL_MAX_TPORT_LEN);
-				ret = -1;
+				ret = -EINVAL;
 				break;
 			}
-			t_port = ptr;
-			continue;
-		}
-		ptr2 = strstr(cur, "tpgt");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" tpgt=\n");
-				break;
-			}
-			tpgt = (u16)tmp_l;
-			continue;
-		}
-		ptr2 = strstr(cur, "port_rtpi");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" port_rtpi=\n");
-				break;
-			}
-			port_rpti = (u16)tmp_l;
-			continue;
+			break;
+		case Opt_tpgt:
+			match_int(args, &arg);
+			tpgt = (u16)arg;
+			break;
+		case Opt_port_rtpi:
+			match_int(args, &arg);
+			port_rpti = (u16)arg;
+			break;
+		case Opt_target_lun:
+			match_int(args, &arg);
+			target_lun = (u32)arg;
+			break;
+		default:
+			break;
 		}
-		ptr2 = strstr(cur, "target_lun");
-		if (ptr2) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ret = strict_strtoul(ptr, 0, &tmp_l);
-			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoul() failed for"
-					" target_lun=\n");
-				break;
-			}
-			target_lun = (u32)tmp_l;
-			continue;
-		} else
-			cur = NULL;
 	}
 
 	if (!(i_port) || !(t_port) || !(sa_res_key)) {
 		printk(KERN_ERR "Illegal parameters for APTPL registration\n");
-		ret = -1;
+		ret = -EINVAL;
 		goto out;
 	}
 
 	if (res_holder && !(type)) {
 		printk(KERN_ERR "Illegal PR type: 0x%02x for reservation"
 				" holder\n", type);
-		ret = -1;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -1687,8 +1627,8 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			i_port, isid, mapped_lun, t_port, tpgt, target_lun,
 			res_holder, all_tg_pt, type);
 out:
-	kfree(buf);
-	return (ret == 0) ? count : -EINVAL;
+	kfree(orig);
+	return (ret == 0) ? count : ret;
 }
 
 SE_DEV_PR_ATTR(res_aptpl_metadata, S_IRUGO | S_IWUSR);
-- 
1.5.6.5

