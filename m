From: Loc Ho <lho@apm.com>
Subject: [PATCH v18 0/4] ata: Add APM X-Gene SoC AHCI SATA host controller support
Date: Fri, 14 Mar 2014 17:53:17 -0600
Message-ID: <1394841201-29495-1-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds support for the APM X-Gene SoC AHCI SATA host controller. In
order for the host controller to work, the corresponding PHY driver
musts also be available. Currently, only Gen3 disk is supported with this
initial version.

v18:
 * Remove clock-name properity from dts nodes
 * Update binding document
 * Clean up dt compatible string
 * Remove IP module offset defines
 * Spilt resource region into individual modules - core, diagnostic, AXI,
   and MUX
 * Update function xgene_ahci_init_memram, xgene_ahci_hw_init,
   xgene_ahci_mux_select, and xgene_ahci_probe due to resource spilt
 * Update function comment in function xgene_ahci_do_hardreset
 * Change DMA coherent mask back to 64

v17:
 * Add comment on no support for PM currently
 * Add xgene_ahci_host_stop function to support stopping the controller
 * Remove call to phy_exit as not necessary with new ahci_platform code

v16:
 * Rebase to libata-for-3.15
 * Pull in the PHY DTS patch as the host controller DTS patch depends on it

v15:
 * Rebase to libata next branch
 * Remove field plat_data and PHY from context structure
 * Fix comment on function xgene_ahci_read_id as well as using bit mask to
   clear DEVSLP bit
 * Remove function xgene_ahci_force_phy_rdy and xgene_ahci_phy_restart as not
   required since Gen1/Gen2 support remove for this initial version
 * Update function xgene_ahci_do_hardreset comment
 * Remove Gen1/Gen2 support from function xgene_ahci_do_hardreset
 * Change int to u32 for variable portcmd_saved in function
   xgene_ahci_hardreset
 * Change variable hplat_data to ctx in function xgene_ahci_probe
 * Remove PHY call and using ahci_platform_enable_resource instead
 * Add ahci_patlform_remove_one to driver function .remove
 * Change phy-name to "sata-phy"

v14:
 * Remove the shutdown already check and replace the while loop check with
   msleep in function xgene_ahci_init_memram

v13:
 * Add fully-winged style comment for function xgene_ahci_read_id and
   xgene_ahci_do_hardrest
 * Minor comments update for function xgene_ahci_read_id,
   xgene_ahci_do_hardrest, and xgene_ahci_hardreset
 * NOTE: There is no functional code change.

v12:
 * Remove function xgene_ahci_get_channel and use the ata_port field port_no
 * Update comment for function xgene_ahci_read_id to function comment style
   '/**'
 * Update comment for multiple lines to fully-winged style

v11:
 * Drop the export functions requirement with libachi
 * Change CONFIG_SATA_XGENE to CONFIG_AHCI_XGENE
 * Rename file sata_xgene.c to ahci_xgene.c
 * Convert to use Hans De Geode version 5 ahci_platform code re-factor changes
   to reduce code duplication. For extra context, use plat_data to store our
   context. The probe function follows the ahci_sunxi implementation. A number
   of code fragments update to reflect this change.
 * Update comment for function xgene_ahci_read_id
 * Minor code move around in function xgene_ahci_do_hardreset and use
   ATA_BUSY instead 0x80
 * Fix hardreset to use start_engine function pointer as required due to newer
   kernel rebased
 * Fix the set DMA mask for 32-bit as well

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
  arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries
  Documentation: Add documentation for the APM X-Gene SoC SATA host
    controller DTS binding
  ata: Add APM X-Gene SoC AHCI SATA host controller driver
  arm64: Add APM X-Gene SoC AHCI SATA host controller DTS entries

 .../devicetree/bindings/ata/apm-xgene.txt          |   76 +++
 arch/arm64/boot/dts/apm-storm.dtsi                 |  152 ++++++
 drivers/ata/Kconfig                                |    7 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/ahci_xgene.c                           |  486 ++++++++++++++++++++
 5 files changed, 722 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/ahci_xgene.c

