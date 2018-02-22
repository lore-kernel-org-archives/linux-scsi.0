From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 37/38] cxlflash: Support AFU reset
Date: Thu, 22 Feb 2018 16:28:31 -0600
Message-ID: <1519338511-53121-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The cxlflash core driver resets the AFU when the master contexts are
created in the initialization or recovery paths. Today, the OCXL
provider service to perform this operation is pending implementation.
To avoid a crash due to a missing fop, log an error once and return
success to continue with execution.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index dc45ed2..8a1a9fc 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -468,6 +468,22 @@ static int ocxlflash_stop_context(void *ctx_cookie)
 }
 
 /**
+ * ocxlflash_afu_reset() - reset the AFU
+ * @ctx_cookie:	Adapter context.
+ */
+static int ocxlflash_afu_reset(void *ctx_cookie)
+{
+	struct ocxlflash_context *ctx = ctx_cookie;
+	struct device *dev = ctx->hw_afu->dev;
+
+	/* Pending implementation from OCXL transport services */
+	dev_err_once(dev, "%s: afu_reset() fop not supported\n", __func__);
+
+	/* Silently return success until it is implemented */
+	return 0;
+}
+
+/**
  * ocxlflash_set_master() - sets the context as master
  * @ctx_cookie:	Adapter context to set as master.
  */
@@ -1393,6 +1409,7 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.get_irq_objhndl	= ocxlflash_get_irq_objhndl,
 	.start_context		= ocxlflash_start_context,
 	.stop_context		= ocxlflash_stop_context,
+	.afu_reset		= ocxlflash_afu_reset,
 	.set_master		= ocxlflash_set_master,
 	.get_context		= ocxlflash_get_context,
 	.dev_context_init	= ocxlflash_dev_context_init,
-- 
2.1.0
