From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] target/tcm_fc: Rename ft_{add,
	del}_lport to {add, del}_wwn
Date: Fri,  4 Apr 2014 16:54:14 -0700
Message-ID: <1396655655-31060-5-git-send-email-agrover@redhat.com>
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

These functions are not adding or deleting an lport. They are adding a
wwn that may match with an lport that is present on the system.

Renaming ft_del_lport also means we won't have functions named
both ft_del_lport and ft_lport_del any more.

Signed-off-by: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/target/tcm_fc/tfc_conf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index bd7d544..efdcb96 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -403,7 +403,7 @@ struct ft_tpg *ft_lport_find_tpg(struct fc_lport *lport)
  * Add lport to allowed config.
  * The name is the WWPN in lower-case ASCII, colon-separated bytes.
  */
-static struct se_wwn *ft_add_lport(
+static struct se_wwn *ft_add_wwn(
 	struct target_fabric_configfs *tf,
 	struct config_group *group,
 	const char *name)
@@ -412,7 +412,7 @@ static struct se_wwn *ft_add_lport(
 	struct ft_lport_wwn *old_ft_wwn;
 	u64 wwpn;
 
-	pr_debug("add lport %s\n", name);
+	pr_debug("add wwn %s\n", name);
 	if (ft_parse_wwn(name, &wwpn, 1) < 0)
 		return NULL;
 	ft_wwn = kzalloc(sizeof(*ft_wwn), GFP_KERNEL);
@@ -435,12 +435,12 @@ static struct se_wwn *ft_add_lport(
 	return &ft_wwn->se_wwn;
 }
 
-static void ft_del_lport(struct se_wwn *wwn)
+static void ft_del_wwn(struct se_wwn *wwn)
 {
 	struct ft_lport_wwn *ft_wwn = container_of(wwn,
 				struct ft_lport_wwn, se_wwn);
 
-	pr_debug("del lport %s\n", ft_wwn->name);
+	pr_debug("del wwn %s\n", ft_wwn->name);
 	mutex_lock(&ft_lport_lock);
 	list_del(&ft_wwn->ft_wwn_node);
 	mutex_unlock(&ft_lport_lock);
@@ -542,8 +542,8 @@ static struct target_core_fabric_ops ft_fabric_ops = {
 	 * Setup function pointers for generic logic in
 	 * target_core_fabric_configfs.c
 	 */
-	.fabric_make_wwn =		&ft_add_lport,
-	.fabric_drop_wwn =		&ft_del_lport,
+	.fabric_make_wwn =		&ft_add_wwn,
+	.fabric_drop_wwn =		&ft_del_wwn,
 	.fabric_make_tpg =		&ft_add_tpg,
 	.fabric_drop_tpg =		&ft_del_tpg,
 	.fabric_post_link =		NULL,
-- 
1.9.0
