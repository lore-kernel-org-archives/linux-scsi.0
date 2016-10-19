From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 04/11] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Wed, 19 Oct 2016 09:13:39 -0700
Message-ID: <921009c0-5c2e-75f1-a903-986ce21ee9e8@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <e42a952c-f245-eb39-d0a1-0336035573f9@sandisk.com>
 <20161019132321.GD6323@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0088.outbound.protection.outlook.com ([104.47.41.88]:25248
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941272AbcJSQNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 12:13:43 -0400
In-Reply-To: <20161019132321.GD6323@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On 10/19/2016 06:23 AM, Christoph Hellwig wrote:
>> +/**
>> + * blk_mq_quiesce_queue() - wait until all ongoing queue_rq calls have finished
>> + *
>> + * Note: this function does not prevent that the struct request end_io()
>> + * callback function is invoked. Additionally, it is not prevented that
>> + * new queue_rq() calls occur unless the queue has been stopped first.
>> + */
>> +void blk_mq_quiesce_queue(struct request_queue *q)
>
> If this is intended to be a kerneldoc comment you need to document the 'q'
> parameter.  If not you should drop the magic "/**" marker.

Good catch. I will document the 'q' parameter.

>> +static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
>> +{
>> +	int srcu_idx;
>> +
>> +	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
>> +		cpu_online(hctx->next_cpu));
>> +
>> +	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
>> +		rcu_read_lock();
>> +		blk_mq_process_rq_list(hctx);
>> +		rcu_read_unlock();
>> +	} else {
>> +		srcu_idx = srcu_read_lock(&hctx->queue_rq_srcu);
>> +		blk_mq_process_rq_list(hctx);
>> +		srcu_read_unlock(&hctx->queue_rq_srcu, srcu_idx);
>> +	}
>> +}
>
> Can you document these synchronization changes in detail in the changelog?

Sure, I will do that.

>> +static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
>> +				      struct request *rq, blk_qc_t *cookie)
>> +{
>> +	if (blk_mq_hctx_stopped(hctx) ||
>> +	    blk_mq_direct_issue_request(rq, cookie) != 0)
>> +		blk_mq_insert_request(rq, false, true, true);
>> +}
>
> Any reason not to merge this function with blk_mq_direct_issue_request?

That sounds like a good idea to me. I will make the proposed change.

Bart.

