From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
 2.6.14-rc1
Date: Thu, 15 Sep 2005 21:52:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509152133170.9589-100000@netrider.rowland.org>
References: <1126823917.4821.70.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:47372 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1161034AbVIPBwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 21:52:54 -0400
In-Reply-To: <1126823917.4821.70.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Thu, 15 Sep 2005, James Bottomley wrote:

> Well, I think the symptoms are racing scsi_remove_host() calls and the
> solution is to enforce the state model on removal (as in if the host is
> already in the remove state, don't try to remove it again).

You're forgetting something: Devices can be removed at any time, no matter
what state the host is in.  It's even possible for thread A to be removing
a device while thread B is removing the host.  The A thread will interfere
with the B thread, because the "list_for_each_entry_safe" loops in
scsi_forget_host and __scsi_remove_target _aren't_ safe against other
threads removing devices.  Also remember that the list pointers get
changed when a device is _released_, which can occur quite some time after
it is _removed_.

In short, those iterations must be carried out as in my patch.


> > I still do not understand as I asked in a previous comment why we are not
> > shutting down the eh_thread in scsi_remove_host and also why simpler state
> > model updates could not solve the problem.
> 
> Well, it goes back to whether we wait for the thread or not.  To shut
> the thread down, we also need to wait for it to complete.
> 
> As far as the state model goes, we either need to wait for the eh thread
> before transitioning to cancel or introduce the extra states that
> reflect the parallel eh transitions.

Agreed, one or the other of these is needed.  I think the parallel-states 
approach offers a little more flexibility.

> > I believe I also indicated that we could enhance scsi_error to shutdown
> > faster during this state which should only be a performance improvement.
> 
> Yes, we could ... patches?

During the DEL_RECOVERY state you could maybe make the error handler 
faster by removing the settle delays.  I'm not sure what else you can do 
-- all attempts at submitting commands will quickly fail.

During CANCEL_RECOVERY you may not want to speed up the error handler.  
In this state it needs to function normally, since there might be errors
during the cache-flush sequence or similar things (for non-forced
removal).


Finally, having said all that, it turns out there's still a bug in the 
2.6.14-rc1 code.  I feel pretty stupid about it -- you'll understand why 
when you read the patch below.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

--- a/drivers/scsi/scsi_sysfs.c	Mon Sep 12 23:12:09 2005
+++ b/drivers/scsi/scsi_sysfs.c	Thu Sep 15 21:32:27 2005
@@ -707,9 +707,11 @@
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	down(&sdev->host->scan_mutex);
+	struct Scsi_Host *shost = sdev->host;
+
+	down(&shost->scan_mutex);
 	__scsi_remove_device(sdev);
-	up(&sdev->host->scan_mutex);
+	up(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
 

