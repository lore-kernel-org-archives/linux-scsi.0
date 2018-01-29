From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Mon, 29 Jan 2018 17:14:36 -0500
Message-ID: <20180129221436.GA6115@redhat.com>
References: <20180129203300.50595-1-snitzer@redhat.com>
 <1517260932.2687.42.camel@wdc.com>
 <20180129214446.GD5744@redhat.com>
 <1517262713.2687.56.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517262713.2687.56.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 29 2018 at  4:51pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2018-01-29 at 16:44 -0500, Mike Snitzer wrote:
> > But regardless of which wins the race, the queue will have been run.
> > Which is all we care about right?
> 
> Running the queue is not sufficient. With this patch applied it can happen
> that the block driver returns BLK_STS_DEV_RESOURCE, that the two or more
> concurrent queue runs finish before sufficient device resources are available
> to execute the request and that blk_mq_delay_run_hw_queue() does not get
> called at all. If no other activity triggers a queue run, e.g. request
> completion, this will result in a queue stall.

If BLK_STS_DEV_RESOURCE is returned then the driver doesn't need to rely
on a future queue run.  IIUC, that is the entire premise of
BLK_STS_DEV_RESOURCE.  If the driver had doubt about whether the
resource were going to be available in the future it should return
BLK_STS_RESOURCE.

That may seem like putting a lot on a driver developer (to decide
between the 2) but I'll again defer to Jens here.  This was the approach
he was advocating be pursued.

In practice it is working.  Would welcome you testing this V4.

Thanks,
Mike
