From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd
 workqueue
Date: Tue, 1 Feb 2011 11:40:43 +0100
Message-ID: <20110201104043.GH14211@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-18-git-send-email-tj@kernel.org>
 <AANLkTi=Fg8wjf-XfVsq0X4RWx7i8F1V7gC6-8Y5LPbnL@mail.gmail.com>
 <20110124162414.GD27510@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110124162414.GD27510@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 24, 2011 at 05:24:14PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 24, 2011 at 05:09:18PM +0100, Bart Van Assche wrote:
> > Insertion of  flush_work_sync() fixes a race - that's a good catch.
> > flush_work_sync() should be invoked a little earlier though because
> > the scheduled work may access the queue destroyed by the
> > crq_queue_destroy(target) call. And the CRQ interrupt should be
> > disabled from before flush_work_sync() is invoked until after the CRQ
> > has been destroyed.
> 
> Heh, I'm a bit out of my depth here.  If you know what's necessary,
> please go ahead and make the change.
> 
> > Regarding the queue removal: I might have missed something, but why
> > would you like to remove the vtgtd work queue ? Since the ibmvstgt
> > driver is a storage target driver, processing latency matters. I'm
> > afraid that switching from a dedicated queue to the global work queue
> > will increase processing latency.
> 
> Having a dedicated workqueue no longer makes any difference regarding
> processing latency.  Each workqueue is mere frontend to the shared
> worker pool anyway.  Dedicated workqueues are now meaningful only as
> forward progress guarantee, attribute and/or flush domain - IOW, when
> the workqueue needs to be used during memory reclaim, the work items
> need to have specific attributes or certain group of work items need
> to be flushed together.  Apart from that, there's virtually no
> difference between using the system_wq and a dedicated one.  As using
> the system one is usually simpler, it's natural to do that.

Ping.  Are you interested in doing the conversion?

Thanks.

-- 
tejun
