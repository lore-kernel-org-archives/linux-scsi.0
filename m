From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/17] fcoe: Logging review changes
Date: Fri, 06 Feb 2009 10:56:32 -0800
Message-ID: <20090206185632.26188.18626.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37653 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbZBFS4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:33 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

I reviewed the current FCOE_DBG and printk statements. These are the corrections and changes that I came up with.

1) Don't need to put function names as prefixes to print statements, the macro will do that.

2) Transport related additions and removals are printk(KERN_INFO, any other transport prints are FCOE_DBG()

3) Miscellaneous cleanups

4) Added newlines to statements without them

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fc_transport_fcoe.c |   83 +++++++++++++++------------------
 drivers/scsi/fcoe/fcoe_sw.c           |    7 +--
 drivers/scsi/fcoe/libfcoe.c           |   36 ++++++++------
 3 files changed, 61 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
index bf7fe6f..9fd4acc 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -21,6 +21,8 @@
 #include <scsi/libfcoe.h>
 #include <scsi/fc_transport_fcoe.h>
 
+#include "fcoe.h"
+
 /* internal fcoe transport */
 struct fcoe_transport_internal {
 	struct fcoe_transport *t;
@@ -96,9 +98,8 @@ static int fcoe_transport_device_add(struct fcoe_transport *t,
 
 	ti = fcoe_transport_device_lookup(t, netdev);
 	if (ti) {
-		printk(KERN_DEBUG "fcoe_transport_device_add:"
-		       "device %s is already added to transport %s\n",
-		       netdev->name, t->name);
+		FCOE_DBG("Device %s is already added to transport %s\n",
+			 netdev->name, t->name);
 		return -EEXIST;
 	}
 	/* allocate an internal struct to host the netdev and the list */
@@ -115,9 +116,8 @@ static int fcoe_transport_device_add(struct fcoe_transport *t,
 	list_add(&ti->list, &t->devlist);
 	mutex_unlock(&t->devlock);
 
-	printk(KERN_DEBUG "fcoe_transport_device_add:"
-		       "device %s added to transport %s\n",
-		       netdev->name, t->name);
+	printk(KERN_INFO "fcoe: Device %s added to transport %s\n",
+	       netdev->name, t->name);
 
 	return 0;
 }
@@ -138,17 +138,15 @@ static int fcoe_transport_device_remove(struct fcoe_transport *t,
 
 	ti = fcoe_transport_device_lookup(t, netdev);
 	if (!ti) {
-		printk(KERN_DEBUG "fcoe_transport_device_remove:"
-		       "device %s is not managed by transport %s\n",
-		       netdev->name, t->name);
+		FCOE_DBG("Device %s is not managed by transport %s\n",
+			 netdev->name, t->name);
 		return -ENODEV;
 	}
 	mutex_lock(&t->devlock);
 	list_del(&ti->list);
 	mutex_unlock(&t->devlock);
-	printk(KERN_DEBUG "fcoe_transport_device_remove:"
-	       "device %s removed from transport %s\n",
-	       netdev->name, t->name);
+	printk(KERN_INFO "fcoe: Device %s removed from transport %s\n",
+		 netdev->name, t->name);
 	dev_put(ti->netdev);
 	kfree(ti);
 	return 0;
@@ -194,10 +192,9 @@ static bool fcoe_transport_match(struct fcoe_transport *t,
 	pci = fcoe_transport_pcidev(netdev);
 
 	if (pci) {
-		printk(KERN_DEBUG "fcoe_transport_match:"
-		       "%s:%x:%x -- %s:%x:%x\n",
-		       t->name, t->vendor, t->device,
-		       netdev->name, pci->vendor, pci->device);
+		FCOE_DBG("%s:%x:%x -- %s:%x:%x\n",
+			 t->name, t->vendor, t->device,
+			 netdev->name, pci->vendor, pci->device);
 
 		/* if transport supports match */
 		if (t->match)
@@ -233,8 +230,9 @@ static struct fcoe_transport *fcoe_transport_lookup(
 	}
 	mutex_unlock(&fcoe_transports_lock);
 
-	printk(KERN_DEBUG "fcoe_transport_lookup:"
-	       "use default transport for %s\n", netdev->name);
+	FCOE_DBG("Unable to lookup for transport for %s, "
+		 "using the default software transport\n",
+		 netdev->name);
 	return fcoe_transport_default();
 }
 
@@ -262,7 +260,7 @@ int fcoe_transport_register(struct fcoe_transport *t)
 	mutex_init(&t->devlock);
 	INIT_LIST_HEAD(&t->devlist);
 
-	printk(KERN_DEBUG "fcoe_transport_register:%s\n", t->name);
+	printk(KERN_INFO "fcoe: Transport %s has been registered\n", t->name);
 
 	return 0;
 }
@@ -284,8 +282,8 @@ int fcoe_transport_unregister(struct fcoe_transport *t)
 			list_del(&t->list);
 			mutex_unlock(&fcoe_transports_lock);
 			fcoe_transport_device_remove_all(t);
-			printk(KERN_DEBUG "fcoe_transport_unregister:%s\n",
-			       t->name);
+			printk(KERN_INFO "fcoe: Transport %s has been "
+			       "unregistered\n", t->name);
 			return 0;
 		}
 	}
@@ -314,19 +312,20 @@ int fcoe_load_transport_driver(struct net_device *netdev)
 	struct device *dev = netdev->dev.parent;
 
 	if (fcoe_transport_lookup(netdev)) {
-		/* load default transport */
-		printk(KERN_DEBUG "fcoe: already loaded transport for %s\n",
-		       netdev->name);
+		FCOE_DBG("Transport for %s has already been registered\n",
+			 netdev->name);
 		return -EEXIST;
 	}
 
 	pci = to_pci_dev(dev);
 	if (dev->bus != &pci_bus_type) {
-		printk(KERN_DEBUG "fcoe: support noly PCI device\n");
+		printk(KERN_WARNING "fcoe: Support for only PCI devices, "
+		       "but %s is not a PCI device\n", netdev->name);
 		return -ENODEV;
 	}
-	printk(KERN_DEBUG "fcoe: loading driver fcoe-pci-0x%04x-0x%04x\n",
-	       pci->vendor, pci->device);
+
+	FCOE_DBG("Loading driver fcoe-pci-0x%04x-0x%04x\n",
+		 pci->vendor, pci->device);
 
 	return request_module("fcoe-pci-0x%04x-0x%04x",
 			      pci->vendor, pci->device);
@@ -350,24 +349,22 @@ int fcoe_transport_attach(struct net_device *netdev)
 	/* find the corresponding transport */
 	t = fcoe_transport_lookup(netdev);
 	if (!t) {
-		printk(KERN_DEBUG "fcoe_transport_attach"
-		       ":no transport for %s:use %s\n",
-		       netdev->name, t->name);
+		FCOE_DBG("Found %s transport for %s\n",
+			 t->name, netdev->name);
 		return -ENODEV;
 	}
 	/* add to the transport */
 	if (fcoe_transport_device_add(t, netdev)) {
-		printk(KERN_DEBUG "fcoe_transport_attach"
-		       ":failed to add %s to tramsport %s\n",
-		       netdev->name, t->name);
+		FCOE_DBG("Failed to add %s to tramsport %s\n",
+			 netdev->name, t->name);
 		return -EIO;
 	}
 	/* transport create function */
 	if (t->create)
 		t->create(netdev);
 
-	printk(KERN_DEBUG "fcoe_transport_attach:transport %s for %s\n",
-	       t->name, netdev->name);
+	printk(KERN_INFO "fcoe: Added %s to transport %s\n",
+	       netdev->name, t->name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_transport_attach);
@@ -385,26 +382,22 @@ int fcoe_transport_release(struct net_device *netdev)
 	/* find the corresponding transport */
 	t = fcoe_transport_lookup(netdev);
 	if (!t) {
-		printk(KERN_DEBUG "fcoe_transport_release:"
-		       "no transport for %s:use %s\n",
-		       netdev->name, t->name);
+		FCOE_DBG("Releasing %s from the default software transport\n",
+			 netdev->name);
 		return -ENODEV;
 	}
 	/* remove the device from the transport */
 	if (fcoe_transport_device_remove(t, netdev)) {
-		printk(KERN_DEBUG "fcoe_transport_release:"
-		       "failed to add %s to tramsport %s\n",
-		       netdev->name, t->name);
+		FCOE_DBG("Failed to remove %s from tramsport %s\n",
+			 netdev->name, t->name);
 		return -EIO;
 	}
 	/* transport destroy function */
 	if (t->destroy)
 		t->destroy(netdev);
 
-	printk(KERN_DEBUG "fcoe_transport_release:"
-	       "device %s dettached from transport %s\n",
-	       netdev->name, t->name);
-
+	printk(KERN_INFO "fcoe: Detached %s from transport %s\n",
+	       t->name, netdev->name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_transport_release);
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index e861c36..769e6a8 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -296,8 +296,7 @@ static int fcoe_sw_destroy(struct net_device *netdev)
 
 	BUG_ON(!netdev);
 
-	printk(KERN_DEBUG "fcoe_sw_destroy:interface on %s\n",
-	       netdev->name);
+	FCOE_DBG("fcoe_sw_destroy:interface on %s\n", netdev->name);
 
 	lp = fcoe_hostlist_lookup(netdev);
 	if (!lp)
@@ -383,7 +382,7 @@ static int fcoe_sw_create(struct net_device *netdev)
 	shost = fcoe_host_alloc(&fcoe_sw_shost_template,
 				sizeof(struct fcoe_softc));
 	if (!shost) {
-		FCOE_DBG("Could not allocate host structure\n");
+		printk(KERN_WARNING "Could not allocate host structure\n");
 		return -ENOMEM;
 	}
 	lp = shost_priv(shost);
@@ -474,7 +473,7 @@ int __init fcoe_sw_init(void)
 	scsi_transport_fcoe_sw =
 		fc_attach_transport(&fcoe_sw_transport_function);
 	if (!scsi_transport_fcoe_sw) {
-		printk(KERN_ERR "fcoe_sw_init:fc_attach_transport() failed\n");
+		FCOE_DBG("fcoe_sw_init:fc_attach_transport() failed\n");
 		return -ENODEV;
 	}
 	/* register sw transport */
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 594295b..9efe1bf 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -194,19 +194,19 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	lp = fc->lp;
 	if (unlikely(lp == NULL)) {
-		FCOE_DBG("cannot find hba structure");
+		FCOE_DBG("cannot find hba structure\n");
 		goto err2;
 	}
 
 	FCOE_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
-		 "end:%p sum:%d dev:%s", skb->len, skb->data_len,
+		 "end:%p sum:%d dev:%s\n", skb->len, skb->data_len,
 		 skb->head, skb->data, skb_tail_pointer(skb),
 		 skb_end_pointer(skb), skb->csum,
 		 skb->dev ? skb->dev->name : "<NULL>");
 
 	/* check for FCOE packet type */
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
-		FCOE_DBG("wrong FC type frame");
+		FCOE_DBG("wrong FC type frame\n");
 		goto err;
 	}
 
