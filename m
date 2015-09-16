From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 08/30] cxlflash: Fix to avoid CXL services during EEH
Date: Wed, 16 Sep 2015 16:27:57 -0500
Message-ID: <1442438877-49469-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:52482 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbbIPV21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 17:28:27 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 17:28:26 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 11FEFC90043
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:19:27 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GLSNod62193894
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 21:28:23 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GLSKJj031138
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:28:22 -0400
In-Reply-To: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

During an EEH freeze event, certain CXL services should not be
called until after the hardware reset has taken place. Doing so
can result in unnecessary failures and possibly cause other ill
effects by triggering hardware accesses. This translates to a
requirement to quiesce all threads that may potentially use CXL
runtime service during this window. In particular, multiple ioctls
make use of the CXL services when acting on contexts on behalf of
the user. Thus, it is essential to 'drain' running ioctls _before_
proceeding with handling the EEH freeze event.

Create the ability to drain ioctls by wrapping the ioctl handler
call in a read semaphore and then implementing a small routine that
obtains the write semaphore, effectively creating a wait point for
all currently executing ioctls.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |   2 +
 drivers/scsi/cxlflash/main.c      |  18 +++++--
 drivers/scsi/cxlflash/superpipe.c | 104 +++++++++++++++++++++++---------------
 3 files changed, 81 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 1c56037..1abe4e0 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -16,6 +16,7 @@
 #define _CXLFLASH_COMMON_H
 
 #include <linux/list.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -110,6 +111,7 @@ struct cxlflash_cfg {
 	atomic_t recovery_threads;
 	struct mutex ctx_recovery_mutex;
 	struct mutex ctx_tbl_list_mutex;
+	struct rw_semaphore ioctl_rwsem;
 	struct ctx_info *ctx_tbl[MAX_CONTEXT];
 	struct list_head ctx_err_recovery; /* contexts w/ recovery pending */
 	struct file_operations cxl_fops;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 3e3ccf1..6e85c77 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2311,6 +2311,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->lr_port = -1;
 	mutex_init(&cfg->ctx_tbl_list_mutex);
 	mutex_init(&cfg->ctx_recovery_mutex);
+	init_rwsem(&cfg->ioctl_rwsem);
 	INIT_LIST_HEAD(&cfg->ctx_err_recovery);
 	INIT_LIST_HEAD(&cfg->lluns);
 
@@ -2365,6 +2366,19 @@ out_remove:
 }
 
 /**
+ * drain_ioctls() - wait until all currently executing ioctls have completed
+ * @cfg:	Internal structure associated with the host.
+ *
+ * Obtain write access to read/write semaphore that wraps ioctl
+ * handling to 'drain' ioctls currently executing.
+ */
+static void drain_ioctls(struct cxlflash_cfg *cfg)
+{
+	down_write(&cfg->ioctl_rwsem);
+	up_write(&cfg->ioctl_rwsem);
+}
+
+/**
  * cxlflash_pci_error_detected() - called when a PCI error is detected
  * @pdev:	PCI device struct.
  * @state:	PCI channel state.
@@ -2383,16 +2397,14 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 	switch (state) {
 	case pci_channel_io_frozen:
 		cfg->state = STATE_LIMBO;
-
-		/* Turn off legacy I/O */
 		scsi_block_requests(cfg->host);
+		drain_ioctls(cfg);
 		rc = cxlflash_mark_contexts_error(cfg);
 		if (unlikely(rc))
 			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
 				__func__, rc);
 		term_mc(cfg, UNDO_START);
 		stop_afu(cfg);
