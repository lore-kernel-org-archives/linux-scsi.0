From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Thu, 03 Oct 2002 08:46:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210031246.g93CkLF02116@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id FAA11811
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 05:46:30 -0700
Received: from localhost.localdomain (midgard.sc.steeleye.com [172.17.6.40])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id FAA11722
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 05:46:28 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g93CkLF02116
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 08:46:21 -0400
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 02 Oct 2002 18:18:37 EDT." <20021002221837.GB30503@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Go look at the QUEUE_FULL handler in the aic7xxx_old driver.  This is
> how  most/all reasonably well written drivers handle queue depth
> adjustments.   Trust me, they don't go around adjusting the depth all
> the time.  Most of  the time there will be one initial adjustment,
> then maybe one more  adjustment as we lock it down to the max upper
> limit when one exists, the  rest of the time we just handle the
> occasional random queue depth  QUEUE_FULL messages as exactly that and
> only temporarily freeze the queue  to let the drive get some work
> done. 

OK, I spent a nice evening doing this (do I get brownie points?).  I see your 
algorithm is roughly lower the depth after 14 queue fulls and assume that luns 
of the same pun need to be treated equivalently.

I failed entirely to find how the queue depth is increased (no brownie points 
here).  How is that done?

> The mid layer simply does not have access to the info needed to do
> what  you are talking about.  Let me give you an example from the
> aic7xxx  driver.  On this card we have a sequencer that handles the
[...]
> how we avoid the random flip flops of queue depth that you were
> worried about earlier. 

Yes, many HBAs have internal "issue" queues where commands wait before being 
placed on the bus.  I was assuming, however, that when a HBA driver got QUEUE 
FULL, it would traverse the issue queue and respond QUEUE FULL also to all 
pending commands for that device.  The mid-layer should thus see a succession 
of QUEUE FULLs for the device (we even have a nice signature for this because 
the QUEUE FULL occurs while device_blocked is set).  However, as long as it 
can correctly recognise this, it knows that when the last QUEUE FULL is 
through it has the true device queue depth, doesn't it?

> Now, what can be moved to the mid layer, and is on my list to do, is a
>  generic interface for coming up with the proper action after a
> QUEUE_FULL.   Currently, each driver not only determines the real
> depth, but then also  does it's own magic to tell if it's a random
> event or a hard limit.  It  would be easy to add something like
> scsi_notify_queue_full(sdev, count);  where scsi_notify_queue_full()
> would keep track of the last queue full  depth, etc.  Let the low
> level driver come up with the accurate count,  then they can use this
> function to determine what to do about it.  On any  change to queue
> depth, the function can return the amount of commands to  add/
> subtract, then the low level driver can adjust it's own internal
> structure counts and also call scsi_adjust_queue_depth() to have the
> mid  layer do likewise.  BTW, I'll change the adjust_queue_depth code
> to make  it immediately adjust the depth down when possible and do
> lazy increases  so that hitting a hard limit will free up resources
> immediately, but that  will go with making the commands linked list
> based so that it can simply  do a while(sdev->queue_depth > sdev->
> new_queue_depth &&  list_not_empty(sdev->free_list)) {
> kfree(get_list_head(sdev->free_list));  sdev->queue_depth--; }  

I'll go for this.  That would address my main concern which is a proliferation 
of individual queue full handling algorithms in the LLDs. (and it's better 
than teaching the mid-layer about QUEUE FULL sequences).

> Well, all the device drivers that implement queue depth adjustments at
> all  already do it themselves, so my proposed method is better than
> what we  currently have since it at least allows them to move the
> decide  disposition stuff into a library call or they can do it
> themselves.

Fair enough.

James






