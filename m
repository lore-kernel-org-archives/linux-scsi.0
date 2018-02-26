From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 27/38] cxlflash: Support adapter context polling
Date: Mon, 26 Feb 2018 16:23:43 -0600
Message-ID: <1519683823-17727-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The cxlflash userspace API requires that users be able to poll the adapter
context for any pending events or interrupts from the AFU. Support polling
on various events by implementing the AFU poll fop using a waitqueue.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 57 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/cxlflash/ocxl_hw.h |  2 ++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 245cce9..b49136a 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/module.h>
 #include <linux/mount.h>
+#include <linux/poll.h>
 
 #include <misc/ocxl.h>
 
@@ -452,6 +453,7 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 	}
 
 	spin_lock_init(&ctx->slock);
+	init_waitqueue_head(&ctx->wq);
 
 	ctx->pe = rc;
 	ctx->master = false;
@@ -884,10 +886,57 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 	goto out;
 }
 
+/**
+ * ctx_event_pending() - check for any event pending on the context
+ * @ctx:	Context to be checked.
+ *
+ * Return: true if there is an event pending, false if none pending
+ */
+static inline bool ctx_event_pending(struct ocxlflash_context *ctx)
+{
+	if (ctx->pending_irq)
+		return true;
+
+	return false;
+}
+
+/**
+ * afu_poll() - poll the AFU for events on the context
+ * @file:	File associated with the adapter context.
+ * @poll:	Poll structure from the user.
+ *
+ * Return: poll mask
+ */
+static unsigned int afu_poll(struct file *file, struct poll_table_struct *poll)
+{
+	struct ocxlflash_context *ctx = file->private_data;
+	struct device *dev = ctx->hw_afu->dev;
+	ulong lock_flags;
+	int mask = 0;
+
+	poll_wait(file, &ctx->wq, poll);
+
+	spin_lock_irqsave(&ctx->slock, lock_flags);
+	if (ctx_event_pending(ctx))
+		mask |= POLLIN | POLLRDNORM;
+	else
+		mask |= POLLERR;
+	spin_unlock_irqrestore(&ctx->slock, lock_flags);
+
+	dev_dbg(dev, "%s: Poll wait completed for pe %i mask %i\n",
+		__func__, ctx->pe, mask);
+
+	return mask;
+}
+
 static const struct file_operations ocxl_afu_fops = {
 	.owner		= THIS_MODULE,
+	.poll		= afu_poll,
 };
 
+#define PATCH_FOPS(NAME)						\
+	do { if (!fops->NAME) fops->NAME = ocxl_afu_fops.NAME; } while (0)
+
 /**
  * ocxlflash_get_fd() - get file descriptor for an adapter context
  * @ctx_cookie:	Adapter context.
@@ -925,8 +974,10 @@ static struct file *ocxlflash_get_fd(void *ctx_cookie,
 	}
 	fdtmp = rc;
 
-	/* Use default ops if there is no fops */
-	if (!fops)
+	/* Patch the file ops that are not defined */
+	if (fops) {
+		PATCH_FOPS(poll);
+	} else /* Use default ops */
 		fops = (struct file_operations *)&ocxl_afu_fops;
 
 	name = kasprintf(GFP_KERNEL, "ocxlflash:%d", ctx->pe);
@@ -990,6 +1041,8 @@ static irqreturn_t ocxlflash_afu_irq(int irq, void *data)
 	set_bit(i - 1, &ctx->irq_bitmap);
 	ctx->pending_irq = true;
 	spin_unlock(&ctx->slock);
+
+	wake_up_all(&ctx->wq);
 out:
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 12c71aa..d0eac35 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -55,6 +55,8 @@ struct ocxlflash_context {
 	u64 psn_size;			/* Process mapping size */
 
 	spinlock_t slock;		/* Protects irq/fault/event updates */
+	wait_queue_head_t wq;		/* Wait queue for poll and interrupts */
+
 	struct ocxlflash_irqs *irqs;	/* Pointer to array of structures */
 	int num_irqs;			/* Number of interrupts */
 	bool pending_irq;		/* Pending interrupt on the context */
-- 
2.1.0
