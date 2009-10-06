From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] NCR5380: bit MR_DMA_MODE set twice in NCR5380_transfer_dma()
Date: Tue, 06 Oct 2009 22:17:43 +0200
Message-ID: <4ACBA5E7.3090000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217]:54023 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbZJFUJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2009 16:09:36 -0400
Received: by ewy17 with SMTP id 17so4320863ewy.39
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2009 13:08:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Besides keeping the line short, the second setting of the
MR_DMA_MODE bit was removed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Please review, maybe some other bit should be set?

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index f92da9f..5d2f148 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1857,7 +1857,9 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase
 #endif
 	/* KLL May need eop and parity in 53c400 */
 	if (hostdata->flags & FLAG_NCR53C400)
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR | MR_ENABLE_EOP_INTR | MR_DMA_MODE | MR_MONITOR_BSY);
+		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE |
+				MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR |
+				MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
 	else
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
 #endif				/* def REAL_DMA */
