From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 07/21] advansys: Remove ASC_WIDE_BOARD predicate
Date: Tue,  2 Oct 2007 21:55:28 -0400
Message-ID: <11913765422071-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:53899 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXJCBzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:45 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Replace it with !ASC_NARROW_BOARD

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
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
1.5.3.1

