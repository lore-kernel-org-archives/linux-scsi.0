From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] Fix two potential mem leaks in MPT Fusion (mpt_attach())
Date: Thu, 2 Aug 2007 01:55:33 +0200
Message-ID: <200708020155.33690.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:45460 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXHAX5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 19:57:18 -0400
Received: by mu-out-0910.google.com with SMTP id i10so445638mue
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 16:57:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: DL-MPTFusionLinux@lsi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, support@lsi.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Greetings & Salutations,

The Coverity checker spotted two potential memory leaks in 
drivers/message/fusion/mptbase.c::mpt_attach().

There are two returns that may leak the storage allocated for 
'ioc' (sizeof(MPT_ADAPTER) bytes).
A simple fix would be to simply add two kfree() calls before 
the return statements, but a better fix (that this patch 
implements) is to reorder the code so that if we hit the first 
return condition we don't have to do the allocation at all and 
then just add a kfree() call for the second case.

Please consider applying.  Patch has been compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/message/fusion/mptbase.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e866dac..f9bb705 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1393,18 +1393,18 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
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
 
@@ -1413,6 +1413,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
+		kfree(ioc);
 		return r;
 	}
 



