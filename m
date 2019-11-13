Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D6BC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 14:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC57222CA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 14:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfKMO5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:57:39 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2094 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfKMO5j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 09:57:39 -0500
Received: from lhreml701-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 3EBB479D1242E9871B03;
        Wed, 13 Nov 2019 14:57:37 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml701-cah.china.huawei.com (10.201.108.42) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 13 Nov 2019 14:57:35 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 13 Nov
 2019 14:57:35 +0000
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
Date:   Wed, 13 Nov 2019 14:57:33 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/11/2019 14:06, Hannes Reinecke wrote:
> On 11/13/19 2:36 PM, John Garry wrote:
>> Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
>> multiple reply queues with single hostwide tags.
>>
>> In addition, these drivers want to use interrupt assignment in
>> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
>> CPU hotplug may cause in-flight IO completion to not be serviced when an
>> interrupt is shutdown.
>>
>> To solve that problem, Ming's patchset to drain hctx's should ensure no
>> IOs are missed in-flight [1].
>>
>> However, to take advantage of that patchset, we need to map the HBA HW
>> queues to blk mq hctx's; to do that, we need to expose the HBA HW queues.
>>
>> In making that transition, the per-SCSI command request tags are no
>> longer unique per Scsi host - they are just unique per hctx. As such, the
>> HBA LLDD would have to generate this tag internally, which has a certain
>> performance overhead.
>>
>> However another problem is that blk mq assumes the host may accept
>> (Scsi_host.can_queue * #hw queue) commands. In [2], we removed the Scsi
>> host busy counter, which would stop the LLDD being sent more than
>> .can_queue commands; however, we should still ensure that the block layer
>> does not issue more than .can_queue commands to the Scsi host.
>>
>> To solve this problem, introduce a shared tags per blk_mq_tag_set, which
>> may be requested when allocating the tagset.
>>
>> New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
>> tagset.
>>
>> This is based on work originally from Ming Lei in [3].
>>
>> [0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
>> [1] https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@redhat.com/
>> [2] https://lore.kernel.org/linux-scsi/20191025065855.6309-1-ming.lei@redhat.com/
>> [3] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   block/blk-core.c       |  1 +
>>   block/blk-flush.c      |  2 +
>>   block/blk-mq-debugfs.c |  2 +-
>>   block/blk-mq-tag.c     | 85 ++++++++++++++++++++++++++++++++++++++++++
>>   block/blk-mq-tag.h     |  1 +
>>   block/blk-mq.c         | 61 +++++++++++++++++++++++++-----
>>   block/blk-mq.h         |  9 +++++
>>   include/linux/blk-mq.h |  3 ++
>>   include/linux/blkdev.h |  1 +
>>   9 files changed, 155 insertions(+), 10 deletions(-)
>>
> [ .. ]
>> @@ -396,15 +398,17 @@ static struct request *blk_mq_get_request(struct request_queue *q,
>>   		blk_mq_tag_busy(data->hctx);
>>   	}
>>   
>> -	tag = blk_mq_get_tag(data);
>> -	if (tag == BLK_MQ_TAG_FAIL) {
>> -		if (clear_ctx_on_error)
>> -			data->ctx = NULL;
>> -		blk_queue_exit(q);
>> -		return NULL;
>> +	if (data->hctx->shared_tags) {
>> +		shared_tag = blk_mq_get_shared_tag(data);
>> +		if (shared_tag == BLK_MQ_TAG_FAIL)
>> +			goto err_shared_tag;
>>   	}
>>   
>> -	rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags, alloc_time_ns);
>> +	tag = blk_mq_get_tag(data);
>> +	if (tag == BLK_MQ_TAG_FAIL)
>> +		goto err_tag;
>> +
>> +	rq = blk_mq_rq_ctx_init(data, tag, shared_tag, data->cmd_flags, alloc_time_ns);
>>   	if (!op_is_flush(data->cmd_flags)) {
>>   		rq->elv.icq = NULL;
>>   		if (e && e->type->ops.prepare_request) {

Hi Hannes,

> Why do you need to keep a parallel tag accounting between 'normal' and
> 'shared' tags here?
> Isn't is sufficient to get a shared tag only, and us that in lieo of the
> 'real' one?

In theory, yes. Just the 'shared' tag should be adequate.

A problem I see with this approach is that we lose the identity of which 
tags are allocated for each hctx. As an example for this, consider 
blk_mq_queue_tag_busy_iter(), which iterates the bits for each hctx. 
Now, if you're just using shared tags only, that wouldn't work.

Consider blk_mq_can_queue() as another example - this tells us if a hctx 
has any bits unset, while with only using shared tags it would tell if 
any bits unset over all queues, and this change in semantics could break 
things. At a glance, function __blk_mq_tag_idle() looks problematic also.

And this is where it becomes messy to implement.

> 
> I would love to combine both,

Same here...

  as then we can easily do a reverse mapping
> by using the 'tag' value to lookup the command itself, and can possibly
> do the 'scsi_cmd_priv' trick of embedding the LLDD-specific parts within
> the command. With this split we'll be wasting quite some memory there,
> as the possible 'tag' values are actually nr_hw_queues * shared_tags.

Yeah, understood. That's just a trade-off I saw.

Thanks,
John
