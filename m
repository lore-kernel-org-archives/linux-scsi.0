From: Loc Ho <lho@apm.com>
Subject: (unknown)
Date: Thu, 16 Jan 2014 09:09:54 -0700
Message-ID: <1389888598-29690-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:59328 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752141AbaAPQKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 11:10:08 -0500
Received: by mail-pb0-f51.google.com with SMTP id rp16so2832566pbb.24
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2014 08:10:07 -0800 (PST)
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dmilburn@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

This patch adds support for APM X-Gene SoC 15Gbps Multi-purpose PHY. This
is the physical layer interface for the corresponding host controller. This
driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
In addition, the new PHY generic framework is patched to provide an
function to set the speed of the PHY.

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

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Loc Ho (4):
  PHY: Add function set_speed to generic PHY framework
  Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
    binding documentation
  PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
  arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries

 .../devicetree/bindings/phy/apm-xgene-phy.txt      |   79 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   75 +
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    2 +
 drivers/phy/phy-core.c                             |   21 +
 drivers/phy/phy-xgene.c                            | 1793 ++++++++++++++++++++
 include/linux/phy/phy.h                            |    8 +
 7 files changed, 1985 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/apm-xgene-phy.txt
 create mode 100644 drivers/phy/phy-xgene.c

