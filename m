From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 30/41] cxlflash: Support file descriptor mapping
Date: Mon, 26 Mar 2018 11:34:27 -0500
Message-ID: <1522082067-58564-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The cxlflash core fop API requires a way to invoke the fault and release
handlers of underlying transports using their native file-based APIs. This
provides the core with the ability to insert selectively itself into the
processing stream of these operations for cleanup. Implement these two
fops to map and release when requested.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 8a9f2f4..4bbc1d1 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -1267,6 +1267,30 @@ static int ocxlflash_start_work(void *ctx_cookie, u64 num_irqs)
 		afu_unmap_irq(0, ctx, i, ctx);
 	free_afu_irqs(ctx);
 	goto out;
+};
+
+/**
+ * ocxlflash_fd_mmap() - mmap handler for adapter file descriptor
+ * @file:	File installed with adapter file descriptor.
+ * @vma:	VM area associated with mapping.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_fd_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return afu_mmap(file, vma);
+}
+
+/**
+ * ocxlflash_fd_release() - release the context associated with the file
+ * @inode:	File inode pointer.
+ * @file:	File associated with the adapter context.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_fd_release(struct inode *inode, struct file *file)
+{
+	return afu_release(inode, file);
 }
 
 /* Backend ops to ocxlflash services */
@@ -1292,4 +1316,6 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.get_fd			= ocxlflash_get_fd,
 	.fops_get_context	= ocxlflash_fops_get_context,
 	.start_work		= ocxlflash_start_work,
+	.fd_mmap		= ocxlflash_fd_mmap,
+	.fd_release		= ocxlflash_fd_release,
 };
-- 
2.1.0
