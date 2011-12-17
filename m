From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 06/24] libsas: fix domain_device leak
Date: Fri, 16 Dec 2011 18:33:39 -0800
Message-ID: <20111217023339.15036.16390.stgit@localhost6.localdomain6>
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

Arrange for the deallocation of a struct domain_device object when it no
longer has:
1/ any children
2/ references by any scsi_targets
3/ references by a lldd

The comment about domain_device lifetime in
Documentation/scsi/libsas.txt is stale as it appears mainline never had
a version of a struct domain_device that was registered as a kobject.
We now manage domain_device reference counts on behalf of external
agents.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/scsi/libsas.txt       |   15 ---------------
 drivers/scsi/libsas/sas_discover.c  |   36 +++++++++++++++++++++++------------
 drivers/scsi/libsas/sas_expander.c  |   10 ++++++----
 drivers/scsi/libsas/sas_internal.h  |   19 ++++++++++++++++++
 drivers/scsi/libsas/sas_scsi_host.c |    6 ++++--
 include/scsi/libsas.h               |    1 +
 6 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/Documentation/scsi/libsas.txt b/Documentation/scsi/libsas.txt
index aa54f54..3cc9c78 100644
--- a/Documentation/scsi/libsas.txt
+++ b/Documentation/scsi/libsas.txt
@@ -398,21 +398,6 @@ struct sas_task {
 	task_done -- callback when the task has finished execution
 };
 
-When an external entity, entity other than the LLDD or the
-SAS Layer, wants to work with a struct domain_device, it
-_must_ call kobject_get() when getting a handle on the
-device and kobject_put() when it is done with the device.
-
-This does two things:
-     A) implements proper kfree() for the device;
-     B) increments/decrements the kref for all players:
-     domain_device
-	all domain_device's ... (if past an expander)
-	    port
-		host adapter
-		     pci device
-			 and up the ladder, etc.
-
 DISCOVERY
 ---------
 
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 54a5199..4e64930 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -36,8 +36,6 @@
 
 void sas_init_dev(struct domain_device *dev)
 {
-        INIT_LIST_HEAD(&dev->siblings);
-        INIT_LIST_HEAD(&dev->dev_list_node);
         switch (dev->dev_type) {
         case SAS_END_DEV:
                 break;
@@ -73,14 +71,14 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	struct sas_rphy *rphy;
 	struct domain_device *dev;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = sas_alloc_device();
 	if (!dev)
 		return -ENOMEM;
 
 	spin_lock_irqsave(&port->phy_list_lock, flags);
 	if (list_empty(&port->phy_list)) {
 		spin_unlock_irqrestore(&port->phy_list_lock, flags);
-		kfree(dev);
+		sas_put_device(dev);
 		return -ENODEV;
 	}
 	phy = container_of(port->phy_list.next, struct asd_sas_phy, port_phy_el);
@@ -130,7 +128,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	}
 
 	if (!rphy) {
-		kfree(dev);
+		sas_put_device(dev);
 		return -ENODEV;
 	}
 	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
@@ -173,6 +171,7 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 			       dev_name(sas_ha->dev),
 			       SAS_ADDR(dev->sas_addr), res);
 		}
+		kref_get(&dev->kref);
 	}
 	return res;
 }
@@ -184,8 +183,10 @@ void sas_notify_lldd_dev_gone(struct domain_device *dev)
 	struct Scsi_Host *shost = sas_ha->core.shost;
 	struct sas_internal *i = to_sas_internal(shost->transportt);
 
-	if (i->dft->lldd_dev_gone)
+	if (i->dft->lldd_dev_gone) {
 		i->dft->lldd_dev_gone(dev);
+		sas_put_device(dev);
+	}
 }
 
 /* ---------- Common/dispatchers ---------- */
@@ -219,6 +220,20 @@ out_err2:
 
 /* ---------- Device registration and unregistration ---------- */
 
+void sas_free_device(struct kref *kref)
+{
+	struct domain_device *dev = container_of(kref, typeof(*dev), kref);
+
+	if (dev->parent)
+		sas_put_device(dev->parent);
+
+	/* remove the phys and ports, everything else should be gone */
+	if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV)
+		kfree(dev->ex_dev.ex_phy);
+
+	kfree(dev);
+}
+
 static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	sas_notify_lldd_dev_gone(dev);
@@ -230,6 +245,8 @@ static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_d
 	spin_lock_irq(&port->dev_list_lock);
 	list_del_init(&dev->dev_list_node);
 	spin_unlock_irq(&port->dev_list_lock);
