From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 13:55:23 +0800
Message-ID: <CACVXFVOWXmNa1q9jG1b_tv-afc3a6SBCAO_tWavVUR9KqQUJfw@mail.gmail.com>
References: <20180129203300.50595-1-snitzer@redhat.com>
	<1517260932.2687.42.camel@wdc.com>
	<20180129214446.GD5744@redhat.com> <1517262713.2687.56.camel@wdc.com>
	<20180129221436.GA6115@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180129221436.GA6115@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 30, 2018 at 6:14 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, Jan 29 2018 at  4:51pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
>> On Mon, 2018-01-29 at 16:44 -0500, Mike Snitzer wrote:
>> > But regardless of which wins the race, the queue will have been run.
>> > Which is all we care about right?
>>
>> Running the queue is not sufficient. With this patch applied it can happen
>> that the block driver returns BLK_STS_DEV_RESOURCE, that the two or more
>> concurrent queue runs finish before sufficient device resources are available
>> to execute the request and that blk_mq_delay_run_hw_queue() does not get
>> called at all. If no other activity triggers a queue run, e.g. request
>> completion, this will result in a queue stall.
>
> If BLK_STS_DEV_RESOURCE is returned then the driver doesn't need to rely
> on a future queue run.  IIUC, that is the entire premise of
> BLK_STS_DEV_RESOURCE.  If the driver had doubt about whether the
> resource were going to be available in the future it should return
> BLK_STS_RESOURCE.
>
> That may seem like putting a lot on a driver developer (to decide
> between the 2) but I'll again defer to Jens here.  This was the approach
> he was advocating be pursued.

Thinking of further, maybe you can add the following description in V5,
and it should be much easier for driver developer to follow:

When any resource allocation fails, if driver can make sure that there is
any in-flight IO, it is safe to return BLK_STS_DEV_RESOURCE to blk-mq,
that is exactly what scsi_queue_rq() is doing.

Follows the theory:

1) driver returns BLK_STS_DEV_RESOURCE if driver figures out
there is any in-flight IO, in case of any resource allocation failure

2) If all these in-flight IOs complete before examining SCHED_RESTART in
blk_mq_dispatch_rq_list(), SCHED_RESTART must be cleared, so queue
is run immediately in this case by blk_mq_dispatch_rq_list();

3) if there is any in-flight IO after/when examining SCHED_RESTART in
blk_mq_dispatch_rq_list():
- if SCHED_RESTART isn't set, queue is run immediately as handled in 2)
- otherwise, this request will be dispatched after any in-flight IO is
completed via
blk_mq_sched_restart() since this request is added to hctx->dispatch already

And there are two invariants when driver returns BLK_STS_DEV_RESOURCE
iff there is any in-flight IOs:

1) SCHED_RESTART must be zero if no in-flight IOs
2) there has to be any IO in-flight if SCHED_RESTART is read as 1


Thanks,
Ming
