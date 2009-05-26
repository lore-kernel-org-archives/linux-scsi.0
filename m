From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Tue, 26 May 2009 16:09:59 -0500
Message-ID: <1243372199.2815.77.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905261508210.9278-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905261508210.9278-100000@iolanthe.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-05-26 at 15:29 -0400, Alan Stern wrote:
> On Tue, 26 May 2009, Kay Sievers wrote:
> 
> > On Mon, May 25, 2009 at 13:45, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > On Mon, May 25, 2009 at 04:06, Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > >> by the way -- so it's a little difficult to trigger.
> > >
> > > I can trigger it pretty reliable now on plain -rc7 , but only with
> > > more hubs in-between the storage device. It usually take less than
> > > 10-15 connect/disconnect cycles.
> > >
> > > It looks like a serious bug though, after the bug triggered, random,
> > > likely unrelated, applications crash, and I can not cleanly shot down
> > > anymore.
> > 
> > Just a heads up if anybody is trying to reproduce this, it trashed my
> > ext3 rootfs, which is not recoverable.
> > 
> > Not sure what exactly caused this, but I didn't have anything like
> > this for a very long time.
> > 
> > I tried to reproduce the issue a few times more, and it crashed random
> > processes after the bug triggered, like mentioned above, and the box
> > never shut down cleanly.
> > 
> > It's entirely possible, that bug causes serious issues.
> 
> If you don't mind trashing some more ext3 root filesystems :-) you can
> try this patch.  It's almost certainly not quite the right thing to do
> and I have probably messed up the target's reference counting, but
> maybe it's a step in the right direction.
> 
> This strange business of deferring unregistration into a workqueue 
> means that the calls might not be executed in the same order that 
> they're made.
> 
> Alan Stern
> 
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -956,6 +956,7 @@ static inline void scsi_destroy_sdev(str
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(&sdev->sdev_gendev);
> +	put_device(sdev->sdev_gendev.parent);
>  	put_device(&sdev->sdev_gendev);
>  }
>  
> Index: usb-2.6/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
> +++ usb-2.6/drivers/scsi/scsi_sysfs.c
> @@ -327,8 +327,6 @@ static void scsi_device_dev_release_user
>  		sdev->request_queue = NULL;
>  	}
>  
> -	scsi_target_reap(scsi_target(sdev));
> -
>  	kfree(sdev->inquiry);
>  	kfree(sdev);
>  
> @@ -954,6 +952,7 @@ void __scsi_remove_device(struct scsi_de
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
> +	scsi_target_reap(scsi_target(sdev));
>  	put_device(dev);
>  }

Um, well, you're right, it's wrong.  The reap needs to be matched with
the reap_ref++

It's hard to follow the problem without full context, but if I
understand correctly the problem is you want all the target directories
removed before you call device_del() on the host and the thing that gets
in the way is the necessary user context removal of the host.  So a
simple solution, rather than mucking with the way it works, is to wait
for the workqueues to complete.  Does this fix it?

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..5846c26 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1877,6 +1877,12 @@ void scsi_forget_host(struct Scsi_Host *shost)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * the sdev removal goes through a workqueue for user context, so
+	 * make sure it's all complete before we return
+	 */
+	flush_scheduled_work();
 }
 
 /*


