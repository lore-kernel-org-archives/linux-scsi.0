From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Fusion: Call pci_set_mwi()
Date: Fri, 13 Oct 2006 10:24:52 -0600
Message-ID: <20061013162452.GB11633@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54177 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751723AbWJMQYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:24:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org


Hi Eric,

Even though the 1030 is a PCI-X device, it can still be plugged into a PCI
bus, and end up operating in PCI mode.  According to the documentation,
it will benefit from using MWI and MRM commands, but in order to do so
under Linux, we need to call pci_set_mwi(), which is what this patch does.
Please apply.

P.S. The if condition is just to avoid the warning from __must_check.
Most device drivers do need to check and adjust their internal flags if
it fails, but according to the 1030 manual, the chip automatically
decides when to use MWI.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 29d0635..d301a67 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1153,6 +1153,9 @@ #endif
 	if (pci_enable_device(pdev))
 		return r;
 
+	if (pci_set_mwi(pdev))
+		/* We don't have to do anything if it fails */;
+
 	dinitprintk((KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {

