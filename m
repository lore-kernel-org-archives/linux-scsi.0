From: Eugene Teo <eugeneteo@kernel.sg>
Subject: [PATCH] drivers/scsi/ips.c: fix scsi_add_host warning
Date: Wed, 8 Aug 2007 12:58:49 +0800
Message-ID: <20070808045849.GA8529@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935360AbXHHE7J@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch fixes the following warning:

drivers/scsi/ips.c: In function 'ips_register_scsi':
drivers/scsi/ips.c:6867: warning: ignoring return value of
	'scsi_add_host', declared with attribute warn_unused_result

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/scsi/ips.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 492a51b..b04c42f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -6824,13 +6824,14 @@ ips_order_controllers(void)
 static int
 ips_register_scsi(int index)
 {
+	int rc = -1;
 	struct Scsi_Host *sh;
 	ips_ha_t *ha, *oldha = ips_ha[index];
 	sh = scsi_host_alloc(&ips_driver_template, sizeof (ips_ha_t));
 	if (!sh) {
 		IPS_PRINTK(KERN_WARNING, oldha->pcidev,
 			   "Unable to register controller with SCSI subsystem\n");
-		return -1;
+		return rc;
 	}
 	ha = IPS_HA(sh);
 	memcpy(ha, oldha, sizeof (ips_ha_t));
@@ -6839,8 +6840,7 @@ ips_register_scsi(int index)
 	if (request_irq(ha->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
-		scsi_host_put(sh);
-		return -1;
+		goto err_put_sh;
 	}
 
 	kfree(oldha);
@@ -6864,10 +6864,18 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	rc = scsi_add_host(sh, NULL);
+	if (rc)
+		goto err_free_irq;
 	scsi_scan_host(sh);
 
 	return 0;
+
+err_free_irq:
+	free_irq(ha->irq);
+err_put_sh:
+	scsi_host_put(sh);
+	return rc;
 }
 
 /*---------------------------------------------------------------------------*/
