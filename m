From: Loc Ho <lho@apm.com>
Subject: [PATCH v5 0/4] PHY: Add APM X-Gene SoC 15Gbps Multi-purpose PHY support
Date: Sat, 14 Dec 2013 01:32:46 -0700
Message-ID: <1387009970-737-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:33026 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753332Ab3LNIc7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Dec 2013 03:32:59 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so3542727pbb.36
        for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2013 00:32:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

This patch adds support for APM X-Gene SoC 15Gbps Multi-purpose PHY. This
is the physical layer interface for the corresponding host controller. This
driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
In addition, the new PHY generic framework is patched to provide an
function to set the speed of the PHY.

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

 .../devicetree/bindings/ata/apm-xgene-phy.txt      |   94 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   76 +
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    2 +
 drivers/phy/phy-core.c                             |   21 +
 drivers/phy/phy-xgene.c                            | 1811 ++++++++++++++++++++
 include/linux/phy/phy.h                            |    8 +
 7 files changed, 2019 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
 create mode 100644 drivers/phy/phy-xgene.c

