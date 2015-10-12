From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Mon, 12 Oct 2015 17:10:16 +0200
Message-ID: <5081546.QjQ32dGX2L@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@odin.com
Cc: Hannes Reinecke <hare@suse.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The advansys drvier uses the request_dma function that is used on ISA
machines for the internal DMA controller, which causes build errors
on platforms that have ISA slots but do not provide the ISA DMA API:

drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:11300:10: error: implicit declaration of function 'request_dma' [-Werror=implicit-function-declaration]

The problem now showed up in ARM randconfig builds after commit
6571fb3f8b7f ("advansys: Update to version 3.5 and remove compilation
warning") made it possible to build on platforms that have neither
VIRT_TO_BUS nor ISA_DMA_API but that do have ISA.

This adds the missing dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d2f480b04a52..d4aa6a1a806c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -499,6 +499,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
 	depends on ISA || EISA || PCI
+	depends on ISA_DMA_API || !ISA
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
