From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 16:33:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506211619460.634-100000@iolanthe.rowland.org>
References: <20050621201056.GA29658@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49548 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262316AbVFUUdQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 16:33:16 -0400
In-Reply-To: <20050621201056.GA29658@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jun 2005, Christoph Hellwig wrote:

> On Tue, Jun 21, 2005 at 04:04:06PM -0400, Alan Stern wrote:
> > This objection runs up against an issue we discussed some time ago.  
> > Should the intended meaning of scsi_remove_host be simply that the kernel
> > needs to stop using the HBA reasonably soon?  In that case you are right.  
> > Or should the intended meaning be that the HBA is actually gone
> > (hot-unplugged) and all further attempts to use it will fail?  In that
> > case it doesn't matter.  The best ways to resolve this issue may be to
> > have a separate scsi_host_gone routine or to add an extra argument to
> > scsi_remove_host.
> 
> It must mean both because we don't know whether a hot unplug happened or
> not.  The ->remove callbacks don't tell us.

I would describe it differently: Since you don't know whether a hot-unplug 
occurred, you might as well assume it did not.  There's no harm in this, 
because if the HBA really was unplugged then it doesn't matter what you 
do; everything will fail.

But those sd flush-cache commands are a problem.  Presumably you want to 
send them _after_ all the outstanding commands have finished or been 
cancelled.  What's the right way to allow those commands while rejecting 
all others?

Alan Stern