@@ -551,7 +551,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		fr = fcoe_dev_from_skb(skb);
 		lp = fr->fr_dev;
 		if (unlikely(lp == NULL)) {
-			FCOE_DBG("invalid HBA Structure");
+			FCOE_DBG("invalid HBA Structure\n");
 			kfree_skb(skb);
 			continue;
 		}
@@ -559,7 +559,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		stats = lp->dev_stats[smp_processor_id()];
 
 		FCOE_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
-			 "tail:%p end:%p sum:%d dev:%s",
+			 "tail:%p end:%p sum:%d dev:%s\n",
 			 skb->len, skb->data_len,
 			 skb->head, skb->data, skb_tail_pointer(skb),
 			 skb_end_pointer(skb), skb->csum,
@@ -585,8 +585,12 @@ int fcoe_percpu_receive_thread(void *arg)
 		if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
 			if (stats) {
 				if (stats->ErrorFrames < 5)
-					FCOE_DBG("unknown FCoE version %x",
-						 FC_FCOE_DECAPS_VER(hp));
+					printk(KERN_WARNING "FCoE version "
+					       "mismatch: The frame has "
+					       "version %x, but the "
+					       "initiator supports version "
+					       "%x\n", FC_FCOE_DECAPS_VER(hp),
+					       FC_FCOE_VER);
 				stats->ErrorFrames++;
 			}
 			kfree_skb(skb);
