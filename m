From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 19/38] cxlflash: Support AFU state toggling
Date: Mon, 26 Feb 2018 16:22:42 -0600
Message-ID: <1519683763-17438-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The AFU should be enabled following a successful configuration and
disabled near the end of the cleanup path.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 67f0252..364e7a5 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -342,12 +342,18 @@ static void ocxlflash_unconfig_afu(struct ocxl_hw_afu *afu)
 static void ocxlflash_destroy_afu(void *afu_cookie)
 {
 	struct ocxl_hw_afu *afu = afu_cookie;
+	int pos;
 
 	if (!afu)
 		return;
 
 	ocxlflash_release_context(afu->ocxl_ctx);
 	idr_destroy(&afu->idr);
+
+	/* Disable the AFU */
+	pos = afu->acfg.dvsec_afu_control_pos;
+	ocxl_config_set_afu_state(afu->pdev, pos, 0);
+
 	ocxlflash_unconfig_afu(afu);
 	kfree(afu);
 }
@@ -492,6 +498,9 @@ static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
 			__func__, rc);
 		goto out;
 	}
+
+	/* Enable the AFU */
+	ocxl_config_set_afu_state(pdev, acfg->dvsec_afu_control_pos, 1);
 out:
 	return rc;
 }
-- 
2.1.0
