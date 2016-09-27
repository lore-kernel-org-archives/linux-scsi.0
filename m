From: Yijing Wang <wangyijing@huawei.com>
Subject: [RFC][PATCH v2 2/2] libsas: Fix hotplug issue in libsas
Date: Tue, 27 Sep 2016 11:16:21 +0800
Message-ID: <1474946181-29899-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, tj@kernel.org, chenqilin2@huawei.com, wangyijing@huawei.com, fangwei1@huawei.com, heyousong@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now the libsas hotplug has some issues, Dan Williams report
a similar bug here:
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html

The root cause of the issues is we use one workqueue(shost->work_q) to
process libsas event, and we divide a hot-on or hot-remove flow to several
events to process. E.g. we start a new work and queue it into the same
workqueue in sas_deform_port() to remove the children devices after
the sas port. So if there is one hot-on event between remove sas port
and destruct the children devices, some unexpected errors would
be caused.

This patch modify hotplug event process mechanism to solve the
hotplug problems in libsas. We move device add/del operation to
a new workqueue(named sas_dev_wq).

And we use sas_port_alloc_num to replace sas_port_alloc function
because when discovery is concurrently executing with the device
adding or destroying, the old sas port resource may have not
completely deleted, the new sas port resource of the same name
will be created, and this will cause calltrace about sysfs
device node.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Yousong He <heyousong@huawei.com>
Signed-off-by: Qilin Chen <chenqilin2@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c       |  34 ++---
 drivers/scsi/libsas/sas_discover.c  | 245 ++++++++++++++++++++++++++----------
 drivers/scsi/libsas/sas_expander.c  |  54 ++++++--
 drivers/scsi/libsas/sas_init.c      |  26 +++-
 drivers/scsi/libsas/sas_internal.h  |  46 ++++++-
 drivers/scsi/libsas/sas_port.c      |  12 +-
 drivers/scsi/libsas/sas_scsi_host.c |  23 ++++
 include/scsi/libsas.h               |   5 +-
 include/scsi/sas_ata.h              |   4 +-
 9 files changed, 340 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 763f012..877efa8 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -619,32 +619,22 @@ static int sas_get_ata_command_set(struct domain_device *dev)
 	return ata_dev_classify(&tf);
 }
 
-void sas_probe_sata(struct asd_sas_port *port)
+void sas_probe_sata_device(struct domain_device *dev)
 {
-	struct domain_device *dev, *n;
-
-	mutex_lock(&port->ha->disco_mutex);
-	list_for_each_entry(dev, &port->disco_list, disco_list_node) {
-		if (!dev_is_sata(dev))
-			continue;
-
-		ata_sas_async_probe(dev->sata_dev.ap);
-	}
-	mutex_unlock(&port->ha->disco_mutex);
+	struct asd_sas_port *port = dev->port;
 
-	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
-		if (!dev_is_sata(dev))
-			continue;
+	if (!port || !port->ha || !dev_is_sata(dev))
+		return;
 
-		sas_ata_wait_eh(dev);
+	ata_sas_async_probe(dev->sata_dev.ap);
 
-		/* if libata could not bring the link up, don't surface
-		 * the device
-		 */
-		if (ata_dev_disabled(sas_to_ata_dev(dev)))
-			sas_fail_probe(dev, __func__, -ENODEV);
-	}
+	sas_ata_wait_eh(dev);
 
+	/* if libata could not bring the link up, don't surface
+	 * the device
+	 */
+	if (ata_dev_disabled(sas_to_ata_dev(dev)))
+		sas_fail_probe(dev, __func__, -ENODEV);
 }
 
 static void sas_ata_flush_pm_eh(struct asd_sas_port *port, const char *func)
@@ -729,7 +719,7 @@ int sas_discover_sata(struct domain_device *dev)
 	if (res)
 		return res;
 
-	sas_discover_event(dev->port, DISCE_PROBE);
+	sas_notify_device_event(dev, SAS_DEVICE_ADD);
 	return 0;
 }
 
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de662..ea57c66 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -34,6 +34,12 @@
 #include <scsi/sas_ata.h>
 #include "../scsi_sas_internal.h"
 
