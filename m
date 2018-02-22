From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 10/38] cxlflash: Setup AFU PASID
Date: Thu, 22 Feb 2018 16:24:00 -0600
Message-ID: <1519338240-52145-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

Per the OpenCXL specification, the maximum PASID supported by the AFU is
indicated by a field within the configuration space. Similar to acTags,
implementations can choose to use any sub-range of PASID within their
assigned range. For cxlflash, the entire range is used.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 3 +++
 drivers/scsi/cxlflash/ocxl_hw.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 3875ed4..677bc34 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -111,6 +111,9 @@ static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 	dev_dbg(dev, "%s: acTag base=%d enabled=%d\n", __func__, base, count);
 	afu->afu_actag_base = base;
 	afu->afu_actag_enabled = count;
+	afu->max_pasid = 1 << acfg->pasid_supported_log;
+
+	ocxl_config_set_afu_pasid(pdev, pos, 0, acfg->pasid_supported_log);
 out:
 	return rc;
 }
diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
index a0ef04c..a807656 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.h
+++ b/drivers/scsi/cxlflash/ocxl_hw.h
@@ -24,4 +24,6 @@ struct ocxl_hw_afu {
 	int fn_actag_enabled;		/* Function acTag number enabled */
 	int afu_actag_base;		/* AFU acTag base */
 	int afu_actag_enabled;		/* AFU acTag number enabled */
+
+	int max_pasid;			/* Maximum number of contexts */
 };
-- 
2.1.0
