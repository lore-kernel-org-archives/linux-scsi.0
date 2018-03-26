From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 09/41] cxlflash: Setup AFU acTag range
Date: Mon, 26 Mar 2018 11:31:36 -0500
Message-ID: <1522081896-57783-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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
AFUs and functions on the link. As cxlflash devices are expected to only
support a single AFU per function, the entire range that was assigned to
the function is also assigned to the AFU.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 13 +++++++++++++
 drivers/scsi/cxlflash/ocxl_hw.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 11399cf..105712b 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -92,6 +92,9 @@ static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 	struct ocxl_afu_config *acfg = &afu->acfg;
 	struct ocxl_fn_config *fcfg = &afu->fcfg;
 	struct device *dev = &pdev->dev;
+	int count;
+	int base;
+	int pos;
 	int rc = 0;
 
 	/* This HW AFU function does not have any AFUs defined */
@@ -105,6 +108,16 @@ static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 			__func__, rc);
 		goto out;
 	}
+
+	/* Only one AFU per function is supported, so actag_base is same */
+	base = afu->fn_actag_base;
+	count = min_t(int, acfg->actag_supported, afu->fn_actag_enabled);
+	pos = acfg->dvsec_afu_control_pos;
+
+	ocxl_config_set_afu_actag(pdev, pos, base, count);
+	dev_dbg(dev, "%s: acTag base=%d enabled=%d\n", __func__, base, count);
+	afu->afu_actag_base = base;
+	afu->afu_actag_enabled = count;
 out:
 	return rc;
 }
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index c9b2843..21803b5 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -22,6 +22,8 @@ struct ocxl_hw_afu {
 
 	int fn_actag_base;		/* Function acTag base */
 	int fn_actag_enabled;		/* Function acTag number enabled */
+	int afu_actag_base;		/* AFU acTag base */
+	int afu_actag_enabled;		/* AFU acTag number enabled */
 
 	bool is_present;		/* Function has AFUs defined */
 };
-- 
2.1.0
