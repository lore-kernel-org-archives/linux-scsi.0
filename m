From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 35/38] cxlflash: Introduce OCXL context state machine
Date: Mon, 26 Feb 2018 16:24:42 -0600
Message-ID: <1519683882-18016-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

In order to protect the OCXL hardware contexts from getting clobbered,
a simple state machine is added to indicate when a context is in open,
close or start state. The expected states are validated throughout the
code to prevent illegal operations on a context. A mutex is added to
protect writes to the context state field.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 59 ++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/cxlflash/ocxl_hw.h |  8 ++++++
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 0e21f79..d707e4c 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -163,6 +163,16 @@ static struct file *ocxlflash_getfile(struct device *dev, const char *name,
 static void __iomem *ocxlflash_psa_map(void *ctx_cookie)
 {
 	struct ocxlflash_context *ctx = ctx_cookie;
+	struct device *dev = ctx->hw_afu->dev;
+
+	mutex_lock(&ctx->state_mutex);
+	if (ctx->state != STARTED) {
+		dev_err(dev, "%s: Context not started, state=%d\n", __func__,
+			ctx->state);
+		mutex_unlock(&ctx->state_mutex);
+		return NULL;
+	}
+	mutex_unlock(&ctx->state_mutex);
 
 	return ioremap(ctx->psn_phys, ctx->psn_size);
 }
@@ -343,6 +353,14 @@ static int start_context(struct ocxlflash_context *ctx)
 	int rc = 0;
 	u32 pid;
 
+	mutex_lock(&ctx->state_mutex);
+	if (ctx->state != OPENED) {
+		dev_err(dev, "%s: Context state invalid, state=%d\n",
+			__func__, ctx->state);
+		rc = -EINVAL;
+		goto out;
+	}
+
 	if (master) {
 		ctx->psn_size = acfg->global_mmio_size;
 		ctx->psn_phys = afu->gmmio_phys;
@@ -366,7 +384,10 @@ static int start_context(struct ocxlflash_context *ctx)
 			__func__, rc);
 		goto out;
 	}
+
+	ctx->state = STARTED;
 out:
+	mutex_unlock(&ctx->state_mutex);
 	return rc;
 }
 
@@ -396,7 +417,15 @@ static int ocxlflash_stop_context(void *ctx_cookie)
 	struct ocxl_afu_config *acfg = &afu->acfg;
 	struct pci_dev *pdev = afu->pdev;
 	struct device *dev = afu->dev;
-	int rc;
+	enum ocxlflash_ctx_state state;
+	int rc = 0;
+
+	mutex_lock(&ctx->state_mutex);
+	state = ctx->state;
+	ctx->state = CLOSED;
+	mutex_unlock(&ctx->state_mutex);
+	if (state != STARTED)
+		goto out;
 
 	rc = ocxl_config_terminate_pasid(pdev, acfg->dvsec_afu_control_pos,
 					 ctx->pe);
@@ -474,7 +503,9 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 
 	spin_lock_init(&ctx->slock);
 	init_waitqueue_head(&ctx->wq);
+	mutex_init(&ctx->state_mutex);
 
+	ctx->state = OPENED;
 	ctx->pe = rc;
 	ctx->master = false;
 	ctx->mapping = NULL;
@@ -499,11 +530,23 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 static int ocxlflash_release_context(void *ctx_cookie)
 {
 	struct ocxlflash_context *ctx = ctx_cookie;
+	struct device *dev;
 	int rc = 0;
 
 	if (!ctx)
 		goto out;
 
+	dev = ctx->hw_afu->dev;
+	mutex_lock(&ctx->state_mutex);
+	if (ctx->state >= STARTED) {
+		dev_err(dev, "%s: Context in use, state=%d\n", __func__,
+			ctx->state);
+		mutex_unlock(&ctx->state_mutex);
+		rc = -EBUSY;
+		goto out;
+	}
+	mutex_unlock(&ctx->state_mutex);
+
 	idr_remove(&ctx->hw_afu->idr, ctx->pe);
 	ocxlflash_release_mapping(ctx);
 	kfree(ctx);
@@ -939,7 +982,7 @@ static unsigned int afu_poll(struct file *file, struct poll_table_struct *poll)
 	spin_lock_irqsave(&ctx->slock, lock_flags);
 	if (ctx_event_pending(ctx))
 		mask |= POLLIN | POLLRDNORM;
-	else
+	else if (ctx->state == CLOSED)
 		mask |= POLLERR;
 	spin_unlock_irqrestore(&ctx->slock, lock_flags);
 
@@ -982,7 +1025,7 @@ static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
 	for (;;) {
 		prepare_to_wait(&ctx->wq, &event_wait, TASK_INTERRUPTIBLE);
 
-		if (ctx_event_pending(ctx))
+		if (ctx_event_pending(ctx) || (ctx->state == CLOSED))
 			break;
 
 		if (file->f_flags & O_NONBLOCK) {
@@ -1068,12 +1111,22 @@ static int ocxlflash_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct ocxlflash_context *ctx = vma->vm_file->private_data;
+	struct device *dev = ctx->hw_afu->dev;
 	u64 mmio_area, offset;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= ctx->psn_size)
 		return VM_FAULT_SIGBUS;
 
+	mutex_lock(&ctx->state_mutex);
+	if (ctx->state != STARTED) {
+		dev_err(dev, "%s: Context not started, state=%d\n",
+			__func__, ctx->state);
+		mutex_unlock(&ctx->state_mutex);
+		return VM_FAULT_SIGBUS;
+	}
+	mutex_unlock(&ctx->state_mutex);
+
 	mmio_area = ctx->psn_phys;
 	mmio_area += offset;
 
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index d0eac35..a4f3b90 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -45,6 +45,12 @@ struct ocxl_hw_afu {
 	int max_pasid;			/* Maximum number of contexts */
 };
 
+enum ocxlflash_ctx_state {
+	CLOSED,
+	OPENED,
+	STARTED
+};
+
 struct ocxlflash_context {
 	struct ocxl_hw_afu *hw_afu;	/* HW AFU back pointer */
 	struct address_space *mapping;	/* Mapping for pseudo filesystem */
@@ -56,6 +62,8 @@ struct ocxlflash_context {
 
 	spinlock_t slock;		/* Protects irq/fault/event updates */
 	wait_queue_head_t wq;		/* Wait queue for poll and interrupts */
+	struct mutex state_mutex;	/* Mutex to update context state */
+	enum ocxlflash_ctx_state state;	/* Context state */
 
 	struct ocxlflash_irqs *irqs;	/* Pointer to array of structures */
 	int num_irqs;			/* Number of interrupts */
-- 
2.1.0
