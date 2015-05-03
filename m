From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v3 2/2] ata: ahci_xgene: Add AHCI Support for 2nd HW version of APM X-Gene SoC AHCI SATA Host controller.
Date: Sun,  3 May 2015 21:03:40 +0530
Message-ID: <1430667220-23477-3-git-send-email-stripathi@apm.com>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430667220-23477-1-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch enables full AHCI feature support for APM X-Gene SoC SATA
host controller. The following errata's are removed:

1. 2a0bdff6b95 ("ahci-xgene: fix the dma state machine lockup for the
                 IDENTIFY DEVICE PIO mode command")
2. 09c32aaa368 ("ahci_xgene: Fix the dma state machine lockup for the
                 ATA_CMD_SMART PIO mode command")
3. 1540035da71 ("ahci_xgene: Implement the xgene_ahci_poll_reg_val to
                 support PMP")
4. a3a84bc7c88 ("ahci_xgene: Implement the workaround to support PMP
                 enumeration and discovery")
5. 1102407bb71 ("ahci_xgene: Fix the DMA state machine lockup for the
                 ATA_CMD_PACKET PIO mode command")
6. 72f79f9e35b ("ahci_xgene: Removing NCQ support from the APM X-Gene
		SoC AHCI SATA Host Controller driver")

In addition, enable PMP support for APM X-Gene SoC and enable FBS
support for second generation APM X-Gene SoC.

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/ata/ahci_xgene.c | 90 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 2b78510..2ced663 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/ahci_platform.h>
 #include <linux/of_address.h>
+#include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/phy/phy.h>
 #include "ahci.h"
@@ -84,6 +85,11 @@
 /* Max retry for link down */
 #define MAX_LINK_DOWN_RETRY 3

+enum xgene_ahci_version {
+	XGENE_AHCI_V1 = 1,
+	XGENE_AHCI_V2,
+};
+
 struct xgene_ahci_context {
 	struct ahci_host_priv *hpriv;
 	struct device *dev;
@@ -547,9 +553,6 @@ static struct ata_port_operations xgene_ahci_ops = {
 	.host_stop = xgene_ahci_host_stop,
 	.hardreset = xgene_ahci_hardreset,
 	.read_id = xgene_ahci_read_id,
-	.qc_issue = xgene_ahci_qc_issue,
-	.softreset = xgene_ahci_softreset,
-	.pmp_softreset = xgene_ahci_pmp_softreset
 };

 static const struct ata_port_info xgene_ahci_port_info = {
@@ -629,12 +632,30 @@ static struct scsi_host_template ahci_platform_sht = {
 	AHCI_SHT(DRV_NAME),
 };

+#ifdef CONFIG_ACPI
+static const struct acpi_device_id xgene_ahci_acpi_match[] = {
+	{ "APMC0D0D", XGENE_AHCI_V1},
+	{ "APMC0D32", XGENE_AHCI_V2},
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
+#endif
+
+static const struct of_device_id xgene_ahci_of_match[] = {
+	{.compatible = "apm,xgene-ahci", .data = (void *) XGENE_AHCI_V1},
+	{.compatible = "apm,xgene-ahci-v2", .data = (void *) XGENE_AHCI_V2},
+	{},
+};
+MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
+
 static int xgene_ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct xgene_ahci_context *ctx;
 	struct resource *res;
+	const struct of_device_id *of_devid;
+	enum xgene_ahci_version version = XGENE_AHCI_V1;
 	int rc;

 	hpriv = ahci_platform_get_resources(pdev);
@@ -677,6 +698,37 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 		ctx->csr_mux = csr;
 	}

+	of_devid = of_match_device(xgene_ahci_of_match, dev);
+	if (of_devid) {
+		if (of_devid->data)
+			version = (enum xgene_ahci_version) of_devid->data;
+	}
+#ifdef CONFIG_ACPI
+	else {
+		const struct acpi_device_id *acpi_id;
+		struct acpi_device_info *info;
+		acpi_status status;
+
+		acpi_id = acpi_match_device(xgene_ahci_acpi_match, &pdev->dev);
+		if (!acpi_id) {
+			dev_warn(&pdev->dev, "No node entry in ACPI table. Assume version1\n");
+			version = XGENE_AHCI_V1;
+		}
+
+		if (acpi_id->driver_data) {
+			version = (enum xgene_ahci_version) acpi_id->driver_data;
+			status = acpi_get_object_info(ACPI_HANDLE(&pdev->dev), &info);
+			if (ACPI_FAILURE(status)) {
+				dev_warn(&pdev->dev, "%s: Error reading device info. Assume version1\n",
+					__func__);
+				version = XGENE_AHCI_V1;
+			}
+			if (info->valid & ACPI_VALID_CID)
+				version = XGENE_AHCI_V2;
+		}
+	}
+#endif
+
 	dev_dbg(dev, "VAddr 0x%p Mmio VAddr 0x%p\n", ctx->csr_core,
 		hpriv->mmio);

@@ -704,7 +756,23 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	/* Configure the host controller */
 	xgene_ahci_hw_init(hpriv);
 skip_clk_phy:
-	hpriv->flags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;
+
+	switch (version) {
+	case XGENE_AHCI_V1:
+		hpriv->flags = AHCI_HFLAG_NO_NCQ;
+		/*
+		 * Override the callbacks for storm ERRATA
+		 */
+		xgene_ahci_ops.qc_issue = xgene_ahci_qc_issue;
+		xgene_ahci_ops.softreset = xgene_ahci_softreset;
+		xgene_ahci_ops.pmp_softreset = xgene_ahci_pmp_softreset;
+		break;
+	case XGENE_AHCI_V2:
+		hpriv->flags |= AHCI_HFLAG_YES_FBS | AHCI_HFLAG_EDGE_TRIG_IRQ;
+		break;
+	default:
+		break;
+	}

 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
 				     &ahci_platform_sht);
@@ -719,20 +787,6 @@ disable_resources:
 	return rc;
 }

-#ifdef CONFIG_ACPI
-static const struct acpi_device_id xgene_ahci_acpi_match[] = {
-	{ "APMC0D0D", },
-	{ }
-};
-MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
-#endif
-
-static const struct of_device_id xgene_ahci_of_match[] = {
-	{.compatible = "apm,xgene-ahci"},
-	{},
-};
-MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
-
 static struct platform_driver xgene_ahci_driver = {
 	.probe = xgene_ahci_probe,
 	.remove = ata_platform_remove_one,
--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
