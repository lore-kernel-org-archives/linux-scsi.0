From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 72/77] ncr5380: Fix pseudo DMA transfers on 53C400
Date: Tue, 22 Dec 2015 12:18:50 +1100
Message-ID: <20151222011757.605771566@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=72-71
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Pseudo-DMA (PDMA) has been broken for ages, resulting in hangs on
53C400-based cards.

According to 53C400 datasheet, PDMA transfer length must be a multiple
of 128. Check if that's true and use PIO if it's not.

This makes PDMA work on 53C400 (Canon FG2-5202).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/g_NCR5380.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:15.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:27.000000000 +1100
@@ -702,6 +702,10 @@ static int generic_NCR5380_dma_xfer_len(
 	    !(cmd->SCp.this_residual % transfersize))
 		transfersize = 32 * 1024;
 
+	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
+	if (transfersize % 128)
+		transfersize = 0;
+
 	return transfersize;
 }
 
