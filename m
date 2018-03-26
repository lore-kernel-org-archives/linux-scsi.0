From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 19/41] cxlflash: Support AFU state toggling
Date: Mon, 26 Mar 2018 11:33:05 -0500
Message-ID: <1522081985-58155-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

The AFU should be enabled following a successful configuration and
disabled near the end of the cleanup path.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/ocxl_hw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 73b0b10..3042057 100644
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
@@ -499,6 +505,9 @@ static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
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
