From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.2-rc1
Date: Sat, 01 Jun 2019 14:45:12 +0300
Message-ID: <1559389512.2947.33.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Six minor fixes to device drivers and one to the multipath alua
handler.  The most extensive fix is the zfcp port remove prevention
one, but it's impact is only s390.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Jason Yan (2):
      scsi: libsas: delete sas port if expander discover failed
      scsi: libsas: only clear phy->in_shutdown after shutdown event done

Lianbo Jiang (1):
      scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask

Steffen Maier (2):
      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)
      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove

Varun Prakash (1):
      scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

YueHaibing (1):
      scsi: scsi_dh_alua: Fix possible null-ptr-deref

And the diffstat:

 drivers/s390/scsi/zfcp_ext.h               |  1 +
 drivers/s390/scsi/zfcp_scsi.c              |  9 +++++
 drivers/s390/scsi/zfcp_sysfs.c             | 55 ++++++++++++++++++++++++++----
 drivers/s390/scsi/zfcp_unit.c              |  8 ++++-
 drivers/scsi/cxgbi/libcxgbi.c              |  4 +++
 drivers/scsi/device_handler/scsi_dh_alua.c |  6 ++--
 drivers/scsi/libsas/sas_expander.c         |  2 ++
 drivers/scsi/libsas/sas_phy.c              |  3 +-
 drivers/scsi/smartpqi/smartpqi_init.c      |  2 +-
 9 files changed, 76 insertions(+), 14 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_ext.h
b/drivers/s390/scsi/zfcp_ext.h
index c6acca521ffe..31e8a7240fd7 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -167,6 +167,7 @@ extern const struct attribute_group
*zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
 extern int zfcp_unit_add(struct zfcp_port *, u64);
diff --git a/drivers/s390/scsi/zfcp_scsi.c
b/drivers/s390/scsi/zfcp_scsi.c
index 221d0dfb8493..e9ded2befa0d 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -129,6 +129,15 @@ static int zfcp_scsi_slave_alloc(struct
scsi_device *sdev)
 
 	zfcp_sdev->erp_action.port = port;
 
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (zfcp_sysfs_port_is_removing(port)) {
+		/* port is already gone */
+		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		put_device(&port->dev); /* undo
zfcp_get_port_by_wwpn() */
+		return -ENXIO;
+	}
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+
 	unit = zfcp_unit_find(port, zfcp_scsi_dev_lun(sdev));
 	if (unit)
 		put_device(&unit->dev);
diff --git a/drivers/s390/scsi/zfcp_sysfs.c
b/drivers/s390/scsi/zfcp_sysfs.c
index b277be6f7611..af197e2b3e69 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -235,6 +235,53 @@ static ZFCP_DEV_ATTR(adapter, port_rescan,
S_IWUSR, NULL,
 
 DEFINE_MUTEX(zfcp_sysfs_port_units_mutex);
 
+static void zfcp_sysfs_port_set_removing(struct zfcp_port *const port)
+{
+	lockdep_assert_held(&zfcp_sysfs_port_units_mutex);
+	atomic_set(&port->units, -1);
+}
+
+bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port)
+{
+	lockdep_assert_held(&zfcp_sysfs_port_units_mutex);
+	return atomic_read(&port->units) == -1;
+}
+
+static bool zfcp_sysfs_port_in_use(struct zfcp_port *const port)
+{
+	struct zfcp_adapter *const adapter = port->adapter;
+	unsigned long flags;
+	struct scsi_device *sdev;
+	bool in_use = true;
+
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (atomic_read(&port->units) > 0)
+		goto unlock_port_units_mutex; /* zfcp_unit(s) under
port */
+
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
+		const struct zfcp_scsi_dev *zsdev =
sdev_to_zfcp(sdev);
+
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL)
+			continue;
+		if (zsdev->port != port)
+			continue;
+		/* alive scsi_device under port of interest */
+		goto unlock_host_lock;
+	}
+
+	/* port is about to be removed, so no more unit_add or
slave_alloc */
+	zfcp_sysfs_port_set_removing(port);
+	in_use = false;
+
+unlock_host_lock:
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
+unlock_port_units_mutex:
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+	return in_use;
+}
+
 static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 					    struct device_attribute
*attr,
 					    const char *buf, size_t
