From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 29/38] cxlflash: Support adapter context mmap and release
Date: Thu, 22 Feb 2018 16:27:19 -0600
Message-ID: <1519338439-52832-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The cxlflash userspace API requires that users be able to mmap and release
the adapter context. Support mapping by implementing the AFU mmap fop to
map the context MMIO space and install the corresponding page table entry
upon page fault. Similarly, implement the AFU release fop to terminate and
clean up the context when invoked.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index e504dd2..f090563 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -1021,10 +1021,80 @@ static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
 	goto out;
 }
 
+/**
+ * afu_release() - release and free the context
+ * @inode:	File inode pointer.
+ * @file:	File associated with the context.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int afu_release(struct inode *inode, struct file *file)
+{
+	struct ocxlflash_context *ctx = file->private_data;
+	int i;
+
+	/* Unmap and free the interrupts associated with the context */
+	for (i = ctx->num_irqs; i >= 0; i--)
+		afu_unmap_irq(0, ctx, i, ctx);
+	free_afu_irqs(ctx);
+
+	return ocxlflash_release_context(ctx);
+}
+
+/**
+ * ocxlflash_mmap_fault() - mmap fault handler
+ * @vmf:	VM fault associated with current fault.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_mmap_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct ocxlflash_context *ctx = vma->vm_file->private_data;
+	u64 mmio_area, offset;
+
+	offset = vmf->pgoff << PAGE_SHIFT;
+	if (offset >= ctx->psn_size)
+		return VM_FAULT_SIGBUS;
+
+	mmio_area = ctx->psn_phys;
+	mmio_area += offset;
+
+	vm_insert_pfn(vma, vmf->address, mmio_area >> PAGE_SHIFT);
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct ocxlflash_vmops = {
+	.fault = ocxlflash_mmap_fault,
+};
+
+/**
+ * afu_mmap() - map the fault handler operations
+ * @file:	File associated with the context.
+ * @vma:	VM area associated with mapping.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int afu_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct ocxlflash_context *ctx = file->private_data;
+
+	if ((vma_pages(vma) + vma->vm_pgoff) >
+	    (ctx->psn_size >> PAGE_SHIFT))
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_PFNMAP;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_ops = &ocxlflash_vmops;
+	return 0;
+}
+
 static const struct file_operations ocxl_afu_fops = {
 	.owner		= THIS_MODULE,
 	.poll		= afu_poll,
 	.read		= afu_read,
+	.release	= afu_release,
+	.mmap		= afu_mmap,
 };
 
 #define PATCH_FOPS(NAME)						\
@@ -1071,6 +1141,8 @@ static struct file *ocxlflash_get_fd(void *ctx_cookie,
 	if (fops) {
 		PATCH_FOPS(poll);
 		PATCH_FOPS(read);
+		PATCH_FOPS(release);
+		PATCH_FOPS(mmap);
 	} else /* Use default ops */
 		fops = (struct file_operations *)&ocxl_afu_fops;
 
-- 
2.1.0
