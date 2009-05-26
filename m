From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Tue, 26 May 2009 15:29:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905261508210.9278-100000@iolanthe.rowland.org>
References: <ac3eb2510905260927we3c748akbbcaf3f3ac1da096@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41762 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756175AbZEZT3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 15:29:38 -0400
In-Reply-To: <ac3eb2510905260927we3c748akbbcaf3f3ac1da096@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Tue, 26 May 2009, Kay Sievers wrote:

> On Mon, May 25, 2009 at 13:45, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Mon, May 25, 2009 at 04:06, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> >> by the way -- so it's a little difficult to trigger.
> >
> > I can trigger it pretty reliable now on plain -rc7 , but only with
> > more hubs in-between the storage device. It usually take less than
> > 10-15 connect/disconnect cycles.
> >
> > It looks like a serious bug though, after the bug triggered, random,
> > likely unrelated, applications crash, and I can not cleanly shot down
> > anymore.
> 
> Just a heads up if anybody is trying to reproduce this, it trashed my
> ext3 rootfs, which is not recoverable.
> 
> Not sure what exactly caused this, but I didn't have anything like
> this for a very long time.
> 
> I tried to reproduce the issue a few times more, and it crashed random
> processes after the bug triggered, like mentioned above, and the box
> never shut down cleanly.
> 
> It's entirely possible, that bug causes serious issues.

If you don't mind trashing some more ext3 root filesystems :-) you can
try this patch.  It's almost certainly not quite the right thing to do
and I have probably messed up the target's reference counting, but
maybe it's a step in the right direction.

This strange business of deferring unregistration into a workqueue 
means that the calls might not be executed in the same order that 
they're made.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -956,6 +956,7 @@ static inline void scsi_destroy_sdev(str
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(sdev->sdev_gendev.parent);
 	put_device(&sdev->sdev_gendev);
 }
 
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -327,8 +327,6 @@ static void scsi_device_dev_release_user
 		sdev->request_queue = NULL;
 	}
 
-	scsi_target_reap(scsi_target(sdev));
-
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -954,6 +952,7 @@ void __scsi_remove_device(struct scsi_de
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+	scsi_target_reap(scsi_target(sdev));
 	put_device(dev);
 }
 

