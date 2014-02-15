From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/2] target: Simplify target_core_store_alua_lu_gp
Date: Fri, 14 Feb 2014 16:11:17 -0800
Message-ID: <1392423077-15760-3-git-send-email-agrover@redhat.com>
References: <1392423077-15760-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaBOALS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 19:11:18 -0500
In-Reply-To: <1392423077-15760-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

If we know that lu_gp_mem->lu_gp will never be NULL, and "NULL" means
"set back to default_lu_gp" instead of really set to NULL (not allowed),
then we can simplify this function by not special-casing the
!lu_gp_new case, and setting lu_gp_new to default_lu_gp at the top.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_configfs.c | 46 ++++++++++-------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2a7a922..689cbf1 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1673,7 +1673,6 @@ static ssize_t target_core_store_alua_lu_gp(
 	struct t10_alua_lu_gp *lu_gp = NULL, *lu_gp_new = NULL;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	unsigned char buf[LU_GROUP_NAME_BUF];
-	int move = 0;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
 	if (!lu_gp_mem)
@@ -1689,7 +1688,13 @@ static ssize_t target_core_store_alua_lu_gp(
 	 * Any ALUA logical unit alias besides "NULL" means we will be
 	 * making a new group association.
 	 */
-	if (strcmp(strstrip(buf), "NULL")) {
+	if (!strcmp(strstrip(buf), "NULL")) {
+		/*
+		 * Clearing an existing lu_gp association, and going back to
+		 * the default group.
+		 */
+		lu_gp_new = default_lu_gp;
+	} else {
 		/*
 		 * core_alua_get_lu_gp_by_name() will increment reference to
 		 * struct t10_alua_lu_gp.  This reference is released with
@@ -1701,48 +1706,23 @@ static ssize_t target_core_store_alua_lu_gp(
 	}
 
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+
 	lu_gp = lu_gp_mem->lu_gp;
-	if (lu_gp) {
-		/*
-		 * Clearing an existing lu_gp association, and replacing
-		 * with NULL
-		 */
-		if (!lu_gp_new) {
-			pr_debug("Target_Core_ConfigFS: Releasing %s/%s"
-				" from ALUA LU Group: core/alua/lu_gps/%s, ID:"
-				" %hu\n",
-				config_item_name(&hba->hba_group.cg_item),
-				config_item_name(&dev->dev_group.cg_item),
-				config_item_name(&lu_gp->lu_gp_group.cg_item),
-				lu_gp->lu_gp_id);
-
-			__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
-			__core_alua_attach_lu_gp_mem(lu_gp_mem, default_lu_gp);
-			spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
-
-			return count;
-		}
-		/*
-		 * Removing existing association of lu_gp_mem with lu_gp
-		 */
-		__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
-		move = 1;
-	}
-	/*
-	 * Associate lu_gp_mem with lu_gp_new.
-	 */
+	__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
 	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
+
 	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 	pr_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
 		" core/alua/lu_gps/%s, ID: %hu\n",
-		(move) ? "Moving" : "Adding",
+		(lu_gp != default_lu_gp) ? "Moving" : "Adding",
 		config_item_name(&hba->hba_group.cg_item),
 		config_item_name(&dev->dev_group.cg_item),
 		config_item_name(&lu_gp_new->lu_gp_group.cg_item),
 		lu_gp_new->lu_gp_id);
 
-	core_alua_put_lu_gp_from_name(lu_gp_new);
+	if (lu_gp_new != default_lu_gp)
+		core_alua_put_lu_gp_from_name(lu_gp_new);
 	return count;
 }
 
-- 
1.8.5.3

