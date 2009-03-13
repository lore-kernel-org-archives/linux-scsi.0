From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.28-rc8
Date: Fri, 13 Mar 2009 20:06:22 +0000
Message-ID: <1236974782.3276.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48663 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbZCMUGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Mar 2009 16:06:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is basically a set of qla2xxx fixes (vport handling, and other
assorted small things) and a fix for an enterprise array spin up. It
also includes a much larger set of updates to fcoe/libfc.  The reason
for the latter is that fcoe/libfc was new in the 2.6.29 merge window, so
there's never been an actual kernel containing it released and it
qualifies under our merge window exemption for new drivers.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Abhijeet Joglekar (2):
      libfc: when rport goes away (re-plogi), clean up exchanges to/from rport
      libfc: Pass lport in exch_mgr_reset

Andrew Vasquez (4):
      qla2xxx: Update version number to 8.03.00-k4.
      qla2xxx: Correct overwrite of pre-assigned init-control-block structure si
      qla2xxx: Correct truncation in return-code status checking.
      qla2xxx: Correct address range checking for option-rom updates.

Anirban Chakraborty (1):
      qla2xxx: Correct vport delete bug.

Chris Leech (2):
      fcoe: fix handling of pending queue, prevent out of order frames (v3)
      libfc: rport retry on LS_RJT from certain ELS

Lalit Chandivade (1):
      qla2xxx: Use correct value for max vport in LOOP topology.

Matthew Wilcox (1):
      sd: Don't try to spin up drives that are connected to an inactive port

Robert Love (11):
      fcoe: Change fcoe receive thread nice value from 19 (lowest priority) to -
      fcoe: Correct fcoe_transports initialization vs. registration
      fcoe: Use setup_timer() and mod_timer()
      libfc, fcoe: Remove unnecessary cast by removing inline wrapper
      libfc, fcoe: Cleanup function formatting and minor typos
      libfc, fcoe: Fix kerneldoc comments
      libfc: Cleanup libfc_function_template comments
      libfc: check for err when recv and state is incorrect
      libfc: rename rp to rdata in fc_disc_new_target()
      libfc: correct RPORT_TO_PRIV usage
      libfc: Don't violate transport template for rogue port creation

Roel Kluin (1):
      fcoe: fix kfree(skb)

Steve Ma (1):
      libfc: exch mgr is freed while lport still retrying sequences

Vasu Dev (5):
      fcoe: Out of order tx frames was causing several check condition SCSI stat
      libfc: fixed a read IO data integrity issue when a IO data frame lost
      libfc, fcoe: fixed locking issues with lport->lp_mutex around lport->link_
      libfc: fixed a soft lockup issue in fc_exch_recv_abts
      libfc: handle RRQ exch timeout

Yi Zou (2):
      fcoe: ETH_P_8021Q is already in if_ether and fcoe is not using it anyway
      libfc: do not change the fh_rx_id of a recevied frame


The diffstat excluding libfc/fcoe is:

 drivers/scsi/qla2xxx/qla_attr.c    |    9 +--------
 drivers/scsi/qla2xxx/qla_init.c    |   19 +++++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c     |    3 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |   10 ++++++----
 drivers/scsi/qla2xxx/qla_os.c      |    6 +-----
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 drivers/scsi/sd.c                  |   26 +++++++++++---------------
 7 files changed, 35 insertions(+), 40 deletions(-)

And the full diffstat is:

 drivers/scsi/fcoe/fc_transport_fcoe.c |   91 ++++-----
 drivers/scsi/fcoe/fcoe_sw.c           |   56 +++--
 drivers/scsi/fcoe/libfcoe.c           |  318 ++++++++++++++--------------------
 drivers/scsi/libfc/fc_disc.c          |   63 +++---
 drivers/scsi/libfc/fc_exch.c          |   32 ---
 drivers/scsi/libfc/fc_fcp.c           |   56 ++---
 drivers/scsi/libfc/fc_lport.c         |  173 ++++++++----------
 drivers/scsi/libfc/fc_rport.c         |  197 +++++++++++----------
 drivers/scsi/qla2xxx/qla_attr.c       |    9 
 drivers/scsi/qla2xxx/qla_init.c       |   19 +-
 drivers/scsi/qla2xxx/qla_mbx.c        |    3 
 drivers/scsi/qla2xxx/qla_mid.c        |   10 -
 drivers/scsi/qla2xxx/qla_os.c         |    6 
 drivers/scsi/qla2xxx/qla_version.h    |    2 
 drivers/scsi/sd.c                     |   26 +-
 include/scsi/fc/fc_fcoe.h             |    4 
 include/scsi/fc/fc_fs.h               |    5 
 include/scsi/libfc.h                  |  138 ++++++++------
 include/scsi/libfcoe.h                |    9 
 19 files changed, 586 insertions(+), 631 deletions(-)

The patch is attached below.

James

---

diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
index bf7fe6f..8862758 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -33,19 +33,19 @@ static LIST_HEAD(fcoe_transports);
 static DEFINE_MUTEX(fcoe_transports_lock);
 
 /**
- * fcoe_transport_default - returns ptr to the default transport fcoe_sw
- **/
+ * fcoe_transport_default() - Returns ptr to the default transport fcoe_sw
+ */
 struct fcoe_transport *fcoe_transport_default(void)
 {
 	return &fcoe_sw_transport;
 }
 
 /**
- * fcoe_transport_to_pcidev - get the pci dev from a netdev
+ * fcoe_transport_to_pcidev() - get the pci dev from a netdev
  * @netdev: the netdev that pci dev will be retrived from
  *
  * Returns: NULL or the corrsponding pci_dev
- **/
+ */
 struct pci_dev *fcoe_transport_pcidev(const struct net_device *netdev)
 {
 	if (!netdev->dev.parent)
@@ -54,18 +54,17 @@ struct pci_dev *fcoe_transport_pcidev(const struct net_device *netdev)
 }
 
 /**
- * fcoe_transport_device_lookup - find out netdev is managed by the
- * transport
- * assign a transport to a device
+ * fcoe_transport_device_lookup() - Lookup a transport
  * @netdev: the netdev the transport to be attached to
  *
  * This will look for existing offload driver, if not found, it falls back to
  * the default sw hba (fcoe_sw) as its fcoe transport.
  *
  * Returns: 0 for success
- **/
-static struct fcoe_transport_internal *fcoe_transport_device_lookup(
-	struct fcoe_transport *t, struct net_device *netdev)
+ */
+static struct fcoe_transport_internal *
+fcoe_transport_device_lookup(struct fcoe_transport *t,
+			     struct net_device *netdev)
 {
 	struct fcoe_transport_internal *ti;
 
@@ -81,14 +80,14 @@ static struct fcoe_transport_internal *fcoe_transport_device_lookup(
 	return NULL;
 }
 /**
- * fcoe_transport_device_add - assign a transport to a device
+ * fcoe_transport_device_add() - Assign a transport to a device
  * @netdev: the netdev the transport to be attached to
  *
  * This will look for existing offload driver, if not found, it falls back to
  * the default sw hba (fcoe_sw) as its fcoe transport.
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_transport_device_add(struct fcoe_transport *t,
 				     struct net_device *netdev)
 {
@@ -123,14 +122,14 @@ static int fcoe_transport_device_add(struct fcoe_transport *t,
 }
 
 /**
- * fcoe_transport_device_remove - remove a device from its transport
+ * fcoe_transport_device_remove() - Remove a device from its transport
  * @netdev: the netdev the transport to be attached to
  *
- * this removes the device from the transport so the given transport will
+ * This removes the device from the transport so the given transport will
  * not manage this device any more
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_transport_device_remove(struct fcoe_transport *t,
 					struct net_device *netdev)
 {
@@ -155,13 +154,13 @@ static int fcoe_transport_device_remove(struct fcoe_transport *t,
 }
 
 /**
- * fcoe_transport_device_remove_all - remove all from transport devlist
+ * fcoe_transport_device_remove_all() - Remove all from transport devlist
  *
- * this removes the device from the transport so the given transport will
+ * This removes the device from the transport so the given transport will
  * not manage this device any more
  *
  * Returns: 0 for success
- **/
+ */
 static void fcoe_transport_device_remove_all(struct fcoe_transport *t)
 {
 	struct fcoe_transport_internal *ti, *tmp;
@@ -175,18 +174,18 @@ static void fcoe_transport_device_remove_all(struct fcoe_transport *t)
 }
 
 /**
- * fcoe_transport_match - use the bus device match function to match the hw
- * @t: the fcoe transport
- * @netdev:
+ * fcoe_transport_match() - Use the bus device match function to match the hw
+ * @t: The fcoe transport to check
+ * @netdev: The netdev to match against
  *
- * This function is used to check if the givne transport wants to manage the
+ * This function is used to check if the given transport wants to manage the
  * input netdev. if the transports implements the match function, it will be
  * called, o.w. we just compare the pci vendor and device id.
  *
  * Returns: true for match up
- **/
+ */
 static bool fcoe_transport_match(struct fcoe_transport *t,
-				struct net_device *netdev)
+				 struct net_device *netdev)
 {
 	/* match transport by vendor and device id */
 	struct pci_dev *pci;
@@ -210,17 +209,17 @@ static bool fcoe_transport_match(struct fcoe_transport *t,
 }
 
 /**
- * fcoe_transport_lookup - check if the transport is already registered
+ * fcoe_transport_lookup() - Check if the transport is already registered
  * @t: the transport to be looked up
  *
  * This compares the parent device (pci) vendor and device id
  *
  * Returns: NULL if not found
  *
- * TODO - return default sw transport if no other transport is found
- **/
-static struct fcoe_transport *fcoe_transport_lookup(
-	struct net_device *netdev)
+ * TODO: return default sw transport if no other transport is found
+ */
+static struct fcoe_transport *
+fcoe_transport_lookup(struct net_device *netdev)
 {
 	struct fcoe_transport *t;
 
@@ -239,11 +238,11 @@ static struct fcoe_transport *fcoe_transport_lookup(
 }
 
 /**
- * fcoe_transport_register - adds a fcoe transport to the fcoe transports list
+ * fcoe_transport_register() - Adds a fcoe transport to the fcoe transports list
  * @t: ptr to the fcoe transport to be added
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_transport_register(struct fcoe_transport *t)
 {
 	struct fcoe_transport *tt;
@@ -259,9 +258,6 @@ int fcoe_transport_register(struct fcoe_transport *t)
 	list_add_tail(&t->list, &fcoe_transports);
 	mutex_unlock(&fcoe_transports_lock);
 
-	mutex_init(&t->devlock);
-	INIT_LIST_HEAD(&t->devlist);
-
 	printk(KERN_DEBUG "fcoe_transport_register:%s\n", t->name);
 
 	return 0;
@@ -269,11 +265,11 @@ int fcoe_transport_register(struct fcoe_transport *t)
 EXPORT_SYMBOL_GPL(fcoe_transport_register);
 
 /**
- * fcoe_transport_unregister - remove the tranport fro the fcoe transports list
+ * fcoe_transport_unregister() - Remove the tranport fro the fcoe transports list
  * @t: ptr to the fcoe transport to be removed
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_transport_unregister(struct fcoe_transport *t)
 {
 	struct fcoe_transport *tt, *tmp;
@@ -294,8 +290,8 @@ int fcoe_transport_unregister(struct fcoe_transport *t)
 }
 EXPORT_SYMBOL_GPL(fcoe_transport_unregister);
 
-/*
- * fcoe_load_transport_driver - load an offload driver by alias name
+/**
+ * fcoe_load_transport_driver() - Load an offload driver by alias name
  * @netdev: the target net device
  *
  * Requests for an offload driver module as the fcoe transport, if fails, it
@@ -307,7 +303,7 @@ EXPORT_SYMBOL_GPL(fcoe_transport_unregister);
  * 	3. pure hw fcoe hba may not have netdev
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_load_transport_driver(struct net_device *netdev)
 {
 	struct pci_dev *pci;
@@ -335,14 +331,14 @@ int fcoe_load_transport_driver(struct net_device *netdev)
 EXPORT_SYMBOL_GPL(fcoe_load_transport_driver);
 
 /**
- * fcoe_transport_attach - load transport to fcoe
+ * fcoe_transport_attach() - Load transport to fcoe
  * @netdev: the netdev the transport to be attached to
  *
  * This will look for existing offload driver, if not found, it falls back to
  * the default sw hba (fcoe_sw) as its fcoe transport.
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_transport_attach(struct net_device *netdev)
 {
 	struct fcoe_transport *t;
@@ -373,11 +369,11 @@ int fcoe_transport_attach(struct net_device *netdev)
 EXPORT_SYMBOL_GPL(fcoe_transport_attach);
 
 /**
- * fcoe_transport_release - unload transport from fcoe
+ * fcoe_transport_release() - Unload transport from fcoe
  * @netdev: the net device on which fcoe is to be released
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_transport_release(struct net_device *netdev)
 {
 	struct fcoe_transport *t;
@@ -410,12 +406,12 @@ int fcoe_transport_release(struct net_device *netdev)
 EXPORT_SYMBOL_GPL(fcoe_transport_release);
 
 /**
- * fcoe_transport_init - initializes fcoe transport layer
+ * fcoe_transport_init() - Initializes fcoe transport layer
  *
  * This prepares for the fcoe transport layer
  *
  * Returns: none
- **/
+ */
 int __init fcoe_transport_init(void)
 {
 	INIT_LIST_HEAD(&fcoe_transports);
@@ -424,12 +420,13 @@ int __init fcoe_transport_init(void)
 }
 
 /**
- * fcoe_transport_exit - cleans up the fcoe transport layer
+ * fcoe_transport_exit() - Cleans up the fcoe transport layer
+ *
  * This cleans up the fcoe transport layer. removing any transport on the list,
  * note that the transport destroy func is not called here.
  *
  * Returns: none
- **/
+ */
 int __exit fcoe_transport_exit(void)
 {
 	struct fcoe_transport *t, *tmp;
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index dc4cd5e..da210eb 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -104,19 +104,19 @@ static struct scsi_host_template fcoe_sw_shost_template = {
 	.max_sectors = 0xffff,
 };
 
-/*
- * fcoe_sw_lport_config - sets up the fc_lport
+/**
+ * fcoe_sw_lport_config() - sets up the fc_lport
  * @lp: ptr to the fc_lport
  * @shost: ptr to the parent scsi host
  *
  * Returns: 0 for success
- *
  */
 static int fcoe_sw_lport_config(struct fc_lport *lp)
 {
 	int i = 0;
 
-	lp->link_status = 0;
+	lp->link_up = 0;
+	lp->qfull = 0;
 	lp->max_retry_count = 3;
 	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
 	lp->r_a_tov = 2 * 2 * 1000;
@@ -136,16 +136,14 @@ static int fcoe_sw_lport_config(struct fc_lport *lp)
 	return 0;
 }
 
-/*
- * fcoe_sw_netdev_config - sets up fcoe_softc for lport and network
- * related properties
+/**
+ * fcoe_sw_netdev_config() - Set up netdev for SW FCoE
  * @lp : ptr to the fc_lport
  * @netdev : ptr to the associated netdevice struct
  *
  * Must be called after fcoe_sw_lport_config() as it will use lport mutex
  *
  * Returns : 0 for success
- *
  */
 static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 {
@@ -181,9 +179,8 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	if (fc_set_mfs(lp, mfs))
 		return -EINVAL;
 
-	lp->link_status = ~FC_PAUSE & ~FC_LINK_UP;
 	if (!fcoe_link_ok(lp))
-		lp->link_status |= FC_LINK_UP;
+		lp->link_up = 1;
 
 	/* offload features support */
 	if (fc->real_dev->features & NETIF_F_SG)
@@ -191,6 +188,7 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 

 	skb_queue_head_init(&fc->fcoe_pending_queue);
+	fc->fcoe_pending_queue_active = 0;
 
 	/* setup Source Mac Address */
 	memcpy(fc->ctl_src_addr, fc->real_dev->dev_addr,
@@ -224,16 +222,15 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	return 0;
 }
 
-/*
- * fcoe_sw_shost_config - sets up fc_lport->host
+/**
+ * fcoe_sw_shost_config() - Sets up fc_lport->host
  * @lp : ptr to the fc_lport
  * @shost : ptr to the associated scsi host
  * @dev : device associated to scsi host
  *
- * Must be called after fcoe_sw_lport_config) and fcoe_sw_netdev_config()
+ * Must be called after fcoe_sw_lport_config() and fcoe_sw_netdev_config()
  *
  * Returns : 0 for success
- *
  */
 static int fcoe_sw_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 				struct device *dev)
@@ -261,8 +258,8 @@ static int fcoe_sw_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 	return 0;
 }
 
-/*
- * fcoe_sw_em_config - allocates em for this lport
+/**
+ * fcoe_sw_em_config() - allocates em for this lport
  * @lp: the port that em is to allocated for
  *
  * Returns : 0 on success
@@ -279,8 +276,8 @@ static inline int fcoe_sw_em_config(struct fc_lport *lp)
 	return 0;
 }
 
-/*
- * fcoe_sw_destroy - FCoE software HBA tear-down function
+/**
+ * fcoe_sw_destroy() - FCoE software HBA tear-down function
  * @netdev: ptr to the associated net_device
  *
  * Returns: 0 if link is OK for use by FCoE.
@@ -301,7 +298,7 @@ static int fcoe_sw_destroy(struct net_device *netdev)
 	if (!lp)
 		return -ENODEV;
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 
 	/* Logout of the fabric */
 	fc_fabric_logoff(lp);
@@ -353,8 +350,8 @@ static struct libfc_function_template fcoe_sw_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 };
 
-/*
- * fcoe_sw_create - this function creates the fcoe interface
+/**
+ * fcoe_sw_create() - this function creates the fcoe interface
  * @netdev: pointer the associated netdevice
  *
  * Creates fc_lport struct and scsi_host for lport, configures lport
@@ -440,8 +437,8 @@ out_host_put:
 	return rc;
 }
 
-/*
- * fcoe_sw_match - the fcoe sw transport match function
+/**
+ * fcoe_sw_match() - The FCoE SW transport match function
  *
  * Returns : false always
  */
@@ -461,8 +458,8 @@ struct fcoe_transport fcoe_sw_transport = {
 	.device = 0xffff,
 };
 
-/*
- * fcoe_sw_init - registers fcoe_sw_transport
+/**
+ * fcoe_sw_init() - Registers fcoe_sw_transport
  *
  * Returns : 0 on success
  */
@@ -471,17 +468,22 @@ int __init fcoe_sw_init(void)
 	/* attach to scsi transport */
 	scsi_transport_fcoe_sw =
 		fc_attach_transport(&fcoe_sw_transport_function);
+
 	if (!scsi_transport_fcoe_sw) {
 		printk(KERN_ERR "fcoe_sw_init:fc_attach_transport() failed\n");
 		return -ENODEV;
 	}
+
+	mutex_init(&fcoe_sw_transport.devlock);
+	INIT_LIST_HEAD(&fcoe_sw_transport.devlist);
+
 	/* register sw transport */
 	fcoe_transport_register(&fcoe_sw_transport);
 	return 0;
 }
 
