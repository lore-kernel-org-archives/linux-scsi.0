From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: cxlflash: Change return type for fault handler
Date: Tue, 12 Jun 2018 01:12:04 +0530
Message-ID: <20180611194204.GA18687@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: willy@infradead.org, manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, sabyasachi.linux@gmail.com, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

Use new return type vm_fault_t for fault handler. For
now, this is just documenting that the function returns
a VM_FAULT value rather than an errno. Once all instances
are converted, vm_fault_t will become a distinct type.

Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/cxlflash/superpipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 2fe79df..a4e4c50 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1087,7 +1087,7 @@ static struct page *get_err_page(struct cxlflash_cfg *cfg)
  *
  * Return: 0 on success, VM_FAULT_SIGBUS on failure
  */
-static int cxlflash_mmap_fault(struct vm_fault *vmf)
+static vm_fault_t cxlflash_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct file *file = vma->vm_file;
@@ -1098,7 +1098,7 @@ static int cxlflash_mmap_fault(struct vm_fault *vmf)
 	struct ctx_info *ctxi = NULL;
 	struct page *err_page = NULL;
 	enum ctx_ctrl ctrl = CTX_CTRL_ERR_FALLBACK | CTX_CTRL_FILE;
-	int rc = 0;
+	vm_fault_t rc = 0;
 	int ctxid;
 
 	ctxid = cfg->ops->process_element(ctx);
@@ -1138,7 +1138,7 @@ static int cxlflash_mmap_fault(struct vm_fault *vmf)
 out:
 	if (likely(ctxi))
 		put_context(ctxi);
-	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
+	dev_dbg(dev, "%s: returning rc=%x\n", __func__, rc);
 	return rc;
 
 err:
-- 
1.9.1
