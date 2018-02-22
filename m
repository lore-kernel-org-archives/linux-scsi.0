From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 06/38] cxlflash: Read host function configuration
Date: Thu, 22 Feb 2018 16:23:21 -0600
Message-ID: <1519338201-52001-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Per the OpenCXL specification, the underlying host can have multiple AFUs
per function with each function supporting its own configuration. The host
function configuration is read on the initialization path to evaluate the
number of functions present and identify the features and configuration of
the functions present. This data is cached for use in later configuration
steps. Note that for the OCXL hardware supported by the cxlflash driver,
only one AFU per function is expected.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 667cf77..a349ec6 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -32,6 +32,35 @@ static void ocxlflash_destroy_afu(void *afu_cookie)
 }
 
 /**
+ * ocxlflash_config_fn() - configure the host function
+ * @pdev:	PCI device associated with the host.
+ * @afu:	AFU associated with the host.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
+{
+	struct ocxl_fn_config *fcfg = &afu->fcfg;
+	struct device *dev = &pdev->dev;
+	int rc = 0;
+
+	/* Read DVSEC config of the function */
+	rc = ocxl_config_read_function(pdev, fcfg);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: ocxl_config_read_function failed rc=%d\n",
+			__func__, rc);
+		goto out;
+	}
+
+	/* Only one AFU per function is supported by ocxlflash */
+	if (fcfg->max_afu_index != 0)
+		dev_warn(dev, "%s: Unexpected AFU index value %d\n",
+			 __func__, fcfg->max_afu_index);
+out:
+	return rc;
+}
+
+/**
  * ocxlflash_create_afu() - create the AFU for OpenCXL
  * @pdev:	PCI device associated with the host.
  *
@@ -41,6 +70,7 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ocxl_hw_afu *afu;
+	int rc;
 
 	afu = kzalloc(sizeof(*afu), GFP_KERNEL);
 	if (unlikely(!afu)) {
@@ -50,8 +80,19 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 
 	afu->pdev = pdev;
 	afu->dev = dev;
+
+	rc = ocxlflash_config_fn(pdev, afu);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: Function configuration failed rc=%d\n",
+			__func__, rc);
+		goto err1;
+	}
 out:
 	return afu;
+err1:
+	kfree(afu);
+	afu = NULL;
+	goto out;
 }
 
 /* Backend ops to ocxlflash services */
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 57eb53b..9c1b5347 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -16,4 +16,6 @@
 struct ocxl_hw_afu {
 	struct pci_dev *pdev;		/* PCI device */
 	struct device *dev;		/* Generic device */
+
+	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
 };
-- 
2.1.0
