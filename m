From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/17] libfc, fcoe: Fix kerneldoc comments
Date: Fri, 06 Feb 2009 10:56:53 -0800
Message-ID: <20090206185653.26188.2279.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34190 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZBFS51 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:57:27 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

1) Added '()' for function names in kerneldoc comments

2) Changed comment bookends from '**/' to '*/'. The comment on the the mailing list
   was that '**/' "is consistently unconventional.  Not wrong, just odd." The
   Documentation/kernel-doc-nano-HOWTO.txt states that kerneldoc comment blocks
   should end with '**/' but most (if not all) instance I found under drivers/scsi/
   were only using the '*/' so I converted to that style.

3) Removed incorrect linebreaks in kerneldoc comments where found

4) Removed a few unnecessary blank comment lines in kerneldoc comment blocks

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fc_transport_fcoe.c |   77 ++++++++--------
 drivers/scsi/fcoe/fcoe_sw.c           |   42 ++++-----
 drivers/scsi/fcoe/libfcoe.c           |  162 +++++++++++++++++----------------
 drivers/scsi/libfc/fc_disc.c          |   45 +++++----
 drivers/scsi/libfc/fc_fcp.c           |   46 +++++----
 drivers/scsi/libfc/fc_lport.c         |   77 ++++++++--------
 drivers/scsi/libfc/fc_rport.c         |   46 +++++----
 include/scsi/libfc.h                  |   14 +--
 8 files changed, 252 insertions(+), 257 deletions(-)

diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
index 9fd4acc..f48c0b0 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -35,19 +35,19 @@ static LIST_HEAD(fcoe_transports);
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
@@ -56,16 +56,14 @@ struct pci_dev *fcoe_transport_pcidev(const struct net_device *netdev)
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
+ */
 static struct fcoe_transport_internal *fcoe_transport_device_lookup(
 	struct fcoe_transport *t, struct net_device *netdev)
 {
@@ -83,14 +81,14 @@ static struct fcoe_transport_internal *fcoe_transport_device_lookup(
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
@@ -123,14 +121,14 @@ static int fcoe_transport_device_add(struct fcoe_transport *t,
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
@@ -153,13 +151,13 @@ static int fcoe_transport_device_remove(struct fcoe_transport *t,
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
@@ -173,16 +171,16 @@ static void fcoe_transport_device_remove_all(struct fcoe_transport *t)
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
 				struct net_device *netdev)
 {
@@ -207,15 +205,15 @@ static bool fcoe_transport_match(struct fcoe_transport *t,
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
+ * TODO: return default sw transport if no other transport is found
+ */
 static struct fcoe_transport *fcoe_transport_lookup(
 	struct net_device *netdev)
 {
@@ -237,11 +235,11 @@ static struct fcoe_transport *fcoe_transport_lookup(
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
@@ -267,11 +265,11 @@ int fcoe_transport_register(struct fcoe_transport *t)
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
@@ -292,8 +290,8 @@ int fcoe_transport_unregister(struct fcoe_transport *t)
 }
 EXPORT_SYMBOL_GPL(fcoe_transport_unregister);
 
-/*
- * fcoe_load_transport_driver - load an offload driver by alias name
+/**
+ * fcoe_load_transport_driver() - Load an offload driver by alias name
  * @netdev: the target net device
  *
  * Requests for an offload driver module as the fcoe transport, if fails, it
@@ -305,7 +303,7 @@ EXPORT_SYMBOL_GPL(fcoe_transport_unregister);
  * 	3. pure hw fcoe hba may not have netdev
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_load_transport_driver(struct net_device *netdev)
 {
 	struct pci_dev *pci;
@@ -334,14 +332,14 @@ int fcoe_load_transport_driver(struct net_device *netdev)
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
@@ -370,11 +368,11 @@ int fcoe_transport_attach(struct net_device *netdev)
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
@@ -403,12 +401,12 @@ int fcoe_transport_release(struct net_device *netdev)
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
@@ -417,12 +415,13 @@ int __init fcoe_transport_init(void)
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
index 769e6a8..b5b2abf 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -106,13 +106,12 @@ static struct scsi_host_template fcoe_sw_shost_template = {
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
@@ -139,16 +138,14 @@ static int fcoe_sw_lport_config(struct fc_lport *lp)
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
@@ -226,16 +223,15 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
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
@@ -263,8 +259,8 @@ static int fcoe_sw_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 	return 0;
 }
 
-/*
- * fcoe_sw_em_config - allocates em for this lport
+/**
+ * fcoe_sw_em_config() - allocates em for this lport
  * @lp: the port that em is to allocated for
  *
  * Returns : 0 on success
@@ -281,8 +277,8 @@ static inline int fcoe_sw_em_config(struct fc_lport *lp)
 	return 0;
 }
 
-/*
- * fcoe_sw_destroy - FCoE software HBA tear-down function
+/**
+ * fcoe_sw_destroy() - FCoE software HBA tear-down function
  * @netdev: ptr to the associated net_device
  *
  * Returns: 0 if link is OK for use by FCoE.
@@ -354,8 +350,8 @@ static struct libfc_function_template fcoe_sw_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 };
 
-/*
- * fcoe_sw_create - this function creates the fcoe interface
+/**
+ * fcoe_sw_create() - this function creates the fcoe interface
  * @netdev: pointer the associated netdevice
  *
  * Creates fc_lport struct and scsi_host for lport, configures lport
@@ -441,8 +437,8 @@ out_host_put:
 	return rc;
 }
 
-/*
- * fcoe_sw_match - the fcoe sw transport match function
+/**
+ * fcoe_sw_match() - The FCoE SW transport match function
  *
  * Returns : false always
  */
@@ -462,8 +458,8 @@ struct fcoe_transport fcoe_sw_transport = {
 	.device = 0xffff,
 };
 
-/*
- * fcoe_sw_init - registers fcoe_sw_transport
+/**
+ * fcoe_sw_init() - Registers fcoe_sw_transport
  *
  * Returns : 0 on success
  */
@@ -481,8 +477,8 @@ int __init fcoe_sw_init(void)
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
index 9efe1bf..60677a8 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -94,13 +94,13 @@ static struct notifier_block fcoe_cpu_notifier = {
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
@@ -118,13 +118,13 @@ static void fcoe_create_percpu_data(int cpu)
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
@@ -140,7 +140,7 @@ static void fcoe_destroy_percpu_data(int cpu)
 }
 
 /**
- * fcoe_cpu_callback - fcoe cpu hotplug event callback
+ * fcoe_cpu_callback() - fcoe cpu hotplug event callback
  * @nfb: callback data block
  * @action: event triggering the callback
  * @hcpu: index for the cpu of this event
@@ -148,7 +148,7 @@ static void fcoe_destroy_percpu_data(int cpu)
  * this creates or destroys per cpu data for fcoe
  *
  * Returns NOTIFY_OK always.
- **/
+ */
 static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
@@ -169,7 +169,7 @@ static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
 #endif /* CONFIG_HOTPLUG_CPU */
 
 /**
- * fcoe_rcv - this is the fcoe receive function called by NET_RX_SOFTIRQ
+ * fcoe_rcv() - this is the fcoe receive function called by NET_RX_SOFTIRQ
  * @skb: the receive skb
  * @dev: associated net device
  * @ptype: context
@@ -178,7 +178,7 @@ static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
  * this function will receive the packet and build fc frame and pass it up
  *
  * Returns: 0 for success
- **/
+ */
 int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	     struct packet_type *ptype, struct net_device *olddev)
 {
@@ -265,11 +265,11 @@ err2:
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
@@ -283,12 +283,12 @@ static inline int fcoe_start_io(struct sk_buff *skb)
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
@@ -326,13 +326,12 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
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
@@ -363,13 +362,12 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
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
@@ -511,12 +509,11 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
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
@@ -660,7 +657,7 @@ int fcoe_percpu_receive_thread(void *arg)
 }
 
 /**
- * fcoe_recv_flogi - flogi receive function
+ * fcoe_recv_flogi() - flogi receive function
  * @fc: associated fcoe_softc
  * @fp: the recieved frame
  * @sa: the source address of this flogi
@@ -669,7 +666,7 @@ int fcoe_percpu_receive_thread(void *arg)
  * mac address for the initiator, eitehr OUI based or GW based.
  *
  * Returns: none
- **/
+ */
 static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
 {
 	struct fc_frame_header *fh;
@@ -717,7 +714,7 @@ static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
 }
 
 /**
- * fcoe_watchdog - fcoe timer callback
+ * fcoe_watchdog() - fcoe timer callback
  * @vp:
  *
  * This checks the pending queue length for fcoe and set lport qfull
@@ -725,7 +722,7 @@ static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
  * fcoe_hostlist.
  *
  * Returns: 0 for success
- **/
+ */
 void fcoe_watchdog(ulong vp)
 {
 	struct fc_lport *lp;
@@ -752,7 +749,7 @@ void fcoe_watchdog(ulong vp)
 
 
 /**
- * fcoe_check_wait_queue - put the skb into fcoe pending xmit queue
+ * fcoe_check_wait_queue() - put the skb into fcoe pending xmit queue
  * @lp: the fc_port for this skb
  * @skb: the associated skb to be xmitted
  *
@@ -766,7 +763,7 @@ void fcoe_watchdog(ulong vp)
  * by the next skb transmit.
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_check_wait_queue(struct fc_lport *lp)
 {
 	int rc;
@@ -799,12 +796,12 @@ static int fcoe_check_wait_queue(struct fc_lport *lp)
 }
 
 /**
- * fcoe_insert_wait_queue_head - puts skb to fcoe pending queue head
+ * fcoe_insert_wait_queue_head() - puts skb to fcoe pending queue head
  * @lp: the fc_port for this skb
  * @skb: the associated skb to be xmitted
  *
  * Returns: none
- **/
+ */
 static void fcoe_insert_wait_queue_head(struct fc_lport *lp,
 					struct sk_buff *skb)
 {
@@ -817,12 +814,12 @@ static void fcoe_insert_wait_queue_head(struct fc_lport *lp,
 }
 
 /**
- * fcoe_insert_wait_queue - put the skb into fcoe pending queue tail
+ * fcoe_insert_wait_queue() - put the skb into fcoe pending queue tail
  * @lp: the fc_port for this skb
  * @skb: the associated skb to be xmitted
  *
  * Returns: none
- **/
+ */
 static void fcoe_insert_wait_queue(struct fc_lport *lp,
 				   struct sk_buff *skb)
 {
@@ -835,10 +832,9 @@ static void fcoe_insert_wait_queue(struct fc_lport *lp,
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
@@ -848,15 +844,15 @@ static void fcoe_dev_setup(void)
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
@@ -864,7 +860,7 @@ static void fcoe_dev_cleanup(void)
  * This function is called by the ethernet driver in case of link change event
  *
  * Returns: 0 for success
- **/
+ */
 static int fcoe_device_notification(struct notifier_block *notifier,
 				    ulong event, void *ptr)
 {
@@ -928,12 +924,12 @@ out:
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
@@ -950,11 +946,11 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
- * fcoe_netdev_to_module_owner - finds out the nic drive moddule of the netdev
+ * fcoe_netdev_to_module_owner() - finds out the nic drive moddule of the netdev
  * @netdev: the target netdev
  *
  * Returns: ptr to the struct module, NULL for failure
- **/
+ */
 static struct module *fcoe_netdev_to_module_owner(
 	const struct net_device *netdev)
 {
@@ -974,12 +970,14 @@ static struct module *fcoe_netdev_to_module_owner(
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
@@ -994,12 +992,14 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
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
@@ -1015,12 +1015,12 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
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
@@ -1053,12 +1053,12 @@ out_nodev:
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
@@ -1099,8 +1099,8 @@ module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(destroy, "string");
 MODULE_PARM_DESC(destroy, "Destroy fcoe port");
 
-/*
- * fcoe_link_ok - check if link is ok for the fc_lport
+/**
+ * fcoe_link_ok() - Check if link is ok for the fc_lport
  * @lp: ptr to the fc_lport
  *
  * Any permanently-disqualifying conditions have been previously checked.
@@ -1144,9 +1144,8 @@ int fcoe_link_ok(struct fc_lport *lp)
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
@@ -1180,11 +1179,11 @@ void fcoe_percpu_clean(struct fc_lport *lp)
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
@@ -1201,12 +1200,12 @@ void fcoe_clean_pending_queue(struct fc_lport *lp)
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
 static inline struct Scsi_Host *libfc_host_alloc(
 	struct scsi_host_template *sht, int priv_size)
@@ -1215,7 +1214,7 @@ static inline struct Scsi_Host *libfc_host_alloc(
 }
 
 /**
- * fcoe_host_alloc - allocate a Scsi_Host with room for the fcoe_softc
+ * fcoe_host_alloc() - Allocate a Scsi_Host with room for the fcoe_softc
  * @sht: ptr to the scsi host templ
  * @priv_size: size of private data after fc_lport
  *
@@ -1227,8 +1226,8 @@ struct Scsi_Host *fcoe_host_alloc(struct scsi_host_template *sht, int priv_size)
 }
 EXPORT_SYMBOL_GPL(fcoe_host_alloc);
 
-/*
- * fcoe_reset - resets the fcoe
+/**
+ * fcoe_reset() - Resets the fcoe
  * @shost: shost the reset is from
  *
  * Returns: always 0
@@ -1241,8 +1240,8 @@ int fcoe_reset(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL_GPL(fcoe_reset);
 
-/*
- * fcoe_wwn_from_mac - converts 48-bit IEEE MAC address to 64-bit FC WWN.
+/**
+ * fcoe_wwn_from_mac() - Converts 48-bit IEEE MAC address to 64-bit FC WWN.
  * @mac: mac address
  * @scheme: check port
  * @port: port indicator for converting
@@ -1281,8 +1280,9 @@ u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
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
@@ -1303,8 +1303,8 @@ static struct fcoe_softc *fcoe_hostlist_lookup_softc(
 	return NULL;
 }
 
-/*
- * fcoe_hostlist_lookup - find the corresponding lport by netdev
+/**
+ * fcoe_hostlist_lookup() - Find the corresponding lport by netdev
  * @netdev: ptr to net_device
  *
  * Returns: 0 for success
@@ -1319,8 +1319,8 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 }
 EXPORT_SYMBOL_GPL(fcoe_hostlist_lookup);
 
-/*
- * fcoe_hostlist_add - add a lport to lports list
+/**
+ * fcoe_hostlist_add() - Add a lport to lports list
  * @lp: ptr to the fc_lport to badded
  *
  * Returns: 0 for success
@@ -1340,8 +1340,8 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 }
 EXPORT_SYMBOL_GPL(fcoe_hostlist_add);
 
-/*
- * fcoe_hostlist_remove - remove a lport from lports list
+/**
+ * fcoe_hostlist_remove() - remove a lport from lports list
  * @lp: ptr to the fc_lport to badded
  *
  * Returns: 0 for success
@@ -1361,12 +1361,12 @@ int fcoe_hostlist_remove(const struct fc_lport *lp)
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
@@ -1384,14 +1384,14 @@ int fcoe_libfc_config(struct fc_lport *lp, struct libfc_function_template *tt)
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
@@ -1454,10 +1454,10 @@ static int __init fcoe_init(void)
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
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index f37ce94..dcf9301 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -56,7 +56,7 @@ static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
 static void fc_disc_restart(struct fc_disc *);
 
 /**
- * fc_disc_lookup_rport - lookup a remote port by port_id
+ * fc_disc_lookup_rport() - lookup a remote port by port_id
  * @lport: Fibre Channel host port instance
  * @port_id: remote port port_id to match
  */
@@ -84,7 +84,7 @@ struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
 }
 
 /**
- * fc_disc_stop_rports - delete all the remote ports associated with the lport
+ * fc_disc_stop_rports() - delete all the remote ports associated with the lport
  * @disc: The discovery job to stop rports on
  *
  * Locking Note: This function expects that the lport mutex is locked before
@@ -109,7 +109,7 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_rport_callback - Event handler for rport events
+ * fc_disc_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
  * @rport: The rport which the event has occured on
  * @event: The event that occured
@@ -143,7 +143,7 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 }
 
 /**
- * fc_disc_recv_rscn_req - Handle Registered State Change Notification (RSCN)
+ * fc_disc_recv_rscn_req() - Handle Registered State Change Notification (RSCN)
  * @sp: Current sequence of the RSCN exchange
  * @fp: RSCN Frame
  * @lport: Fibre Channel host port instance
@@ -257,7 +257,7 @@ reject:
 }
 
 /**
- * fc_disc_recv_req - Handle incoming requests
+ * fc_disc_recv_req() - Handle incoming requests
  * @sp: Current sequence of the request exchange
  * @fp: The frame
  * @lport: The FC local port
@@ -287,7 +287,7 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_disc_restart - Restart discovery
+ * fc_disc_restart() - Restart discovery
  * @lport: FC discovery context
  *
  * Locking Note: This function expects that the disc mutex
@@ -314,7 +314,7 @@ static void fc_disc_restart(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_start - Fibre Channel Target discovery
+ * fc_disc_start() - Fibre Channel Target discovery
  * @lport: FC local port
  *
  * Returns non-zero if discovery cannot be started.
@@ -375,7 +375,7 @@ static struct fc_rport_operations fc_disc_rport_ops = {
 };
 
 /**
- * fc_disc_new_target - Handle new target found by discovery
+ * fc_disc_new_target() - Handle new target found by discovery
  * @lport: FC local port
  * @rport: The previous FC remote port (NULL if new remote port)
  * @ids: Identifiers for the new FC remote port
@@ -438,7 +438,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 }
 
 /**
- * fc_disc_del_target - Delete a target
+ * fc_disc_del_target() - Delete a target
  * @disc: FC discovery context
  * @rport: The remote port to be removed
  */
@@ -451,7 +451,7 @@ static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
 }
 
 /**
- * fc_disc_done - Discovery has been completed
+ * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
  */
 static void fc_disc_done(struct fc_disc *disc)
@@ -471,7 +471,7 @@ static void fc_disc_done(struct fc_disc *disc)
 }
 
 /**
- * fc_disc_error - Handle error on dNS request
+ * fc_disc_error() - Handle error on dNS request
  * @disc: FC discovery context
  * @fp: The frame pointer
  */
@@ -510,7 +510,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 }
 
 /**
- * fc_disc_gpn_ft_req - Send Get Port Names by FC-4 type (GPN_FT) request
+ * fc_disc_gpn_ft_req() - Send Get Port Names by FC-4 type (GPN_FT) request
  * @lport: FC discovery context
  *
  * Locking Note: This function expects that the disc_mutex is locked
@@ -544,7 +544,7 @@ err:
 }
 
 /**
- * fc_disc_gpn_ft_parse - Parse the list of IDs and names resulting from a request
+ * fc_disc_gpn_ft_parse() - Parse the list of IDs and names resulting from a request
  * @lport: Fibre Channel host port instance
  * @buf: GPN_FT response buffer
  * @len: size of response buffer
@@ -649,7 +649,10 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
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
@@ -664,7 +667,7 @@ static void fc_disc_timeout(struct work_struct *work)
 }
 
 /**
- * fc_disc_gpn_ft_resp - Handle a response frame from Get Port Names (GPN_FT)
+ * fc_disc_gpn_ft_resp() - Handle a response frame from Get Port Names (GPN_FT)
  * @sp: Current sequence of GPN_FT exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
@@ -703,9 +706,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 				    fr_len(fp));
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
-			/*
-			 * Accepted.  Parse response.
-			 */
+			/* Accepted, parse the response. */
 			buf = cp + 1;
 			len -= sizeof(*cp);
 		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
@@ -737,7 +738,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_disc_single - Discover the directory information for a single target
+ * fc_disc_single() - Discover the directory information for a single target
  * @lport: FC local port
  * @dp: The port to rediscover
  *
@@ -773,7 +774,7 @@ out:
 }
 
 /**
- * fc_disc_stop - Stop discovery for a given lport
+ * fc_disc_stop() - Stop discovery for a given lport
  * @lport: The lport that discovery should stop for
  */
 void fc_disc_stop(struct fc_lport *lport)
@@ -787,7 +788,7 @@ void fc_disc_stop(struct fc_lport *lport)
 }
 
 /**
- * fc_disc_stop_final - Stop discovery for a given lport
+ * fc_disc_stop_final() - Stop discovery for a given lport
  * @lport: The lport that discovery should stop for
  *
  * This function will block until discovery has been
@@ -800,7 +801,7 @@ void fc_disc_stop_final(struct fc_lport *lport)
 }
 
 /**
- * fc_disc_init - Initialize the discovery block
+ * fc_disc_init() - Initialize the discovery block
  * @lport: FC local port
  */
 int fc_disc_init(struct fc_lport *lport)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 0d75b23..22e29d1 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -157,7 +157,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lp, gfp_t gfp)
 }
 
 /**
- * fc_fcp_pkt_release - release hold on scsi_pkt packet
+ * fc_fcp_pkt_release() - release hold on scsi_pkt packet
  * @fsp:	fcp packet struct
  *
  * This is used by upper layer scsi driver.
@@ -179,8 +179,7 @@ static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_pkt_destory - release hold on scsi_pkt packet
- *
+ * fc_fcp_pkt_destory() - release hold on scsi_pkt packet
  * @seq:		exchange sequence
  * @fsp:	fcp packet struct
  *
@@ -195,7 +194,7 @@ static void fc_fcp_pkt_destroy(struct fc_seq *seq, void *fsp)
 }
 
 /**
- * fc_fcp_lock_pkt - lock a packet and get a ref to it.
+ * fc_fcp_lock_pkt() - lock a packet and get a ref to it.
  * @fsp:	fcp packet
  *
  * We should only return error if we return a command to scsi-ml before
@@ -287,9 +286,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	buf = fc_frame_payload_get(fp, 0);
 
 	if (offset + len > fsp->data_len) {
-		/*
-		 * this should never happen
-		 */
+		/* this should never happen */
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
 		    fc_frame_crc_check(fp))
 			goto crc_err;
@@ -383,8 +380,8 @@ crc_err:
 		fc_fcp_complete_locked(fsp);
 }
 
-/*
- * fc_fcp_send_data -  Send SCSI data to target.
+/**
+ * fc_fcp_send_data() -  Send SCSI data to target.
  * @fsp: ptr to fc_fcp_pkt
  * @sp: ptr to this sequence
  * @offset: starting offset for this data request
@@ -606,8 +603,8 @@ static void fc_fcp_abts_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	}
 }
 
-/*
- * fc_fcp_reduce_can_queue - drop can_queue
+/**
+ * fc_fcp_reduce_can_queue() - drop can_queue
  * @lp: lport to drop queueing for
  *
  * If we are getting memory allocation failures, then we may
@@ -638,9 +635,11 @@ done:
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
@@ -828,7 +827,7 @@ err:
 }
 
 /**
- * fc_fcp_complete_locked - complete processing of a fcp packet
+ * fc_fcp_complete_locked() - complete processing of a fcp packet
  * @fsp:	fcp packet
  *
  * This function may sleep if a timer is pending. The packet lock must be
@@ -896,7 +895,7 @@ static void fc_fcp_cleanup_cmd(struct fc_fcp_pkt *fsp, int error)
 }
 
 /**
- * fc_fcp_cleanup_each_cmd - run fn on each active command
+ * fc_fcp_cleanup_each_cmd() - Cleanup active commads
  * @lp:		logical port
  * @id:		target id
  * @lun:	lun
@@ -948,7 +947,7 @@ static void fc_fcp_abort_io(struct fc_lport *lp)
 }
 
 /**
- * fc_fcp_pkt_send - send a fcp packet to the lower level.
+ * fc_fcp_pkt_send() - send a fcp packet to the lower level.
  * @lp:		fc lport
  * @fsp:	fc packet.
  *
@@ -1721,7 +1720,7 @@ out:
 EXPORT_SYMBOL(fc_queuecommand);
 
 /**
- * fc_io_compl -  Handle responses for completed commands
+ * fc_io_compl() -  Handle responses for completed commands
  * @fsp:	scsi packet
  *
  * Translates a error to a Linux SCSI error.
@@ -1851,7 +1850,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_complete - complete processing of a fcp packet
+ * fc_fcp_complete() - complete processing of a fcp packet
  * @fsp:	fcp packet
  *
  * This function may sleep if a fsp timer is pending.
@@ -1868,9 +1867,10 @@ void fc_fcp_complete(struct fc_fcp_pkt *fsp)
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
@@ -1914,7 +1914,7 @@ release_pkt:
 EXPORT_SYMBOL(fc_eh_abort);
 
 /**
- * fc_eh_device_reset: Reset a single LUN
+ * fc_eh_device_reset() Reset a single LUN
  * @sc_cmd:	scsi command
  *
  * Set from scsi host template to send tm cmd to the target and wait for the
@@ -1967,7 +1967,7 @@ out:
 EXPORT_SYMBOL(fc_eh_device_reset);
 
 /**
- * fc_eh_host_reset - The reset function will reset the ports on the host.
+ * fc_eh_host_reset() - The reset function will reset the ports on the host.
  * @sc_cmd:	scsi command
  */
 int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
@@ -1994,7 +1994,7 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 EXPORT_SYMBOL(fc_eh_host_reset);
 
 /**
- * fc_slave_alloc - configure queue depth
+ * fc_slave_alloc() - configure queue depth
  * @sdev:	scsi device
  *
  * Configures queue depth based on host's cmd_per_len. If not set
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 54ef40e..fb581a6 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -131,7 +131,7 @@ static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
- * fc_lport_rport_callback - Event handler for rport events
+ * fc_lport_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
  * @rport: The rport which the event has occured on
  * @event: The event that occured
@@ -187,7 +187,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 }
 
 /**
- * fc_lport_state - Return a string which represents the lport's state
+ * fc_lport_state() - Return a string which represents the lport's state
  * @lport: The lport whose state is to converted to a string
  */
 static const char *fc_lport_state(struct fc_lport *lport)
@@ -201,7 +201,7 @@ static const char *fc_lport_state(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_ptp_setup - Create an rport for point-to-point mode
+ * fc_lport_ptp_setup() - Create an rport for point-to-point mode
  * @lport: The lport to attach the ptp rport to
  * @fid: The FID of the ptp rport
  * @remote_wwpn: The WWPN of the ptp rport
@@ -343,7 +343,7 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
 }
 
 /**
- * fc_lport_recv_rlir_req - Handle received Registered Link Incident Report.
+ * fc_lport_recv_rlir_req() - Handle received Registered Link Incident Report.
  * @lport: Fibre Channel local port recieving the RLIR
  * @sp: current sequence in the RLIR exchange
  * @fp: RLIR request frame
@@ -362,7 +362,7 @@ static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_lport_recv_echo_req - Handle received ECHO request
+ * fc_lport_recv_echo_req() - Handle received ECHO request
  * @lport: Fibre Channel local port recieving the ECHO
  * @sp: current sequence in the ECHO exchange
  * @fp: ECHO request frame
@@ -404,7 +404,7 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_echo_req - Handle received Request Node ID data request
+ * fc_lport_recv_echo_req() - Handle received Request Node ID data request
  * @lport: Fibre Channel local port recieving the RNID
  * @sp: current sequence in the RNID exchange
  * @fp: RNID request frame
@@ -471,7 +471,7 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_adisc_req - Handle received Address Discovery Request
+ * fc_lport_recv_adisc_req() - Handle received Address Discovery Request
  * @lport: Fibre Channel local port recieving the ADISC
  * @sp: current sequence in the ADISC exchange
  * @fp: ADISC request frame
@@ -521,7 +521,7 @@ static void fc_lport_recv_adisc_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_logo_req - Handle received fabric LOGO request
+ * fc_lport_recv_logo_req() - Handle received fabric LOGO request
  * @lport: Fibre Channel local port recieving the LOGO
  * @sp: current sequence in the LOGO exchange
  * @fp: LOGO request frame
@@ -538,7 +538,7 @@ static void fc_lport_recv_logo_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_fabric_login - Start the lport state machine
+ * fc_fabric_login() - Start the lport state machine
  * @lport: The lport that should log into the fabric
  *
  * Locking Note: This function should not be called
@@ -560,7 +560,7 @@ int fc_fabric_login(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_fabric_login);
 
 /**
- * fc_linkup - Handler for transport linkup events
+ * fc_linkup() - Handler for transport linkup events
  * @lport: The lport whose link is up
  */
 void fc_linkup(struct fc_lport *lport)
@@ -580,7 +580,7 @@ void fc_linkup(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_linkup);
 
 /**
- * fc_linkdown - Handler for transport linkdown events
+ * fc_linkdown() - Handler for transport linkdown events
  * @lport: The lport whose link is down
  */
 void fc_linkdown(struct fc_lport *lport)
@@ -599,12 +599,12 @@ void fc_linkdown(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_linkdown);
 
 /**
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
@@ -617,7 +617,7 @@ int fc_fabric_logoff(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_fabric_logoff);
 
 /**
- * fc_lport_destroy - unregister a fc_lport
+ * fc_lport_destroy() - unregister a fc_lport
  * @lport:	      fc_lport pointer to unregister
  *
  * Return value:
@@ -627,7 +627,7 @@ EXPORT_SYMBOL(fc_fabric_logoff);
  * clean-up all the allocated memory
  * and free up other system resources.
  *
- **/
+ */
 int fc_lport_destroy(struct fc_lport *lport)
 {
 	lport->tt.frame_send = fc_frame_drop;
@@ -638,15 +638,14 @@ int fc_lport_destroy(struct fc_lport *lport)
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
@@ -675,7 +674,7 @@ int fc_set_mfs(struct fc_lport *lport, u32 mfs)
 EXPORT_SYMBOL(fc_set_mfs);
 
 /**
- * fc_lport_disc_callback - Callback for discovery events
+ * fc_lport_disc_callback() - Callback for discovery events
  * @lport: FC local port
  * @event: The discovery event
  */
@@ -700,7 +699,7 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 }
 
 /**
- * fc_rport_enter_ready - Enter the ready state and start discovery
+ * fc_rport_enter_ready() - Enter the ready state and start discovery
  * @lport: Fibre Channel local port that is ready
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -717,7 +716,7 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_recv_flogi_req - Receive a FLOGI request
+ * fc_lport_recv_flogi_req() - Receive a FLOGI request
  * @sp_in: The sequence the FLOGI is on
  * @rx_fp: The frame the FLOGI is in
  * @lport: The lport that recieved the request
@@ -807,7 +806,7 @@ out:
 }
 
 /**
- * fc_lport_recv_req - The generic lport request handler
+ * fc_lport_recv_req() - The generic lport request handler
  * @lport: The lport that received the request
  * @sp: The sequence the request is on
  * @fp: The frame the request is in
@@ -903,7 +902,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 }
 
 /**
- * fc_lport_reset - Reset an lport
+ * fc_lport_reset() - Reset an lport
  * @lport: The lport which should be reset
  *
  * Locking Note: This functions should not be called with the
@@ -919,7 +918,7 @@ int fc_lport_reset(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_lport_reset);
 
 /**
- * fc_rport_enter_reset - Reset the local port
+ * fc_rport_enter_reset() - Reset the local port
  * @lport: Fibre Channel local port to be reset
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -952,7 +951,7 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_error - Handler for any errors
+ * fc_lport_error() - Handler for any errors
  * @lport: The fc_lport object
  * @fp: The frame pointer
  *
@@ -999,8 +998,8 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
- * fc_lport_rft_id_resp - Handle response to Register Fibre
- *			  Channel Types by ID (RPN_ID) request
+ * fc_lport_rft_id_resp() - Handle response to Register Fibre
+ *			    Channel Types by ID (RPN_ID) request
  * @sp: current sequence in RPN_ID exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
@@ -1051,8 +1050,8 @@ err:
 }
 
 /**
- * fc_lport_rpn_id_resp - Handle response to Register Port
- *			  Name by ID (RPN_ID) request
+ * fc_lport_rpn_id_resp() - Handle response to Register Port
+ *			    Name by ID (RPN_ID) request
  * @sp: current sequence in RPN_ID exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
@@ -1103,7 +1102,7 @@ err:
 }
 
 /**
- * fc_lport_scr_resp - Handle response to State Change Register (SCR) request
+ * fc_lport_scr_resp() - Handle response to State Change Register (SCR) request
  * @sp: current sequence in SCR exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel lport port instance that sent the registration request
@@ -1149,7 +1148,7 @@ err:
 }
 
 /**
- * fc_lport_enter_scr - Send a State Change Register (SCR) request
+ * fc_lport_enter_scr() - Send a State Change Register (SCR) request
  * @lport: Fibre Channel local port to register for state changes
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1176,7 +1175,7 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_enter_rft_id - Register FC4-types with the name server
+ * fc_lport_enter_rft_id() - Register FC4-types with the name server
  * @lport: Fibre Channel local port to register
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1218,7 +1217,7 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 }
 
 /**
- * fc_rport_enter_rft_id - Register port name with the name server
+ * fc_rport_enter_rft_id() - Register port name with the name server
  * @lport: Fibre Channel local port to register
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1251,7 +1250,7 @@ static struct fc_rport_operations fc_lport_rport_ops = {
 };
 
 /**
- * fc_rport_enter_dns - Create a rport to the name server
+ * fc_rport_enter_dns() - Create a rport to the name server
  * @lport: Fibre Channel local port requesting a rport for the name server
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1288,7 +1287,7 @@ err:
 }
 
 /**
- * fc_lport_timeout - Handler for the retry_work timer.
+ * fc_lport_timeout() - Handler for the retry_work timer.
  * @work: The work struct of the fc_lport
  */
 static void fc_lport_timeout(struct work_struct *work)
@@ -1329,7 +1328,7 @@ static void fc_lport_timeout(struct work_struct *work)
 }
 
 /**
- * fc_lport_logo_resp - Handle response to LOGO request
+ * fc_lport_logo_resp() - Handle response to LOGO request
  * @sp: current sequence in LOGO exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel lport port instance that sent the LOGO request
@@ -1375,7 +1374,7 @@ err:
 }
 
 /**
- * fc_rport_enter_logo - Logout of the fabric
+ * fc_rport_enter_logo() - Logout of the fabric
  * @lport: Fibre Channel local port to be logged out
  *
  * Locking Note: The lport lock is expected to be held before calling
@@ -1407,7 +1406,7 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_flogi_resp - Handle response to FLOGI request
+ * fc_lport_flogi_resp() - Handle response to FLOGI request
  * @sp: current sequence in FLOGI exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel lport port instance that sent the FLOGI request
@@ -1504,7 +1503,7 @@ err:
 }
 
 /**
- * fc_rport_enter_flogi - Send a FLOGI request to the fabric manager
+ * fc_rport_enter_flogi() - Send a FLOGI request to the fabric manager
  * @lport: Fibre Channel local port to be logged in to the fabric
  *
  * Locking Note: The lport lock is expected to be held before calling
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d4f6e01..b008f49 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -138,7 +138,7 @@ struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
 }
 
 /**
- * fc_rport_state - return a string for the state the rport is in
+ * fc_rport_state() - return a string for the state the rport is in
  * @rport: The rport whose state we want to get a string for
  */
 static const char *fc_rport_state(struct fc_rport *rport)
@@ -153,7 +153,7 @@ static const char *fc_rport_state(struct fc_rport *rport)
 }
 
 /**
- * fc_set_rport_loss_tmo - Set the remote port loss timeout in seconds.
+ * fc_set_rport_loss_tmo() - Set the remote port loss timeout in seconds.
  * @rport: Pointer to Fibre Channel remote port structure
  * @timeout: timeout in seconds
  */
