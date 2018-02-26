From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 25/38] cxlflash: Support AFU interrupt mapping and
 registration
Date: Mon, 26 Feb 2018 16:23:27 -0600
Message-ID: <1519683807-17655-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Add support to map and unmap the irq space and manage irq registrations
with the kernel for each allocated AFU interrupt. Also support mapping
the physical trigger page to obtain an effective address that will be
provided to the cxlflash core in a future commit.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 120 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |   2 +
 2 files changed, 122 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index e04dce8..177e329 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -186,6 +186,124 @@ static int ocxlflash_process_element(void *ctx_cookie)
 }
 
 /**
+ * afu_map_irq() - map the interrupt of the adapter context
+ * @flags:	Flags.
+ * @ctx:	Adapter context.
+ * @num:	Per-context AFU interrupt number.
+ * @handler:	Interrupt handler to register.
+ * @cookie:	Interrupt handler private data.
+ * @name:	Name of the interrupt.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int afu_map_irq(u64 flags, struct ocxlflash_context *ctx, int num,
+		       irq_handler_t handler, void *cookie, char *name)
+{
+	struct ocxl_hw_afu *afu = ctx->hw_afu;
+	struct device *dev = afu->dev;
+	struct ocxlflash_irqs *irq;
+	void __iomem *vtrig;
+	u32 virq;
+	int rc = 0;
+
+	if (num < 0 || num >= ctx->num_irqs) {
+		dev_err(dev, "%s: Interrupt %d not allocated\n", __func__, num);
+		rc = -ENOENT;
+		goto out;
+	}
+
+	irq = &ctx->irqs[num];
+	virq = irq_create_mapping(NULL, irq->hwirq);
+	if (unlikely(!virq)) {
+		dev_err(dev, "%s: irq_create_mapping failed\n", __func__);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = request_irq(virq, handler, 0, name, cookie);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: request_irq failed rc=%d\n", __func__, rc);
+		goto err1;
+	}
+
+	vtrig = ioremap(irq->ptrig, PAGE_SIZE);
+	if (unlikely(!vtrig)) {
+		dev_err(dev, "%s: Trigger page mapping failed\n", __func__);
+		rc = -ENOMEM;
+		goto err2;
+	}
+
+	irq->virq = virq;
+	irq->vtrig = vtrig;
+out:
+	return rc;
+err2:
+	free_irq(virq, cookie);
+err1:
+	irq_dispose_mapping(virq);
+	goto out;
+}
+
+/**
+ * ocxlflash_map_afu_irq() - map the interrupt of the adapter context
+ * @ctx_cookie:	Adapter context.
+ * @num:	Per-context AFU interrupt number.
+ * @handler:	Interrupt handler to register.
+ * @cookie:	Interrupt handler private data.
+ * @name:	Name of the interrupt.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_map_afu_irq(void *ctx_cookie, int num,
+				 irq_handler_t handler, void *cookie,
+				 char *name)
+{
+	return afu_map_irq(0, ctx_cookie, num, handler, cookie, name);
+}
+
+/**
+ * afu_unmap_irq() - unmap the interrupt
+ * @flags:	Flags.
+ * @ctx:	Adapter context.
+ * @num:	Per-context AFU interrupt number.
+ * @cookie:	Interrupt handler private data.
+ */
+static void afu_unmap_irq(u64 flags, struct ocxlflash_context *ctx, int num,
+			  void *cookie)
+{
+	struct ocxl_hw_afu *afu = ctx->hw_afu;
+	struct device *dev = afu->dev;
+	struct ocxlflash_irqs *irq;
+
+	if (num < 0 || num >= ctx->num_irqs) {
+		dev_err(dev, "%s: Interrupt %d not allocated\n", __func__, num);
+		return;
+	}
+
+	irq = &ctx->irqs[num];
+	if (irq->vtrig)
+		iounmap(irq->vtrig);
+
+	if (irq_find_mapping(NULL, irq->hwirq)) {
+		free_irq(irq->virq, cookie);
+		irq_dispose_mapping(irq->virq);
+	}
+
+	memset(irq, 0, sizeof(*irq));
+}
+
+/**
+ * ocxlflash_unmap_afu_irq() - unmap the interrupt
+ * @ctx_cookie:	Adapter context.
+ * @num:	Per-context AFU interrupt number.
+ * @cookie:	Interrupt handler private data.
+ */
+static void ocxlflash_unmap_afu_irq(void *ctx_cookie, int num, void *cookie)
+{
+	return afu_unmap_irq(0, ctx_cookie, num, cookie);
+}
+
+/**
  * start_context() - local routine to start a context
  * @ctx:	Adapter context to be started.
  *
@@ -836,6 +954,8 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.psa_map		= ocxlflash_psa_map,
 	.psa_unmap		= ocxlflash_psa_unmap,
 	.process_element	= ocxlflash_process_element,
+	.map_afu_irq		= ocxlflash_map_afu_irq,
+	.unmap_afu_irq		= ocxlflash_unmap_afu_irq,
 	.start_context		= ocxlflash_start_context,
 	.stop_context		= ocxlflash_stop_context,
 	.set_master		= ocxlflash_set_master,
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 500de6b..9e44ff4 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -16,7 +16,9 @@
 
 struct ocxlflash_irqs {
 	int hwirq;
+	u32 virq;
 	u64 ptrig;
+	void __iomem *vtrig;
 };
 
 /* OCXL hardware AFU associated with the host */
-- 
2.1.0
