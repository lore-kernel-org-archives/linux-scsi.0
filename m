From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev RCU usage
Date: Tue, 26 May 2015 06:57:23 +0000
Message-ID: <1432623445-25776-3-git-send-email-nab@daterainc.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33585 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbEZHAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2015 03:00:15 -0400
Received: by obbnx5 with SMTP id nx5so67462747obb.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2015 00:00:14 -0700 (PDT)
In-Reply-To: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

With se_port and t10_alua_tg_pt_gp_member being absored into se_lun,
there is no need for an extra lock to protect se_lun->lun_se_dev
assignment.

This patch also converts backend drivers to use call_rcu() release
to allow any se_device readers to complete.  The call_rcu() instead
of kfree_rcu() is required here because se_device is embedded into
the backend driver specific structure.

Also, convert se_lun->lun_stats to use atomic_long_t within the
target_complete_ok_work() completion callback.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      |   4 +-
 drivers/target/target_core_device.c    |  26 +++----
 drivers/target/target_core_file.c      |  11 ++-
 drivers/target/target_core_iblock.c    |  10 ++-
 drivers/target/target_core_pscsi.c     |  11 ++-
 drivers/target/target_core_rd.c        |  10 ++-
 drivers/target/target_core_spc.c       |   2 +-
 drivers/target/target_core_stat.c      | 123 +++++++++++++++++----------------
 drivers/target/target_core_tpg.c       |  11 +--
 drivers/target/target_core_transport.c |  20 ++----
 drivers/target/target_core_user.c      |  11 ++-
 include/target/target_core_base.h      |  10 +--
 12 files changed, 140 insertions(+), 109 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 93f78f2..314d230 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1934,7 +1934,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	size_t count)
 {
 	struct se_portal_group *tpg = lun->lun_tpg;
-	struct se_device *dev = lun->lun_se_dev;
+	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *tg_pt_gp_new = NULL;
 	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 	int move = 0;
@@ -2188,7 +2188,7 @@ ssize_t core_alua_store_offline_bit(
 	const char *page,
 	size_t count)
 {
-	struct se_device *dev = lun->lun_se_dev;
+	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
 	unsigned long tmp;
 	int ret;
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4f1040b..29d429c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -60,7 +60,6 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_node_acl *nacl = se_sess->se_node_acl;
-	struct se_device *dev;
 	struct se_dev_entry *deve;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
@@ -129,14 +128,15 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	}
 
 	/* Directly associate cmd with se_dev */
-	se_cmd->se_dev = se_lun->lun_se_dev;
+	se_cmd->se_dev = lockless_dereference(se_lun->lun_se_dev);
+	atomic_long_inc(&se_cmd->se_dev->num_cmds);
 
-	dev = se_lun->lun_se_dev;
-	atomic_long_inc(&dev->num_cmds);
 	if (se_cmd->data_direction == DMA_TO_DEVICE)
-		atomic_long_add(se_cmd->data_length, &dev->write_bytes);
+		atomic_long_add(se_cmd->data_length,
+				&se_cmd->se_dev->write_bytes);
 	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-		atomic_long_add(se_cmd->data_length, &dev->read_bytes);
+		atomic_long_add(se_cmd->data_length,
+				&se_cmd->se_dev->read_bytes);
 
 	return 0;
 }
@@ -174,8 +174,8 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	}
 
 	/* Directly associate cmd with se_dev */
-	se_cmd->se_dev = se_lun->lun_se_dev;
-	se_tmr->tmr_dev = se_lun->lun_se_dev;
+	se_cmd->se_dev = lockless_dereference(se_lun->lun_se_dev);
+	se_tmr->tmr_dev = lockless_dereference(se_lun->lun_se_dev);
 
 	spin_lock_irqsave(&se_tmr->tmr_dev->se_tmr_lock, flags);
 	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
