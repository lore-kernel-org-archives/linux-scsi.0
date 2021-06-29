Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ADAC11F68
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 08:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E1661DD6
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 08:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhF2IZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 04:25:09 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3328 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhF2IYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2021 04:24:55 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GDcdd4jBLz6GBS1;
        Tue, 29 Jun 2021 16:12:05 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 10:22:26 +0200
Received: from [10.47.83.88] (10.47.83.88) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 29 Jun
 2021 09:22:26 +0100
Subject: Re: [PATCH] scsi: Delete scsi_{get,free}_host_dev()
To:     Hannes Reinecke <hare@suse.de>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hch@lst.de>, <ming.lei@redhat.com>
References: <1624640314-93055-1-git-send-email-john.garry@huawei.com>
 <044a31ed-f6e9-3017-4973-3a02765933e0@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <77afd764-4195-188d-ef0e-c4adcfa38f8b@huawei.com>
Date:   Tue, 29 Jun 2021 09:15:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <044a31ed-f6e9-3017-4973-3a02765933e0@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.88]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/06/2021 12:55, Hannes Reinecke wrote:
> On 6/25/21 6:58 PM, John Garry wrote:
>> Functions scsi_{get,free}_host_dev() no longer have any in-tree users, so
>> delete them.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>> An alt agenda of this patch is to get clarification on whether this API
>> should be used for Hannes' reserved commands series.
>>
>> Originally the recommendation was to use it, but now it seems to be to
>> not use it:
>> https://lore.kernel.org/linux-scsi/55918d68-7385-0153-0bd9-d822d3ce4c21@suse.de/ 
>>
>>
> Please don't.

ok, we can take that as a nacked-by for now.

> 
> Before we're doing something like this I would like to have 
> clarification from Christoph which way he prefers for reserved commands. 
> Personally I _do_ like the host dev approach for reserved commands as it 
> allows us to re-use existing infrastructure.

So when you deleted the gdth driver, the request there was to delete 
this API. And in the v8 series, again, the request was not to use it, 
and use the dedicated request queue instead - I do know that this 
conflicts with the much earlier suggestion not to do that, but that was 
when gdth existed.

As for reuse of existing infrastructure, using this API seems to add 
more code than it reuses.

So don't we just need to add a dedicated request_queue for host? I don't 
know the use in having the scsi_device. Having said all that, we don't 
seem to have a host request_queue sysfs entry with either solution, 
which would be good.

> 
> Christoph?
> 

Thanks,
John
