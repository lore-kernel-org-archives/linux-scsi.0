From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 19/24] libsas: execute transport link resets with libata-eh
 via host workqueue
Date: Fri, 16 Dec 2011 18:34:46 -0800
Message-ID: <20111217023446.15036.53050.stgit@localhost6.localdomain6>
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

Link resets leave ata affiliations intact, so arrange for libsas to make
an effort to avoid dropping the device due to a slow-to-recover link.
Towards this end carry out reset in the host workqueue so that it can
check for ata devices and kick the reset request to libata.  Hard
resets, in contrast, bypass libata since they are meant for associating
an ata device with another initiator in the domain (tears down
affiliations).

Need to add a new transport_sas_phy_reset() since the current
sas_phy_reset() is a utility function to libsas lldds.  They are not
prepared for it to loop back into eh.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-eh.c            |    1 +
 drivers/ata/libata.h               |    1 -
 drivers/scsi/libsas/sas_ata.c      |   11 +++++++
 drivers/scsi/libsas/sas_init.c     |   56 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_internal.h |    1 +
 drivers/scsi/scsi_transport_sas.c  |   23 ++++++++++++---
 include/linux/libata.h             |    1 +
 include/scsi/sas_ata.h             |    4 +++
 include/scsi/scsi_transport_sas.h  |    2 +
 9 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a9b2820..c61316e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -863,6 +863,7 @@ void ata_port_wait_eh(struct ata_port *ap)
 		goto retry;
 	}
 }
+EXPORT_SYMBOL_GPL(ata_port_wait_eh);
 
 static int ata_eh_nr_in_flight(struct ata_port *ap)
 {
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 773de97..78c356d 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -150,7 +150,6 @@ extern void ata_eh_acquire(struct ata_port *ap);
 extern void ata_eh_release(struct ata_port *ap);
 extern enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
-extern void ata_port_wait_eh(struct ata_port *ap);
 extern void ata_eh_fastdrain_timerfn(unsigned long arg);
 extern void ata_qc_schedule_eh(struct ata_queued_cmd *qc);
 extern void ata_dev_disable(struct ata_device *dev);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 94354d5..1df6ed2 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -685,3 +685,14 @@ void sas_ata_schedule_reset(struct domain_device *dev)
 
 	ata_port_schedule_eh(ap);
 }
+
+void sas_ata_wait_eh(struct domain_device *dev)
+{
+	struct ata_port *ap;
+
+	if (!dev_is_sata(dev))
+		return;
+
+	ap = dev->sata_dev.ap;
+	ata_port_wait_eh(ap);
+}
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 934c9e7..2b8c09e 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/spinlock.h>
+#include <scsi/sas_ata.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport.h>
@@ -191,6 +192,59 @@ static int sas_get_linkerrors(struct sas_phy *phy)
 	return sas_smp_get_phy_events(phy);
 }
 
