From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 08/38] cxlflash: Read host AFU configuration
Date: Mon, 26 Feb 2018 16:21:00 -0600
Message-ID: <1519683660-17039-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The host AFU configuration is read on the initialization path to identify
the features and configuration of the AFU. This data is cached for use in
later configuration steps.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 39cccb7..2325030 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -76,6 +76,33 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 }
 
 /**
+ * ocxlflash_config_afu() - configure the host AFU
+ * @pdev:	PCI device associated with the host.
+ * @afu:	AFU associated with the host.
+ *
+ * Must be called _after_ host function configuration.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
+{
+	struct ocxl_afu_config *acfg = &afu->acfg;
+	struct ocxl_fn_config *fcfg = &afu->fcfg;
+	struct device *dev = &pdev->dev;
+	int rc = 0;
+
+	/* Read AFU config at index 0 */
+	rc = ocxl_config_read_afu(pdev, fcfg, acfg, 0);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: ocxl_config_read_afu failed rc=%d\n",
+			__func__, rc);
+		goto out;
+	}
+out:
+	return rc;
+}
+
+/**
  * ocxlflash_create_afu() - create the AFU for OCXL
  * @pdev:	PCI device associated with the host.
  *
@@ -102,6 +129,13 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
 			__func__, rc);
 		goto err1;
 	}
+
+	rc = ocxlflash_config_afu(pdev, afu);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: AFU configuration failed rc=%d\n",
+			__func__, rc);
+		goto err1;
+	}
 out:
 	return afu;
 err1:
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 190d71a..f6af247 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -18,6 +18,7 @@ struct ocxl_hw_afu {
 	struct device *dev;		/* Generic device */
 
 	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
+	struct ocxl_afu_config acfg;	/* AFU configuration data */
 
 	int fn_actag_base;		/* Function acTag base */
 	int fn_actag_enabled;		/* Function acTag number enabled */
-- 
2.1.0
