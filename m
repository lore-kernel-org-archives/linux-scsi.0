From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH 2.6]  Add readX_relaxed to MPT Fusion driver
Date: Wed, 2 Jun 2004 23:24:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040603062439.GA59204@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:16185 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S261156AbUFCGZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2004 02:25:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: emoore@lsil.com

This patch makes use of readX_relaxed to improve PIO read
response times on platforms that define them (currently
SGI Altix :-), but it could be used in conjunction with the
PCI-X relaxed ordering attribute on another platform in the
future).

>From what I could see, there was only one PIO read in which
it was unsafe for the response to pass DMA write data, so
I made the default readX_relaxed.

jeremy


diff -ur -X /usr/people/jeremy/dontdiff linux-2.6.6/drivers/message/fusion/mptbase.c linux-2.6.7-rc1/drivers/message/fusion/mptbase.c
--- linux-2.6.6/drivers/message/fusion/mptbase.c	2004-05-28 23:14:11.000000000 -0700
+++ linux-2.6.7-rc1/drivers/message/fusion/mptbase.c	2004-05-27 16:48:09.000000000 -0700
@@ -282,7 +282,8 @@
 };
 MODULE_DEVICE_TABLE(pci, mptbase_pci_table);
 
-#define CHIPREG_READ32(addr) 		readl(addr)
+#define CHIPREG_READ32(addr) 		readl_relaxed(addr)
+#define CHIPREG_READ32_dmasync(addr)	readl(addr)
 #define CHIPREG_WRITE32(addr,val) 	writel(val, addr)
 #define CHIPREG_PIO_WRITE32(addr,val)	outl(val, (unsigned long)addr)
 #define CHIPREG_PIO_READ32(addr) 	inl((unsigned long)addr)
@@ -347,7 +348,7 @@
 	 */
 	while (1) {
 
-		if ((pa = CHIPREG_READ32(&ioc->chip->ReplyFifo)) == 0xFFFFFFFF)
+		if ((pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo)) == 0xFFFFFFFF)
 			return IRQ_HANDLED;
 
 		cb_idx = 0;
