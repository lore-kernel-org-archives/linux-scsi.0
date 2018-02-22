From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 17/38] cxlflash: Support starting an adapter context
Date: Thu, 22 Feb 2018 16:25:04 -0600
Message-ID: <1519338304-52398-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Once the adapter context is created, it needs to be started by assigning
the MMIO space for the context and by enabling the process element in the
link. This commit adds the skeleton for starting the context and assigns
the context specific MMIO space. Master contexts have access to the global
MMIO space while the rest have access to the context specific space.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  3 +++
 2 files changed, 42 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 824d789..7d92df0 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -164,6 +164,44 @@ static int ocxlflash_process_element(void *ctx_cookie)
 }
 
 /**
+ * start_context() - local routine to start a context
+ * @ctx:	Adapter context to be started.
+ *
+ * Assign the context specific MMIO space.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int start_context(struct ocxlflash_context *ctx)
+{
+	struct ocxl_hw_afu *afu = ctx->hw_afu;
+	struct ocxl_afu_config *acfg = &afu->acfg;
+	bool master = ctx->master;
+
+	if (master) {
+		ctx->psn_size = acfg->global_mmio_size;
+		ctx->psn_phys = afu->gmmio_phys;
+	} else {
+		ctx->psn_size = acfg->pp_mmio_stride;
+		ctx->psn_phys = afu->ppmmio_phys + (ctx->pe * ctx->psn_size);
+	}
+
+	return 0;
+}
+
+/**
+ * ocxlflash_start_context() - start a kernel context
+ * @ctx_cookie:	Adapter context to be started.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_start_context(void *ctx_cookie)
+{
+	struct ocxlflash_context *ctx = ctx_cookie;
+
+	return start_context(ctx);
+}
+
+/**
  * ocxlflash_set_master() - sets the context as master
  * @ctx_cookie:	Adapter context to set as master.
  */
@@ -573,6 +611,7 @@ static void *ocxlflash_fops_get_context(struct file *file)
 const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.module			= THIS_MODULE,
 	.process_element	= ocxlflash_process_element,
+	.start_context		= ocxlflash_start_context,
 	.set_master		= ocxlflash_set_master,
 	.get_context		= ocxlflash_get_context,
 	.dev_context_init	= ocxlflash_dev_context_init,
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index fbe9741..6912dd1 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -40,4 +40,7 @@ struct ocxlflash_context {
 	struct address_space *mapping;	/* Mapping for pseudo filesystem */
 	bool master;			/* Whether this is a master context */
 	int pe;				/* Process element */
+
+	phys_addr_t psn_phys;		/* Process mapping */
+	u64 psn_size;			/* Process mapping size */
 };
-- 
2.1.0
