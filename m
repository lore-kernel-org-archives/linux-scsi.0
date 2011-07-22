From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Linux 3.0 STILL dies on USB device hotplug - please merge fix
 ASAP
Date: Fri, 22 Jul 2011 16:19:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107221610000.1923-100000@iolanthe.rowland.org>
References: <1311364348.7153.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59973 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755164Ab1GVUTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2011 16:19:12 -0400
In-Reply-To: <1311364348.7153.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, stable@kernel.org, Dan Williams <dan.j.williams@intel.com>

On Fri, 22 Jul 2011, James Bottomley wrote:

> On Fri, 2011-07-22 at 19:02 +0200, Andi Kleen wrote:
> > Hi,
> > 
> > 3.0 still oopses and dies immediately on USB device hot unplug.
> > The same problem also triggered with SAS device according to Dan.
> > 
> > There was a lot of debugging on this a few weeks back and Alan Stern
> > posted a SCSI layer patch that fixed the problem (for both USB
> > and SAS):
> > 
> > http://68.183.106.108/lists/linux-usb/msg49001.html
> > 
> > But for some reason that patch didn't make it into 3.0 and 3.0 still
> > happily oopses as the RC*s.
> > 
> > Can you please merge this patch ASAP?  This should also go to stable.
> > 
> > At least for me it makes pure 3.0 very risky to use, because these USB 
> > hotunplug events are not uncommon and I end up with a dead machine.
> 
> Like I said at the time, the patch is wrong because of the relocation of
> the queue teardown.

That argument doesn't seem right.  The queue teardown (i.e., the call
to scsi_free_queue()) was moved by commit 86cbfb5607d4b81b ([SCSI] put
stricter guards on queue dead checks).  Here's the changelog:

    SCSI uses request_queue->queuedata == NULL as a signal that the queue
    is dying.  We set this state in the sdev release function.  However,
    this allows a small window where we release the last reference but
    haven't quite got to this stage yet and so something will try to take
    a reference in scsi_request_fn and oops.  It's very rare, but we had a
    report here, so we're pushing this as a bug fix
    
    The actual fix is to set request_queue->queuedata to NULL in
    scsi_remove_device() before we drop the reference.  This causes
    correct automatic rejects from scsi_request_fn as people who hold
    additional references try to submit work and prevents anything from
    getting a new reference to the sdev that way.

It's quite evident that the point of the commit was to move the line
setting queue->queuedata to NULL; the scsi_free_queue() call merely
went along for the ride (by mistake perhaps?).  I don't see any reason
why moving scsi_free_queue() back to where it was should cause a
problem.

Alan Stern