-
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		cfg->state = STATE_FAILTERM;
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index cf2a85d..8a18230 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1214,6 +1214,48 @@ static const struct file_operations null_fops = {
 };
 
 /**
+ * check_state() - checks and responds to the current adapter state
+ * @cfg:	Internal structure associated with the host.
+ * @ioctl:	Indicates if on an ioctl thread.
+ *
+ * This routine can block and should only be used on process context.
+ * When blocking on an ioctl thread, the ioctl read semaphore should be
+ * let up to allow for draining actively running ioctls. Also note that
+ * when waking up from waiting in reset, the state is unknown and must
+ * be checked again before proceeding.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int check_state(struct cxlflash_cfg *cfg, bool ioctl)
+{
+	struct device *dev = &cfg->dev->dev;
+	int rc = 0;
+
+retry:
+	switch (cfg->state) {
+	case STATE_LIMBO:
+		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
+		if (ioctl)
+			up_read(&cfg->ioctl_rwsem);
+		rc = wait_event_interruptible(cfg->limbo_waitq,
+					      cfg->state != STATE_LIMBO);
+		if (ioctl)
+			down_read(&cfg->ioctl_rwsem);
+		if (unlikely(rc))
+			break;
+		goto retry;
+	case STATE_FAILTERM:
+		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
+		rc = -ENODEV;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+/**
  * cxlflash_disk_attach() - attach a LUN to a context
  * @sdev:	SCSI device associated with LUN.
  * @attach:	Attach ioctl data structure.
@@ -1524,41 +1566,6 @@ err1:
 }
 
 /**
- * check_state() - checks and responds to the current adapter state
- * @cfg:	Internal structure associated with the host.
- *
- * This routine can block and should only be used on process context.
- * Note that when waking up from waiting in limbo, the state is unknown
- * and must be checked again before proceeding.
- *
- * Return: 0 on success, -errno on failure
- */
-static int check_state(struct cxlflash_cfg *cfg)
-{
-	struct device *dev = &cfg->dev->dev;
-	int rc = 0;
-
-retry:
-	switch (cfg->state) {
-	case STATE_LIMBO:
-		dev_dbg(dev, "%s: Limbo, going to wait...\n", __func__);
-		rc = wait_event_interruptible(cfg->limbo_waitq,
-					      cfg->state != STATE_LIMBO);
-		if (unlikely(rc))
-			break;
-		goto retry;
-	case STATE_FAILTERM:
-		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
-		rc = -ENODEV;
-		break;
-	default:
-		break;
-	}
-
-	return rc;
-}
-
-/**
  * cxlflash_afu_recover() - initiates AFU recovery
  * @sdev:	SCSI device associated with LUN.
  * @recover:	Recover ioctl data structure.
@@ -1647,12 +1654,17 @@ retry_recover:
 	/* Test if in error state */
 	reg = readq_be(&afu->ctrl_map->mbox_r);
 	if (reg == -1) {
-		dev_dbg(dev, "%s: MMIO read fail! Wait for recovery...\n",
-			__func__);
-		mutex_unlock(&ctxi->mutex);
+		dev_dbg(dev, "%s: MMIO fail, wait for recovery.\n", __func__);
+
+		/*
+		 * Before checking the state, put back the context obtained with
+		 * get_context() as it is no longer needed and sleep for a short
+		 * period of time (see prolog notes).
+		 */
+		put_context(ctxi);
 		ctxi = NULL;
 		ssleep(1);
-		rc = check_state(cfg);
+		rc = check_state(cfg, true);
 		if (unlikely(rc))
 			goto out;
 		goto retry;
@@ -1946,7 +1958,7 @@ static int ioctl_common(struct scsi_device *sdev, int cmd)
 		goto out;
 	}
 
-	rc = check_state(cfg);
+	rc = check_state(cfg, true);
 	if (unlikely(rc) && (cfg->state == STATE_FAILTERM)) {
 		switch (cmd) {
 		case DK_CXLFLASH_VLUN_RESIZE:
@@ -1968,6 +1980,14 @@ out:
  * @cmd:	IOCTL command.
  * @arg:	Userspace ioctl data structure.
  *
+ * A read/write semaphore is used to implement a 'drain' of currently
+ * running ioctls. The read semaphore is taken at the beginning of each
+ * ioctl thread and released upon concluding execution. Additionally the
+ * semaphore should be released and then reacquired in any ioctl execution
+ * path which will wait for an event to occur that is outside the scope of
+ * the ioctl (i.e. an adapter reset). To drain the ioctls currently running,
+ * a thread simply needs to acquire the write semaphore.
+ *
  * Return: 0 on success, -errno on failure
  */
 int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
@@ -2002,6 +2022,9 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	{sizeof(struct dk_cxlflash_clone), (sioctl)cxlflash_disk_clone},
 	};
 
+	/* Hold read semaphore so we can drain if needed */
+	down_read(&cfg->ioctl_rwsem);
+
 	/* Restrict command set to physical support only for internal LUN */
 	if (afu->internal_lun)
 		switch (cmd) {
@@ -2083,6 +2106,7 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	/* fall through to exit */
 
 cxlflash_ioctl_exit:
+	up_read(&cfg->ioctl_rwsem);
 	if (unlikely(rc && known_ioctl))
 		dev_err(dev, "%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
 			"returned rc %d\n", __func__,
-- 
2.1.0

