From: akpm@linux-foundation.org
Subject: [patch 27/30] mpt-fusion: fix two potential mem leaks
Date: Fri, 10 Aug 2007 14:50:51 -0700
Message-ID: <200708102150.l7ALope8011401@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582AbXHJWBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jesper.juhl@gmail.com, Eric.Moore@lsil.com

From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted two potential memory leaks in
drivers/message/fusion/mptbase.c::mpt_attach().

There are two returns that may leak the storage allocated for 'ioc'
(sizeof(MPT_ADAPTER) bytes).

A simple fix would be to simply add two kfree() calls before the return
statements, but a better fix (that this patch implements) is to reorder the
code so that if we hit the first return condition we don't have to do the
allocation at all and then just add a kfree() call for the second case.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fusion-fix-two-potential-mem-leaks drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fusion-fix-two-potential-mem-leaks
+++ a/drivers/message/fusion/mptbase.c
@@ -1408,18 +1408,18 @@ mpt_attach(struct pci_dev *pdev, const s
 	struct proc_dir_entry *dent, *ent;
 #endif
 
+	if (mpt_debug_level)
+		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
+
+	if (pci_enable_device(pdev))
+		return r;
+
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-
 	ioc->debug_level = mpt_debug_level;
-	if (mpt_debug_level)
-		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
-
-	if (pci_enable_device(pdev))
-		return r;
 
 	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
@@ -1428,6 +1428,7 @@ mpt_attach(struct pci_dev *pdev, const s
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		kfree(ioc);
 		return r;
 	}
 
_
