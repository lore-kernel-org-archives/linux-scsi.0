From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
 RCU hlist
Date: Mon, 18 May 2015 00:17:24 -0700
Message-ID: <1431933444.24645.7.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-2-git-send-email-nab@daterainc.com>
	 <20150513063555.GA21770@lst.de>
	 <1431506771.26897.78.camel@haakon3.risingtidesystems.com>
	 <20150517165142.GA17217@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150517165142.GA17217@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2015-05-17 at 18:51 +0200, Christoph Hellwig wrote:
> On Wed, May 13, 2015 at 01:46:11AM -0700, Nicholas A. Bellinger wrote:
> > Updated to use a mirror lun->lun_rtpi, with the assignment from sep_rtpi
> > occuring in core_dev_export() code.
> 
> From looking at your current tree I suspect freeing the se_port structure
> using kfree_rcu might be a better idea.  Together with dropping the references
> to the se_device from call_rcu context this basically means all pointers
> in struct se_lun are rcu protected which is much safer if you want
> to access struct se_lun under rcu protection, as this avoids having to
> deal with special cases.  Additionally that basically allows you to
> replace lun_sep_lock with rcu_read_lock for anything remotely like
> a fast path.

Here's a first pass at this along with kref + completion conversion for
the special case PR ALL_TGT_PT=1 pointer dereference.

Thanks HCH.

>From 3a6e7fffe13050a0d8cb0c668e122e16e0a8b17d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sun, 17 May 2015 23:00:31 -0700
Subject: [PATCH] target: Convert se_lun->lun_sep updater + readers to RCU

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |  51 +++----
 drivers/target/target_core_internal.h  |   1 +
 drivers/target/target_core_pr.c        |   8 +-
 drivers/target/target_core_stat.c      | 268 ++++++++++-----------------------
 drivers/target/target_core_transport.c |  48 +++---
 include/target/target_core_base.h      |   4 +-
 6 files changed, 135 insertions(+), 245 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2f4c8fa..88dad15 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -452,6 +452,8 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 	spin_lock_init(&port->sep_alua_lock);
 	mutex_init(&port->sep_tg_pt_md_mutex);
