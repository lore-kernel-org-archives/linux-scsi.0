Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BBEC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 08:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D982207FF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 08:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHRIfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:35:51 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2610 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgHRIfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 04:35:50 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id C133F7E0E8EBC5D06D85;
        Tue, 18 Aug 2020 09:35:48 +0100 (IST)
Received: from [127.0.0.1] (10.210.172.123) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Tue, 18 Aug
 2020 09:35:47 +0100
Subject: Re: [PATCH RFC v7 11/12] smartpqi: enable host tagset
To:     Hannes Reinecke <hare@suse.de>, <don.brace@microsemi.com>,
        <hare@suse.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-12-git-send-email-john.garry@huawei.com>
 <a8afea5c-97f2-ac84-f4b5-155963bebb2c@huawei.com>
 <f4425d8b-d132-c5c7-c854-2be948795bda@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <7c535e7f-9c32-3d53-cdcc-408e8faee46c@huawei.com>
Date:   Tue, 18 Aug 2020 09:33:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <f4425d8b-d132-c5c7-c854-2be948795bda@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.172.123]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2020 15:02, Hannes Reinecke wrote:
> On 7/14/20 3:16 PM, John Garry wrote:
>> Hi Hannes,
>>
>>>    static struct pqi_io_request *pqi_alloc_io_request(
>>> -    struct pqi_ctrl_info *ctrl_info)
>>> +    struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
>>>    {
>>>        struct pqi_io_request *io_request;
>>> +    unsigned int limit = PQI_RESERVED_IO_SLOTS;
>>>        u16 i = ctrl_info->next_io_request_slot;    /* benignly racy */
>>>    -    while (1) {
>>> +    if (scmd) {
>>> +        u32 blk_tag = blk_mq_unique_tag(scmd->request);
>>> +
>>> +        i = blk_mq_unique_tag_to_tag(blk_tag) + limit;
>>>            io_request = &ctrl_info->io_request_pool[i];
>>
>> This looks ok
>>
>>> -        if (atomic_inc_return(&io_request->refcount) == 1)
>>> -            break;
>>> -        atomic_dec(&io_request->refcount);
>>> -        i = (i + 1) % ctrl_info->max_io_slots;
>>> +        if (WARN_ON(atomic_inc_return(&io_request->refcount) > 1)) {
>>> +            atomic_dec(&io_request->refcount);
>>> +            return NULL;
>>> +        }
>>> +    } else {
>>> +        while (1) {
>>> +            io_request = &ctrl_info->io_request_pool[i];
>>> +            if (atomic_inc_return(&io_request->refcount) == 1)
>>> +                break;
>>> +            atomic_dec(&io_request->refcount);
>>> +            i = (i + 1) % limit;
>>
>> To me, the range we use here looks incorrect. I would assume we should
>> restrict range to [max_io_slots - PQI_RESERVED_IO_SLOTS, max_io_slots).
>>
>> But then your reserved commands support would solve that.
>>
> This branch of the 'if' condition will only be taken for internal
> commands, for which we only allow up to PQI_RESERVED_IO_SLOTS.
> And we set the 'normal' I/O commands above at an offset, so we're fine here.

Here is the code:

----8<----
	unsigned int limit = PQI_RESERVED_IO_SLOTS;
	u16 i = ctrl_info->next_io_request_slot; /* benignly racy */

	if (scmd) {
		u32 blk_tag = blk_mq_unique_tag(scmd->request);

		i = blk_mq_unique_tag_to_tag(blk_tag) + limit;
		io_request = &ctrl_info->io_request_pool[i];
		if (WARN_ON(atomic_inc_return(&io_request->refcount) > 1)) {
			atomic_dec(&io_request->refcount);
			return NULL;
		}
	} else {
		while (1) {
			io_request = &ctrl_info->io_request_pool[i];
			if (atomic_inc_return(&io_request->refcount) == 1)
				break;
			atomic_dec(&io_request->refcount);
			i = (i + 1) % limit;
		}
	}

	/* benignly racy */
	ctrl_info->next_io_request_slot = (i + 1) % ctrl_info->max_io_slots;

---->8----

Is how we set ctrl_info->next_io_request_slot ok? Should it be:

ctrl_info->next_io_request_slot = (i + 1) % limit;

And also moved into 'else' leg for good measure.

Thanks,
John
