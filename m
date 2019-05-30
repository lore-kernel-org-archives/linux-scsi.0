From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Thu, 30 May 2019 17:54:49 +0200
Message-ID: <461fe0cd-c5bc-a612-6013-7c002b92dcdc@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 30/05/19 17:36, Bart Van Assche wrote:
> On 5/30/19 4:28 AM, Paolo Bonzini wrote:
>> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
>> +    .get_budget    = scsi_mq_get_budget,
>> +    .put_budget    = scsi_mq_put_budget,
>> +    .queue_rq    = scsi_queue_rq,
>> +    .complete    = scsi_softirq_done,
>> +    .timeout    = scsi_timeout,
>> +#ifdef CONFIG_BLK_DEBUG_FS
>> +    .show_rq    = scsi_show_rq,
>> +#endif
>> +    .init_request    = scsi_mq_init_request,
>> +    .exit_request    = scsi_mq_exit_request,
>> +    .initialize_rq_fn = scsi_initialize_rq,
>> +    .busy        = scsi_mq_lld_busy,
>> +    .map_queues    = scsi_map_queues,
>> +};
>> +
>> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
>> +{
>> +    struct request_queue *q = hctx->queue;
>> +    struct scsi_device *sdev = q->queuedata;
>> +    struct Scsi_Host *shost = sdev->host;
>> +
>> +    shost->hostt->commit_rqs(shost, hctx->queue_num);
>> +}
>> +
>>   static const struct blk_mq_ops scsi_mq_ops = {
>>       .get_budget    = scsi_mq_get_budget,
>>       .put_budget    = scsi_mq_put_budget,
>>       .queue_rq    = scsi_queue_rq,
>> +    .commit_rqs    = scsi_commit_rqs,
>>       .complete    = scsi_softirq_done,
>>       .timeout    = scsi_timeout,
>>   #ifdef CONFIG_BLK_DEBUG_FS
> 
> Hi Paolo,
> 
> Have you considered to modify the block layer such that a single
> scsi_mq_ops structure can be used for all SCSI LLD types?

Yes, but I don't think it's possible to do it in a nice way.
Any adjustment we make to the block layer to fit the SCSI subsystem's
desires would make all other block drivers uglier, so I chose to confine
the ugliness here.

The root issue is that the SCSI subsystem is unique in how it sits on
top of the block layer; this is the famous "adapter" (or "midlayer",
though that is confusing when talking about SCSI) design that Linux
usually tries to avoid.

Paolo
