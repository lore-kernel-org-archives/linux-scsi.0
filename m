From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 07/41] cxlflash: Setup function acTag range
Date: Mon, 26 Mar 2018 11:31:21 -0500
Message-ID: <1522081881-57709-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The OCXL specification supports distributing acTags amongst different
AFUs and functions on the link. The platform-specific acTag range for the
link is obtained using the OCXL provider services and then assigned to the
host function based on implementation.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 15 +++++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 85c0f84..7783842 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -42,6 +42,7 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 {
 	struct ocxl_fn_config *fcfg = &afu->fcfg;
 	struct device *dev = &pdev->dev;
+	u16 base, enabled, supported;
 	int rc = 0;
 
 	/* Read DVSEC config of the function */
@@ -59,6 +60,20 @@ static int ocxlflash_config_fn(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 			dev_warn(dev, "%s: Unexpected AFU index value %d\n",
 				 __func__, fcfg->max_afu_index);
 	}
+
+	rc = ocxl_config_get_actag_info(pdev, &base, &enabled, &supported);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: ocxl_config_get_actag_info failed rc=%d\n",
+			__func__, rc);
+		goto out;
+	}
+
+	afu->fn_actag_base = base;
+	afu->fn_actag_enabled = enabled;
+
+	ocxl_config_set_actag(pdev, fcfg->dvsec_function_pos, base, enabled);
+	dev_dbg(dev, "%s: Function acTag range base=%u enabled=%u\n",
+		__func__, base, enabled);
 out:
 	return rc;
 }
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index 356a6a3..55e833cb 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -19,5 +19,8 @@ struct ocxl_hw_afu {
 
 	struct ocxl_fn_config fcfg;	/* DVSEC config of the function */
 
+	int fn_actag_base;		/* Function acTag base */
+	int fn_actag_enabled;		/* Function acTag number enabled */
+
 	bool is_present;		/* Function has AFUs defined */
 };
-- 
2.1.0
