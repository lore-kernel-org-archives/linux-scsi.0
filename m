From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] powerpc: simplify CONFIG_PCI_QSPAN Kconfig magic
Date: Sat, 13 Oct 2018 17:10:10 +0200
Message-ID: <20181013151016.31674-3-hch@lst.de>
References: <20181013151016.31674-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

The way how CONFIG_PCI_QSPAN selects the CONFIG_PCI default is highly
unusual and gets in the way of moving CONFIG_PCI into
drivers/pci/Kconfig.  Simplify it by just having it depend on
CONFIG_PCI.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a80669209155..6fa6f92edb7f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -955,7 +955,6 @@ config PCI
 	bool "PCI support" if PPC_PCI_CHOICE
 	default y if !40x && !CPM2 && !PPC_8xx && !PPC_83xx \
 		&& !PPC_85xx && !PPC_86xx && !GAMECUBE_COMMON
-	default PCI_QSPAN if PPC_8xx
 	select GENERIC_PCI_IOMAP
 	help
 	  Find out whether your system includes a PCI bus. PCI is the name of
@@ -971,7 +970,7 @@ config PCI_SYSCALL
 
 config PCI_QSPAN
 	bool "QSpan PCI"
-	depends on PPC_8xx
+	depends on PPC_8xx && PCI
 	select PPC_I8259
 	help
 	  Say Y here if you have a system based on a Motorola 8xx-series
-- 
2.19.1
