From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v7 4/6] libsas: async ata scanning
Date: Mon, 23 Jan 2012 23:50:35 -0800
Message-ID: <20120124075035.22384.48107.stgit@localhost6.localdomain6>
References: <20120124074825.22384.17157.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120124074825.22384.17157.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

libsas ata error handling is already async but this does not help the
scan case.  Move initial link recovery out from under host->scan_mutex,
and delay synchronization with eh until after all port probe/recovery
work has been queued.

Device ordering is maintained with scan order by still calling
sas_rphy_add() in order of domain discovery.

Since we now scan the domain list when invoking libata-eh we need to be
careful to check for fully initialized ata ports.

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c           |   34 +++++++++-------
 drivers/ata/libata-scsi.c           |   13 ++++++
 drivers/ata/libata.h                |    1 
 drivers/scsi/aic94xx/aic94xx_init.c |    1 
 drivers/scsi/isci/init.c            |    1 
 drivers/scsi/libsas/sas_ata.c       |   74 ++++++++++++++++++++++++++++++-----
 drivers/scsi/libsas/sas_discover.c  |   22 +++++-----
 drivers/scsi/libsas/sas_internal.h  |    9 ++++
 drivers/scsi/libsas/sas_scsi_host.c |   18 ---------
 drivers/scsi/mvsas/mv_init.c        |    1 
 drivers/scsi/pm8001/pm8001_init.c   |    1 
 include/linux/libata.h              |    1 
 include/scsi/libsas.h               |    1 
 include/scsi/sas_ata.h              |   12 +++---
 14 files changed, 123 insertions(+), 66 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c04ad68..1654c94 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5874,29 +5874,31 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 	host->ops = ops;
 }
 
