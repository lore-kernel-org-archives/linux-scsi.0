From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev RCU usage
Date: Fri, 22 May 2015 07:06:55 +0000
Message-ID: <1432278417-29994-3-git-send-email-nab@daterainc.com>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432278417-29994-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With se_port and t10_alua_tg_pt_gp_member being absored into se_lun,
there is no need for an extra lock to protect se_lun->lun_se_dev
assignment.

Also, convert se_lun->lun_stats to use atomic_long_t within the
target_complete_ok_work() completion callback.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |  1 -
 drivers/target/target_core_stat.c      | 65 +++++++++++++++++-----------------
 drivers/target/target_core_tpg.c       |  8 ++---
 drivers/target/target_core_transport.c | 22 ++++--------
 include/target/target_core_base.h      |  9 +++--
 5 files changed, 46 insertions(+), 59 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 31133ce..1d98033 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -792,7 +792,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	xcopy_lun = &dev->xcopy_lun;
 	xcopy_lun->lun_se_dev = dev;
-	spin_lock_init(&xcopy_lun->lun_sep_lock);
 	init_completion(&xcopy_lun->lun_ref_comp);
 	INIT_LIST_HEAD(&xcopy_lun->lun_deve_list);
 	INIT_LIST_HEAD(&xcopy_lun->lun_dev_link);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 5127c67..d38a18e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -545,11 +545,11 @@ static ssize_t target_stat_scsi_port_show_attr_inst(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(inst);
@@ -561,11 +561,11 @@ static ssize_t target_stat_scsi_port_show_attr_dev(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(dev);
@@ -576,10 +576,10 @@ static ssize_t target_stat_scsi_port_show_attr_indx(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	if (lun->lun_se_dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(indx);
@@ -591,13 +591,13 @@ static ssize_t target_stat_scsi_port_show_attr_role(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev) {
 		ret = snprintf(page, PAGE_SIZE, "%s%u\n", "Device",
 				dev->dev_index);
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(role);
@@ -608,12 +608,12 @@ static ssize_t target_stat_scsi_port_show_attr_busy_count(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	if (lun->lun_se_dev) {
 		/* FIXME: scsiPortBusyStatuses  */
 		ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(busy_count);
@@ -664,11 +664,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_inst(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(inst);
@@ -680,11 +680,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_dev(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(dev);
@@ -695,10 +695,10 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_indx(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	if (lun->lun_se_dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(indx);
@@ -709,13 +709,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_name(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	if (lun->lun_se_dev) {
 		ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
 			lun->lun_tpg->se_tpg_tfo->get_fabric_name(),
 			lun->lun_rtpi);
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(name);
@@ -738,9 +738,10 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_in_cmds(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", lun->lun_stats.cmd_pdus);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_lock();
+	ret = snprintf(page, PAGE_SIZE, "%lu\n",
+		       atomic_long_read(&lun->lun_stats.cmd_pdus));
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -752,10 +753,10 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_write_mbytes(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(lun->lun_stats.rx_data_octets >> 20));
-	spin_unlock(&lun->lun_sep_lock);
+			(u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(write_mbytes);
@@ -766,10 +767,10 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_read_mbytes(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(lun->lun_stats.tx_data_octets >> 20));
-	spin_unlock(&lun->lun_sep_lock);
+			(u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(read_mbytes);
@@ -834,11 +835,11 @@ static ssize_t target_stat_scsi_transport_show_attr_inst(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(inst);
@@ -874,10 +875,10 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 	struct t10_wwn *wwn;
 	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (!dev) {
-		spin_unlock(&lun->lun_sep_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	wwn = &dev->t10_wwn;
@@ -886,7 +887,7 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 			(strlen(wwn->unit_serial)) ? wwn->unit_serial :
 			wwn->vendor);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(dev_name);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 8764f1c..f60b74e 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -601,7 +601,6 @@ struct se_lun *core_tpg_alloc_lun(
 	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
-	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 	INIT_LIST_HEAD(&lun->lun_deve_list);
 	INIT_LIST_HEAD(&lun->lun_dev_link);
@@ -638,10 +637,7 @@ int core_tpg_add_lun(
 		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
 
 	mutex_lock(&tpg->tpg_lun_mutex);
-
-	spin_lock(&lun->lun_sep_lock);
-	lun->lun_se_dev = dev;
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_assign_pointer(lun->lun_se_dev, dev);
 
 	spin_lock(&dev->se_port_lock);
 	dev->export_count++;
@@ -683,7 +679,7 @@ void core_tpg_remove_lun(
 		dev->export_count--;
 		spin_unlock(&dev->se_port_lock);
 
-		lun->lun_se_dev = NULL;
+		rcu_assign_pointer(lun->lun_se_dev, NULL);
 	}
 
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1f9688a..2ccaeff 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1261,10 +1261,7 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 		return ret;
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-
-	spin_lock(&cmd->se_lun->lun_sep_lock);
-	cmd->se_lun->lun_stats.cmd_pdus++;
-	spin_unlock(&cmd->se_lun->lun_sep_lock);
+	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
 	return 0;
 }
 EXPORT_SYMBOL(target_setup_cmd_from_cdb);
@@ -2061,10 +2058,8 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
-		spin_lock(&cmd->se_lun->lun_sep_lock);
-		cmd->se_lun->lun_stats.tx_data_octets +=
-					cmd->data_length;
-		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		atomic_long_add(cmd->data_length,
+				&cmd->se_lun->lun_stats.tx_data_octets);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
 		 * backend had PI enabled, if the transport will not be
@@ -2087,17 +2082,14 @@ queue_rsp:
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
-		spin_lock(&cmd->se_lun->lun_sep_lock);
-		cmd->se_lun->lun_stats.rx_data_octets += cmd->data_length;
-		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		atomic_long_add(cmd->data_length,
+				&cmd->se_lun->lun_stats.rx_data_octets);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
-			spin_lock(&cmd->se_lun->lun_sep_lock);
-			cmd->se_lun->lun_stats.tx_data_octets +=
-				cmd->data_length;
-			spin_unlock(&cmd->se_lun->lun_sep_lock);
+			atomic_long_add(cmd->data_length,
+					&cmd->se_lun->lun_stats.tx_data_octets);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret == -EAGAIN || ret == -ENOMEM)
 				goto queue_full;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b3df83e..6cd1452 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -695,9 +695,9 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-       u64     cmd_pdus;
-       u64     tx_data_octets;
-       u64     rx_data_octets;
+	atomic_long_t	cmd_pdus;
+	atomic_long_t	tx_data_octets;
+	atomic_long_t	rx_data_octets;
 };
 
 struct se_lun {
@@ -711,8 +711,7 @@ struct se_lun {
 	u32			lun_flags;
 	u32			unpacked_lun;
 	atomic_t		lun_acl_count;
-	spinlock_t		lun_sep_lock;
-	struct se_device	*lun_se_dev;
+	struct se_device __rcu	*lun_se_dev;
 
 	struct list_head	lun_deve_list;
 	spinlock_t		lun_deve_lock;
-- 
1.9.1
