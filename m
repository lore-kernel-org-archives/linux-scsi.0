From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/2] target: Ensure lu_gp_mem->lu_gp is never NULL
Date: Fri, 14 Feb 2014 16:11:16 -0800
Message-ID: <1392423077-15760-2-git-send-email-agrover@redhat.com>
References: <1392423077-15760-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaBOALS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 19:11:18 -0500
In-Reply-To: <1392423077-15760-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

->lu_gp should never be NULL, because if lu_gp_mem is not in an explicit
group, it should be in default_lu_gp. Change target_core_store_alua_lu_gp
to make this so.

Also, fix a typo in a comment in that function.

Finally, in core_alua_free_lu_gp, explicitly leave the old group before
joining default_lu_gp, allowing simpler logic.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_alua.c     | 6 ++----
 drivers/target/target_core_configfs.c | 3 ++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 12da9b3..60a6a2c 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1599,11 +1599,9 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 		 * we want to re-associate a given lu_gp_mem with default_lu_gp.
 		 */
 		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
+		__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
 		if (lu_gp != default_lu_gp)
-			__core_alua_attach_lu_gp_mem(lu_gp_mem,
-					default_lu_gp);
-		else
-			lu_gp_mem->lu_gp = NULL;
+			__core_alua_attach_lu_gp_mem(lu_gp_mem, default_lu_gp);
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 		spin_lock(&lu_gp->lu_gp_lock);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f0e85b1..2a7a922 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1693,7 +1693,7 @@ static ssize_t target_core_store_alua_lu_gp(
 		/*
 		 * core_alua_get_lu_gp_by_name() will increment reference to
 		 * struct t10_alua_lu_gp.  This reference is released with
-		 * core_alua_get_lu_gp_by_name below().
+		 * core_alua_put_lu_gp_from_name() below.
 		 */
 		lu_gp_new = core_alua_get_lu_gp_by_name(strstrip(buf));
 		if (!lu_gp_new)
@@ -1717,6 +1717,7 @@ static ssize_t target_core_store_alua_lu_gp(
 				lu_gp->lu_gp_id);
 
 			__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
+			__core_alua_attach_lu_gp_mem(lu_gp_mem, default_lu_gp);
 			spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 			return count;
-- 
1.8.5.3

