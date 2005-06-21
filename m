From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 13:58:58 -0700
Message-ID: <20050621205858.GB30526@us.ibm.com>
References: <20050621201056.GA29658@infradead.org> <Pine.LNX.4.44L0.0506211619460.634-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55440 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262330AbVFUU6p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 16:58:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5LKwjxd001251
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 16:58:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5LKwjW1184632
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 16:58:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5LKwdMv029063
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 16:58:40 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506211619460.634-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Tue, 21 Jun 2005, Christoph Hellwig wrote:
> 
> > On Tue, Jun 21, 2005 at 04:04:06PM -0400, Alan Stern wrote:
> > > This objection runs up against an issue we discussed some time ago.  
> > > Should the intended meaning of scsi_remove_host be simply that the kernel
> > > needs to stop using the HBA reasonably soon?  In that case you are right.  
> > > Or should the intended meaning be that the HBA is actually gone
> > > (hot-unplugged) and all further attempts to use it will fail?  In that
> > > case it doesn't matter.  The best ways to resolve this issue may be to
> > > have a separate scsi_host_gone routine or to add an extra argument to
> > > scsi_remove_host.
> > 
> > It must mean both because we don't know whether a hot unplug happened or
> > not.  The ->remove callbacks don't tell us.
> 
> I would describe it differently: Since you don't know whether a hot-unplug 
> occurred, you might as well assume it did not.  There's no harm in this, 
> because if the HBA really was unplugged then it doesn't matter what you 
> do; everything will fail.
> 

I have asked this multiple times, but I will again. If the hba knows to
fail everything by some internal state in the LLDD why does it not also
know to flush all commands back to the scsi mid layer in this unplugged
state so we do not have to deal with canceling them from the mid-layer. 

I think it has been stated many times if commands always go in through
queuecommand and always return through scsi_done it makes the chances of
errors a lot less.

> But those sd flush-cache commands are a problem.  Presumably you want to 
> send them _after_ all the outstanding commands have finished or been 
> cancelled.  What's the right way to allow those commands while rejecting 
> all others?

We have some notion of this already if you look in scsi_prep_fn (i.e.,
specials_only), but this is based on sdev state not shost. Checking for a
specials_only flag in scsi_dispatch may not be to clean. This may be why
we should look at a shost state model update and align sdev and shost to
clearly state what will happen to command.s

-andmike
--
Michael Anderson
andmike@us.ibm.com

