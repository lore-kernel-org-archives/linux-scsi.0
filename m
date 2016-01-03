From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 73/78] ncr5380: Fix pseudo DMA transfers on 53C400
Date: Sun, 03 Jan 2016 16:06:14 +1100
Message-ID: <20160103050522.292805572@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49436 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbcACFSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:31 -0500
Content-Disposition: inline; filename=72-71
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>

From: Ondrej Zary <linux@rainbow-software.org>

Pseudo-DMA (PDMA) has been broken for ages, resulting in hangs on
53C400-based cards.

According to 53C400 datasheet, PDMA transfer length must be a multiple
of 128. Check if that's true and use PIO if it's not.

This makes PDMA work on 53C400 (Canon FG2-5202).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/g_NCR5380.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:38.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:50.000000000 +1100
@@ -702,6 +702,10 @@ static int generic_NCR5380_dma_xfer_len(
 	    !(cmd->SCp.this_residual % transfersize))
 		transfersize = 32 * 1024;
 
+	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
+	if (transfersize % 128)
+		transfersize = 0;
+
 	return transfersize;
 }
 