+
+	sas_put_device(dev);
 }
 
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
@@ -239,11 +256,6 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 		sas_rphy_delete(dev->rphy);
 		dev->rphy = NULL;
 	}
-	if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV) {
-		/* remove the phys and ports, everything else should be gone */
-		kfree(dev->ex_dev.ex_phy);
-		dev->ex_dev.ex_phy = NULL;
-	}
 	sas_unregister_common_dev(port, dev);
 }
 
@@ -322,7 +334,7 @@ static void sas_discover_domain(struct work_struct *work)
 		list_del_init(&dev->dev_list_node);
 		spin_unlock_irq(&port->dev_list_lock);
 
-		kfree(dev); /* not kobject_register-ed yet */
+		sas_put_device(dev);
 		port->port_dev = NULL;
 	}
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 1b831c5..15d2239 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -657,10 +657,11 @@ static struct domain_device *sas_ex_discover_end_dev(
 	if (phy->attached_sata_host || phy->attached_sata_ps)
 		return NULL;
 
-	child = kzalloc(sizeof(*child), GFP_KERNEL);
+	child = sas_alloc_device();
 	if (!child)
 		return NULL;
 
+	kref_get(&parent->kref);
 	child->parent = parent;
 	child->port   = parent->port;
 	child->iproto = phy->attached_iproto;
@@ -762,7 +763,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 	sas_port_delete(phy->port);
  out_err:
 	phy->port = NULL;
-	kfree(child);
+	sas_put_device(child);
 	return NULL;
 }
 
@@ -809,7 +810,7 @@ static struct domain_device *sas_ex_discover_expander(
 			    phy->attached_phy_id);
 		return NULL;
 	}
-	child = kzalloc(sizeof(*child), GFP_KERNEL);
+	child = sas_alloc_device();
 	if (!child)
 		return NULL;
 
@@ -835,6 +836,7 @@ static struct domain_device *sas_ex_discover_expander(
 	child->rphy = rphy;
 	edev = rphy_to_expander_device(rphy);
 	child->dev_type = phy->attached_dev_type;
+	kref_get(&parent->kref);
 	child->parent = parent;
 	child->port = port;
 	child->iproto = phy->attached_iproto;
@@ -858,7 +860,7 @@ static struct domain_device *sas_ex_discover_expander(
 		spin_lock_irq(&parent->port->dev_list_lock);
 		list_del(&child->dev_list_node);
 		spin_unlock_irq(&parent->port->dev_list_lock);
-		kfree(child);
+		sas_put_device(child);
 		return NULL;
 	}
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 14e21b5..0d43408 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -76,6 +76,8 @@ struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 
 void sas_hae_reset(struct work_struct *work);
 
+void sas_free_device(struct kref *kref);
+
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 				struct request *rsp);
@@ -161,4 +163,21 @@ static inline void sas_add_parent_port(struct domain_device *dev, int phy_id)
 	sas_port_add_phy(ex->parent_port, ex_phy->phy);
 }
 
+static inline struct domain_device *sas_alloc_device(void)
+{
+	struct domain_device *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+
+	if (dev) {
+		INIT_LIST_HEAD(&dev->siblings);
+		INIT_LIST_HEAD(&dev->dev_list_node);
+		kref_init(&dev->kref);
+	}
+	return dev;
+}
+
+static inline void sas_put_device(struct domain_device *dev)
+{
+	kref_put(&dev->kref, sas_free_device);
+}
+
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index e95e5e1..4636453 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -758,6 +758,7 @@ int sas_target_alloc(struct scsi_target *starget)
 			return res;
 	}
 
+	kref_get(&found_dev->kref);
 	starget->hostdata = found_dev;
 	return 0;
 }
@@ -1047,7 +1048,7 @@ int sas_slave_alloc(struct scsi_device *scsi_dev)
 
 void sas_target_destroy(struct scsi_target *starget)
 {
-	struct domain_device *found_dev = sas_find_target(starget);
+	struct domain_device *found_dev = starget->hostdata;
 
 	if (!found_dev)
 		return;
@@ -1055,7 +1056,8 @@ void sas_target_destroy(struct scsi_target *starget)
 	if (dev_is_sata(found_dev))
 		ata_sas_port_destroy(found_dev->sata_dev.ap);
 
-	return;
+	starget->hostdata = NULL;
+	sas_put_device(found_dev);
 }
 
 static void sas_parse_addr(u8 *sas_addr, const char *p)
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 2b14348..7ecb5c1 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -206,6 +206,7 @@ struct domain_device {
 
         void *lldd_dev;
 	int gone;
+	struct kref kref;
 };
 
 struct sas_discovery_event {

