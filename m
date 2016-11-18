From: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v2] ata: xgene: Enable NCQ support for APM X-Gene SATA controller hardware v1.1
Date: Fri, 18 Nov 2016 15:15:45 +0530
Message-ID: <1479462345-13942-1-git-send-email-rsahu@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch enables NCQ support for APM X-Gene SATA controller hardware v1.1
that was broken with hardware v1.0. Second thing, here we should not assume
XGENE_AHCI_V2 always in case of having valid _CID in ACPI table. I need to
remove this assumption because V1_1 also has a valid _CID for backward
compatibly with v1.

v2 changes:
	1. Changed patch description

Signed-off-by: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/ata/ahci_xgene.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 73b19b2..8b88be9 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -87,6 +87,7 @@

 enum xgene_ahci_version {
 	XGENE_AHCI_V1 = 1,
+	XGENE_AHCI_V1_1,
 	XGENE_AHCI_V2,
 };

@@ -734,6 +735,7 @@ static struct scsi_host_template ahci_platform_sht = {
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id xgene_ahci_acpi_match[] = {
 	{ "APMC0D0D", XGENE_AHCI_V1},
+	{ "APMC0D67", XGENE_AHCI_V1_1},
 	{ "APMC0D32", XGENE_AHCI_V2},
 	{},
 };
@@ -742,6 +744,7 @@ MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);

 static const struct of_device_id xgene_ahci_of_match[] = {
 	{.compatible = "apm,xgene-ahci", .data = (void *) XGENE_AHCI_V1},
+	{.compatible = "apm,xgene-ahci-v1-1", .data = (void *) XGENE_AHCI_V1_1},
 	{.compatible = "apm,xgene-ahci-v2", .data = (void *) XGENE_AHCI_V2},
 	{},
 };
@@ -755,8 +758,7 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	struct resource *res;
 	const struct of_device_id *of_devid;
 	enum xgene_ahci_version version = XGENE_AHCI_V1;
-	const struct ata_port_info *ppi[] = { &xgene_ahci_v1_port_info,
-					      &xgene_ahci_v2_port_info };
+	const struct ata_port_info *ppi;
 	int rc;

 	hpriv = ahci_platform_get_resources(pdev);
@@ -821,8 +823,6 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 				dev_warn(&pdev->dev, "%s: Error reading device info. Assume version1\n",
 					__func__);
 				version = XGENE_AHCI_V1;
-			} else if (info->valid & ACPI_VALID_CID) {
-				version = XGENE_AHCI_V2;
 			}
 		}
 	}
@@ -858,18 +858,20 @@ skip_clk_phy:

 	switch (version) {
 	case XGENE_AHCI_V1:
+		ppi = &xgene_ahci_v1_port_info;
 		hpriv->flags = AHCI_HFLAG_NO_NCQ;
 		break;
 	case XGENE_AHCI_V2:
+		ppi = &xgene_ahci_v2_port_info;
 		hpriv->flags |= AHCI_HFLAG_YES_FBS;
 		hpriv->irq_handler = xgene_ahci_irq_intr;
 		break;
 	default:
+		ppi = &xgene_ahci_v1_port_info;
 		break;
 	}

-	rc = ahci_platform_init_host(pdev, hpriv, ppi[version - 1],
-				     &ahci_platform_sht);
+	rc = ahci_platform_init_host(pdev, hpriv, ppi, &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;

--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
