From: Loc Ho <lho@apm.com>
Subject: (unknown)
Date: Thu, 16 Jan 2014 09:11:23 -0700
Message-ID: <1389888687-29741-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:48893 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752032AbaAPQLg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 11:11:36 -0500
Received: by mail-pb0-f52.google.com with SMTP id jt11so781542pbb.11
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2014 08:11:35 -0800 (PST)
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dmilburn@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

This patch adds support for the APM X-Gene SoC SATA host controller. In
order for the host controller to work, the corresponding PHY driver
musts also be available.

v10:
 * Update binding documentation

v9:
 * Remove ACPI/EFI include files
 * Remove the IO flush support, interrupt routine, and DTS resources
 * Remove function xgene_rd, xgene_wr, and xgene_wr_flush
 * Remove PMP support (function xgene_ahci_qc_issue, xgene_ahci_qc_prep,
   xgene_ahci_qc_fill_rtf, xgene_ahci_softreset, and xgene_ahci_do_softreset)
 * Rename function xgene_ahci_enable_phy to xgene_ahci_force_phy_rdy
 * Clean up hardreset functions
 * Require v7 of the PHY driver

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

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Loc Ho (4):
  ata: Export required functions by APM X-Gene SATA driver
  Documentation: Add documentation for APM X-Gene SoC SATA host
    controller DTS binding
  ata: Add APM X-Gene SoC SATA host controller driver
  arm64: Add APM X-Gene SoC SATA host controller DTS entries

 .../devicetree/bindings/ata/apm-xgene.txt          |   70 +++
 arch/arm64/boot/dts/apm-storm.dtsi                 |   75 +++
 drivers/ata/Kconfig                                |    8 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/ahci.h                                 |    9 +
 drivers/ata/libahci.c                              |   16 +-
 drivers/ata/sata_xgene.c                           |  630 ++++++++++++++++++++
 7 files changed, 803 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/sata_xgene.c