@@ -167,7 +167,7 @@ void fc_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 EXPORT_SYMBOL(fc_set_rport_loss_tmo);
 
 /**
- * fc_plogi_get_maxframe - Get max payload from the common service parameters
+ * fc_plogi_get_maxframe() - Get max payload from the common service parameters
  * @flp: FLOGI payload structure
  * @maxval: upper limit, may be less than what is in the service parameters
  */
@@ -190,7 +190,7 @@ fc_plogi_get_maxframe(struct fc_els_flogi *flp, unsigned int maxval)
 }
 
 /**
- * fc_rport_state_enter - Change the rport's state
+ * fc_rport_state_enter() - Change the rport's state
  * @rport: The rport whose state should change
  * @new: The new state of the rport
  *
@@ -284,7 +284,7 @@ static void fc_rport_work(struct work_struct *work)
 }
 
 /**
- * fc_rport_login - Start the remote port login state machine
+ * fc_rport_login() - Start the remote port login state machine
  * @rport: Fibre Channel remote port
  *
  * Locking Note: Called without the rport lock held. This
@@ -307,7 +307,7 @@ int fc_rport_login(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_logoff - Logoff and remove an rport
+ * fc_rport_logoff() - Logoff and remove an rport
  * @rport: Fibre Channel remote port to be removed
  *
  * Locking Note: Called without the rport lock held. This
@@ -345,7 +345,7 @@ int fc_rport_logoff(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_enter_ready - The rport is ready
+ * fc_rport_enter_ready() - The rport is ready
  * @rport: Fibre Channel remote port that is ready
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -364,7 +364,7 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_timeout - Handler for the retry_work timer.
+ * fc_rport_timeout() - Handler for the retry_work timer.
  * @work: The work struct of the fc_rport_libfc_priv
  *
  * Locking Note: Called without the rport lock held. This
@@ -403,7 +403,7 @@ static void fc_rport_timeout(struct work_struct *work)
 }
 
 /**
- * fc_rport_error - Error handler, called once retries have been exhausted
+ * fc_rport_error() - Error handler, called once retries have been exhausted
  * @rport: The fc_rport object
  * @fp: The frame pointer
  *
@@ -436,7 +436,7 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 }
 
 /**
- * fc_rport_error_retry - Error handler when retries are desired
+ * fc_rport_error_retry() - Error handler when retries are desired
  * @rport: The fc_rport object
  * @fp: The frame pointer
  *
@@ -471,7 +471,7 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 }
 
 /**
- * fc_rport_plogi_recv_resp - Handle incoming ELS PLOGI response
+ * fc_rport_plogi_recv_resp() - Handle incoming ELS PLOGI response
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -546,7 +546,7 @@ err:
 }
 
 /**
- * fc_rport_enter_plogi - Send Port Login (PLOGI) request to peer
+ * fc_rport_enter_plogi() - Send Port Login (PLOGI) request to peer
  * @rport: Fibre Channel remote port to send PLOGI to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -579,7 +579,7 @@ static void fc_rport_enter_plogi(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_prli_resp - Process Login (PRLI) response handler
+ * fc_rport_prli_resp() - Process Login (PRLI) response handler
  * @sp: current sequence in the PRLI exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -649,7 +649,7 @@ err:
 }
 
 /**
- * fc_rport_logo_resp - Logout (LOGO) response handler
+ * fc_rport_logo_resp() - Logout (LOGO) response handler
  * @sp: current sequence in the LOGO exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -698,7 +698,7 @@ err:
 }
 
 /**
- * fc_rport_enter_prli - Send Process Login (PRLI) request to peer
+ * fc_rport_enter_prli() - Send Process Login (PRLI) request to peer
  * @rport: Fibre Channel remote port to send PRLI to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -733,7 +733,7 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_els_rtv_resp - Request Timeout Value response handler
+ * fc_rport_els_rtv_resp() - Request Timeout Value response handler
  * @sp: current sequence in the RTV exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -799,7 +799,7 @@ err:
 }
 
 /**
- * fc_rport_enter_rtv - Send Request Timeout Value (RTV) request to peer
+ * fc_rport_enter_rtv() - Send Request Timeout Value (RTV) request to peer
  * @rport: Fibre Channel remote port to send RTV to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -830,7 +830,7 @@ static void fc_rport_enter_rtv(struct fc_rport *rport)
 }
 
 /**
- * fc_rport_enter_logo - Send Logout (LOGO) request to peer
+ * fc_rport_enter_logo() - Send Logout (LOGO) request to peer
  * @rport: Fibre Channel remote port to send LOGO to
  *
  * Locking Note: The rport lock is expected to be held before calling
@@ -862,7 +862,7 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 
 
 /**
- * fc_rport_recv_req - Receive a request from a rport
+ * fc_rport_recv_req() - Receive a request from a rport
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
  * @rp_arg: Fibre Channel remote port
@@ -923,7 +923,7 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_rport_recv_plogi_req - Handle incoming Port Login (PLOGI) request
+ * fc_rport_recv_plogi_req() - Handle incoming Port Login (PLOGI) request
  * @rport: Fibre Channel remote port that initiated PLOGI
  * @sp: current sequence in the PLOGI exchange
  * @fp: PLOGI request frame
@@ -1045,7 +1045,7 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 }
 
 /**
- * fc_rport_recv_prli_req - Handle incoming Process Login (PRLI) request
+ * fc_rport_recv_prli_req() - Handle incoming Process Login (PRLI) request
  * @rport: Fibre Channel remote port that initiated PRLI
  * @sp: current sequence in the PRLI exchange
  * @fp: PRLI request frame
@@ -1196,7 +1196,7 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 }
 
 /**
- * fc_rport_recv_prlo_req - Handle incoming Process Logout (PRLO) request
+ * fc_rport_recv_prlo_req() - Handle incoming Process Logout (PRLO) request
  * @rport: Fibre Channel remote port that initiated PRLO
  * @sp: current sequence in the PRLO exchange
  * @fp: PRLO request frame
@@ -1227,7 +1227,7 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 }
 
 /**
- * fc_rport_recv_logo_req - Handle incoming Logout (LOGO) request
+ * fc_rport_recv_logo_req() - Handle incoming Logout (LOGO) request
  * @rport: Fibre Channel remote port that initiated LOGO
  * @sp: current sequence in the LOGO exchange
  * @fp: LOGO request frame
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 30056cd..7df48de 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -690,7 +690,7 @@ struct fc_lport {
 	struct delayed_work	disc_work;
 };
 
-/**
+/*
  * FC_LPORT HELPER FUNCTIONS
  *****************************/
 static inline void *lport_priv(const struct fc_lport *lp)
@@ -722,7 +722,7 @@ static inline void fc_lport_state_enter(struct fc_lport *lp,
 }
 
 
-/**
+/*
  * LOCAL PORT LAYER
  *****************************/
 int fc_lport_init(struct fc_lport *lp);
@@ -772,19 +772,19 @@ int fc_lport_reset(struct fc_lport *);
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
@@ -845,7 +845,7 @@ int fc_change_queue_type(struct scsi_device *sdev, int tag_type);
  */
 void fc_fcp_destroy(struct fc_lport *);
 
-/**
+/*
  * ELS/CT interface
  *****************************/
 /*
@@ -854,7 +854,7 @@ void fc_fcp_destroy(struct fc_lport *);
 int fc_elsct_init(struct fc_lport *lp);
 
 
-/**
+/*
  * EXCHANGE MANAGER LAYER
  *****************************/
 /*

