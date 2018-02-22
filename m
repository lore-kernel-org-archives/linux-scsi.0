From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 28/38] cxlflash: Support adapter context reading
Date: Thu, 22 Feb 2018 16:27:12 -0600
Message-ID: <1519338432-52796-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The cxlflash userspace API requires that users be able to read the adapter
context for any pending events or interrupts from the AFU. Support reading
various events by implementing the AFU read fop to copy out event data.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 94 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 3297934..e504dd2 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -17,9 +17,12 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/poll.h>
+#include <linux/sched/signal.h>
 
 #include <misc/ocxl.h>
 
+#include <uapi/misc/cxl.h>
+
 #include "backend.h"
 #include "ocxl_hw.h"
 
@@ -929,9 +932,99 @@ static unsigned int afu_poll(struct file *file, struct poll_table_struct *poll)
 	return mask;
 }
 
+/**
+ * afu_read() - perform a read on the context for any event
+ * @file:	File associated with the adapter context.
+ * @buf:	Buffer to receive the data.
+ * @count:	Size of buffer (maximum bytes that can be read).
+ * @off:	Offset.
+ *
+ * Return: size of the data read on success, -errno on failure
+ */
+static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
+			loff_t *off)
+{
+	struct ocxlflash_context *ctx = file->private_data;
+	struct device *dev = ctx->hw_afu->dev;
+	struct cxl_event event;
+	ulong lock_flags;
+	ssize_t esize;
+	ssize_t rc;
+	int bit;
+	DEFINE_WAIT(event_wait);
+
+	if (*off != 0) {
+		dev_err(dev, "%s: Non-zero offset not supported, off=%lld\n",
+			__func__, *off);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	spin_lock_irqsave(&ctx->slock, lock_flags);
+
+	for (;;) {
+		prepare_to_wait(&ctx->wq, &event_wait, TASK_INTERRUPTIBLE);
+
+		if (ctx_event_pending(ctx))
+			break;
+
+		if (file->f_flags & O_NONBLOCK) {
+			dev_err(dev, "%s: File cannot be blocked on I/O\n",
+				__func__);
+			rc = -EAGAIN;
+			goto err;
+		}
+
+		if (signal_pending(current)) {
+			dev_err(dev, "%s: Signal pending on the process\n",
+				__func__);
+			rc = -ERESTARTSYS;
+			goto err;
+		}
+
+		spin_unlock_irqrestore(&ctx->slock, lock_flags);
+		schedule();
+		spin_lock_irqsave(&ctx->slock, lock_flags);
+	}
+
+	finish_wait(&ctx->wq, &event_wait);
+
+	memset(&event, 0, sizeof(event));
+	event.header.process_element = ctx->pe;
+	event.header.size = sizeof(struct cxl_event_header);
+	if (ctx->pending_irq) {
+		esize = sizeof(struct cxl_event_afu_interrupt);
+		event.header.size += esize;
+		event.header.type = CXL_EVENT_AFU_INTERRUPT;
+
+		bit = find_first_bit(&ctx->irq_bitmap, ctx->num_irqs);
+		clear_bit(bit, &ctx->irq_bitmap);
+		event.irq.irq = bit + 1;
+		if (bitmap_empty(&ctx->irq_bitmap, ctx->num_irqs))
+			ctx->pending_irq = false;
+	}
+
+	spin_unlock_irqrestore(&ctx->slock, lock_flags);
+
+	if (copy_to_user(buf, &event, event.header.size)) {
+		dev_err(dev, "%s: copy_to_user failed\n", __func__);
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = event.header.size;
+out:
+	return rc;
+err:
+	finish_wait(&ctx->wq, &event_wait);
+	spin_unlock_irqrestore(&ctx->slock, lock_flags);
+	goto out;
+}
+
 static const struct file_operations ocxl_afu_fops = {
 	.owner		= THIS_MODULE,
 	.poll		= afu_poll,
+	.read		= afu_read,
 };
 
 #define PATCH_FOPS(NAME)						\
@@ -977,6 +1070,7 @@ static struct file *ocxlflash_get_fd(void *ctx_cookie,
 	/* Patch the file ops that are not defined */
 	if (fops) {
 		PATCH_FOPS(poll);
+		PATCH_FOPS(read);
 	} else /* Use default ops */
 		fops = (struct file_operations *)&ocxl_afu_fops;
 
-- 
2.1.0
