From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 24 Jan 2018 00:49:52 +0800
Message-ID: <20180123164951.GG13277@ming.t460p>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-2-ming.lei@redhat.com>
 <1516639793.2545.14.camel@sandisk.com>
 <20180123005728.GB4411@ming.t460p>
 <54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
 <20180123162605.GD13277@ming.t460p>
 <4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
 <20180123164109.GF13277@ming.t460p>
 <1516726030.3339.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516726030.3339.14.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 23, 2018 at 04:47:11PM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-24 at 00:41 +0800, Ming Lei wrote:
> > Could you explain where to call call_rcu()?  call_rcu() can't be used in
> > IO path at all.
> 
> Can you explain what makes you think that call_rcu() can't be used in the
> I/O path? As you know call_rcu() invokes a function asynchronously. From
> Documentation/RCU/Design/Requirements/Requirements.html:
> 
>   The <tt>call_rcu()</tt> function may be used in a number of
>   situations where neither <tt>synchronize_rcu()</tt> nor
>   <tt>synchronize_rcu_expedited()</tt> would be legal,
>   including within preempt-disable code, <tt>local_bh_disable()</tt> code,
>   interrupt-disable code, and interrupt handlers.

OK, suppose it is true, do you want to change most of STS_RESOURCE in
all drivers to this way? Why can't we use the generic and simple approach
in this patch?

-- 
Ming
