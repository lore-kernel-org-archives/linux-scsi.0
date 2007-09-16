From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 07/17] advansys: Remove ASC_WIDE_BOARD predicate
Date: Sun, 16 Sep 2007 09:37:38 -0600
Message-ID: <11899570693465-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52608 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXIPPhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:38 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Replace it with !ASC_NARROW_BOARD

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 5e6bcf2..a5bb4e4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2232,7 +2232,6 @@ do { \
 #define ASC_IS_WIDE_BOARD       0x04	/* AdvanSys Wide Board */
 
 #define ASC_NARROW_BOARD(boardp) (((boardp)->flags & ASC_IS_WIDE_BOARD) == 0)
-#define ASC_WIDE_BOARD(boardp)   ((boardp)->flags & ASC_IS_WIDE_BOARD)
 
 #define NO_ISA_DMA              0xff	/* No ISA DMA Channel Used */
 
@@ -4385,7 +4384,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	/*
 	 * Display Wide Board BIOS Information.
 	 */
-	if (ASC_WIDE_BOARD(boardp)) {
+	if (!ASC_NARROW_BOARD(boardp)) {
 		cp = boardp->prtbuf;
 		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
 		BUG_ON(cplen >= ASC_PRTBUF_SIZE);
@@ -14432,7 +14431,7 @@ static int advansys_release(struct Scsi_Host *shost)
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
-	if (ASC_WIDE_BOARD(boardp)) {
+	if (!ASC_NARROW_BOARD(boardp)) {
 		iounmap(boardp->ioremap_addr);
 		advansys_wide_free_mem(boardp);
 	}
-- 
1.5.2.4

