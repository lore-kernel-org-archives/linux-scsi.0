From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] powerpc: PCI_MSI needs PCI
Date: Sat, 13 Oct 2018 17:10:11 +0200
Message-ID: <20181013151016.31674-4-hch@lst.de>
References: <20181013151016.31674-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Various powerpc boards select the PCI_MSI config option without selecting
PCI, resulting in potentially not compilable configurations if the by
default enabled PCI option is disabled.  Explicitly select PCI to ensure
we always have valid configs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/platforms/40x/Kconfig | 1 +
 arch/powerpc/platforms/44x/Kconfig | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index 60254a321a91..d5361e63e0bb 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -33,6 +33,7 @@ config KILAUEA
 	select 405EX
 	select PPC40x_SIMPLE
 	select PPC4xx_PCI_EXPRESS
+	select PCI
 	select PCI_MSI
 	select PPC4xx_MSI
 	help
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index a6011422b861..70856a213663 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -24,6 +24,7 @@ config BLUESTONE
 	default n
 	select PPC44x_SIMPLE
 	select APM821xx
+	select PCI
 	select PCI_MSI
 	select PPC4xx_MSI
 	select PPC4xx_PCI_EXPRESS
@@ -78,6 +79,7 @@ config KATMAI
 	select 440SPe
 	select PCI
 	select PPC4xx_PCI_EXPRESS
+	select PCI
 	select PCI_MSI
 	select PPC4xx_MSI
 	help
@@ -219,6 +221,7 @@ config AKEBONO
 	select SWIOTLB
 	select 476FPE
 	select PPC4xx_PCI_EXPRESS
+	select PCI
 	select PCI_MSI
 	select PPC4xx_HSTA_MSI
 	select I2C
-- 
2.19.1
