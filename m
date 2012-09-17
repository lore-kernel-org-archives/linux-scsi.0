From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] drivers/target/target_core_configfs.c: fix error return code
Date: Mon, 17 Sep 2012 20:05:33 +0200
Message-ID: <1347905133-28492-1-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/target/target_core_configfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a1b4171..015f5be 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3124,6 +3124,7 @@ static int __init target_core_init_configfs(void)
 				GFP_KERNEL);
 	if (!target_cg->default_groups) {
 		pr_err("Unable to allocate target_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3139,6 +3140,7 @@ static int __init target_core_init_configfs(void)
 				GFP_KERNEL);
 	if (!hba_cg->default_groups) {
 		pr_err("Unable to allocate hba_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 	config_group_init_type_name(&alua_group,
@@ -3154,6 +3156,7 @@ static int __init target_core_init_configfs(void)
 			GFP_KERNEL);
 	if (!alua_cg->default_groups) {
 		pr_err("Unable to allocate alua_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3165,14 +3168,17 @@ static int __init target_core_init_configfs(void)
 	 * Add core/alua/lu_gps/default_lu_gp
 	 */
 	lu_gp = core_alua_allocate_lu_gp("default_lu_gp", 1);
-	if (IS_ERR(lu_gp))
+	if (IS_ERR(lu_gp)) {
+		ret = -ENOMEM;
 		goto out_global;
+	}
 
 	lu_gp_cg = &alua_lu_gps_group;
 	lu_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!lu_gp_cg->default_groups) {
 		pr_err("Unable to allocate lu_gp_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
-- 
1.7.11.4
