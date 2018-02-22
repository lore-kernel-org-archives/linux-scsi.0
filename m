From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 26/38] cxlflash: Support starting user contexts
Date: Thu, 22 Feb 2018 16:26:56 -0600
Message-ID: <1519338416-52723-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

User contexts request interrupts and are started using the "start work"
interface. Populate the start_work() fop to allocate and map interrupts
before starting the user context. As part of starting the context, update
the user process identification logic to properly derive the data required
by the SPA. Also, introduce a skeleton interrupt handler using a bitmap,
flag, and spinlock to track interrupts. This handler will be expanded in
future commits.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 99 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/cxlflash/ocxl_hw.h |  3 ++
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 3b28c2a..4ca4a72 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -318,7 +318,9 @@ static int start_context(struct ocxlflash_context *ctx)
 	void *link_token = afu->link_token;
 	struct device *dev = afu->dev;
 	bool master = ctx->master;
+	struct mm_struct *mm;
 	int rc = 0;
+	u32 pid;
 
 	if (master) {
 		ctx->psn_size = acfg->global_mmio_size;
@@ -328,9 +330,16 @@ static int start_context(struct ocxlflash_context *ctx)
 		ctx->psn_phys = afu->ppmmio_phys + (ctx->pe * ctx->psn_size);
 	}
 
+	/* pid and mm not set for master contexts */
+	if (master) {
+		pid = 0;
+		mm = NULL;
+	} else {
+		pid = current->mm->context.id;
+		mm = current->mm;
+	}
 
-	/* pid, tid, amr and mm are zeroes/NULL for a kernel context */
-	rc = ocxl_link_add_pe(link_token, ctx->pe, 0, 0, 0, NULL, NULL, NULL);
+	rc = ocxl_link_add_pe(link_token, ctx->pe, pid, 0, 0, mm, NULL, NULL);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: ocxl_link_add_pe failed rc=%d\n",
 			__func__, rc);
@@ -442,10 +451,14 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 		goto err2;
 	}
 
+	spin_lock_init(&ctx->slock);
+
 	ctx->pe = rc;
 	ctx->master = false;
 	ctx->mapping = NULL;
 	ctx->hw_afu = afu;
+	ctx->irq_bitmap = 0;
+	ctx->pending_irq = false;
 out:
 	return ctx;
 err2:
@@ -948,6 +961,87 @@ static void *ocxlflash_fops_get_context(struct file *file)
 	return file->private_data;
 }
 
+/**
+ * ocxlflash_afu_irq() - interrupt handler for user contexts
+ * @irq:	Interrupt number.
+ * @data:	Private data provided at interrupt registration, the context.
+ *
+ * Return: Always return IRQ_HANDLED.
+ */
+static irqreturn_t ocxlflash_afu_irq(int irq, void *data)
+{
+	struct ocxlflash_context *ctx = data;
+	struct device *dev = ctx->hw_afu->dev;
+	int i;
+
+	dev_dbg(dev, "%s: Interrupt raised for pe %i virq %i\n",
+		__func__, ctx->pe, irq);
+
+	for (i = 0; i < ctx->num_irqs; i++) {
+		if (ctx->irqs[i].virq == irq)
+			break;
+	}
+	if (unlikely(i >= ctx->num_irqs)) {
+		dev_err(dev, "%s: Received AFU IRQ out of range\n", __func__);
+		goto out;
+	}
+
+	spin_lock(&ctx->slock);
+	set_bit(i - 1, &ctx->irq_bitmap);
+	ctx->pending_irq = true;
+	spin_unlock(&ctx->slock);
+out:
+	return IRQ_HANDLED;
+}
+
+/**
+ * ocxlflash_start_work() - start a user context
+ * @ctx_cookie:	Context to be started.
+ * @num_irqs:	Number of interrupts requested.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_start_work(void *ctx_cookie, u64 num_irqs)
+{
+	struct ocxlflash_context *ctx = ctx_cookie;
+	struct ocxl_hw_afu *afu = ctx->hw_afu;
+	struct device *dev = afu->dev;
+	char *name;
+	int rc = 0;
+	int i;
+
+	rc = alloc_afu_irqs(ctx, num_irqs);
+	if (unlikely(rc < 0)) {
+		dev_err(dev, "%s: alloc_afu_irqs failed rc=%d\n", __func__, rc);
+		goto out;
+	}
+
+	for (i = 0; i < num_irqs; i++) {
+		name = kasprintf(GFP_KERNEL, "ocxlflash-%s-pe%i-%i",
+				 dev_name(dev), ctx->pe, i);
+		rc = afu_map_irq(0, ctx, i, ocxlflash_afu_irq, ctx, name);
+		kfree(name);
+		if (unlikely(rc < 0)) {
+			dev_err(dev, "%s: afu_map_irq failed rc=%d\n",
+				__func__, rc);
+			goto err;
+		}
+	}
+
+	rc = start_context(ctx);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: start_context failed rc=%d\n", __func__, rc);
+		goto err;
+	}
+out:
+	return rc;
+err:
+	for (i = i-1; i >= 0; i--)
+		afu_unmap_irq(0, ctx, i, ctx);
+	free_afu_irqs(ctx);
+	goto out;
+}
+
 /* Backend ops to ocxlflash services */
 const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.module			= THIS_MODULE,
@@ -970,4 +1064,5 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.destroy_afu		= ocxlflash_destroy_afu,
 	.get_fd			= ocxlflash_get_fd,
 	.fops_get_context	= ocxlflash_fops_get_context,
+	.start_work		= ocxlflash_start_work,
 };
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 53c2d33..c7cbf67 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -54,6 +54,9 @@ struct ocxlflash_context {
 	phys_addr_t psn_phys;		/* Process mapping */
 	u64 psn_size;			/* Process mapping size */
 
+	spinlock_t slock;		/* Protects irq/fault/event updates */
 	struct ocxlflash_irqs *irqs;	/* Pointer to array of structures */
 	int num_irqs;			/* Number of interrupts */
+	bool pending_irq;		/* Pending interrupt on the context */
+	ulong irq_bitmap;		/* Bits indicating pending irq num */
 };
-- 
2.1.0
