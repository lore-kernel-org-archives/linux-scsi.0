From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: 10 Feb 2004 15:05:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076443541.2080.56.camel@mulgrave>
References: <20040120132052.GA6740@lst.de>		<2432440000.1076430858@aslan.btc.adaptec.com
	>	<1076431366.1804.24.camel@mulgrave>
		<2472850000.1076435243@aslan.btc.adaptec.com>
	<1076438507.2165.38.camel@mulgrave>
	<2520610000.1076442259@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:15852 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266020AbUBJUGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 15:06:00 -0500
In-Reply-To: <2520610000.1076442259@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-02-10 at 14:44, Justin T. Gibbs wrote:
> > If you need to stall a command after you've accepted it by returning
> > zero from queuecommand, you return it to the mid-layer with status
> > either BUSY or QUEUE_FULL.
> 
> BUSY and QUEUE_FULL status have particular meanings when associated
> with an SCSI peripheral.  Using them for this purpose will only confuse
> the mid-layer into taking unwarranted action, like trying to throttle
> the queue depth.  The times that I want to use this have nothing to
> do with BUSY or QUEUE_FULL in their SCSI sense.

So if I give you an error code for this, like DID_REQEUEUE, you'll
eliminate the driver queueing from your queucommand and from your done
processing?

> >> 1) A counting "device frozen semaphore" that the LLD or the mid-layer
> >>    can decrement when I/O to this device needs to be halted.
> > 
> > If you really need to halt everything after returning BUSY, then the
> > scsi_block_requests()/scsi_unblock_requests() can be used for this.
> 
> scsi_block_requests() blocks the whole controller up.  I only want
> and need to block the transactions going to a particular lun.
> 
> >> 2) An explicit scsi cmd code indicating "requeue this request - don't
> >>    attempt recovery" for commands that are in internal queues that were
> >>    innocently affected by a recovery or transport event.
> > 
> > commands in the controller issue queue innocently affected by recovery
> > should be returned to the mid-layer with DID_RESET, where they will be
> > reissued.
> 
> They will only be issued up to their command retry count which may be zero
> for certain commands.  This may also confuse the peripheral or mid-layer
> drivers into believing that a unit attention condition is expected and
> should be ignored.  The commands that were affected by the recovery action
> should be marked accordingly, but marking the commands that are still waiting
> on the sidelines is the equivalent of a drive-by-shooting.

No, they won't.  DID_RESET doesn't count against the retry count (the
only things that affect the retry count are conditions that go through
the maybe_retry label in scsi_device_disposition()).

DID_RESET is designed for returning an uncompleted command where
recovery in one command affected another, which is what you say you
need.

It will not cause any unit attention exception processing.  That only
happens if the error handler knows it reset something, or the driver
reports that it is resetting something.

James