@@ -906,7 +910,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_REGISTER:
 		break;
 	default:
-		FCOE_DBG("unknown event %ld call", event);
+		FCOE_DBG("Unknown event %ld from netdev netlink\n", event);
 	}
 	if (lp->link_up != new_link_up) {
 		if (new_link_up)
@@ -982,8 +986,8 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
 
 	owner = fcoe_netdev_to_module_owner(netdev);
 	if (owner) {
-		printk(KERN_DEBUG "fcoe:hold driver module %s for %s\n",
-		       module_name(owner), netdev->name);
+		FCOE_DBG("fcoe:hold driver module %s for %s\n",
+			 module_name(owner), netdev->name);
 		return  try_module_get(owner);
 	}
 	return -ENODEV;
@@ -1002,8 +1006,8 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 
 	owner = fcoe_netdev_to_module_owner(netdev);
 	if (owner) {
-		printk(KERN_DEBUG "fcoe:release driver module %s for %s\n",
-		       module_name(owner), netdev->name);
+		FCOE_DBG("fcoe:release driver module %s for %s\n",
+			 module_name(owner), netdev->name);
 		module_put(owner);
 		return 0;
 	}
@@ -1035,8 +1039,8 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	/* pass to transport */
 	rc = fcoe_transport_release(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_transport_release(%s) failed\n",
-		       netdev->name);
+		FCOE_DBG("fcoe: fcoe_transport_release(%s) failed\n",
+			 netdev->name);
 		rc = -EIO;
 		goto out_putdev;
 	}
@@ -1075,8 +1079,8 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	/* pass to transport */
 	rc = fcoe_transport_attach(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_transport_attach(%s) failed\n",
-		       netdev->name);
+		FCOE_DBG("fcoe: fcoe_transport_attach(%s) failed\n",
+			 netdev->name);
 		fcoe_ethdrv_put(netdev);
 		rc = -EIO;
 		goto out_putdev;

