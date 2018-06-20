From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH v2] scsi: cxlflash: Change return type for fault handler
Date: Wed, 20 Jun 2018 23:55:07 +0530
Message-ID: <20180620182507.GA21775@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: willy@infradead.org, manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use new return type vm_fault_t for fault handler. For
now, this is just documenting that the function returns
a VM_FAULT value rather than an errno. Once all instances
are converted, vm_fault_t will become a distinct type.

Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")

Previously, VM_FAULT_NOPAGE was returned without verifying
return value of vm_insert_pfn. The new inline vmf_insert_pfn()
will address this issue by returning correct VM_FAULT_* type
from fault handler.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---

v2: Updated the change log and ocxlflash_mmap_fault()
    return type is changed to vm_fault_t

 drivers/scsi/cxlflash/ocxl_hw.c   | 5 ++---
 drivers/scsi/cxlflash/superpipe.c | 6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 0a95b5f..91178ff 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -1158,7 +1158,7 @@ static int afu_release(struct inode *inode, struct file *file)
  *
  * Return: 0 on success, -errno on failure
  */
-static int ocxlflash_mmap_fault(struct vm_fault *vmf)
+static vm_fault_t ocxlflash_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct ocxlflash_context *ctx = vma->vm_file->private_data;
@@ -1181,8 +1181,7 @@ static int ocxlflash_mmap_fault(struct vm_fault *vmf)
 	mmio_area = ctx->psn_phys;
 	mmio_area += offset;
 
-	vm_insert_pfn(vma, vmf->address, mmio_area >> PAGE_SHIFT);
-	return VM_FAULT_NOPAGE;
+	return vmf_insert_pfn(vma, vmf->address, mmio_area >> PAGE_SHIFT);
 }
 
 static const struct vm_operations_struct ocxlflash_vmops = {
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index e489d89..eee193e 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1108,7 +1108,7 @@ static struct page *get_err_page(struct cxlflash_cfg *cfg)
  *
  * Return: 0 on success, VM_FAULT_SIGBUS on failure
  */
-static int cxlflash_mmap_fault(struct vm_fault *vmf)
+static vm_fault_t cxlflash_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct file *file = vma->vm_file;
@@ -1119,7 +1119,7 @@ static int cxlflash_mmap_fault(struct vm_fault *vmf)
 	struct ctx_info *ctxi = NULL;
 	struct page *err_page = NULL;
 	enum ctx_ctrl ctrl = CTX_CTRL_ERR_FALLBACK | CTX_CTRL_FILE;
-	int rc = 0;
+	vm_fault_t rc = 0;
 	int ctxid;
 
 	ctxid = cfg->ops->process_element(ctx);
@@ -1159,7 +1159,7 @@ static int cxlflash_mmap_fault(struct vm_fault *vmf)
 out:
 	if (likely(ctxi))
 		put_context(ctxi);
-	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
+	dev_dbg(dev, "%s: returning rc=%x\n", __func__, rc);
 	return rc;
 
 err:
-- 
1.9.1
