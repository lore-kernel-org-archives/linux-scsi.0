From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] gdth buggy page mapping
Date: Tue, 23 Nov 2004 20:13:21 +0100
Message-ID: <20041123191321.GL13174@suse.de>
References: <20041123180622.GK13174@suse.de> <1101235504.2016.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56007 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261503AbUKWTNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 14:13:53 -0500
Content-Disposition: inline
In-Reply-To: <1101235504.2016.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, achim_leubner@adaptec.com

On Tue, Nov 23 2004, James Bottomley wrote:
> Actually, this:
> 
> On Tue, 2004-11-23 at 12:06, Jens Axboe wrote:
> > @@ -2717,8 +2716,8 @@
> >      if (scp->use_sg) {
> >          sl = (struct scatterlist *)scp->request_buffer;
> >  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
> > -        sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,PCI_DMA_FROMDEVICE);
> > -        for (i=0,cpsum=0; i<sgcnt; ++i,++sl) {
> > +        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
> > +	    unsigned long flags;
> >              cpnow = (ushort)sg_dma_len(sl);
> 
> Won't quite work any more.  On most platforms, it will since
> sg_dma_len(sl) expands to sl->length which is the correct thing. 
> However, on some, like parisc, x86_64, ppc64 it will expand to a
> different parameter which won't get filled in if the dma mapping is

Ah yes, I forgot that some have a different output length. I guess an
open coded ->length would work best then.

> never done.  I think all use of the sg_dma_ macros in this driver will
> need modifying with this change.

How so? It's internal usage in that function, it needs a one-liner to
work.

===== drivers/scsi/gdth.c 1.44 vs edited =====
--- 1.44/drivers/scsi/gdth.c	2004-10-01 04:44:10 +02:00
+++ edited/drivers/scsi/gdth.c	2004-11-23 20:13:04 +01:00
@@ -2708,7 +2708,6 @@
     ushort cpsum,cpnow;
     struct scatterlist *sl;
     gdth_ha_str *ha;
-    int sgcnt;
     char *address;
 
     cpcount = count<=(ushort)scp->bufflen ? count:(ushort)scp->bufflen;
@@ -2717,9 +2716,9 @@
     if (scp->use_sg) {
         sl = (struct scatterlist *)scp->request_buffer;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
-        sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,PCI_DMA_FROMDEVICE);
-        for (i=0,cpsum=0; i<sgcnt; ++i,++sl) {
-            cpnow = (ushort)sg_dma_len(sl);
+        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
+	    unsigned long flags;
+            cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
                           cpnow,cpsum,cpcount,(ushort)scp->bufflen));
             if (cpsum+cpnow > cpcount) 
@@ -2730,17 +2729,18 @@
                        hanum);
                 return;
             }
-            address = (char *)(page_address(sl->page) + sl->offset);
+	    local_irq_save(flags);
+	    address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
             memcpy(address,buffer,cpnow);
+	    flush_dcache_page(sl->page);
+	    kunmap_atomic(address, KM_BIO_SRC_IRQ);
+	    local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
             buffer += cpnow;
         }
-        pci_unmap_sg(ha->pdev,scp->request_buffer,
-                     scp->use_sg,PCI_DMA_FROMDEVICE);
 #else
-        sgcnt = scp->use_sg;
-        for (i=0,cpsum=0; i<sgcnt; ++i,++sl) {
+        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
             cpnow = (ushort)sl->length;
             TRACE(("copy_internal() now %d sum %d count %d %d\n",
                           cpnow,cpsum,cpcount,(ushort)scp->bufflen));

-- 
Jens Axboe

