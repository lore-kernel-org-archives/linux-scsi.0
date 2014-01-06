From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v8 0/4] ata: Add APM X-Gene SoC SATA host controller support
Date: Mon,  6 Jan 2014 11:11:58 -0700
Message-ID: <1389031922-4309-1-git-send-email-lho@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds support for the APM X-Gene SoC SATA host controller. In
order for the host controller to work, the corresponding PHY driver
musts also be available.

v8:
 * Remove _ADDR from defines
 * Remove define MSTAWAUX_COHERENT_BYPASS_SET and
   STARAUX_COHERENT_BYPASS_SET and use direct coding
 * Remove the un-necessary check for DTS boot with built in ACPI table
 * Switch to use dma_set_mask_and_coherent for setting DMA mask
 * Remove ACPI table matching code
 * Update clock-names for sata01clk, sata23clk, and sata45clk

v7:
 * Update the clock code by toggle the clock
 * Update the DTS clock mask values due to the clock spilt between host and
   v5 of the PHY drivers

v6:
 * Update binding documentation
 * Change select PHY_XGENE_SATA to PHY_XGENE
 * Add ULL to constants
 * Change indentation and comments
 * Clean up the probe functions a bit more
 * Remove xgene_ahci_remove function
 * Add the flush register to DTS
 * Remove the interrupt-parent from DTS

v5:
 * Sync up to v3 of the PHY driver
 * Remove MSLIM wrapper functions
 * Change the memory shutdown loop to use usleep_range
 * Use devm_ioremap_resource instead devm_ioremap
 * Remove suspend/resume functions as not needed

v4:
 * Remove the ID property in DT
 * Remove the temporary PHY direct function call and use PHY function
 * Change printk to pr_debug
 * Move the IOB flush addresses into the DT
 * Remove the parameters retrieval function as no longer needed
 * Remove the header file as no longer needed
 * Require v2 patch of the SATA PHY driver. Require slightly modification
   in the Kconfig as it is moved to folder driver/phy and use Kconfig
   PHY_XGENE_SATA instead SATA_XGENE_PHY.

v3:
 * Move out the SATA PHY to another driver
 * Remove the clock-cells entry from DTS
 * Remove debug wrapper
 * Remove delay functions wrapper
 * Clean up resource and IRQ query
 * Remove query clock name
 * Switch to use dma_set_mask/dma_coherent_mask
 * Remove un-necessary devm_kfree
 * Update GPL license header to v2
 * Spilt up function xgene_ahci_hardreset
 * Spilt up function xgene_ahci_probe
 * Remove all reference of CONFIG_ARCH_MSLIM
 * Clean up chip revision code

v2:
 * Clean up file sata_xgene.c with Lindent and etc
 * Clean up file sata_xgene_serdes.c with Lindent and etc
 * Add description to each patch

v1:
 * inital version

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
Loc Ho (4):
  ata: Export required functions by APM X-Gene SATA driver
  Documentation: Add documentation for APM X-Gene SoC SATA host
    controller DTS binding
  ata: Add APM X-Gene SoC SATA host controller driver
  arm64: Add APM X-Gene SoC SATA host controller DTS entries

 .../devicetree/bindings/ata/apm-xgene.txt          |   68 ++
 arch/arm64/boot/dts/apm-storm.dtsi                 |   81 ++
 drivers/ata/Kconfig                                |    8 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/ahci.h                                 |    9 +
 drivers/ata/libahci.c                              |   16 +-
 drivers/ata/sata_xgene.c                           | 1047 ++++++++++++++++++++
 7 files changed, 1224 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/sata_xgene.c

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
