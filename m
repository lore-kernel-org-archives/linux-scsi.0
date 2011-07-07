From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Thu, 7 Jul 2011 17:07:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107071653010.1687-100000@iolanthe.rowland.org>
References: <1310071540.3282.71.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52471 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751943Ab1GGVHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2011 17:07:39 -0400
In-Reply-To: <1310071540.3282.71.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <roland@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Thu, 7 Jul 2011, James Bottomley wrote:

> > Perhaps this means the elevator shouldn't be freed until the queue is.  
> > I just don't know.  Jens and James are the experts, but Jens hasn't
> > said anything and James is currently busy.
> 
> OK, back from being busy now (for a short while).
> 
> This is what I think should fix it all (at least it fixes it for me now
> I've finally figured out how to reproduce it).
> 
> The nasty about this is that blk_get_request() has to return NULL even
> if __GFP_WAIT is specified, if the queue is already dead.  Lots of block
> users don't check for NULL if they specify __GFP_WAIT.

There are a few things here you might be able to explain.

First, after blk_cleanup_queue() is called, whose responsibility is it
to make sure that no more requests can be added to the queue: the block
layer or the client (in this case the SCSI layer)?  Your patch implies
that the block layer is responsible; is this documented anywhere?  Or
if it isn't, does Jens agree?

Second, there isn't any synchronization between __scsi_remove_device()
and scsi_prep_fn().  Isn't it still possible that a request will get
added to the queue and processed after queuedata has been set to NULL,
leading to another invalid memory access?  Isn't a NULL check still 
needed in scsi_prep_fn()?

Third, do you recall the reason (if any) for freeing the queue in 
__scsi_remove_device() rather than 
scsi_device_dev_release_usercontext()?  At that point, you can be quite 
sure no more requests will be added to the queue.

Alan Stern

