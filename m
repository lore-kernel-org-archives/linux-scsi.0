From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/21] iscsi-target: Fix leak on failure in iscsi_copy_param_list()
Date: Wed, 17 Aug 2011 23:17:08 +0000
Message-ID: <1313623045-15916-5-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58299 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1HQXmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:20 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jesper Juhl <jj@chaosbits.net>

From: Jesper Juhl <jj@chaosbits.net>

We leak memory if the allocations for 'new_param->name' or
'new_param->value' fail in iscsi_target_parameters.c::iscsi_copy_param_list()

We also do a lot of variable assignments that are completely pointless
if the allocations fail.

So, let's move the allocations before the assignments and also make
sure that we free whatever was allocated to one if the allocation fail.

There's also some small CodingStyle fixups in there (curly braces on
both branches of if statement, only one variable per line) since I was
in the area anyway. And finally, error messages in the function are
put on a single line for easy grep'abillity.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_parameters.c |   43 +++++++++---------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 252e246..497b2e7 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -545,13 +545,13 @@ int iscsi_copy_param_list(
 	struct iscsi_param_list *src_param_list,
 	int leading)
 {
-	struct iscsi_param *new_param = NULL, *param = NULL;
+	struct iscsi_param *param = NULL;
+	struct iscsi_param *new_param = NULL;
 	struct iscsi_param_list *param_list = NULL;
 
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!param_list) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_param_list.\n");
+		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
 		goto err_out;
 	}
 	INIT_LIST_HEAD(&param_list->param_list);
@@ -567,8 +567,17 @@ int iscsi_copy_param_list(
 
 		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 		if (!new_param) {
-			pr_err("Unable to allocate memory for"
-				" struct iscsi_param.\n");
+			pr_err("Unable to allocate memory for struct iscsi_param.\n");
+			goto err_out;
+		}
+
+		new_param->name = kstrdup(param->name, GFP_KERNEL);
+		new_param->value = kstrdup(param->value, GFP_KERNEL);
+		if (!new_param->value || !new_param->name) {
+			kfree(new_param->value);
+			kfree(new_param->name);
+			kfree(new_param);
+			pr_err("Unable to allocate memory for parameter name/value.\n");
 			goto err_out;
 		}
 
@@ -580,32 +589,12 @@ int iscsi_copy_param_list(
 		new_param->use = param->use;
 		new_param->type_range = param->type_range;
 
-		new_param->name = kzalloc(strlen(param->name) + 1, GFP_KERNEL);
-		if (!new_param->name) {
-			pr_err("Unable to allocate memory for"
-				" parameter name.\n");
-			goto err_out;
-		}
-
-		new_param->value = kzalloc(strlen(param->value) + 1,
-				GFP_KERNEL);
-		if (!new_param->value) {
-			pr_err("Unable to allocate memory for"
-				" parameter value.\n");
-			goto err_out;
-		}
-
-		memcpy(new_param->name, param->name, strlen(param->name));
-		new_param->name[strlen(param->name)] = '\0';
-		memcpy(new_param->value, param->value, strlen(param->value));
-		new_param->value[strlen(param->value)] = '\0';
-
 		list_add_tail(&new_param->p_list, &param_list->param_list);
 	}
 
-	if (!list_empty(&param_list->param_list))
+	if (!list_empty(&param_list->param_list)) {
 		*dst_param_list = param_list;
-	else {
+	} else {
 		pr_err("No parameters allocated.\n");
 		goto err_out;
 	}
-- 
1.7.6

