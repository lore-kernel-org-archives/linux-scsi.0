From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/24] libsas: prevent domain rediscovery competing with ata
 error handling
Date: Fri, 16 Dec 2011 18:33:59 -0800
Message-ID: <20111217023359.15036.89266.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

libata error handling provides for a timeout for link recovery.  libsas
must not rescan for previously known devices in this interval otherwise
it may remove a device that is simply waiting for its link to recover.
Let libata-eh make the determination of when the link is stable and
prevent libsas (host workqueue) from taking action while this
determination is pending.

This adds a new cleanup state for domain devices to libsas
'allocated-not-probed'.  In this state dev->rphy points to a rphy that
is known to have been through a sas_rphy_add() event.  At
sas_unregister_dev() time check if this device is still pending probe
and cleanup accordingly.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c      |   45 +++++++++++++++++++++++++++++++++---
 drivers/scsi/libsas/sas_discover.c |   25 ++++++++++++++++++--
 drivers/scsi/libsas/sas_expander.c |    5 ++--
 drivers/scsi/libsas/sas_init.c     |    1 +
 drivers/scsi/libsas/sas_internal.h |    1 +
 drivers/scsi/libsas/sas_port.c     |    1 +
 include/scsi/libsas.h              |    8 +++++-
 include/scsi/sas_ata.h             |    5 ++++
 8 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0489001..4b91c74 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -753,6 +753,35 @@ static int sas_discover_sata_pm(struct domain_device *dev)
 	return -ENODEV;
 }
 
+void sas_probe_sata(struct work_struct *work)
+{
+	struct domain_device *dev, *n;
+	struct sas_discovery_event *ev =
+		container_of(work, struct sas_discovery_event, work);
+	struct asd_sas_port *port = ev->port;
+
+	clear_bit(DISCE_PROBE, &port->disc.pending);
+
+	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
+		int err;
+
+		spin_lock_irq(&port->dev_list_lock);
+		list_add_tail(&dev->dev_list_node, &port->dev_list);
+		spin_unlock_irq(&port->dev_list_lock);
+
+		err = sas_rphy_add(dev->rphy);
+
+		if (err) {
+			SAS_DPRINTK("%s: for %s device %16llx returned %d\n",
+				    __func__, dev->parent ? "exp-attached" :
+							    "direct-attached",
+				    SAS_ADDR(dev->sas_addr), err);
+			sas_unregister_dev(port, dev);
+		} else
+			list_del_init(&dev->disco_list_node);
+	}
+}
+
 /**
  * sas_discover_sata -- discover an STP/SATA domain device
  * @dev: pointer to struct domain_device of interest
@@ -789,10 +818,15 @@ int sas_discover_sata(struct domain_device *dev)
 		break;
 	}
 	sas_notify_lldd_dev_gone(dev);
-	if (!res) {
-		sas_notify_lldd_dev_found(dev);
-		res = sas_rphy_add(dev->rphy);
-	}
+
+	if (res)
+		return res;
+
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		return res;
+
+	sas_discover_event(dev->port, DISCE_PROBE);
 
 	return res;
 }
@@ -800,7 +834,9 @@ int sas_discover_sata(struct domain_device *dev)
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
+	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
 
+	mutex_lock(&sas_ha->eh_mutex);
 	shost_for_each_device(sdev, shost) {
 		struct domain_device *ddev = sdev_to_domain_dev(sdev);
 		struct ata_port *ap = ddev->sata_dev.ap;
@@ -811,6 +847,7 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 		ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error handler");
 		ata_scsi_port_error_handler(shost, ap);
 	}
+	mutex_unlock(&sas_ha->eh_mutex);
 }
 
 int sas_ata_timed_out(struct scsi_cmnd *cmd, struct sas_task *task,
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index ed04118..5fb072c 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -148,9 +148,14 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	port->disc.max_level = 0;
 
 	dev->rphy = rphy;
-	spin_lock_irq(&port->dev_list_lock);
-	list_add_tail(&dev->dev_list_node, &port->dev_list);
-	spin_unlock_irq(&port->dev_list_lock);
+
+	if (dev_is_sata(dev))
+		list_add_tail(&dev->disco_list_node, &port->disco_list);
+	else {
+		spin_lock_irq(&port->dev_list_lock);
+		list_add_tail(&dev->dev_list_node, &port->dev_list);
+		spin_unlock_irq(&port->dev_list_lock);
+	}
 
 	return 0;
 }
@@ -257,6 +262,12 @@ static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_d
 
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
+	if (!list_empty(&dev->disco_list_node)) {
+		list_del_init(&dev->disco_list_node);
+		sas_rphy_free(dev->rphy);
+		dev->rphy = NULL;
+	}
+
 	if (dev->rphy) {
 		sas_remove_children(&dev->rphy->dev);
 		sas_rphy_delete(dev->rphy);
@@ -271,6 +282,8 @@ void sas_unregister_domain_devices(struct asd_sas_port *port)
 
 	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node)
 		sas_unregister_dev(port, dev);
+	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
+		sas_unregister_dev(port, dev);
 
 	port->port->rphy = NULL;
 
@@ -335,6 +348,7 @@ static void sas_discover_domain(struct work_struct *work)
 		sas_rphy_free(dev->rphy);
 		dev->rphy = NULL;
 
+		list_del_init(&dev->disco_list_node);
 		spin_lock_irq(&port->dev_list_lock);
 		list_del_init(&dev->dev_list_node);
 		spin_unlock_irq(&port->dev_list_lock);
@@ -358,8 +372,12 @@ static void sas_revalidate_domain(struct work_struct *work)
 
 	SAS_DPRINTK("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
 		    task_pid_nr(current));
+
+	/* prevent rediscovery from finding sata links in recovery */
+	mutex_lock(&port->ha->eh_mutex);
 	if (port->port_dev)
 		res = sas_ex_revalidate_domain(port->port_dev);
