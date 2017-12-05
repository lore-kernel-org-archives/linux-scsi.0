From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.15-rc2
Date: Tue, 05 Dec 2017 08:56:49 -0800
Message-ID: <1512493009.3019.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38656 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751937AbdLEQ4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 11:56:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

We have a bunch of fixes for aacraid, a set of coherency fixes that
only affect non-coherent platforms and one coccinelle detected null
check after use.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi: dma-mapping: always provide dma_get_cache_alignment

Guilherme G. Piccoli (3):
      scsi: aacraid: Prevent crash in case of free interrupt during scsi EH path
      scsi: aacraid: Perform initialization reset only once
      scsi: aacraid: Check for PCI state of device in a generic way

Gustavo A. R. Silva (1):
      scsi: ufs: ufshcd: fix potential NULL pointer dereference in ufshcd_config_vreg

Huacai Chen (2):
      scsi: libsas: align sata_device's rps_resp on a cacheline
      scsi: use dma_get_cache_alignment() as minimum DMA alignment

And the diffstat:

 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/commsup.c | 35 +++--------------------------------
 drivers/scsi/aacraid/linit.c   |  3 +++
 drivers/scsi/aacraid/rx.c      | 15 ++++++++++-----
 drivers/scsi/aacraid/src.c     | 20 ++++++++++++++------
 drivers/scsi/scsi_lib.c        | 10 ++++++----
 drivers/scsi/ufs/ufshcd.c      |  7 +++++--
 include/linux/dma-mapping.h    |  2 --
 include/scsi/libsas.h          |  2 +-
 9 files changed, 43 insertions(+), 52 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 403a639574e5..6e3d81969a77 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1673,6 +1673,7 @@ struct aac_dev
 	struct aac_hba_map_info	hba_map[AAC_MAX_BUSES][AAC_MAX_TARGETS];
 	u8			adapter_shutdown;
 	u32			handle_pci_error;
+	bool			init_reset;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 525a652dab48..bec9f3193f60 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -467,35 +467,6 @@ int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct hw_fib * hw
 	return 0;
 }
 
-#ifdef CONFIG_EEH
-static inline int aac_check_eeh_failure(struct aac_dev *dev)
-{
-	/* Check for an EEH failure for the given
-	 * device node. Function eeh_dev_check_failure()
-	 * returns 0 if there has not been an EEH error
-	 * otherwise returns a non-zero value.
-	 *
-	 * Need to be called before any PCI operation,
-	 * i.e.,before aac_adapter_check_health()
-	 */
-	struct eeh_dev *edev = pci_dev_to_eeh_dev(dev->pdev);
-
-	if (eeh_dev_check_failure(edev)) {
-		/* The EEH mechanisms will handle this
-		 * error and reset the device if
-		 * necessary.
-		 */
-		return 1;
-	}
-	return 0;
-}
-#else
-static inline int aac_check_eeh_failure(struct aac_dev *dev)
-{
-	return 0;
-}
-#endif
-
 /*
  *	Define the highest level of host to adapter communication routines.
  *	These routines will support host to adapter FS commuication. These
@@ -701,7 +672,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					return -ETIMEDOUT;
 				}
 
-				if (aac_check_eeh_failure(dev))
+				if (unlikely(pci_channel_offline(dev->pdev)))
 					return -EFAULT;
 
 				if ((blink = aac_adapter_check_health(dev)) > 0) {
@@ -801,7 +772,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
-		if (aac_check_eeh_failure(dev))
+		if (unlikely(pci_channel_offline(dev->pdev)))
 			return -EFAULT;
 
 		fibptr->flags |= FIB_CONTEXT_FLAG_WAIT;
@@ -1583,6 +1554,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * will ensure that i/o is queisced and the card is flushed in that
 	 * case.
 	 */
+	aac_free_irq(aac);
 	aac_fib_map_free(aac);
 	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
 			  aac->comm_phys);
@@ -1590,7 +1562,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	aac->comm_phys = 0;
 	kfree(aac->queues);
 	aac->queues = NULL;
-	aac_free_irq(aac);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c9252b138c1f..bdf127aaab41 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1680,6 +1680,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->cardtype = index;
 	INIT_LIST_HEAD(&aac->entry);
 