+
+static void sas_unregister_common_dev(struct asd_sas_port *port,
+				struct domain_device *dev);
+static void sas_unregister_fail_dev(struct asd_sas_port *port,
+				struct domain_device *dev);
+
 /* ---------- Basic task processing for discovery purposes ---------- */
 
 void sas_init_dev(struct domain_device *dev)
@@ -158,11 +164,8 @@ static int sas_get_port_device(struct asd_sas_port *port)
 
 	if (dev_is_sata(dev) || dev->dev_type == SAS_END_DEVICE)
 		list_add_tail(&dev->disco_list_node, &port->disco_list);
-	else {
-		spin_lock_irq(&port->dev_list_lock);
-		list_add_tail(&dev->dev_list_node, &port->dev_list);
-		spin_unlock_irq(&port->dev_list_lock);
-	}
+	else
+		list_add_tail(&dev->dev_list_node, &port->expander_list);
 
 	spin_lock_irq(&port->phy_list_lock);
 	list_for_each_entry(phy, &port->phy_list, port_phy_el)
@@ -212,34 +215,83 @@ void sas_notify_lldd_dev_gone(struct domain_device *dev)
 	}
 }
 
-static void sas_probe_devices(struct work_struct *work)
+static void sas_add_device(struct work_struct *work)
 {
-	struct domain_device *dev, *n;
-	struct sas_discovery_event *ev = to_sas_discovery_event(work);
-	struct asd_sas_port *port = ev->port;
+	int err;
+	struct sas_device_event *ev = to_sas_device_event(work);
+	struct domain_device *dev = ev->device;
+	struct asd_sas_port *port = dev->port;
 
-	clear_bit(DISCE_PROBE, &port->disc.pending);
+	/* if device is not on disco_list, BUG! */
+	BUG_ON(list_empty(&dev->disco_list_node));
 
-	/* devices must be domain members before link recovery and probe */
-	list_for_each_entry(dev, &port->disco_list, disco_list_node) {
-		spin_lock_irq(&port->dev_list_lock);
-		list_add_tail(&dev->dev_list_node, &port->dev_list);
-		spin_unlock_irq(&port->dev_list_lock);
-	}
+	/* avoid add a device that has gone */
+	if (test_bit(SAS_DEV_DESTROY, &dev->state))
+		goto out;
 
-	sas_probe_sata(port);
+	mutex_lock(&port->ha->disco_mutex);
+	spin_lock_irq(&port->dev_list_lock);
+	list_add_tail(&dev->dev_list_node, &port->dev_list);
+	spin_unlock_irq(&port->dev_list_lock);
+	mutex_unlock(&port->ha->disco_mutex);
+
+	sas_probe_sata_device(dev);
 
-	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
-		int err;
+	if (!test_bit(SAS_DEV_PROBE_FAIL, &dev->state)) {
 
 		err = sas_rphy_add(dev->rphy);
 		if (err)
 			sas_fail_probe(dev, __func__, err);
-		else
-			list_del_init(&dev->disco_list_node);
 	}
+
+out:
+	/* race with discovery */
+	mutex_lock(&port->ha->disco_mutex);
+	list_del_init(&dev->disco_list_node);
+	mutex_unlock(&port->ha->disco_mutex);
+
+	kfree(ev);
 }
 
