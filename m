From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 RESENDv2 9/9] target: Refactor core_enable_device_list_for_node
Date: Mon, 23 Jun 2014 16:55:38 -0700
Message-ID: <1403567738-13310-10-git-send-email-agrover@redhat.com>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaFWXzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2014 19:55:46 -0400
In-Reply-To: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

Create helper functions to alloc a deve and to transition it from
demo mode to explicit.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c | 121 ++++++++++++++++++++++--------------
 1 file changed, 74 insertions(+), 47 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 28ab38f..dc510d5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -288,6 +288,73 @@ void core_update_device_list_access(
 	spin_unlock_irq(&nacl->device_list_lock);
 }
 
+static struct se_dev_entry *core_alloc_se_dev_entry(
+	struct se_lun *lun,
+	struct se_lun_acl *lun_acl,
+	u32 mapped_lun,
+	u32 lun_access,
+	struct se_node_acl *nacl)
+{
+	struct se_dev_entry *deve;
+
+	/* Holding locks, can't sleep */
+	deve = kzalloc(sizeof(*deve), GFP_ATOMIC);
+	if (!deve)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&deve->ua_count, 0);
+	atomic_set(&deve->pr_ref_count, 0);
+	spin_lock_init(&deve->ua_lock);
+	INIT_LIST_HEAD(&deve->alua_port_list);
+	INIT_LIST_HEAD(&deve->ua_list);
+	deve->se_lun = lun;
+	deve->se_lun_acl = lun_acl;
+	deve->mapped_lun = mapped_lun;
+
+	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
+		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+	else
+		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+
+	deve->creation_time = get_jiffies_64();
+
+	nacl->device_list[mapped_lun] = deve;
+
+	return deve;
+}
+
+static int core_transition_deve_to_explicit(
+	struct se_lun *lun,
+	struct se_lun_acl *lun_acl,
+	struct se_dev_entry *deve,
+	u32 lun_access)
+{
+	if (deve->se_lun_acl != NULL) {
+		pr_err("struct se_dev_entry->se_lun_acl"
+		       " already set for demo mode -> explicit"
+		       " LUN ACL transition\n");
+		return -EINVAL;
+	}
+	if (deve->se_lun != lun) {
+		pr_err("struct se_dev_entry->se_lun does"
+		       " match passed struct se_lun for demo mode"
+		       " -> explicit LUN ACL transition\n");
+		return -EINVAL;
+	}
+
+	deve->se_lun_acl = lun_acl;
+
+	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
+		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+	} else {
+		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+	}
+
+	return 0;
+}
+
 /*      core_enable_device_list_for_node():
  *
  * Called with tpg_lun_lock held & irqs off
@@ -314,62 +381,22 @@ int core_enable_device_list_for_node(
 	 * + mapped_lun that was setup in demo mode..
 	 */
 	if (deve) {
-		if (deve->se_lun_acl != NULL) {
-			pr_err("struct se_dev_entry->se_lun_acl"
-			       " already set for demo mode -> explicit"
-			       " LUN ACL transition\n");
-			ret = -EINVAL;
-			goto out;
-		}
-		if (deve->se_lun != lun) {
-			pr_err("struct se_dev_entry->se_lun does"
-			       " match passed struct se_lun for demo mode"
-			       " -> explicit LUN ACL transition\n");
-			ret = -EINVAL;
-			goto out;
-		}
-		deve->se_lun_acl = lun_acl;
-
-		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-		} else {
-			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
-			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-		}
-
+		ret = core_transition_deve_to_explicit(lun, lun_acl, deve,
+						       lun_access);
 		goto out;
 	}
 
-	deve = kzalloc(sizeof(*deve), GFP_ATOMIC);
-	if (!deve) {
-		spin_unlock_irq(&nacl->device_list_lock);
-		return -ENOMEM;
+	deve = core_alloc_se_dev_entry(lun, lun_acl, mapped_lun, lun_access, nacl);
+	if (IS_ERR(deve)) {
+		ret = PTR_ERR(deve);
+		goto out;
 	}
 
-	nacl->device_list[mapped_lun] = deve;
-
-	atomic_set(&deve->ua_count, 0);
-	atomic_set(&deve->pr_ref_count, 0);
-	spin_lock_init(&deve->ua_lock);
-	INIT_LIST_HEAD(&deve->alua_port_list);
-	INIT_LIST_HEAD(&deve->ua_list);
-	deve->se_lun = lun;
-	deve->se_lun_acl = lun_acl;
-	deve->mapped_lun = mapped_lun;
-
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	else
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-
-	deve->creation_time = get_jiffies_64();
-	deve->attach_count++;
-
 	spin_lock(&port->sep_alua_lock);
 	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
 	spin_unlock(&port->sep_alua_lock);
 
+	deve->attach_count++;
 out:
 	spin_unlock(&nacl->device_list_lock);
 
-- 
1.9.3

