From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 72/71] ncr5380: Fix pseudo-DMA
Date: Wed, 25 Nov 2015 22:34:42 +0100
Message-ID: <1448487282-31766-1-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pseudo-DMA (PDMA) has been broken for ages, resulting in hangs on
53C400-based cards.

According to 53C400 datasheet, PDMA transfer length must be a multiple
of 128. Check if that's true and use PIO if it's not.

This makes PDMA work on 53C400 (Canon FG2-5202).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 0daffe2..a9a237f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -703,6 +703,10 @@ static int generic_NCR5380_dma_xfer_len(struct scsi_cmnd *cmd)
 	    !(cmd->SCp.this_residual % transfersize))
 		transfersize = 32 * 1024;
 
+	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
+	if (transfersize % 128)
+		transfersize = 0;
+
 	return transfersize;
 }
 
-- 
Ondrej Zary