+static void sas_del_device(struct work_struct *work)
+{
+	struct sas_device_event *ev = to_sas_device_event(work);
+	struct domain_device *dev = ev->device;
+	struct asd_sas_port *port = dev->port;
+
+	struct sas_port *sas_port = dev_to_sas_port(dev->rphy->dev.parent);
+
+	if (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE
+			|| dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+		sas_del_parent_port(dev);
+
+	/* expander can not come to this branch */
+	if (list_empty(&dev->dev_list_node)) {
+		sas_rphy_free(dev->rphy);
+		sas_unregister_fail_dev(port, dev);
+		goto out;
+	}
+
+	if (test_and_clear_bit(SAS_DEV_PROBE_FAIL, &dev->state)) {
+		/* this rphy never saw sas_rphy_add */
+		sas_rphy_free(dev->rphy);
+		sas_unregister_common_dev(port, dev);
+
+		goto out;
+	}
+
+	sas_remove_children(&dev->rphy->dev);
+	sas_rphy_delete(dev->rphy);
+	sas_unregister_common_dev(port, dev);
+
+out:
+	if (!sas_port->num_phys)
+		sas_port_delete(sas_port);
+
+	kfree(ev);
+ }
+ 
+
 static void sas_suspend_devices(struct work_struct *work)
 {
 	struct asd_sas_phy *phy;
@@ -260,6 +312,9 @@ static void sas_suspend_devices(struct work_struct *work)
 	list_for_each_entry(dev, &port->dev_list, dev_list_node)
 		sas_notify_lldd_dev_gone(dev);
 
+	list_for_each_entry(dev, &port->expander_list, dev_list_node)
+		sas_notify_lldd_dev_gone(dev);
+
 	/* we are suspending, so we know events are disabled and
 	 * phy_list is not being mutated
 	 */
@@ -281,6 +336,29 @@ static void sas_resume_devices(struct work_struct *work)
 	sas_resume_sata(port);
 }
 
+const work_func_t sas_dev_event_fns[SAS_DEVICE_NUM_EVENTS] = {
+		[SAS_DEVICE_ADD] = sas_add_device,
+		[SAS_DEVICE_DEL] = sas_del_device,
+	};
+
+int sas_notify_device_event(struct domain_device *dev, enum sas_device_event_type ev)
+{
+	struct sas_device_event *evt;
+
+	BUG_ON(ev >= SAS_DEVICE_NUM_EVENTS);
+
+	evt = kmalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt)
+		return 0;
+
+	INIT_WORK(&evt->work, sas_dev_event_fns[ev]);
+	evt->device = dev;
+	evt->event = ev;
+
+	return queue_work(sas_dev_wq, &evt->work);
+}
+
+
 /**
  * sas_discover_end_dev -- discover an end device (SSP, etc)
  * @end: pointer to domain device of interest
@@ -294,7 +372,7 @@ int sas_discover_end_dev(struct domain_device *dev)
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
 		return res;
-	sas_discover_event(dev->port, DISCE_PROBE);
+	sas_notify_device_event(dev, SAS_DEVICE_ADD);
 
 	return 0;
 }
@@ -326,21 +404,49 @@ void sas_free_device(struct kref *kref)
 	kfree(dev);
 }
 
+static void sas_unregister_fail_dev(struct asd_sas_port *port,
+				struct domain_device *dev)
+{
+	sas_notify_lldd_dev_gone(dev);
+
+	/* race with discovery */
+	mutex_lock(&port->ha->disco_mutex);
+	if (!dev->parent)
+		dev->port->port_dev = NULL;
+	else
+		list_del_init(&dev->siblings);
+
+	mutex_unlock(&port->ha->disco_mutex);
+
+	sas_put_device(dev);
+}
+
+
 static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	struct sas_ha_struct *ha = port->ha;
 
 	sas_notify_lldd_dev_gone(dev);
+
+	/* race with discovery */
+	mutex_lock(&port->ha->disco_mutex);
+
 	if (!dev->parent)
 		dev->port->port_dev = NULL;
 	else
 		list_del_init(&dev->siblings);
 
