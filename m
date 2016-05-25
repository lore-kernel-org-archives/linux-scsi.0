From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/5] blk mq: take ref to q when running it
Date: Wed, 25 May 2016 14:15:03 -0500
Message-ID: <5745F9B7.5070703@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <1464162903-14735-2-git-send-email-mchristi@redhat.com>
 <8cab029e-fac5-b4cb-8e80-707abe50ab09@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbcEYTPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 15:15:06 -0400
In-Reply-To: <8cab029e-fac5-b4cb-8e80-707abe50ab09@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org

On 05/25/2016 10:53 AM, Bart Van Assche wrote:
> On 05/25/2016 12:54 AM, mchristi@redhat.com wrote:
>> If the __blk_mq_run_hw_queue is a result of a async run or retry
>> then we do not have a reference to the queue. At this time,
>> blk_cleanup_queue could begin tearing it down while the queue_rq
>> function is being run.
>>
>> This patch just has us do a blk_queue_enter call.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> ---
>>  block/blk-mq.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 7df9c92..5958a02 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -738,8 +738,13 @@ static void __blk_mq_run_hw_queue(struct
>> blk_mq_hw_ctx *hctx)
>>
>>      WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
>>
>> -    if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
>> +    if (blk_queue_enter(q, false)) {
>> +        blk_mq_run_hw_queue(hctx, true);
>>          return;
>> +    }
>> +
>> +    if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
>> +        goto exit_queue;
>>
>>      hctx->run++;
>>
>> @@ -832,6 +837,9 @@ static void __blk_mq_run_hw_queue(struct
>> blk_mq_hw_ctx *hctx)
>>           **/
>>          blk_mq_run_hw_queue(hctx, true);
>>      }
>> +
>> +exit_queue:
>> +    blk_queue_exit(q);
>>  }
> 
> Hello Mike,
> 
> blk_cleanup_queue() waits until delay_work and run_work have finished
> inside blk_sync_queue(). The code in blk_cleanup_queue() before the
> blk_sync_queue() call should be safe to execute concurrently with
> queue_rq(). Or did I perhaps miss something?
> 

My concern was when blk_mq_run_hw_queue is run with async=false then we
are not always run from the work queue or a under another
blk_queue_enter call already.

For example, in the scsi cases where we call
scsi_run_queue->blk_mq_start_stopped_hw_queues we can be in soft irq
context, some driver thread or the scsi eh thread.
