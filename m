From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 24 Jan 2018 00:41:10 +0800
Message-ID: <20180123164109.GF13277@ming.t460p>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-2-ming.lei@redhat.com>
 <1516639793.2545.14.camel@sandisk.com>
 <20180123005728.GB4411@ming.t460p>
 <54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
 <20180123162605.GD13277@ming.t460p>
 <4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 23, 2018 at 08:37:26AM -0800, Bart Van Assche wrote:
> On 01/23/18 08:26, Ming Lei wrote:
> > On Tue, Jan 23, 2018 at 08:17:02AM -0800, Bart Van Assche wrote:
> > > On 01/22/18 16:57, Ming Lei wrote:
> > > > Even though RCU lock is held during dispatch, preemption or interrupt
> > > > can happen too, so it is simply wrong to depend on the timing to make
> > > > sure __blk_mq_run_hw_queue() can see the request in this situation.
> > > 
> > > It is very unlikely that this race will ever be hit because that race exists
> > > for less than one microsecond and the smallest timeout that can be specified
> > > for delayed queue rerunning is one millisecond. Let's address this race if
> > > anyone ever finds a way to hit it.
> > 
> > Please don't depend on the timing which is often fragile, as we can make it
> > correct in a generic approach. Also we should avoid to make every driver to
> > follow this way for dealing with most of STS_RESOURCE, right?
> 
> Wouldn't it be better to fix that race without changing the block layer API,
> e.g. by using call_rcu() for delayed queue runs? As you know call_rcu() will

Could you explain where to call call_rcu()?  call_rcu() can't be used in
IO path at all.

> only call the specified function after a grace period. Since pushing back
> requests onto the dispatch list happens with the RCU lock held using
> call_rcu() for delayed queue runs would be sufficient to address this race.


-- 
Ming
