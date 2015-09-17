From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 00/11] exynos-ufs: add support for Exynos
Date: Thu, 17 Sep 2015 15:15:26 +0530
Message-ID: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49424 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbIQJyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 05:54:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host support
for Samsung Exynos SoC. Mostly, it consists of UFS PHY and host specific driver.
And it also contains some quirks handling for Exynos.

-Changes since v1:
* Addressed review comments from Alexey[1] and various review comments from Amit.
* Updated email id of Seungwon as his samsung id is void now.
* Added ufs platform data

[1]-> https://lkml.org/lkml/2015/8/23/124

Alim Akhtar (1):
  scsi: ufs: Add exynos ufs platform data

Seungwon Jeon (10):
  phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
  scsi: ufs: add quirk to contain unconformable utrd field
  scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr
  scsi: ufs: add quirk not to allow reset of interrupt aggregation
  scsi: ufs: add quirk to enable host controller without hce
  scsi: ufs: add specific callback for nexus type
  scsi: ufs: add add specific callback for hibern8
  scsi: ufs: make ufshcd_config_pwr_mode of non-static func
  scsi: ufs: return value of pwr_change_notify
  scsi: ufs-exynos: add UFS host support for Exynos SoCs

 .../devicetree/bindings/phy/samsung-phy.txt        |   22 +
 .../devicetree/bindings/ufs/ufs-exynos.txt         |   93 ++
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-ufs.c                       |  262 +++++
 drivers/phy/phy-exynos-ufs.h                       |   85 ++
 drivers/phy/phy-exynos7-ufs.h                      |   89 ++
 drivers/scsi/ufs/Kconfig                           |   12 +
 drivers/scsi/ufs/Makefile                          |    1 +
 drivers/scsi/ufs/ufs-exynos-hw.c                   |  147 +++
 drivers/scsi/ufs/ufs-exynos-hw.h                   |   43 +
 drivers/scsi/ufs/ufs-exynos.c                      | 1173 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                      |  463 ++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |    2 +
 drivers/scsi/ufs/ufshcd.c                          |  196 +++-
 drivers/scsi/ufs/ufshcd.h                          |   35 +
 drivers/scsi/ufs/ufshci.h                          |   26 +-
 drivers/scsi/ufs/unipro.h                          |   47 +
 include/linux/phy/phy-exynos-ufs.h                 |  107 ++
 19 files changed, 2784 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
 create mode 100644 drivers/phy/phy-exynos-ufs.c
 create mode 100644 drivers/phy/phy-exynos-ufs.h
 create mode 100644 drivers/phy/phy-exynos7-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h
 create mode 100644 include/linux/phy/phy-exynos-ufs.h

-- 
1.7.10.4

