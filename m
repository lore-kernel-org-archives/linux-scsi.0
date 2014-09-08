From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
Date: Mon, 8 Sep 2014 13:42:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409081335450.1433-100000@iolanthe.rowland.org>
References: <1410191478.2027.28.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49471 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751962AbaIHRmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 13:42:45 -0400
In-Reply-To: <1410191478.2027.28.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Shirish Pargaonkar <shirishpargaonkar@gmail.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Mon, 8 Sep 2014, James Bottomley wrote:

> > Jens and James, it appears the problem is in blk_register_queue().  The 
> > code does this:
> > 
> > 	/*
> > 	 * Initialization must be complete by now.  Finish the initial
> > 	 * bypass from queue allocation.
> > 	 */
> > 	queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
> > 	blk_queue_bypass_end(q);
> > 
> > This doesn't work well if the queue is unregistered later and then
> > registered again -- which is what happens when the sd driver is unbound
> > from a device and then bound again.  It looks like the code should be:
> > 
> > 	if (!queue_flag_test_and_set(QUEUE_FLAG_INIT_DONE, q))
> > 		blk_queue_bypass_end(q);
> > 
> > Do you agree?  If so, I'll send in patch.
> 
> This looks like a nasty hack.  In theory the QUEUE_FLAG_INIT_DONE should
> be unset on blk_unregister_queue() to match the teardown; it's only
> accident it isn't.  del_gendisk() in sd_remove() is supposed to tear a
> lot of queue stuff down.

It's not clear what the operative assumptions are.  The comment in
blk_register_queue() implies that bypass is active only because it was
set up that way when the queue was created.  The fact that
blk_unregister_queue() doesn't call blk_queue_bypass_start() seems to
support this view -- although it could also be a simple oversight.

Hopefully Tejun can clear this iup.

>  However, the problem looks to be the mismatch
> in assumptions.  The way SCSI binding works, the queue belongs to the
> underlying device so we always assumed we could add and remove upper
> drivers ... there's even a case for this if you don't want a disk but
> want to attach sg instead.  However, it's not the common use case.
> 
> The block model now seems to tie a lot of queue set up and teardown to
> add and remove of the gendisk which is counter to these assumptions.  As
> long as we can go from del->add without calling the ->release function
> on the queue, everything works.  Most of the operations seem
> symmetrical, so perhaps this is only the bypass doing too much.
> 
> The ideal is that disk teardown only does as much as disk setup, so the
> mid layer can still use the underlying queue on the device.
> 
> This bypass code is not very well documented.  However, your problem
> seems to be caused by this change:
> 
> commit 776687bce42bb22cce48b5da950e48ebbb9a948f
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Jul 1 10:29:17 2014 -0600
> 
>     block, blk-mq: draining can't be skipped even if bypass_depth was
> non-zero
> 
> Your hack seems to indicate that this doesn't work on the add->del->add
> transtion of a gendisk.

Indeed, it does not work.

Tejun, for more details about the failure see the initial message in 
this thread:

	http://marc.info/?l=linux-kernel&m=140993911413862&w=2

Alan Stern