count)
@@ -257,15 +304,11 @@ static ssize_t
zfcp_sysfs_port_remove_store(struct device *dev,
 	else
 		retval = 0;
 
-	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) > 0) {
+	if (zfcp_sysfs_port_in_use(port)) {
 		retval = -EBUSY;
-		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		put_device(&port->dev); /* undo
zfcp_get_port_by_wwpn() */
 		goto out;
 	}
-	/* port is about to be removed, so no more unit_add */
-	atomic_set(&port->units, -1);
-	mutex_unlock(&zfcp_sysfs_port_units_mutex);
 
 	write_lock_irq(&adapter->port_list_lock);
 	list_del(&port->list);
diff --git a/drivers/s390/scsi/zfcp_unit.c
b/drivers/s390/scsi/zfcp_unit.c
index 1bf0a0984a09..e67bf7388cae 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -124,7 +124,7 @@ int zfcp_unit_add(struct zfcp_port *port, u64
fcp_lun)
 	int retval = 0;
 
 	mutex_lock(&zfcp_sysfs_port_units_mutex);
-	if (atomic_read(&port->units) == -1) {
+	if (zfcp_sysfs_port_is_removing(port)) {
 		/* port is already gone */
 		retval = -ENODEV;
 		goto out;
@@ -168,8 +168,14 @@ int zfcp_unit_add(struct zfcp_port *port, u64
fcp_lun)
 	write_lock_irq(&port->unit_list_lock);
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);
+	/*
+	 * lock order: shost->scan_mutex before
zfcp_sysfs_port_units_mutex
+	 * due to      zfcp_unit_scsi_scan() =>
zfcp_scsi_slave_alloc()
+	 */
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
 
 	zfcp_unit_scsi_scan(unit);
+	return retval;
 
 out:
 	mutex_unlock(&zfcp_sysfs_port_units_mutex);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c
b/drivers/scsi/cxgbi/libcxgbi.c
index 8b915d4ed98d..7d43e014bd21 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -639,6 +639,10 @@ cxgbi_check_route(struct sockaddr *dst_addr, int
ifindex)
 
 	if (ndev->flags & IFF_LOOPBACK) {
 		ndev = ip_dev_find(&init_net, daddr->sin_addr.s_addr);
+		if (!ndev) {
+			err = -ENETUNREACH;
+			goto rel_neigh;
+		}
 		mtu = ndev->mtu;
 		pr_info("rt dev %s, loopback -> %s, mtu %u.\n",
 			n->dev->name, ndev->name, mtu);
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
b/drivers/scsi/device_handler/scsi_dh_alua.c
index d7ac498ba35a..2a9dcb8973b7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1174,10 +1174,8 @@ static int __init alua_init(void)
 	int r;
 
 	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, 0);
-	if (!kaluad_wq) {
-		/* Temporary failure, bypass */
-		return SCSI_DH_DEV_TEMP_BUSY;
-	}
+	if (!kaluad_wq)
+		return -ENOMEM;
 
 	r = scsi_register_device_handler(&alua_dh);
 	if (r != 0) {
diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index 83f2fd70ce76..9f7e2457360e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1019,6 +1019,8 @@ static struct domain_device
*sas_ex_discover_expander(
 		list_del(&child->dev_list_node);
 		spin_unlock_irq(&parent->port->dev_list_lock);
 		sas_put_device(child);
+		sas_port_delete(phy->port);
+		phy->port = NULL;
 		return NULL;
 	}
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
diff --git a/drivers/scsi/libsas/sas_phy.c
b/drivers/scsi/libsas/sas_phy.c
index e030e1452136..b71f5ac6c7dc 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -35,7 +35,6 @@ static void sas_phye_loss_of_signal(struct
work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	phy->in_shutdown = 0;
 	phy->error = 0;
 	sas_deform_port(phy, 1);
 }
@@ -45,7 +44,6 @@ static void sas_phye_oob_done(struct work_struct
*work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	phy->in_shutdown = 0;
 	phy->error = 0;
 }
 
@@ -126,6 +124,7 @@ static void sas_phye_shutdown(struct work_struct
*work)
 				  ret);
 	} else
 		pr_notice("phy%d is not enabled, cannot shutdown\n",
phy->id);
+	phy->in_shutdown = 0;
 }
 
 /* ---------- Phy class registration ---------- */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
b/drivers/scsi/smartpqi/smartpqi_init.c
index b17761eafca9..d6be4e8f4a8f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7291,7 +7291,7 @@ static int pqi_pci_init(struct pqi_ctrl_info
*ctrl_info)
 	else
 		mask = DMA_BIT_MASK(32);
 
-	rc = dma_set_mask(&ctrl_info->pci_dev->dev, mask);
+	rc = dma_set_mask_and_coherent(&ctrl_info->pci_dev->dev,
mask);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev, "failed to set DMA
mask\n");
 		goto disable_device;
