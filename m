From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] Fix 2.4 bounce_limit decl
Date: Tue, 30 Dec 2003 15:49:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312301549.46786.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:35807 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S265880AbTL3Wtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2003 17:49:52 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Here's another bit from the ia64 patch.  ia64 doesn't define dma64_addr_t.

There was a discussion about whether ia64 is doing the Right Thing by
not defining dma64_addr_t:
    http://www.gelato.unsw.edu.au/linux-ia64/0112/2521.html
The eventual resolution was that we need not define it because it
is only used for pci_dac_*, and there's no need for those interfaces
on ia64 because dma_addr_t is 64 bits.

Bjorn


diff -urN linux-2.4/drivers/scsi/scsi_merge.c linux-ia64-2.4/drivers/scsi/scsi_merge.c
--- linux-2.4/drivers/scsi/scsi_merge.c	2003-12-29 17:05:42.000000000 -0700
+++ linux-ia64-2.4/drivers/scsi/scsi_merge.c	2003-12-29 17:06:33.000000000 -0700
@@ -1155,7 +1155,7 @@
 {
 	struct Scsi_Host *SHpnt = SDpnt->host;
 	request_queue_t *q = &SDpnt->request_queue;
-	dma64_addr_t bounce_limit;
+	u64 bounce_limit;
 
 	/*
 	 * If this host has an unlimited tablesize, then don't bother with a

