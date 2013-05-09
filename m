From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/12] [SCSI] SCSI_UFSHCD should depend on SCSI_DMA
Date: Thu,  9 May 2013 23:04:44 +0200
Message-ID: <1368133494-22198-2-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `ufshcd_transfer_req_compl':
drivers/scsi/ufs/ufshcd.c:1182: undefined reference to `scsi_dma_unmap'
drivers/built-in.o: In function `ufshcd_map_sg':
drivers/scsi/ufs/ufshcd.c:377: undefined reference to `scsi_dma_map'
drivers/built-in.o: In function `ufshcd_do_reset':
drivers/scsi/ufs/ufshcd.c:912: undefined reference to `scsi_dma_unmap'
drivers/built-in.o: In function `ufshcd_memory_alloc':
drivers/scsi/ufs/ufshcd.c:565: undefined reference to `dma_alloc_coherent'
drivers/built-in.o: In function `ufshcd_free_hba_memory':
drivers/scsi/ufs/ufshcd.c:185: undefined reference to `dma_free_coherent'
drivers/scsi/ufs/ufshcd.c:192: undefined reference to `dma_free_coherent'
drivers/scsi/ufs/ufshcd.c:199: undefined reference to `dma_free_coherent'
drivers/scsi/ufs/ufshcd.c:185: undefined reference to `dma_free_coherent'
drivers/scsi/ufs/ufshcd.c:192: undefined reference to `dma_free_coherent'
drivers/built-in.o:drivers/scsi/ufs/ufshcd.c:199: more undefined references to `dma_free_coherent' follow
drivers/built-in.o: In function `ufshcd_abort':
drivers/scsi/ufs/ufshcd.c:1498: undefined reference to `scsi_dma_unmap'
drivers/built-in.o: In function `ufshcd_device_reset':
drivers/scsi/ufs/ufshcd.c:1436: undefined reference to `scsi_dma_unmap'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 0371047..acd7a1c 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -34,7 +34,7 @@
 
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller Driver Core"
-	depends on SCSI
+	depends on SCSI && SCSI_DMA
 	---help---
 	This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card
-- 
1.7.0.4