-/*
- * fcoe_sw_exit - unregisters fcoe_sw_transport
+/**
+ * fcoe_sw_exit() - Unregisters fcoe_sw_transport
  *
  * Returns : 0 on success
  */
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index e419f48..5548bf3 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -49,6 +49,7 @@
 static int debug_fcoe;
 
 #define FCOE_MAX_QUEUE_DEPTH  256
+#define FCOE_LOW_QUEUE_DEPTH  32
 
 /* destination address mode */
 #define FCOE_GW_ADDR_MODE	    0x00
@@ -69,8 +70,6 @@ struct fcoe_percpu_s *fcoe_percpu[NR_CPUS];
 
 /* Function Prototyes */
 static int fcoe_check_wait_queue(struct fc_lport *);
-static void fcoe_insert_wait_queue_head(struct fc_lport *, struct sk_buff *);
-static void fcoe_insert_wait_queue(struct fc_lport *, struct sk_buff *);
 static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
 #ifdef CONFIG_HOTPLUG_CPU
 static int fcoe_cpu_callback(struct notifier_block *, ulong, void *);
@@ -91,13 +90,13 @@ static struct notifier_block fcoe_cpu_notifier = {
 };
 
 /**
- * fcoe_create_percpu_data - creates the associated cpu data
+ * fcoe_create_percpu_data() - creates the associated cpu data
  * @cpu: index for the cpu where fcoe cpu data will be created
  *
  * create percpu stats block, from cpu add notifier
  *
  * Returns: none
- **/
+ */
 static void fcoe_create_percpu_data(int cpu)
 {
 	struct fc_lport *lp;
@@ -115,13 +114,13 @@ static void fcoe_create_percpu_data(int cpu)
 }
 
 /**
- * fcoe_destroy_percpu_data - destroys the associated cpu data
+ * fcoe_destroy_percpu_data() - destroys the associated cpu data
  * @cpu: index for the cpu where fcoe cpu data will destroyed
  *
  * destroy percpu stats block called by cpu add/remove notifier
  *
  * Retuns: none
- **/
+ */
 static void fcoe_destroy_percpu_data(int cpu)
 {
 	struct fc_lport *lp;
@@ -137,7 +136,7 @@ static void fcoe_destroy_percpu_data(int cpu)
 }
 
 /**
- * fcoe_cpu_callback - fcoe cpu hotplug event callback
+ * fcoe_cpu_callback() - fcoe cpu hotplug event callback
  * @nfb: callback data block
  * @action: event triggering the callback
  * @hcpu: index for the cpu of this event
@@ -145,7 +144,7 @@ static void fcoe_destroy_percpu_data(int cpu)
  * this creates or destroys per cpu data for fcoe
  *
  * Returns NOTIFY_OK always.
- **/
+ */
 static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
