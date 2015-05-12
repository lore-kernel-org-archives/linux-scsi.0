From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 03/12] target/configfs: Convert mappedlun + SCSI MIBs to RCU reader
Date: Tue, 12 May 2015 09:25:27 +0000
Message-ID: <1431422736-29125-4-git-send-email-nab@daterainc.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts fabric independent configfs link/unlink to use
RCU read path macros for se_node_acl->lun_entry_hlist access.

It also converts SCSI MIB configfs show attribute code to use
RCU read path macros for se_node_acl->lun_entry_hlist access.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |  35 +++---
 drivers/target/target_core_stat.c            | 180 +++++++++++++--------------
 2 files changed, 110 insertions(+), 105 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 6cb4828..0dab6d5 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -123,16 +123,16 @@ static int target_fabric_mappedlun_link(
 	 * which be will write protected (READ-ONLY) when
 	 * tpg_1/attrib/demo_mode_write_protect=1
 	 */
-	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
-	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
+	rcu_read_lock();
+	deve = target_nacl_find_deve(lacl->se_lun_nacl, lacl->mapped_lun);
+	if (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
 		lun_access = deve->lun_flags;
 	else
 		lun_access =
 			(se_tpg->se_tpg_tfo->tpg_check_prod_mode_write_protect(
 				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
 					   TRANSPORT_LUNFLAGS_READ_WRITE;
-	spin_unlock_irq(&lacl->se_lun_nacl->device_list_lock);
+	rcu_read_unlock();
 	/*
 	 * Determine the actual mapped LUN value user wants..
 	 *
@@ -153,14 +153,18 @@ static int target_fabric_mappedlun_unlink(
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
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || !deve->se_lun) {
+		rcu_read_lock();
 		return 0;
-
+	}
+	rcu_read_unlock();
 	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
 	se_tpg = lun->lun_sep->sep_tpg;
 
@@ -181,14 +185,15 @@ static ssize_t target_fabric_mappedlun_show_write_protect(
 {
 	struct se_node_acl *se_nacl = lacl->se_lun_nacl;
 	struct se_dev_entry *deve;
-	ssize_t len;
-
-	spin_lock_irq(&se_nacl->device_list_lock);
-	deve = se_nacl->device_list[lacl->mapped_lun];
-	len = sprintf(page, "%d\n",
-			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
-			1 : 0);
-	spin_unlock_irq(&se_nacl->device_list_lock);
+	ssize_t len = 0;
+
+	rcu_read_lock();
+	deve = target_nacl_find_deve(se_nacl, lacl->mapped_lun);
+	if (deve) {
+		len = sprintf(page, "%d\n",
+			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ? 1 : 0);
+	}
+	rcu_read_unlock();
 
 	return len;
 }
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 64efee2..a268977 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1084,17 +1084,17 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_inst(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1109,16 +1109,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev(
 	struct se_lun *lun;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1133,16 +1133,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_port(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1156,15 +1156,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || !deve->se_lun || !deve->se_lun_acl) {
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
@@ -1178,15 +1178,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev_or_port(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || deve->se_lun || !deve->se_lun_acl) {
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
@@ -1200,15 +1200,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_intr_name(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1222,15 +1222,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_map_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1244,15 +1244,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_att_count(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1266,15 +1266,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_num_cmds(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1288,15 +1288,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_read_mbytes(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1310,15 +1310,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_write_mbytes(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1332,15 +1332,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_hs_num_cmds(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1354,16 +1354,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_creation_time(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1377,15 +1377,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_row_status(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
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
@@ -1450,17 +1450,17 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_inst(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || deve->se_lun || !deve->se_lun_acl) {
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
@@ -1475,16 +1475,16 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_dev(
 	struct se_lun *lun;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || deve->se_lun || !deve->se_lun_acl) {
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
@@ -1499,16 +1499,16 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || deve->se_lun || !deve->se_lun_acl) {
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
@@ -1548,15 +1548,15 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port_auth_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve || deve->se_lun || !deve->se_lun_acl) {
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
