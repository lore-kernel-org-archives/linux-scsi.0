From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 12/38] cxlflash: Use IDR to manage adapter contexts
Date: Thu, 22 Feb 2018 16:24:18 -0600
Message-ID: <1519338258-52217-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

A range of PASIDs are used as identifiers for the adapter contexts. These
contexts may be destroyed and created randomly. Use an IDR to keep track
of contexts that are in use and assign a unique identifier to new ones.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 20 ++++++++++++++++++--
 drivers/scsi/cxlflash/ocxl_hw.h |  2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index c5f5c81..30db79d 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -12,6 +12,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/idr.h>
+
 #include <misc/ocxl.h>
 
 #include "backend.h"
@@ -60,14 +62,25 @@ static void *ocxlflash_dev_context_init(struct pci_dev *pdev, void *afu_cookie)
 	if (unlikely(!ctx)) {
 		dev_err(dev, "%s: Context allocation failed\n", __func__);
 		rc = -ENOMEM;
-		goto err;
+		goto err1;
+	}
+
+	idr_preload(GFP_KERNEL);
+	rc = idr_alloc(&afu->idr, ctx, 0, afu->max_pasid, GFP_NOWAIT);
+	idr_preload_end();
+	if (unlikely(rc < 0)) {
+		dev_err(dev, "%s: idr_alloc failed rc=%d\n", __func__, rc);
+		goto err2;
 	}
 
+	ctx->pe = rc;
 	ctx->master = false;
 	ctx->hw_afu = afu;
 out:
 	return ctx;
-err:
+err2:
+	kfree(ctx);
+err1:
 	ctx = ERR_PTR(rc);
 	goto out;
 }
@@ -86,6 +99,7 @@ static int ocxlflash_release_context(void *ctx_cookie)
 	if (!ctx)
 		goto out;
 
+	idr_remove(&ctx->hw_afu->idr, ctx->pe);
 	kfree(ctx);
 out:
 	return rc;
@@ -103,6 +117,7 @@ static void ocxlflash_destroy_afu(void *afu_cookie)
 		return;
 
 	ocxlflash_release_context(afu->ocxl_ctx);
+	idr_destroy(&afu->idr);
 	kfree(afu);
 }
 
@@ -237,6 +252,7 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 		goto err1;
 	}
 
+	idr_init(&afu->idr);
 	afu->ocxl_ctx = ctx;
 out:
 	return afu;
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index f78e5c9..49d5d08 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -26,10 +26,12 @@ struct ocxl_hw_afu {
 	int afu_actag_base;		/* AFU acTag base */
 	int afu_actag_enabled;		/* AFU acTag number enabled */
 
+	struct idr idr;			/* IDR to manage contexts */
 	int max_pasid;			/* Maximum number of contexts */
 };
 
 struct ocxlflash_context {
 	struct ocxl_hw_afu *hw_afu;	/* HW AFU back pointer */
 	bool master;			/* Whether this is a master context */
+	int pe;				/* Process element */
 };
-- 
2.1.0
