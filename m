From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Thu, 13 Apr 2017 09:59:57 -0700
Message-ID: <25ebc19f-f6e0-2f71-f590-8416359d2fd1@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
 <20170407181654.27836-7-bart.vanassche@sandisk.com>
 <20170411160958.GA19222@redhat.com> <1491928005.2654.6.camel@sandisk.com>
 <20170411174739.GA19620@redhat.com> <1491933092.2654.10.camel@sandisk.com>
 <20170411180358.GA19660@redhat.com> <1491934715.2654.14.camel@sandisk.com>
 <20170412034229.GA8835@ming.t460p> <1492022286.2764.15.camel@sandisk.com>
 <20170413022030.GD8835@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170413022030.GD8835@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On 04/12/17 19:20, Ming Lei wrote:
> On Wed, Apr 12, 2017 at 06:38:07PM +0000, Bart Van Assche wrote:
>> If the blk-mq core would always rerun a hardware queue if a block driver
>> returns BLK_MQ_RQ_QUEUE_BUSY then that would cause 100% of a single CPU core
> 
> It won't casue 100% CPU utilization since we restart queue in completion
> path and at that time at least one tag is available, then progress can be
> made.

Hello Ming,

Sorry but you are wrong. If .queue_rq() returns BLK_MQ_RQ_QUEUE_BUSY
then it's likely that calling .queue_rq() again after only a few
microseconds will cause it to return BLK_MQ_RQ_QUEUE_BUSY again. If you
don't believe me, change "if (!blk_mq_sched_needs_restart(hctx) &&
!test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state)) blk_mq_run_hw_queue(hctx,
true);" into "blk_mq_run_hw_queue(hctx, true);", trigger a busy
condition for either a SCSI LLD or a dm-rq driver, run top and you will
see that the CPU usage of a kworker thread jumps up to 100%.

Bart.