@@ -386,6 +386,7 @@ void core_disable_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
+	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
 	 * lun->lun_deve_list must be removed now before clearing the
@@ -423,7 +424,7 @@ void core_disable_device_list_for_node(
 
 	kfree_rcu(orig, rcu_head);
 
-	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
+	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
 }
 
 /*      core_clear_lun_from_tpg():
@@ -625,6 +626,7 @@ int core_dev_add_initiator_node_lun_acl(
 	u32 lun_access)
 {
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
 
 	if (!nacl)
 		return -EINVAL;
@@ -648,7 +650,7 @@ int core_dev_add_initiator_node_lun_acl(
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
 	 */
-	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, nacl,
+	core_scsi3_check_aptpl_registration(dev, tpg, lun, nacl,
 					    lacl->mapped_lun);
 	return 0;
 }
@@ -742,6 +744,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
 	dev->prot_length = sizeof(struct se_dif_v1_tuple);
+	dev->hba_index = hba->hba_index;
 
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
@@ -798,8 +801,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 
 	xcopy_lun = &dev->xcopy_lun;
-	xcopy_lun->lun_se_dev = dev;
-	spin_lock_init(&xcopy_lun->lun_sep_lock);
+	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
 	init_completion(&xcopy_lun->lun_ref_comp);
 	INIT_LIST_HEAD(&xcopy_lun->lun_deve_list);
 	INIT_LIST_HEAD(&xcopy_lun->lun_dev_link);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 90e09ba..ac9cbf1 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -241,6 +241,14 @@ fail:
 	return ret;
 }
 
+static void fd_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct fd_dev *fd_dev = FD_DEV(dev);
+
+	kfree(fd_dev);
+}
+
 static void fd_free_device(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -249,8 +257,7 @@ static void fd_free_device(struct se_device *dev)
 		filp_close(fd_dev->fd_file, NULL);
 		fd_dev->fd_file = NULL;
 	}
-
-	kfree(fd_dev);
+	call_rcu(&dev->rcu_head, fd_dev_call_rcu);
 }
 
 static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index bd9dcd8..1a78e31 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -191,6 +191,14 @@ out:
 	return ret;
 }
 
+static void iblock_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+	kfree(ib_dev);
+}
+
 static void iblock_free_device(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -200,7 +208,7 @@ static void iblock_free_device(struct se_device *dev)
 	if (ib_dev->ibd_bio_set != NULL)
 		bioset_free(ib_dev->ibd_bio_set);
 
-	kfree(ib_dev);
+	call_rcu(&dev->rcu_head, iblock_dev_call_rcu);
 }
 
 static unsigned long long iblock_emulate_read_cap_with_block_size(
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5bc458e..c710ff0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -578,6 +578,14 @@ static int pscsi_configure_device(struct se_device *dev)
 	return -ENODEV;
 }
 
+static void pscsi_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
+
+	kfree(pdv);
+}
+
 static void pscsi_free_device(struct se_device *dev)
 {
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
@@ -607,8 +615,7 @@ static void pscsi_free_device(struct se_device *dev)
 
 		pdv->pdv_sd = NULL;
 	}
-
-	kfree(pdv);
+	call_rcu(&dev->rcu_head, pscsi_dev_call_rcu);
 }
 
 static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 5f84144..dd495b6 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -350,12 +350,20 @@ fail:
 	return ret;
 }
 
+static void rd_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct rd_dev *rd_dev = RD_DEV(dev);
+
+	kfree(rd_dev);
+}
+
 static void rd_free_device(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = RD_DEV(dev);
 
 	rd_release_device_space(rd_dev);
-	kfree(rd_dev);
+	call_rcu(&dev->rcu_head, rd_dev_call_rcu);
 }
 
 static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 34d8292..bcf5d8e 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -692,7 +692,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	if (dev == tpg->tpg_virt_lun0->lun_se_dev)
