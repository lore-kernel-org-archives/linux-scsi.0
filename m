From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 24/38] cxlflash: Support AFU interrupt management
Date: Mon, 26 Feb 2018 16:23:19 -0600
Message-ID: <1519683799-17619-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Add support to allocate and free AFU interrupts using the OCXL provider
services. The trigger page returned upon successful allocation will be
mapped and exposed to the cxlflash core in a future commit.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 104 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  10 ++++
 2 files changed, 114 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index f18d82d..e04dce8 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -385,6 +385,108 @@ static ssize_t ocxlflash_read_adapter_vpd(struct pci_dev *pdev, void *buf,
 }
 
 /**
+ * free_afu_irqs() - internal service to free interrupts
+ * @ctx:	Adapter context.
+ */
+static void free_afu_irqs(struct ocxlflash_context *ctx)
+{
+	struct ocxl_hw_afu *afu = ctx->hw_afu;
+	struct device *dev = afu->dev;
+	int i;
+
+	if (!ctx->irqs) {
+		dev_err(dev, "%s: Interrupts not allocated\n", __func__);
+		return;
+	}
+
+	for (i = ctx->num_irqs; i >= 0; i--)
+		ocxl_link_free_irq(afu->link_token, ctx->irqs[i].hwirq);
+
+	kfree(ctx->irqs);
+	ctx->irqs = NULL;
+}
+
+/**
+ * alloc_afu_irqs() - internal service to allocate interrupts
+ * @ctx:	Context associated with the request.
+ * @num:	Number of interrupts requested.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int alloc_afu_irqs(struct ocxlflash_context *ctx, int num)
+{
+	struct ocxl_hw_afu *afu = ctx->hw_afu;
+	struct device *dev = afu->dev;
+	struct ocxlflash_irqs *irqs;
+	u64 addr;
+	int rc = 0;
+	int hwirq;
+	int i;
+
+	if (ctx->irqs) {
+		dev_err(dev, "%s: Interrupts already allocated\n", __func__);
+		rc = -EEXIST;
+		goto out;
+	}
+
+	if (num > OCXL_MAX_IRQS) {
+		dev_err(dev, "%s: Too many interrupts num=%d\n", __func__, num);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	irqs = kcalloc(num, sizeof(*irqs), GFP_KERNEL);
+	if (unlikely(!irqs)) {
+		dev_err(dev, "%s: Context irqs allocation failed\n", __func__);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < num; i++) {
+		rc = ocxl_link_irq_alloc(afu->link_token, &hwirq, &addr);
+		if (unlikely(rc)) {
+			dev_err(dev, "%s: ocxl_link_irq_alloc failed rc=%d\n",
+				__func__, rc);
+			goto err;
+		}
+
+		irqs[i].hwirq = hwirq;
+		irqs[i].ptrig = addr;
+	}
+
+	ctx->irqs = irqs;
+	ctx->num_irqs = num;
+out:
+	return rc;
+err:
+	for (i = i-1; i >= 0; i--)
+		ocxl_link_free_irq(afu->link_token, irqs[i].hwirq);
+	kfree(irqs);
+	goto out;
+}
+
+/**
+ * ocxlflash_allocate_afu_irqs() - allocates the requested number of interrupts
+ * @ctx_cookie:	Context associated with the request.
+ * @num:	Number of interrupts requested.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_allocate_afu_irqs(void *ctx_cookie, int num)
+{
+	return alloc_afu_irqs(ctx_cookie, num);
+}
+
+/**
+ * ocxlflash_free_afu_irqs() - frees the interrupts of an adapter context
+ * @ctx_cookie:	Adapter context.
+ */
+static void ocxlflash_free_afu_irqs(void *ctx_cookie)
+{
+	free_afu_irqs(ctx_cookie);
+}
+
+/**
  * ocxlflash_unconfig_afu() - unconfigure the AFU
  * @afu: AFU associated with the host.
  */
@@ -742,6 +844,8 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.release_context	= ocxlflash_release_context,
 	.perst_reloads_same_image = ocxlflash_perst_reloads_same_image,
 	.read_adapter_vpd	= ocxlflash_read_adapter_vpd,
+	.allocate_afu_irqs	= ocxlflash_allocate_afu_irqs,
+	.free_afu_irqs		= ocxlflash_free_afu_irqs,
 	.create_afu		= ocxlflash_create_afu,
 	.destroy_afu		= ocxlflash_destroy_afu,
 	.get_fd			= ocxlflash_get_fd,
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 4d43650..500de6b 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -12,6 +12,13 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define OCXL_MAX_IRQS	4	/* Max interrupts per process */
+
+struct ocxlflash_irqs {
+	int hwirq;
+	u64 ptrig;
+};
+
 /* OCXL hardware AFU associated with the host */
 struct ocxl_hw_afu {
 	struct ocxlflash_context *ocxl_ctx; /* Host context */
@@ -44,4 +51,7 @@ struct ocxlflash_context {
 
 	phys_addr_t psn_phys;		/* Process mapping */
 	u64 psn_size;			/* Process mapping size */
+
+	struct ocxlflash_irqs *irqs;	/* Pointer to array of structures */
+	int num_irqs;			/* Number of interrupts */
 };
-- 
2.1.0
