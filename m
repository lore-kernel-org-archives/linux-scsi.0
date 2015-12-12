From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/7] iscsi-target: Less checks in iscsi_set_default_param()
 after error detection
Date: Sat, 12 Dec 2015 15:37:03 +0100
Message-ID: <566C310F.6040604@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566C2F7B.6030704@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Dec 2015 12:50:10 +0100

This issue was detected by using the Coccinelle software.

A sanity check would be performed by the iscsi_set_default_param() function
even if it is known already that the passed variable contained
a null pointer.

* This implementation detail could be improved by adjustments
  for jump targets according to the Linux coding style convention.

* Let us return directly if a call of the function "kzalloc" failed.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 0a8bd3f..15b2618 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -131,20 +131,20 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 
 	if (!param) {
 		pr_err("Unable to allocate memory for parameter.\n");
-		goto out;
+		return NULL;
 	}
 	INIT_LIST_HEAD(&param->p_list);
 
 	param->name = kstrdup(name, GFP_KERNEL);
 	if (!param->name) {
 		pr_err("Unable to allocate memory for parameter name.\n");
-		goto out;
+		goto free_param;
 	}
 
 	param->value = kstrdup(value, GFP_KERNEL);
 	if (!param->value) {
 		pr_err("Unable to allocate memory for parameter value.\n");
-		goto out;
+		goto free_name;
 	}
 
 	param->phase		= phase;
@@ -182,18 +182,17 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 	default:
 		pr_err("Unknown type_range 0x%02x\n",
 				param->type_range);
-		goto out;
+		goto free_value;
 	}
 	list_add_tail(&param->p_list, &param_list->param_list);
 
 	return param;
-out:
-	if (param) {
-		kfree(param->value);
-		kfree(param->name);
-		kfree(param);
-	}
-
+free_value:
+	kfree(param->value);
+free_name:
+	kfree(param->name);
+free_param:
+	kfree(param);
 	return NULL;
 }
 
-- 
2.6.3
