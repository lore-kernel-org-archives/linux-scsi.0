From: Loc Ho <lho@apm.com>
Subject: [PATCH v4 0/4] ata: Add APM X-Gene SoC SATA host controller support
Date: Wed, 20 Nov 2013 23:11:34 -0700
Message-ID: <1385014298-15700-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:56846 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750862Ab3KUGLv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2013 01:11:51 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so5527215pdj.11
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 22:11:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

ata: Add APM X-Gene SoC SATA host controller support

This patch adds support for the APM X-Gene SoC SATA host controller. In
order for the host controller to work, the corresponding SATA PHY driver
musts also be available.

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
  Documentation:: Add documentation for APM X-Gene SoC SATA host
    controller DTS binding
  ata: Add APM X-Gene SoC SATA host controller driver
  arm64: Add APM X-Gene SoC SATA host controller DTS entries

 .../devicetree/bindings/ata/apm-xgene.txt          |   56 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   33 +
 drivers/ata/Kconfig                                |    8 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/ahci.h                                 |    6 +
 drivers/ata/libahci.c                              |   13 +-
 drivers/ata/sata_xgene.c                           | 1128 ++++++++++++++++++++
 7 files changed, 1240 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/sata_xgene.c

