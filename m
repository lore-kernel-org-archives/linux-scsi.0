From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/3] fcoe: Fibre Channel over Ethernet
Date: Tue, 18 Nov 2008 14:21:22 -0800
Message-ID: <20081118222122.2289.95781.stgit@fritz>
References: <20081118222051.2289.81361.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32902 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbYKRWV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2008 17:21:29 -0500
In-Reply-To: <20081118222051.2289.81361.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: jgarzik@redhat.com, james.smart@emulex.com, davem@davemloft.net, michaelc@cs.wisc.edu, jeffrey.t.kirsher@intel.com, jeykholt@cisco.com

Encapsulation protocol for running Fibre Channel over Ethernet interfaces.
Creates virtual Fibre Channel host adapters using libfc.

This patch leaves two WARNINGs from checkpatch.pl regarding the use of NR_CPUS.
We're using them to create per-cpu receive threads. Since these are WARNINGS
and not ERRORS we'd like to fix this issue later.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig                  |    7 
 drivers/scsi/Makefile                 |    1 
 drivers/scsi/fcoe/Makefile            |    8 
 drivers/scsi/fcoe/fc_transport_fcoe.c |  446 ++++++++++
 drivers/scsi/fcoe/fcoe_sw.c           |  488 +++++++++++
 drivers/scsi/fcoe/libfcoe.c           | 1506 +++++++++++++++++++++++++++++++++
 include/scsi/fc_transport_fcoe.h      |   54 +
 include/scsi/libfcoe.h                |  177 ++++
 8 files changed, 2687 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fcoe/Makefile
 create mode 100644 drivers/scsi/fcoe/fc_transport_fcoe.c
 create mode 100644 drivers/scsi/fcoe/fcoe_sw.c
 create mode 100644 drivers/scsi/fcoe/libfcoe.c
 create mode 100644 include/scsi/fc_transport_fcoe.h
 create mode 100644 include/scsi/libfcoe.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 860c935..a3a73ea 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -609,6 +609,13 @@ config LIBFC
 	---help---
 	  Fibre Channel library module
 