-int ata_port_probe(struct ata_port *ap)
+void __ata_port_probe(struct ata_port *ap)
 {
-	int rc = 0;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	unsigned long flags;
 
-	/* probe */
-	if (ap->ops->error_handler) {
-		struct ata_eh_info *ehi = &ap->link.eh_info;
-		unsigned long flags;
+	/* kick EH for boot probing */
+	spin_lock_irqsave(ap->lock, flags);
 
-		/* kick EH for boot probing */
-		spin_lock_irqsave(ap->lock, flags);
+	ehi->probe_mask |= ATA_ALL_DEVICES;
+	ehi->action |= ATA_EH_RESET;
+	ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
 
-		ehi->probe_mask |= ATA_ALL_DEVICES;
-		ehi->action |= ATA_EH_RESET;
-		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+	ap->pflags &= ~ATA_PFLAG_INITIALIZING;
+	ap->pflags |= ATA_PFLAG_LOADING;
+	ata_port_schedule_eh(ap);
 
-		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
-		ap->pflags |= ATA_PFLAG_LOADING;
-		ata_port_schedule_eh(ap);
+	spin_unlock_irqrestore(ap->lock, flags);
+}
 
-		spin_unlock_irqrestore(ap->lock, flags);
+int ata_port_probe(struct ata_port *ap)
+{
+	int rc = 0;
 
-		/* wait for EH to finish */
+	if (ap->ops->error_handler) {
+		__ata_port_probe(ap);
 		ata_port_wait_eh(ap);
 	} else {
 		DPRINTK("ata%u: bus probe begin\n", ap->print_id);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2a5412e..faf8730 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3837,6 +3837,19 @@ void ata_sas_port_stop(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
+int ata_sas_async_port_init(struct ata_port *ap)
+{
+	int rc = ap->ops->port_start(ap);
+
+	if (!rc) {
+		ap->print_id = ata_print_id++;
+		__ata_port_probe(ap);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_sas_async_port_init);
+
 /**
  *	ata_sas_port_init - Initialize a SATA device
  *	@ap: SATA port to initialize
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 78c356d..2a2aa51 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -104,6 +104,7 @@ extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
 extern int ata_port_probe(struct ata_port *ap);
+extern void __ata_port_probe(struct ata_port *ap);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index eea988a..ff80552 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -81,7 +81,6 @@ static struct scsi_host_template aic94xx_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 };
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 437f76b..9a28270 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -157,7 +157,6 @@ static struct scsi_host_template isci_sht = {
 	.sg_tablesize			= SG_ALL,
 	.max_sectors			= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.slave_alloc			= sas_slave_alloc,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 5f8adb8..f82997a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -585,11 +585,10 @@ static struct ata_port_info sata_port_info = {
 	.port_ops = &sas_sata_ops
 };
 
-int sas_ata_init_host_and_port(struct domain_device *found_dev,
-			       struct scsi_target *starget)
+int sas_ata_init_host_and_port(struct domain_device *found_dev)
 {
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
+	struct sas_ha_struct *ha = found_dev->port->ha;
+	struct Scsi_Host *shost = ha->core.shost;
 	struct ata_port *ap;
 
 	ata_host_init(&found_dev->sata_dev.ata_host,
@@ -607,6 +606,8 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
+	/* publish initialized ata port */
+	smp_wmb();
 	found_dev->sata_dev.ap = ap;
 
 	return 0;
@@ -683,6 +684,38 @@ static void sas_get_ata_command_set(struct domain_device *dev)
 		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
 }
 
+void sas_probe_sata(struct asd_sas_port *port)
+{
+	struct domain_device *dev, *n;
+	int err;
+
+	mutex_lock(&port->ha->disco_mutex);
+	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
+		if (!dev_is_sata(dev))
+			continue;
+
+		err = sas_ata_init_host_and_port(dev);
+		if (err)
+			sas_fail_probe(dev, __func__, err);
+		else
+			ata_sas_async_port_init(dev->sata_dev.ap);
+	}
+	mutex_unlock(&port->ha->disco_mutex);
+
+	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
+		if (!dev_is_sata(dev))
+			continue;
+
+		sas_ata_wait_eh(dev);
+
+		/* if libata could not bring the link up, don't surface
+		 * the device
+		 */
+		if (ata_dev_disabled(sas_to_ata_dev(dev)))
+			sas_fail_probe(dev, __func__, -ENODEV);
+	}
+}
+
 /**
  * sas_discover_sata -- discover an STP/SATA domain device
  * @dev: pointer to struct domain_device of interest
@@ -729,11 +762,23 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 	wake_up(&ha->core.shost->host_wait);
 }
 
+static bool sas_ata_dev_eh_valid(struct domain_device *dev)
+{
+	struct ata_port *ap;
+
+	if (!dev_is_sata(dev))
+		return false;
+	ap = dev->sata_dev.ap;
+	/* consume fully initialized ata ports */
+	smp_rmb();
+	return !!ap;
+}
+
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
 	LIST_HEAD(async);
+	int i;
 
 	/* it's ok to defer revalidation events during ata eh, these
 	 * disks are in one of three states:
@@ -745,14 +790,21 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 	 */
 	sas_disable_revalidation(sas_ha);
 
-	shost_for_each_device(sdev, shost) {
-		struct domain_device *ddev = sdev_to_domain_dev(sdev);
-
-		if (!dev_is_sata(ddev))
-			continue;
+	spin_lock_irq(&sas_ha->phy_port_lock);
+	for (i = 0; i < sas_ha->num_phys; i++) {
+		struct asd_sas_port *port = sas_ha->sas_port[i];
+		struct domain_device *dev;
 
-		async_schedule_domain(async_sas_ata_eh, ddev, &async);
+		spin_lock(&port->dev_list_lock);
+		list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+			if (!sas_ata_dev_eh_valid(dev))
+				continue;
+			async_schedule_domain(async_sas_ata_eh, dev, &async);
+		}
+		spin_unlock(&port->dev_list_lock);
 	}
+	spin_unlock_irq(&sas_ha->phy_port_lock);
+
 	async_synchronize_full_domain(&async);
 
 	sas_enable_revalidation(sas_ha);
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index f60b602..ed3f8c0 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -207,22 +207,22 @@ static void sas_probe_devices(struct work_struct *work)
 
 	clear_bit(DISCE_PROBE, &port->disc.pending);
 
-	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
-		int err;
-
+	/* devices must be domain members before link recovery and probe */
+	list_for_each_entry(dev, &port->disco_list, disco_list_node) {
 		spin_lock_irq(&port->dev_list_lock);
 		list_add_tail(&dev->dev_list_node, &port->dev_list);
 		spin_unlock_irq(&port->dev_list_lock);
+	}
 
-		err = sas_rphy_add(dev->rphy);
+	sas_probe_sata(port);
 
-		if (err) {
-			SAS_DPRINTK("%s: for %s device %16llx returned %d\n",
-				    __func__, dev->parent ? "exp-attached" :
-							    "direct-attached",
-				    SAS_ADDR(dev->sas_addr), err);
-			sas_unregister_dev(port, dev);
-		} else
+	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
+		int err;
+
+		err = sas_rphy_add(dev->rphy);
+		if (err)
+			sas_fail_probe(dev, __func__, err);
+		else
 			list_del_init(&dev->disco_list_node);
 	}
 }
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index e028d7a..d0d9bf1 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -113,6 +113,15 @@ static inline int sas_smp_host_handler(struct Scsi_Host *shost,
 }
 #endif
 
