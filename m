Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78533C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 10:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3457522B3B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 10:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgLGKQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 05:16:55 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2213 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgLGKQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 05:16:55 -0500
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CqJzJ57Nhz67Mb8;
        Mon,  7 Dec 2020 18:13:00 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 7 Dec 2020 11:16:13 +0100
Received: from [10.210.170.143] (10.210.170.143) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 7 Dec 2020 10:16:12 +0000
Subject: Re: [PATCH 03/21] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>, chenxiang <chenxiang66@hisilicon.com>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-4-hare@suse.de>
 <5b9e5684-2235-7ba7-f81f-6dc46ee141e9@huawei.com>
 <b60ff356-b17b-128a-7b32-8cef3a234286@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2debadf2-a120-e73f-7fd6-14a3eb89e320@huawei.com>
Date:   Mon, 7 Dec 2020 10:15:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <b60ff356-b17b-128a-7b32-8cef3a234286@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.143]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/11/2020 09:03, Hannes Reinecke wrote:
> On 11/16/20 9:56 AM, John Garry wrote:
>> On 03/07/2020 14:01, Hannes Reinecke wrote:
>>> Add helper functions to allow LLDDs to allocate and free
>>> internal commands.
>>
>> Hi Hannes,
>>
>> Is there any way to ensure that the request allocated is associated 
>> with some determined HW queue here?
>>
>> The reason for this requirement is that sometimes the LLDD must submit 
>> some internal IO (for which we allocate an "internal command") on a 
>> specific HW queue. An example of this is internal abort IO commands, 
>> which should be submitted on the same queue as the IO which we are 
>> attempting to abort was submitted.
>>
>> So, for sure, the LLDD does not have to honor the hwq associated with 
>> the request and submit on the desired queue, but then we lose the 
>> blk-mq CPU hotplug protection. And maybe other problems.
>>
>> One way to achieve this is to run scsi_get_internal_cmd() on a CPU 
>> associated with the desired HW queue, but that's a bit hacky. Not sure 
>> of another way.
>>
> Hmm. You are correct for the 'abort' command; that typically needs to be 
> submitted to a specific hwq.
> 
> Let me think about it...
> 


Hannes,

Earlier you mentioned " some drivers not only the command needs a tag, 
but the sgls also, thereby completely messing up our mq tags logic.
So to map those we'd need to allocate _several_ tags for one command ..."

Which drivers are these? Can you provide a pointer? Is this the blocker?

Thanks,
John
