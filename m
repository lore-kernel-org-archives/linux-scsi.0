From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 24 Jan 2018 00:59:15 +0800
Message-ID: <20180123165914.GH13277@ming.t460p>
References: <20180122033550.27855-2-ming.lei@redhat.com>
	<1516639793.2545.14.camel@sandisk.com>
	<20180123005728.GB4411@ming.t460p>
	<54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
	<20180123162605.GD13277@ming.t460p>
	<4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
	<20180123164109.GF13277@ming.t460p>
	<1516726030.3339.14.camel@wdc.com>
	<20180123164951.GG13277@ming.t460p>
	<1516726441.3339.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516726441.3339.16.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 23, 2018 at 04:54:02PM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-24 at 00:49 +0800, Ming Lei wrote:
> > On Tue, Jan 23, 2018 at 04:47:11PM +0000, Bart Van Assche wrote:
> > > On Wed, 2018-01-24 at 00:41 +0800, Ming Lei wrote:
> > > > Could you explain where to call call_rcu()?  call_rcu() can't be used in
> > > > IO path at all.
> > > 
> > > Can you explain what makes you think that call_rcu() can't be used in the
> > > I/O path? As you know call_rcu() invokes a function asynchronously. From
> > > Documentation/RCU/Design/Requirements/Requirements.html:
> > > 
> > >   The <tt>call_rcu()</tt> function may be used in a number of
> > >   situations where neither <tt>synchronize_rcu()</tt> nor
> > >   <tt>synchronize_rcu_expedited()</tt> would be legal,
> > >   including within preempt-disable code, <tt>local_bh_disable()</tt> code,
> > >   interrupt-disable code, and interrupt handlers.
> > 
> > OK, suppose it is true, do you want to change most of STS_RESOURCE in
> > all drivers to this way? Why can't we use the generic and simple approach
> > in this patch?
> 
> Please reread my proposal. I did not propose to change any block drivers.
> What I proposed is to change the blk_mq_delay_run_hw_queue() implementation
> such that it uses call_rcu() instead of kblockd_mod_delayed_work_on().
> That's a generic and simple approach.

How is that enough to fix the IO hang when driver returns STS_RESOURCE
and the queue is idle? If you want to follow previous dm-rq's way of
call blk_mq_delay_run_hw_queue() in .queue_rq(), the same trick need
to be applied to other drivers too, right?

Unfortunately most of STS_RESOURCE don't use this trick, but they need
to be handled.

The patch of 'blk-mq: introduce BLK_STS_DEV_RESOURCE' can fix all these
cases.

-- 
Ming
