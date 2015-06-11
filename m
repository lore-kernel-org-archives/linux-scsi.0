From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] target: Send UA when changing LUN inventory
Date: Thu, 11 Jun 2015 10:01:29 +0200
Message-ID: <1434009689-112909-7-git-send-email-hare@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbbFKIBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 04:01:35 -0400
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

When changind the LUN inventory via core_enable_device_list_for_node()
or core_disable_device_list_for_node() a REPORTED LUNS DATA HAS CHANGED
UA should be send.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_device.c | 26 +++++++++++++++++++++++++-
 drivers/target/target_core_ua.h     |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 650613e..ac191a9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -305,7 +305,7 @@ int core_enable_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
-	struct se_dev_entry *orig, *new;
+	struct se_dev_entry *orig, *new, *tmp;
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new) {
@@ -360,6 +360,15 @@ int core_enable_device_list_for_node(
 		kref_put(&orig->pr_kref, target_pr_kref_release);
 		wait_for_completion(&orig->pr_comp);
 
+		rcu_read_lock();
+		hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
+			if (tmp == new)
+				continue;
+			core_scsi3_ua_allocate(tmp, 0x3F,
+				ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
+		}
+		rcu_read_unlock();
+
 		kfree_rcu(orig, rcu_head);
 		return 0;
 	}
@@ -373,6 +382,14 @@ int core_enable_device_list_for_node(
 	list_add_tail(&new->lun_link, &lun->lun_deve_list);
 	spin_unlock_bh(&lun->lun_deve_lock);
 
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
+		if (tmp == new)
+			continue;
+		core_scsi3_ua_allocate(tmp, 0x3F,
+			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
+	}
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -385,6 +402,7 @@ void core_disable_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
+	struct se_dev_entry *tmp;
 	/*
 	 * rcu_dereference_raw protected by se_lun->lun_group symlink
 	 * reference to se_device->dev_group.
@@ -428,6 +446,12 @@ void core_disable_device_list_for_node(
 	kfree_rcu(orig, rcu_head);
 
 	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link)
+		core_scsi3_ua_allocate(tmp, 0x3F,
+			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
+	rcu_read_unlock();
 }
 
 /*      core_clear_lun_from_tpg():
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 948ae1e..45e3b6d 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -26,6 +26,7 @@
 #define ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS		0x09
 
 #define ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED			0x03
+#define ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED			0x0E
 
 extern struct kmem_cache *se_ua_cache;
 
-- 
1.8.5.2

