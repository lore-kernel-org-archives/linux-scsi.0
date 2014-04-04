From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] target/tcm_fc: Limit to 1 TPG per wwn
Date: Fri,  4 Apr 2014 16:54:12 -0700
Message-ID: <1396655655-31060-3-git-send-email-agrover@redhat.com>
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

tcm_fc doesn't support multiple TPGs per wwn. For proof, see
ft_lport_find_tpg. Enforce this in the code.

Replace ft_lport_wwn.tpg_list with a single pointer. We can't fold ft_tpg
into ft_lport_wwn because they can have different lifetimes.

Signed-off-by: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/target/tcm_fc/tcm_fc.h   |  3 +--
 drivers/target/tcm_fc/tfc_conf.c | 20 +++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index aba6861..7290f8f 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -96,7 +96,6 @@ struct ft_tpg {
 	u32 index;
 	struct ft_lport_acl *lport_acl;
 	struct ft_tport *tport;		/* active tport or NULL */
-	struct list_head list;		/* linkage in ft_lport_acl tpg_list */
 	struct list_head lun_list;	/* head of LUNs */
 	struct se_portal_group se_tpg;
 	struct workqueue_struct *workqueue;
@@ -105,8 +104,8 @@ struct ft_tpg {
 struct ft_lport_acl {
 	u64 wwpn;
 	char name[FT_NAMELEN];
+	struct ft_tpg *tpg;
 	struct list_head list;
-	struct list_head tpg_list;
 	struct se_wwn fc_lport_wwn;
 };
 
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 9c2da1f..ccfa328 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -318,6 +318,11 @@ static struct se_portal_group *ft_add_tpg(
 	if (index > UINT_MAX)
 		return NULL;
 
+	if ((index != 1)) {
+		pr_err("Error, a single TPG=1 is used for HW port mappings\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
 	lacl = container_of(wwn, struct ft_lport_acl, fc_lport_wwn);
 	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
 	if (!tpg)
@@ -342,7 +347,7 @@ static struct se_portal_group *ft_add_tpg(
 	tpg->workqueue = wq;
 
 	mutex_lock(&ft_lport_lock);
-	list_add_tail(&tpg->list, &lacl->tpg_list);
+	lacl->tpg = tpg;
 	mutex_unlock(&ft_lport_lock);
 
 	return &tpg->se_tpg;
@@ -351,6 +356,7 @@ static struct se_portal_group *ft_add_tpg(
 static void ft_del_tpg(struct se_portal_group *se_tpg)
 {
 	struct ft_tpg *tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
+	struct ft_lport_acl *lacl = tpg->lport_acl;
 
 	pr_debug("del tpg %s\n",
 		    config_item_name(&tpg->se_tpg.tpg_group.cg_item));
@@ -361,7 +367,8 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 	synchronize_rcu();
 
 	mutex_lock(&ft_lport_lock);
-	list_del(&tpg->list);
+	lacl->tpg = NULL;
+
 	if (tpg->tport) {
 		tpg->tport->tpg = NULL;
 		tpg->tport = NULL;
@@ -381,14 +388,10 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 struct ft_tpg *ft_lport_find_tpg(struct fc_lport *lport)
 {
 	struct ft_lport_acl *lacl;
-	struct ft_tpg *tpg;
 
 	list_for_each_entry(lacl, &ft_lport_list, list) {
-		if (lacl->wwpn == lport->wwpn) {
-			list_for_each_entry(tpg, &lacl->tpg_list, list)
-				return tpg; /* XXX for now return first entry */
-			return NULL;
-		}
+		if (lacl->wwpn == lport->wwpn)
+			return lacl->tpg;
 	}
 	return NULL;
 }
@@ -417,7 +420,6 @@ static struct se_wwn *ft_add_lport(
 	if (!lacl)
 		return NULL;
 	lacl->wwpn = wwpn;
-	INIT_LIST_HEAD(&lacl->tpg_list);
 
 	mutex_lock(&ft_lport_lock);
 	list_for_each_entry(old_lacl, &ft_lport_list, list) {
-- 
1.9.0
