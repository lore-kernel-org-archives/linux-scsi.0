Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF922C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 13:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B58C20780
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 13:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgC3NnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 09:43:05 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2617 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728301AbgC3NnE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 09:43:04 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 4BE4F118960F3A97A5F9;
        Mon, 30 Mar 2020 14:43:03 +0100 (IST)
Received: from [127.0.0.1] (10.47.8.155) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 30 Mar
 2020 14:43:01 +0100
Subject: Re: [PATCH RFC v2 12/24] hpsa: use reserved commands
To:     Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <bvanassche@acm.org>,
        <hch@infradead.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-13-git-send-email-john.garry@huawei.com>
 <20200311081059.GC31504@ming.t460p>
 <a76ab13a-85a3-0d88-595f-af13ef1b3fe3@huawei.com>
 <881b6a9b-2137-946f-a900-5c4e6cf1fe37@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c3f5c030-d735-c730-6ff9-19cb1cb50fe8@huawei.com>
Date:   Mon, 30 Mar 2020 14:42:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <881b6a9b-2137-946f-a900-5c4e6cf1fe37@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.8.155]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/03/2020 09:48, Hannes Reinecke wrote:
> On 3/17/20 10:38 AM, John Garry wrote:
>> On 11/03/2020 08:10, Ming Lei wrote:
>>>> ands(struct ctlr_info *h)
>>>> @@ -5803,6 +5803,7 @@ static int hpsa_scsi_host_alloc(struct 
>>>> ctlr_info *h)
>>>>       sh->max_lun = HPSA_MAX_LUN;
>>>>       sh->max_id = HPSA_MAX_LUN;
>>>>       sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
>>>> +    sh->nr_reserved_cmds = HPSA_NRESERVED_CMDS;
>>> Now .nr_reserved_cmds has been passed to blk-mq, you need to increase
>>> sh->can_queue to h->nr_cmds, because .can_queue is the whole queue depth
>>> (include the part of reserved tags), otherwise, IO tags will be
>>> decreased.
>>>
>>
>> Sounds correct.
>>
> I will have having a look at the patchset; I thought I did a patch to 
> modify .can_queue so that it would cover only the usable tags, not the 
> reserved ones.
> 

To me, it makes sense to leave .can_queue unmodified, carry it down to 
blk-mq and allow blk_mq_init_bitmap_tags() find the queue depth:

static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
   int node, int alloc_policy)
{
	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags; *
	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;

	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
		goto free_tags;

Cheers,
John
