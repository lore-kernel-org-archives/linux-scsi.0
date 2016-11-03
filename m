From: John Garry <john.garry@huawei.com>
Subject: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Thu, 3 Nov 2016 22:58:40 +0800
Message-ID: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, dan.j.williams@intel.com, john.garry2@mail.dcu.ie, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The following patch introduces an annoying WARN
when a device is removed from the SAS topology:
[SCSI] libsas: prevent domain rediscovery competing with ata error handling

A sample WARN is as follows:
[  236.842227] WARNING: CPU: 7 PID: 1520 at fs/sysfs/group.c:237 sysfs_remove_group+0x90/0x98
[  236.850465] Modules linked in:
[  236.853544]
[  236.855045] CPU: 7 PID: 1520 Comm: kworker/u64:4 Tainted: G        W       4.9.0-rc1-15310-g3fbc29e-dirty #676
[  236.865010] Hardware name: Huawei Taishan 2180 /D03, BIOS Estuary v2.3 D03 UEFI 08/17/2016
[  236.873249] Workqueue: scsi_wq_0 sas_destruct_devices
[  236.878317] task: ffff8027ba31b200 task.stack: ffff8027b9d44000
[  236.884225] PC is at sysfs_remove_group+0x90/0x98
[  236.888920] LR is at sysfs_remove_group+0x90/0x98
[  236.893616] pc : [<ffff000008256df8>] lr : [<ffff000008256df8>] pstate: 60000145
[  236.900989] sp : ffff8027b9d47bf0

< snip >

[  237.116463] [<ffff000008256df8>] sysfs_remove_group+0x90/0x98
[  237.122197] [<ffff00000851fe68>] dpm_sysfs_remove+0x58/0x68
[  237.127758] [<ffff000008513678>] device_del+0x40/0x218
[  237.132886] [<ffff000008513864>] device_unregister+0x14/0x2c
[  237.138536] [<ffff0000083670c4>] bsg_unregister_queue+0x5c/0xa0
[  237.144442] [<ffff00000855b984>] sas_rphy_remove+0x44/0x80
[  237.149915] [<ffff00000855b9d4>] sas_rphy_delete+0x14/0x28
[  237.155388] [<ffff00000855f9d8>] sas_destruct_devices+0x64/0x98
[  237.161293] [<ffff0000080d2c1c>] process_one_work+0x128/0x2e4
[  237.167027] [<ffff0000080d2e30>] worker_thread+0x58/0x434
[  237.172415] [<ffff0000080d8c24>] kthread+0xd4/0xe8
[  237.177198] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[  237.182557] sysfs group 'power' not found for kobject 'end_device-0:0:5'

(this can be really huge when an expander is unplugged)

The problem is with the process of sas_port and domain_device
destruction in domain revalidation. There is a 2-stage process:
In domain revalidation (which runs in work queue context), if a
domain_device is discovered to be gone, then the following happens:
- the domain_device is queued for destruction in a separate work item
- the associated sas_port is destroyed immediately

This causes a problem in that the sas_port associated with
a domain_device is destroyed prior the domain_device: this causes
the sysfs WARN. Essentially the "rug has been pulled from underneath".

Also, likewise, when a root port is deformed due to loss of signal,
we have the same issue.

To solve, destroy the sas_port in a separate work item to which
we do the domain revalidation with a new discovery event, as follows:
- When a domain_device is detected to be gone, the domain_device is
  queued for destruction in a separate work item. The associated
  sas_port is also queued for destruction in another separate work item
  (needs to be queued 2nd)
- the domain_device is destroyed
- the sas_port is destroyed
[similar is done for loss of signal event, in sas_port_deformed()].

Fixes: 87c8331fcf72e501c3a3c0cdc5c [SCSI] libsas: prevent domain
rediscovery competing with ata error handling

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de662..01d0fe2 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -361,7 +361,7 @@ static void sas_destruct_devices(struct work_struct *work)
 
 	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
 
-	list_for_each_entry_safe(dev, n, &port->destroy_list, disco_list_node) {
+	list_for_each_entry_safe(dev, n, &port->dev_destroy_list, disco_list_node) {
 		list_del_init(&dev->disco_list_node);
 
 		sas_remove_children(&dev->rphy->dev);
@@ -383,7 +383,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 
 	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
 		sas_rphy_unlink(dev->rphy);
-		list_move_tail(&dev->disco_list_node, &port->destroy_list);
+		list_move_tail(&dev->disco_list_node, &port->dev_destroy_list);
 		sas_discover_event(dev->port, DISCE_DESTRUCT);
 	}
 }
