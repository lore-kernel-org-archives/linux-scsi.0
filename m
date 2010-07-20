From: akpm@linux-foundation.org
Subject: [patch 05/27] NCR5380: bit MR_DMA_MODE set twice in NCR5380_transfer_dma()
Date: Tue, 20 Jul 2010 15:28:45 -0700
Message-ID: <201007202228.o6KMSjKo021721@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932846Ab0GTW3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:29:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk

From: Roel Kluin <roel.kluin@gmail.com>

Besides keeping the line short, the second setting of the MR_DMA_MODE bit
was removed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/NCR5380.c~ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma
+++ a/drivers/scsi/NCR5380.c
@@ -1857,7 +1857,9 @@ static int NCR5380_transfer_dma(struct S
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
_
