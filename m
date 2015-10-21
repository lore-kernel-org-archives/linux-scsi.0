From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 08/37] cxlflash: Fix to avoid CXL services during EEH
Date: Wed, 21 Oct 2015 15:11:52 -0500
Message-ID: <1445458312-60946-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:33200 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbbJUUNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:13:16 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:13:15 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 9682D1FF0041
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:01:24 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKDCRv7143742
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:13:12 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKDAs4021853
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:13:12 -0600
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

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
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/common.h    |  2 +
 drivers/scsi/cxlflash/main.c      | 18 +++++--
 drivers/scsi/cxlflash/superpipe.c | 98 ++++++++++++++++++++++++---------------
 3 files changed, 77 insertions(+), 41 deletions(-)

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
index 28aa9d9..655cbf1 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1214,6 +1214,46 @@ static const struct file_operations null_fops = {
 };
 
 /**
+ * check_state() - checks and responds to the current adapter state
+ * @cfg:	Internal structure associated with the host.
+ *
+ * This routine can block and should only be used on process context.
+ * It assumes that the caller is an ioctl thread and holding the ioctl
+ * read semaphore. This is temporarily let up across the wait to allow
+ * for draining actively running ioctls. Also note that when waking up
+ * from waiting in reset, the state is unknown and must be checked again
+ * before proceeding.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int check_state(struct cxlflash_cfg *cfg)
+{
+	struct device *dev = &cfg->dev->dev;
+	int rc = 0;
+
+retry:
+	switch (cfg->state) {
+	case STATE_LIMBO:
+		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
+		up_read(&cfg->ioctl_rwsem);
+		rc = wait_event_interruptible(cfg->limbo_waitq,
+					      cfg->state != STATE_LIMBO);
+		down_read(&cfg->ioctl_rwsem);
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
@@ -1523,41 +1563,6 @@ err1:
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
@@ -1646,9 +1651,14 @@ retry_recover:
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
 		rc = check_state(cfg);
@@ -1967,6 +1977,14 @@ out:
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
@@ -2001,6 +2019,9 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	{sizeof(struct dk_cxlflash_clone), (sioctl)cxlflash_disk_clone},
 	};
 
+	/* Hold read semaphore so we can drain if needed */
+	down_read(&cfg->ioctl_rwsem);
+
 	/* Restrict command set to physical support only for internal LUN */
 	if (afu->internal_lun)
 		switch (cmd) {
@@ -2082,6 +2103,7 @@ int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	/* fall through to exit */
 
 cxlflash_ioctl_exit:
+	up_read(&cfg->ioctl_rwsem);
 	if (unlikely(rc && known_ioctl))
 		dev_err(dev, "%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
 			"returned rc %d\n", __func__,
-- 
2.1.0

