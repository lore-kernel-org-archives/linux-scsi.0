From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Fri, 08 Jul 2011 12:04:26 -0500
Message-ID: <1310144667.3282.94.camel@mulgrave>
References: <Pine.LNX.4.44L0.1107071653010.1687-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41725 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab1GHREc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 13:04:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.1107071653010.1687-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland Dreier <roland@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Thu, 2011-07-07 at 17:07 -0400, Alan Stern wrote:
> On Thu, 7 Jul 2011, James Bottomley wrote:
> 
> > > Perhaps this means the elevator shouldn't be freed until the queue is.  
> > > I just don't know.  Jens and James are the experts, but Jens hasn't
> > > said anything and James is currently busy.
> > 
> > OK, back from being busy now (for a short while).
> > 
> > This is what I think should fix it all (at least it fixes it for me now
> > I've finally figured out how to reproduce it).
> > 
> > The nasty about this is that blk_get_request() has to return NULL even
> > if __GFP_WAIT is specified, if the queue is already dead.  Lots of block
> > users don't check for NULL if they specify __GFP_WAIT.
> 
> There are a few things here you might be able to explain.
> 
> First, after blk_cleanup_queue() is called, whose responsibility is it
> to make sure that no more requests can be added to the queue: the block
> layer or the client (in this case the SCSI layer)?  Your patch implies
> that the block layer is responsible; is this documented anywhere?  Or
> if it isn't, does Jens agree?

So when I asked Jens, he agreed block.  The problem we've been running
into is that the teardown state (QUEUE_FLAG_DEAD) isn't really checked
where it should be, so the early teardown SCSI now does runs into a lot
of these missing checks.

> Second, there isn't any synchronization between __scsi_remove_device()
> and scsi_prep_fn().  Isn't it still possible that a request will get
> added to the queue and processed after queuedata has been set to NULL,
> leading to another invalid memory access?  Isn't a NULL check still 
> needed in scsi_prep_fn()?

only in the REQ_TYPE_BLOCK_PC case. The theory is that before we tear
down the queue, we've waited for the ULD detach to occur, so none of the
ULD prep functions need check.

However, that does beg the question of why sr is using the device after
sr_remove() has completed.  That seems to be because of the block ops
being the dominant structure, so we try to do cleanup when we get the
block release rather than the driver release ... that looks to be the
root cause to me.

> Third, do you recall the reason (if any) for freeing the queue in 
> __scsi_remove_device() rather than 
> scsi_device_dev_release_usercontext()?  At that point, you can be quite 
> sure no more requests will be added to the queue.

Yes, it was to get early teardown of the queue.  I've forgotten the
specific bug, but it's somewhere in bugzilla.  There was an oops because
the queue was still running.

James