+config FCOE
+	tristate "FCoE module"
+	depends on SCSI
+	select LIBFC
+	---help---
+	  Fibre Channel over Ethernet module
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 9158dc6..b0aa59e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_LIBFC)		+= libfc/
+obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
new file mode 100644
index 0000000..b78da06
--- /dev/null
+++ b/drivers/scsi/fcoe/Makefile
@@ -0,0 +1,8 @@
+# $Id: Makefile
+
+obj-$(CONFIG_FCOE) += fcoe.o
+
+fcoe-y := \
+	libfcoe.o \
+	fcoe_sw.o \
+	fc_transport_fcoe.o
diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
new file mode 100644
index 0000000..bf7fe6f
--- /dev/null
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -0,0 +1,446 @@
+/*
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#include <linux/pci.h>
+#include <scsi/libfcoe.h>
+#include <scsi/fc_transport_fcoe.h>
+
+/* internal fcoe transport */
+struct fcoe_transport_internal {
+	struct fcoe_transport *t;
+	struct net_device *netdev;
+	struct list_head list;
+};
+
+/* fcoe transports list and its lock */
+static LIST_HEAD(fcoe_transports);
+static DEFINE_MUTEX(fcoe_transports_lock);
+
+/**
+ * fcoe_transport_default - returns ptr to the default transport fcoe_sw
+ **/
+struct fcoe_transport *fcoe_transport_default(void)
+{
+	return &fcoe_sw_transport;
+}
+
+/**
+ * fcoe_transport_to_pcidev - get the pci dev from a netdev
+ * @netdev: the netdev that pci dev will be retrived from
+ *
+ * Returns: NULL or the corrsponding pci_dev
+ **/
+struct pci_dev *fcoe_transport_pcidev(const struct net_device *netdev)
+{
+	if (!netdev->dev.parent)
+		return NULL;
+	return to_pci_dev(netdev->dev.parent);
+}
+
+/**
+ * fcoe_transport_device_lookup - find out netdev is managed by the
+ * transport
+ * assign a transport to a device
+ * @netdev: the netdev the transport to be attached to
+ *
+ * This will look for existing offload driver, if not found, it falls back to
+ * the default sw hba (fcoe_sw) as its fcoe transport.
+ *
+ * Returns: 0 for success
+ **/
+static struct fcoe_transport_internal *fcoe_transport_device_lookup(
+	struct fcoe_transport *t, struct net_device *netdev)
+{
+	struct fcoe_transport_internal *ti;
+
+	/* assign the transpor to this device */
+	mutex_lock(&t->devlock);
+	list_for_each_entry(ti, &t->devlist, list) {
+		if (ti->netdev == netdev) {
+			mutex_unlock(&t->devlock);
+			return ti;
+		}
+	}
+	mutex_unlock(&t->devlock);
+	return NULL;
+}
+/**
+ * fcoe_transport_device_add - assign a transport to a device
+ * @netdev: the netdev the transport to be attached to
+ *
+ * This will look for existing offload driver, if not found, it falls back to
+ * the default sw hba (fcoe_sw) as its fcoe transport.
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_transport_device_add(struct fcoe_transport *t,
+				     struct net_device *netdev)
+{
+	struct fcoe_transport_internal *ti;
+
+	ti = fcoe_transport_device_lookup(t, netdev);
+	if (ti) {
+		printk(KERN_DEBUG "fcoe_transport_device_add:"
+		       "device %s is already added to transport %s\n",
+		       netdev->name, t->name);
+		return -EEXIST;
+	}
+	/* allocate an internal struct to host the netdev and the list */
+	ti = kzalloc(sizeof(*ti), GFP_KERNEL);
+	if (!ti)
+		return -ENOMEM;
+
+	ti->t = t;
+	ti->netdev = netdev;
+	INIT_LIST_HEAD(&ti->list);
+	dev_hold(ti->netdev);
+
+	mutex_lock(&t->devlock);
+	list_add(&ti->list, &t->devlist);
+	mutex_unlock(&t->devlock);
+
+	printk(KERN_DEBUG "fcoe_transport_device_add:"
+		       "device %s added to transport %s\n",
+		       netdev->name, t->name);
+
+	return 0;
+}
+
+/**
+ * fcoe_transport_device_remove - remove a device from its transport
+ * @netdev: the netdev the transport to be attached to
+ *
+ * this removes the device from the transport so the given transport will
+ * not manage this device any more
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_transport_device_remove(struct fcoe_transport *t,
+					struct net_device *netdev)
+{
+	struct fcoe_transport_internal *ti;
+
+	ti = fcoe_transport_device_lookup(t, netdev);
+	if (!ti) {
+		printk(KERN_DEBUG "fcoe_transport_device_remove:"
+		       "device %s is not managed by transport %s\n",
+		       netdev->name, t->name);
+		return -ENODEV;
+	}
+	mutex_lock(&t->devlock);
+	list_del(&ti->list);
+	mutex_unlock(&t->devlock);
+	printk(KERN_DEBUG "fcoe_transport_device_remove:"
+	       "device %s removed from transport %s\n",
+	       netdev->name, t->name);
+	dev_put(ti->netdev);
+	kfree(ti);
+	return 0;
+}
+
+/**
+ * fcoe_transport_device_remove_all - remove all from transport devlist
+ *
+ * this removes the device from the transport so the given transport will
+ * not manage this device any more
+ *
+ * Returns: 0 for success
+ **/
+static void fcoe_transport_device_remove_all(struct fcoe_transport *t)
+{
+	struct fcoe_transport_internal *ti, *tmp;
+
+	mutex_lock(&t->devlock);
+	list_for_each_entry_safe(ti, tmp, &t->devlist, list) {
+		list_del(&ti->list);
+		kfree(ti);
+	}
+	mutex_unlock(&t->devlock);
+}
+
+/**
+ * fcoe_transport_match - use the bus device match function to match the hw
+ * @t: the fcoe transport
+ * @netdev:
+ *
+ * This function is used to check if the givne transport wants to manage the
+ * input netdev. if the transports implements the match function, it will be
+ * called, o.w. we just compare the pci vendor and device id.
+ *
+ * Returns: true for match up
+ **/
+static bool fcoe_transport_match(struct fcoe_transport *t,
+				struct net_device *netdev)
+{
+	/* match transport by vendor and device id */
+	struct pci_dev *pci;
+
+	pci = fcoe_transport_pcidev(netdev);
+
+	if (pci) {
+		printk(KERN_DEBUG "fcoe_transport_match:"
+		       "%s:%x:%x -- %s:%x:%x\n",
+		       t->name, t->vendor, t->device,
+		       netdev->name, pci->vendor, pci->device);
+
+		/* if transport supports match */
+		if (t->match)
+			return t->match(netdev);
+
+		/* else just compare the vendor and device id: pci only */
+		return (t->vendor == pci->vendor) && (t->device == pci->device);
+	}
+	return false;
+}
+
+/**
+ * fcoe_transport_lookup - check if the transport is already registered
+ * @t: the transport to be looked up
+ *
+ * This compares the parent device (pci) vendor and device id
+ *
+ * Returns: NULL if not found
+ *
+ * TODO - return default sw transport if no other transport is found
+ **/
+static struct fcoe_transport *fcoe_transport_lookup(
+	struct net_device *netdev)
+{
+	struct fcoe_transport *t;
+
+	mutex_lock(&fcoe_transports_lock);
+	list_for_each_entry(t, &fcoe_transports, list) {
+		if (fcoe_transport_match(t, netdev)) {
+			mutex_unlock(&fcoe_transports_lock);
+			return t;
+		}
+	}
+	mutex_unlock(&fcoe_transports_lock);
+
+	printk(KERN_DEBUG "fcoe_transport_lookup:"
+	       "use default transport for %s\n", netdev->name);
+	return fcoe_transport_default();
+}
+
+/**
+ * fcoe_transport_register - adds a fcoe transport to the fcoe transports list
+ * @t: ptr to the fcoe transport to be added
+ *
+ * Returns: 0 for success
+ **/
+int fcoe_transport_register(struct fcoe_transport *t)
+{
+	struct fcoe_transport *tt;
+
+	/* TODO - add fcoe_transport specific initialization here */
+	mutex_lock(&fcoe_transports_lock);
+	list_for_each_entry(tt, &fcoe_transports, list) {
+		if (tt == t) {
+			mutex_unlock(&fcoe_transports_lock);
+			return -EEXIST;
+		}
+	}
+	list_add_tail(&t->list, &fcoe_transports);
+	mutex_unlock(&fcoe_transports_lock);
+
+	mutex_init(&t->devlock);
+	INIT_LIST_HEAD(&t->devlist);
+
+	printk(KERN_DEBUG "fcoe_transport_register:%s\n", t->name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_transport_register);
+
+/**
+ * fcoe_transport_unregister - remove the tranport fro the fcoe transports list
+ * @t: ptr to the fcoe transport to be removed
+ *
+ * Returns: 0 for success
+ **/
+int fcoe_transport_unregister(struct fcoe_transport *t)
+{
+	struct fcoe_transport *tt, *tmp;
+
+	mutex_lock(&fcoe_transports_lock);
+	list_for_each_entry_safe(tt, tmp, &fcoe_transports, list) {
+		if (tt == t) {
+			list_del(&t->list);
+			mutex_unlock(&fcoe_transports_lock);
+			fcoe_transport_device_remove_all(t);
+			printk(KERN_DEBUG "fcoe_transport_unregister:%s\n",
+			       t->name);
+			return 0;
+		}
+	}
+	mutex_unlock(&fcoe_transports_lock);
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(fcoe_transport_unregister);
+
+/*
+ * fcoe_load_transport_driver - load an offload driver by alias name
+ * @netdev: the target net device
+ *
+ * Requests for an offload driver module as the fcoe transport, if fails, it
+ * falls back to use the SW HBA (fcoe_sw) as its transport
+ *
+ * TODO -
+ * 	1. supports only PCI device
+ * 	2. needs fix for VLAn and bonding
+ * 	3. pure hw fcoe hba may not have netdev
+ *
+ * Returns: 0 for success
+ **/
+int fcoe_load_transport_driver(struct net_device *netdev)
+{
+	struct pci_dev *pci;
+	struct device *dev = netdev->dev.parent;
+
+	if (fcoe_transport_lookup(netdev)) {
+		/* load default transport */
+		printk(KERN_DEBUG "fcoe: already loaded transport for %s\n",
+		       netdev->name);
+		return -EEXIST;
+	}
+
+	pci = to_pci_dev(dev);
+	if (dev->bus != &pci_bus_type) {
+		printk(KERN_DEBUG "fcoe: support noly PCI device\n");
+		return -ENODEV;
+	}
+	printk(KERN_DEBUG "fcoe: loading driver fcoe-pci-0x%04x-0x%04x\n",
+	       pci->vendor, pci->device);
+
+	return request_module("fcoe-pci-0x%04x-0x%04x",
+			      pci->vendor, pci->device);
+
+}
+EXPORT_SYMBOL_GPL(fcoe_load_transport_driver);
+
+/**
+ * fcoe_transport_attach - load transport to fcoe
+ * @netdev: the netdev the transport to be attached to
+ *
+ * This will look for existing offload driver, if not found, it falls back to
+ * the default sw hba (fcoe_sw) as its fcoe transport.
+ *
+ * Returns: 0 for success
+ **/
+int fcoe_transport_attach(struct net_device *netdev)
+{
+	struct fcoe_transport *t;
+
+	/* find the corresponding transport */
+	t = fcoe_transport_lookup(netdev);
+	if (!t) {
+		printk(KERN_DEBUG "fcoe_transport_attach"
+		       ":no transport for %s:use %s\n",
+		       netdev->name, t->name);
+		return -ENODEV;
+	}
+	/* add to the transport */
+	if (fcoe_transport_device_add(t, netdev)) {
+		printk(KERN_DEBUG "fcoe_transport_attach"
+		       ":failed to add %s to tramsport %s\n",
+		       netdev->name, t->name);
+		return -EIO;
+	}
+	/* transport create function */
+	if (t->create)
+		t->create(netdev);
+
+	printk(KERN_DEBUG "fcoe_transport_attach:transport %s for %s\n",
+	       t->name, netdev->name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_transport_attach);
+
+/**
+ * fcoe_transport_release - unload transport from fcoe
+ * @netdev: the net device on which fcoe is to be released
+ *
+ * Returns: 0 for success
+ **/
+int fcoe_transport_release(struct net_device *netdev)
+{
+	struct fcoe_transport *t;
+
+	/* find the corresponding transport */
+	t = fcoe_transport_lookup(netdev);
+	if (!t) {
+		printk(KERN_DEBUG "fcoe_transport_release:"
+		       "no transport for %s:use %s\n",
+		       netdev->name, t->name);
+		return -ENODEV;
+	}
+	/* remove the device from the transport */
+	if (fcoe_transport_device_remove(t, netdev)) {
+		printk(KERN_DEBUG "fcoe_transport_release:"
+		       "failed to add %s to tramsport %s\n",
+		       netdev->name, t->name);
+		return -EIO;
+	}
+	/* transport destroy function */
+	if (t->destroy)
+		t->destroy(netdev);
+
+	printk(KERN_DEBUG "fcoe_transport_release:"
+	       "device %s dettached from transport %s\n",
+	       netdev->name, t->name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_transport_release);
+
+/**
+ * fcoe_transport_init - initializes fcoe transport layer
+ *
+ * This prepares for the fcoe transport layer
+ *
+ * Returns: none
+ **/
+int __init fcoe_transport_init(void)
+{
+	INIT_LIST_HEAD(&fcoe_transports);
+	mutex_init(&fcoe_transports_lock);
+	return 0;
+}
+
+/**
+ * fcoe_transport_exit - cleans up the fcoe transport layer
+ * This cleans up the fcoe transport layer. removing any transport on the list,
+ * note that the transport destroy func is not called here.
+ *
+ * Returns: none
+ **/
+int __exit fcoe_transport_exit(void)
+{
+	struct fcoe_transport *t, *tmp;
+
+	mutex_lock(&fcoe_transports_lock);
+	list_for_each_entry_safe(t, tmp, &fcoe_transports, list) {
+		list_del(&t->list);
+		mutex_unlock(&fcoe_transports_lock);
+		fcoe_transport_device_remove_all(t);
+		mutex_lock(&fcoe_transports_lock);
+	}
+	mutex_unlock(&fcoe_transports_lock);
+	return 0;
+}
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
new file mode 100644
index 0000000..27c5db8
--- /dev/null
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -0,0 +1,488 @@
+/*
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
+#include <net/rtnetlink.h>
+
+#include <scsi/fc/fc_els.h>
+#include <scsi/fc/fc_encaps.h>
+#include <scsi/fc/fc_fs.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+
+#include <scsi/libfc.h>
+#include <scsi/libfcoe.h>
+#include <scsi/fc_transport_fcoe.h>
+
+#define FCOE_SW_VERSION	"0.1"
+#define	FCOE_SW_NAME	"fcoesw"
+#define	FCOE_SW_VENDOR	"Open-FCoE.org"
+
+#define FCOE_MAX_LUN		255
+#define FCOE_MAX_FCP_TARGET	256
+
+#define FCOE_MAX_OUTSTANDING_COMMANDS	1024
+
+#define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
+#define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
+
+static struct scsi_transport_template *scsi_transport_fcoe_sw;
+
+struct fc_function_template fcoe_sw_transport_function = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_active_fc4s = 1,
+	.show_host_maxframe_size = 1,
+
+	.show_host_port_id = 1,
+	.show_host_supported_speeds = 1,
+	.get_host_speed = fc_get_host_speed,
+	.show_host_speed = 1,
+	.show_host_port_type = 1,
+	.get_host_port_state = fc_get_host_port_state,
+	.show_host_port_state = 1,
+	.show_host_symbolic_name = 1,
+
+	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.show_host_fabric_name = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+	.get_fc_host_stats = fc_get_host_stats,
+	.issue_fc_host_lip = fcoe_reset,
+
+	.terminate_rport_io = fc_rport_terminate_io,
+};
+
+static struct scsi_host_template fcoe_sw_shost_template = {
+	.module = THIS_MODULE,
+	.name = "FCoE Driver",
+	.proc_name = FCOE_SW_NAME,
+	.queuecommand = fc_queuecommand,
+	.eh_abort_handler = fc_eh_abort,
+	.eh_device_reset_handler = fc_eh_device_reset,
+	.eh_host_reset_handler = fc_eh_host_reset,
+	.slave_alloc = fc_slave_alloc,
+	.change_queue_depth = fc_change_queue_depth,
+	.change_queue_type = fc_change_queue_type,
+	.this_id = -1,
+	.cmd_per_lun = 32,
+	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.sg_tablesize = 4,
+	.max_sectors = 0xffff,
+};
+
+/*
+ * fcoe_sw_lport_config - sets up the fc_lport
+ * @lp: ptr to the fc_lport
+ * @shost: ptr to the parent scsi host
+ *
+ * Returns: 0 for success
+ *
+ */
+static int fcoe_sw_lport_config(struct fc_lport *lp)
+{
+	int i = 0;
+
+	lp->link_status = 0;
+	lp->max_retry_count = 3;
+	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
+	lp->r_a_tov = 2 * 2 * 1000;
+	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
+			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
+
+	/*
+	 * allocate per cpu stats block
+	 */
+	for_each_online_cpu(i)
+		lp->dev_stats[i] = kzalloc(sizeof(struct fcoe_dev_stats),
+					   GFP_KERNEL);
+
+	/* lport fc_lport related configuration */
+	fc_lport_config(lp);
+
+	return 0;
+}
+
+/*
+ * fcoe_sw_netdev_config - sets up fcoe_softc for lport and network
+ * related properties
+ * @lp : ptr to the fc_lport
+ * @netdev : ptr to the associated netdevice struct
+ *
+ * Must be called after fcoe_sw_lport_config() as it will use lport mutex
+ *
+ * Returns : 0 for success
+ *
+ */
+static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
+{
+	u32 mfs;
+	u64 wwnn, wwpn;
+	struct fcoe_softc *fc;
+	u8 flogi_maddr[ETH_ALEN];
+
+	/* Setup lport private data to point to fcoe softc */
+	fc = lport_priv(lp);
+	fc->lp = lp;
+	fc->real_dev = netdev;
+	fc->phys_dev = netdev;
+
+	/* Require support for get_pauseparam ethtool op. */
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
+		fc->phys_dev = vlan_dev_real_dev(netdev);
+
+	/* Do not support for bonding device */
+	if ((fc->real_dev->priv_flags & IFF_MASTER_ALB) ||
+	    (fc->real_dev->priv_flags & IFF_SLAVE_INACTIVE) ||
+	    (fc->real_dev->priv_flags & IFF_MASTER_8023AD)) {
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * Determine max frame size based on underlying device and optional
+	 * user-configured limit.  If the MFS is too low, fcoe_link_ok()
+	 * will return 0, so do this first.
+	 */
+	mfs = fc->real_dev->mtu - (sizeof(struct fcoe_hdr) +
+				   sizeof(struct fcoe_crc_eof));
+	fc_set_mfs(lp, mfs);
+
+	lp->link_status = ~FC_PAUSE & ~FC_LINK_UP;
+	if (!fcoe_link_ok(lp))
+		lp->link_status |= FC_LINK_UP;
+
+	/* offload features support */
+	if (fc->real_dev->features & NETIF_F_SG)
+		lp->sg_supp = 1;
+
+
+	skb_queue_head_init(&fc->fcoe_pending_queue);
+
+	/* setup Source Mac Address */
+	memcpy(fc->ctl_src_addr, fc->real_dev->dev_addr,
+	       fc->real_dev->addr_len);
+
+	wwnn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 1, 0);
+	fc_set_wwnn(lp, wwnn);
+	/* XXX - 3rd arg needs to be vlan id */
+	wwpn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 2, 0);
+	fc_set_wwpn(lp, wwpn);
+
+	/*
+	 * Add FCoE MAC address as second unicast MAC address
+	 * or enter promiscuous mode if not capable of listening
+	 * for multiple unicast MACs.
+	 */
+	rtnl_lock();
+	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+	dev_unicast_add(fc->real_dev, flogi_maddr, ETH_ALEN);
+	rtnl_unlock();
+
+	/*
+	 * setup the receive function from ethernet driver
+	 * on the ethertype for the given device
+	 */
+	fc->fcoe_packet_type.func = fcoe_rcv;
+	fc->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	fc->fcoe_packet_type.dev = fc->real_dev;
+	dev_add_pack(&fc->fcoe_packet_type);
+
+	return 0;
+}
+
+/*
+ * fcoe_sw_shost_config - sets up fc_lport->host
+ * @lp : ptr to the fc_lport
+ * @shost : ptr to the associated scsi host
+ *
+ * Must be called after fcoe_sw_lport_config) and fcoe_sw_netdev_config()
+ *
+ * Returns : 0 for success
+ *
+ */
+static int fcoe_sw_shost_config(struct fc_lport *lp, struct Scsi_Host *shost)
+{
+	int rc = 0;
+
+	/* lport scsi host config */
+	lp->host = shost;
+
+	lp->host->max_lun = FCOE_MAX_LUN;
+	lp->host->max_id = FCOE_MAX_FCP_TARGET;
+	lp->host->max_channel = 0;
+	lp->host->transportt = scsi_transport_fcoe_sw;
+
+	/* add the new host to the SCSI-ml */
+	rc = scsi_add_host(lp->host, NULL);
+	if (rc) {
+		FC_DBG("fcoe_sw_shost_config:error on scsi_add_host\n");
+		return rc;
+	}
+	sprintf(fc_host_symbolic_name(lp->host), "%s v%s over %s",
+		FCOE_SW_NAME, FCOE_SW_VERSION,
+		fcoe_netdev(lp)->name);
+
+	return 0;
+}
+
+/*
+ * fcoe_sw_em_config - allocates em for this lport
+ * @lp: the port that em is to allocated for
+ *
+ * Returns : 0 on success
+ */
+static inline int fcoe_sw_em_config(struct fc_lport *lp)
+{
+	BUG_ON(lp->emp);
+
+	lp->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3,
+				    FCOE_MIN_XID, FCOE_MAX_XID);
+	if (!lp->emp)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * fcoe_sw_destroy - FCoE software HBA tear-down function
+ * @netdev: ptr to the associated net_device
+ *
+ * Returns: 0 if link is OK for use by FCoE.
+ */
+static int fcoe_sw_destroy(struct net_device *netdev)
+{
+	int cpu;
+	struct fc_lport *lp = NULL;
+	struct fcoe_softc *fc;
+	u8 flogi_maddr[ETH_ALEN];
+
+	BUG_ON(!netdev);
+
+	printk(KERN_DEBUG "fcoe_sw_destroy:interface on %s\n",
+	       netdev->name);
+
+	lp = fcoe_hostlist_lookup(netdev);
+	if (!lp)
+		return -ENODEV;
+
+	fc = fcoe_softc(lp);
+
+	/* Remove the instance from fcoe's list */
+	fcoe_hostlist_remove(lp);
+
+	/* Don't listen for Ethernet packets anymore */
+	dev_remove_pack(&fc->fcoe_packet_type);
+
+	/* Cleanup the fc_lport */
+	fc_lport_destroy(lp);
+	fc_fcp_destroy(lp);
+
+	/* Detach from the scsi-ml */
+	fc_remove_host(lp->host);
+	scsi_remove_host(lp->host);
+
+	/* There are no more rports or I/O, free the EM */
+	if (lp->emp)
+		fc_exch_mgr_free(lp->emp);
+
+	/* Delete secondary MAC addresses */
+	rtnl_lock();
+	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+	dev_unicast_delete(fc->real_dev, flogi_maddr, ETH_ALEN);
+	if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
+		dev_unicast_delete(fc->real_dev, fc->data_src_addr, ETH_ALEN);
+	rtnl_unlock();
+
+	/* Free the per-CPU revieve threads */
+	fcoe_percpu_clean(lp);
+
+	/* Free existing skbs */
+	fcoe_clean_pending_queue(lp);
+
+	/* Free memory used by statistical counters */
+	for_each_online_cpu(cpu)
+		kfree(lp->dev_stats[cpu]);
+
+	/* Release the net_device and Scsi_Host */
+	dev_put(fc->real_dev);
+	scsi_host_put(lp->host);
+
+	return 0;
+}
+
+static struct libfc_function_template fcoe_sw_libfc_fcn_templ = {
+	.frame_send = fcoe_xmit,
+};
+
+/*
+ * fcoe_sw_create - this function creates the fcoe interface
+ * @netdev: pointer the associated netdevice
+ *
+ * Creates fc_lport struct and scsi_host for lport, configures lport
+ * and starts fabric login.
+ *
+ * Returns : 0 on success
+ */
+static int fcoe_sw_create(struct net_device *netdev)
+{
+	int rc;
+	struct fc_lport *lp = NULL;
+	struct fcoe_softc *fc;
+	struct Scsi_Host *shost;
+
+	BUG_ON(!netdev);
+
+	printk(KERN_DEBUG "fcoe_sw_create:interface on %s\n",
+	       netdev->name);
+
+	lp = fcoe_hostlist_lookup(netdev);
+	if (lp)
+		return -EEXIST;
+
+	shost = fcoe_host_alloc(&fcoe_sw_shost_template,
+				sizeof(struct fcoe_softc));
+	if (!shost) {
+		FC_DBG("Could not allocate host structure\n");
+		return -ENOMEM;
+	}
+	lp = shost_priv(shost);
+	fc = lport_priv(lp);
+
+	/* configure fc_lport, e.g., em */
+	rc = fcoe_sw_lport_config(lp);
+	if (rc) {
+		FC_DBG("Could not configure lport\n");
+		goto out_host_put;
+	}
+
+	/* configure lport network properties */
+	rc = fcoe_sw_netdev_config(lp, netdev);
+	if (rc) {
+		FC_DBG("Could not configure netdev for lport\n");
+		goto out_host_put;
+	}
+
+	/* configure lport scsi host properties */
+	rc = fcoe_sw_shost_config(lp, shost);
+	if (rc) {
+		FC_DBG("Could not configure shost for lport\n");
+		goto out_host_put;
+	}
+
+	/* lport exch manager allocation */
+	rc = fcoe_sw_em_config(lp);
+	if (rc) {
+		FC_DBG("Could not configure em for lport\n");
+		goto out_host_put;
+	}
+
+	/* Initialize the library */
+	rc = fcoe_libfc_config(lp, &fcoe_sw_libfc_fcn_templ);
+	if (rc) {
+		FC_DBG("Could not configure libfc for lport!\n");
+		goto out_lp_destroy;
+	}
+
+	/* add to lports list */
+	fcoe_hostlist_add(lp);
+
+	lp->boot_time = jiffies;
+
+	fc_fabric_login(lp);
+
+	dev_hold(netdev);
+
+	return rc;
+
+out_lp_destroy:
+	fc_exch_mgr_free(lp->emp); /* Free the EM */
+out_host_put:
+	scsi_host_put(lp->host);
+	return rc;
+}
+
+/*
+ * fcoe_sw_match - the fcoe sw transport match function
+ *
+ * Returns : false always
+ */
+static bool fcoe_sw_match(struct net_device *netdev)
+{
+	/* FIXME - for sw transport, always return false */
+	return false;
+}
+
+/* the sw hba fcoe transport */
+struct fcoe_transport fcoe_sw_transport = {
+	.name = "fcoesw",
+	.create = fcoe_sw_create,
+	.destroy = fcoe_sw_destroy,
+	.match = fcoe_sw_match,
+	.vendor = 0x0,
+	.device = 0xffff,
+};
+
+/*
+ * fcoe_sw_init - registers fcoe_sw_transport
+ *
+ * Returns : 0 on success
+ */
+int __init fcoe_sw_init(void)
+{
+	/* attach to scsi transport */
+	scsi_transport_fcoe_sw =
+		fc_attach_transport(&fcoe_sw_transport_function);
+	if (!scsi_transport_fcoe_sw) {
+		printk(KERN_ERR "fcoe_sw_init:fc_attach_transport() failed\n");
+		return -ENODEV;
+	}
+	/* register sw transport */
+	fcoe_transport_register(&fcoe_sw_transport);
+	return 0;
+}
+
+/*
+ * fcoe_sw_exit - unregisters fcoe_sw_transport
+ *
+ * Returns : 0 on success
+ */
+int __exit fcoe_sw_exit(void)
+{
+	/* dettach the transport */
+	fc_release_transport(scsi_transport_fcoe_sw);
+	fcoe_transport_unregister(&fcoe_sw_transport);
+	return 0;
+}
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
new file mode 100644
index 0000000..4ce9a2d
--- /dev/null
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -0,0 +1,1506 @@
+/*
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <linux/kthread.h>
+#include <linux/crc32.h>
+#include <linux/cpu.h>
+#include <linux/fs.h>
+#include <linux/sysfs.h>
+#include <linux/ctype.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+#include <net/rtnetlink.h>
+
+#include <scsi/fc/fc_encaps.h>
+
+#include <scsi/libfc.h>
+#include <scsi/fc_frame.h>
+#include <scsi/libfcoe.h>
+#include <scsi/fc_transport_fcoe.h>
+
+static int debug_fcoe;
+
+#define FCOE_MAX_QUEUE_DEPTH  256
+
+/* destination address mode */
+#define FCOE_GW_ADDR_MODE	    0x00
+#define FCOE_FCOUI_ADDR_MODE	    0x01
+
+#define FCOE_WORD_TO_BYTE  4
+
+MODULE_AUTHOR("Open-FCoE.org");
+MODULE_DESCRIPTION("FCoE");
+MODULE_LICENSE("GPL");
+
+/* fcoe host list */
+LIST_HEAD(fcoe_hostlist);
+DEFINE_RWLOCK(fcoe_hostlist_lock);
+DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
+struct fcoe_percpu_s *fcoe_percpu[NR_CPUS];
+
+
+/* Function Prototyes */
+static int fcoe_check_wait_queue(struct fc_lport *);
+static void fcoe_insert_wait_queue_head(struct fc_lport *, struct sk_buff *);
+static void fcoe_insert_wait_queue(struct fc_lport *, struct sk_buff *);
+static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
+#ifdef CONFIG_HOTPLUG_CPU
+static int fcoe_cpu_callback(struct notifier_block *, ulong, void *);
+#endif /* CONFIG_HOTPLUG_CPU */
+static int fcoe_device_notification(struct notifier_block *, ulong, void *);
+static void fcoe_dev_setup(void);
+static void fcoe_dev_cleanup(void);
+
+/* notification function from net device */
+static struct notifier_block fcoe_notifier = {
+	.notifier_call = fcoe_device_notification,
+};
+
+
+#ifdef CONFIG_HOTPLUG_CPU
+static struct notifier_block fcoe_cpu_notifier = {
+	.notifier_call = fcoe_cpu_callback,
+};
+
+/**
+ * fcoe_create_percpu_data - creates the associated cpu data
+ * @cpu: index for the cpu where fcoe cpu data will be created
+ *
+ * create percpu stats block, from cpu add notifier
+ *
+ * Returns: none
+ **/
+static void fcoe_create_percpu_data(int cpu)
+{
+	struct fc_lport *lp;
+	struct fcoe_softc *fc;
+
+	write_lock_bh(&fcoe_hostlist_lock);
+	list_for_each_entry(fc, &fcoe_hostlist, list) {
+		lp = fc->lp;
+		if (lp->dev_stats[cpu] == NULL)
+			lp->dev_stats[cpu] =
+				kzalloc(sizeof(struct fcoe_dev_stats),
+					GFP_KERNEL);
+	}
+	write_unlock_bh(&fcoe_hostlist_lock);
+}
+
+/**
+ * fcoe_destroy_percpu_data - destroys the associated cpu data
+ * @cpu: index for the cpu where fcoe cpu data will destroyed
+ *
+ * destroy percpu stats block called by cpu add/remove notifier
+ *
+ * Retuns: none
+ **/
+static void fcoe_destroy_percpu_data(int cpu)
+{
+	struct fc_lport *lp;
+	struct fcoe_softc *fc;
+
+	write_lock_bh(&fcoe_hostlist_lock);
+	list_for_each_entry(fc, &fcoe_hostlist, list) {
+		lp = fc->lp;
+		kfree(lp->dev_stats[cpu]);
+		lp->dev_stats[cpu] = NULL;
+	}
+	write_unlock_bh(&fcoe_hostlist_lock);
+}
+
+/**
+ * fcoe_cpu_callback - fcoe cpu hotplug event callback
+ * @nfb: callback data block
+ * @action: event triggering the callback
+ * @hcpu: index for the cpu of this event
+ *
+ * this creates or destroys per cpu data for fcoe
+ *
+ * Returns NOTIFY_OK always.
+ **/
+static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
+			     void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+		fcoe_create_percpu_data(cpu);
+		break;
+	case CPU_DEAD:
+		fcoe_destroy_percpu_data(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+#endif /* CONFIG_HOTPLUG_CPU */
+
+/**
+ * foce_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
+ * @skb: the receive skb
+ * @dev: associated net device
+ * @ptype: context
+ * @odldev: last device
+ *
+ * this function will receive the packet and build fc frame and pass it up
+ *
+ * Returns: 0 for success
+ **/
+int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
+	     struct packet_type *ptype, struct net_device *olddev)
+{
+	struct fc_lport *lp;
+	struct fcoe_rcv_info *fr;
+	struct fcoe_softc *fc;
+	struct fcoe_dev_stats *stats;
+	u8 *data;
+	struct fc_frame_header *fh;
+	unsigned short oxid;
+	int cpu_idx;
+	struct fcoe_percpu_s *fps;
+
+	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
+	lp = fc->lp;
+	if (unlikely(lp == NULL)) {
+		FC_DBG("cannot find hba structure");
+		goto err2;
+	}
+
+	if (unlikely(debug_fcoe)) {
+		FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
+		       "end:%p sum:%d dev:%s", skb->len, skb->data_len,
+		       skb->head, skb->data, skb_tail_pointer(skb),
+		       skb_end_pointer(skb), skb->csum,
+		       skb->dev ? skb->dev->name : "<NULL>");
+
+	}
+
+	/* check for FCOE packet type */
+	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
+		FC_DBG("wrong FC type frame");
+		goto err;
+	}
+	data = skb->data;
+	data += sizeof(struct fcoe_hdr);
+	fh = (struct fc_frame_header *)data;
+	oxid = ntohs(fh->fh_ox_id);
+
+	fr = fcoe_dev_from_skb(skb);
+	fr->fr_dev = lp;
+	fr->ptype = ptype;
+	cpu_idx = 0;
+#ifdef CONFIG_SMP
+	/*
+	 * The exchange ID are ANDed with num of online CPUs,
+	 * so that will have the least lock contention in
+	 * handling the exchange. if there is no thread
+	 * for a given idx then use first online cpu.
+	 */
+	cpu_idx = oxid & (num_online_cpus() >> 1);
+	if (fcoe_percpu[cpu_idx] == NULL)
+		cpu_idx = first_cpu(cpu_online_map);
+#endif
+	fps = fcoe_percpu[cpu_idx];
+
+	spin_lock_bh(&fps->fcoe_rx_list.lock);
+	__skb_queue_tail(&fps->fcoe_rx_list, skb);
+	if (fps->fcoe_rx_list.qlen == 1)
+		wake_up_process(fps->thread);
+
+	spin_unlock_bh(&fps->fcoe_rx_list.lock);
+
+	return 0;
+err:
+#ifdef CONFIG_SMP
+	stats = lp->dev_stats[smp_processor_id()];
+#else
+	stats = lp->dev_stats[0];
+#endif
+	if (stats)
+		stats->ErrorFrames++;
+
+err2:
+	kfree_skb(skb);
+	return -1;
+}
+EXPORT_SYMBOL_GPL(fcoe_rcv);
+
+/**
+ * fcoe_start_io - pass to netdev to start xmit for fcoe
+ * @skb: the skb to be xmitted
+ *
+ * Returns: 0 for success
+ **/
+static inline int fcoe_start_io(struct sk_buff *skb)
+{
+	int rc;
+
+	skb_get(skb);
+	rc = dev_queue_xmit(skb);
+	if (rc != 0)
+		return rc;
+	kfree_skb(skb);
+	return 0;
+}
+
+/**
+ * fcoe_get_paged_crc_eof - in case we need alloc a page for crc_eof
+ * @skb: the skb to be xmitted
+ * @tlen: total len
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
+{
+	struct fcoe_percpu_s *fps;
+	struct page *page;
+	int cpu_idx;
+
+	cpu_idx = get_cpu();
+	fps = fcoe_percpu[cpu_idx];
+	page = fps->crc_eof_page;
+	if (!page) {
+		page = alloc_page(GFP_ATOMIC);
+		if (!page) {
+			put_cpu();
+			return -ENOMEM;
+		}
+		fps->crc_eof_page = page;
+		WARN_ON(fps->crc_eof_offset != 0);
+	}
+
+	get_page(page);
+	skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
+			   fps->crc_eof_offset, tlen);
+	skb->len += tlen;
+	skb->data_len += tlen;
+	skb->truesize += tlen;
+	fps->crc_eof_offset += sizeof(struct fcoe_crc_eof);
+
+	if (fps->crc_eof_offset >= PAGE_SIZE) {
+		fps->crc_eof_page = NULL;
+		fps->crc_eof_offset = 0;
+		put_page(page);
+	}
+	put_cpu();
+	return 0;
+}
+
+/**
+ * fcoe_fc_crc - calculates FC CRC in this fcoe skb
+ * @fp: the fc_frame containg data to be checksummed
+ *
+ * This uses crc32() to calculate the crc for fc frame
+ * Return   : 32 bit crc
+ *
+ **/
+u32 fcoe_fc_crc(struct fc_frame *fp)
+{
+	struct sk_buff *skb = fp_skb(fp);
+	struct skb_frag_struct *frag;
+	unsigned char *data;
+	unsigned long off, len, clen;
+	u32 crc;
+	unsigned i;
+
+	crc = crc32(~0, skb->data, skb_headlen(skb));
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		frag = &skb_shinfo(skb)->frags[i];
+		off = frag->page_offset;
+		len = frag->size;
+		while (len > 0) {
+			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
+			data = kmap_atomic(frag->page + (off >> PAGE_SHIFT),
+					   KM_SKB_DATA_SOFTIRQ);
+			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
+			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
+			off += clen;
+			len -= clen;
+		}
+	}
+	return crc;
+}
+EXPORT_SYMBOL_GPL(fcoe_fc_crc);
+
+/**
+ * fcoe_xmit - FCoE frame transmit function
+ * @lp:	the associated local port
+ * @fp: the fc_frame to be transmitted
+ *
+ * Return   : 0 for success
+ *
+ **/
+int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
+{
+	int wlen, rc = 0;
+	u32 crc;
+	struct ethhdr *eh;
+	struct fcoe_crc_eof *cp;
+	struct sk_buff *skb;
+	struct fcoe_dev_stats *stats;
+	struct fc_frame_header *fh;
+	unsigned int hlen;		/* header length implies the version */
+	unsigned int tlen;		/* trailer length */
+	unsigned int elen;		/* eth header, may include vlan */
+	int flogi_in_progress = 0;
+	struct fcoe_softc *fc;
+	u8 sof, eof;
+	struct fcoe_hdr *hp;
+
+	WARN_ON((fr_len(fp) % sizeof(u32)) != 0);
+
+	fc = fcoe_softc(lp);
+	/*
+	 * if it is a flogi then we need to learn gw-addr
+	 * and my own fcid
+	 */
+	fh = fc_frame_header_get(fp);
+	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ)) {
+		if (fc_frame_payload_op(fp) == ELS_FLOGI) {
+			fc->flogi_oxid = ntohs(fh->fh_ox_id);
+			fc->address_mode = FCOE_FCOUI_ADDR_MODE;
+			fc->flogi_progress = 1;
+			flogi_in_progress = 1;
+		} else if (fc->flogi_progress && ntoh24(fh->fh_s_id) != 0) {
+			/*
+			 * Here we must've gotten an SID by accepting an FLOGI
+			 * from a point-to-point connection.  Switch to using
+			 * the source mac based on the SID.  The destination
+			 * MAC in this case would have been set by receving the
+			 * FLOGI.
+			 */
+			fc_fcoe_set_mac(fc->data_src_addr, fh->fh_s_id);
+			fc->flogi_progress = 0;
+		}
+	}
+
+	skb = fp_skb(fp);
+	sof = fr_sof(fp);
+	eof = fr_eof(fp);
+
+	elen = (fc->real_dev->priv_flags & IFF_802_1Q_VLAN) ?
+		sizeof(struct vlan_ethhdr) : sizeof(struct ethhdr);
+	hlen = sizeof(struct fcoe_hdr);
+	tlen = sizeof(struct fcoe_crc_eof);
+	wlen = (skb->len - tlen + sizeof(crc)) / FCOE_WORD_TO_BYTE;
+
+	/* crc offload */
+	if (likely(lp->crc_offload)) {
+		skb->ip_summed = CHECKSUM_COMPLETE;
+		skb->csum_start = skb_headroom(skb);
+		skb->csum_offset = skb->len;
+		crc = 0;
+	} else {
+		skb->ip_summed = CHECKSUM_NONE;
+		crc = fcoe_fc_crc(fp);
+	}
+
+	/* copy fc crc and eof to the skb buff */
+	if (skb_is_nonlinear(skb)) {
+		skb_frag_t *frag;
+		if (fcoe_get_paged_crc_eof(skb, tlen)) {
+			kfree(skb);
+			return -ENOMEM;
+		}
+		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
+		cp = kmap_atomic(frag->page, KM_SKB_DATA_SOFTIRQ)
+			+ frag->page_offset;
+	} else {
+		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
+	}
+
+	memset(cp, 0, sizeof(*cp));
+	cp->fcoe_eof = eof;
+	cp->fcoe_crc32 = cpu_to_le32(~crc);
+
+	if (skb_is_nonlinear(skb)) {
+		kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
+		cp = NULL;
+	}
+
+	/* adjust skb netowrk/transport offsets to match mac/fcoe/fc */
+	skb_push(skb, elen + hlen);
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, elen);
+	skb_set_transport_header(skb, elen + hlen);
+	skb->mac_len = elen;
+	skb->protocol = htons(ETH_P_FCOE);
+	skb->dev = fc->real_dev;
+
+	/* fill up mac and fcoe headers */
+	eh = eth_hdr(skb);
+	eh->h_proto = htons(ETH_P_FCOE);
+	if (fc->address_mode == FCOE_FCOUI_ADDR_MODE)
+		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
+	else
+		/* insert GW address */
+		memcpy(eh->h_dest, fc->dest_addr, ETH_ALEN);
+
+	if (unlikely(flogi_in_progress))
+		memcpy(eh->h_source, fc->ctl_src_addr, ETH_ALEN);
+	else
+		memcpy(eh->h_source, fc->data_src_addr, ETH_ALEN);
+
+	hp = (struct fcoe_hdr *)skb_network_header(skb);
+	memset(hp, 0, sizeof(*hp));
+	if (FC_FCOE_VER)
+		FC_FCOE_ENCAPS_VER(hp, FC_FCOE_VER);
+	hp->fcoe_sof = sof;
+
+	/* update tx stats: regardless if LLD fails */
+	stats = lp->dev_stats[smp_processor_id()];
+	if (stats) {
+		stats->TxFrames++;
+		stats->TxWords += wlen;
+	}
+
+	/* send down to lld */
+	fr_dev(fp) = lp;
+	if (fc->fcoe_pending_queue.qlen)
+		rc = fcoe_check_wait_queue(lp);
+
+	if (rc == 0)
+		rc = fcoe_start_io(skb);
+
+	if (rc) {
+		fcoe_insert_wait_queue(lp, skb);
+		if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
+			fc_pause(lp);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_xmit);
+
+/*
+ * fcoe_percpu_receive_thread - recv thread per cpu
+ * @arg: ptr to the fcoe per cpu struct
+ *
+ * Return: 0 for success
+ *
+ */
+int fcoe_percpu_receive_thread(void *arg)
+{
+	struct fcoe_percpu_s *p = arg;
+	u32 fr_len;
+	unsigned int hlen;
+	unsigned int tlen;
+	struct fc_lport *lp;
+	struct fcoe_rcv_info *fr;
+	struct fcoe_dev_stats *stats;
+	struct fc_frame_header *fh;
+	struct sk_buff *skb;
+	struct fcoe_crc_eof *cp;
+	struct fc_frame *fp;
+	u8 *mac = NULL;
+	struct fcoe_softc *fc;
+	struct fcoe_hdr *hp;
+
+	set_user_nice(current, 19);
+
+	while (!kthread_should_stop()) {
+
+		spin_lock_bh(&p->fcoe_rx_list.lock);
+		while ((skb = __skb_dequeue(&p->fcoe_rx_list)) == NULL) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock_bh(&p->fcoe_rx_list.lock);
+			schedule();
+			set_current_state(TASK_RUNNING);
+			if (kthread_should_stop())
+				return 0;
+			spin_lock_bh(&p->fcoe_rx_list.lock);
+		}
+		spin_unlock_bh(&p->fcoe_rx_list.lock);
+		fr = fcoe_dev_from_skb(skb);
+		lp = fr->fr_dev;
+		if (unlikely(lp == NULL)) {
+			FC_DBG("invalid HBA Structure");
+			kfree_skb(skb);
+			continue;
+		}
+
+		stats = lp->dev_stats[smp_processor_id()];
+
+		if (unlikely(debug_fcoe)) {
+			FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
+			       "tail:%p end:%p sum:%d dev:%s",
+			       skb->len, skb->data_len,
+			       skb->head, skb->data, skb_tail_pointer(skb),
+			       skb_end_pointer(skb), skb->csum,
+			       skb->dev ? skb->dev->name : "<NULL>");
+		}
+
+		/*
+		 * Save source MAC address before discarding header.
+		 */
+		fc = lport_priv(lp);
+		if (unlikely(fc->flogi_progress))
+			mac = eth_hdr(skb)->h_source;
+
+		if (skb_is_nonlinear(skb))
+			skb_linearize(skb);	/* not ideal */
+
+		/*
+		 * Check the header and pull it off.
+		 */
+		hlen = sizeof(struct fcoe_hdr);
+		hp = (struct fcoe_hdr *)skb->data;
+		if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
+			if (stats) {
+				if (stats->ErrorFrames < 5)
+					FC_DBG("unknown FCoE version %x",
+					       FC_FCOE_DECAPS_VER(hp));
+				stats->ErrorFrames++;
+			}
+			kfree_skb(skb);
+			continue;
+		}
+		skb_pull(skb, sizeof(struct fcoe_hdr));
+		tlen = sizeof(struct fcoe_crc_eof);
+		fr_len = skb->len - tlen;
+		skb_trim(skb, fr_len);
+
+		if (unlikely(fr_len > skb->len)) {
+			if (stats) {
+				if (stats->ErrorFrames < 5)
+					FC_DBG("length error fr_len 0x%x "
+					       "skb->len 0x%x", fr_len,
+					       skb->len);
+				stats->ErrorFrames++;
+			}
+			kfree_skb(skb);
+			continue;
+		}
+		if (stats) {
+			stats->RxFrames++;
+			stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+		}
+
+		fp = (struct fc_frame *)skb;
+		cp = (struct fcoe_crc_eof *)(skb->data + fr_len);
+		fc_frame_init(fp);
+		fr_eof(fp) = cp->fcoe_eof;
+		fr_sof(fp) = hp->fcoe_sof;
+		fr_dev(fp) = lp;
+
+		/*
+		 * We only check CRC if no offload is available and if it is
+		 * it's solicited data, in which case, the FCP layer would
+		 * check it during the copy.
+		 */
+		if (lp->crc_offload)
+			fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
+		else
+			fr_flags(fp) |= FCPHF_CRC_UNCHECKED;
+
+		fh = fc_frame_header_get(fp);
+		if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
+		    fh->fh_type == FC_TYPE_FCP) {
+			fc_exch_recv(lp, lp->emp, fp);
+			continue;
+		}
+		if (fr_flags(fp) & FCPHF_CRC_UNCHECKED) {
+			if (le32_to_cpu(cp->fcoe_crc32) !=
+			    ~crc32(~0, skb->data, fr_len)) {
+				if (debug_fcoe || stats->InvalidCRCCount < 5)
+					printk(KERN_WARNING "fcoe: dropping "
+					       "frame with CRC error\n");
+				stats->InvalidCRCCount++;
+				stats->ErrorFrames++;
+				fc_frame_free(fp);
+				continue;
+			}
+			fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
+		}
+		/* non flogi and non data exchanges are handled here */
+		if (unlikely(fc->flogi_progress))
+			fcoe_recv_flogi(fc, fp, mac);
+		fc_exch_recv(lp, lp->emp, fp);
+	}
+	return 0;
+}
+
+/**
+ * fcoe_recv_flogi - flogi receive function
+ * @fc: associated fcoe_softc
+ * @fp: the recieved frame
+ * @sa: the source address of this flogi
+ *
+ * This is responsible to parse the flogi response and sets the corresponding
+ * mac address for the initiator, eitehr OUI based or GW based.
+ *
+ * Returns: none
+ **/
+static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
+{
+	struct fc_frame_header *fh;
+	u8 op;
+
+	fh = fc_frame_header_get(fp);
+	if (fh->fh_type != FC_TYPE_ELS)
+		return;
+	op = fc_frame_payload_op(fp);
+	if (op == ELS_LS_ACC && fh->fh_r_ctl == FC_RCTL_ELS_REP &&
+	    fc->flogi_oxid == ntohs(fh->fh_ox_id)) {
+		/*
+		 * FLOGI accepted.
+		 * If the src mac addr is FC_OUI-based, then we mark the
+		 * address_mode flag to use FC_OUI-based Ethernet DA.
+		 * Otherwise we use the FCoE gateway addr
+		 */
+		if (!compare_ether_addr(sa, (u8[6]) FC_FCOE_FLOGI_MAC)) {
+			fc->address_mode = FCOE_FCOUI_ADDR_MODE;
+		} else {
+			memcpy(fc->dest_addr, sa, ETH_ALEN);
+			fc->address_mode = FCOE_GW_ADDR_MODE;
+		}
+
+		/*
+		 * Remove any previously-set unicast MAC filter.
+		 * Add secondary FCoE MAC address filter for our OUI.
+		 */
+		rtnl_lock();
+		if (compare_ether_addr(fc->data_src_addr, (u8[6]) { 0 }))
+			dev_unicast_delete(fc->real_dev, fc->data_src_addr,
+					   ETH_ALEN);
+		fc_fcoe_set_mac(fc->data_src_addr, fh->fh_d_id);
+		dev_unicast_add(fc->real_dev, fc->data_src_addr, ETH_ALEN);
+		rtnl_unlock();
+
+		fc->flogi_progress = 0;
+	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa) {
+		/*
+		 * Save source MAC for point-to-point responses.
+		 */
+		memcpy(fc->dest_addr, sa, ETH_ALEN);
+		fc->address_mode = FCOE_GW_ADDR_MODE;
+	}
+}
+
+/**
+ * fcoe_watchdog - fcoe timer callback
+ * @vp:
+ *
+ * This checks the pending queue length for fcoe and put fcoe to be paused state
+ * if the FCOE_MAX_QUEUE_DEPTH is reached. This is done for all fc_lport on the
+ * fcoe_hostlist.
+ *
+ * Returns: 0 for success
+ **/
+void fcoe_watchdog(ulong vp)
+{
+	struct fc_lport *lp;
+	struct fcoe_softc *fc;
+	int paused = 0;
+
+	read_lock(&fcoe_hostlist_lock);
+	list_for_each_entry(fc, &fcoe_hostlist, list) {
+		lp = fc->lp;
+		if (lp) {
+			if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
+				paused = 1;
+			if (fcoe_check_wait_queue(lp) <	 FCOE_MAX_QUEUE_DEPTH) {
+				if (paused)
+					fc_unpause(lp);
+			}
+		}
+	}
+	read_unlock(&fcoe_hostlist_lock);
+
+	fcoe_timer.expires = jiffies + (1 * HZ);
+	add_timer(&fcoe_timer);
+}
+
+
+/**
+ * fcoe_check_wait_queue - put the skb into fcoe pending xmit queue
+ * @lp: the fc_port for this skb
+ * @skb: the associated skb to be xmitted
+ *
+ * This empties the wait_queue, dequeue the head of the wait_queue queue
+ * and calls fcoe_start_io() for each packet, if all skb have been
+ * transmitted, return 0 if a error occurs, then restore wait_queue and
+ * try again later.
+ *
+ * The wait_queue is used when the skb transmit fails. skb will go
+ * in the wait_queue which will be emptied by the time function OR
+ * by the next skb transmit.
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_check_wait_queue(struct fc_lport *lp)
+{
+	int rc, unpause = 0;
+	int paused = 0;
+	struct sk_buff *skb;
+	struct fcoe_softc *fc;
+
+	fc = fcoe_softc(lp);
+	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+
+	/*
+	 * is this interface paused?
+	 */
+	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
+		paused = 1;
+	if (fc->fcoe_pending_queue.qlen) {
+		while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
+			spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+			rc = fcoe_start_io(skb);
+			if (rc) {
+				fcoe_insert_wait_queue_head(lp, skb);
+				return rc;
+			}
+			spin_lock_bh(&fc->fcoe_pending_queue.lock);
+		}
+		if (fc->fcoe_pending_queue.qlen < FCOE_MAX_QUEUE_DEPTH)
+			unpause = 1;
+	}
+	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+	if ((unpause) && (paused))
+		fc_unpause(lp);
+	return fc->fcoe_pending_queue.qlen;
+}
+
+/**
+ * fcoe_insert_wait_queue_head - puts skb to fcoe pending queue head
+ * @lp: the fc_port for this skb
+ * @skb: the associated skb to be xmitted
+ *
+ * Returns: none
+ **/
+static void fcoe_insert_wait_queue_head(struct fc_lport *lp,
+					struct sk_buff *skb)
+{
+	struct fcoe_softc *fc;
+
+	fc = fcoe_softc(lp);
+	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+	__skb_queue_head(&fc->fcoe_pending_queue, skb);
+	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+}
+
+/**
+ * fcoe_insert_wait_queue - put the skb into fcoe pending queue tail
+ * @lp: the fc_port for this skb
+ * @skb: the associated skb to be xmitted
+ *
+ * Returns: none
+ **/
+static void fcoe_insert_wait_queue(struct fc_lport *lp,
+				   struct sk_buff *skb)
+{
+	struct fcoe_softc *fc;
+
+	fc = fcoe_softc(lp);
+	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+	__skb_queue_tail(&fc->fcoe_pending_queue, skb);
+	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+}
+
+/**
+ * fcoe_dev_setup - setup link change notification interface
+ *
+ **/
+static void fcoe_dev_setup(void)
+{
+	/*
+	 * here setup a interface specific wd time to
+	 * monitor the link state
+	 */
+	register_netdevice_notifier(&fcoe_notifier);
+}
+
+/**
+ * fcoe_dev_setup - cleanup link change notification interface
+ **/
+static void fcoe_dev_cleanup(void)
+{
+	unregister_netdevice_notifier(&fcoe_notifier);
+}
+
+/**
+ * fcoe_device_notification - netdev event notification callback
+ * @notifier: context of the notification
+ * @event: type of event
+ * @ptr: fixed array for output parsed ifname
+ *
+ * This function is called by the ethernet driver in case of link change event
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_device_notification(struct notifier_block *notifier,
+				    ulong event, void *ptr)
+{
+	struct fc_lport *lp = NULL;
+	struct net_device *real_dev = ptr;
+	struct fcoe_softc *fc;
+	struct fcoe_dev_stats *stats;
+	u16 new_status;
+	u32 mfs;
+	int rc = NOTIFY_OK;
+
+	read_lock(&fcoe_hostlist_lock);
+	list_for_each_entry(fc, &fcoe_hostlist, list) {
+		if (fc->real_dev == real_dev) {
+			lp = fc->lp;
+			break;
+		}
+	}
+	read_unlock(&fcoe_hostlist_lock);
+	if (lp == NULL) {
+		rc = NOTIFY_DONE;
+		goto out;
+	}
+
+	new_status = lp->link_status;
+	switch (event) {
+	case NETDEV_DOWN:
+	case NETDEV_GOING_DOWN:
+		new_status &= ~FC_LINK_UP;
+		break;
+	case NETDEV_UP:
+	case NETDEV_CHANGE:
+		new_status &= ~FC_LINK_UP;
+		if (!fcoe_link_ok(lp))
+			new_status |= FC_LINK_UP;
+		break;
+	case NETDEV_CHANGEMTU:
+		mfs = fc->real_dev->mtu -
+			(sizeof(struct fcoe_hdr) +
+			 sizeof(struct fcoe_crc_eof));
+		if (fc->user_mfs && fc->user_mfs < mfs)
+			mfs = fc->user_mfs;
+		if (mfs >= FC_MIN_MAX_FRAME)
+			fc_set_mfs(lp, mfs);
+		new_status &= ~FC_LINK_UP;
+		if (!fcoe_link_ok(lp))
+			new_status |= FC_LINK_UP;
+		break;
+	case NETDEV_REGISTER:
+		break;
+	default:
+		FC_DBG("unknown event %ld call", event);
+	}
+	if (lp->link_status != new_status) {
+		if ((new_status & FC_LINK_UP) == FC_LINK_UP)
+			fc_linkup(lp);
+		else {
+			stats = lp->dev_stats[smp_processor_id()];
+			if (stats)
+				stats->LinkFailureCount++;
+			fc_linkdown(lp);
+			fcoe_clean_pending_queue(lp);
+		}
+	}
+out:
+	return rc;
+}
+
+/**
+ * fcoe_if_to_netdev - parse a name buffer to get netdev
+ * @ifname: fixed array for output parsed ifname
+ * @buffer: incoming buffer to be copied
+ *
+ * Returns: NULL or ptr to netdeive
+ **/
+static struct net_device *fcoe_if_to_netdev(const char *buffer)
+{
+	char *cp;
+	char ifname[IFNAMSIZ + 2];
+
+	if (buffer) {
+		strlcpy(ifname, buffer, IFNAMSIZ);
+		cp = ifname + strlen(ifname);
+		while (--cp >= ifname && *cp == '\n')
+			*cp = '\0';
+		return dev_get_by_name(&init_net, ifname);
+	}
+	return NULL;
+}
+
+/**
+ * fcoe_netdev_to_module_owner - finds out the nic drive moddule of the netdev
+ * @netdev: the target netdev
+ *
+ * Returns: ptr to the struct module, NULL for failure
+ **/
+static struct module *fcoe_netdev_to_module_owner(
+	const struct net_device *netdev)
+{
+	struct device *dev;
+
+	if (!netdev)
+		return NULL;
+
+	dev = netdev->dev.parent;
+	if (!dev)
+		return NULL;
+
+	if (!dev->driver)
+		return NULL;
+
+	return dev->driver->owner;
+}
+
+/**
+ * fcoe_ethdrv_get - holds the nic driver module by  try_module_get() for
+ * the corresponding netdev.
+ * @netdev: the target netdev
+ *
+ * Returns: 0 for succsss
+ **/
+static int fcoe_ethdrv_get(const struct net_device *netdev)
+{
+	struct module *owner;
+
+	owner = fcoe_netdev_to_module_owner(netdev);
+	if (owner) {
+		printk(KERN_DEBUG "foce:hold driver module %s for %s\n",
+		       owner->name, netdev->name);
+		return  try_module_get(owner);
+	}
+	return -ENODEV;
+}
+
+/**
+ * fcoe_ethdrv_get - releases the nic driver module by module_put for
+ * the corresponding netdev.
+ * @netdev: the target netdev
+ *
+ * Returns: 0 for succsss
+ **/
+static int fcoe_ethdrv_put(const struct net_device *netdev)
+{
+	struct module *owner;
+
+	owner = fcoe_netdev_to_module_owner(netdev);
+	if (owner) {
+		printk(KERN_DEBUG "foce:release driver module %s for %s\n",
+		       owner->name, netdev->name);
+		module_put(owner);
+		return 0;
+	}
+	return -ENODEV;
+}
+
+/**
+ * fcoe_destroy- handles the destroy from sysfs
+ * @buffer: expcted to be a eth if name
+ * @kp: associated kernel param
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
+{
+	int rc;
+	struct net_device *netdev;
+
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+	/* look for existing lport */
+	if (!fcoe_hostlist_lookup(netdev)) {
+		rc = -ENODEV;
+		goto out_putdev;
+	}
+	/* pass to transport */
+	rc = fcoe_transport_release(netdev);
+	if (rc) {
+		printk(KERN_ERR "fcoe: fcoe_transport_release(%s) failed\n",
+		       netdev->name);
+		rc = -EIO;
+		goto out_putdev;
+	}
+	fcoe_ethdrv_put(netdev);
+	rc = 0;
+out_putdev:
+	dev_put(netdev);
+out_nodev:
+	return rc;
+}
+
+/**
+ * fcoe_create - handles the create call from sysfs
+ * @buffer: expcted to be a eth if name
+ * @kp: associated kernel param
+ *
+ * Returns: 0 for success
+ **/
+static int fcoe_create(const char *buffer, struct kernel_param *kp)
+{
+	int rc;
+	struct net_device *netdev;
+
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+	/* look for existing lport */
+	if (fcoe_hostlist_lookup(netdev)) {
+		rc = -EEXIST;
+		goto out_putdev;
+	}
+	fcoe_ethdrv_get(netdev);
+
+	/* pass to transport */
+	rc = fcoe_transport_attach(netdev);
+	if (rc) {
+		printk(KERN_ERR "fcoe: fcoe_transport_attach(%s) failed\n",
+		       netdev->name);
+		fcoe_ethdrv_put(netdev);
+		rc = -EIO;
+		goto out_putdev;
+	}
+	rc = 0;
+out_putdev:
+	dev_put(netdev);
+out_nodev:
+	return rc;
+}
+
+module_param_call(create, fcoe_create, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(create, "string");
+MODULE_PARM_DESC(create, "Create fcoe port using net device passed in.");
+module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(destroy, "string");
+MODULE_PARM_DESC(destroy, "Destroy fcoe port");
+
+/*
+ * fcoe_link_ok - check if link is ok for the fc_lport
+ * @lp: ptr to the fc_lport
+ *
+ * Any permanently-disqualifying conditions have been previously checked.
+ * This also updates the speed setting, which may change with link for 100/1000.
+ *
+ * This function should probably be checking for PAUSE support at some point
+ * in the future. Currently Per-priority-pause is not determinable using
+ * ethtool, so we shouldn't be restrictive until that problem is resolved.
+ *
+ * Returns: 0 if link is OK for use by FCoE.
+ *
+ */
+int fcoe_link_ok(struct fc_lport *lp)
+{
+	struct fcoe_softc *fc = fcoe_softc(lp);
+	struct net_device *dev = fc->real_dev;
+	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
+	int rc = 0;
+
+	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev)) {
+		dev = fc->phys_dev;
+		if (dev->ethtool_ops->get_settings) {
+			dev->ethtool_ops->get_settings(dev, &ecmd);
+			lp->link_supported_speeds &=
+				~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
+			if (ecmd.supported & (SUPPORTED_1000baseT_Half |
+					      SUPPORTED_1000baseT_Full))
+				lp->link_supported_speeds |= FC_PORTSPEED_1GBIT;
+			if (ecmd.supported & SUPPORTED_10000baseT_Full)
+				lp->link_supported_speeds |=
+					FC_PORTSPEED_10GBIT;
+			if (ecmd.speed == SPEED_1000)
+				lp->link_speed = FC_PORTSPEED_1GBIT;
+			if (ecmd.speed == SPEED_10000)
+				lp->link_speed = FC_PORTSPEED_10GBIT;
+		}
+	} else
+		rc = -1;
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(fcoe_link_ok);
+
+/*
+ * fcoe_percpu_clean - frees skb of the corresponding lport from the per
+ * cpu queue.
+ * @lp: the fc_lport
+ */
+void fcoe_percpu_clean(struct fc_lport *lp)
+{
+	int idx;
+	struct fcoe_percpu_s *pp;
+	struct fcoe_rcv_info *fr;
+	struct sk_buff_head *list;
+	struct sk_buff *skb, *next;
+	struct sk_buff *head;
+
+	for (idx = 0; idx < NR_CPUS; idx++) {
+		if (fcoe_percpu[idx]) {
+			pp = fcoe_percpu[idx];
+			spin_lock_bh(&pp->fcoe_rx_list.lock);
+			list = &pp->fcoe_rx_list;
+			head = list->next;
+			for (skb = head; skb != (struct sk_buff *)list;
+			     skb = next) {
+				next = skb->next;
+				fr = fcoe_dev_from_skb(skb);
+				if (fr->fr_dev == lp) {
+					__skb_unlink(skb, list);
+					kfree_skb(skb);
+				}
+			}
+			spin_unlock_bh(&pp->fcoe_rx_list.lock);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(fcoe_percpu_clean);
+
+/**
+ * fcoe_clean_pending_queue - dequeue skb and free it
+ * @lp: the corresponding fc_lport
+ *
+ * Returns: none
+ **/
+void fcoe_clean_pending_queue(struct fc_lport *lp)
+{
+	struct fcoe_softc  *fc = lport_priv(lp);
+	struct sk_buff *skb;
+
+	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+	while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
+		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+		kfree_skb(skb);
+		spin_lock_bh(&fc->fcoe_pending_queue.lock);
+	}
+	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+}
+EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
+
+/**
+ * libfc_host_alloc - allocate a Scsi_Host with room for the fc_lport
+ * @sht: ptr to the scsi host templ
+ * @priv_size: size of private data after fc_lport
+ *
+ * Returns: ptr to Scsi_Host
+ * TODO - to libfc?
+ */
+static inline struct Scsi_Host *libfc_host_alloc(
+	struct scsi_host_template *sht, int priv_size)
+{
+	return scsi_host_alloc(sht, sizeof(struct fc_lport) + priv_size);
+}
+
+/**
+ * fcoe_host_alloc - allocate a Scsi_Host with room for the fcoe_softc
+ * @sht: ptr to the scsi host templ
+ * @priv_size: size of private data after fc_lport
+ *
+ * Returns: ptr to Scsi_Host
+ */
+struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *sht, int priv_size)
+{
+	return libfc_host_alloc(sht, sizeof(struct fcoe_softc) + priv_size);
+}
+EXPORT_SYMBOL_GPL(fcoe_host_alloc);
+
+/*
+ * fcoe_reset - resets the fcoe
+ * @shost: shost the reset is from
+ *
+ * Returns: always 0
+ */
+int fcoe_reset(struct Scsi_Host *shost)
+{
+	struct fc_lport *lport = shost_priv(shost);
+	fc_lport_reset(lport);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_reset);
+
+/*
+ * fcoe_wwn_from_mac - converts 48-bit IEEE MAC address to 64-bit FC WWN.
+ * @mac: mac address
+ * @scheme: check port
+ * @port: port indicator for converting
+ *
+ * Returns: u64 fc world wide name
+ */
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+		      unsigned int scheme, unsigned int port)
+{
+	u64 wwn;
+	u64 host_mac;
+
+	/* The MAC is in NO, so flip only the low 48 bits */
+	host_mac = ((u64) mac[0] << 40) |
+		((u64) mac[1] << 32) |
+		((u64) mac[2] << 24) |
+		((u64) mac[3] << 16) |
+		((u64) mac[4] << 8) |
+		(u64) mac[5];
+
+	WARN_ON(host_mac >= (1ULL << 48));
+	wwn = host_mac | ((u64) scheme << 60);
+	switch (scheme) {
+	case 1:
+		WARN_ON(port != 0);
+		break;
+	case 2:
+		WARN_ON(port >= 0xfff);
+		wwn |= (u64) port << 48;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return wwn;
+}
+EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
+/*
+ * fcoe_hostlist_lookup_softc - find the corresponding lport by a given device
+ * @device: this is currently ptr to net_device
+ *
+ * Returns: NULL or the located fcoe_softc
+ */
+static struct fcoe_softc *fcoe_hostlist_lookup_softc(
+	const struct net_device *dev)
+{
+	struct fcoe_softc *fc;
+
+	read_lock(&fcoe_hostlist_lock);
+	list_for_each_entry(fc, &fcoe_hostlist, list) {
+		if (fc->real_dev == dev) {
+			read_unlock(&fcoe_hostlist_lock);
+			return fc;
+		}
+	}
+	read_unlock(&fcoe_hostlist_lock);
+	return NULL;
+}
+
+/*
+ * fcoe_hostlist_lookup - find the corresponding lport by netdev
+ * @netdev: ptr to net_device
+ *
+ * Returns: 0 for success
+ */
+struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
+{
+	struct fcoe_softc *fc;
+
+	fc = fcoe_hostlist_lookup_softc(netdev);
+
+	return (fc) ? fc->lp : NULL;
+}
+EXPORT_SYMBOL_GPL(fcoe_hostlist_lookup);
+
+/*
+ * fcoe_hostlist_add - add a lport to lports list
+ * @lp: ptr to the fc_lport to badded
+ *
+ * Returns: 0 for success
+ */
+int fcoe_hostlist_add(const struct fc_lport *lp)
+{
+	struct fcoe_softc *fc;
+
+	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
+	if (!fc) {
+		fc = fcoe_softc(lp);
+		write_lock_bh(&fcoe_hostlist_lock);
+		list_add_tail(&fc->list, &fcoe_hostlist);
+		write_unlock_bh(&fcoe_hostlist_lock);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_hostlist_add);
+
+/*
+ * fcoe_hostlist_remove - remove a lport from lports list
+ * @lp: ptr to the fc_lport to badded
+ *
+ * Returns: 0 for success
+ */
+int fcoe_hostlist_remove(const struct fc_lport *lp)
+{
+	struct fcoe_softc *fc;
+
+	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
+	BUG_ON(!fc);
+	write_lock_bh(&fcoe_hostlist_lock);
+	list_del(&fc->list);
+	write_unlock_bh(&fcoe_hostlist_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_hostlist_remove);
+
+/**
+ * fcoe_libfc_config - sets up libfc related properties for lport
+ * @lp: ptr to the fc_lport
+ * @tt: libfc function template
+ *
+ * Returns : 0 for success
+ **/
+int fcoe_libfc_config(struct fc_lport *lp, struct libfc_function_template *tt)
+{
+	/* Set the function pointers set by the LLDD */
+	memcpy(&lp->tt, tt, sizeof(*tt));
+	if (fc_fcp_init(lp))
+		return -ENOMEM;
+	fc_exch_init(lp);
+	fc_elsct_init(lp);
+	fc_lport_init(lp);
+	fc_rport_init(lp);
+	fc_disc_init(lp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_libfc_config);
+
+/**
+ * fcoe_init - fcoe module loading initialization
+ *
+ * Initialization routine
+ * 1. Will create fc transport software structure
+ * 2. initialize the link list of port information structure
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int __init fcoe_init(void)
+{
+	int cpu;
+	struct fcoe_percpu_s *p;
+
+
+	INIT_LIST_HEAD(&fcoe_hostlist);
+	rwlock_init(&fcoe_hostlist_lock);
+
+#ifdef CONFIG_HOTPLUG_CPU
+	register_cpu_notifier(&fcoe_cpu_notifier);
+#endif /* CONFIG_HOTPLUG_CPU */
+
+	/*
+	 * initialize per CPU interrupt thread
+	 */
+	for_each_online_cpu(cpu) {
+		p = kzalloc(sizeof(struct fcoe_percpu_s), GFP_KERNEL);
+		if (p) {
+			p->thread = kthread_create(fcoe_percpu_receive_thread,
+						   (void *)p,
+						   "fcoethread/%d", cpu);
+
+			/*
+			 * if there is no error then bind the thread to the cpu
+			 * initialize the semaphore and skb queue head
+			 */
+			if (likely(!IS_ERR(p->thread))) {
+				p->cpu = cpu;
+				fcoe_percpu[cpu] = p;
+				skb_queue_head_init(&p->fcoe_rx_list);
+				kthread_bind(p->thread, cpu);
+				wake_up_process(p->thread);
+			} else {
+				fcoe_percpu[cpu] = NULL;
+				kfree(p);
+
+			}
+		}
+	}
+
+	/*
+	 * setup link change notification
+	 */
+	fcoe_dev_setup();
+
+	init_timer(&fcoe_timer);
+	fcoe_timer.data = 0;
+	fcoe_timer.function = fcoe_watchdog;
+	fcoe_timer.expires = (jiffies + (10 * HZ));
+	add_timer(&fcoe_timer);
+
+	/* initiatlize the fcoe transport */
+	fcoe_transport_init();
+
+	fcoe_sw_init();
+
+	return 0;
+}
+module_init(fcoe_init);
+
+/**
+ * fcoe_exit - fcoe module unloading cleanup
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static void __exit fcoe_exit(void)
+{
+	u32 idx;
+	struct fcoe_softc *fc, *tmp;
+	struct fcoe_percpu_s *p;
+	struct sk_buff *skb;
+
+	/*
+	 * Stop all call back interfaces
+	 */
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_cpu_notifier(&fcoe_cpu_notifier);
+#endif /* CONFIG_HOTPLUG_CPU */
+	fcoe_dev_cleanup();
+
+	/*
+	 * stop timer
+	 */
+	del_timer_sync(&fcoe_timer);
+
+	/* releases the assocaited fcoe transport for each lport */
+	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
+		fcoe_transport_release(fc->real_dev);
+
+	for (idx = 0; idx < NR_CPUS; idx++) {
+		if (fcoe_percpu[idx]) {
+			kthread_stop(fcoe_percpu[idx]->thread);
+			p = fcoe_percpu[idx];
+			spin_lock_bh(&p->fcoe_rx_list.lock);
+			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
+				kfree_skb(skb);
+			spin_unlock_bh(&p->fcoe_rx_list.lock);
+			if (fcoe_percpu[idx]->crc_eof_page)
+				put_page(fcoe_percpu[idx]->crc_eof_page);
+			kfree(fcoe_percpu[idx]);
+		}
+	}
+
+	/* remove sw trasnport */
+	fcoe_sw_exit();
+
+	/* detach the transport */
+	fcoe_transport_exit();
+}
+module_exit(fcoe_exit);
diff --git a/include/scsi/fc_transport_fcoe.h b/include/scsi/fc_transport_fcoe.h
new file mode 100644
index 0000000..8dca2af
--- /dev/null
+++ b/include/scsi/fc_transport_fcoe.h
@@ -0,0 +1,54 @@
+#ifndef FC_TRANSPORT_FCOE_H
+#define FC_TRANSPORT_FCOE_H
+
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <scsi/scsi_host.h>
+#include <scsi/libfc.h>
+
+/**
+ * struct fcoe_transport - FCoE transport struct for generic transport
+ * for Ethernet devices as well as pure HBAs
+ *
+ * @name: name for thsi transport
+ * @bus: physical bus type (pci_bus_type)
+ * @driver: physical bus driver for network device
+ * @create: entry create function
+ * @destroy: exit destroy function
+ * @list: list of transports
+ */
+struct fcoe_transport {
+	char *name;
+	unsigned short vendor;
+	unsigned short device;
+	struct bus_type *bus;
+	struct device_driver *driver;
+	int (*create)(struct net_device *device);
+	int (*destroy)(struct net_device *device);
+	bool (*match)(struct net_device *device);
+	struct list_head list;
+	struct list_head devlist;
+	struct mutex devlock;
+};
+
+/**
+ * MODULE_ALIAS_FCOE_PCI
+ *
+ * some care must be taken with this, vendor and device MUST be a hex value
+ * preceded with 0x and with letters in lower case (0x12ab, not 0x12AB or 12AB)
+ */
+#define MODULE_ALIAS_FCOE_PCI(vendor, device) \
+	MODULE_ALIAS("fcoe-pci-" __stringify(vendor) "-" __stringify(device))
+
+/* exported funcs */
+int fcoe_transport_attach(struct net_device *netdev);
+int fcoe_transport_release(struct net_device *netdev);
+int fcoe_transport_register(struct fcoe_transport *t);
+int fcoe_transport_unregister(struct fcoe_transport *t);
+int fcoe_load_transport_driver(struct net_device *netdev);
+int __init fcoe_transport_init(void);
+int __exit fcoe_transport_exit(void);
+
+/* fcow_sw is the default transport */
+extern struct fcoe_transport fcoe_sw_transport;
+#endif /* FC_TRANSPORT_FCOE_H */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
new file mode 100644
index 0000000..4ca5902
--- /dev/null
+++ b/include/scsi/libfcoe.h
@@ -0,0 +1,177 @@
+/*
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _LIBFCOE_H
+#define _LIBFCOE_H
+
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <scsi/fc/fc_fcoe.h>
+#include <scsi/libfc.h>
+
+/*
+ * this percpu struct for fcoe
+ */
+struct fcoe_percpu_s {
+	int		cpu;
+	struct task_struct *thread;
+	struct sk_buff_head fcoe_rx_list;
+	struct page *crc_eof_page;
+	int crc_eof_offset;
+};
+
+/*
+ * the fcoe sw transport private data
+ */
+struct fcoe_softc {
+	struct list_head list;
+	struct fc_lport *lp;
+	struct net_device *real_dev;
+	struct net_device *phys_dev;		/* device with ethtool_ops */
+	struct packet_type  fcoe_packet_type;
+	struct sk_buff_head fcoe_pending_queue;
+	u16 user_mfs;			/* configured max frame size */
+
+	u8 dest_addr[ETH_ALEN];
+	u8 ctl_src_addr[ETH_ALEN];
+	u8 data_src_addr[ETH_ALEN];
+	/*
+	 * fcoe protocol address learning related stuff
+	 */
+	u16 flogi_oxid;
+	u8 flogi_progress;
+	u8 address_mode;
+};
+
+static inline struct fcoe_softc *fcoe_softc(
+	const struct fc_lport *lp)
+{
+	return (struct fcoe_softc *)lport_priv(lp);
+}
+
+static inline struct net_device *fcoe_netdev(
+	const struct fc_lport *lp)
+{
+	return fcoe_softc(lp)->real_dev;
+}
+
+static inline struct fcoe_hdr *skb_fcoe_header(const struct sk_buff *skb)
+{
+	return (struct fcoe_hdr *)skb_network_header(skb);
+}
+
+static inline int skb_fcoe_offset(const struct sk_buff *skb)
+{
+	return skb_network_offset(skb);
+}
+
+static inline struct fc_frame_header *skb_fc_header(const struct sk_buff *skb)
+{
+	return (struct fc_frame_header *)skb_transport_header(skb);
+}
+
+static inline int skb_fc_offset(const struct sk_buff *skb)
+{
+	return skb_transport_offset(skb);
+}
+
+static inline void skb_reset_fc_header(struct sk_buff *skb)
+{
+	skb_reset_network_header(skb);
+	skb_set_transport_header(skb, skb_network_offset(skb) +
+				 sizeof(struct fcoe_hdr));
+}
+
+static inline bool skb_fc_is_data(const struct sk_buff *skb)
+{
+	return skb_fc_header(skb)->fh_r_ctl == FC_RCTL_DD_SOL_DATA;
+}
+
+static inline bool skb_fc_is_cmd(const struct sk_buff *skb)
+{
+	return skb_fc_header(skb)->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD;
+}
+
+static inline bool skb_fc_has_exthdr(const struct sk_buff *skb)
+{
+	return (skb_fc_header(skb)->fh_r_ctl == FC_RCTL_VFTH) ||
+	    (skb_fc_header(skb)->fh_r_ctl == FC_RCTL_IFRH) ||
+	    (skb_fc_header(skb)->fh_r_ctl == FC_RCTL_ENCH);
+}
+
+static inline bool skb_fc_is_roff(const struct sk_buff *skb)
+{
+	return skb_fc_header(skb)->fh_f_ctl[2] & FC_FC_REL_OFF;
+}
+
+static inline u16 skb_fc_oxid(const struct sk_buff *skb)
+{
+	return be16_to_cpu(skb_fc_header(skb)->fh_ox_id);
+}
+
+static inline u16 skb_fc_rxid(const struct sk_buff *skb)
+{
+	return be16_to_cpu(skb_fc_header(skb)->fh_rx_id);
+}
+
+/* FIXME - DMA_BIDIRECTIONAL ? */
+#define skb_cb(skb)	((struct fcoe_rcv_info *)&((skb)->cb[0]))
+#define skb_cmd(skb)	(skb_cb(skb)->fr_cmd)
+#define skb_dir(skb)	(skb_cmd(skb)->sc_data_direction)
+static inline bool skb_fc_is_read(const struct sk_buff *skb)
+{
+	if (skb_fc_is_cmd(skb) && skb_cmd(skb))
+		return skb_dir(skb) == DMA_FROM_DEVICE;
+	return false;
+}
+
+static inline bool skb_fc_is_write(const struct sk_buff *skb)
+{
+	if (skb_fc_is_cmd(skb) && skb_cmd(skb))
+		return skb_dir(skb) == DMA_TO_DEVICE;
+	return false;
+}
+
+/* libfcoe funcs */
+int fcoe_reset(struct Scsi_Host *shost);
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+		      unsigned int scheme, unsigned int port);
+
+u32 fcoe_fc_crc(struct fc_frame *fp);
+int fcoe_xmit(struct fc_lport *, struct fc_frame *);
+int fcoe_rcv(struct sk_buff *, struct net_device *,
+	     struct packet_type *, struct net_device *);
+
+int fcoe_percpu_receive_thread(void *arg);
+void fcoe_clean_pending_queue(struct fc_lport *lp);
+void fcoe_percpu_clean(struct fc_lport *lp);
+void fcoe_watchdog(ulong vp);
+int fcoe_link_ok(struct fc_lport *lp);
+
+struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
+int fcoe_hostlist_add(const struct fc_lport *);
+int fcoe_hostlist_remove(const struct fc_lport *);
+
+struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *, int);
+int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
+
+/* fcoe sw hba */
+int __init fcoe_sw_init(void);
+int __exit fcoe_sw_exit(void);
+#endif /* _LIBFCOE_H */

