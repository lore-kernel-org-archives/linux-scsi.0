From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] cxlflash: Fix regression issue with re-ordering patch
Date: Fri, 25 Mar 2016 14:26:34 -0500
Message-ID: <1458933994-28825-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:37684 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbcCYT24 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2016 15:28:56 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 25 Mar 2016 13:28:55 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id C809819D803F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 13:16:46 -0600 (MDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2PJSqtd24248464
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 19:28:52 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2PJNdcq024380
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 15:23:40 -0400
In-Reply-To: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

While running 'sg_reset -H' back to back the following exception was seen:

[  735.115695] Faulting instruction address: 0xd0000000098c0864
cpu 0x0: Vector: 300 (Data Access) at [c000000ffffafa80]
    pc: d0000000098c0864: cxlflash_async_err_irq+0x84/0x5c0 [cxlflash]
    lr: c00000000013aed0: handle_irq_event_percpu+0xa0/0x310
    sp: c000000ffffafd00
   msr: 9000000000009033
   dar: 2010000
 dsisr: 40000000
  current = 0xc000000001510880
  paca    = 0xc00000000fb80000   softe: 0        irq_happened: 0x01
    pid   = 0, comm = swapper/0

Linux version 4.5.0-491-26f710d+

enter ? for help
[c000000ffffafe10] c00000000013aed0 handle_irq_event_percpu+0xa0/0x310
[c000000ffffafed0] c00000000013b1a8 handle_irq_event+0x68/0xc0
[c000000ffffaff00] c0000000001404ec handle_fasteoi_irq+0xec/0x2a0
[c000000ffffaff30] c00000000013a084 generic_handle_irq+0x54/0x80
[c000000ffffaff60] c000000000011130 __do_irq+0x80/0x1d0
[c000000ffffaff90] c000000000024d40 call_do_irq+0x14/0x24
[c000000001573a20] c000000000011318 do_IRQ+0x98/0x140
[c000000001573a70] c000000000002594 hardware_interrupt_common+0x114/0x180

This exception is being hit because the async_err interrupt path performs
an MMIO to read the interrupt status register. The MMIO region in this
case is not available.

Commit 6ded8b3cbd9a ("cxlflash: Unmap problem state area before detaching
master context") re-ordered the sequence in which term_mc() and stop_afu()
are called. This introduces a window for interrupts to come in with the
problem space area unmapped, that did not exist previously.

The fix is to separate the disabling of all AFU interrupts to a distinct
function, term_intr() so that it is the first thing that is done in the
tear down process.

To keep the initialization process symmetric, separate the AFU interrupt
setup also to a distinct function: init_intr().

Fixes: 6ded8b3cbd9a ("cxlflash: Unmap problem state area before detaching master context")
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 130 ++++++++++++++++++++++++++++++-------------
 drivers/scsi/cxlflash/main.h |   5 +-
 2 files changed, 93 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 35968bd..e6d56ac 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -683,28 +683,23 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 }
 
 /**
- * term_mc() - terminates the master context
+ * term_intr() - disables all AFU interrupts
  * @cfg:	Internal structure associated with the host.
  * @level:	Depth of allocation, where to begin waterfall tear down.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
  */
-static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
+static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level)
 {
-	int rc = 0;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 
 	if (!afu || !cfg->mcctx) {
-		dev_err(dev, "%s: returning from term_mc with NULL afu or MC\n",
-		       __func__);
+		dev_err(dev, "%s: returning with NULL afu or MC\n", __func__);
 		return;
 	}
 
 	switch (level) {
-	case UNDO_START:
-		rc = cxl_stop_context(cfg->mcctx);
-		BUG_ON(rc);
 	case UNMAP_THREE:
 		cxl_unmap_afu_irq(cfg->mcctx, 3, afu);
 	case UNMAP_TWO:
@@ -713,9 +708,34 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
 		cxl_unmap_afu_irq(cfg->mcctx, 1, afu);
 	case FREE_IRQ:
 		cxl_free_afu_irqs(cfg->mcctx);
-	case RELEASE_CONTEXT:
-		cfg->mcctx = NULL;
+		/* fall through */
+	case UNDO_NOOP:
+		/* No action required */
+		break;
+	}
+}
+
+/**
+ * term_mc() - terminates the master context
+ * @cfg:	Internal structure associated with the host.
+ * @level:	Depth of allocation, where to begin waterfall tear down.
+ *
+ * Safe to call with AFU/MC in partially allocated/initialized state.
+ */
+static void term_mc(struct cxlflash_cfg *cfg)
+{
+	int rc = 0;
+	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
+
+	if (!afu || !cfg->mcctx) {
+		dev_err(dev, "%s: returning with NULL afu or MC\n", __func__);
+		return;
 	}
+
+	rc = cxl_stop_context(cfg->mcctx);
+	WARN_ON(rc);
+	cfg->mcctx = NULL;
 }
 
 /**
@@ -726,10 +746,20 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
  */
 static void term_afu(struct cxlflash_cfg *cfg)
 {
+	/*
+	 * Tear down is carefully orchestrated to ensure
+	 * no interrupts can come in when the problem state
+	 * area is unmapped.
+	 *
+	 * 1) Disable all AFU interrupts
+	 * 2) Unmap the problem state area
+	 * 3) Stop the master context
+	 */
+	term_intr(cfg, UNMAP_THREE);
 	if (cfg->afu)
 		stop_afu(cfg);
 
-	term_mc(cfg, UNDO_START);
+	term_mc(cfg);
 
 	pr_debug("%s: returning\n", __func__);
 }
