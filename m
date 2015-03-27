From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 11/22] target: Convert UNIT_ATTENTION logic to RCU reader
Date: Fri, 27 Mar 2015 08:05:01 +0000
Message-ID: <1427443512-8925-12-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts target_core_ua.c code to use RCU read path macros
for se_node_acl->lun_entry_hlist[] access.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_ua.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 1738b16..975dbba 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -51,9 +51,13 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 	if (!nacl)
 		return 0;
 
-	deve = nacl->device_list[cmd->orig_fe_lun];
-	if (!atomic_read(&deve->ua_count))
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[cmd->orig_fe_lun]);
+	if (!atomic_read(&deve->ua_count)) {
+		rcu_read_unlock();
 		return 0;
+	}
+	rcu_read_unlock();
 	/*
 	 * From sam4r14, section 5.14 Unit attention condition:
 	 *
@@ -104,9 +108,8 @@ int core_scsi3_ua_allocate(
 	ua->ua_asc = asc;
 	ua->ua_ascq = ascq;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[unpacked_lun];
-
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[unpacked_lun]);
 	spin_lock(&deve->ua_lock);
 	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_list) {
 		/*
@@ -114,7 +117,7 @@ int core_scsi3_ua_allocate(
 		 */
 		if ((ua_p->ua_asc == asc) && (ua_p->ua_ascq == ascq)) {
 			spin_unlock(&deve->ua_lock);
-			spin_unlock_irq(&nacl->device_list_lock);
+			rcu_read_unlock();
 			kmem_cache_free(se_ua_cache, ua);
 			return 0;
 		}
@@ -159,14 +162,13 @@ int core_scsi3_ua_allocate(
 			list_add_tail(&ua->ua_nacl_list,
 				&deve->ua_list);
 		spin_unlock(&deve->ua_lock);
-		spin_unlock_irq(&nacl->device_list_lock);
 
 		atomic_inc_mb(&deve->ua_count);
+		rcu_read_unlock();
 		return 0;
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
 
 	pr_debug("[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
 		" 0x%02x, ASCQ: 0x%02x\n",
@@ -174,6 +176,7 @@ int core_scsi3_ua_allocate(
 		asc, ascq);
 
 	atomic_inc_mb(&deve->ua_count);
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -211,10 +214,10 @@ void core_scsi3_ua_for_check_condition(
 	if (!nacl)
 		return;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[cmd->orig_fe_lun]);
 	if (!atomic_read(&deve->ua_count)) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return;
 	}
 	/*
@@ -250,7 +253,7 @@ void core_scsi3_ua_for_check_condition(
 		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	pr_debug("[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
@@ -279,10 +282,10 @@ int core_scsi3_ua_clear_for_request_sense(
 	if (!nacl)
 		return -EINVAL;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[cmd->orig_fe_lun]);
 	if (!atomic_read(&deve->ua_count)) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -EPERM;
 	}
 	/*
@@ -308,7 +311,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
-- 
1.9.1
