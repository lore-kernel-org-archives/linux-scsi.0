From: Tejun Heo <tj@kernel.org>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
Date: Tue, 9 Sep 2014 10:19:45 +0900
Message-ID: <20140909011945.GD11706@mtj.dyndns.org>
References: <1410191478.2027.28.camel@jarvis.lan>
 <Pine.LNX.4.44L0.1409081335450.1433-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38497 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaIIBTv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 21:19:51 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409081335450.1433-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Shirish Pargaonkar <shirishpargaonkar@gmail.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

Hello,

On Mon, Sep 08, 2014 at 01:42:44PM -0400, Alan Stern wrote:
> > This looks like a nasty hack.  In theory the QUEUE_FLAG_INIT_DONE should
> > be unset on blk_unregister_queue() to match the teardown; it's only
> > accident it isn't.  del_gendisk() in sd_remove() is supposed to tear a
> > lot of queue stuff down.
> 
> It's not clear what the operative assumptions are.  The comment in
> blk_register_queue() implies that bypass is active only because it was
> set up that way when the queue was created.  The fact that
> blk_unregister_queue() doesn't call blk_queue_bypass_start() seems to
> support this view -- although it could also be a simple oversight.
> 
> Hopefully Tejun can clear this iup.

Maintaining the initial bypass till queue registration is an
optimization because shutting down a fully functional queue is a
costly operation and there are drivers which set and destroy queues
repeatedly while probing, so, yeah, it's really a special case for
when the queue is being registered for the first time.

> > Your hack seems to indicate that this doesn't work on the add->del->add
> > transtion of a gendisk.
> 
> Indeed, it does not work.

As such, the change you suggested makes perfect sense to me.  Why
wouldn't it work?

Thanks.

-- 
tejun
