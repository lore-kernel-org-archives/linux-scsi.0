From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Fri, 12 Oct 2018 10:02:57 +0100
Message-ID: <3322d066-d118-320f-eb99-0fb03d530c67@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com> <20181011063603.GA3456@infradead.org>
 <118d01db-05f4-a85b-850c-c4e5a5616a16@huawei.com>
 <20181011101534.GA31802@infradead.org>
 <e2f35903-e28f-0fb5-7c61-47aa7f1a6926@huawei.com>
 <20181011133159.GA31355@ming.t460p>
 <519812c7-970a-976c-7db5-a035bf4f4e24@huawei.com>
 <20181011233633.GA30271@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181011233633.GA30271@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>, Kashyap Desai <kashyap.desai@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi Ming,

> In theory, you still may generate and manage the IPTT in the LLDD by
> simply ignoring rq->tag, meantime enabling SCSI_MQ with 16 hw queues.
>

Well at the moment we can't expose all 16 hw queues to upper layer 
anyway, due to ordering restiction imposed by HW on LLDD. We have a plan 
to solve it.

Regardless, we still found performance better by using rq tag instead of 
exposing all 16 queues.

> However, not sure how much this way may improve performance, and it may
> degrade IO perf. If 16 hw queues are exposed to blk-mq, 16*.can_queue
> requests may be queued to the driver, and allocation & free on the single
> IPTT pool will become a bottleneck.

Right, this IPTT management doesn't scale (especially for our host with 
2 sockets @ 48/64 cores each). So if upper layer is already generating a 
tag which we can use, good to use it.

>
> Per my experiment on host tagset, it might be a good tradeoff to allocate
> one hw queue for each node to avoid the remote access on dispatch
> data/requests structure for this case, but your IPTT pool is still
> shared all CPUs, maybe you can try the smart sbitmap.
>
> https://www.spinics.net/lists/linux-scsi/msg117920.html

I don't understand this about allocating a hw queue per node. Surely 
having and using all available queues in an intelligent way means less 
queue contention, right?

Looking at this change:
@@ -5761,6 +5762,11 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
  static int hpsa_scsi_add_host(struct ctlr_info *h)
  {
  	int rv;
+	/* 256 tags should be high enough to saturate device */
+	int max_queues = DIV_ROUND_UP(h->scsi_host->can_queue, 256);
+
+	/* per NUMA node hw queue */
+	h->scsi_host->nr_hw_queues = min_t(int, nr_node_ids, max_queues);

I assume h->scsi_host->nr_hw_queues was zero-init previously, so we're 
now using > 1 queue, but why limit?

>
>
>>
>>>
>>>>
>>>>> IFF you device needs different tags for different queues it can use
>>>>> the blk_mq_unique_tag heper to generate unique global tag.
>>>>
>>>> So this helper can't help, as fundamentially the issue is "the tag field in
>>>> struct request is unique per hardware queue but not all all hw queues".
>>>> Indeed blk_mq_unique_tag() does give a unique global tag, but cannot be used
>>>> for the IPTT.
>>>>
>>>> OTOH, We could expose 16 queues to upper layer, and drop 6/7, but we found
>>>> it performs worse.
>>>
>>> We discussed this issue before, but not found a good solution yet for
>>> exposing multiple hw queues to blk-mq.
>>
>> I just think that it's unfortunate that enabling blk-mq means that the LLDD
>> loses this unique tag across all queues in range [0, Scsi_host.can_queue),
>> so much so that we found performance better by not exposing multiple queues
>> and continuing to use single rq tag...
>
> It isn't a new problem, we discussed it a lot on megaraid_sas which has
> same situation with yours, you may find it in block list.

I'll do some digging.

>
> Kashyap Desai did lots of test on this case.
>
>>
>>>
>>> However, we still get good performance in case of none scheduler by the
>>> following patches:
>>>
>>> 8824f62246be blk-mq: fail the request in case issue failure
>>> 6ce3dd6eec11 blk-mq: issue directly if hw queue isn't busy in case of 'none'
>>>
>>
>> I think that these patches would have been included in our testing. I need
>> to check.
>
> Please switch to none io sched in your test, and it is observed that IO
> perf becomes good on megaraid_sas.

Hmmm... I thought that deadline was preferred.

>
> Thanks,
> Ming
>
> .
>

Much appreciated,
John
