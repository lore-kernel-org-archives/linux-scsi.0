Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65C8C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A47D12333F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgLGL5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 06:57:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:35708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgLGL5O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 06:57:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB8CFAC9A;
        Mon,  7 Dec 2020 11:56:32 +0000 (UTC)
Subject: Re: [PATCH v2 01/17] ibmvfc: add vhost fields and defaults for MQ
 enablement
To:     Brian King <brking@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201202005329.4538-1-tyreld@linux.ibm.com>
 <20201202005329.4538-2-tyreld@linux.ibm.com>
 <a11c0e6a-cfa6-0dc4-5d34-6fd35ae1f29b@linux.vnet.ibm.com>
 <38903a4f-9253-0b4b-6f67-af78ec86175f@linux.ibm.com>
 <efbfe9e9-c692-80a1-f5b4-55473d8193e4@linux.vnet.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6ce79011-d288-7a49-3d51-262da58d8486@suse.de>
Date:   Mon, 7 Dec 2020 12:56:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <efbfe9e9-c692-80a1-f5b4-55473d8193e4@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/4/20 3:26 PM, Brian King wrote:
> On 12/2/20 11:27 AM, Tyrel Datwyler wrote:
>> On 12/2/20 7:14 AM, Brian King wrote:
>>> On 12/1/20 6:53 PM, Tyrel Datwyler wrote:
>>>> Introduce several new vhost fields for managing MQ state of the adapter
>>>> as well as initial defaults for MQ enablement.
>>>>
>>>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>>>> ---
>>>>   drivers/scsi/ibmvscsi/ibmvfc.c |  9 ++++++++-
>>>>   drivers/scsi/ibmvscsi/ibmvfc.h | 13 +++++++++++--
>>>>   2 files changed, 19 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>>>> index 42e4d35e0d35..f1d677a7423d 100644
>>>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>>>> @@ -5161,12 +5161,13 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>>>   	}
>>>>   
>>>>   	shost->transportt = ibmvfc_transport_template;
>>>> -	shost->can_queue = max_requests;
>>>> +	shost->can_queue = (max_requests / IBMVFC_SCSI_HW_QUEUES);
>>>
>>> This doesn't look right. can_queue is the SCSI host queue depth, not the MQ queue depth.
>>
>> Our max_requests is the total number commands allowed across all queues. From
>> what I understand is can_queue is the total number of commands in flight allowed
>> for each hw queue.
>>
>>          /*
>>           * In scsi-mq mode, the number of hardware queues supported by the LLD.
>>           *
>>           * Note: it is assumed that each hardware queue has a queue depth of
>>           * can_queue. In other words, the total queue depth per host
>>           * is nr_hw_queues * can_queue. However, for when host_tagset is set,
>>           * the total queue depth is can_queue.
>>           */
>>
>> We currently don't use the host wide shared tagset.
> 
> Ok. I missed that bit... In that case, since we allocate by default only 100
> event structs. If we slice that across IBMVFC_SCSI_HW_QUEUES (16) queues, then
> we end up with only about 6 commands that can be outstanding per queue,
> which is going to really hurt performance... I'd suggest bumping up
> IBMVFC_MAX_REQUESTS_DEFAULT from 100 to 1000 as a starting point.
> 
Before doing that I'd rather use the host-wide shared tagset.
Increasing the number of requests will increase the memory footprint of 
the driver (as each request will be statically allocated).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