+	kref_init(&port->sep_tg_pt_ref);
+	init_completion(&port->sep_tg_pt_comp);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
@@ -502,7 +504,7 @@ static void core_export_port(
 	spin_lock(&lun->lun_sep_lock);
 	port->sep_tpg = tpg;
 	port->sep_lun = lun;
-	lun->lun_sep = port;
+	rcu_assign_pointer(lun->lun_sep, port);
 	spin_unlock(&lun->lun_sep_lock);
 
 	list_add_tail(&port->sep_list, &dev->dev_sep_list);
@@ -529,28 +531,6 @@ static void core_export_port(
 	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFIER */
 }
 
-/*
- *	Called with struct se_device->se_port_lock spinlock held.
- */
-static void core_release_port(struct se_device *dev, struct se_port *port)
-	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
-{
-	/*
-	 * Wait for any port reference for PR ALL_TG_PT=1 operation
-	 * to complete in __core_scsi3_alloc_registration()
-	 */
-	spin_unlock(&dev->se_port_lock);
-	if (atomic_read(&port->sep_tg_pt_ref_cnt))
-		cpu_relax();
-	spin_lock(&dev->se_port_lock);
-
-	core_alua_free_tg_pt_gp_mem(port);
-
-	list_del(&port->sep_list);
-	dev->dev_port_count--;
-	kfree(port);
-}
-
 int core_dev_export(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
@@ -574,31 +554,46 @@ int core_dev_export(
 	return 0;
 }
 
+void target_port_kref_release(struct kref *kref)
+{
+	struct se_port *port = container_of(kref, struct se_port, sep_tg_pt_ref);
+
+	complete(&port->sep_tg_pt_comp);
+}
+
 void core_dev_unexport(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
 	struct se_hba *hba = dev->se_hba;
-	struct se_port *port = lun->lun_sep;
+	struct se_port *port;
 
 	spin_lock(&lun->lun_sep_lock);
-	if (lun->lun_se_dev == NULL) {
+	port = lun->lun_sep;
+	if (!port) {
 		spin_unlock(&lun->lun_sep_lock);
 		return;
 	}
+	rcu_assign_pointer(lun->lun_sep, NULL);
+	lun->lun_se_dev = NULL;
 	spin_unlock(&lun->lun_sep_lock);
 
+	kref_put(&port->sep_tg_pt_ref, target_port_kref_release);
+	wait_for_completion(&port->sep_tg_pt_comp);
+
+	core_alua_free_tg_pt_gp_mem(port);
+
 	spin_lock(&dev->se_port_lock);
-	core_release_port(dev, port);
+	list_del(&port->sep_list);
+	dev->dev_port_count--;
 	spin_unlock(&dev->se_port_lock);
 
 	spin_lock(&hba->device_lock);
 	dev->export_count--;
 	spin_unlock(&hba->device_lock);
 
-	lun->lun_sep = NULL;
-	lun->lun_se_dev = NULL;
+	kfree_rcu(port, sep_rcu);
 }
 
 static void se_release_vpd_for_dev(struct se_device *dev)
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index beb1c3e..21e5f9e 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -23,6 +23,7 @@ extern struct list_head g_device_list;
 
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
 void	target_pr_kref_release(struct kref *);
+void	target_port_kref_release(struct kref *);
 void	core_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
 void	core_update_device_list_access(u32, u32, struct se_node_acl *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index cee2b31..c53b66c 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -702,7 +702,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 */
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
-		atomic_inc_mb(&port->sep_tg_pt_ref_cnt);
+		kref_get(&port->sep_tg_pt_ref);
 		spin_unlock(&dev->se_port_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -748,7 +748,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (ret < 0) {
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
-				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
+				kref_put(&port->sep_tg_pt_ref, target_port_kref_release);
 				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
 			}
@@ -764,7 +764,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						deve_tmp, deve_tmp->mapped_lun,
 						NULL, sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
-				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
+				kref_put(&port->sep_tg_pt_ref, target_port_kref_release);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -776,7 +776,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 		spin_unlock_bh(&port->sep_alua_lock);
 
 		spin_lock(&dev->se_port_lock);
-		atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
+		kref_put(&port->sep_tg_pt_ref, target_port_kref_release);
 	}
 	spin_unlock(&dev->se_port_lock);
 
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 7b7b524..7af692c 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -542,21 +542,9 @@ static ssize_t target_stat_scsi_port_show_attr_inst(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
 	struct se_device *dev = lun->lun_se_dev;
-	struct se_hba *hba;
-	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	hba = dev->se_hba;
-	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(inst);
 
@@ -564,19 +552,9 @@ static ssize_t target_stat_scsi_port_show_attr_dev(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
 	struct se_device *dev = lun->lun_se_dev;
-	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(dev);
 
@@ -587,14 +565,15 @@ static ssize_t target_stat_scsi_port_show_attr_indx(
 	struct se_port *sep;
 	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
 	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
+
 	return ret;
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(indx);
@@ -604,41 +583,16 @@ static ssize_t target_stat_scsi_port_show_attr_role(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	ssize_t ret;
 
-	if (!dev)
-		return -ENODEV;
-
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%s%u\n", "Device", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%s%u\n", "Device", dev->dev_index);
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(role);
 
 static ssize_t target_stat_scsi_port_show_attr_busy_count(
 	struct se_port_stat_grps *pgrps, char *page)
 {
-	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	ssize_t ret;
-
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
 	/* FIXME: scsiPortBusyStatuses  */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", 0);
 }
 DEV_STAT_SCSI_PORT_ATTR_RO(busy_count);
 
@@ -686,20 +640,8 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_inst(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	struct se_hba *hba;
-	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	hba = dev->se_hba;
-	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(inst);
 
@@ -708,18 +650,8 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_dev(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(dev);
 
@@ -728,16 +660,14 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_indx(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
-	spin_unlock(&lun->lun_sep_lock);
+	if (sep)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
+	rcu_read_unlock();
+
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(indx);
@@ -748,19 +678,17 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_name(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
 	struct se_portal_group *tpg;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (sep) {
+		tpg = sep->sep_tpg;
+		ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
+			tpg->se_tpg_tfo->get_fabric_name(), sep->sep_index);
 	}
-	tpg = sep->sep_tpg;
+	rcu_read_unlock();
 
-	ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
-		tpg->se_tpg_tfo->get_fabric_name(), sep->sep_index);
-	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(name);
@@ -771,20 +699,18 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_port_index(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
 	struct se_portal_group *tpg;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (sep) {
+		tpg = sep->sep_tpg;
+		ret = snprintf(page, PAGE_SIZE, "%s%s%d\n",
+			tpg->se_tpg_tfo->tpg_get_wwn(tpg), "+t+",
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 	}
-	tpg = sep->sep_tpg;
+	rcu_read_unlock();
 
-	ret = snprintf(page, PAGE_SIZE, "%s%s%d\n",
-		tpg->se_tpg_tfo->tpg_get_wwn(tpg), "+t+",
-		tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(port_index);
@@ -794,17 +720,14 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_in_cmds(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
+	if (sep)
+		ret = snprintf(page, PAGE_SIZE, "%llu\n", sep->sep_stats.cmd_pdus);
+	rcu_read_unlock();
 
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", sep->sep_stats.cmd_pdus);
-	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(in_cmds);
@@ -814,18 +737,15 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_write_mbytes(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
+	if (sep)
+		ret = snprintf(page, PAGE_SIZE, "%u\n",
+				(u32)(sep->sep_stats.rx_data_octets >> 20));
+	rcu_read_unlock();
 
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(sep->sep_stats.rx_data_octets >> 20));
-	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(write_mbytes);
@@ -837,16 +757,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_read_mbytes(
 	struct se_port *sep;
 	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
+	if (sep)
+		ret = snprintf(page, PAGE_SIZE, "%u\n",
+				(u32)(sep->sep_stats.tx_data_octets >> 20));
+	rcu_read_unlock();
 
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(sep->sep_stats.tx_data_octets >> 20));
-	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(read_mbytes);
@@ -854,21 +771,8 @@ DEV_STAT_SCSI_TGT_PORT_ATTR_RO(read_mbytes);
 static ssize_t target_stat_scsi_tgt_port_show_attr_hs_in_cmds(
 	struct se_port_stat_grps *pgrps, char *page)
 {
-	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	ssize_t ret;
-
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-
 	/* FIXME: scsiTgtPortHsInCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", 0);
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(hs_in_cmds);
 
@@ -922,21 +826,8 @@ static ssize_t target_stat_scsi_transport_show_attr_inst(
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	struct se_hba *hba;
-	ssize_t ret;
-
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
 
-	hba = dev->se_hba;
-	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(inst);
 
@@ -946,19 +837,18 @@ static ssize_t target_stat_scsi_transport_show_attr_device(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
 	struct se_portal_group *tpg;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (sep) {
+		tpg = sep->sep_tpg;
+		/* scsiTransportType */
+		ret = snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
+				tpg->se_tpg_tfo->get_fabric_name());
 	}
-	tpg = sep->sep_tpg;
-	/* scsiTransportType */
-	ret = snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
-			tpg->se_tpg_tfo->get_fabric_name());
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
+
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(device);
@@ -969,18 +859,17 @@ static ssize_t target_stat_scsi_transport_show_attr_indx(
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
 	struct se_port *sep;
 	struct se_portal_group *tpg;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (sep) {
+		tpg = sep->sep_tpg;
+		ret = snprintf(page, PAGE_SIZE, "%u\n",
+				tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
 	}
-	tpg = sep->sep_tpg;
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
+
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(indx);
@@ -993,22 +882,21 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 	struct se_port *sep;
 	struct se_portal_group *tpg;
 	struct t10_wwn *wwn;
-	ssize_t ret;
+	ssize_t ret = 0;
 
-	spin_lock(&lun->lun_sep_lock);
+	rcu_read_lock();
 	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (sep) {
+		tpg = sep->sep_tpg;
+		wwn = &dev->t10_wwn;
+		/* scsiTransportDevName */
+		ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
+				tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+				(strlen(wwn->unit_serial)) ? wwn->unit_serial :
+				wwn->vendor);
 	}
-	tpg = sep->sep_tpg;
-	wwn = &dev->t10_wwn;
-	/* scsiTransportDevName */
-	ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
-			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-			(strlen(wwn->unit_serial)) ? wwn->unit_serial :
-			wwn->vendor);
-	spin_unlock(&lun->lun_sep_lock);
+	rcu_read_unlock();
+
 	return ret;
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(dev_name);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2b9f41a..0de29d8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1213,6 +1213,7 @@ sense_reason_t
 target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	struct se_device *dev = cmd->se_dev;
+	struct se_port *sep;
 	sense_reason_t ret;
 
 	/*
@@ -1276,10 +1277,12 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
 
-	spin_lock(&cmd->se_lun->lun_sep_lock);
-	if (cmd->se_lun->lun_sep)
-		cmd->se_lun->lun_sep->sep_stats.cmd_pdus++;
-	spin_unlock(&cmd->se_lun->lun_sep_lock);
+	rcu_read_lock();
+	sep = cmd->se_lun->lun_sep;
+	if (sep)
+		sep->sep_stats.cmd_pdus++;
+	rcu_read_unlock();
+
 	return 0;
 }
 EXPORT_SYMBOL(target_setup_cmd_from_cdb);
@@ -2016,6 +2019,7 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 static void target_complete_ok_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
+	struct se_port *sep;
 	int ret;
 
 	/*
@@ -2076,12 +2080,12 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
-		spin_lock(&cmd->se_lun->lun_sep_lock);
-		if (cmd->se_lun->lun_sep) {
-			cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
-					cmd->data_length;
-		}
-		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		rcu_read_lock();
+		sep = cmd->se_lun->lun_sep;
+		if (sep)
+			sep->sep_stats.tx_data_octets += cmd->data_length;
+		rcu_read_unlock();
+
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
 		 * backend had PI enabled, if the transport will not be
@@ -2104,22 +2108,22 @@ queue_rsp:
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
-		spin_lock(&cmd->se_lun->lun_sep_lock);
-		if (cmd->se_lun->lun_sep) {
-			cmd->se_lun->lun_sep->sep_stats.rx_data_octets +=
-				cmd->data_length;
-		}
-		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		rcu_read_lock();
+		sep = cmd->se_lun->lun_sep;
+		if (sep)
+			sep->sep_stats.rx_data_octets += cmd->data_length;
+		rcu_read_unlock();
+
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
-			spin_lock(&cmd->se_lun->lun_sep_lock);
-			if (cmd->se_lun->lun_sep) {
-				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
-					cmd->data_length;
-			}
-			spin_unlock(&cmd->se_lun->lun_sep_lock);
+			rcu_read_lock();
+			sep = cmd->se_lun->lun_sep;
+			if (sep)
+				sep->sep_stats.tx_data_octets += cmd->data_length;
+			rcu_read_unlock();
+
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret == -EAGAIN || ret == -ENOMEM)
 				goto queue_full;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 86c0c5c..01f2d91 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -845,7 +845,8 @@ struct se_port {
 	/* Used for ALUA Target Port Groups membership */
 	atomic_t	sep_tg_pt_secondary_offline;
 	/* Used for PR ALL_TG_PT=1 */
-	atomic_t	sep_tg_pt_ref_cnt;
+	struct kref	sep_tg_pt_ref;
+	struct completion sep_tg_pt_comp;
 	spinlock_t	sep_alua_lock;
 	struct mutex	sep_tg_pt_md_mutex;
 	struct t10_alua_tg_pt_gp_member *sep_alua_tg_pt_gp_mem;
@@ -853,6 +854,7 @@ struct se_port {
 	struct se_portal_group *sep_tpg;
 	struct list_head sep_alua_list;
 	struct list_head sep_list;
+	struct rcu_head	sep_rcu;
 };
 
 struct se_tpg_np {
-- 
1.9.1
