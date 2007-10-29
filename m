From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Mon, 29 Oct 2007 11:18:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710291107180.4550-200000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="=-eBrn8utCVnnjNZnrza9u"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57863 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752300AbXJ2PSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 11:18:38 -0400
Content-ID: <Pine.LNX.4.44L0.0710291107181.4550@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--=-eBrn8utCVnnjNZnrza9u
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44L0.0710291107182.4550@iolanthe.rowland.org>

James:

With regard to the discussion below, is there any objection to the 
attached patch?  It moves the call to scsi_release_queue() from 
scsi_device_dev_release_usercontext() to __scsi_remove_device().  In 
fact, it might turn out that with this change, the extra _usercontext 
routine isn't needed at all.

As far as I can see, the only reason for not adopting this patch would 
be if a scsi_device's queue structure was needed even after the 
scsi_device was unregistered.  Does this ever happen?  If it does, it 
would be indicative of a nasty reference-loop problem (scsi_device 
needs reference to request_queue, request_queue holds reference to 
gendisk, gendisk holds reference to scsi_device).

Alan Stern


---------- Forwarded message ----------
Date: Tue, 23 Oct 2007 13:27:49 +0200
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
     Kernel development list <linux-kernel@vger.kernel.org>,
     Hannes Reinecke <hare@suse.de>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
    devices

On Tue, 2007-10-23 at 00:14 -0400, Alan Stern wrote:
> On Tue, 23 Oct 2007, Kay Sievers wrote:
> 
> > There must be something going wrong with the block patch in conjunction
> > with the crazy SCSI release logic.
> 
> I don't know -- there's nothing obviously wrong with the block patch 
> except the extra put_device.  But you're right that the SCSI logic is 
> crazy.  The scsi_device is the parent of the gendisk, which is the 
> parent of the request_queue.  But the scsi_device holds a reference to 
> the request_queue, which is dropped in the scsi_device's release 
> routine!

That's the thing. We see a circular reference when we use the SCSI LUN
as the parent.
The sysfs relationship is: scsi_device -> genhd -> queue, while the
queue holds a ref to to the blockdev (parent), the blockdev to the
scsi_device (parent) and the scsi_devices to the queue (SCSI). All
waiting for their release functions to be called, to release the other
refs.

The scsi_device needs to drop the queue reference while the device is
removed, not when it's data is released. Hannes came up with the
attached patch, which seems to work fine here.

> That doesn't make much sense to me, and it is complicated by 
> the fact that deleting a kobject doesn't drop the kobject's reference 
> to its parent -- only releasing the kobject does.

Right, that makes things very complicated.

> In fact, for my development work I normally use a patch which makes 
> kobjects behave better: They do drop the reference to their parent when 
> they are deleted.  This actually is nothing more than a reversion of a 
> patch added several years ago to try and cover up some of the 
> weaknesses of the SCSI stack!  Now that the SCSI stack is in better 
> shape, maybe my patch should be included in the mainstream kernel.  The 
> patch is below; see what you think.

Sounds good to me, to disconnect a dead object from its parent when it's
deleted. We only need to protect for "use after free" but not lock the
parent, I guess. We should give it a try.

Thanks,
Kay

--=-eBrn8utCVnnjNZnrza9u
Content-Type: TEXT/X-PATCH; NAME="scsi-sysfs-drop-queue-ref-on-remove.patch"; CHARSET=UTF-8
Content-ID: <Pine.LNX.4.44L0.0710291107183.4550@iolanthe.rowland.org>
Content-Description: 
Content-Disposition: INLINE; FILENAME="scsi-sysfs-drop-queue-ref-on-remove.patch"

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c


index daed37d..577bbf3 100644


--- a/drivers/scsi/scsi_sysfs.c


+++ b/drivers/scsi/scsi_sysfs.c


@@ -280,15 +280,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)


 	list_del(&sdev->starved_entry);


 	spin_unlock_irqrestore(sdev->host->host_lock, flags);


 


-	if (sdev->request_queue) {


-		sdev->request_queue->queuedata = NULL;


-		/* user context needed to free queue */


-		scsi_free_queue(sdev->request_queue);


-		/* temporary expedient, try to catch use of queue lock


-		 * after free of sdev */


-		sdev->request_queue = NULL;


-	}


-


 	scsi_target_reap(scsi_target(sdev));


 


 	kfree(sdev->inquiry);


@@ -799,6 +790,16 @@ void __scsi_remove_device(struct scsi_device *sdev)


 	if (sdev->host->hostt->slave_destroy)


 		sdev->host->hostt->slave_destroy(sdev);


 	transport_destroy_device(dev);


+


+	if (sdev->request_queue) {


+		sdev->request_queue->queuedata = NULL;


+		/* user context needed to free queue */


+		scsi_free_queue(sdev->request_queue);


+		/* temporary expedient, try to catch use of queue lock


+		 * after free of sdev */


+		sdev->request_queue = NULL;


+	}


+


 	put_device(dev);


 }


 



--=-eBrn8utCVnnjNZnrza9u--
