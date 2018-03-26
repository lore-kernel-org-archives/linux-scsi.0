From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 14/41] cxlflash: Support adapter context discovery
Date: Mon, 26 Mar 2018 11:32:20 -0500
Message-ID: <1522081940-57969-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Provide means to obtain the process element of an adapter context as well
as locate an adapter context by file.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 49af059..21915b7 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -151,6 +151,19 @@ static struct file *ocxlflash_getfile(struct device *dev, const char *name,
 }
 
 /**
+ * ocxlflash_process_element() - get process element of the adapter context
+ * @ctx_cookie:	Adapter context associated with the process element.
+ *
+ * Return: process element of the adapter context
+ */
+static int ocxlflash_process_element(void *ctx_cookie)
+{
+	struct ocxlflash_context *ctx = ctx_cookie;
+
+	return ctx->pe;
+}
+
+/**
  * ocxlflash_set_master() - sets the context as master
  * @ctx_cookie:	Adapter context to set as master.
  */
@@ -469,9 +482,21 @@ static struct file *ocxlflash_get_fd(void *ctx_cookie,
 	goto out;
 }
 
+/**
+ * ocxlflash_fops_get_context() - get the context associated with the file
+ * @file:	File associated with the adapter context.
+ *
+ * Return: pointer to the context
+ */
+static void *ocxlflash_fops_get_context(struct file *file)
+{
+	return file->private_data;
+}
+
 /* Backend ops to ocxlflash services */
 const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.module			= THIS_MODULE,
+	.process_element	= ocxlflash_process_element,
 	.set_master		= ocxlflash_set_master,
 	.get_context		= ocxlflash_get_context,
 	.dev_context_init	= ocxlflash_dev_context_init,
@@ -479,4 +504,5 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.create_afu		= ocxlflash_create_afu,
 	.destroy_afu		= ocxlflash_destroy_afu,
 	.get_fd			= ocxlflash_get_fd,
+	.fops_get_context	= ocxlflash_fops_get_context,
 };
-- 
2.1.0
