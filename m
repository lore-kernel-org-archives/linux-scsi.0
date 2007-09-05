From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH] fusion -mm bits : Kconfig menuconfig objects, use kzalloc in mptctl, fix mem leaks, kill redundant memset
Date: Wed, 5 Sep 2007 16:13:45 -0600
Message-ID: <20070905221345.GA18262@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64398 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbXIEWUy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2007 18:20:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@linux-foundaion.org

James - These fusion patchs from -mm can be merged into scsi-misc.  Here is a single patch containing all four changes.

Changeset:

[patch 08/30] Use menuconfig objects: Fusion
	http://marc.info/?l=linux-scsi&m=118678275800902&w=2
[patch 26/30] drivers/message/fusion/mptctl.c: mostly kmalloc + memset conversion to kzalloc
	http://marc.info/?l=linux-scsi&m=118678346112881&w=2
[patch 27/30] mpt-fusion: fix two potential mem leaks
	http://marc.info/?l=linux-scsi&m=118678345904954&w=2
[patch 30/30] message/fusion: remove redundant memset
	http://marc.info/?l=linux-scsi&m=118678345816541&w=2

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff --git a/drivers/message/fusion/Kconfig b/drivers/message/fusion/Kconfig
index 3c44a2f..9b87c2f 100644
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -1,15 +1,19 @@
 
-menu "Fusion MPT device support"
+menuconfig FUSION
+	bool "Fusion MPT device support"
 	depends on PCI
+	---help---
+	Say Y here to get to see options for Fusion Message
+	Passing Technology (MPT) drivers.
+	This option alone does not add any kernel code.
+
+	If you say N, all options in this submenu will be skipped and disabled.
 
-config FUSION
-	bool
-	default n
+if FUSION
 
 config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_SPI_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
@@ -25,7 +29,6 @@ config FUSION_SPI
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -43,7 +46,6 @@ config FUSION_FC
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
- 	select FUSION
 	select SCSI_SAS_ATTRS
 	---help---
 	  SCSI HOST support for a SAS host adapters.
@@ -57,7 +59,6 @@ config FUSION_SAS
 
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
-	depends on FUSION
 	default "128"
 	range 16 128
 	help
@@ -117,4 +118,4 @@ config FUSION_LOGGING
 	  There are various debug levels that an be found in the source:
 	  file:drivers/message/fusion/mptdebug.h
 
-endmenu
+endif # FUSION
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 22cb0f8..635defd 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1458,18 +1458,18 @@ mpt_attach(struct pci_dev *pdev, const s
 	struct proc_dir_entry *dent, *ent;
 #endif
 
+	if (mpt_debug_level)
+		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
+
+	if (pci_enable_device(pdev))
+		return r;
+
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-
 	ioc->debug_level = mpt_debug_level;
-	if (mpt_debug_level)
-		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
-
-	if (pci_enable_device(pdev))
-		return r;
 
 	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
@@ -1478,6 +1478,7 @@ mpt_attach(struct pci_dev *pdev, const s
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		kfree(ioc);
 		return r;
 	}
 
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index b9618f4..12dfa2e 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -977,10 +977,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 	 * structures for the SG elements.
 	 */
 	i = MAX_SGL_BYTES / 8;
-	buflist = kmalloc(i, GFP_USER);
-	if (buflist == NULL)
+	buflist = kzalloc(i, GFP_USER);
+	if (!buflist)
 		return NULL;
-	memset(buflist, 0, i);
 	buflist_ent = 0;
 
 	/* Allocate a single block of memory to store the sg elements and
@@ -1379,13 +1378,12 @@ mptctl_gettargetinfo (unsigned long arg)
 	 *      15- 8: Bus Number
 	 *       7- 0: Target ID
 	 */
-	pmem = kmalloc(numBytes, GFP_KERNEL);
-	if (pmem == NULL) {
+	pmem = kzalloc(numBytes, GFP_KERNEL);
+	if (!pmem) {
 		printk(KERN_ERR "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
 				__FILE__, __LINE__);
 		return -ENOMEM;
 	}
-	memset(pmem, 0, numBytes);
 	pdata =  (int *) pmem;
 
 	/* Get number of devices
@@ -1570,12 +1568,11 @@ mptctl_eventenable (unsigned long arg)
 		/* Have not yet allocated memory - do so now.
 		 */
 		int sz = MPTCTL_EVENT_LOG_SIZE * sizeof(MPT_IOCTL_EVENTS);
-		ioc->events = kmalloc(sz, GFP_KERNEL);
-		if (ioc->events == NULL) {
+		ioc->events = kzalloc(sz, GFP_KERNEL);
+		if (!ioc->events) {
 			printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 			return -ENOMEM;
 		}
-		memset(ioc->events, 0, sz);
 		ioc->alloc_total += sz;
 
 		ioc->eventContext = 0;
@@ -2865,31 +2862,22 @@ static long compat_mpctl_ioctl(struct fi
 static int
 mptctl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int err;
-	int sz;
-	u8 *mem;
+	MPT_IOCTL *mem;
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
 	/*
 	 * Allocate and inite a MPT_IOCTL structure
 	*/
-	sz = sizeof (MPT_IOCTL);
-	mem = kmalloc(sz, GFP_KERNEL);
-	if (mem == NULL) {
-		err = -ENOMEM;
-		goto out_fail;
+	mem = kzalloc(sizeof(MPT_IOCTL), GFP_KERNEL);
+	if (!mem) {
+		mptctl_remove(pdev);
+		return -ENOMEM;
 	}
 
-	memset(mem, 0, sz);
-	ioc->ioctl = (MPT_IOCTL *) mem;
+	ioc->ioctl = mem;
 	ioc->ioctl->ioc = ioc;
 	mutex_init(&ioc->ioctl->ioctl_mutex);
 	return 0;
-
-out_fail:
-
-	mptctl_remove(pdev);
-	return err;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 952e148..b550471 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1345,10 +1345,11 @@ mpt_lan_post_receive_buckets_work(struct
 static struct net_device *
 mpt_register_lan_device (MPT_ADAPTER *mpt_dev, int pnum)
 {
-	struct net_device *dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
-	struct mpt_lan_priv *priv = NULL;
+	struct net_device *dev;
+	struct mpt_lan_priv *priv;
 	u8 HWaddr[FC_ALEN], *a;
 
+	dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
 	if (!dev)
 		return NULL;
 
@@ -1360,7 +1361,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	priv->mpt_dev = mpt_dev;
 	priv->pnum = pnum;
 
-	memset(&priv->post_buckets_task, 0, sizeof(priv->post_buckets_task));
 	INIT_DELAYED_WORK(&priv->post_buckets_task,
 			  mpt_lan_post_receive_buckets_work);
 	priv->post_buckets_active = 0;
@@ -1385,8 +1385,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	spin_lock_init(&priv->txfidx_lock);
 	spin_lock_init(&priv->rxfidx_lock);
 
-	memset(&priv->stats, 0, sizeof(priv->stats));
-
 	/*  Grab pre-fetched LANPage1 stuff. :-) */
 	a = (u8 *) &mpt_dev->lan_cnfg_page1.HardwareAddressLow;
 

