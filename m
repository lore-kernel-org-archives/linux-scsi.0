From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 20:18:54 -0700
Message-ID: <729b1ba5-84ee-2c65-9c94-fbeba27b90d4@kernel.dk>
References: <2f7ea970-bd0d-d2c2-429b-c6eeb1694507@kernel.dk>
 <20180131030457.1132-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180131030457.1132-1-snitzer@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 1/30/18 8:04 PM, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> This status is returned from driver to block layer if device related
> resource is unavailable, but driver can guarantee that IO dispatch
> will be triggered in future when the resource is available.
> 
> Convert some drivers to return BLK_STS_DEV_RESOURCE.  Also, if driver
> returns BLK_STS_RESOURCE and SCHED_RESTART is set, rerun queue after
> a delay (BLK_MQ_DELAY_QUEUE) to avoid IO stalls.  BLK_MQ_DELAY_QUEUE is
> 3 ms because both scsi-mq and nvmefc are using that magic value.
> 
> If a driver can make sure there is in-flight IO, it is safe to return
> BLK_STS_DEV_RESOURCE because:
> 
> 1) If all in-flight IOs complete before examining SCHED_RESTART in
> blk_mq_dispatch_rq_list(), SCHED_RESTART must be cleared, so queue
> is run immediately in this case by blk_mq_dispatch_rq_list();
> 
> 2) if there is any in-flight IO after/when examining SCHED_RESTART
> in blk_mq_dispatch_rq_list():
> - if SCHED_RESTART isn't set, queue is run immediately as handled in 1)
> - otherwise, this request will be dispatched after any in-flight IO is
>   completed via blk_mq_sched_restart()
> 
> 3) if SCHED_RESTART is set concurently in context because of
> BLK_STS_RESOURCE, blk_mq_delay_run_hw_queue() will cover the above two
> cases and make sure IO hang can be avoided.
> 
> One invariant is that queue will be rerun if SCHED_RESTART is set.

Applied, thanks.

-- 
Jens Axboe
