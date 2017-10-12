From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V6 4/5] blk-mq-sched: improve dispatching from sw queue
Date: Thu, 12 Oct 2017 09:37:11 -0600
Message-ID: <7809048e-c99e-689f-f17b-a0565332bb29@kernel.dk>
References: <20171009112424.30524-1-ming.lei@redhat.com>
 <20171009112424.30524-5-ming.lei@redhat.com>
 <20171010182345.GD30738@vader.DHCP.thefacebook.com>
 <20171012100107.GA28224@ming.t460p> <1507822412.2448.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507822412.2448.12.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "osandov@osandov.com" <osandov@osandov.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2017 09:33 AM, Bart Van Assche wrote:
> On Thu, 2017-10-12 at 18:01 +0800, Ming Lei wrote:
>> Even EWMA approach isn't good on SCSI-MQ too, because
>> some SCSI's .cmd_per_lun is very small, such as 3 on
>> lpfc and qla2xxx, and one full flush will trigger
>> BLK_STS_RESOURCE easily.
>>
>> So I suggest to use the way of q->queue_depth first, since we
>> don't get performance degrade report on other devices(!q->queue_depth)
>> with blk-mq. We can improve this way in the future if we
>> have better approach.
> 
> Measurements have shown that even with this patch series applied sequential
> I/O performance is still below that of the legacy block and SCSI layers. So
> this patch series is not the final solution. (See also John Garry's e-mail
> of October 10th - https://lkml.org/lkml/2017/10/10/401). I have been
> wondering what could be causing that performance difference. Maybe it's
> because requests can reside for a while in the hctx dispatch queue and hence
> are unvisible for the scheduler while in the hctx dispatch queue? Should we
> modify blk_mq_dispatch_rq_list() such that it puts back requests that have
> not been accepted by .queue_rq() onto the scheduler queue(s) instead of to
> the hctx dispatch queue? If we would make that change, would it allow us to
> drop patch "blk-mq-sched: improve dispatching from sw queue"?

Yes, it's clear that even with the full series, we're not completely there
yet. We are closer, though, and I do want to close that gap up as much
as we can. I think everybody will be more motivated and have an easier time
getting the last bit of the way there, once we have a good foundation in.

It may be the reason that you hint at, if we do see a lot of requeueing
or BUSY in the test case. That would prematurely move requests from the
schedulers knowledge and into the hctx->dispatch holding area. It'd be
useful to have a standard SATA test run and see if we're missing merging
in that case (since merging is what it boils down to). If we are, then
it's not hctx->dispatch issues.

-- 
Jens Axboe
