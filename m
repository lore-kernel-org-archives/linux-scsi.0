From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 06/41] cxlflash: Read host function configuration
Date: Mon, 26 Mar 2018 11:31:09 -0500
Message-ID: <1522081869-57672-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Per the OCXL specification, the underlying host can have multiple AFUs
per function with each function supporting its own configuration. The host
function configuration is read on the initialization path to evaluate the
number of functions present and identify the features and configuration of
the functions present. This data is cached for use in later configuration
steps. Note that for the OCXL hardware supported by the cxlflash driver,
only one AFU per function is expected.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 44 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  4 ++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index e3a0a9b..85c0f84 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -32,6 +32,38 @@ static void ocxlflash_destroy_afu(void *afu_cookie)
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
+	/* Check if function has AFUs defined, only 1 per function supported */
+	if (fcfg->max_afu_index >= 0) {
+		afu->is_present = true;
+		if (fcfg->max_afu_index != 0)
+			dev_warn(dev, "%s: Unexpected AFU index value %d\n",
+				 __func__, fcfg->max_afu_index);
+	}
+out:
+	return rc;
+}
+
+/**
  * ocxlflash_create_afu() - create the AFU for OCXL
  * @pdev:	PCI device associated with the host.
  *
@@ -41,6 +73,7 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ocxl_hw_afu *afu;
+	int rc;
 
 	afu = kzalloc(sizeof(*afu), GFP_KERNEL);
 	if (unlikely(!afu)) {
@@ -50,8 +83,19 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 
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
index c7e5c4d..356a6a3 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -16,4 +16,8 @@
 struct ocxl_hw_afu {
 	struct pci_dev *pdev;		/* PCI device */
 	struct device *dev;		/* Generic device */
+
+	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
+
+	bool is_present;		/* Function has AFUs defined */
 };
-- 
2.1.0
