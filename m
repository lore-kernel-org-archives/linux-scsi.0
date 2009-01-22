From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of
 queue
Date: Fri, 23 Jan 2009 07:03:23 +0900
Message-ID: <20090123070237B.fujita.tomonori@lab.ntt.co.jp>
References: <20090122111302.GG30821@kernel.dk>
	<49786A1E.3070707@panasas.com>
	<20090122124640.GQ30821@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53820 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZAVWD6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 17:03:58 -0500
In-Reply-To: <20090122124640.GQ30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Thu, 22 Jan 2009 13:46:41 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Jan 22 2009, Boaz Harrosh wrote:
> > Jens Axboe wrote:
> > > On Thu, Jan 22 2009, FUJITA Tomonori wrote:
> > >> On Wed, 21 Jan 2009 11:52:39 +0200
> > >> Boaz Harrosh <bharrosh@panasas.com> wrote:
> > >>
> > >>> Currently inherited from sg.c bsg will submit asynchronous request
> > >>> at the head-of-the-queue, (using "at_head" set in the call to
> > >>> blk_execute_rq_nowait()). This is bad in situation where we want
> > >>> to keep the queues full but need the requests to execute in order.
> > >> As I wrote, I think that blk_execute_rq_nowait inserts a request and
> > >> plugs a queue. So how can you keep the queue full? On the completion
> > >> of blk_execute_rq_nowait, the queue is empty.
> > > 
> > > That's not true at all. If you submit more than one request, request 2
> > > and up would be queued according to the orientation given. It may even
> > > include request 1 as well, what if the queue is busy doing work for
> > > someone else already?
> > > 
> > > I think the patch makes sense, I also wish that the default would have
> > > been reversed so that at_back would be the default. at_back is more
> > > complex though, since it impacts existing requests for the device (it
> > > drains the scheduler queue).
> > > 
> > 
> > bsg only sends BLOCK_PC commands, I think these are not held in the
> > scheduler queue, right? 

Right, that's what I meant.


> They are not, correct. But that queue may have other requests pending,
> which may be "normal" file system requests. Then an at_back bsg command
> would act almost like a barrier, draining the entire queue to dispatch.

Theoretically, yes. But for what do you want to mix pc and fs commands
with a single device and send a pc command 'at the end of the queue'?

And as you know, you can assume that Boaz always cares about only
OSD. ;) There is no way in mainline now to send fs commands to OSD.

So, Boaz, what do you want to do exactly? It should have in the patch
description. I don't want to add something that nobody uses.
