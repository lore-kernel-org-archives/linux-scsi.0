From: Loc Ho <lho@apm.com>
Subject: [PATCH v3 0/4] ata: Add APM X-Gene SoC SATA host controller support
Date: Thu, 14 Nov 2013 14:39:09 -0700
Message-ID: <1384465153-29902-1-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

ata: Add APM X-Gene SoC SATA host controller support

This patch adds support for the APM X-Gene SoC SATA host controller. In 
order for the host controller to work, the corresponding SATA PHY driver
musts also be available.

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
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Olof Johansson <olof@lixom.net>
---
Loc Ho (4):
  ata: Export required functions by APM X-Gene SATA driver
  Documentation: Add documentation for APM X-Gene SATA controllor DTS
    binding
  ata: Add APM X-Gene SoC SATA host controller driver
  arm64: Add APM X-Gene SoC SATA host controller DTS entries

 .../devicetree/bindings/ata/apm-xgene.txt          |   62 +-
 arch/arm64/boot/dts/apm-storm.dtsi                 |   70 ++
 drivers/ata/Kconfig                                |    8 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/ahci.h                                 |    6 +
 drivers/ata/libahci.c                              |   13 +-
 drivers/ata/sata_xgene.c                           | 1271 ++++++++++++++++++++
 drivers/ata/sata_xgene.h                           |   96 ++
 8 files changed, 1521 insertions(+), 6 deletions(-)
 create mode 100644 drivers/ata/sata_xgene.c
 create mode 100644 drivers/ata/sata_xgene.h