+static inline void sas_fail_probe(struct domain_device *dev, const char *func, int err)
+{
+	SAS_DPRINTK("%s: for %s device %16llx returned %d\n",
+		    func, dev->parent ? "exp-attached" :
+					    "direct-attached",
+		    SAS_ADDR(dev->sas_addr), err);
+	sas_unregister_dev(dev->port, dev);
+}
+
 static inline void sas_fill_in_rphy(struct domain_device *dev,
 				    struct sas_rphy *rphy)
 {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index e58ca50..3701ff7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -762,17 +762,10 @@ int sas_target_alloc(struct scsi_target *starget)
 {
 	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
 	struct domain_device *found_dev = sas_find_dev_by_rphy(rphy);
-	int res;
 
 	if (!found_dev)
 		return -ENODEV;
 
-	if (dev_is_sata(found_dev)) {
-		res = sas_ata_init_host_and_port(found_dev, starget);
-		if (res)
-			return res;
-	}
-
 	kref_get(&found_dev->kref);
 	starget->hostdata = found_dev;
 	return 0;
@@ -1012,16 +1005,6 @@ void sas_task_abort(struct sas_task *task)
 	}
 }
 
-int sas_slave_alloc(struct scsi_device *scsi_dev)
-{
-	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-
-	if (dev_is_sata(dev))
-		return ata_sas_port_init(dev->sata_dev.ap);
-
-	return 0;
-}
-
 void sas_target_destroy(struct scsi_target *starget)
 {
 	struct domain_device *found_dev = starget->hostdata;
@@ -1082,6 +1065,5 @@ EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
 EXPORT_SYMBOL_GPL(sas_eh_bus_reset_handler);
-EXPORT_SYMBOL_GPL(sas_slave_alloc);
 EXPORT_SYMBOL_GPL(sas_target_destroy);
 EXPORT_SYMBOL_GPL(sas_ioctl);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index d45878b..cc59dff 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -73,7 +73,6 @@ static struct scsi_host_template mvs_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index bd165ea..36efaa7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -75,7 +75,6 @@ static struct scsi_host_template pm8001_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index aa42704..42378d6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -996,6 +996,7 @@ extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
+extern int ata_sas_async_port_init(struct ata_port *);
 extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_port_start(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4a42be3..20153d5 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -646,7 +646,6 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 int sas_queue_up(struct sas_task *task);
 extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
-extern int sas_slave_alloc(struct scsi_device *);
 extern int sas_slave_configure(struct scsi_device *);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth,
 				  int reason);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 1556eff..cdccd2e 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -37,15 +37,14 @@ static inline int dev_is_sata(struct domain_device *dev)
 }
 
 int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
-int sas_ata_init_host_and_port(struct domain_device *found_dev,
-			       struct scsi_target *starget);
-
+int sas_ata_init_host_and_port(struct domain_device *found_dev);
 void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
 void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 		struct list_head *done_q);
 void sas_ata_schedule_reset(struct domain_device *dev);
 void sas_ata_wait_eh(struct domain_device *dev);
+void sas_probe_sata(struct asd_sas_port *port);
 #else
 
 
@@ -53,8 +52,7 @@ static inline int dev_is_sata(struct domain_device *dev)
 {
 	return 0;
 }
-static inline int sas_ata_init_host_and_port(struct domain_device *found_dev,
-			       struct scsi_target *starget)
+static inline int sas_ata_init_host_and_port(struct domain_device *found_dev)
 {
 	return 0;
 }
@@ -79,6 +77,10 @@ static inline void sas_ata_wait_eh(struct domain_device *dev)
 {
 }
 
+static inline void sas_probe_sata(struct asd_sas_port *port)
+{
+}
+
 static inline int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
 {
 	return 0;

