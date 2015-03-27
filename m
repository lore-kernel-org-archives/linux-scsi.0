From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 04/22] target/configfs: Convert mappedlun link/unlink to RCU reader
Date: Fri, 27 Mar 2015 08:04:54 +0000
Message-ID: <1427443512-8925-5-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33629 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbbC0IGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:06 -0400
Received: by oifl3 with SMTP id l3so70046342oif.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:06 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts fabric independent configfs link/unlink to use
RCU read path macros for se_node_acl->lun_entry_hlist[] access.

Also, update show_write_protect attribute access as well.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c | 29 ++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0c3f901..86ad50d 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -111,8 +111,8 @@ static int target_fabric_mappedlun_link(
 	 * which be will write protected (READ-ONLY) when
 	 * tpg_1/attrib/demo_mode_write_protect=1
 	 */
-	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
-	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(lacl->se_lun_nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
 		lun_access = deve->lun_flags;
 	else
@@ -120,7 +120,7 @@ static int target_fabric_mappedlun_link(
 			(se_tpg->se_tpg_tfo->tpg_check_prod_mode_write_protect(
 				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
 					   TRANSPORT_LUNFLAGS_READ_WRITE;
-	spin_unlock_irq(&lacl->se_lun_nacl->device_list_lock);
+	rcu_read_unlock();
 	/*
 	 * Determine the actual mapped LUN value user wants..
 	 *
@@ -141,14 +141,18 @@ static int target_fabric_mappedlun_unlink(
 	struct se_lun_acl *lacl = container_of(to_config_group(lun_acl_ci),
 			struct se_lun_acl, se_lun_group);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry *deve = nacl->device_list[lacl->mapped_lun];
+	struct se_dev_entry *deve;
 	struct se_portal_group *se_tpg;
 	/*
 	 * Determine if the underlying MappedLUN has already been released..
 	 */
-	if (!deve->se_lun)
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun) {
+		rcu_read_lock();
 		return 0;
-
+	}
+	rcu_read_unlock();
 	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
 	se_tpg = lun->lun_sep->sep_tpg;
 
@@ -171,12 +175,13 @@ static ssize_t target_fabric_mappedlun_show_write_protect(
 	struct se_dev_entry *deve;
 	ssize_t len;
 
-	spin_lock_irq(&se_nacl->device_list_lock);
-	deve = se_nacl->device_list[lacl->mapped_lun];
-	len = sprintf(page, "%d\n",
-			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
-			1 : 0);
-	spin_unlock_irq(&se_nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(se_nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (deve) {
+		len = sprintf(page, "%d\n",
+			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ? 1 : 0);
+	}
+	rcu_read_unlock();
 
 	return len;
 }
-- 
1.9.1