+	mutex_unlock(&port->ha->eh_mutex);
 
 	SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
 		    port->id, task_pid_nr(current), res);
@@ -395,6 +413,7 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
 	static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
 		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
 		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
+		[DISCE_PROBE] = sas_probe_sata,
 	};
 
 	disc->pending = 0;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 15d2239..c3846cf 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -704,9 +704,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		child->rphy = rphy;
 
-		spin_lock_irq(&parent->port->dev_list_lock);
-		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
-		spin_unlock_irq(&parent->port->dev_list_lock);
+		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
 		res = sas_discover_sata(child);
 		if (res) {
@@ -756,6 +754,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 	sas_rphy_free(child->rphy);
 	child->rphy = NULL;
 
+	list_del(&child->disco_list_node);
 	spin_lock_irq(&parent->port->dev_list_lock);
 	list_del(&child->dev_list_node);
 	spin_unlock_irq(&parent->port->dev_list_lock);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index a435876..55e34c6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -104,6 +104,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 {
 	int error = 0;
 
+	mutex_init(&sas_ha->eh_mutex);
 	spin_lock_init(&sas_ha->phy_port_lock);
 	sas_hash_addr(sas_ha->hashed_sas_addr, sas_ha->sas_addr);
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7fe4ede..128c941 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -152,6 +152,7 @@ static inline struct domain_device *sas_alloc_device(void)
 	if (dev) {
 		INIT_LIST_HEAD(&dev->siblings);
 		INIT_LIST_HEAD(&dev->dev_list_node);
+		INIT_LIST_HEAD(&dev->disco_list_node);
 		kref_init(&dev->kref);
 	}
 	return dev;
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index a47c7a7..df230f1 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -277,6 +277,7 @@ static void sas_init_port(struct asd_sas_port *port,
 	memset(port, 0, sizeof(*port));
 	port->id = i;
 	INIT_LIST_HEAD(&port->dev_list);
+	INIT_LIST_HEAD(&port->disco_list);
 	spin_lock_init(&port->phy_list_lock);
 	INIT_LIST_HEAD(&port->phy_list);
 	port->ha = sas_ha;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index de63a66..f1e4f2d 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -86,7 +86,8 @@ enum discover_event {
 	DISCE_DISCOVER_DOMAIN   = 0U,
 	DISCE_REVALIDATE_DOMAIN = 1,
 	DISCE_PORT_GONE         = 2,
-	DISC_NUM_EVENTS 	= 3,
+	DISCE_PROBE		= 3,
+	DISC_NUM_EVENTS 	= 4,
 };
 
 /* ---------- Expander Devices ---------- */
@@ -188,6 +189,7 @@ struct domain_device {
         struct asd_sas_port *port;        /* shortcut to root of the tree */
 
         struct list_head dev_list_node;
+	struct list_head disco_list_node;
 
         enum sas_protocol    iproto;
         enum sas_protocol    tproto;
@@ -223,7 +225,6 @@ struct sas_discovery {
 	int    max_level;
 };
 
-
 /* The port struct is Class:RW, driver:RO */
 struct asd_sas_port {
 /* private: */
@@ -233,6 +234,7 @@ struct asd_sas_port {
 	struct domain_device *port_dev;
 	spinlock_t dev_list_lock;
 	struct list_head dev_list;
+	struct list_head disco_list;
 	enum   sas_linkrate linkrate;
 
 	struct sas_phy *phy;
@@ -341,6 +343,8 @@ struct sas_ha_struct {
 	enum sas_ha_state state;
 	spinlock_t 	  state_lock;
 
+	struct mutex eh_mutex;
+
 	struct scsi_core core;
 
 /* public: */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 7d5013f..557fc9a 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -45,6 +45,7 @@ int sas_ata_timed_out(struct scsi_cmnd *cmd, struct sas_task *task,
 		      enum blk_eh_timer_return *rtn);
 int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 	       struct list_head *done_q);
+void sas_probe_sata(struct work_struct *work);
 
 #else
 
@@ -78,6 +79,10 @@ static inline int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 	return 0;
 }
 
+static inline void sas_probe_sata(struct work_struct *work)
+{
+}
+
 #endif
 
 #endif /* _SAS_ATA_H_ */