@@ -166,7 +165,7 @@ static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
 #endif /* CONFIG_HOTPLUG_CPU */
 
 /**
- * fcoe_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
+ * fcoe_rcv() - this is the fcoe receive function called by NET_RX_SOFTIRQ
  * @skb: the receive skb
  * @dev: associated net device
  * @ptype: context
@@ -175,7 +174,7 @@ static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
  * this function will receive the packet and build fc frame and pass it up
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	     struct packet_type *ptype, struct net_device *olddev)
 {
@@ -265,11 +264,11 @@ err2:
 EXPORT_SYMBOL_GPL(fcoe_rcv);
 
 /**
- * fcoe_start_io - pass to netdev to start xmit for fcoe
+ * fcoe_start_io() - pass to netdev to start xmit for fcoe
  * @skb: the skb to be xmitted
  *
  * Returns: 0 for success
- **/
+ */
 static inline int fcoe_start_io(struct sk_buff *skb)
 {
 	int rc;
@@ -283,12 +282,12 @@ static inline int fcoe_start_io(struct sk_buff *skb)
 }
 
 /**
- * fcoe_get_paged_crc_eof - in case we need alloc a page for crc_eof
+ * fcoe_get_paged_crc_eof() - in case we need alloc a page for crc_eof
  * @skb: the skb to be xmitted
  * @tlen: total len
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	struct fcoe_percpu_s *fps;
@@ -326,13 +325,12 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 }
 
 /**
- * fcoe_fc_crc - calculates FC CRC in this fcoe skb
+ * fcoe_fc_crc() - calculates FC CRC in this fcoe skb
  * @fp: the fc_frame containg data to be checksummed
  *
  * This uses crc32() to calculate the crc for fc frame
  * Return   : 32 bit crc
- *
- **/
+ */
 u32 fcoe_fc_crc(struct fc_frame *fp)
 {
 	struct sk_buff *skb = fp_skb(fp);
@@ -363,13 +361,12 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 EXPORT_SYMBOL_GPL(fcoe_fc_crc);
 
 /**
- * fcoe_xmit - FCoE frame transmit function
+ * fcoe_xmit() - FCoE frame transmit function
  * @lp:	the associated local port
  * @fp: the fc_frame to be transmitted
  *
  * Return   : 0 for success
- *
- **/
+ */
 int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 {
 	int wlen, rc = 0;
@@ -389,7 +386,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 
 	WARN_ON((fr_len(fp) % sizeof(u32)) != 0);
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 	/*
 	 * if it is a flogi then we need to learn gw-addr
 	 * and my own fcid
@@ -439,7 +436,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	if (skb_is_nonlinear(skb)) {
 		skb_frag_t *frag;
 		if (fcoe_get_paged_crc_eof(skb, tlen)) {
-			kfree(skb);
+			kfree_skb(skb);
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
@@ -502,21 +499,22 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		rc = fcoe_start_io(skb);
 
 	if (rc) {
-		fcoe_insert_wait_queue(lp, skb);
+		spin_lock_bh(&fc->fcoe_pending_queue.lock);
+		__skb_queue_tail(&fc->fcoe_pending_queue, skb);
+		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
 		if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-			fc_pause(lp);
+			lp->qfull = 1;
 	}
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_xmit);
 
-/*
- * fcoe_percpu_receive_thread - recv thread per cpu
+/**
+ * fcoe_percpu_receive_thread() - recv thread per cpu
  * @arg: ptr to the fcoe per cpu struct
  *
  * Return: 0 for success
- *
  */
 int fcoe_percpu_receive_thread(void *arg)
 {
@@ -533,7 +531,7 @@ int fcoe_percpu_receive_thread(void *arg)
 	struct fcoe_softc *fc;
 	struct fcoe_hdr *hp;
 
-	set_user_nice(current, 19);
+	set_user_nice(current, -20);
 
 	while (!kthread_should_stop()) {
 
@@ -658,7 +656,7 @@ int fcoe_percpu_receive_thread(void *arg)
 }
 
 /**
- * fcoe_recv_flogi - flogi receive function
+ * fcoe_recv_flogi() - flogi receive function
  * @fc: associated fcoe_softc
  * @fp: the recieved frame
  * @sa: the source address of this flogi
@@ -667,7 +665,7 @@ int fcoe_percpu_receive_thread(void *arg)
  * mac address for the initiator, eitehr OUI based or GW based.
  *
  * Returns: none
- **/
+ */
 static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
 {
 	struct fc_frame_header *fh;
@@ -715,32 +713,23 @@ static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
 }
 
 /**
- * fcoe_watchdog - fcoe timer callback
+ * fcoe_watchdog() - fcoe timer callback
  * @vp:
  *
- * This checks the pending queue length for fcoe and put fcoe to be paused state
+ * This checks the pending queue length for fcoe and set lport qfull
  * if the FCOE_MAX_QUEUE_DEPTH is reached. This is done for all fc_lport on the
  * fcoe_hostlist.
  *
  * Returns: 0 for success
- **/
+ */
 void fcoe_watchdog(ulong vp)
 {
-	struct fc_lport *lp;
 	struct fcoe_softc *fc;
-	int paused = 0;
 
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		lp = fc->lp;
-		if (lp) {
-			if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-				paused = 1;
-			if (fcoe_check_wait_queue(lp) <	 FCOE_MAX_QUEUE_DEPTH) {
-				if (paused)
-					fc_unpause(lp);
-			}
-		}
+		if (fc->lp)
+			fcoe_check_wait_queue(fc->lp);
 	}
 	read_unlock(&fcoe_hostlist_lock);
 
@@ -750,96 +739,64 @@ void fcoe_watchdog(ulong vp)
 

 /**
- * fcoe_check_wait_queue - put the skb into fcoe pending xmit queue
+ * fcoe_check_wait_queue() - put the skb into fcoe pending xmit queue
  * @lp: the fc_port for this skb
  * @skb: the associated skb to be xmitted
  *
  * This empties the wait_queue, dequeue the head of the wait_queue queue
  * and calls fcoe_start_io() for each packet, if all skb have been
- * transmitted, return 0 if a error occurs, then restore wait_queue and
- * try again later.
+ * transmitted, return qlen or -1 if a error occurs, then restore
+ * wait_queue and  try again later.
  *
  * The wait_queue is used when the skb transmit fails. skb will go
  * in the wait_queue which will be emptied by the time function OR
  * by the next skb transmit.
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_check_wait_queue(struct fc_lport *lp)
 {
-	int rc, unpause = 0;
-	int paused = 0;
+	struct fcoe_softc *fc = lport_priv(lp);
 	struct sk_buff *skb;
-	struct fcoe_softc *fc;
+	int rc = -1;
 
-	fc = fcoe_softc(lp);
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+	if (fc->fcoe_pending_queue_active)
+		goto out;
+	fc->fcoe_pending_queue_active = 1;
 
-	/*
-	 * is this interface paused?
-	 */
-	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-		paused = 1;
-	if (fc->fcoe_pending_queue.qlen) {
-		while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
-			spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-			rc = fcoe_start_io(skb);
-			if (rc) {
-				fcoe_insert_wait_queue_head(lp, skb);
-				return rc;
-			}
-			spin_lock_bh(&fc->fcoe_pending_queue.lock);
-		}
-		if (fc->fcoe_pending_queue.qlen < FCOE_MAX_QUEUE_DEPTH)
-			unpause = 1;
-	}
-	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-	if ((unpause) && (paused))
-		fc_unpause(lp);
-	return fc->fcoe_pending_queue.qlen;
-}
-
-/**
- * fcoe_insert_wait_queue_head - puts skb to fcoe pending queue head
- * @lp: the fc_port for this skb
- * @skb: the associated skb to be xmitted
- *
- * Returns: none
- **/
-static void fcoe_insert_wait_queue_head(struct fc_lport *lp,
-					struct sk_buff *skb)
-{
-	struct fcoe_softc *fc;
+	while (fc->fcoe_pending_queue.qlen) {
+		/* keep qlen > 0 until fcoe_start_io succeeds */
+		fc->fcoe_pending_queue.qlen++;
+		skb = __skb_dequeue(&fc->fcoe_pending_queue);
 
-	fc = fcoe_softc(lp);
-	spin_lock_bh(&fc->fcoe_pending_queue.lock);
-	__skb_queue_head(&fc->fcoe_pending_queue, skb);
-	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-}
+		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+		rc = fcoe_start_io(skb);
+		spin_lock_bh(&fc->fcoe_pending_queue.lock);
 
-/**
- * fcoe_insert_wait_queue - put the skb into fcoe pending queue tail
- * @lp: the fc_port for this skb
- * @skb: the associated skb to be xmitted
- *
- * Returns: none
- **/
-static void fcoe_insert_wait_queue(struct fc_lport *lp,
-				   struct sk_buff *skb)
-{
-	struct fcoe_softc *fc;
+		if (rc) {
+			__skb_queue_head(&fc->fcoe_pending_queue, skb);
+			/* undo temporary increment above */
+			fc->fcoe_pending_queue.qlen--;
+			break;
+		}
+		/* undo temporary increment above */
+		fc->fcoe_pending_queue.qlen--;
+	}
 
-	fc = fcoe_softc(lp);
-	spin_lock_bh(&fc->fcoe_pending_queue.lock);
-	__skb_queue_tail(&fc->fcoe_pending_queue, skb);
+	if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
+		lp->qfull = 0;
+	fc->fcoe_pending_queue_active = 0;
+	rc = fc->fcoe_pending_queue.qlen;
+out:
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+	return rc;
 }
 
 /**
- * fcoe_dev_setup - setup link change notification interface
- *
- **/
-static void fcoe_dev_setup(void)
+ * fcoe_dev_setup() - setup link change notification interface
+ */
+static void fcoe_dev_setup()
 {
 	/*
 	 * here setup a interface specific wd time to
@@ -849,15 +806,15 @@ static void fcoe_dev_setup(void)
 }
 
 /**
- * fcoe_dev_setup - cleanup link change notification interface
- **/
+ * fcoe_dev_setup() - cleanup link change notification interface
+ */
 static void fcoe_dev_cleanup(void)
 {
 	unregister_netdevice_notifier(&fcoe_notifier);
 }
 
 /**
- * fcoe_device_notification - netdev event notification callback
+ * fcoe_device_notification() - netdev event notification callback
  * @notifier: context of the notification
  * @event: type of event
  * @ptr: fixed array for output parsed ifname
@@ -865,7 +822,7 @@ static void fcoe_dev_cleanup(void)
  * This function is called by the ethernet driver in case of link change event
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_device_notification(struct notifier_block *notifier,
 				    ulong event, void *ptr)
 {
@@ -873,7 +830,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	struct net_device *real_dev = ptr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *stats;
-	u16 new_status;
+	u32 new_link_up;
 	u32 mfs;
 	int rc = NOTIFY_OK;
 
@@ -890,17 +847,15 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		goto out;
 	}
 
-	new_status = lp->link_status;
+	new_link_up = lp->link_up;
 	switch (event) {
 	case NETDEV_DOWN:
 	case NETDEV_GOING_DOWN:
-		new_status &= ~FC_LINK_UP;
+		new_link_up = 0;
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		new_status &= ~FC_LINK_UP;
-		if (!fcoe_link_ok(lp))
-			new_status |= FC_LINK_UP;
+		new_link_up = !fcoe_link_ok(lp);
 		break;
 	case NETDEV_CHANGEMTU:
 		mfs = fc->real_dev->mtu -
@@ -908,17 +863,15 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 			 sizeof(struct fcoe_crc_eof));
 		if (mfs >= FC_MIN_MAX_FRAME)
 			fc_set_mfs(lp, mfs);
-		new_status &= ~FC_LINK_UP;
-		if (!fcoe_link_ok(lp))
-			new_status |= FC_LINK_UP;
+		new_link_up = !fcoe_link_ok(lp);
 		break;
 	case NETDEV_REGISTER:
 		break;
 	default:
 		FC_DBG("unknown event %ld call", event);
 	}
-	if (lp->link_status != new_status) {
-		if ((new_status & FC_LINK_UP) == FC_LINK_UP)
+	if (lp->link_up != new_link_up) {
+		if (new_link_up)
 			fc_linkup(lp);
 		else {
 			stats = lp->dev_stats[smp_processor_id()];
@@ -933,12 +886,12 @@ out:
 }
 
 /**
- * fcoe_if_to_netdev - parse a name buffer to get netdev
+ * fcoe_if_to_netdev() - parse a name buffer to get netdev
  * @ifname: fixed array for output parsed ifname
  * @buffer: incoming buffer to be copied
  *
  * Returns: NULL or ptr to netdeive
- **/
+ */
 static struct net_device *fcoe_if_to_netdev(const char *buffer)
 {
 	char *cp;
@@ -955,13 +908,13 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
- * fcoe_netdev_to_module_owner - finds out the nic drive moddule of the netdev
+ * fcoe_netdev_to_module_owner() - finds out the nic drive moddule of the netdev
  * @netdev: the target netdev
  *
  * Returns: ptr to the struct module, NULL for failure
- **/
-static struct module *fcoe_netdev_to_module_owner(
-	const struct net_device *netdev)
+ */
+static struct module *
+fcoe_netdev_to_module_owner(const struct net_device *netdev)
 {
 	struct device *dev;
 
@@ -979,12 +932,14 @@ static struct module *fcoe_netdev_to_module_owner(
 }
 
 /**
- * fcoe_ethdrv_get - holds the nic driver module by  try_module_get() for
- * the corresponding netdev.
+ * fcoe_ethdrv_get() - Hold the Ethernet driver
  * @netdev: the target netdev
  *
+ * Holds the Ethernet driver module by try_module_get() for
+ * the corresponding netdev.
+ *
  * Returns: 0 for succsss
- **/
+ */
 static int fcoe_ethdrv_get(const struct net_device *netdev)
 {
 	struct module *owner;
@@ -999,12 +954,14 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
 }
 
 /**
- * fcoe_ethdrv_get - releases the nic driver module by module_put for
- * the corresponding netdev.
+ * fcoe_ethdrv_put() - Release the Ethernet driver
  * @netdev: the target netdev
  *
+ * Releases the Ethernet driver module by module_put for
+ * the corresponding netdev.
+ *
  * Returns: 0 for succsss
- **/
+ */
 static int fcoe_ethdrv_put(const struct net_device *netdev)
 {
 	struct module *owner;
@@ -1020,12 +977,12 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 }
 
 /**
- * fcoe_destroy- handles the destroy from sysfs
+ * fcoe_destroy() - handles the destroy from sysfs
  * @buffer: expcted to be a eth if name
  * @kp: associated kernel param
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
 	int rc;
@@ -1058,12 +1015,12 @@ out_nodev:
 }
 
 /**
- * fcoe_create - handles the create call from sysfs
+ * fcoe_create() - Handles the create call from sysfs
  * @buffer: expcted to be a eth if name
  * @kp: associated kernel param
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_create(const char *buffer, struct kernel_param *kp)
 {
 	int rc;
@@ -1104,8 +1061,8 @@ module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(destroy, "string");
 MODULE_PARM_DESC(destroy, "Destroy fcoe port");
 
-/*
- * fcoe_link_ok - check if link is ok for the fc_lport
+/**
+ * fcoe_link_ok() - Check if link is ok for the fc_lport
  * @lp: ptr to the fc_lport
  *
  * Any permanently-disqualifying conditions have been previously checked.
@@ -1120,7 +1077,7 @@ MODULE_PARM_DESC(destroy, "Destroy fcoe port");
  */
 int fcoe_link_ok(struct fc_lport *lp)
 {
-	struct fcoe_softc *fc = fcoe_softc(lp);
+	struct fcoe_softc *fc = lport_priv(lp);
 	struct net_device *dev = fc->real_dev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 	int rc = 0;
@@ -1149,9 +1106,8 @@ int fcoe_link_ok(struct fc_lport *lp)
 }
 EXPORT_SYMBOL_GPL(fcoe_link_ok);
 
-/*
- * fcoe_percpu_clean - frees skb of the corresponding lport from the per
- * cpu queue.
+/**
+ * fcoe_percpu_clean() - Clear the pending skbs for an lport
  * @lp: the fc_lport
  */
 void fcoe_percpu_clean(struct fc_lport *lp)
@@ -1185,11 +1141,11 @@ void fcoe_percpu_clean(struct fc_lport *lp)
 EXPORT_SYMBOL_GPL(fcoe_percpu_clean);
 
 /**
- * fcoe_clean_pending_queue - dequeue skb and free it
+ * fcoe_clean_pending_queue() - Dequeue a skb and free it
  * @lp: the corresponding fc_lport
  *
  * Returns: none
- **/
+ */
 void fcoe_clean_pending_queue(struct fc_lport *lp)
 {
 	struct fcoe_softc  *fc = lport_priv(lp);
@@ -1206,21 +1162,21 @@ void fcoe_clean_pending_queue(struct fc_lport *lp)
 EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
 
 /**
- * libfc_host_alloc - allocate a Scsi_Host with room for the fc_lport
+ * libfc_host_alloc() - Allocate a Scsi_Host with room for the fc_lport
  * @sht: ptr to the scsi host templ
  * @priv_size: size of private data after fc_lport
  *
  * Returns: ptr to Scsi_Host
- * TODO - to libfc?
+ * TODO: to libfc?
  */
-static inline struct Scsi_Host *libfc_host_alloc(
-	struct scsi_host_template *sht, int priv_size)
+static inline struct Scsi_Host *
+libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
 {
 	return scsi_host_alloc(sht, sizeof(struct fc_lport) + priv_size);
 }
 
 /**
- * fcoe_host_alloc - allocate a Scsi_Host with room for the fcoe_softc
+ * fcoe_host_alloc() - Allocate a Scsi_Host with room for the fcoe_softc
  * @sht: ptr to the scsi host templ
  * @priv_size: size of private data after fc_lport
  *
@@ -1232,8 +1188,8 @@ struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *sht, int priv_size)
 }
 EXPORT_SYMBOL_GPL(fcoe_host_alloc);
 
-/*
- * fcoe_reset - resets the fcoe
+/**
+ * fcoe_reset() - Resets the fcoe
  * @shost: shost the reset is from
  *
  * Returns: always 0
@@ -1246,8 +1202,8 @@ int fcoe_reset(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL_GPL(fcoe_reset);
 
-/*
- * fcoe_wwn_from_mac - converts 48-bit IEEE MAC address to 64-bit FC WWN.
+/**
+ * fcoe_wwn_from_mac() - Converts 48-bit IEEE MAC address to 64-bit FC WWN.
  * @mac: mac address
  * @scheme: check port
  * @port: port indicator for converting
@@ -1286,14 +1242,15 @@ u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
 	return wwn;
 }
 EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
-/*
- * fcoe_hostlist_lookup_softc - find the corresponding lport by a given device
+
+/**
+ * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
  * @device: this is currently ptr to net_device
  *
  * Returns: NULL or the located fcoe_softc
  */
-static struct fcoe_softc *fcoe_hostlist_lookup_softc(
-	const struct net_device *dev)
+static struct fcoe_softc *
+fcoe_hostlist_lookup_softc(const struct net_device *dev)
 {
 	struct fcoe_softc *fc;
 
@@ -1308,8 +1265,8 @@ static struct fcoe_softc *fcoe_hostlist_lookup_softc(
 	return NULL;
 }
 
-/*
- * fcoe_hostlist_lookup - find the corresponding lport by netdev
+/**
+ * fcoe_hostlist_lookup() - Find the corresponding lport by netdev
  * @netdev: ptr to net_device
  *
  * Returns: 0 for success
@@ -1324,8 +1281,8 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 }
 EXPORT_SYMBOL_GPL(fcoe_hostlist_lookup);
 
-/*
- * fcoe_hostlist_add - add a lport to lports list
+/**
+ * fcoe_hostlist_add() - Add a lport to lports list
  * @lp: ptr to the fc_lport to badded
  *
  * Returns: 0 for success
@@ -1336,7 +1293,7 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 
 	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
 	if (!fc) {
-		fc = fcoe_softc(lp);
+		fc = lport_priv(lp);
 		write_lock_bh(&fcoe_hostlist_lock);
 		list_add_tail(&fc->list, &fcoe_hostlist);
 		write_unlock_bh(&fcoe_hostlist_lock);
@@ -1345,8 +1302,8 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 }
 EXPORT_SYMBOL_GPL(fcoe_hostlist_add);
 
-/*
- * fcoe_hostlist_remove - remove a lport from lports list
+/**
+ * fcoe_hostlist_remove() - remove a lport from lports list
  * @lp: ptr to the fc_lport to badded
  *
  * Returns: 0 for success
@@ -1366,12 +1323,12 @@ int fcoe_hostlist_remove(const struct fc_lport *lp)
 EXPORT_SYMBOL_GPL(fcoe_hostlist_remove);
 
 /**
- * fcoe_libfc_config - sets up libfc related properties for lport
+ * fcoe_libfc_config() - sets up libfc related properties for lport
  * @lp: ptr to the fc_lport
  * @tt: libfc function template
  *
  * Returns : 0 for success
- **/
+ */
 int fcoe_libfc_config(struct fc_lport *lp, struct libfc_function_template *tt)
 {
 	/* Set the function pointers set by the LLDD */
@@ -1389,14 +1346,14 @@ int fcoe_libfc_config(struct fc_lport *lp, struct libfc_function_template *tt)
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
 
 /**
- * fcoe_init - fcoe module loading initialization
+ * fcoe_init() - fcoe module loading initialization
  *
  * Initialization routine
  * 1. Will create fc transport software structure
  * 2. initialize the link list of port information structure
  *
  * Returns 0 on success, negative on failure
- **/
+ */
 static int __init fcoe_init(void)
 {
 	int cpu;
@@ -1433,7 +1390,6 @@ static int __init fcoe_init(void)
 			} else {
 				fcoe_percpu[cpu] = NULL;
 				kfree(p);
-
 			}
 		}
 	}
@@ -1443,11 +1399,9 @@ static int __init fcoe_init(void)
 	 */
 	fcoe_dev_setup();
 
-	init_timer(&fcoe_timer);
-	fcoe_timer.data = 0;
-	fcoe_timer.function = fcoe_watchdog;
-	fcoe_timer.expires = (jiffies + (10 * HZ));
-	add_timer(&fcoe_timer);
+	setup_timer(&fcoe_timer, fcoe_watchdog, 0);
+
+	mod_timer(&fcoe_timer, jiffies + (10 * HZ));
 
 	/* initiatlize the fcoe transport */
 	fcoe_transport_init();
@@ -1459,10 +1413,10 @@ static int __init fcoe_init(void)
 module_init(fcoe_init);
 
 /**
- * fcoe_exit - fcoe module unloading cleanup
+ * fcoe_exit() - fcoe module unloading cleanup
  *
  * Returns 0 on success, negative on failure
- **/
+ */
 static void __exit fcoe_exit(void)
 {
 	u32 idx;
@@ -1483,7 +1437,7 @@ static void __exit fcoe_exit(void)
 	 */
 	del_timer_sync(&fcoe_timer);
 
-	/* releases the assocaited fcoe transport for each lport */
+	/* releases the associated fcoe transport for each lport */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
 		fcoe_transport_release(fc->real_dev);
 
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index dd1564c..e57556e 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -64,7 +64,7 @@ static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
 static void fc_disc_restart(struct fc_disc *);
 
 /**
- * fc_disc_lookup_rport - lookup a remote port by port_id
+ * fc_disc_lookup_rport() - lookup a remote port by port_id
  * @lport: Fibre Channel host port instance
  * @port_id: remote port port_id to match
  */
@@ -92,7 +92,7 @@ struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
 }
 
 /**
- * fc_disc_stop_rports - delete all the remote ports associated with the lport
+ * fc_disc_stop_rports() - delete all the remote ports associated with the lport
  * @disc: The discovery job to stop rports on
  *
  * Locking Note: This function expects that the lport mutex is locked before
@@ -117,7 +117,7 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_rport_callback - Event handler for rport events
+ * fc_disc_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
  * @rport: The rport which the event has occured on
  * @event: The event that occured
@@ -151,7 +151,7 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 }
 
 /**
- * fc_disc_recv_rscn_req - Handle Registered State Change Notification (RSCN)
+ * fc_disc_recv_rscn_req() - Handle Registered State Change Notification (RSCN)
  * @sp: Current sequence of the RSCN exchange
  * @fp: RSCN Frame
  * @lport: Fibre Channel host port instance
@@ -246,7 +246,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			list_del(&dp->peers);
 			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
 			if (rport) {
-				rdata = RPORT_TO_PRIV(rport);
+				rdata = rport->dd_data;
 				list_del(&rdata->peers);
 				lport->tt.rport_logoff(rport);
 			}
@@ -265,7 +265,7 @@ reject:
 }
 
 /**
- * fc_disc_recv_req - Handle incoming requests
+ * fc_disc_recv_req() - Handle incoming requests
  * @sp: Current sequence of the request exchange
  * @fp: The frame
  * @lport: The FC local port
@@ -294,7 +294,7 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_disc_restart - Restart discovery
+ * fc_disc_restart() - Restart discovery
  * @lport: FC discovery context
  *
  * Locking Note: This function expects that the disc mutex
@@ -322,7 +322,7 @@ static void fc_disc_restart(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_start - Fibre Channel Target discovery
+ * fc_disc_start() - Fibre Channel Target discovery
  * @lport: FC local port
  *
  * Returns non-zero if discovery cannot be started.
@@ -383,7 +383,7 @@ static struct fc_rport_operations fc_disc_rport_ops = {
 };
 
 /**
- * fc_disc_new_target - Handle new target found by discovery
+ * fc_disc_new_target() - Handle new target found by discovery
  * @lport: FC local port
  * @rport: The previous FC remote port (NULL if new remote port)
  * @ids: Identifiers for the new FC remote port
@@ -396,7 +396,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			      struct fc_rport_identifiers *ids)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_libfc_priv *rp;
+	struct fc_rport_libfc_priv *rdata;
 	int error = 0;
 
 	if (rport && ids->port_name) {
@@ -430,15 +430,15 @@ static int fc_disc_new_target(struct fc_disc *disc,
 				dp.ids.port_name = ids->port_name;
 				dp.ids.node_name = ids->node_name;
 				dp.ids.roles = ids->roles;
-				rport = fc_rport_rogue_create(&dp);
+				rport = lport->tt.rport_create(&dp);
 			}
 			if (!rport)
 				error = -ENOMEM;
 		}
 		if (rport) {
-			rp = rport->dd_data;
-			rp->ops = &fc_disc_rport_ops;
-			rp->rp_state = RPORT_ST_INIT;
+			rdata = rport->dd_data;
+			rdata->ops = &fc_disc_rport_ops;
+			rdata->rp_state = RPORT_ST_INIT;
 			lport->tt.rport_login(rport);
 		}
 	}
@@ -446,20 +446,20 @@ static int fc_disc_new_target(struct fc_disc *disc,
 }
 
 /**
- * fc_disc_del_target - Delete a target
+ * fc_disc_del_target() - Delete a target
  * @disc: FC discovery context
  * @rport: The remote port to be removed
  */
 static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_libfc_priv *rdata = RPORT_TO_PRIV(rport);
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	list_del(&rdata->peers);
 	lport->tt.rport_logoff(rport);
 }
 
 /**
- * fc_disc_done - Discovery has been completed
+ * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
  */
 static void fc_disc_done(struct fc_disc *disc)
@@ -479,7 +479,7 @@ static void fc_disc_done(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_error - Handle error on dNS request
+ * fc_disc_error() - Handle error on dNS request
  * @disc: FC discovery context
  * @fp: The frame pointer
  */
@@ -519,7 +519,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 }
 
 /**
- * fc_disc_gpn_ft_req - Send Get Port Names by FC-4 type (GPN_FT) request
+ * fc_disc_gpn_ft_req() - Send Get Port Names by FC-4 type (GPN_FT) request
  * @lport: FC discovery context
  *
  * Locking Note: This function expects that the disc_mutex is locked
@@ -553,7 +553,7 @@ err:
 }
 
 /**
- * fc_disc_gpn_ft_parse - Parse the list of IDs and names resulting from a request
+ * fc_disc_gpn_ft_parse() - Parse the list of IDs and names resulting from a request
  * @lport: Fibre Channel host port instance
  * @buf: GPN_FT response buffer
  * @len: size of response buffer
@@ -617,7 +617,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 
 		if ((dp.ids.port_id != fc_host_port_id(lport->host)) &&
 		    (dp.ids.port_name != lport->wwpn)) {
-			rport = fc_rport_rogue_create(&dp);
+			rport = lport->tt.rport_create(&dp);
 			if (rport) {
 				rdata = rport->dd_data;
 				rdata->ops = &fc_disc_rport_ops;
@@ -658,7 +658,10 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	return error;
 }
 
-/*
+/**
+ * fc_disc_timeout() - Retry handler for the disc component
+ * @work: Structure holding disc obj that needs retry discovery
+ *
  * Handle retry of memory allocation for remote ports.
  */
 static void fc_disc_timeout(struct work_struct *work)
@@ -673,7 +676,7 @@ static void fc_disc_timeout(struct work_struct *work)
 }
 
 /**
- * fc_disc_gpn_ft_resp - Handle a response frame from Get Port Names (GPN_FT)
+ * fc_disc_gpn_ft_resp() - Handle a response frame from Get Port Names (GPN_FT)
  * @sp: Current sequence of GPN_FT exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
@@ -712,9 +715,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       fr_len(fp));
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
-			/*
-			 * Accepted.  Parse response.
-			 */
+			/* Accepted, parse the response. */
 			buf = cp + 1;
 			len -= sizeof(*cp);
 		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
@@ -746,7 +747,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_disc_single - Discover the directory information for a single target
+ * fc_disc_single() - Discover the directory information for a single target
  * @lport: FC local port
  * @dp: The port to rediscover
  *
@@ -769,7 +770,7 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (rport)
 		fc_disc_del_target(disc, rport);
 
-	new_rport = fc_rport_rogue_create(dp);
+	new_rport = lport->tt.rport_create(dp);
 	if (new_rport) {
 		rdata = new_rport->dd_data;
 		rdata->ops = &fc_disc_rport_ops;
@@ -782,7 +783,7 @@ out:
 }
 
 /**
- * fc_disc_stop - Stop discovery for a given lport
+ * fc_disc_stop() - Stop discovery for a given lport
  * @lport: The lport that discovery should stop for
  */
 void fc_disc_stop(struct fc_lport *lport)
@@ -796,7 +797,7 @@ void fc_disc_stop(struct fc_lport *lport)
 }
 
 /**
- * fc_disc_stop_final - Stop discovery for a given lport
+ * fc_disc_stop_final() - Stop discovery for a given lport
  * @lport: The lport that discovery should stop for
  *
  * This function will block until discovery has been
@@ -809,7 +810,7 @@ void fc_disc_stop_final(struct fc_lport *lport)
 }
 
 /**
- * fc_disc_init - Initialize the discovery block
+ * fc_disc_init() - Initialize the discovery block
  * @lport: FC local port
  */
 int fc_disc_init(struct fc_lport *lport)
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 66db08a..505825b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -32,8 +32,6 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-#define	  FC_DEF_R_A_TOV      (10 * 1000) /* resource allocation timeout */
-
 /*
  * fc_exch_debug can be set in debugger or at compile time to get more logs.
  */
@@ -627,7 +625,6 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 {
 	struct fc_exch *ep;
 	struct fc_frame_header *fh;
-	u16 rxid;
 
 	ep = mp->lp->tt.exch_get(mp->lp, fp);
 	if (ep) {
@@ -654,18 +651,6 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		if ((ntoh24(fh->fh_f_ctl) & FC_FC_SEQ_INIT) == 0)
 			ep->esb_stat &= ~ESB_ST_SEQ_INIT;
 
-		/*
-		 * Set the responder ID in the frame header.
-		 * The old one should've been 0xffff.
-		 * If it isn't, don't assign one.
-		 * Incoming basic link service frames may specify
-		 * a referenced RX_ID.
-		 */
-		if (fh->fh_type != FC_TYPE_BLS) {
-			rxid = ntohs(fh->fh_rx_id);
-			WARN_ON(rxid != FC_XID_UNKNOWN);
-			fh->fh_rx_id = htons(ep->rxid);
-		}
 		fc_exch_hold(ep);	/* hold for caller */
 		spin_unlock_bh(&ep->ex_lock);	/* lock from exch_get */
 	}
@@ -677,8 +662,8 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
  * If fc_pf_rjt_reason is FC_RJT_NONE then this function will have a hold
  * on the ep that should be released by the caller.
  */
-static enum fc_pf_rjt_reason
-fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
+static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_exch_mgr *mp,
+						 struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	struct fc_exch *ep = NULL;
@@ -996,9 +981,9 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
  * Send BLS Reject.
  * This is for rejecting BA_ABTS only.
  */
-static void
-fc_exch_send_ba_rjt(struct fc_frame *rx_fp, enum fc_ba_rjt_reason reason,
-		    enum fc_ba_rjt_explan explan)
+static void fc_exch_send_ba_rjt(struct fc_frame *rx_fp,
+				enum fc_ba_rjt_reason reason,
+				enum fc_ba_rjt_explan explan)
 {
 	struct fc_frame *fp;
 	struct fc_frame_header *rx_fh;
@@ -1096,7 +1081,7 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 		ap->ba_high_seq_cnt = fh->fh_seq_cnt;
 		ap->ba_low_seq_cnt = htons(sp->cnt);
 	}
-	sp = fc_seq_start_next(sp);
+	sp = fc_seq_start_next_locked(sp);
 	spin_unlock_bh(&ep->ex_lock);
 	fc_seq_send_last(sp, fp, FC_RCTL_BA_ACC, FC_TYPE_BLS);
 	fc_frame_free(rx_fp);
@@ -1480,10 +1465,11 @@ static void fc_exch_reset(struct fc_exch *ep)
  * If sid is non-zero, reset only exchanges we source from that FID.
  * If did is non-zero, reset only exchanges destined to that FID.
  */
-void fc_exch_mgr_reset(struct fc_exch_mgr *mp, u32 sid, u32 did)
+void fc_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
 {
 	struct fc_exch *ep;
 	struct fc_exch *next;
+	struct fc_exch_mgr *mp = lp->emp;
 
 	spin_lock_bh(&mp->em_lock);
 restart:
@@ -1607,7 +1593,7 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	if (IS_ERR(fp)) {
 		int err = PTR_ERR(fp);
 
-		if (err == -FC_EX_CLOSED)
+		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
 			goto cleanup;
 		FC_DBG("Cannot process RRQ, because of frame error %d\n", err);
 		return;
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 404e63f..2a631d7 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -161,7 +161,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lp, gfp_t gfp)
 }
 
 /**
- * fc_fcp_pkt_release - release hold on scsi_pkt packet
+ * fc_fcp_pkt_release() - release hold on scsi_pkt packet
  * @fsp:	fcp packet struct
  *
  * This is used by upper layer scsi driver.
@@ -183,8 +183,7 @@ static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_pkt_destory - release hold on scsi_pkt packet
- *
+ * fc_fcp_pkt_destory() - release hold on scsi_pkt packet
  * @seq:		exchange sequence
  * @fsp:	fcp packet struct
  *
@@ -199,7 +198,7 @@ static void fc_fcp_pkt_destroy(struct fc_seq *seq, void *fsp)
 }
 
 /**
- * fc_fcp_lock_pkt - lock a packet and get a ref to it.
+ * fc_fcp_lock_pkt() - lock a packet and get a ref to it.
  * @fsp:	fcp packet
  *
  * We should only return error if we return a command to scsi-ml before
@@ -291,9 +290,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	buf = fc_frame_payload_get(fp, 0);
 
 	if (offset + len > fsp->data_len) {
-		/*
-		 * this should never happen
-		 */
+		/* this should never happen */
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
 		    fc_frame_crc_check(fp))
 			goto crc_err;
@@ -387,8 +384,8 @@ crc_err:
 		fc_fcp_complete_locked(fsp);
 }
 
-/*
- * fc_fcp_send_data -  Send SCSI data to target.
+/**
+ * fc_fcp_send_data() -  Send SCSI data to target.
  * @fsp: ptr to fc_fcp_pkt
  * @sp: ptr to this sequence
  * @offset: starting offset for this data request
@@ -610,8 +607,8 @@ static void fc_fcp_abts_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	}
 }
 
-/*
- * fc_fcp_reduce_can_queue - drop can_queue
+/**
+ * fc_fcp_reduce_can_queue() - drop can_queue
  * @lp: lport to drop queueing for
  *
  * If we are getting memory allocation failures, then we may
@@ -642,9 +639,11 @@ done:
 	spin_unlock_irqrestore(lp->host->host_lock, flags);
 }
 
-/*
- * exch mgr calls this routine to process scsi
- * exchanges.
+/**
+ * fc_fcp_recv() - Reveive FCP frames
+ * @seq: The sequence the frame is on
+ * @fp: The FC frame
+ * @arg: The related FCP packet
  *
  * Return   : None
  * Context  : called from Soft IRQ context
@@ -832,7 +831,7 @@ err:
 }
 
 /**
- * fc_fcp_complete_locked - complete processing of a fcp packet
+ * fc_fcp_complete_locked() - complete processing of a fcp packet
  * @fsp:	fcp packet
  *
  * This function may sleep if a timer is pending. The packet lock must be
@@ -900,7 +899,7 @@ static void fc_fcp_cleanup_cmd(struct fc_fcp_pkt *fsp, int error)
 }
 
 /**
- * fc_fcp_cleanup_each_cmd - run fn on each active command
+ * fc_fcp_cleanup_each_cmd() - Cleanup active commads
  * @lp:		logical port
  * @id:		target id
  * @lun:	lun
@@ -952,7 +951,7 @@ static void fc_fcp_abort_io(struct fc_lport *lp)
 }
 
 /**
- * fc_fcp_pkt_send - send a fcp packet to the lower level.
+ * fc_fcp_pkt_send() - send a fcp packet to the lower level.
  * @lp:		fc lport
  * @fsp:	fc packet.
  *
@@ -1621,7 +1620,7 @@ out:
 static inline int fc_fcp_lport_queue_ready(struct fc_lport *lp)
 {
 	/* lock ? */
-	return (lp->state == LPORT_ST_READY) && (lp->link_status & FC_LINK_UP);
+	return (lp->state == LPORT_ST_READY) && lp->link_up && !lp->qfull;
 }
 
 /**
@@ -1727,7 +1726,7 @@ out:
 EXPORT_SYMBOL(fc_queuecommand);
 
 /**
- * fc_io_compl -  Handle responses for completed commands
+ * fc_io_compl() -  Handle responses for completed commands
  * @fsp:	scsi packet
  *
  * Translates a error to a Linux SCSI error.
@@ -1810,12 +1809,12 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		sc_cmd->result = DID_ERROR << 16;
 		break;
 	case FC_DATA_UNDRUN:
-		if (fsp->cdb_status == 0) {
+		if ((fsp->cdb_status == 0) && !(fsp->req_flags & FC_SRB_READ)) {
 			/*
 			 * scsi status is good but transport level
-			 * underrun. for read it should be an error??
+			 * underrun.
 			 */