-	spin_lock_irq(&port->dev_list_lock);
-	list_del_init(&dev->dev_list_node);
-	if (dev_is_sata(dev))
-		sas_ata_end_eh(dev->sata_dev.ap);
-	spin_unlock_irq(&port->dev_list_lock);
+	if (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE
+		|| dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		list_del_init(&dev->dev_list_node);
+	} else {
+		spin_lock_irq(&port->dev_list_lock);
+		list_del_init(&dev->dev_list_node);
+		if (dev_is_sata(dev))
+			sas_ata_end_eh(dev->sata_dev.ap);
+		spin_unlock_irq(&port->dev_list_lock);
+	}
+	mutex_unlock(&port->ha->disco_mutex);
 
 	spin_lock_irq(&ha->lock);
 	if (dev->dev_type == SAS_END_DEVICE &&
@@ -353,53 +459,36 @@ static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_d
 	sas_put_device(dev);
 }
 
-static void sas_destruct_devices(struct work_struct *work)
-{
-	struct domain_device *dev, *n;
-	struct sas_discovery_event *ev = to_sas_discovery_event(work);
-	struct asd_sas_port *port = ev->port;
-
-	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
-
-	list_for_each_entry_safe(dev, n, &port->destroy_list, disco_list_node) {
-		list_del_init(&dev->disco_list_node);
-
-		sas_remove_children(&dev->rphy->dev);
-		sas_rphy_delete(dev->rphy);
-		sas_unregister_common_dev(port, dev);
-	}
-}
-
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
-	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
-	    !list_empty(&dev->disco_list_node)) {
-		/* this rphy never saw sas_rphy_add */
-		list_del_init(&dev->disco_list_node);
-		sas_rphy_free(dev->rphy);
-		sas_unregister_common_dev(port, dev);
-		return;
-	}
-
-	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
-		sas_rphy_unlink(dev->rphy);
-		list_move_tail(&dev->disco_list_node, &port->destroy_list);
-		sas_discover_event(dev->port, DISCE_DESTRUCT);
-	}
+	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state))
+		sas_notify_device_event(dev, SAS_DEVICE_DEL);
 }
 
 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 {
 	struct domain_device *dev, *n;
 
+	/* race with device add or device delete */
+	mutex_lock(&port->ha->disco_mutex);
+
+	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
+		sas_unregister_dev(port, dev);
+
 	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node) {
 		if (gone)
 			set_bit(SAS_DEV_GONE, &dev->state);
 		sas_unregister_dev(port, dev);
 	}
 
-	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
+	list_for_each_entry_safe_reverse(dev, n,
+				&port->expander_list, dev_list_node) {
+		if (gone)
+			set_bit(SAS_DEV_GONE, &dev->state);
+
 		sas_unregister_dev(port, dev);
+	}
+	mutex_unlock(&port->ha->disco_mutex);
 
 	port->port->rphy = NULL;
 
@@ -427,6 +516,8 @@ void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
 
 /* ---------- Discovery and Revalidation ---------- */
 
+#define SAS_MAX_WAIT_RESCOURCE_CLEAR_TIME (3 * 60)
+
 /**
  * sas_discover_domain -- discover the domain
  * @port: port to the domain of interest
@@ -445,9 +536,36 @@ static void sas_discover_domain(struct work_struct *work)
 
 	clear_bit(DISCE_DISCOVER_DOMAIN, &port->disc.pending);
 
-	if (port->port_dev)
-		return;
+	/* if port_dev still valid, may another hot-remove is
+	 * processing, max wait time is 3 minutes */
+	if (port->port_dev) {
+		int cnt = 0;
+
+		while (1) {
+			msleep(100);
+
+			mutex_lock(&port->ha->disco_mutex);
+			if (list_empty(&port->dev_list)
+				&& list_empty(&port->expander_list)
+				&& list_empty(&port->disco_list)) {
+				mutex_unlock(&port->ha->disco_mutex);
+				break;
+			}
+			mutex_unlock(&port->ha->disco_mutex);
+
+			cnt++;
+			if (cnt > SAS_MAX_WAIT_RESCOURCE_CLEAR_TIME * 10) {
+				SAS_DPRINTK(
+				"Timeout for wait port %d clear, pid:%d\n",
+					port->id,
+					task_pid_nr(current));
+				cnt = 0;
+				return;
+			}
+		}
+	}
 
+	mutex_lock(&port->ha->disco_mutex);
 	error = sas_get_port_device(port);
 	if (error)
 		return;
