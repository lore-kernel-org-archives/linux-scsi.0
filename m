From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 05/22] target/configfs: Convert SCSI MIB attrs to RCU reader
Date: Fri, 27 Mar 2015 08:04:55 +0000
Message-ID: <1427443512-8925-6-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33646 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbC0IGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:08 -0400
Received: by oifl3 with SMTP id l3so70046776oif.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:07 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts SCSI MIB configfs show attribute code to use
RCU read path macros for se_node_acl->lun_entry_hlist[] access.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_stat.c | 168 +++++++++++++++++++-------------------
 1 file changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 0353899..d09787b 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1085,17 +1085,17 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_inst(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiInstIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
 			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(inst);
@@ -1110,16 +1110,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev(
 	struct se_lun *lun;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	lun = deve->se_lun;
 	/* scsiDeviceIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_se_dev->dev_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(dev);
@@ -1134,16 +1134,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_port(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiAuthIntrTgtPortIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(port);
@@ -1157,15 +1157,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", nacl->acl_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(indx);
@@ -1179,15 +1179,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev_or_port(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrDevOrPort */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", 1);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(dev_or_port);
@@ -1201,15 +1201,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_intr_name(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrName */
 	ret = snprintf(page, PAGE_SIZE, "%s\n", nacl->initiatorname);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(intr_name);
@@ -1223,15 +1223,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_map_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* FIXME: scsiAuthIntrLunMapIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(map_indx);
@@ -1245,15 +1245,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_att_count(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrAttachedTimes */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->attach_count);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(att_count);
@@ -1267,15 +1267,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_num_cmds(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrOutCommands */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->total_cmds);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(num_cmds);
@@ -1289,15 +1289,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_read_mbytes(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrReadMegaBytes */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(deve->read_bytes >> 20));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(read_mbytes);
@@ -1311,15 +1311,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_write_mbytes(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrWrittenMegaBytes */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(deve->write_bytes >> 20));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(write_mbytes);
@@ -1333,15 +1333,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_hs_num_cmds(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* FIXME: scsiAuthIntrHSOutCommands */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(hs_num_cmds);
@@ -1355,16 +1355,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_creation_time(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrLastCreation */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(((u32)deve->creation_time -
 				INITIAL_JIFFIES) * 100 / HZ));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(creation_time);
@@ -1378,15 +1378,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_row_status(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
+	if (!deve || deve->se_lun || !deve->se_lun_acl) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* FIXME: scsiAuthIntrRowStatus */
 	ret = snprintf(page, PAGE_SIZE, "Ready\n");
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(row_status);
@@ -1451,17 +1451,17 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_inst(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiInstIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
 			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(inst);
@@ -1476,16 +1476,16 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_dev(
 	struct se_lun *lun;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	lun = deve->se_lun;
 	/* scsiDeviceIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_se_dev->dev_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(dev);
@@ -1500,16 +1500,16 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiPortIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port);
@@ -1549,15 +1549,15 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port_auth_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
+	rcu_read_lock();
+	deve = rcu_dereference(nacl->lun_entry_hlist[lacl->mapped_lun]);
 	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAttIntrPortAuthIntrIdx */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", nacl->acl_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port_auth_indx);
-- 
1.9.1

