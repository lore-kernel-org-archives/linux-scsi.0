From: akpm@linux-foundation.org
Subject: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 14:48:41 -0700
Message-ID: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757282AbYC1VtR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp

From: Andrew Morton <akpm@linux-foundation.org>

powerpc:

drivers/scsi/initio.c: In function 'initio_build_scb':
drivers/scsi/initio.c:2585: warning: large integer implicitly truncated to unsigned type

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/initio.c~drivers-scsi-initioc-suppress-compile-warning drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~drivers-scsi-initioc-suppress-compile-warning
+++ a/drivers/scsi/initio.c
@@ -2582,7 +2582,11 @@ static void initio_build_scb(struct init
 	dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->sense_buffer,
 				  SENSE_SIZE, DMA_FROM_DEVICE);
 	cblk->senseptr = cpu_to_le32((u32)dma_addr);
-	cblk->senselen = cpu_to_le32(SENSE_SIZE);
+	/*
+	 * The below needs casting to avoid a "large integer implicitly
+	 * truncated to unsigned type" warning on powerpc
+	 */
+	cblk->senselen = (u8)cpu_to_le32(SENSE_SIZE);
 	cmnd->SCp.ptr = (char *)(unsigned long)dma_addr;
 	cblk->cdblen = cmnd->cmd_len;
 
_
