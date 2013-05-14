From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/3] SCSI_UFSHCD should depend on SCSI_DMA
Date: Tue, 14 May 2013 21:34:14 +0530
Message-ID: <1368547455-5211-3-git-send-email-santoshsy@gmail.com>
References: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36737 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3ENQEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 12:04:52 -0400
Received: by mail-pb0-f41.google.com with SMTP id xb12so558576pbc.14
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2013 09:04:51 -0700 (PDT)
In-Reply-To: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Geert Uytterhoeven <geert@linux-m68k.org>

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
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 35faf24..f07f901 100644
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
1.8.1.2

