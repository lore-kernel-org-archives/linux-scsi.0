From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] target/tcm_fc: Rename structs and list
	members for clarity
Date: Fri,  4 Apr 2014 16:54:13 -0700
Message-ID: <1396655655-31060-4-git-send-email-agrover@redhat.com>
References: <1396655655-31060-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1396655655-31060-1-git-send-email-agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Rename struct ft_lport_acl to ft_lport_wwn. "acl" is associated with
something different in LIO terms. Really, ft_lport_wwn is the
fabric-specific wrapper for the struct se_wwn.

Rename "lacl" local variables to "ft_wwn" as well.

Rename list_heads used as list members to make it clear they're nodes, not
heads.

Rename lport_node to ft_wwn_node.

Rename ft_lport_list to ft_wwn_list

Signed-off-by: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/target/tcm_fc/tcm_fc.h   |  8 +++---
 drivers/target/tcm_fc/tfc_conf.c | 57 ++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 7290f8f..a0bcfd3 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -94,19 +94,19 @@ struct ft_lun {
  */
 struct ft_tpg {
 	u32 index;
-	struct ft_lport_acl *lport_acl;
+	struct ft_lport_wwn *lport_wwn;
 	struct ft_tport *tport;		/* active tport or NULL */
 	struct list_head lun_list;	/* head of LUNs */
 	struct se_portal_group se_tpg;
 	struct workqueue_struct *workqueue;
 };
 
-struct ft_lport_acl {
+struct ft_lport_wwn {
 	u64 wwpn;
 	char name[FT_NAMELEN];
+	struct list_head ft_wwn_node;
 	struct ft_tpg *tpg;
-	struct list_head list;
-	struct se_wwn fc_lport_wwn;
+	struct se_wwn se_wwn;
 };
 
 /*
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index ccfa328..bd7d544 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -50,7 +50,7 @@
 
 struct target_fabric_configfs *ft_configfs;
 
-static LIST_HEAD(ft_lport_list);
+static LIST_HEAD(ft_wwn_list);
 DEFINE_MUTEX(ft_lport_lock);
 
 unsigned int ft_debug_logging;
@@ -298,7 +298,7 @@ static struct se_portal_group *ft_add_tpg(
 	struct config_group *group,
 	const char *name)
 {
-	struct ft_lport_acl *lacl;
+	struct ft_lport_wwn *ft_wwn;
 	struct ft_tpg *tpg;
 	struct workqueue_struct *wq;
 	unsigned long index;
@@ -323,12 +323,12 @@ static struct se_portal_group *ft_add_tpg(
 		return ERR_PTR(-ENOSYS);
 	}
 
-	lacl = container_of(wwn, struct ft_lport_acl, fc_lport_wwn);
+	ft_wwn = container_of(wwn, struct ft_lport_wwn, se_wwn);
 	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
 	if (!tpg)
 		return NULL;
 	tpg->index = index;
-	tpg->lport_acl = lacl;
+	tpg->lport_wwn = ft_wwn;
 	INIT_LIST_HEAD(&tpg->lun_list);
 
 	wq = alloc_workqueue("tcm_fc", 0, 1);
@@ -347,7 +347,7 @@ static struct se_portal_group *ft_add_tpg(
 	tpg->workqueue = wq;
 
 	mutex_lock(&ft_lport_lock);
-	lacl->tpg = tpg;
+	ft_wwn->tpg = tpg;
 	mutex_unlock(&ft_lport_lock);
 
 	return &tpg->se_tpg;
@@ -356,7 +356,7 @@ static struct se_portal_group *ft_add_tpg(
 static void ft_del_tpg(struct se_portal_group *se_tpg)
 {
 	struct ft_tpg *tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
-	struct ft_lport_acl *lacl = tpg->lport_acl;
+	struct ft_lport_wwn *ft_wwn = tpg->lport_wwn;
 
 	pr_debug("del tpg %s\n",
 		    config_item_name(&tpg->se_tpg.tpg_group.cg_item));
@@ -367,8 +367,7 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 	synchronize_rcu();
 
 	mutex_lock(&ft_lport_lock);
-	lacl->tpg = NULL;
-
+	ft_wwn->tpg = NULL;
 	if (tpg->tport) {
 		tpg->tport->tpg = NULL;
 		tpg->tport = NULL;
@@ -387,11 +386,11 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
  */
 struct ft_tpg *ft_lport_find_tpg(struct fc_lport *lport)
 {
-	struct ft_lport_acl *lacl;
+	struct ft_lport_wwn *ft_wwn;
 
-	list_for_each_entry(lacl, &ft_lport_list, list) {
-		if (lacl->wwpn == lport->wwpn)
-			return lacl->tpg;
+	list_for_each_entry(ft_wwn, &ft_wwn_list, ft_wwn_node) {
+		if (ft_wwn->wwpn == lport->wwpn)
+			return ft_wwn->tpg;
 	}
 	return NULL;
 }
@@ -409,44 +408,44 @@ static struct se_wwn *ft_add_lport(
 	struct config_group *group,
 	const char *name)
 {
-	struct ft_lport_acl *lacl;
-	struct ft_lport_acl *old_lacl;
+	struct ft_lport_wwn *ft_wwn;
+	struct ft_lport_wwn *old_ft_wwn;
 	u64 wwpn;
 
 	pr_debug("add lport %s\n", name);
 	if (ft_parse_wwn(name, &wwpn, 1) < 0)
 		return NULL;
-	lacl = kzalloc(sizeof(*lacl), GFP_KERNEL);
-	if (!lacl)
+	ft_wwn = kzalloc(sizeof(*ft_wwn), GFP_KERNEL);
+	if (!ft_wwn)
 		return NULL;
-	lacl->wwpn = wwpn;
+	ft_wwn->wwpn = wwpn;
 
 	mutex_lock(&ft_lport_lock);
-	list_for_each_entry(old_lacl, &ft_lport_list, list) {
-		if (old_lacl->wwpn == wwpn) {
+	list_for_each_entry(old_ft_wwn, &ft_wwn_list, ft_wwn_node) {
+		if (old_ft_wwn->wwpn == wwpn) {
 			mutex_unlock(&ft_lport_lock);
-			kfree(lacl);
+			kfree(ft_wwn);
 			return NULL;
 		}
 	}
-	list_add_tail(&lacl->list, &ft_lport_list);
-	ft_format_wwn(lacl->name, sizeof(lacl->name), wwpn);
+	list_add_tail(&ft_wwn->ft_wwn_node, &ft_wwn_list);
+	ft_format_wwn(ft_wwn->name, sizeof(ft_wwn->name), wwpn);
 	mutex_unlock(&ft_lport_lock);
 
-	return &lacl->fc_lport_wwn;
+	return &ft_wwn->se_wwn;
 }
 
 static void ft_del_lport(struct se_wwn *wwn)
 {
-	struct ft_lport_acl *lacl = container_of(wwn,
-				struct ft_lport_acl, fc_lport_wwn);
+	struct ft_lport_wwn *ft_wwn = container_of(wwn,
+				struct ft_lport_wwn, se_wwn);
 
-	pr_debug("del lport %s\n", lacl->name);
+	pr_debug("del lport %s\n", ft_wwn->name);
 	mutex_lock(&ft_lport_lock);
-	list_del(&lacl->list);
+	list_del(&ft_wwn->ft_wwn_node);
 	mutex_unlock(&ft_lport_lock);
 
-	kfree(lacl);
+	kfree(ft_wwn);
 }
 
 static ssize_t ft_wwn_show_attr_version(
@@ -473,7 +472,7 @@ static char *ft_get_fabric_wwn(struct se_portal_group *se_tpg)
 {
 	struct ft_tpg *tpg = se_tpg->se_tpg_fabric_ptr;
 
-	return tpg->lport_acl->name;
+	return tpg->lport_wwn->name;
 }
 
 static u16 ft_get_tag(struct se_portal_group *se_tpg)
-- 
1.9.0