@@ -525,6 +525,28 @@ static void sas_revalidate_domain(struct work_struct *work)
 	mutex_unlock(&ha->disco_mutex);
 }
 
+/* ---------- Async Port destruct ---------- */
+static void sas_async_port_destruct(struct work_struct *work)
+{
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
+	struct asd_sas_port *port = ev->port;
+	struct sas_port *sas_port, *n;
+
+	clear_bit(DISCE_PORT_DESTRUCT, &port->disc.pending);
+
+	list_for_each_entry_safe(sas_port, n, &port->port_destroy_list, destroy_list) {
+		list_del_init(&port->port_destroy_list);
+
+		sas_port_delete(sas_port);
+	}
+}
+
+void sas_port_destruct(struct asd_sas_port *port, struct sas_port *sas_port)
+{
+	list_move_tail(&sas_port->destroy_list, &port->port_destroy_list);
+	sas_discover_event(port, DISCE_PORT_DESTRUCT);
+}
+
 /* ---------- Events ---------- */
 
 static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
@@ -582,6 +604,7 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
 		[DISCE_SUSPEND] = sas_suspend_devices,
 		[DISCE_RESUME] = sas_resume_devices,
 		[DISCE_DESTRUCT] = sas_destruct_devices,
+		[DISCE_PORT_DESTRUCT] = sas_async_port_destruct,
 	};
 
 	disc->pending = 0;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 022bb6e..f9522a0 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1900,10 +1900,11 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	if (phy->port) {
+		struct asd_sas_port *port = found->port;
 		sas_port_delete_phy(phy->port, phy->phy);
 		sas_device_set_phy(found, phy->port);
 		if (phy->port->num_phys == 0)
-			sas_port_delete(phy->port);
+			sas_port_destruct(port, phy->port);
 		phy->port = NULL;
 	}
 }
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297..1a32f86 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -219,7 +219,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 
 	if (port->num_phys == 1) {
 		sas_unregister_domain_devices(port, gone);
-		sas_port_delete(port->port);
+		sas_port_destruct(port, port->port);
 		port->port = NULL;
 	} else {
 		sas_port_delete_phy(port->port, phy->phy);
@@ -322,7 +322,8 @@ static void sas_init_port(struct asd_sas_port *port,
 	port->id = i;
 	INIT_LIST_HEAD(&port->dev_list);
 	INIT_LIST_HEAD(&port->disco_list);
-	INIT_LIST_HEAD(&port->destroy_list);
+	INIT_LIST_HEAD(&port->dev_destroy_list);
+	INIT_LIST_HEAD(&port->port_destroy_list);
 	spin_lock_init(&port->phy_list_lock);
 	INIT_LIST_HEAD(&port->phy_list);
 	port->ha = sas_ha;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 60b651b..062c03c 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -934,6 +934,7 @@ struct sas_port *sas_port_alloc(struct device *parent, int port_id)
 
 	mutex_init(&port->phy_list_mutex);
 	INIT_LIST_HEAD(&port->phy_list);
+	INIT_LIST_HEAD(&port->destroy_list);
 
 	if (scsi_is_sas_expander_device(parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index dae99d7..a7953c8 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -91,7 +91,8 @@ enum discover_event {
 	DISCE_SUSPEND		= 4,
 	DISCE_RESUME		= 5,
 	DISCE_DESTRUCT		= 6,
-	DISC_NUM_EVENTS		= 7,
+	DISCE_PORT_DESTRUCT	= 7,
+	DISC_NUM_EVENTS,
 };
 
 /* ---------- Expander Devices ---------- */
@@ -268,7 +269,8 @@ struct asd_sas_port {
 	spinlock_t dev_list_lock;
 	struct list_head dev_list;
 	struct list_head disco_list;
-	struct list_head destroy_list;
+	struct list_head dev_destroy_list;
+	struct list_head port_destroy_list;
 	enum   sas_linkrate linkrate;
 
 	struct sas_work work;
@@ -702,6 +704,7 @@ extern int sas_bios_param(struct scsi_device *,
 int  sas_ex_revalidate_domain(struct domain_device *);
 
 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
+void sas_port_destruct(struct asd_sas_port *port, struct sas_port *sas_port);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
 int  sas_discover_event(struct asd_sas_port *, enum discover_event ev);
 
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 73d8709..b495aac 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -154,6 +154,7 @@ struct sas_port {
 
 	struct mutex		phy_list_mutex;
 	struct list_head	phy_list;
+	struct list_head	destroy_list; /* only used by libsas */
 };
 
 #define dev_to_sas_port(d) \
-- 
1.9.1
