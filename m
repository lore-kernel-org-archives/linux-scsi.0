From: Chengguang Xu <cgxu519@gmx.com>
Subject: [RESEND PATCH] target: fix potential memory leak in option parsing
Date: Wed, 13 Jun 2018 13:27:26 +0800
Message-ID: <1528867646-138322-1-git-send-email-cgxu519@gmx.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
List-Id: linux-scsi@vger.kernel.org

When specifying same string type option several times,
current option parsing will cause memory leak. Hence,
call kfree for previous one in this case.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 drivers/target/target_core_configfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 5ccef7d..5512432 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1661,6 +1661,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_initiator_fabric:
+			kfree(i_fabric);
 			i_fabric = match_strdup(args);
 			if (!i_fabric) {
 				ret = -ENOMEM;
@@ -1668,6 +1669,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			}
 			break;
 		case Opt_initiator_node:
+			kfree(i_port);
 			i_port = match_strdup(args);
 			if (!i_port) {
 				ret = -ENOMEM;
@@ -1682,6 +1684,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			}
 			break;
 		case Opt_initiator_sid:
+			kfree(isid);
 			isid = match_strdup(args);
 			if (!isid) {
 				ret = -ENOMEM;
@@ -1739,6 +1742,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		 * PR APTPL Metadata for Target Port
 		 */
 		case Opt_target_fabric:
+			kfree(t_fabric);
 			t_fabric = match_strdup(args);
 			if (!t_fabric) {
 				ret = -ENOMEM;
@@ -1746,6 +1750,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			}
 			break;
 		case Opt_target_node:
+			kfree(t_port);
 			t_port = match_strdup(args);
 			if (!t_port) {
 				ret = -ENOMEM;
-- 
1.8.3.1
