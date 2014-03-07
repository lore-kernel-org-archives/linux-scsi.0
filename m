From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v15 0/3] PHY: Add APM X-Gene SoC 15Gbps Multi-purpose PHY support
Date: Fri,  7 Mar 2014 10:28:06 -0700
Message-ID: <1394213289-29565-1-git-send-email-lho@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kishon-l0cyMroinI0@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds support for APM X-Gene SoC 15Gbps Multi-purpose PHY. This
is the physical layer interface for the corresponding host controller. This
driver uses the PHY generic framework.

v15:
* Fix all check patch warning and re-run checkpatch to confirm

v14:
* Fix function xgene_phy_xlate to check valid mode and parameter count
* Clean up probe function on error checking

v13:
* Remove PHY patch for initial version as only Gen3 speed is supported
* Remove function xgene_phy_sata_force_gen and xgene_phy_set_speed
* Minor comment update to header and function xgene_phy_hw_init

v12:
* Add driver depend on HAS_IOMEM and OF
* Fix comment typo in header file phy-xgene.
* Change all macro shift value in hex to decimal
* Add time out for while loop to function sds_wr and sds_rd
* Set proper return value if failed to get IO resource 0
* Move devm_of_phy_provider_register to last operation in probe function
* Remove driver registration print statement
* Replace module init/exit with module_platform_driver
* Change license to GPL v2

v11:
* Add comment to function phy_set_speed
* Add commit log for documentation patch file
* Minor comment update to function xgene_phy_force_lat_summer_cal and
  xgene_phy_sata_force_gen

v10
* Update comment for function xgene_phy_force_lat_summer_cal and
  xgene_phy_sata_force_gen with function style fully-winged style

v9
* Update CMU parameter setting for register 13
* Add required delay when configure CMU PLL, Manual Calibration PLL, and VCO
  PLL
* Add comment for CMU PLL calibration loop delay of 10us
* Add required delay for stopping and starting summer calibrations
* Update comment for summer and latch calibration delays
* Update comment for PHY reset Rx delay and decrease max sleep time from 500
  to 150us
* Always program the DFE (equalizer) setting to 0x7e00 as with original version
* Fix Tx speed selection to always using Gen3 setting when force to an
  specified generation speed

v8
* Update binding documentation
* Remove XGENE_PHY_DTS and XGENE_PHY_EXT_DTS defines
* Remove support for internal clock
* Remove support for external reference CMU
* Remove the need for external reference resource DTS entry and its related
  code

v7
* Add/Update PHY CMU/lane parameters and its default values
* Rename variable enable_manual_cal to preA3Chip
* Remove function phy_rd, phy_wr, and phy_wr_flush
* Change function cmu_wr, cmu_rd, cmu_toggle1to0, cmu_clrbits, cmu_setbits,
  serdes_wr, serdes_rd, serdes_clrbits, and serdes_setbits to take context
  instead void *
* Remove function serdes_toggle1to0
* Decrease the polling time from 10ms to 1ms on CMU calibration complete
  detection
* Move all SATA specify code in function xgene_phy_hw_initialize into
  function xgene_phy_hw_init_sata
* Add usleep_range after starting summer/latch calibrations
* Add usleep_range between receiver reset (function xgene_phy_reset_rxd)
* Save and restore PHY register 31 instead writing 0 in function
  xgene_phy_gen_avg_val
* Update function xgene_phy_sata_force_gen programming sequences
* Add support to reset the receiver lane in function xgene_phy_set_speed
  if speed is 0
* Update PHY parameters in DTS per controller
* Some minor code clean up

v6
* Move PHY document to Documentation/devicetree/binding/phy
* Remove _ADDR from all register defines
* Update clock-names property for sataphy1clk, sataphy2clk, and sataphy3clk

v5
* Update DTS binding documentation
* Remove direct clock access and use clock interface instead
* Change override parameters to decimal instead hex values
* Change apm,tx-amplitude, apm,tx-pre-cursor1, apm,tx-pre-cursor2,
  apm,tx-post-cursor to be unit of uV

v4
* Update documentation with 'apm,' instead 'apm-'
* Change DTS override parameter to have 'apm,'
* Add select GENERIC_PHY to Kconfig PHY_XGENE
* Make override parameters to be pair of three values instead one
* Some minor comment and indentation changes
* Remove error register addition offset
* Add ULL to constants
* Use module_init instead subsys_initcall
* Make DTS node based on first register address
* Update override setting values

v3
* Major re-write of the code based on various review comments
* Support external clock only at the moment
* Support SATA mode only at the moment
* No UEFI support at the moment

v2
* Remove port knowledge from functions
* Make all functions static
* Remove ID completely
* Make resource requirement based on compatible type
* Rename override PHY parameters with more descriptive name
* Add override PHY parameter for per controller, per port, and per speed
* Patch the generic PHY frame to expose set_speed operation

v1
* Initial version

Signed-off-by: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>
Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
Loc Ho (3):
  Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
    binding documentation
  PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
  arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries

 .../devicetree/bindings/phy/apm-xgene-phy.txt      |   79 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   75 +
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    2 +
 drivers/phy/phy-xgene.c                            | 1750 ++++++++++++++++++++
 5 files changed, 1913 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
 create mode 100644 drivers/phy/phy-xgene.c

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