@@ -482,14 +600,13 @@ static void sas_discover_domain(struct work_struct *work)
 	if (error) {
 		sas_rphy_free(dev->rphy);
 		list_del_init(&dev->disco_list_node);
-		spin_lock_irq(&port->dev_list_lock);
 		list_del_init(&dev->dev_list_node);
-		spin_unlock_irq(&port->dev_list_lock);
 
 		sas_put_device(dev);
 		port->port_dev = NULL;
 	}
 
+	mutex_unlock(&port->ha->disco_mutex);
 	SAS_DPRINTK("DONE DISCOVERY on port %d, pid:%d, result:%d\n", port->id,
 		    task_pid_nr(current), error);
 }
@@ -578,10 +695,8 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
 	static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
 		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
 		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
-		[DISCE_PROBE] = sas_probe_devices,
 		[DISCE_SUSPEND] = sas_suspend_devices,
 		[DISCE_RESUME] = sas_resume_devices,
-		[DISCE_DESTRUCT] = sas_destruct_devices,
 	};
 
 	disc->pending = 0;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 022bb6e..eb00331 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -643,9 +643,25 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
 	if (SAS_ADDR(port->sas_addr) == SAS_ADDR(sas_addr))
 		return 1;
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr))
+		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr)) {
+			/* ignore the device that has been gone */
+			if (sas_dev_gone(dev))
+				continue;
+
+			return 1;
+		}
+	}
+
+	list_for_each_entry(dev, &port->expander_list, dev_list_node) {
+		if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr)) {
+			/* ignore the device that has been gone */
+			if (sas_dev_gone(dev))
+				continue;
+
 			return 1;
+		}
 	}
+
 	return 0;
 }
 
@@ -659,6 +675,9 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
 
+	if (!dev)
+		return -ENODEV;
+
 	req = alloc_smp_req(RPEL_REQ_SIZE);
 	if (!req)
 		return -ENOMEM;