+	if (dev == lockless_dereference(tpg->tpg_virt_lun0->lun_se_dev))
 		buf[0] = 0x3f; /* Not connected */
 	else
 		buf[0] = dev->transport->get_device_type(dev);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 8e080ef..79c7852 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -545,11 +545,11 @@ static ssize_t target_stat_scsi_port_show_attr_inst(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->hba_index);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(inst);
@@ -561,11 +561,11 @@ static ssize_t target_stat_scsi_port_show_attr_dev(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(dev);
@@ -577,11 +577,11 @@ static ssize_t target_stat_scsi_port_show_attr_indx(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(indx);
@@ -593,11 +593,11 @@ static ssize_t target_stat_scsi_port_show_attr_role(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%s%u\n", "Device", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(role);
@@ -609,13 +609,13 @@ static ssize_t target_stat_scsi_port_show_attr_busy_count(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev) {
 		/* FIXME: scsiPortBusyStatuses  */
 		ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(busy_count);
@@ -666,11 +666,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_inst(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->hba_index);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(inst);
@@ -682,11 +682,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_dev(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(dev);
@@ -698,11 +698,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_indx(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(indx);
@@ -715,13 +715,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_name(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
 			tpg->se_tpg_tfo->get_fabric_name(),
 			lun->lun_rtpi);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(name);
@@ -734,13 +734,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_port_index(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%s%s%d\n",
 			tpg->se_tpg_tfo->tpg_get_wwn(tpg), "+t+",
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(port_index);
@@ -752,11 +752,12 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_in_cmds(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_stats.cmd_pdus);
-	spin_unlock(&lun->lun_sep_lock);
+		ret = snprintf(page, PAGE_SIZE, "%lu\n",
+			       atomic_long_read(&lun->lun_stats.cmd_pdus));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(in_cmds);
@@ -768,12 +769,12 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_write_mbytes(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n",
-				(u32)(lun->lun_stats.rx_data_octets >> 20));
-	spin_unlock(&lun->lun_sep_lock);
+			(u32)(atomic_long_read(&lun->lun_stats.rx_data_octets) >> 20));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(write_mbytes);
@@ -785,12 +786,12 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_read_mbytes(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n",
-				(u32)(lun->lun_stats.tx_data_octets >> 20));
-	spin_unlock(&lun->lun_sep_lock);
+				(u32)(atomic_long_read(&lun->lun_stats.tx_data_octets) >> 20));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(read_mbytes);
@@ -802,13 +803,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_hs_in_cmds(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev) {
 		/* FIXME: scsiTgtPortHsInCommands */
 		ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(hs_in_cmds);
@@ -865,11 +866,11 @@ static ssize_t target_stat_scsi_transport_show_attr_inst(
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->hba_index);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(inst);
@@ -882,14 +883,14 @@ static ssize_t target_stat_scsi_transport_show_attr_device(
 	struct se_portal_group *tpg = lun->lun_tpg;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev) {
 		/* scsiTransportType */
 		ret = snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
 			       tpg->se_tpg_tfo->get_fabric_name());
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(device);
@@ -902,12 +903,12 @@ static ssize_t target_stat_scsi_transport_show_attr_indx(
 	struct se_portal_group *tpg = lun->lun_tpg;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%u\n",
 			       tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(indx);
@@ -916,13 +917,13 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_device *dev = lun->lun_se_dev;
+	struct se_device *dev;
 	struct se_portal_group *tpg = lun->lun_tpg;
 	struct t10_wwn *wwn;
 	ssize_t ret = -ENODEV;
 
-	spin_lock(&lun->lun_sep_lock);
-	dev = lun->lun_se_dev;
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev) {
 		wwn = &dev->t10_wwn;
 		/* scsiTransportDevName */
@@ -931,7 +932,7 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 				(strlen(wwn->unit_serial)) ? wwn->unit_serial :
 				wwn->vendor);
 	}
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(dev_name);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 9cee8fe..5b9a229 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -102,7 +102,7 @@ void core_tpg_add_node_to_devs(
 		if (lun_orig && lun != lun_orig)
 			continue;
 
-		dev = lun->lun_se_dev;
+		dev = lockless_dereference(lun->lun_se_dev);
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
 		 * demo_mode_write_protect is ON, or READ_ONLY;
@@ -598,7 +598,6 @@ struct se_lun *core_tpg_alloc_lun(
 	lun->unpacked_lun = unpacked_lun;
 	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
 	atomic_set(&lun->lun_acl_count, 0);
-	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 	INIT_LIST_HEAD(&lun->lun_deve_list);
 	INIT_LIST_HEAD(&lun->lun_dev_link);
@@ -636,12 +635,8 @@ int core_tpg_add_lun(
 
 	mutex_lock(&tpg->tpg_lun_mutex);
 
-	spin_lock(&lun->lun_sep_lock);
-	lun->lun_index = dev->dev_index;
-	lun->lun_se_dev = dev;
-	spin_unlock(&lun->lun_sep_lock);
-
 	spin_lock(&dev->se_port_lock);
+	lun->lun_index = dev->dev_index;
 	rcu_assign_pointer(lun->lun_se_dev, dev);
 	dev->export_count++;
 	list_add_tail(&lun->lun_dev_link, &dev->dev_sep_list);
@@ -664,7 +659,7 @@ void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	struct se_device *dev = lun->lun_se_dev;
+	struct se_device *dev = lockless_dereference(lun->lun_se_dev);
 
 	core_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5dccf74..2ccaeff 100644
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
@@ -2061,9 +2058,8 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
-		spin_lock(&cmd->se_lun->lun_sep_lock);
-		cmd->se_lun->lun_stats.tx_data_octets += cmd->data_length;
-		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		atomic_long_add(cmd->data_length,
+				&cmd->se_lun->lun_stats.tx_data_octets);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
 		 * backend had PI enabled, if the transport will not be
@@ -2086,16 +2082,14 @@ queue_rsp:
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
-			cmd->se_lun->lun_stats.tx_data_octets += cmd->data_length;
-			spin_unlock(&cmd->se_lun->lun_sep_lock);
+			atomic_long_add(cmd->data_length,
+					&cmd->se_lun->lun_stats.tx_data_octets);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret == -EAGAIN || ret == -ENOMEM)
 				goto queue_full;
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index d59df02..6742e53 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -960,6 +960,14 @@ static int tcmu_check_pending_cmd(int id, void *p, void *data)
 	return -EINVAL;
 }
 
+static void tcmu_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	kfree(udev);
+}
+
 static void tcmu_free_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
@@ -985,8 +993,7 @@ static void tcmu_free_device(struct se_device *dev)
 		kfree(udev->uio_info.name);
 		kfree(udev->name);
 	}
-
-	kfree(udev);
+	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
 
 enum {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1927dd5..b82a989 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -690,9 +690,9 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-	u32		cmd_pdus;
-	u64		tx_data_octets;
-	u64		rx_data_octets;
+	atomic_long_t	cmd_pdus;
+	atomic_long_t	tx_data_octets;
+	atomic_long_t	rx_data_octets;
 };
 
 struct se_lun {
@@ -705,7 +705,6 @@ struct se_lun {
 	u32			unpacked_lun;
 	u32			lun_index;
 	atomic_t		lun_acl_count;
-	spinlock_t		lun_sep_lock;
 	struct se_device __rcu	*lun_se_dev;
 
 	struct list_head	lun_deve_list;
@@ -818,6 +817,9 @@ struct se_device {
 	struct se_lun		xcopy_lun;
 	/* Protection Information */
 	int			prot_length;
+	/* For se_lun->lun_se_dev RCU read-side critical access */
+	u32			hba_index;
+	struct rcu_head		rcu_head;
 };
 
 struct se_hba {
-- 
1.9.1

