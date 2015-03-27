From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 02/22] target: Convert enable/disable ->device_list to RCU updater
Date: Fri, 27 Mar 2015 08:04:52 +0000
Message-ID: <1427443512-8925-3-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34976 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbbC0IGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:03 -0400
Received: by oiag65 with SMTP id g65so69887957oia.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:02 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts core_[enable,disable]_device_list_for_node() to RCU
updater path code when modifying se_dev_entry pointers.

It includes protected rcu_assign_pointer() and invokes synchronize_rcu()
to wait for RCU read paths to finish.

Required for subsequent conversion to se_deve->pr_ref percpu-refcount.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 50 ++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index be893c8..9385e16 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -324,31 +324,16 @@ int core_enable_device_list_for_node(
 	struct se_port *port = lun->lun_sep;
 	struct se_dev_entry *deve;
 
-	spin_lock_irq(&nacl->device_list_lock);
-
-	deve = nacl->device_list[mapped_lun];
-
 	/*
 	 * Check if the call is handling demo mode -> explicit LUN ACL
 	 * transition.  This transition must be for the same struct se_lun
 	 * + mapped_lun that was setup in demo mode..
 	 */
+	spin_lock_irq(&nacl->lun_entry_lock);
+	deve = nacl->lun_entry_hlist[mapped_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		if (deve->se_lun_acl != NULL) {
-			pr_err("struct se_dev_entry->se_lun_acl"
-			       " already set for demo mode -> explicit"
-			       " LUN ACL transition\n");
-			spin_unlock_irq(&nacl->device_list_lock);
-			return -EINVAL;
-		}
-		if (deve->se_lun != lun) {
-			pr_err("struct se_dev_entry->se_lun does"
-			       " match passed struct se_lun for demo mode"
-			       " -> explicit LUN ACL transition\n");
-			spin_unlock_irq(&nacl->device_list_lock);
-			return -EINVAL;
-		}
-		deve->se_lun_acl = lun_acl;
+		BUG_ON(deve->se_lun_acl != NULL);
+		BUG_ON(deve->se_lun != lun);
 
 		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
 			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
@@ -357,13 +342,13 @@ int core_enable_device_list_for_node(
 			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
 			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 		}
+		rcu_assign_pointer(deve->se_lun_acl, lun_acl);
+		spin_unlock_irq(&nacl->lun_entry_lock);
 
-		spin_unlock_irq(&nacl->device_list_lock);
+		synchronize_rcu();
 		return 0;
 	}
 
-	deve->se_lun = lun;
-	deve->se_lun_acl = lun_acl;
 	deve->mapped_lun = mapped_lun;
 	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
 
@@ -377,12 +362,16 @@ int core_enable_device_list_for_node(
 
 	deve->creation_time = get_jiffies_64();
 	deve->attach_count++;
-	spin_unlock_irq(&nacl->device_list_lock);
+
+	rcu_assign_pointer(deve->se_lun, lun);
+	rcu_assign_pointer(deve->se_lun_acl, lun_acl);
+	spin_unlock_irq(&nacl->lun_entry_lock);
 
 	spin_lock_bh(&port->sep_alua_lock);
 	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 
+	synchronize_rcu();
 	return 0;
 }
 
@@ -399,8 +388,10 @@ int core_disable_device_list_for_node(
 	struct se_portal_group *tpg)
 {
 	struct se_port *port = lun->lun_sep;
-	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
+	struct se_dev_entry *deve;
 
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[mapped_lun]);
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
 	 * port->sep_alua_list must be removed now before clearing the
@@ -424,17 +415,20 @@ int core_disable_device_list_for_node(
 	while (atomic_read(&deve->pr_ref_count) != 0)
 		cpu_relax();
 
-	spin_lock_irq(&nacl->device_list_lock);
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
+	spin_lock_irq(&nacl->lun_entry_lock);
 	core_scsi3_ua_release_all(deve);
-	deve->se_lun = NULL;
-	deve->se_lun_acl = NULL;
+	rcu_assign_pointer(deve->se_lun, NULL);
+	rcu_assign_pointer(deve->se_lun_acl, NULL);
 	deve->lun_flags = 0;
 	deve->creation_time = 0;
 	deve->attach_count--;
-	spin_unlock_irq(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->lun_entry_lock);
+	rcu_read_unlock();
+
+	synchronize_rcu();
 
 	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
 	return 0;
-- 
1.9.1

