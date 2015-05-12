From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 04/12] target: Convert UNIT_ATTENTION logic to RCU reader
Date: Tue, 12 May 2015 09:25:28 +0000
Message-ID: <1431422736-29125-5-git-send-email-nab@daterainc.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33308 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389AbbELJ2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 05:28:04 -0400
Received: by obblk2 with SMTP id lk2so953861obb.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 02:28:03 -0700 (PDT)
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts target_core_ua.c code to use RCU read path locks
for se_node_acl->lun_entry_hlist access.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_ua.c | 51 ++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index a0bf0d1..6c9616d 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -50,9 +50,17 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 	if (!nacl)
 		return 0;
 
-	deve = nacl->device_list[cmd->orig_fe_lun];
-	if (!atomic_read(&deve->ua_count))
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return 0;
+	}
+	if (!atomic_read(&deve->ua_count)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
 	/*
 	 * From sam4r14, section 5.14 Unit attention condition:
 	 *
@@ -103,9 +111,12 @@ int core_scsi3_ua_allocate(
 	ua->ua_asc = asc;
 	ua->ua_ascq = ascq;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[unpacked_lun];
-
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
 	spin_lock(&deve->ua_lock);
 	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_list) {
 		/*
@@ -113,7 +124,7 @@ int core_scsi3_ua_allocate(
 		 */
 		if ((ua_p->ua_asc == asc) && (ua_p->ua_ascq == ascq)) {
 			spin_unlock(&deve->ua_lock);
-			spin_unlock_irq(&nacl->device_list_lock);
+			rcu_read_unlock();
 			kmem_cache_free(se_ua_cache, ua);
 			return 0;
 		}
@@ -158,14 +169,13 @@ int core_scsi3_ua_allocate(
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
@@ -173,6 +183,7 @@ int core_scsi3_ua_allocate(
 		asc, ascq);
 
 	atomic_inc_mb(&deve->ua_count);
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -210,10 +221,14 @@ void core_scsi3_ua_for_check_condition(
 	if (!nacl)
 		return;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return;
+	}
 	if (!atomic_read(&deve->ua_count)) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return;
 	}
 	/*
@@ -249,7 +264,7 @@ void core_scsi3_ua_for_check_condition(
 		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	pr_debug("[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
@@ -278,10 +293,14 @@ int core_scsi3_ua_clear_for_request_sense(
 	if (!nacl)
 		return -EINVAL;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
 	if (!atomic_read(&deve->ua_count)) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -EPERM;
 	}
 	/*
@@ -307,7 +326,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
-- 
1.9.1

