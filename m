From: Christoph Hellwig <hch@lst.de>
Subject: Re: drop scsi_register_blocked_host() in 2.5?
Date: Fri, 21 Feb 2003 23:52:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030221235210.C30977@lst.de>
References: <3E557FD5.5080708@torque.net> <20030221235031.A30977@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030221235031.A30977@lst.de>; from hch@lst.de on Fri, Feb 21, 2003 at 11:50:31PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2003 at 11:50:31PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 21, 2003 at 12:24:37PM +1100, Douglas Gilbert wrote:
> > Just doing some documentation and noticed these two functions:
> >    - scsi_register_blocked_host()
> >    - scsi_deregister_blocked_host()
> > that return void and do nothing. See scsi_lib.c around line 1344
> > for Eric's comment. These functions are exported and the
> > eata and u14-34f drivers call them.
> > 
> > Time for Christoph's razor?
> 
> How does this patch look?

Probably not good as I attached the wrong patch..


--- 1.27/drivers/scsi/eata.c	Tue Feb 11 15:51:57 2003
+++ edited/drivers/scsi/eata.c	Fri Feb 21 23:27:14 2003
@@ -1228,7 +1228,6 @@
       sh[j]->unchecked_isa_dma = FALSE;
    else {
       unsigned long flags;
-      scsi_register_blocked_host(sh[j]);
       sh[j]->unchecked_isa_dma = TRUE;
 
       flags=claim_dma_lock();
@@ -2352,8 +2351,6 @@
 
    if (sh[j] == NULL) panic("%s: release, invalid Scsi_Host pointer.\n",
                             driver_name);
-
-   if(sh[j]->unchecked_isa_dma) scsi_deregister_blocked_host(sh[j]);
 
    for (i = 0; i < sh[j]->can_queue; i++)
       if ((&HD(j)->cp[i])->sglist) kfree((&HD(j)->cp[i])->sglist);
--- 1.55/drivers/scsi/hosts.h	Fri Feb 21 15:57:24 2003
+++ edited/drivers/scsi/hosts.h	Fri Feb 21 23:27:46 2003
@@ -515,8 +515,6 @@
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
-extern void scsi_register_blocked_host(struct Scsi_Host *);
-extern void scsi_deregister_blocked_host(struct Scsi_Host *);
 
 static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
 {
--- 1.71/drivers/scsi/scsi_lib.c	Fri Feb 21 15:57:25 2003
+++ edited/drivers/scsi/scsi_lib.c	Fri Feb 21 23:27:58 2003
@@ -1340,23 +1340,6 @@
 	}
 }
 
-/*
- * FIXME(eric) - these are empty stubs for the moment.  I need to re-implement
- * host blocking from scratch. The theory is that hosts that wish to block
- * will register/deregister using these functions instead of the old way
- * of setting the wish_block flag.
- *
- * The details of the implementation remain to be settled, however the
- * stubs are here now so that the actual drivers will properly compile.
- */
-void scsi_register_blocked_host(struct Scsi_Host * shost)
-{
-}
-
-void scsi_deregister_blocked_host(struct Scsi_Host * shost)
-{
-}
-
 int __init scsi_init_queue(void)
 {
 	int i;
--- 1.27/drivers/scsi/scsi_syms.c	Mon Feb 10 23:25:47 2003
+++ edited/drivers/scsi/scsi_syms.c	Fri Feb 21 23:27:39 2003
@@ -74,8 +74,6 @@
 
 EXPORT_SYMBOL(scsi_io_completion);
 
-EXPORT_SYMBOL(scsi_register_blocked_host);
-EXPORT_SYMBOL(scsi_deregister_blocked_host);
 EXPORT_SYMBOL(scsi_slave_attach);
 EXPORT_SYMBOL(scsi_slave_detach);
 EXPORT_SYMBOL(scsi_device_get);
--- 1.23/drivers/scsi/u14-34f.c	Wed Feb 12 11:56:04 2003
+++ edited/drivers/scsi/u14-34f.c	Fri Feb 21 23:27:28 2003
@@ -905,7 +905,6 @@
       }
    else {
       unsigned long flags;
-      scsi_register_blocked_host(sh[j]);
       sh[j]->unchecked_isa_dma = TRUE;
 
       flags=claim_dma_lock();
@@ -1910,8 +1909,6 @@
 
    if (sh[j] == NULL) panic("%s: release, invalid Scsi_Host pointer.\n",
                             driver_name);
-
-   if(sh[j]->unchecked_isa_dma) scsi_deregister_blocked_host(sh[j]);
 
    for (i = 0; i < sh[j]->can_queue; i++)
       if ((&HD(j)->cp[i])->sglist) kfree((&HD(j)->cp[i])->sglist);
