From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: block: Check that queue is alive in blk_insert_cloned_request()
Date: Tue, 12 Jul 2011 13:10:33 -0400
Message-ID: <20110712171033.GG1293@redhat.com>
References: <20110712014633.GA30965@redhat.com>
 <Pine.LNX.4.44L0.1107121120130.31381-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107121120130.31381-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2011 at 11:24:54AM -0400, Alan Stern wrote:
> On Mon, 11 Jul 2011, Vivek Goyal wrote:
> 
> > > > There's still the issue that Stefan Richter pointed out: The test for a 
> > > > dead queue must be made _after_ acquiring the queue lock, not _before_.
> > > 
> > > Yes, quite important.
> > > 
> > > Jens, can you tweak the patch or should Roland send a v2?
> > 
> > I do not think that we should do queue dead check after taking a spinlock.
> > The reason being that there are life time issues of two objects.
> > 
> > - Validity of request queue pointer
> > - Validity of q->spin_lock pointer
> > 
> > If the dm has taken the reference to the request queue in the beginning
> > then it can be sure request queue pointer is valid. But spin_lock might
> > be coming from driver and might be in one of driver allocated structures.
> > So it might happen that driver has called blk_cleanup_queue() and freed
> > up structures which contained the spin lock.
> 
> Surely this is a bug in the design of the block layer?
> 
> > So if queue is not dead, we know that q->spin_lock is valid. I think
> > only race present here is that whole operation is not atomic. First
> > we check for queue not dead flag and then go on to acquire request
> > queue lock. So this leaves a small window for race. I think I have
> > seen other code written in such manner (__generic_make_request()). So
> > it proably reasonably safe to do here too.
> 
> "Probably reasonably safe" = "unsafe".  The fact that it will usually
> work out okay means that when it does fail, it will be very difficult
> to track down.
> 
> It needs to be fixed _now_, when people are aware of the issue.  Not 
> five years from now, when everybody has forgotten about it.

I agree that fixing would be good. Frankly speaking I don't even have
full understanding of the problem. I know little bit from request queue
side but have no idea about referencing mechanism at device level and
how that is supposed to work with request queue referencing.

So once we understand the problem well, probably we will have an answer
how to go about fixing it.

Thanks
Vivek
