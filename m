From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: block: Check that queue is alive in blk_insert_cloned_request()
Date: Mon, 11 Jul 2011 21:46:33 -0400
Message-ID: <20110712014633.GA30965@redhat.com>
References: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
 <Pine.LNX.4.44L0.1107112050480.17690-100000@netrider.rowland.org>
 <20110712012206.GA30690@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1GLBrf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 21:47:35 -0400
Content-Disposition: inline
In-Reply-To: <20110712012206.GA30690@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com

On Mon, Jul 11, 2011 at 09:22:06PM -0400, Mike Snitzer wrote:
> On Mon, Jul 11 2011 at  8:52pm -0400,
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Mon, 11 Jul 2011, Mike Snitzer wrote:
> > 
> > > [cc'ing dm-devel, vivek and tejun]
> > > 
> > > On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wrote:
> > > > From: Roland Dreier <roland@purestorage.com>
> > > >
> > > > This fixes crashes such as the below that I see when the storage
> > > > underlying a dm-multipath device is hot-removed. ?The problem is that
> > > > dm requeues a request to a device whose block queue has already been
> > > > cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> > > > is alive, but rather goes ahead and tries to queue the request. ?This
> > > > ends up dereferencing the elevator that was already freed in
> > > > blk_cleanup_queue().
> > > 
> > > Your patch looks fine to me:
> > > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > There's still the issue that Stefan Richter pointed out: The test for a 
> > dead queue must be made _after_ acquiring the queue lock, not _before_.
> 
> Yes, quite important.
> 
> Jens, can you tweak the patch or should Roland send a v2?

I do not think that we should do queue dead check after taking a spinlock.
The reason being that there are life time issues of two objects.

- Validity of request queue pointer
- Validity of q->spin_lock pointer

If the dm has taken the reference to the request queue in the beginning
then it can be sure request queue pointer is valid. But spin_lock might
be coming from driver and might be in one of driver allocated structures.
So it might happen that driver has called blk_cleanup_queue() and freed
up structures which contained the spin lock.

So if queue is not dead, we know that q->spin_lock is valid. I think
only race present here is that whole operation is not atomic. First
we check for queue not dead flag and then go on to acquire request
queue lock. So this leaves a small window for race. I think I have
seen other code written in such manner (__generic_make_request()). So
it proably reasonably safe to do here too.

Thanks
Vivek
