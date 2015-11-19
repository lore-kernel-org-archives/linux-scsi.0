From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3] scsi: advansys needs ISA dma api for ISA support
Date: Thu, 19 Nov 2015 15:22:23 +0100
Message-ID: <4355540.BF55dNX7U7@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
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
---
This is identical to v1 of the patch. We had gone through several iterations
of this in October before concluding that everything else was more problematic.

Please apply.

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5f692ae40749..04a720686516 100644
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