+/**
+ * transport_sas_phy_reset - reset a phy and permit libata to manage the link
+ *
+ * phy reset request via sysfs in host workqueue context so we know we
+ * can block on eh and safely traverse the domain_device topology
+ */
+static int transport_sas_phy_reset(struct sas_phy *phy, int hard_reset)
+{
+	int ret;
+	enum phy_func reset_type;
+
+	if (hard_reset)
+		reset_type = PHY_FUNC_HARD_RESET;
+	else
+		reset_type = PHY_FUNC_LINK_RESET;
+
+	if (scsi_is_sas_phy_local(phy)) {
+		struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+		struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+		struct asd_sas_phy *asd_phy = sas_ha->sas_phy[phy->number];
+		struct sas_internal *i =
+			to_sas_internal(sas_ha->core.shost->transportt);
+		struct domain_device *dev = NULL;
+
+		if (asd_phy->port)
+			dev = asd_phy->port->port_dev;
+
+		/* validate that dev has been probed */
+		if (dev)
+			dev = sas_find_dev_by_rphy(dev->rphy);
+
+		if (dev && dev_is_sata(dev) && !hard_reset) {
+			sas_ata_schedule_reset(dev);
+			sas_ata_wait_eh(dev);
+			ret = 0;
+		} else
+			ret = i->dft->lldd_control_phy(asd_phy, reset_type, NULL);
+	} else {
+		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
+		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
+		struct domain_device *ata_dev = sas_ex_to_ata(ddev, phy->number);
+
+		if (ata_dev && !hard_reset) {
+			sas_ata_schedule_reset(ata_dev);
+			sas_ata_wait_eh(ata_dev);
+			ret = 0;
+		} else
+			ret = sas_smp_phy_control(ddev, phy->number, reset_type, NULL);
+	}
+
+	return ret;
+}
+
 int sas_phy_enable(struct sas_phy *phy, int enable)
 {
 	int ret;
@@ -288,7 +342,7 @@ int sas_set_phy_speed(struct sas_phy *phy,
 
 static struct sas_function_template sft = {
 	.phy_enable = sas_phy_enable,
-	.phy_reset = sas_phy_reset,
+	.phy_reset = transport_sas_phy_reset,
 	.set_phy_speed = sas_set_phy_speed,
 	.get_linkerrors = sas_get_linkerrors,
 	.smp_handler = sas_smp_handler,
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 141a2df..5879e72 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -73,6 +73,7 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
+struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 
 void sas_hae_reset(struct work_struct *work);
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 9d9330a..760b80b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -609,12 +609,15 @@ do_sas_phy_reset(struct device *dev, size_t count, int hard_reset)
 {
 	struct sas_phy *phy = transport_class_to_phy(dev);
 	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
-	int error;
 
-	error = i->f->phy_reset(phy, hard_reset);
-	if (error)
-		return error;
+	phy->hard_reset = hard_reset;
+	phy->reset_result = 0;
+
+	scsi_queue_work(shost, &phy->reset_work);
+	scsi_flush_work(shost);
+
+	if (phy->reset_result)
+		return phy->reset_result;
 	return count;
 };
 
@@ -683,6 +686,15 @@ static void sas_phy_release(struct device *dev)
 	kfree(phy);
 }
 
+static void sas_phy_reset_work(struct work_struct *work)
+{
+	struct sas_phy *phy = container_of(work, typeof(*phy), reset_work);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+
+	phy->reset_result = i->f->phy_reset(phy, phy->hard_reset);
+}
+
 /**
  * sas_phy_alloc  -  allocates and initialize a SAS PHY structure
  * @parent:	Parent device
@@ -711,6 +723,7 @@ struct sas_phy *sas_phy_alloc(struct device *parent, int number)
 	phy->dev.parent = get_device(parent);
 	phy->dev.release = sas_phy_release;
 	INIT_LIST_HEAD(&phy->port_siblings);
+	INIT_WORK(&phy->reset_work, sas_phy_reset_work);
 	if (scsi_is_sas_expander_device(parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent);
 		dev_set_name(&phy->dev, "phy-%d:%d:%d", shost->host_no,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index cafc09a..aa42704 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1147,6 +1147,7 @@ static inline int ata_acpi_cbl_80wire(struct ata_port *ap,
  * EH - drivers/ata/libata-eh.c
  */
 extern void ata_port_schedule_eh(struct ata_port *ap);
+extern void ata_port_wait_eh(struct ata_port *ap);
 extern int ata_link_abort(struct ata_link *link);
 extern int ata_port_abort(struct ata_port *ap);
 extern int ata_port_freeze(struct ata_port *ap);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index c0bcd30..da3f377 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -45,6 +45,7 @@ int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 	       struct list_head *done_q);
 void sas_probe_sata(struct work_struct *work);
 void sas_ata_schedule_reset(struct domain_device *dev);
+void sas_ata_wait_eh(struct domain_device *dev);
 #else
 
 
@@ -79,6 +80,9 @@ static inline void sas_ata_schedule_reset(struct domain_device *dev)
 {
 }
 
+static inline void sas_ata_wait_eh(struct domain_device *dev)
+{
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index ffeebc3..c7eea0d 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -75,6 +75,8 @@ struct sas_phy {
 	/* for the list of phys belonging to a port */
 	struct list_head	port_siblings;
 
+	int			hard_reset;
+	int			reset_result;
 	struct work_struct      reset_work;
 };
 

