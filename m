From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
Date: Tue, 9 Sep 2014 11:08:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409091026470.1677-100000@iolanthe.rowland.org>
References: <20140909011945.GD11706@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37195 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751493AbaIIPIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 11:08:23 -0400
In-Reply-To: <20140909011945.GD11706@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Shirish Pargaonkar <shirishpargaonkar@gmail.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Tue, 9 Sep 2014, Tejun Heo wrote:

> Hello,
> 
> On Mon, Sep 08, 2014 at 01:42:44PM -0400, Alan Stern wrote:
> > > This looks like a nasty hack.  In theory the QUEUE_FLAG_INIT_DONE should
> > > be unset on blk_unregister_queue() to match the teardown; it's only
> > > accident it isn't.  del_gendisk() in sd_remove() is supposed to tear a
> > > lot of queue stuff down.
> > 
> > It's not clear what the operative assumptions are.  The comment in
> > blk_register_queue() implies that bypass is active only because it was
> > set up that way when the queue was created.  The fact that
> > blk_unregister_queue() doesn't call blk_queue_bypass_start() seems to
> > support this view -- although it could also be a simple oversight.
> > 
> > Hopefully Tejun can clear this iup.
> 
> Maintaining the initial bypass till queue registration is an
> optimization because shutting down a fully functional queue is a
> costly operation and there are drivers which set and destroy queues
> repeatedly while probing, so, yeah, it's really a special case for
> when the queue is being registered for the first time.
> 
> > > Your hack seems to indicate that this doesn't work on the add->del->add
> > > transtion of a gendisk.
> > 
> > Indeed, it does not work.
> 
> As such, the change you suggested makes perfect sense to me.  Why
> wouldn't it work?

Sorry, the meaning wasn't clear.  I meant that the existing code 
doesn't work.  The patch seems to work okay (except that I can't use 
queue_flag_test_and_set because the queue isn't locked at that point).  
I'll submit the patch shortly.

Alan Stern

