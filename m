From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 36/38] cxlflash: Register for translation errors
Date: Thu, 22 Feb 2018 16:28:23 -0600
Message-ID: <1519338503-53085-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

While enabling a context on the link, a predefined callback can be
registered with the OCXL provider services to be notified on translation
errors. These errors can in turn be passed back to the user on a read
operation.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 31 +++++++++++++++++++++++++++++--
 drivers/scsi/cxlflash/ocxl_hw.h |  4 ++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 535b21a..dc45ed2 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -335,6 +335,25 @@ static u64 ocxlflash_get_irq_objhndl(void *ctx_cookie, int irq)
 }
 
 /**
+ * ocxlflash_xsl_fault() - callback when translation error is triggered
+ * @data:	Private data provided at callback registration, the context.
+ * @addr:	Address that triggered the error.
+ * @dsisr:	Value of dsisr register.
+ */
+static void ocxlflash_xsl_fault(void *data, u64 addr, u64 dsisr)
+{
+	struct ocxlflash_context *ctx = data;
+
+	spin_lock(&ctx->slock);
+	ctx->fault_addr = addr;
+	ctx->fault_dsisr = dsisr;
+	ctx->pending_fault = true;
+	spin_unlock(&ctx->slock);
+
+	wake_up_all(&ctx->wq);
+}
+
+/**
  * start_context() - local routine to start a context
  * @ctx:	Adapter context to be started.
  *
@@ -378,7 +397,8 @@ static int start_context(struct ocxlflash_context *ctx)
 		mm = current->mm;
 	}
 
-	rc = ocxl_link_add_pe(link_token, ctx->pe, pid, 0, 0, mm, NULL, NULL);
+	rc = ocxl_link_add_pe(link_token, ctx->pe, pid, 0, 0, mm,
+			      ocxlflash_xsl_fault, ctx);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: ocxl_link_add_pe failed rc=%d\n",
 			__func__, rc);
@@ -512,6 +532,7 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 	ctx->hw_afu = afu;
 	ctx->irq_bitmap = 0;
 	ctx->pending_irq = false;
+	ctx->pending_fault = false;
 out:
 	return ctx;
 err2:
@@ -957,7 +978,7 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
  */
 static inline bool ctx_event_pending(struct ocxlflash_context *ctx)
 {
-	if (ctx->pending_irq)
+	if (ctx->pending_irq || ctx->pending_fault)
 		return true;
 
 	return false;
@@ -1062,6 +1083,12 @@ static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
 		event.irq.irq = bit + 1;
 		if (bitmap_empty(&ctx->irq_bitmap, ctx->num_irqs))
 			ctx->pending_irq = false;
+	} else if (ctx->pending_fault) {
+		event.header.size += sizeof(struct cxl_event_data_storage);
+		event.header.type = CXL_EVENT_DATA_STORAGE;
+		event.fault.addr = ctx->fault_addr;
+		event.fault.dsisr = ctx->fault_dsisr;
+		ctx->pending_fault = false;
 	}
 
 	spin_unlock_irqrestore(&ctx->slock, lock_flags);
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index c23b681..c48465a 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -69,4 +69,8 @@ struct ocxlflash_context {
 	int num_irqs;			/* Number of interrupts */
 	bool pending_irq;		/* Pending interrupt on the context */
 	ulong irq_bitmap;		/* Bits indicating pending irq num */
+
+	u64 fault_addr;			/* Address that triggered the fault */
+	u64 fault_dsisr;		/* Value of dsisr register at fault */
+	bool pending_fault;		/* Pending translation fault */
 };
-- 
2.1.0