+	if (aac_reset_devices || reset_devices)
+		aac->init_reset = true;
+
 	aac->fibs = kzalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
 	if (!aac->fibs)
 		goto out_free_host;
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 93ef7c37e568..620166694171 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -561,11 +561,16 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
 	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
-	if ((((status & 0x0c) != 0x0c) || aac_reset_devices || reset_devices) &&
-	  !aac_rx_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
-		/* Make sure the Hardware FIFO is empty */
-		while ((++restart < 512) &&
-		  (rx_readl(dev, MUnit.OutboundQueue) != 0xFFFFFFFFL));
+
+	if (((status & 0x0c) != 0x0c) || dev->init_reset) {
+		dev->init_reset = false;
+		if (!aac_rx_restart_adapter(dev, 0, IOP_HWSOFT_RESET)) {
+			/* Make sure the Hardware FIFO is empty */
+			while ((++restart < 512) &&
+			       (rx_readl(dev, MUnit.OutboundQueue) != 0xFFFFFFFFL));
+		}
+	}
+
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 0c9361c87ec8..fde6b6aa86e3 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -868,9 +868,13 @@ int aac_src_init(struct aac_dev *dev)
 	/* Failure to reset here is an option ... */
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
-	if ((aac_reset_devices || reset_devices) &&
-		!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
-		++restart;
+
+	if (dev->init_reset) {
+		dev->init_reset = false;
+		if (!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
+			++restart;
+	}
+
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
@@ -1014,9 +1018,13 @@ int aac_srcv_init(struct aac_dev *dev)
 	/* Failure to reset here is an option ... */
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
-	if ((aac_reset_devices || reset_devices) &&
-		!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
-		++restart;
+
+	if (dev->init_reset) {
+		dev->init_reset = false;
+		if (!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
+			++restart;
+	}
+
 	/*
 	 *	Check to see if flash update is running.
 	 *	Wait for the adapter to be up and running. Wait up to 5 minutes
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1cbc497e00bd..00742c50cd44 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2148,11 +2148,13 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		q->limits.cluster = 0;
 
 	/*
-	 * set a reasonable default alignment on word boundaries: the
-	 * host and device may alter it using
-	 * blk_queue_update_dma_alignment() later.
+	 * Set a reasonable default alignment:  The larger of 32-byte (dword),
+	 * which is a common minimum for HBAs, and the minimum DMA alignment,
+	 * which is set by the platform.
+	 *
+	 * Devices that require a bigger alignment can increase it later.
 	 */
-	blk_queue_dma_alignment(q, 0x03);
+	blk_queue_dma_alignment(q, max(4, dma_get_cache_alignment()) - 1);
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 011c3369082c..a355d989b414 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6559,12 +6559,15 @@ static int ufshcd_config_vreg(struct device *dev,
 		struct ufs_vreg *vreg, bool on)
 {
 	int ret = 0;
-	struct regulator *reg = vreg->reg;
-	const char *name = vreg->name;
+	struct regulator *reg;
+	const char *name;
 	int min_uV, uA_load;
 
 	BUG_ON(!vreg);
 
+	reg = vreg->reg;
+	name = vreg->name;
+
 	if (regulator_count_voltages(reg) > 0) {
 		min_uV = on ? vreg->min_uV : 0;
 		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index eee1499db396..29cfd18360be 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -710,7 +710,6 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 	return ret;
 }
 
-#ifdef CONFIG_HAS_DMA
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN
@@ -718,7 +717,6 @@ static inline int dma_get_cache_alignment(void)
 #endif
 	return 1;
 }
-#endif
 
 /* flags for the coherent memory api */
 #define DMA_MEMORY_EXCLUSIVE		0x01
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 0f9cbf96c093..6df6fe0c2198 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -159,11 +159,11 @@ struct expander_device {
 
 struct sata_device {
 	unsigned int class;
-	struct smp_resp        rps_resp; /* report_phy_sata_resp */
 	u8     port_no;        /* port number, if this is a PM (Port) */
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
+	struct smp_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp */
 	u8     fis[ATA_RESP_FIS_SIZE];
 };
 
