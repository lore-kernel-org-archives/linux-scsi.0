From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 08/41] cxlflash: Read host AFU configuration
Date: Mon, 26 Mar 2018 11:31:29 -0500
Message-ID: <1522081889-57746-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The host AFU configuration is read on the initialization path to identify
the features and configuration of the AFU. This data is cached for use in
later configuration steps.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  1 +
 2 files changed, 39 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 7783842..11399cf 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -79,6 +79,37 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
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
+	/* This HW AFU function does not have any AFUs defined */
+	if (!afu->is_present)
+		goto out;
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
@@ -105,6 +136,13 @@ static void *ocxlflash_create_afu(struct pci_dev *pdev)
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
index 55e833cb..c9b2843 100644
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
