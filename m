From: scameron@beardog.cce.hp.com
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 13:55:33 -0600
Message-ID: <20121214195533.GS20898@beardog.cce.hp.com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org> <50CAF502.3070300@acm.org> <20121214164421.GQ20898@beardog.cce.hp.com> <50CB50A9.1050202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25540 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2LNSzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 13:55:37 -0500
Content-Disposition: inline
In-Reply-To: <50CB50A9.1050202@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com, scameron@beardog.cce.hp.com

On Fri, Dec 14, 2012 at 05:15:37PM +0100, Bart Van Assche wrote:
> On 12/14/12 17:44, scameron@beardog.cce.hp.com wrote:
> >I expect the flash devices re-order requests as well, simply because
> >to feed requests to the things at a sufficient rate, you have to pump
> >requests into them concurrently on multiple hardware queues -- a single
> >cpu jamming requests into them as fast as it can is still not fast enough
> >to keep them busy.  Consequently, they *can't* care about ordering, as the
> >relative order requests on different hardware queues are submitted into 
> >them
> >is not even really controlled, so the OS *can't* count on concurrent 
> >requests
> >not to be essentially "re-ordered", just because of the nature of the way
> >requests get into the device.
> 
> Why should a flash device have to reorder write requests ? These devices 
> typically use a log-structured file system internally.

It's not so much that they are re-ordered as that there is no controlled
ordering to begin with because multiple cpus are submitting to multiple
hardware queues concurrently.  If you have 12 requests coming in on 12
cpus to 12 hardware queues to the device, it's going to be racy as to
which request is processed first by the device -- and this is fine, the
hardware queues are independent of one another and do not need to worry
about each other.  This is all to provide a means of getting enough commands
on the device to actually keep it busy.  A single cpu can't do it, the
device is too fast.  If you have ordering dependencies such that request
A must complete before request B completes, then don't submit A and B
concurrently, because if you do submit them concurrently, you cannot tell
whether A or B will arrive into the device first because they may go into
it via different hardware queues.

Note, in case it isn't obvious, the hardware queues I'm talking about here
are not the struct scsi_device, sdev->request_queue queues, they are
typically ring buffers in host memory from which the device DMAs commands/responses
to/from depending on if it's a submit queue or a completion queue and with
producer/consumer indexes one of which is in host memory and one of which
is a register on the device (which is which depends on the direction of the
queue, from device (pi = host memory, ci = device register), or to device
(pi = device register, ci = host memory))

-- steve
