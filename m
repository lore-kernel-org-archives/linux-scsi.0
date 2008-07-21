From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH] sym53c8xx_2: free luntbl in sym_hcb_free
Date: Mon, 21 Jul 2008 15:58:32 -0700
Message-ID: <20080721225832.GA4516@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:53668 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYGUW7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2008 18:59:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6LMrA2e027268
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2008 18:53:10 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6LMwrIf140794
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2008 16:58:53 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6LMwrUI010810
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2008 16:58:53 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch frees the luntbl dma area in sym_hcb_free if allocated.
Since the luntbl is part of a larger dma coherent area not freeing the
luntbl kept a 64k dma coherent area previous allocated through
dma_alloc_coherent allocated. This prevented a DLPAR remove IO 
operation from completing successfully.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-combined/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6-combined.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-07-21 13:38:56.000000000 -0400
+++ linux-2.6-combined/drivers/scsi/sym53c8xx_2/sym_hipd.c	2008-07-21 16:06:58.000000000 -0400
@@ -5741,6 +5741,8 @@
 
 	for (target = 0; target < SYM_CONF_MAX_TARGET ; target++) {
 		tp = &np->target[target];
+		if (tp->luntbl)
+			sym_mfree_dma(tp->luntbl, 256, "LUNTBL");
 #if SYM_CONF_MAX_LUN > 1
 		kfree(tp->lunmp);
 #endif 
