From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 10 Feb 2004 12:44:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2520610000.1076442259@aslan.btc.adaptec.com>
References: <20040120132052.GA6740@lst.de>		<2432440000.1076430858@aslan.btc.adaptec.com>	<1076431366.1804.24.camel@mulgrave> 	<2472850000.1076435243@aslan.btc.adaptec.com> <1076438507.2165.38.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:29632 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266175AbUBJThm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 14:37:42 -0500
In-Reply-To: <1076438507.2165.38.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> If you need to stall a command after you've accepted it by returning
> zero from queuecommand, you return it to the mid-layer with status
> either BUSY or QUEUE_FULL.

BUSY and QUEUE_FULL status have particular meanings when associated
with an SCSI peripheral.  Using them for this purpose will only confuse
the mid-layer into taking unwarranted action, like trying to throttle
the queue depth.  The times that I want to use this have nothing to
do with BUSY or QUEUE_FULL in their SCSI sense.

>> 1) A counting "device frozen semaphore" that the LLD or the mid-layer
>>    can decrement when I/O to this device needs to be halted.
> 
> If you really need to halt everything after returning BUSY, then the
> scsi_block_requests()/scsi_unblock_requests() can be used for this.

scsi_block_requests() blocks the whole controller up.  I only want
and need to block the transactions going to a particular lun.

>> 2) An explicit scsi cmd code indicating "requeue this request - don't
>>    attempt recovery" for commands that are in internal queues that were
>>    innocently affected by a recovery or transport event.
> 
> commands in the controller issue queue innocently affected by recovery
> should be returned to the mid-layer with DID_RESET, where they will be
> reissued.

They will only be issued up to their command retry count which may be zero
for certain commands.  This may also confuse the peripheral or mid-layer
drivers into believing that a unit attention condition is expected and
should be ignored.  The commands that were affected by the recovery action
should be marked accordingly, but marking the commands that are still waiting
on the sidelines is the equivalent of a drive-by-shooting.

You've complained in the past about how the aic7xxx and aic79xx drivers
work around the mid-layer to get stuff to work correctly.  Above you are
asking for the LLD to continue to "lie" to the mid-layer instead of actually
fixing the problem.  What you are proposing here *loses* critical
information for the mid-layer and the perihperal drivers.  How is this
different or better than the other "lies" the current aic7xxx and aic79xx
drivers tell to convince the mid-layer to do the right thing?  I thought
the intention was to fix the mid-layer so that drivers could avoid these
kinds of things.

--
Justin

