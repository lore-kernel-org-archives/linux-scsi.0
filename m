From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 04/13] libsas: set attached device type and target
 protocols for local phys
Date: Fri, 10 Feb 2012 00:45:00 -0800
Message-ID: <20120210084500.25701.50169.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443Ab2BJIaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 03:30:05 -0500
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

Before:
$ cat /sys/class/sas_phy/phy-6\:3/device_type
none
$ cat /sys/class/sas_phy/phy-6\:3/target_port_protocols
none

After:
$ cat /sys/class/sas_phy/phy-6\:3/device_type
end device
$ cat /sys/class/sas_phy/phy-6\:3/target_port_protocols
sata

Also downgrade the phy_list_lock to _irq instead of _irqsave since
libsas will never call sas_get_port_device with interrupts disbled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |   12 ++++++++----
 drivers/scsi/libsas/sas_internal.h |   17 +++++++++++++++++
 drivers/scsi/libsas/sas_port.c     |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index ed3f8c0..7a3ae48 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -69,7 +69,6 @@ void sas_init_dev(struct domain_device *dev)
  */
 static int sas_get_port_device(struct asd_sas_port *port)
 {
-	unsigned long flags;
 	struct asd_sas_phy *phy;
 	struct sas_rphy *rphy;
 	struct domain_device *dev;
@@ -78,9 +77,9 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	if (!dev)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&port->phy_list_lock, flags);
+	spin_lock_irq(&port->phy_list_lock);
 	if (list_empty(&port->phy_list)) {
-		spin_unlock_irqrestore(&port->phy_list_lock, flags);
+		spin_unlock_irq(&port->phy_list_lock);
 		sas_put_device(dev);
 		return -ENODEV;
 	}
@@ -89,7 +88,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	memcpy(dev->frame_rcvd, phy->frame_rcvd, min(sizeof(dev->frame_rcvd),
 					     (size_t)phy->frame_rcvd_size));
 	spin_unlock(&phy->frame_rcvd_lock);
-	spin_unlock_irqrestore(&port->phy_list_lock, flags);
+	spin_unlock_irq(&port->phy_list_lock);
 
 	if (dev->frame_rcvd[0] == 0x34 && port->oob_mode == SATA_OOB_MODE) {
 		struct dev_to_host_fis *fis =
@@ -134,6 +133,11 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		sas_put_device(dev);
 		return -ENODEV;
 	}
+
+	spin_lock_irq(&port->phy_list_lock);
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		sas_phy_set_target(phy, dev);
+	spin_unlock_irq(&port->phy_list_lock);
 	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_fill_in_rphy(dev, rphy);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index d0d9bf1..f05c638 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -30,6 +30,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/libsas.h>
+#include <scsi/sas_ata.h>
 
 #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
 
@@ -147,6 +148,22 @@ static inline void sas_fill_in_rphy(struct domain_device *dev,
 	}
 }
 
+static inline void sas_phy_set_target(struct asd_sas_phy *p, struct domain_device *dev)
+{
+	struct sas_phy *phy = p->phy;
+
+	if (dev) {
+		if (dev_is_sata(dev))
+			phy->identify.device_type = SAS_END_DEVICE;
+		else
+			phy->identify.device_type = dev->dev_type;
+		phy->identify.target_port_protocols = dev->tproto;
+	} else {
+		phy->identify.device_type = SAS_PHY_UNUSED;
+		phy->identify.target_port_protocols = 0;
+	}
+}
+
 static inline void sas_add_parent_port(struct domain_device *dev, int phy_id)
 {
 	struct expander_device *ex = &dev->ex_dev;
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 29f8fd3..eb19c01 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -104,6 +104,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	/* add the phy to the port */
 	list_add_tail(&phy->port_phy_el, &port->phy_list);
+	sas_phy_set_target(phy, port->port_dev);
 	phy->port = port;
 	port->num_phys++;
 	port->phy_mask |= (1U << phy->id);
@@ -182,6 +183,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 	spin_lock(&port->phy_list_lock);
 
 	list_del_init(&phy->port_phy_el);
+	sas_phy_set_target(phy, NULL);
 	phy->port = NULL;
 	port->num_phys--;
 	port->phy_mask &= ~(1U << phy->id);