-			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
+			sc_cmd->result = DID_OK << 16;
 		} else {
 			/*
 			 * scsi got underrun, this is an error
@@ -1857,7 +1856,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_complete - complete processing of a fcp packet
+ * fc_fcp_complete() - complete processing of a fcp packet
  * @fsp:	fcp packet
  *
  * This function may sleep if a fsp timer is pending.
@@ -1874,9 +1873,10 @@ void fc_fcp_complete(struct fc_fcp_pkt *fsp)
 EXPORT_SYMBOL(fc_fcp_complete);
 
 /**
- * fc_eh_abort - Abort a command...from scsi host template
+ * fc_eh_abort() - Abort a command
  * @sc_cmd:	scsi command to abort
  *
+ * From scsi host template.
  * send ABTS to the target device  and wait for the response
  * sc_cmd is the pointer to the command to be aborted.
  */
@@ -1890,7 +1890,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	lp = shost_priv(sc_cmd->device->host);
 	if (lp->state != LPORT_ST_READY)
 		return rc;
-	else if (!(lp->link_status & FC_LINK_UP))
+	else if (!lp->link_up)
 		return rc;
 
 	spin_lock_irqsave(lp->host->host_lock, flags);
@@ -1920,7 +1920,7 @@ release_pkt:
 EXPORT_SYMBOL(fc_eh_abort);
 
 /**
- * fc_eh_device_reset: Reset a single LUN
+ * fc_eh_device_reset() Reset a single LUN
  * @sc_cmd:	scsi command
  *
  * Set from scsi host template to send tm cmd to the target and wait for the
@@ -1973,7 +1973,7 @@ out:
 EXPORT_SYMBOL(fc_eh_device_reset);
 
 /**
- * fc_eh_host_reset - The reset function will reset the ports on the host.
+ * fc_eh_host_reset() - The reset function will reset the ports on the host.
  * @sc_cmd:	scsi command
  */
 int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
@@ -1999,7 +1999,7 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 EXPORT_SYMBOL(fc_eh_host_reset);
 
 /**
- * fc_slave_alloc - configure queue depth
+ * fc_slave_alloc() - configure queue depth
  * @sdev:	scsi device
  *
  * Configures queue depth based on host's cmd_per_len. If not set
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 0b9bdb1..2ae50a1 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -139,7 +139,7 @@ static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
- * fc_lport_rport_callback - Event handler for rport events
+ * fc_lport_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
  * @rport: The rport which the event has occured on
  * @event: The event that occured
@@ -195,7 +195,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 }
 
 /**
- * fc_lport_state - Return a string which represents the lport's state
+ * fc_lport_state() - Return a string which represents the lport's state
  * @lport: The lport whose state is to converted to a string
  */
 static const char *fc_lport_state(struct fc_lport *lport)
@@ -209,7 +209,7 @@ static const char *fc_lport_state(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_ptp_setup - Create an rport for point-to-point mode
+ * fc_lport_ptp_setup() - Create an rport for point-to-point mode
  * @lport: The lport to attach the ptp rport to
  * @fid: The FID of the ptp rport
  * @remote_wwpn: The WWPN of the ptp rport
@@ -232,7 +232,7 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 		lport->ptp_rp = NULL;
 	}
 
-	lport->ptp_rp = fc_rport_rogue_create(&dp);
+	lport->ptp_rp = lport->tt.rport_create(&dp);
 
 	lport->tt.rport_login(lport->ptp_rp);
 
@@ -250,7 +250,7 @@ void fc_get_host_port_state(struct Scsi_Host *shost)
 {
 	struct fc_lport *lp = shost_priv(shost);
 
-	if ((lp->link_status & FC_LINK_UP) == FC_LINK_UP)
+	if (lp->link_up)
 		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
 	else
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
@@ -351,7 +351,7 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
 }
 
 /**
- * fc_lport_recv_rlir_req - Handle received Registered Link Incident Report.
+ * fc_lport_recv_rlir_req() - Handle received Registered Link Incident Report.
  * @lport: Fibre Channel local port recieving the RLIR
  * @sp: current sequence in the RLIR exchange
  * @fp: RLIR request frame
@@ -370,7 +370,7 @@ static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_lport_recv_echo_req - Handle received ECHO request
+ * fc_lport_recv_echo_req() - Handle received ECHO request
  * @lport: Fibre Channel local port recieving the ECHO
  * @sp: current sequence in the ECHO exchange
  * @fp: ECHO request frame
@@ -412,7 +412,7 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_echo_req - Handle received Request Node ID data request
+ * fc_lport_recv_echo_req() - Handle received Request Node ID data request
  * @lport: Fibre Channel local port recieving the RNID
  * @sp: current sequence in the RNID exchange
  * @fp: RNID request frame
@@ -479,7 +479,7 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_adisc_req - Handle received Address Discovery Request
+ * fc_lport_recv_adisc_req() - Handle received Address Discovery Request
  * @lport: Fibre Channel local port recieving the ADISC
  * @sp: current sequence in the ADISC exchange
  * @fp: ADISC request frame
@@ -529,7 +529,7 @@ static void fc_lport_recv_adisc_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_logo_req - Handle received fabric LOGO request
+ * fc_lport_recv_logo_req() - Handle received fabric LOGO request
  * @lport: Fibre Channel local port recieving the LOGO
  * @sp: current sequence in the LOGO exchange
  * @fp: LOGO request frame
@@ -546,7 +546,7 @@ static void fc_lport_recv_logo_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_fabric_login - Start the lport state machine
+ * fc_fabric_login() - Start the lport state machine
  * @lport: The lport that should log into the fabric
  *
  * Locking Note: This function should not be called
@@ -568,7 +568,7 @@ int fc_fabric_login(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_fabric_login);
 
 /**
- * fc_linkup - Handler for transport linkup events
+ * fc_linkup() - Handler for transport linkup events
  * @lport: The lport whose link is up
  */
 void fc_linkup(struct fc_lport *lport)
@@ -577,8 +577,8 @@ void fc_linkup(struct fc_lport *lport)
 		       fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
-	if ((lport->link_status & FC_LINK_UP) != FC_LINK_UP) {
-		lport->link_status |= FC_LINK_UP;
+	if (!lport->link_up) {
+		lport->link_up = 1;
 
 		if (lport->state == LPORT_ST_RESET)
 			fc_lport_enter_flogi(lport);
@@ -588,7 +588,7 @@ void fc_linkup(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_linkup);
 
 /**
- * fc_linkdown - Handler for transport linkdown events
+ * fc_linkdown() - Handler for transport linkdown events
  * @lport: The lport whose link is down
  */
 void fc_linkdown(struct fc_lport *lport)
@@ -597,8 +597,8 @@ void fc_linkdown(struct fc_lport *lport)
 	FC_DEBUG_LPORT("Link is down for port (%6x)\n",
 		       fc_host_port_id(lport->host));
 
-	if ((lport->link_status & FC_LINK_UP) == FC_LINK_UP) {
-		lport->link_status &= ~(FC_LINK_UP);
+	if (lport->link_up) {
+		lport->link_up = 0;
 		fc_lport_enter_reset(lport);
 		lport->tt.fcp_cleanup(lport);
 	}
@@ -607,48 +607,25 @@ void fc_linkdown(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_linkdown);
 
 /**
- * fc_pause - Pause the flow of frames
- * @lport: The lport to be paused
- */
-void fc_pause(struct fc_lport *lport)
-{
-	mutex_lock(&lport->lp_mutex);
-	lport->link_status |= FC_PAUSE;
-	mutex_unlock(&lport->lp_mutex);
-}
-EXPORT_SYMBOL(fc_pause);
-
-/**
- * fc_unpause - Unpause the flow of frames
- * @lport: The lport to be unpaused
- */
-void fc_unpause(struct fc_lport *lport)
-{
-	mutex_lock(&lport->lp_mutex);
-	lport->link_status &= ~(FC_PAUSE);
-	mutex_unlock(&lport->lp_mutex);
-}
-EXPORT_SYMBOL(fc_unpause);
-
-/**
- * fc_fabric_logoff - Logout of the fabric
+ * fc_fabric_logoff() - Logout of the fabric
  * @lport:	      fc_lport pointer to logoff the fabric
  *
  * Return value:
  *	0 for success, -1 for failure
- **/
+ */
 int fc_fabric_logoff(struct fc_lport *lport)
 {
 	lport->tt.disc_stop_final(lport);
 	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_logo(lport);
 	mutex_unlock(&lport->lp_mutex);
+	cancel_delayed_work_sync(&lport->retry_work);
 	return 0;
 }
 EXPORT_SYMBOL(fc_fabric_logoff);
 
 /**
- * fc_lport_destroy - unregister a fc_lport
+ * fc_lport_destroy() - unregister a fc_lport
  * @lport:	      fc_lport pointer to unregister
  *
  * Return value:
@@ -658,26 +635,25 @@ EXPORT_SYMBOL(fc_fabric_logoff);
  * clean-up all the allocated memory
  * and free up other system resources.
  *
- **/
+ */
 int fc_lport_destroy(struct fc_lport *lport)
 {
 	lport->tt.frame_send = fc_frame_drop;
 	lport->tt.fcp_abort_io(lport);
-	lport->tt.exch_mgr_reset(lport->emp, 0, 0);
+	lport->tt.exch_mgr_reset(lport, 0, 0);
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_destroy);
 
 /**
- * fc_set_mfs - sets up the mfs for the corresponding fc_lport
+ * fc_set_mfs() - sets up the mfs for the corresponding fc_lport
  * @lport: fc_lport pointer to unregister
  * @mfs: the new mfs for fc_lport
  *
  * Set mfs for the given fc_lport to the new mfs.
  *
  * Return: 0 for success
- *
- **/
+ */
 int fc_set_mfs(struct fc_lport *lport, u32 mfs)
 {
 	unsigned int old_mfs;
@@ -706,7 +682,7 @@ int fc_set_mfs(struct fc_lport *lport, u32 mfs)
 EXPORT_SYMBOL(fc_set_mfs);
 
 /**
- * fc_lport_disc_callback - Callback for discovery events
+ * fc_lport_disc_callback() - Callback for discovery events
  * @lport: FC local port
  * @event: The discovery event
  */
@@ -731,7 +707,7 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 }
 
 /**
- * fc_rport_enter_ready - Enter the ready state and start discovery
+ * fc_rport_enter_ready() - Enter the ready state and start discovery
  * @lport: Fibre Channel local port that is ready
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -748,7 +724,7 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_recv_flogi_req - Receive a FLOGI request
+ * fc_lport_recv_flogi_req() - Receive a FLOGI request
  * @sp_in: The sequence the FLOGI is on
  * @rx_fp: The frame the FLOGI is in
  * @lport: The lport that recieved the request
@@ -838,7 +814,7 @@ out:
 }
 
 /**
- * fc_lport_recv_req - The generic lport request handler
+ * fc_lport_recv_req() - The generic lport request handler
  * @lport: The lport that received the request
  * @sp: The sequence the request is on
  * @fp: The frame the request is in
@@ -934,7 +910,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 }
 
 /**
- * fc_lport_reset - Reset an lport
+ * fc_lport_reset() - Reset an lport
  * @lport: The lport which should be reset
  *
  * Locking Note: This functions should not be called with the
@@ -942,6 +918,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
  */
 int fc_lport_reset(struct fc_lport *lport)
 {
+	cancel_delayed_work_sync(&lport->retry_work);
 	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_reset(lport);
 	mutex_unlock(&lport->lp_mutex);
@@ -950,7 +927,7 @@ int fc_lport_reset(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_lport_reset);
 
 /**
- * fc_rport_enter_reset - Reset the local port
+ * fc_rport_enter_reset() - Reset the local port
  * @lport: Fibre Channel local port to be reset
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -973,16 +950,16 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 
 	lport->tt.disc_stop(lport);
 
-	lport->tt.exch_mgr_reset(lport->emp, 0, 0);
+	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_host_fabric_name(lport->host) = 0;
 	fc_host_port_id(lport->host) = 0;
 
-	if ((lport->link_status & FC_LINK_UP) == FC_LINK_UP)
+	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
 }
 
 /**
- * fc_lport_error - Handler for any errors
+ * fc_lport_error() - Handler for any errors
  * @lport: The fc_lport object
  * @fp: The frame pointer
  *
@@ -1029,8 +1006,8 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
- * fc_lport_rft_id_resp - Handle response to Register Fibre
- *			  Channel Types by ID (RPN_ID) request
+ * fc_lport_rft_id_resp() - Handle response to Register Fibre
+ *			    Channel Types by ID (RPN_ID) request
  * @sp: current sequence in RPN_ID exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
@@ -1053,17 +1030,17 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RFT_ID response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_RFT_ID) {
 		FC_DBG("Received a RFT_ID response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 
@@ -1081,8 +1058,8 @@ err:
 }
 
 /**
- * fc_lport_rpn_id_resp - Handle response to Register Port
- *			  Name by ID (RPN_ID) request
+ * fc_lport_rpn_id_resp() - Handle response to Register Port
+ *			    Name by ID (RPN_ID) request
  * @sp: current sequence in RPN_ID exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
@@ -1105,17 +1082,17 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RPN_ID response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_RPN_ID) {
 		FC_DBG("Received a RPN_ID response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
@@ -1133,7 +1110,7 @@ err:
 }
 
 /**
- * fc_lport_scr_resp - Handle response to State Change Register (SCR) request
+ * fc_lport_scr_resp() - Handle response to State Change Register (SCR) request
  * @sp: current sequence in SCR exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel lport port instance that sent the registration request
@@ -1155,17 +1132,17 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a SCR response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_SCR) {
 		FC_DBG("Received a SCR response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_ready(lport);
@@ -1179,7 +1156,7 @@ err:
 }
 
 /**
- * fc_lport_enter_scr - Send a State Change Register (SCR) request
+ * fc_lport_enter_scr() - Send a State Change Register (SCR) request
  * @lport: Fibre Channel local port to register for state changes
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1206,7 +1183,7 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_enter_rft_id - Register FC4-types with the name server
+ * fc_lport_enter_rft_id() - Register FC4-types with the name server
  * @lport: Fibre Channel local port to register
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1248,7 +1225,7 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 }
 
 /**
- * fc_rport_enter_rft_id - Register port name with the name server
+ * fc_rport_enter_rft_id() - Register port name with the name server
  * @lport: Fibre Channel local port to register
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1281,7 +1258,7 @@ static struct fc_rport_operations fc_lport_rport_ops = {
 };
 
 /**
- * fc_rport_enter_dns - Create a rport to the name server
+ * fc_rport_enter_dns() - Create a rport to the name server
  * @lport: Fibre Channel local port requesting a rport for the name server
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1304,7 +1281,7 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
-	rport = fc_rport_rogue_create(&dp);
+	rport = lport->tt.rport_create(&dp);
 	if (!rport)
 		goto err;
 
@@ -1318,7 +1295,7 @@ err:
 }
 
 /**
- * fc_lport_timeout - Handler for the retry_work timer.
+ * fc_lport_timeout() - Handler for the retry_work timer.
  * @work: The work struct of the fc_lport
  */
 static void fc_lport_timeout(struct work_struct *work)
@@ -1359,7 +1336,7 @@ static void fc_lport_timeout(struct work_struct *work)
 }
 
 /**
- * fc_lport_logo_resp - Handle response to LOGO request
+ * fc_lport_logo_resp() - Handle response to LOGO request
  * @sp: current sequence in LOGO exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel lport port instance that sent the LOGO request
@@ -1381,17 +1358,17 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a LOGO response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_LOGO) {
 		FC_DBG("Received a LOGO response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_reset(lport);
@@ -1405,7 +1382,7 @@ err:
 }
 
 /**
- * fc_rport_enter_logo - Logout of the fabric
+ * fc_rport_enter_logo() - Logout of the fabric
  * @lport: Fibre Channel local port to be logged out
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1437,7 +1414,7 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_flogi_resp - Handle response to FLOGI request
+ * fc_lport_flogi_resp() - Handle response to FLOGI request
  * @sp: current sequence in FLOGI exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel lport port instance that sent the FLOGI request
@@ -1465,17 +1442,17 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a FLOGI response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_FLOGI) {
 		FC_DBG("Received a FLOGI response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	fh = fc_frame_header_get(fp);
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
@@ -1532,7 +1509,7 @@ err:
 }
 
 /**
- * fc_rport_enter_flogi - Send a FLOGI request to the fabric manager
+ * fc_rport_enter_flogi() - Send a FLOGI request to the fabric manager
  * @lport: Fibre Channel local port to be logged in to the fabric
  *
  * Locking Note: The lport lock is expected to be held before calling
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e780d8c..dae6513 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -81,6 +81,7 @@ static void fc_rport_recv_logo_req(struct fc_rport *,
 				   struct fc_seq *, struct fc_frame *);
 static void fc_rport_timeout(struct work_struct *);
 static void fc_rport_error(struct fc_rport *, struct fc_frame *);
+static void fc_rport_error_retry(struct fc_rport *, struct fc_frame *);
 static void fc_rport_work(struct work_struct *);
 
 static const char *fc_rport_state_names[] = {
@@ -145,7 +146,7 @@ struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
 }
 
 /**
- * fc_rport_state - return a string for the state the rport is in
+ * fc_rport_state() - return a string for the state the rport is in
  * @rport: The rport whose state we want to get a string for
  */
 static const char *fc_rport_state(struct fc_rport *rport)
@@ -160,7 +161,7 @@ static const char *fc_rport_state(struct fc_rport *rport)
 }
 
 /**
- * fc_set_rport_loss_tmo - Set the remote port loss timeout in seconds.
+ * fc_set_rport_loss_tmo() - Set the remote port loss timeout in seconds.
  * @rport: Pointer to Fibre Channel remote port structure
  * @timeout: timeout in seconds
  */
@@ -174,12 +175,12 @@ void fc_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 EXPORT_SYMBOL(fc_set_rport_loss_tmo);
 
 /**
- * fc_plogi_get_maxframe - Get max payload from the common service parameters
+ * fc_plogi_get_maxframe() - Get max payload from the common service parameters
  * @flp: FLOGI payload structure
  * @maxval: upper limit, may be less than what is in the service parameters
  */
-static unsigned int
-fc_plogi_get_maxframe(struct fc_els_flogi *flp, unsigned int maxval)
+static unsigned int fc_plogi_get_maxframe(struct fc_els_flogi *flp,
+					  unsigned int maxval)
 {
 	unsigned int mfs;
 
@@ -197,7 +198,7 @@ fc_plogi_get_maxframe(struct fc_els_flogi *flp, unsigned int maxval)
 }
 
 /**
- * fc_rport_state_enter - Change the rport's state
+ * fc_rport_state_enter() - Change the rport's state
  * @rport: The rport whose state should change
  * @new: The new state of the rport
  *
@@ -214,6 +215,7 @@ static void fc_rport_state_enter(struct fc_rport *rport,
 
 static void fc_rport_work(struct work_struct *work)
 {
+	u32 port_id;
 	struct fc_rport_libfc_priv *rdata =
 		container_of(work, struct fc_rport_libfc_priv, event_work);
 	enum fc_rport_event event;
@@ -279,14 +281,18 @@ static void fc_rport_work(struct work_struct *work)
 			rport_ops->event_callback(lport, rport, event);
 		if (trans_state == FC_PORTSTATE_ROGUE)
 			put_device(&rport->dev);
-		else
+		else {
+			port_id = rport->port_id;
 			fc_remote_port_delete(rport);
+			lport->tt.exch_mgr_reset(lport, 0, port_id);
+			lport->tt.exch_mgr_reset(lport, port_id, 0);
+		}
 	} else
 		mutex_unlock(&rdata->rp_mutex);
 }
 
 /**
- * fc_rport_login - Start the remote port login state machine
+ * fc_rport_login() - Start the remote port login state machine
  * @rport: Fibre Channel remote port
  *
  * Locking Note: Called without the rport lock held. This
@@ -309,7 +315,7 @@ int fc_rport_login(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_logoff - Logoff and remove an rport
+ * fc_rport_logoff() - Logoff and remove an rport
  * @rport: Fibre Channel remote port to be removed
  *
  * Locking Note: Called without the rport lock held. This
@@ -347,7 +353,7 @@ int fc_rport_logoff(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_enter_ready - The rport is ready
+ * fc_rport_enter_ready() - The rport is ready
  * @rport: Fibre Channel remote port that is ready
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -366,7 +372,7 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_timeout - Handler for the retry_work timer.
+ * fc_rport_timeout() - Handler for the retry_work timer.
  * @work: The work struct of the fc_rport_libfc_priv
  *
  * Locking Note: Called without the rport lock held. This
@@ -405,59 +411,75 @@ static void fc_rport_timeout(struct work_struct *work)
 }
 
 /**
- * fc_rport_error - Handler for any errors
+ * fc_rport_error() - Error handler, called once retries have been exhausted
  * @rport: The fc_rport object
  * @fp: The frame pointer
  *
- * If the error was caused by a resource allocation failure
- * then wait for half a second and retry, otherwise retry
- * immediately.
- *
  * Locking Note: The rport lock is expected to be held before
  * calling this routine
  */
 static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
-	unsigned long delay = 0;
 
 	FC_DEBUG_RPORT("Error %ld in state %s, retries %d\n",
 		       PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
 
-	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
-		/*
-		 * Memory allocation failure, or the exchange timed out.
-		 *  Retry after delay
-		 */
-		if (rdata->retries < rdata->local_port->max_retry_count) {
-			rdata->retries++;
-			if (!fp)
-				delay = msecs_to_jiffies(500);
-			get_device(&rport->dev);
-			schedule_delayed_work(&rdata->retry_work, delay);
-		} else {
-			switch (rdata->rp_state) {
-			case RPORT_ST_PLOGI:
-			case RPORT_ST_PRLI:
-			case RPORT_ST_LOGO:
-				rdata->event = RPORT_EV_FAILED;
-				queue_work(rport_event_queue,
-					   &rdata->event_work);
-				break;
-			case RPORT_ST_RTV:
-				fc_rport_enter_ready(rport);
-				break;
-			case RPORT_ST_NONE:
-			case RPORT_ST_READY:
-			case RPORT_ST_INIT:
-				break;
-			}
-		}
+	switch (rdata->rp_state) {
+	case RPORT_ST_PLOGI:
+	case RPORT_ST_PRLI:
+	case RPORT_ST_LOGO:
+		rdata->event = RPORT_EV_FAILED;
+		queue_work(rport_event_queue,
+			   &rdata->event_work);
+		break;
+	case RPORT_ST_RTV:
+		fc_rport_enter_ready(rport);
+		break;
+	case RPORT_ST_NONE:
+	case RPORT_ST_READY:
+	case RPORT_ST_INIT:
+		break;
 	}
 }
 
 /**
- * fc_rport_plogi_recv_resp - Handle incoming ELS PLOGI response
+ * fc_rport_error_retry() - Error handler when retries are desired
+ * @rport: The fc_rport object
+ * @fp: The frame pointer
+ *
+ * If the error was an exchange timeout retry immediately,
+ * otherwise wait for E_D_TOV.
+ *
+ * Locking Note: The rport lock is expected to be held before
+ * calling this routine
+ */
+static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	unsigned long delay = FC_DEF_E_D_TOV;
+
+	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
+	if (PTR_ERR(fp) == -FC_EX_CLOSED)
+		return fc_rport_error(rport, fp);
+
+	if (rdata->retries < rdata->local_port->max_retry_count) {
+		FC_DEBUG_RPORT("Error %ld in state %s, retrying\n",
+			       PTR_ERR(fp), fc_rport_state(rport));
+		rdata->retries++;
+		/* no additional delay on exchange timeouts */
+		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
+			delay = 0;
+		get_device(&rport->dev);
+		schedule_delayed_work(&rdata->retry_work, delay);
+		return;
+	}
+
+	return fc_rport_error(rport, fp);
+}
+
+/**
+ * fc_rport_plogi_recv_resp() - Handle incoming ELS PLOGI response
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -483,17 +505,17 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
 		       rport->port_id);
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
 		FC_DBG("Received a PLOGI response, but in state %s\n",
 		       fc_rport_state(rport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC &&
 	    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
@@ -522,7 +544,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		else
 			fc_rport_enter_prli(rport);
 	} else
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 
 out:
 	fc_frame_free(fp);
@@ -532,7 +554,7 @@ err:
 }
 
 /**
- * fc_rport_enter_plogi - Send Port Login (PLOGI) request to peer
+ * fc_rport_enter_plogi() - Send Port Login (PLOGI) request to peer
  * @rport: Fibre Channel remote port to send PLOGI to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -552,20 +574,20 @@ static void fc_rport_enter_plogi(struct fc_rport *rport)
 	rport->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp) {
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 		return;
 	}
 	rdata->e_d_tov = lport->e_d_tov;
 
 	if (!lport->tt.elsct_send(lport, rport, fp, ELS_PLOGI,
 				  fc_rport_plogi_resp, rport, lport->e_d_tov))
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 	else
 		get_device(&rport->dev);
 }
 
 /**
- * fc_rport_prli_resp - Process Login (PRLI) response handler
+ * fc_rport_prli_resp() - Process Login (PRLI) response handler
  * @sp: current sequence in the PRLI exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -592,17 +614,17 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
 		       rport->port_id);
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	if (rdata->rp_state != RPORT_ST_PRLI) {
 		FC_DBG("Received a PRLI response, but in state %s\n",
 		       fc_rport_state(rport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		pp = fc_frame_payload_get(fp, sizeof(*pp));
@@ -635,7 +657,7 @@ err:
 }
 
 /**
- * fc_rport_logo_resp - Logout (LOGO) response handler
+ * fc_rport_logo_resp() - Logout (LOGO) response handler
  * @sp: current sequence in the LOGO exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -657,7 +679,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 		       rport->port_id);
 
 	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 		goto err;
 	}
 
@@ -684,7 +706,7 @@ err:
 }
 
 /**
- * fc_rport_enter_prli - Send Process Login (PRLI) request to peer
+ * fc_rport_enter_prli() - Send Process Login (PRLI) request to peer
  * @rport: Fibre Channel remote port to send PRLI to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -707,19 +729,19 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
 
 	fp = fc_frame_alloc(lport, sizeof(*pp));
 	if (!fp) {
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 		return;
 	}
 
 	if (!lport->tt.elsct_send(lport, rport, fp, ELS_PRLI,
 				  fc_rport_prli_resp, rport, lport->e_d_tov))
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 	else
 		get_device(&rport->dev);
 }
 
 /**
- * fc_rport_els_rtv_resp - Request Timeout Value response handler
+ * fc_rport_els_rtv_resp() - Request Timeout Value response handler
  * @sp: current sequence in the RTV exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -742,17 +764,17 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
 		       rport->port_id);
 
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
 	if (rdata->rp_state != RPORT_ST_RTV) {
 		FC_DBG("Received a RTV response, but in state %s\n",
 		       fc_rport_state(rport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		struct fc_els_rtv_acc *rtv;
@@ -785,7 +807,7 @@ err:
 }
 
 /**
- * fc_rport_enter_rtv - Send Request Timeout Value (RTV) request to peer
+ * fc_rport_enter_rtv() - Send Request Timeout Value (RTV) request to peer
  * @rport: Fibre Channel remote port to send RTV to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -804,19 +826,19 @@ static void fc_rport_enter_rtv(struct fc_rport *rport)
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_rtv));
 	if (!fp) {
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 		return;
 	}
 
 	if (!lport->tt.elsct_send(lport, rport, fp, ELS_RTV,
 				     fc_rport_rtv_resp, rport, lport->e_d_tov))
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 	else
 		get_device(&rport->dev);
 }
 
 /**
- * fc_rport_enter_logo - Send Logout (LOGO) request to peer
+ * fc_rport_enter_logo() - Send Logout (LOGO) request to peer
  * @rport: Fibre Channel remote port to send LOGO to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -835,20 +857,20 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_logo));
 	if (!fp) {
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 		return;
 	}
 
 	if (!lport->tt.elsct_send(lport, rport, fp, ELS_LOGO,
 				  fc_rport_logo_resp, rport, lport->e_d_tov))
-		fc_rport_error(rport, fp);
+		fc_rport_error_retry(rport, fp);
 	else
 		get_device(&rport->dev);
 }
 

 /**
- * fc_rport_recv_req - Receive a request from a rport
+ * fc_rport_recv_req() - Receive a request from a rport
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -909,7 +931,7 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_rport_recv_plogi_req - Handle incoming Port Login (PLOGI) request
+ * fc_rport_recv_plogi_req() - Handle incoming Port Login (PLOGI) request
  * @rport: Fibre Channel remote port that initiated PLOGI
  * @sp: current sequence in the PLOGI exchange
  * @fp: PLOGI request frame
@@ -1031,7 +1053,7 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 }
 
 /**
- * fc_rport_recv_prli_req - Handle incoming Process Login (PRLI) request
+ * fc_rport_recv_prli_req() - Handle incoming Process Login (PRLI) request
  * @rport: Fibre Channel remote port that initiated PRLI
  * @sp: current sequence in the PRLI exchange
  * @fp: PRLI request frame
@@ -1182,7 +1204,7 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 }
 
 /**
- * fc_rport_recv_prlo_req - Handle incoming Process Logout (PRLO) request
+ * fc_rport_recv_prlo_req() - Handle incoming Process Logout (PRLO) request
  * @rport: Fibre Channel remote port that initiated PRLO
  * @sp: current sequence in the PRLO exchange
  * @fp: PRLO request frame
@@ -1213,7 +1235,7 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 }
 
 /**
- * fc_rport_recv_logo_req - Handle incoming Logout (LOGO) request
+ * fc_rport_recv_logo_req() - Handle incoming Logout (LOGO) request
  * @rport: Fibre Channel remote port that initiated LOGO
  * @sp: current sequence in the LOGO exchange
  * @fp: LOGO request frame
@@ -1249,6 +1271,9 @@ static void fc_rport_flush_queue(void)
 
 int fc_rport_init(struct fc_lport *lport)
 {
+	if (!lport->tt.rport_create)
+		lport->tt.rport_create = fc_rport_rogue_create;
+
 	if (!lport->tt.rport_login)
 		lport->tt.rport_login = fc_rport_login;
 
@@ -1285,7 +1310,7 @@ void fc_rport_terminate_io(struct fc_rport *rport)
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
-	lport->tt.exch_mgr_reset(lport->emp, 0, rport->port_id);
-	lport->tt.exch_mgr_reset(lport->emp, rport->port_id, 0);
+	lport->tt.exch_mgr_reset(lport, 0, rport->port_id);
+	lport->tt.exch_mgr_reset(lport, rport->port_id, 0);
 }
 EXPORT_SYMBOL(fc_rport_terminate_io);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f4c5722..ee9d401 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -244,12 +244,6 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		if (ha->optrom_state != QLA_SWAITING)
 			break;
 
-		if (start & 0xfff) {
-			qla_printk(KERN_WARNING, ha,
-			    "Invalid start region 0x%x/0x%x.\n", start, size);
-			return -EINVAL;
-		}
-
 		ha->optrom_region_start = start;
 		ha->optrom_region_size = start + size > ha->optrom_size ?
 		    ha->optrom_size - start : size;
@@ -303,8 +297,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		else if (start == (ha->flt_region_boot * 4) ||
 		    start == (ha->flt_region_fw * 4))
 			valid = 1;
-		else if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) &&
-		    start == (ha->flt_region_vpd_nvram * 4))
+		else if (IS_QLA25XX(ha) || IS_QLA81XX(ha))
 		    valid = 1;
 		if (!valid) {
 			qla_printk(KERN_WARNING, ha,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9865017..87f9abc 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1308,8 +1308,12 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", vha->host_no));
 
-	if (ha->flags.npiv_supported)
+	if (ha->flags.npiv_supported) {
+		if (ha->operating_mode == LOOP)
+			ha->max_npiv_vports = MIN_MULTI_ID_FABRIC - 1;
 		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
+	}
+
 
 	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 
@@ -2610,6 +2614,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	port_id_t	wrap, nxt_d_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
+	struct scsi_qla_host *tvp;
 
 	rval = QLA_SUCCESS;
 
@@ -2709,7 +2714,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		/* Bypass virtual ports of the same host. */
 		found = 0;
 		if (ha->num_vhosts) {
-			list_for_each_entry(vp, &ha->vp_list, list) {
+			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 				if (new_fcport->d_id.b24 == vp->d_id.b24) {
 					found = 1;
 					break;
@@ -2832,6 +2837,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 	uint16_t first_loop_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
+	struct scsi_qla_host *tvp;
 
 	rval = QLA_SUCCESS;
 
@@ -2856,7 +2862,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 		/* Check for loop ID being already in use. */
 		found = 0;
 		fcport = NULL;
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			list_for_each_entry(fcport, &vp->vp_fcports, list) {
 				if (fcport->loop_id == dev->loop_id &&
 								fcport != dev) {
@@ -3291,6 +3297,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
+	struct scsi_qla_host *tvp;
 	struct req_que *req = ha->req_q_map[0];
 
 	if (vha->flags.online) {
@@ -3306,7 +3313,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
 			qla2x00_mark_all_devices_lost(vha, 0);
-			list_for_each_entry(vp, &ha->vp_list, list)
+			list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
 			       qla2x00_mark_all_devices_lost(vp, 0);
 		} else {
 			if (!atomic_read(&vha->loop_down_timer))
@@ -3403,7 +3410,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		DEBUG(printk(KERN_INFO
 				"qla2x00_abort_isp(%ld): succeeded.\n",
 				vha->host_no));
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			if (vp->vp_idx)
 				qla2x00_vp_abort_isp(vp);
 		}
@@ -3428,7 +3435,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 static int
 qla2x00_restart_isp(scsi_qla_host_t *vha)
 {
-	uint8_t		status = 0;
+	int status = 0;
 	uint32_t wait_time;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4c7504c..4aab7ac 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2685,6 +2685,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
+	scsi_qla_host_t *tvp;
 
 	if (rptid_entry->entry_status != 0)
 		return;
@@ -2710,7 +2711,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		if (MSB(stat) == 1)
 			return;
 
-		list_for_each_entry(vp, &ha->vp_list, list)
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
 			if (vp_idx == vp->vp_idx)
 				break;
 		if (!vp)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 3f23932..785c612 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -69,9 +69,10 @@ static scsi_qla_host_t *
 qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
+	struct scsi_qla_host *tvha;
 
 	/* Locate matching device in database. */
-	list_for_each_entry(vha, &ha->vp_list, list) {
+	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
 		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
 			return vha;
 	}
@@ -194,11 +195,11 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 void
 qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 {
-	scsi_qla_host_t *vha;
+	scsi_qla_host_t *vha, *tvha;
 	struct qla_hw_data *ha = rsp->hw;
 	int i = 0;
 
-	list_for_each_entry(vha, &ha->vp_list, list) {
+	list_for_each_entry_safe(vha, tvha, &ha->vp_list, list) {
 		if (vha->vp_idx) {
 			switch (mb[0]) {
 			case MBA_LIP_OCCURRED:
@@ -300,6 +301,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 	int ret;
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
+	struct scsi_qla_host *tvp;
 
 	if (vha->vp_idx)
 		return;
@@ -308,7 +310,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 	clear_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
-	list_for_each_entry(vp, &ha->vp_list, list) {
+	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		if (vp->vp_idx)
 			ret = qla2x00_do_dpc_vp(vp);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2f5f725..3ddfa88 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2222,10 +2222,6 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 {
 	char	name[16];
 
-	ha->init_cb_size = sizeof(init_cb_t);
-	if (IS_QLA2XXX_MIDTYPE(ha))
-		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
-
 	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
 		&ha->init_cb_dma, GFP_KERNEL);
 	if (!ha->init_cb)
@@ -2568,7 +2564,7 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 void qla2x00_relogin(struct scsi_qla_host *vha)
 {
 	fc_port_t       *fcport;
-	uint8_t         status;
+	int status;
 	uint16_t        next_loopid = 0;
 	struct qla_hw_data *ha = vha->hw;
 
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 79f7053..a772eab 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.00-k3"
+#define QLA2XXX_VERSION      "8.03.00-k4"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 55310db..4970ae4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1167,23 +1167,19 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		/*
 		 * The device does not want the automatic start to be issued.
 		 */
-		if (sdkp->device->no_start_on_add) {
+		if (sdkp->device->no_start_on_add)
 			break;
-		}
-
-		/*
-		 * If manual intervention is required, or this is an
-		 * absent USB storage device, a spinup is meaningless.
-		 */
-		if (sense_valid &&
-		    sshdr.sense_key == NOT_READY &&
-		    sshdr.asc == 4 && sshdr.ascq == 3) {
-			break;		/* manual intervention required */
 
-		/*
-		 * Issue command to spin up drive when not ready
-		 */
-		} else if (sense_valid && sshdr.sense_key == NOT_READY) {
+		if (sense_valid && sshdr.sense_key == NOT_READY) {
+			if (sshdr.asc == 4 && sshdr.ascq == 3)
+				break;	/* manual intervention required */
+			if (sshdr.asc == 4 && sshdr.ascq == 0xb)
+				break;	/* standby */
+			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
+				break;	/* unavailable */
+			/*
+			 * Issue command to spin up drive when not ready
+			 */
 			if (!spintime) {
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
 				cmd[0] = START_STOP;
diff --git a/include/scsi/fc/fc_fcoe.h b/include/scsi/fc/fc_fcoe.h
index 57aaa8f..f271d9c 100644
--- a/include/scsi/fc/fc_fcoe.h
+++ b/include/scsi/fc/fc_fcoe.h
@@ -31,10 +31,6 @@
 #define	ETH_P_FCOE	0x8906		/* FCOE ether type */
 #endif
 
-#ifndef ETH_P_8021Q
-#define	ETH_P_8021Q	0x8100
-#endif
-
 /*
  * FC_FCOE_OUI hasn't been standardized yet.   XXX TBD.
  */
diff --git a/include/scsi/fc/fc_fs.h b/include/scsi/fc/fc_fs.h
index 3e4801d..1b7af3a 100644
--- a/include/scsi/fc/fc_fs.h
+++ b/include/scsi/fc/fc_fs.h
@@ -337,4 +337,9 @@ enum fc_pf_rjt_reason {
 	FC_RJT_VENDOR =		0xff,	/* vendor specific reject */
 };
 
+/* default timeout values */
+
+#define FC_DEF_E_D_TOV	2000UL
+#define FC_DEF_R_A_TOV	10000UL
+
 #endif /* _FC_FS_H_ */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 9f28763..a2e126b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -68,9 +68,6 @@
 /*
  * FC HBA status
  */
-#define FC_PAUSE		    (1 << 1)
-#define FC_LINK_UP		    (1 << 0)
-
 enum fc_lport_state {
 	LPORT_ST_NONE = 0,
 	LPORT_ST_FLOGI,
@@ -339,31 +336,17 @@ struct fc_exch {
 
 struct libfc_function_template {
 
-	/**
-	 * Mandatory Fields
-	 *
-	 * These handlers must be implemented by the LLD.
-	 */
-
 	/*
 	 * Interface to send a FC frame
-	 */
-	int (*frame_send)(struct fc_lport *lp, struct fc_frame *fp);
-
-	/**
-	 * Optional Fields
 	 *
-	 * The LLD may choose to implement any of the following handlers.
-	 * If LLD doesn't specify hander and leaves its pointer NULL then
-	 * the default libfc function will be used for that handler.
-	 */
-
-	/**
-	 * ELS/CT interfaces
+	 * STATUS: REQUIRED
 	 */
+	int (*frame_send)(struct fc_lport *lp, struct fc_frame *fp);
 
 	/*
-	 * elsct_send - sends ELS/CT frame
+	 * Interface to send ELS/CT frames
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*elsct_send)(struct fc_lport *lport,
 				     struct fc_rport *rport,
@@ -373,9 +356,6 @@ struct libfc_function_template {
 					     struct fc_frame *fp,
 					     void *arg),
 				     void *arg, u32 timer_msec);
-	/**
-	 * Exhance Manager interfaces
-	 */
 
 	/*
 	 * Send the FC frame payload using a new exchange and sequence.
@@ -407,6 +387,8 @@ struct libfc_function_template {
 	 * timer_msec argument is specified. The timer is canceled when
 	 * it fires or when the exchange is done. The exchange timeout handler
 	 * is registered by EM layer.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*exch_seq_send)(struct fc_lport *lp,
 					struct fc_frame *fp,
@@ -418,14 +400,18 @@ struct libfc_function_template {
 					void *arg, unsigned int timer_msec);
 
 	/*
-	 * send a frame using existing sequence and exchange.
+	 * Send a frame using an existing sequence and exchange.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*seq_send)(struct fc_lport *lp, struct fc_seq *sp,
 			struct fc_frame *fp);
 
 	/*
-	 * Send ELS response using mainly infomation
-	 * in exchange and sequence in EM layer.
+	 * Send an ELS response using infomation from a previous
+	 * exchange and sequence.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*seq_els_rsp_send)(struct fc_seq *sp, enum fc_els_cmd els_cmd,
 				 struct fc_seq_els_data *els_data);
@@ -437,6 +423,8 @@ struct libfc_function_template {
 	 * A timer_msec can be specified for abort timeout, if non-zero
 	 * timer_msec value is specified then exchange resp handler
 	 * will be called with timeout error if no response to abort.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*seq_exch_abort)(const struct fc_seq *req_sp,
 			      unsigned int timer_msec);
@@ -444,6 +432,8 @@ struct libfc_function_template {
 	/*
 	 * Indicate that an exchange/sequence tuple is complete and the memory
 	 * allocated for the related objects may be freed.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*exch_done)(struct fc_seq *sp);
 
@@ -451,6 +441,8 @@ struct libfc_function_template {
 	 * Assigns a EM and a free XID for an new exchange and then
 	 * allocates a new exchange and sequence pair.
 	 * The fp can be used to determine free XID.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_exch *(*exch_get)(struct fc_lport *lp, struct fc_frame *fp);
 
@@ -458,12 +450,16 @@ struct libfc_function_template {
 	 * Release previously assigned XID by exch_get API.
 	 * The LLD may implement this if XID is assigned by LLD
 	 * in exch_get().
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*exch_put)(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			 u16 ex_id);
 
 	/*
 	 * Start a new sequence on the same exchange/sequence tuple.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*seq_start_next)(struct fc_seq *sp);
 
@@ -471,26 +467,38 @@ struct libfc_function_template {
 	 * Reset an exchange manager, completing all sequences and exchanges.
 	 * If s_id is non-zero, reset only exchanges originating from that FID.
 	 * If d_id is non-zero, reset only exchanges sending to that FID.
+	 *
+	 * STATUS: OPTIONAL
 	 */
-	void (*exch_mgr_reset)(struct fc_exch_mgr *,
+	void (*exch_mgr_reset)(struct fc_lport *,
 			       u32 s_id, u32 d_id);
 
-	void (*rport_flush_queue)(void);
-	/**
-	 * Local Port interfaces
+	/*
+	 * Flush the rport work queue. Generally used before shutdown.
+	 *
+	 * STATUS: OPTIONAL
 	 */
+	void (*rport_flush_queue)(void);
 
 	/*
-	 * Receive a frame to a local port.
+	 * Receive a frame for a local port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*lport_recv)(struct fc_lport *lp, struct fc_seq *sp,
 			   struct fc_frame *fp);
 
+	/*
+	 * Reset the local port.
+	 *
+	 * STATUS: OPTIONAL
+	 */
 	int (*lport_reset)(struct fc_lport *);
 
-	/**
-	 * Remote Port interfaces
+	/*
+	 * Create a remote port
 	 */
+	struct fc_rport *(*rport_create)(struct fc_disc_port *);
 
 	/*
 	 * Initiates the RP state machine. It is called from the LP module.
@@ -500,26 +508,33 @@ struct libfc_function_template {
 	 * - PLOGI
 	 * - PRLI
 	 * - RTV
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*rport_login)(struct fc_rport *rport);
 
 	/*
 	 * Logoff, and remove the rport from the transport if
 	 * it had been added. This will send a LOGO to the target.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*rport_logoff)(struct fc_rport *rport);
 
 	/*
 	 * Recieve a request from a remote port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*rport_recv_req)(struct fc_seq *, struct fc_frame *,
 			       struct fc_rport *);
 
-	struct fc_rport *(*rport_lookup)(const struct fc_lport *, u32);
-
-	/**
-	 * FCP interfaces
+	/*
+	 * lookup an rport by it's port ID.
+	 *
+	 * STATUS: OPTIONAL
 	 */
+	struct fc_rport *(*rport_lookup)(const struct fc_lport *, u32);
 
 	/*
 	 * Send a fcp cmd from fsp pkt.
@@ -527,30 +542,38 @@ struct libfc_function_template {
 	 *
 	 * The resp handler is called when FCP_RSP received.
 	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*fcp_cmd_send)(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 			    void (*resp)(struct fc_seq *, struct fc_frame *fp,
 					 void *arg));
 
 	/*
-	 * Used at least durring linkdown and reset
+	 * Cleanup the FCP layer, used durring link down and reset
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*fcp_cleanup)(struct fc_lport *lp);
 
 	/*
 	 * Abort all I/O on a local port
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*fcp_abort_io)(struct fc_lport *lp);
 
-	/**
-	 * Discovery interfaces
+	/*
+	 * Receive a request for the discovery layer.
+	 *
+	 * STATUS: OPTIONAL
 	 */
-
 	void (*disc_recv_req)(struct fc_seq *,
 			      struct fc_frame *, struct fc_lport *);
 
 	/*
 	 * Start discovery for a local port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*disc_start)(void (*disc_callback)(struct fc_lport *,
 						 enum fc_disc_event),
@@ -559,6 +582,8 @@ struct libfc_function_template {
 	/*
 	 * Stop discovery for a given lport. This will remove
 	 * all discovered rports
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*disc_stop) (struct fc_lport *);
 
@@ -566,6 +591,8 @@ struct libfc_function_template {
 	 * Stop discovery for a given lport. This will block
 	 * until all discovered rports are deleted from the
 	 * FC transport class
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*disc_stop_final) (struct fc_lport *);
 };
@@ -603,7 +630,8 @@ struct fc_lport {
 
 	/* Operational Information */
 	struct libfc_function_template tt;
-	u16			link_status;
+	u8			link_up;
+	u8			qfull;
 	enum fc_lport_state	state;
 	unsigned long		boot_time;
 
@@ -637,7 +665,7 @@ struct fc_lport {
 	struct delayed_work	disc_work;
 };
 
-/**
+/*
  * FC_LPORT HELPER FUNCTIONS
  *****************************/
 static inline void *lport_priv(const struct fc_lport *lp)
@@ -669,7 +697,7 @@ static inline void fc_lport_state_enter(struct fc_lport *lp,
 }
 

-/**
+/*
  * LOCAL PORT LAYER
  *****************************/
 int fc_lport_init(struct fc_lport *lp);
@@ -704,12 +732,6 @@ void fc_linkup(struct fc_lport *);
 void fc_linkdown(struct fc_lport *);
 
 /*
- * Pause and unpause traffic.
- */
-void fc_pause(struct fc_lport *);
-void fc_unpause(struct fc_lport *);
-
-/*
  * Configure the local port.
  */
 int fc_lport_config(struct fc_lport *);
@@ -725,19 +747,19 @@ int fc_lport_reset(struct fc_lport *);
 int fc_set_mfs(struct fc_lport *lp, u32 mfs);
 

-/**
+/*
  * REMOTE PORT LAYER
  *****************************/
 int fc_rport_init(struct fc_lport *lp);
 void fc_rport_terminate_io(struct fc_rport *rp);
 
-/**
+/*
  * DISCOVERY LAYER
  *****************************/
 int fc_disc_init(struct fc_lport *lp);
 

-/**
+/*
  * SCSI LAYER
  *****************************/
 /*
@@ -798,7 +820,7 @@ int fc_change_queue_type(struct scsi_device *sdev, int tag_type);
  */
 void fc_fcp_destroy(struct fc_lport *);
 
-/**
+/*
  * ELS/CT interface
  *****************************/
 /*
@@ -807,7 +829,7 @@ void fc_fcp_destroy(struct fc_lport *);
 int fc_elsct_init(struct fc_lport *lp);
 

-/**
+/*
  * EXCHANGE MANAGER LAYER
  *****************************/
 /*
@@ -916,7 +938,7 @@ struct fc_seq *fc_seq_start_next(struct fc_seq *sp);
  * If s_id is non-zero, reset only exchanges originating from that FID.
  * If d_id is non-zero, reset only exchanges sending to that FID.
  */
-void fc_exch_mgr_reset(struct fc_exch_mgr *, u32 s_id, u32 d_id);
+void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 
 /*
  * Functions for fc_functions_template
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 89fdbb9..941818f 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -46,6 +46,7 @@ struct fcoe_softc {
 	struct net_device *phys_dev;		/* device with ethtool_ops */
 	struct packet_type  fcoe_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
+	u8	fcoe_pending_queue_active;
 
 	u8 dest_addr[ETH_ALEN];
 	u8 ctl_src_addr[ETH_ALEN];
@@ -58,16 +59,10 @@ struct fcoe_softc {
 	u8 address_mode;
 };
 
-static inline struct fcoe_softc *fcoe_softc(
-	const struct fc_lport *lp)
-{
-	return (struct fcoe_softc *)lport_priv(lp);
-}
-
 static inline struct net_device *fcoe_netdev(
 	const struct fc_lport *lp)
 {
-	return fcoe_softc(lp)->real_dev;
+	return ((struct fcoe_softc *)lport_priv(lp))->real_dev;
 }
 
 static inline struct fcoe_hdr *skb_fcoe_header(const struct sk_buff *skb)


