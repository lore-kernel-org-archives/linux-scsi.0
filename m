From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 03/38] cxlflash: Add argument identifier names
Date: Thu, 22 Feb 2018 16:22:28 -0600
Message-ID: <1519338148-51892-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Checkpatch throws a warning when the argument identifier names are not
included in the function definitions.

To avoid these warnings, argument identifiers are added in the existing
function definitions.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/backend.h | 47 ++++++++++++++++++++++-------------------
 drivers/scsi/cxlflash/common.h  |  4 ++--
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/cxlflash/backend.h b/drivers/scsi/cxlflash/backend.h
index 339e42b..7b72149 100644
--- a/drivers/scsi/cxlflash/backend.h
+++ b/drivers/scsi/cxlflash/backend.h
@@ -16,26 +16,29 @@ extern const struct cxlflash_backend_ops cxlflash_cxl_ops;
 
 struct cxlflash_backend_ops {
 	struct module *module;
-	void __iomem * (*psa_map)(void *);
-	void (*psa_unmap)(void __iomem *);
-	int (*process_element)(void *);
-	int (*map_afu_irq)(void *, int, irq_handler_t, void *, char *);
-	void (*unmap_afu_irq)(void *, int, void *);
-	int (*start_context)(void *);
-	int (*stop_context)(void *);
-	int (*afu_reset)(void *);
-	void (*set_master)(void *);
-	void * (*get_context)(struct pci_dev *, void *);
-	void * (*dev_context_init)(struct pci_dev *, void *);
-	int (*release_context)(void *);
-	void (*perst_reloads_same_image)(void *, bool);
-	ssize_t (*read_adapter_vpd)(struct pci_dev *, void *, size_t);
-	int (*allocate_afu_irqs)(void *, int);
-	void (*free_afu_irqs)(void *);
-	void * (*create_afu)(struct pci_dev *);
-	struct file * (*get_fd)(void *, struct file_operations *, int *);
-	void * (*fops_get_context)(struct file *);
-	int (*start_work)(void *, u64);
-	int (*fd_mmap)(struct file *, struct vm_area_struct *);
-	int (*fd_release)(struct inode *, struct file *);
+	void __iomem * (*psa_map)(void *ctx_cookie);
+	void (*psa_unmap)(void __iomem *addr);
+	int (*process_element)(void *ctx_cookie);
+	int (*map_afu_irq)(void *ctx_cookie, int num, irq_handler_t handler,
+			   void *cookie, char *name);
+	void (*unmap_afu_irq)(void *ctx_cookie, int num, void *cookie);
+	int (*start_context)(void *ctx_cookie);
+	int (*stop_context)(void *ctx_cookie);
+	int (*afu_reset)(void *ctx_cookie);
+	void (*set_master)(void *ctx_cookie);
+	void * (*get_context)(struct pci_dev *dev, void *afu_cookie);
+	void * (*dev_context_init)(struct pci_dev *dev, void *afu_cookie);
+	int (*release_context)(void *ctx_cookie);
+	void (*perst_reloads_same_image)(void *afu_cookie, bool image);
+	ssize_t (*read_adapter_vpd)(struct pci_dev *dev, void *buf,
+				    size_t count);
+	int (*allocate_afu_irqs)(void *ctx_cookie, int num);
+	void (*free_afu_irqs)(void *ctx_cookie);
+	void * (*create_afu)(struct pci_dev *dev);
+	struct file * (*get_fd)(void *ctx_cookie, struct file_operations *fops,
+				int *fd);
+	void * (*fops_get_context)(struct file *file);
+	int (*start_work)(void *ctx_cookie, u64 irqs);
+	int (*fd_mmap)(struct file *file, struct vm_area_struct *vm);
+	int (*fd_release)(struct inode *inode, struct file *file);
 };
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 5d7ca01..d7fccea 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -232,8 +232,8 @@ struct hwq {
 
 struct afu {
 	struct hwq hwqs[CXLFLASH_MAX_HWQS];
-	int (*send_cmd)(struct afu *, struct afu_cmd *);
-	int (*context_reset)(struct hwq *);
+	int (*send_cmd)(struct afu *afu, struct afu_cmd *cmd);
+	int (*context_reset)(struct hwq *hwq);
 
 	/* AFU HW */
 	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
-- 
2.1.0
