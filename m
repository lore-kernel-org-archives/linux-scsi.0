From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 38/41] cxlflash: Enable OCXL operations
Date: Mon, 26 Mar 2018 11:35:21 -0500
Message-ID: <1522082121-58862-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

This commit enables the OCXL operations for the OCXL devices.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 9 +++++++--
 drivers/scsi/cxlflash/main.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 8c55fcd..42a95b7 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3168,7 +3168,8 @@ static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS,
 static struct dev_dependent_vals dev_flash_gt_vals = { CXLFLASH_MAX_SECTORS,
 					CXLFLASH_NOTIFY_SHUTDOWN };
 static struct dev_dependent_vals dev_briard_vals = { CXLFLASH_MAX_SECTORS,
-					CXLFLASH_NOTIFY_SHUTDOWN };
+					(CXLFLASH_NOTIFY_SHUTDOWN |
+					CXLFLASH_OCXL_DEV) };
 
 /*
  * PCI device binding table
@@ -3679,9 +3680,13 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
-	cfg->ops = &cxlflash_cxl_ops;
 	cfg->cxl_fops = cxlflash_cxl_fops;
 
+	if (ddv->flags & CXLFLASH_OCXL_DEV)
+		cfg->ops = &cxlflash_ocxl_ops;
+	else
+		cfg->ops = &cxlflash_cxl_ops;
+
 	/*
 	 * Promoted LUNs move to the top of the LUN table. The rest stay on
 	 * the bottom half. The bottom half grows from the end (index = 255),
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index ba0108a..6f1be62 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -97,6 +97,7 @@ struct dev_dependent_vals {
 	u64 flags;
 #define CXLFLASH_NOTIFY_SHUTDOWN	0x0000000000000001ULL
 #define CXLFLASH_WWPN_VPD_REQUIRED	0x0000000000000002ULL
+#define CXLFLASH_OCXL_DEV		0x0000000000000004ULL
 };
 
 struct asyc_intr_info {
-- 
2.1.0
