From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bug in SCSI async probing
Date: Tue, 26 May 2009 14:34:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905261347570.9278-100000@iolanthe.rowland.org>
References: <1243352063.2815.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757009AbZEZSe7@vger.kernel.org>
In-Reply-To: <1243352063.2815.34.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 May 2009, James Bottomley wrote:

> On Tue, 2009-05-26 at 11:22 -0400, Alan Stern wrote:
> > James & Arjan:
> > 
> > Am I missing something here?  It looks like
> > 
> > 	fastboot: make scsi probes asynchronous
> > 
> > has introduced a bug in the sd probing code.  AFAICT, there is now
> > nothing to prevent do_scan_async() from returning before
> > sd_probe_async() has run.
> 
> True, but this isn't really a problem.

Why not?  I'd say an oops is a problem.  :-)

> > Doesn't this mean that there's nothing to prevent sd_remove() from 
> > being called and trying to unregister the disk _before_ 
> > sd_probe_async() has managed to register it?
> 
> Yes, we've been discussing this ... most of the removal functions now
> need async_synchronize calls to mitigate this type of race.

Such as this?


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1866,6 +1866,12 @@ void scsi_forget_host(struct Scsi_Host *
 	struct scsi_device *sdev;
 	unsigned long flags;
 
+	/*
+	 * Don't try to get rid of this host's devices until all the async
+	 * probing is finished.
+	 */
+	async_synchronize_full();
+
  restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {



(Which reminds me...  Are the calls in wait_scan_init() really enough?  
wait_for_device_probe() does async_synchronize_full() and then
scsi_complete_async_scans() finishes the SCSI scanning.  But if this
scanning involves calling sd_probe(), then more async work will be
queued.  Maybe a second call to wait_for_device_probe() is needed.)

There's still more; the patch above isn't sufficient.  What happens if
the "device_add(&sdkp->dev)" call in sd_probe_async() fails?  Then in
sd_remove(), sdkp will be NULL and &sdkp->dev will be meaningless.  The 
device_del() call will crash and the actual scsi_disk structure will be 
leaked.  This could be fixed by moving the dev_set_drvdata() call from 
the end of sd_probe_async() back into sd_probe(), but then we'd find 
sd_remove trying to unregister a device which was never successfully 
registered.

And why is it that the "out_free_index:" code in sd_probe() acquires 
sd_index_lock but the corresponding code in sd_probe_async() doesn't?

Alan Stern
