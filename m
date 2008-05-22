From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH] sym53c8xx_2: free luntbl in sym_hcb_free
Date: Thu, 22 May 2008 09:42:52 -0700
Message-ID: <20080522164252.4256.35795.stgit@desktop-andmike.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36861 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbYEVQnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2008 12:43:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4MGjH6a015303
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 12:45:17 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4MGgsq7157772
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 12:42:54 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4MGgs3s008357
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 12:42:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

This patch frees the luntbl dma area in sym_hcb_free if allocated.
Since the luntbl is part of a larger dma coherent area not freeing the
luntbl kept a 64k dma coherent area previous allocated through
dma_alloc_coherent allocated. This prevented a DLPAR remove IO
operation from completing sucessfully.

Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 22a6aae..98df165 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5741,6 +5741,8 @@ void sym_hcb_free(struct sym_hcb *np)
 
 	for (target = 0; target < SYM_CONF_MAX_TARGET ; target++) {
 		tp = &np->target[target];
+		if (tp->luntbl)
+			sym_mfree_dma(tp->luntbl, 256, "LUNTBL");
 #if SYM_CONF_MAX_LUN > 1
 		kfree(tp->lunmp);
 #endif 