@@ -792,7 +811,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
 	if (!phy->port) {
-		phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
+		phy->port = sas_port_alloc_num(&parent->rphy->dev);
 		if (unlikely(!phy->port))
 			goto out_err;
 		if (unlikely(sas_port_add(phy->port) != 0)) {
@@ -868,9 +887,6 @@ static struct domain_device *sas_ex_discover_end_dev(
  out_list_del:
 	sas_rphy_free(child->rphy);
 	list_del(&child->disco_list_node);
-	spin_lock_irq(&parent->port->dev_list_lock);
-	list_del(&child->dev_list_node);
-	spin_unlock_irq(&parent->port->dev_list_lock);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
@@ -926,7 +942,7 @@ static struct domain_device *sas_ex_discover_expander(
 	if (!child)
 		return NULL;
 
-	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
+	phy->port = sas_port_alloc_num(&parent->rphy->dev);
 	/* FIXME: better error handling */
 	BUG_ON(sas_port_add(phy->port) != 0);
 
@@ -964,16 +980,12 @@ static struct domain_device *sas_ex_discover_expander(
 	sas_fill_in_rphy(child, rphy);
 	sas_rphy_add(rphy);
 
-	spin_lock_irq(&parent->port->dev_list_lock);
-	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
-	spin_unlock_irq(&parent->port->dev_list_lock);
+	list_add_tail(&child->dev_list_node, &parent->port->expander_list);
 
 	res = sas_discover_expander(child);
 	if (res) {
 		sas_rphy_delete(rphy);
-		spin_lock_irq(&parent->port->dev_list_lock);
 		list_del(&child->dev_list_node);
-		spin_unlock_irq(&parent->port->dev_list_lock);
 		sas_put_device(child);
 		return NULL;
 	}
@@ -1130,6 +1142,9 @@ static int sas_check_level_subtractive_boundary(struct domain_device *dev)
 	u8 sub_addr[8] = {0, };
 
 	list_for_each_entry(child, &ex->children, siblings) {
+		if (sas_dev_gone(child))
+			continue;
+
 		if (child->dev_type != SAS_EDGE_EXPANDER_DEVICE &&
 		    child->dev_type != SAS_FANOUT_EXPANDER_DEVICE)
 			continue;
@@ -1618,7 +1633,7 @@ static int sas_ex_level_discovery(struct asd_sas_port *port, const int level)
 	int res = 0;
 	struct domain_device *dev;
 
-	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+	list_for_each_entry(dev, &port->expander_list, dev_list_node) {
 		if (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
 		    dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
 			struct sas_expander_device *ex =
@@ -1849,6 +1864,9 @@ static int sas_find_bcast_dev(struct domain_device *dev,
 			SAS_DPRINTK("Expander phys DID NOT change\n");
 	}
 	list_for_each_entry(ch, &ex->children, siblings) {
+		if (sas_dev_gone(ch))
+			continue;
+
 		if (ch->dev_type == SAS_EDGE_EXPANDER_DEVICE || ch->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
 			res = sas_find_bcast_dev(ch, src_dev);
 			if (*src_dev)
@@ -1865,6 +1883,9 @@ static void sas_unregister_ex_tree(struct asd_sas_port *port, struct domain_devi
 	struct domain_device *child, *n;
 
 	list_for_each_entry_safe(child, n, &ex->children, siblings) {
+		if (sas_dev_gone(child))
+			continue;
+
 		set_bit(SAS_DEV_GONE, &child->state);
 		if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
 		    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
@@ -1884,6 +1905,9 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 	if (last) {
 		list_for_each_entry_safe(child, n,
 			&ex_dev->children, siblings) {
+			if (sas_dev_gone(child))
+				continue;
+
 			if (SAS_ADDR(child->sas_addr) ==
 			    SAS_ADDR(phy->attached_sas_addr)) {
 				set_bit(SAS_DEV_GONE, &child->state);
@@ -1916,6 +1940,9 @@ static int sas_discover_bfs_by_root_level(struct domain_device *root,
 	int res = 0;
 
 	list_for_each_entry(child, &ex_root->children, siblings) {
+		if (sas_dev_gone(child))
+			continue;
+
 		if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
 		    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
 			struct sas_expander_device *ex =
@@ -1968,6 +1995,9 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 	if (res)
 		return res;
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
+		if (sas_dev_gone(child))
+			continue;
+
 		if (SAS_ADDR(child->sas_addr) ==
 		    SAS_ADDR(ex_phy->attached_sas_addr)) {
 			if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 301d6ce..fa2a98a 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -39,6 +39,7 @@
 #include "../scsi_sas_internal.h"
 
 static struct kmem_cache *sas_task_cache;
+struct workqueue_struct *sas_dev_wq;
 
 struct sas_task *sas_alloc_task(gfp_t flags)
 {
@@ -131,6 +132,12 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 	INIT_LIST_HEAD(&sas_ha->defer_q);
 	INIT_LIST_HEAD(&sas_ha->eh_dev_q);
 
+	sas_dev_wq = create_singlethread_workqueue("sas_dev_wq");
+	if (!sas_dev_wq) {
+		error = -EINVAL;
+		return error;
+	}
+
 	error = sas_register_phys(sas_ha);
 	if (error) {
 		printk(KERN_NOTICE "couldn't register sas phys:%d\n", error);
@@ -184,6 +191,7 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 	__sas_drain_work(sas_ha);
 	mutex_unlock(&sas_ha->drain_mutex);
 
+	destroy_workqueue(sas_dev_wq);
 	return 0;
 }
 
@@ -251,7 +259,12 @@ static int transport_sas_phy_reset(struct sas_phy *phy, int hard_reset)
 	} else {
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
-		struct domain_device *ata_dev = sas_ex_to_ata(ddev, phy->number);
+		struct domain_device *ata_dev;
+
+		if (!ddev)
+			return -ENODEV;
+
+		ata_dev = sas_ex_to_ata(ddev, phy->number);
 
 		if (ata_dev && !hard_reset) {
 			sas_ata_schedule_reset(ata_dev);
@@ -287,6 +300,9 @@ static int sas_phy_enable(struct sas_phy *phy, int enable)
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
 
+		if (!ddev)
+			return -ENODEV;
+
 		if (enable)
 			ret = transport_sas_phy_reset(phy, 0);
 		else
@@ -319,6 +335,10 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 	} else {
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
+
+		if (!ddev)
+			return -ENODEV;
+
 		ret = sas_smp_phy_control(ddev, phy->number, reset_type, NULL);
 	}
 	return ret;
@@ -355,6 +375,10 @@ int sas_set_phy_speed(struct sas_phy *phy,
 	} else {
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
+
+		if (!ddev)
+			return -ENODEV;
+
 		ret = sas_smp_phy_control(ddev, phy->number,
 					  PHY_FUNC_LINK_RESET, rates);
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 79c7c48..23a00ca 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -51,6 +51,29 @@ struct sas_phy_data {
 	struct sas_work enable_work;
 };
 
+enum sas_device_event_type {
+	SAS_DEVICE_ADD   = 0U,
+	SAS_DEVICE_DEL = 1,
+	SAS_DEVICE_NUM_EVENTS
+};
+
+struct sas_device_event {
+	struct work_struct work;
+	struct domain_device *device;
+	enum sas_device_event_type event;
+};
+
+static inline struct sas_device_event *to_sas_device_event(struct work_struct *work)
+{
+	struct sas_device_event *ev = container_of(work, typeof(*ev), work);
+
+	return ev;
+}
+
+extern struct workqueue_struct *sas_dev_wq;
+extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
+extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
+
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
 int sas_show_class(enum sas_class class, char *buf);
@@ -99,8 +122,8 @@ void sas_hae_reset(struct work_struct *work);
 
 void sas_free_device(struct kref *kref);
 
-extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
-extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
+int sas_notify_device_event(struct domain_device *dev, 
+	enum sas_device_event_type ev);
 
 #ifdef CONFIG_SCSI_SAS_HOST_SMP
 extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
@@ -122,6 +145,7 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		    func, dev->parent ? "exp-attached" :
 					    "direct-attached",
 		    SAS_ADDR(dev->sas_addr), err);
+	set_bit(SAS_DEV_PROBE_FAIL, &dev->state);
 	sas_unregister_dev(dev->port, dev);
 }
 
@@ -172,7 +196,7 @@ static inline void sas_add_parent_port(struct domain_device *dev, int phy_id)
 	struct ex_phy *ex_phy = &ex->ex_phy[phy_id];
 
 	if (!ex->parent_port) {
-		ex->parent_port = sas_port_alloc(&dev->rphy->dev, phy_id);
+		ex->parent_port = sas_port_alloc_num(&dev->rphy->dev);
 		/* FIXME: error handling */
 		BUG_ON(!ex->parent_port);
 		BUG_ON(sas_port_add(ex->parent_port));
@@ -181,6 +205,15 @@ static inline void sas_add_parent_port(struct domain_device *dev, int phy_id)
 	sas_port_add_phy(ex->parent_port, ex_phy->phy);
 }
 
+static inline void sas_del_parent_port(struct domain_device *dev)
+{
+	struct expander_device *ex = &dev->ex_dev;
+
+	if (ex->parent_port)
+		sas_port_delete(ex->parent_port);
+}
+
+
 static inline struct domain_device *sas_alloc_device(void)
 {
 	struct domain_device *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -200,4 +233,11 @@ static inline void sas_put_device(struct domain_device *dev)
 	kref_put(&dev->kref, sas_free_device);
 }
 
+static inline int sas_dev_gone(struct domain_device *dev)
+{
+	return (test_bit(SAS_DEV_GONE, &dev->state) 
+			|| test_bit(SAS_DEV_PROBE_FAIL, &dev->state)
+			|| test_bit(SAS_DEV_DESTROY, &dev->state));
+}
+
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 6364346..ef4fdc9 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -61,6 +61,14 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 	 * 2/ force the next revalidation to check all expander phys
 	 */
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
+		int rc;
+
+		rc = sas_notify_lldd_dev_found(dev);
+		if (rc)
+			sas_unregister_dev(port, dev);
+	}
+
+	list_for_each_entry(dev, &port->expander_list, dev_list_node) {
 		int i, rc;
 
 		rc = sas_notify_lldd_dev_found(dev);
@@ -173,7 +181,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	if (!port->port) {
-		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
+		port->port = sas_port_alloc_num(phy->phy->dev.parent);
 		BUG_ON(!port->port);
 		sas_port_add(port->port);
 	}
@@ -317,7 +325,7 @@ static void sas_init_port(struct asd_sas_port *port,
 	port->id = i;
 	INIT_LIST_HEAD(&port->dev_list);
 	INIT_LIST_HEAD(&port->disco_list);
-	INIT_LIST_HEAD(&port->destroy_list);
+	INIT_LIST_HEAD(&port->expander_list);
 	spin_lock_init(&port->phy_list_lock);
 	INIT_LIST_HEAD(&port->phy_list);
 	port->ha = sas_ha;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 519dac4..e3ce60f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -836,12 +836,35 @@ struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy)
 		spin_lock(&port->dev_list_lock);
 		list_for_each_entry(dev, &port->dev_list, dev_list_node) {
 			if (rphy == dev->rphy) {
+				if (sas_dev_gone(dev)) {
+					SAS_DPRINTK(
+					"%s, ignore device %llx state %lx\n",
+					 __func__, SAS_ADDR(dev->sas_addr),
+					 dev->state);
+					continue;
+				}
+
 				found_dev = dev;
 				spin_unlock(&port->dev_list_lock);
 				goto found;
 			}
 		}
 		spin_unlock(&port->dev_list_lock);
+
+		list_for_each_entry(dev, &port->expander_list, dev_list_node) {
+			if (rphy == dev->rphy) {
+				if (sas_dev_gone(dev)) {
+					SAS_DPRINTK(
+					"%s, ignore device %llx state %lx\n",
+					 __func__, SAS_ADDR(dev->sas_addr),
+					 dev->state);
+					continue;
+				}
+
+				found_dev = dev;
+				goto found;
+			}
+		}
 	}
  found:
 	spin_unlock_irqrestore(&ha->phy_port_lock, flags);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 6c25173..334d512 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -181,7 +181,8 @@ struct ssp_device {
 enum {
 	SAS_DEV_GONE,
 	SAS_DEV_FOUND, /* device notified to lldd */
-	SAS_DEV_DESTROY,
+	SAS_DEV_PROBE_FAIL,/* device probe fail */
+	SAS_DEV_DESTROY, /* device will be destroyed from system */
 	SAS_DEV_EH_PENDING,
 	SAS_DEV_LU_RESET,
 	SAS_DEV_RESET,
@@ -268,7 +269,7 @@ struct asd_sas_port {
 	spinlock_t dev_list_lock;
 	struct list_head dev_list;
 	struct list_head disco_list;
-	struct list_head destroy_list;
+	struct list_head expander_list;
 	enum   sas_linkrate linkrate;
 
 	struct sas_work work;
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 00f41ae..a3104a1 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -44,7 +44,7 @@ void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 		struct list_head *done_q);
 void sas_ata_schedule_reset(struct domain_device *dev);
 void sas_ata_wait_eh(struct domain_device *dev);
-void sas_probe_sata(struct asd_sas_port *port);
+void sas_probe_sata_device(struct domain_device *dev);
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
 void sas_ata_end_eh(struct ata_port *ap);
@@ -80,7 +80,7 @@ static inline void sas_ata_wait_eh(struct domain_device *dev)
 {
 }
 
-static inline void sas_probe_sata(struct asd_sas_port *port)
+static inline void sas_probe_sata_device(struct domain_device *dev)
 {
 }
 
-- 
2.5.0
