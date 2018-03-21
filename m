From: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
Subject: [PATCH 1/1] target:separate tx/rx cmd_puds
Date: Wed, 21 Mar 2018 17:52:43 +0800
Message-ID: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

Separate tx/rx cmd_pdus in order to distinguish LUN read/write IOPS.

Signed-off-by: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
---
 drivers/target/target_core_stat.c      | 26 ++++++++++++++++++++++----
 drivers/target/target_core_transport.c | 11 ++++++++++-
 include/target/target_core_base.h      |  3 ++-
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index f0db91e..9099494 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -636,7 +636,7 @@ static ssize_t target_stat_tgt_port_port_index_show(struct config_item *item,
 	return ret;
 }
 
-static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
+static ssize_t target_stat_tgt_port_tx_cmds_show(struct config_item *item,
 		char *page)
 {
 	struct se_lun *lun = to_stat_tgt_port(item);
@@ -647,7 +647,23 @@ static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%lu\n",
-			       atomic_long_read(&lun->lun_stats.cmd_pdus));
+			       atomic_long_read(&lun->lun_stats.tx_cmd_pdus));
+	rcu_read_unlock();
+	return ret;
+}
+
+static ssize_t target_stat_tgt_port_rx_cmds_show(struct config_item *item,
+		char *page)
+{
+	struct se_lun *lun = to_stat_tgt_port(item);
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
+
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%lu\n",
+			       atomic_long_read(&lun->lun_stats.rx_cmd_pdus));
 	rcu_read_unlock();
 	return ret;
 }
@@ -706,7 +722,8 @@ static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *item,
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, indx);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, name);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, port_index);
-CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
+CONFIGFS_ATTR_RO(target_stat_tgt_port_, tx_cmds);
+CONFIGFS_ATTR_RO(target_stat_tgt_port_, rx_cmds);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, write_mbytes);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, read_mbytes);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, hs_in_cmds);
@@ -717,7 +734,8 @@ static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *item,
 	&target_stat_tgt_port_attr_indx,
 	&target_stat_tgt_port_attr_name,
 	&target_stat_tgt_port_attr_port_index,
-	&target_stat_tgt_port_attr_in_cmds,
+	&target_stat_tgt_port_attr_tx_cmds,
+	&target_stat_tgt_port_attr_rx_cmds,
 	&target_stat_tgt_port_attr_write_mbytes,
 	&target_stat_tgt_port_attr_read_mbytes,
 	&target_stat_tgt_port_attr_hs_in_cmds,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 74b646f..79cb96f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1356,7 +1356,16 @@ void transport_init_se_cmd(
 		return ret;
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
+	switch (cmd->data_direction) {
+	case DMA_FROM_DEVICE:
+		atomic_long_inc(&cmd->se_lun->lun_stats.tx_cmd_pdus);
+		break;
+	case DMA_TO_DEVICE:
+		atomic_long_inc(&cmd->se_lun->lun_stats.rx_cmd_pdus);
+		break;
+	default:
+		break;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(target_setup_cmd_from_cdb);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9f9f590..6a0a2a7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -698,7 +698,8 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-	atomic_long_t	cmd_pdus;
+	atomic_long_t	tx_cmd_pdus;
+	atomic_long_t	rx_cmd_pdus;
 	atomic_long_t	tx_data_octets;
 	atomic_long_t	rx_data_octets;
 };
-- 
1.8.3.1
