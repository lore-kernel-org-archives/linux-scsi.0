From: Berkley Shands <berkley@cs.wustl.edu>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple map/unmaps
Date: Wed, 7 Jan 2004 10:33:08 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401071633.i07GX8U0000021336@mudpuddle.cs.wustl.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cliff.cse.wustl.edu ([128.252.166.5]:41150 "EHLO
	cliff.cse.wustl.edu") by vger.kernel.org with ESMTP id S266272AbUAGQdX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 11:33:23 -0500
List-Id: linux-scsi@vger.kernel.org
To: berkley@cs.wustl.edu, davem@redhat.com
Cc: gibbs@scsiguy.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

	Here is a somewhat more robust (and trivial) fix for the sg iommu
problem on the x86_64. Still does not correct the sg list modification logic though :-)

--- /raid0/kernels/linux/arch/x86_64/kernel/pci-gart.c  2004-01-05 10:16:11.000000000 -0600
+++ pci-gart.c  2004-01-07 10:14:47.000000000 -0600
@@ -446,6 +446,16 @@
                return 0;
        out = 0;
        start = 0;
+
+       /* see if we are recovering from an error */
+
+       if (sg[0].oldlength) {
+               printk(KERN_WARNING "Recovering sg list for %s\n", dev->slot_name);
+               for (i = 0; i < nents; i++) {
+                       sg[i].length = sg[i].oldlength;
+                       }
+               }
+
        for (i = 0; i < nents; i++) {
                struct scatterlist *s = &sg[i];
                dma_addr_t addr = page_to_phys(s->page) + s->offset;
@@ -453,6 +463,7 @@
                BUG_ON(s->length == 0); 
 
                size += s->length; 
+               s->oldlength = s->length;
 
                /* Handle the previous not yet processed entries */
                if (i > start) {

--- /raid0/kernels/linux/include/asm-x86_64/scatterlist.h       2003-12-17 20:59:39.000000000 -0600
+++ scatterlist.h       2004-01-07 10:01:06.000000000 -0600
@@ -5,6 +5,7 @@
     struct page                *page;
     unsigned int       offset;
     unsigned int       length;
+    unsigned int       oldlength;
     dma_addr_t         dma_address;
 };


berkley
