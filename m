From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 RESENDv2 2/9] target: Don't unlock/relock tpg_lun_lock in loop in add_node_to_devs
Date: Mon, 23 Jun 2014 16:55:31 -0700
Message-ID: <1403567738-13310-3-git-send-email-agrover@redhat.com>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

It's not safe to unlock/relock in core_tpg_add_node_to_devs. Remove this.

As a consequence, core_enable_device_list_for_node needs to be called with
a lock held & irqs off. Add a comment mentioning this. Change
spin_lock_irqs to spin_locks. Change error handling to goto-style.

Also change the other place enable_device_list_for_node is called,
add_initiator_node_lun_acl. Hold tpg_lun_lock across all uses of lun.
Change error handling to release lock from error paths. Remove
core_dev_get_lun.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c | 78 ++++++++++++++-----------------------
 drivers/target/target_core_tpg.c    |  3 --
 2 files changed, 29 insertions(+), 52 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9789a11..b15219e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -295,7 +295,7 @@ void core_update_device_list_access(
 
 /*      core_enable_device_list_for_node():
  *
- *
+ * Called with tpg_lun_lock held & irqs off
  */
 int core_enable_device_list_for_node(
 	struct se_lun *lun,
@@ -307,8 +307,9 @@ int core_enable_device_list_for_node(
 {
 	struct se_port *port = lun->lun_sep;
 	struct se_dev_entry *deve;
+	int ret = 0;
 
-	spin_lock_irq(&nacl->device_list_lock);
+	spin_lock(&nacl->device_list_lock);
 
 	deve = nacl->device_list[mapped_lun];
 
@@ -322,15 +323,15 @@ int core_enable_device_list_for_node(
 			pr_err("struct se_dev_entry->se_lun_acl"
 			       " already set for demo mode -> explicit"
 			       " LUN ACL transition\n");
-			spin_unlock_irq(&nacl->device_list_lock);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		if (deve->se_lun != lun) {
 			pr_err("struct se_dev_entry->se_lun does"
 			       " match passed struct se_lun for demo mode"
 			       " -> explicit LUN ACL transition\n");
-			spin_unlock_irq(&nacl->device_list_lock);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		deve->se_lun_acl = lun_acl;
 
@@ -342,8 +343,7 @@ int core_enable_device_list_for_node(
 			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 		}
 
-		spin_unlock_irq(&nacl->device_list_lock);
-		return 0;
+		goto out;
 	}
 
 	deve->se_lun = lun;
@@ -366,9 +366,10 @@ int core_enable_device_list_for_node(
 	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
 	spin_unlock(&port->sep_alua_lock);
 
-	spin_unlock_irq(&nacl->device_list_lock);
+out:
+	spin_unlock(&nacl->device_list_lock);
 
-	return 0;
+	return ret;
 }
 
 /*      core_disable_device_list_for_node():
@@ -1299,39 +1300,6 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_l
 	return lun;
 }
 
-/*      core_dev_get_lun():
- *
- *
- */
-static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked_lun)
-{
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
-			"_TPG-1: %u for Target Portal Group: %hu\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
-
-	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
-		pr_err("%s Logical Unit Number: %u is not active on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return lun;
-}
-
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_node_acl *nacl,
@@ -1370,19 +1338,24 @@ int core_dev_add_initiator_node_lun_acl(
 {
 	struct se_lun *lun;
 	struct se_node_acl *nacl;
+	int ret = 0;
 
-	lun = core_dev_get_lun(tpg, unpacked_lun);
+	spin_lock(&tpg->tpg_lun_lock);
+	lun = tpg->tpg_lun_list[unpacked_lun];
 	if (!lun) {
 		pr_err("%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	nacl = lacl->se_lun_nacl;
-	if (!nacl)
-		return -EINVAL;
+	if (!nacl) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	if ((lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) &&
 	    (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE))
@@ -1392,7 +1365,10 @@ int core_dev_add_initiator_node_lun_acl(
 
 	if (core_enable_device_list_for_node(lun, lacl, lacl->mapped_lun,
 			lun_access, nacl, tpg) < 0)
-		return -EINVAL;
+	{
+		ret = -EINVAL;
+		goto out;
+	}
 
 	spin_lock(&lun->lun_acl_lock);
 	list_add_tail(&lacl->lacl_list, &lun->lun_acl_list);
@@ -1410,7 +1386,11 @@ int core_dev_add_initiator_node_lun_acl(
 	 * pre-registrations that need to be enabled for this LUN ACL..
 	 */
 	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, lacl);
-	return 0;
+
+out:
+	spin_unlock(&tpg->tpg_lun_lock);
+
+	return ret;
 }
 
 /*      core_dev_del_initiator_node_lun_acl():
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c036595..88fddcf 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -137,8 +137,6 @@ void core_tpg_add_node_to_devs(
 		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 			continue;
 
-		spin_unlock(&tpg->tpg_lun_lock);
-
 		dev = lun->lun_se_dev;
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
@@ -166,7 +164,6 @@ void core_tpg_add_node_to_devs(
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
 				lun_access, acl, tpg);
-		spin_lock(&tpg->tpg_lun_lock);
 	}
 	spin_unlock(&tpg->tpg_lun_lock);
 }
-- 
1.9.3
