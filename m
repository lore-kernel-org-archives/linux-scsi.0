Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F664C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 16:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D59560F9D
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 16:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhKFQtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbhKFQtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 12:49:40 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD63C061714
        for <linux-scsi@vger.kernel.org>; Sat,  6 Nov 2021 09:46:58 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:91c6:551:e507:741f])
        by albert.telenet-ops.be with bizsmtp
        id F4ms260094BJ5g4064msF8; Sat, 06 Nov 2021 17:46:55 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mjOqC-00AbhT-9P; Sat, 06 Nov 2021 17:46:52 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mjOqB-006aiZ-LK; Sat, 06 Nov 2021 17:46:51 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: ufs: Wrap Universal Flash Storage drivers in SCSI_UFSHCD
Date:   Sat,  6 Nov 2021 17:46:50 +0100
Message-Id: <20211106164650.1571068-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The build only descends into drivers/scsi/ufs/ if SCSI_UFSHCD is
enabled.  Hence all later config symbols should depend on SCSI_UFSHCD,
to prevent asking the user about config symbols for driver code that
won't be build anyway.  Unfortunately not all symbols have that
dependency.

Fix this by wrapping them all into a big if/endif block.  Remove the now
superfluous explicit dependencies on SCSI_UFSHCD from all symbols that
already had it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Exposed by commit 60c98a87fcaad9e7 ("scsi: ufs: core: SCSI_UFS_HWMON
depends on HWMON=y").
---
 drivers/scsi/ufs/Kconfig | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index b2521b830be72fa5..a43f4d947f1bf8a8 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -50,9 +50,11 @@ config SCSI_UFSHCD
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a UFS device.
 
+if SCSI_UFSHCD
+
 config SCSI_UFSHCD_PCI
 	tristate "PCI bus based UFS Controller support"
-	depends on SCSI_UFSHCD && PCI
+	depends on PCI
 	help
 	  This selects the PCI UFS Host Controller Interface. Select this if
 	  you have UFS Host Controller with PCI Interface.
@@ -71,7 +73,6 @@ config SCSI_UFS_DWC_TC_PCI
 
 config SCSI_UFSHCD_PLATFORM
 	tristate "Platform bus based UFS Controller support"
-	depends on SCSI_UFSHCD
 	depends on HAS_IOMEM
 	help
 	  This selects the UFS host controller support. Select this if
@@ -147,7 +148,6 @@ config SCSI_UFS_TI_J721E
 
 config SCSI_UFS_BSG
 	bool "Universal Flash Storage BSG device node"
-	depends on SCSI_UFSHCD
 	select BLK_DEV_BSGLIB
 	help
 	  Universal Flash Storage (UFS) is SCSI transport specification for
@@ -177,7 +177,7 @@ config SCSI_UFS_EXYNOS
 
 config SCSI_UFS_CRYPTO
 	bool "UFS Crypto Engine Support"
-	depends on SCSI_UFSHCD && BLK_INLINE_ENCRYPTION
+	depends on BLK_INLINE_ENCRYPTION
 	help
 	  Enable Crypto Engine Support in UFS.
 	  Enabling this makes it possible for the kernel to use the crypto
@@ -186,7 +186,6 @@ config SCSI_UFS_CRYPTO
 
 config SCSI_UFS_HPB
 	bool "Support UFS Host Performance Booster"
-	depends on SCSI_UFSHCD
 	help
 	  The UFS HPB feature improves random read performance. It caches
 	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
@@ -195,7 +194,7 @@ config SCSI_UFS_HPB
 
 config SCSI_UFS_FAULT_INJECTION
 	bool "UFS Fault Injection Support"
-	depends on SCSI_UFSHCD && FAULT_INJECTION
+	depends on FAULT_INJECTION
 	help
 	  Enable fault injection support in the UFS driver. This makes it easier
 	  to test the UFS error handler and abort handler.
@@ -208,3 +207,5 @@ config SCSI_UFS_HWMON
 	  a hardware monitoring device will be created for the UFS device.
 
 	  If unsure, say N.
+
+endif
-- 
2.25.1