@@ -1597,41 +1627,24 @@ static int start_afu(struct cxlflash_cfg *cfg)
 }
 
 /**
- * init_mc() - create and register as the master context
+ * init_intr() - setup interrupt handlers for the master context
  * @cfg:	Internal structure associated with the host.
  *
  * Return: 0 on success, -errno on failure
  */
-static int init_mc(struct cxlflash_cfg *cfg)
+static enum undo_level init_intr(struct cxlflash_cfg *cfg,
+				 struct cxl_context *ctx)
 {
-	struct cxl_context *ctx;
-	struct device *dev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 	int rc = 0;
-	enum undo_level level;
-
-	ctx = cxl_get_context(cfg->dev);
-	if (unlikely(!ctx))
-		return -ENOMEM;
-	cfg->mcctx = ctx;
-
-	/* Set it up as a master with the CXL */
-	cxl_set_master(ctx);
-
-	/* During initialization reset the AFU to start from a clean slate */
-	rc = cxl_afu_reset(cfg->mcctx);
-	if (unlikely(rc)) {
-		dev_err(dev, "%s: initial AFU reset failed rc=%d\n",
-			__func__, rc);
-		level = RELEASE_CONTEXT;
-		goto out;
-	}
+	enum undo_level level = UNDO_NOOP;
 
 	rc = cxl_allocate_afu_irqs(ctx, 3);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: call to allocate_afu_irqs failed rc=%d!\n",
 			__func__, rc);
-		level = RELEASE_CONTEXT;
+		level = UNDO_NOOP;
 		goto out;
 	}
 
@@ -1661,8 +1674,47 @@ static int init_mc(struct cxlflash_cfg *cfg)
 		level = UNMAP_TWO;
 		goto out;
 	}
+out:
+	return level;
+}
 
-	rc = 0;
+/**
+ * init_mc() - create and register as the master context
+ * @cfg:	Internal structure associated with the host.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int init_mc(struct cxlflash_cfg *cfg)
+{
+	struct cxl_context *ctx;
+	struct device *dev = &cfg->dev->dev;
+	int rc = 0;
+	enum undo_level level;
+
+	ctx = cxl_get_context(cfg->dev);
+	if (unlikely(!ctx)) {
+		rc = -ENOMEM;
+		goto ret;
+	}
+	cfg->mcctx = ctx;
+
+	/* Set it up as a master with the CXL */
+	cxl_set_master(ctx);
+
+	/* During initialization reset the AFU to start from a clean slate */
+	rc = cxl_afu_reset(cfg->mcctx);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: initial AFU reset failed rc=%d\n",
+			__func__, rc);
+		goto ret;
+	}
+
+	level = init_intr(cfg, ctx);
+	if (unlikely(level)) {
+		dev_err(dev, "%s: setting up interrupts failed rc=%d\n",
+			__func__, rc);
+		goto out;
+	}
 
 	/* This performs the equivalent of the CXL_IOCTL_START_WORK.
 	 * The CXL_IOCTL_GET_PROCESS_ELEMENT is implicit in the process
@@ -1678,7 +1730,7 @@ ret:
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 out:
-	term_mc(cfg, level);
+	term_intr(cfg, level);
 	goto ret;
 }
 
@@ -1751,7 +1803,8 @@ out:
 err2:
 	kref_put(&afu->mapcount, afu_unmap);
 err1:
-	term_mc(cfg, UNDO_START);
+	term_intr(cfg, UNMAP_THREE);
+	term_mc(cfg);
 	goto out;
 }
 
@@ -2488,8 +2541,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 		if (unlikely(rc))
 			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
 				__func__, rc);
-		stop_afu(cfg);
-		term_mc(cfg, UNDO_START);
+		term_afu(cfg);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		cfg->state = STATE_FAILTERM;
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 0faed42..eb9d8f7 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -79,12 +79,11 @@
 #define WWPN_BUF_LEN	(WWPN_LEN + 1)
 
 enum undo_level {
-	RELEASE_CONTEXT = 0,
+	UNDO_NOOP = 0,
 	FREE_IRQ,
 	UNMAP_ONE,
 	UNMAP_TWO,
-	UNMAP_THREE,
-	UNDO_START
+	UNMAP_THREE
 };
 
 struct dev_dependent_vals {
-- 
2.1.0

