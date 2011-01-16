From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix memory leaks in target_core_dev_pr_store_attr_res_aptpl_metadata
Date: Sun, 16 Jan 2011 15:04:31 -0800
Message-ID: <1295219071-32722-2-git-send-email-nab@linux-iscsi.org>
References: <1295219071-32722-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm12.bullet.mail.sp2.yahoo.com ([98.139.91.82]:32209 "HELO
	nm12.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752163Ab1APXEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Jan 2011 18:04:37 -0500
In-Reply-To: <1295219071-32722-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Jesper Juhl <jj@chaosbits.net>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds missing kfree()'s for match_strdup() allocations for
Opt_initiator_fabric, Opt_initiator_node, Opt_initiator_sid, Opt_sa_res_key,
Opt_target_fabric, and Opt_target_node for the Persistent Reservations
Activate Persistence across Target Power Loss (APTPL=1) token parsing.

Reported-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2764510..656c4fa 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1452,8 +1452,8 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
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
@@ -1489,9 +1489,17 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
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
@@ -1502,6 +1510,10 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
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
@@ -1512,6 +1524,10 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
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
@@ -1548,9 +1564,17 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
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
@@ -1593,6 +1617,11 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
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
-- 
1.5.6.5

