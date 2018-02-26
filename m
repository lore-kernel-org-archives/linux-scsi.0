From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 20/38] cxlflash: Support reading adapter VPD data
Date: Mon, 26 Feb 2018 16:22:50 -0600
Message-ID: <1519683770-17474-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Use the PCI VPD services to support reading the VPD data of the
underlying adapter.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 364e7a5..a1d58fc 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -324,6 +324,20 @@ static void ocxlflash_perst_reloads_same_image(void *afu_cookie, bool image)
 }
 
 /**
+ * ocxlflash_read_adapter_vpd() - reads the adapter VPD
+ * @pdev:	PCI device associated with the host.
+ * @buf:	Buffer to get the VPD data.
+ * @count:	Size of buffer (maximum bytes that can be read).
+ *
+ * Return: size of VPD on success, -errno on failure
+ */
+static ssize_t ocxlflash_read_adapter_vpd(struct pci_dev *pdev, void *buf,
+					  size_t count)
+{
+	return pci_read_vpd(pdev, 0, count, buf);
+}
+
+/**
  * ocxlflash_unconfig_afu() - unconfigure the AFU
  * @afu: AFU associated with the host.
  */
@@ -650,6 +664,7 @@ const struct cxlflash_backend_ops cxlflash_ocxl_ops = {
 	.dev_context_init	= ocxlflash_dev_context_init,
 	.release_context	= ocxlflash_release_context,
 	.perst_reloads_same_image = ocxlflash_perst_reloads_same_image,
+	.read_adapter_vpd	= ocxlflash_read_adapter_vpd,
 	.create_afu		= ocxlflash_create_afu,
 	.destroy_afu		= ocxlflash_destroy_afu,
 	.get_fd			= ocxlflash_get_fd,
-- 
2.1.0
