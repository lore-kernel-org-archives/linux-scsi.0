From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 15/41] cxlflash: Support image reload policy modification
Date: Mon, 26 Mar 2018 11:32:29 -0500
Message-ID: <1522081949-58006-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

On a PERST, the AFU image can be reloaded or left intact. Provide means to
set this image reload policy.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 13 +++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 21915b7..f26bbb7 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -252,6 +252,18 @@ static int ocxlflash_release_context(void *ctx_cookie)
 }
 
 /**
+ * ocxlflash_perst_reloads_same_image() - sets the image reload policy
+ * @afu_cookie:	Hardware AFU associated with the host.
+ * @image:	Whether to load the same image on PERST.
+ */
+static void ocxlflash_perst_reloads_same_image(void *afu_cookie, bool image)
+{
+	struct ocxl_hw_afu *afu = afu_cookie;
+
+	afu->perst_same_image = image;
+}
+
+/**
  * ocxlflash_destroy_afu() - destroy the AFU structure
  * @afu_cookie:	AFU to be freed.
  */
@@ -501,6 +513,7 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.get_context		= ocxlflash_get_context,
 	.dev_context_init	= ocxlflash_dev_context_init,
 	.release_context	= ocxlflash_release_context,
+	.perst_reloads_same_image = ocxlflash_perst_reloads_same_image,
 	.create_afu		= ocxlflash_create_afu,
 	.destroy_afu		= ocxlflash_destroy_afu,
 	.get_fd			= ocxlflash_get_fd,
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 55db005..b963871 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -17,6 +17,7 @@ struct ocxl_hw_afu {
 	struct ocxlflash_context *ocxl_ctx; /* Host context */
 	struct pci_dev *pdev;		/* PCI device */
 	struct device *dev;		/* Generic device */
+	bool perst_same_image;		/* Same image loaded on perst */
 
 	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
 	struct ocxl_afu_config acfg;	/* AFU configuration data */
-- 
2.1.0
