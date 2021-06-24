Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1B9C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 10:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99693613FC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 10:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhFXKD6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 06:03:58 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3304 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhFXKD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 06:03:56 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G9b4d37jhz6J6RX;
        Thu, 24 Jun 2021 17:51:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 12:01:35 +0200
Received: from [10.47.26.115] (10.47.26.115) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 24 Jun
 2021 11:01:34 +0100
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de>
 <d9c7f79f-f0ec-a420-517c-d6ca83d99ef9@acm.org>
 <e2b24fd6-fe1b-ac5e-e370-93900d98ac90@suse.de>
 <4ba63914-e308-ca62-8562-c0779a7ed05c@huawei.com>
 <8f6b1d3c-0119-b8f4-e630-2599c4b9fc26@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <22b77d3d-b47d-4a09-a49e-b78f35f9459a@huawei.com>
Date:   Thu, 24 Jun 2021 10:55:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <8f6b1d3c-0119-b8f4-e630-2599c4b9fc26@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.26.115]
X-ClientProxiedBy: lhreml723-chm.china.huawei.com (10.201.108.74) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/2021 14:48, Hannes Reinecke wrote:
>>
>> I will note that we also bypass the queue budgeting in 
>> blk_mq_ops.{get,put}_budget. I figure that is not an issue...
>>
>> BTW, any chance of a new version?
>>
> I have _so_ no idea.
> 
> The review from Christoph to patch 07/18 he (apparently) changed his 
> mind for the current implementation of using scsi_get_host_dev(), citing 
> an approach I had been implemented for v2 (and which got changed due to 
> his reviews for v2).
> So no I'm not sure if he retracted on his earlier review, or if he just 
> had forgotten about it.
> And before I get clarification from him I can't really move forward, as 
> both reviews contradict each other.
> 
> Christoph?

I see.

FWIW, not using scsi_get_host_dev() means that internal command 
scsi_cmnd.device cannot be set. But then many fields are not set there.

I suppose that if we delete scsi_get_host_dev() now [as it has no user], 
then that will narrow the choice...

BTW, I was just checking the v7, and we have no queue sysfs folder for 
that host scsi_device. Regardless of how the queue is created - v2 vs v7 
method - I think that we should have that somehow.

Thanks,
John
