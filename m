Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448DFC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 08:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1258A6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 08:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhDTIRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 04:17:25 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2887 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhDTIRZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 04:17:25 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FPbxB3wz9z6yhbT;
        Tue, 20 Apr 2021 16:11:26 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 10:16:51 +0200
Received: from [10.47.91.165] (10.47.91.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Apr
 2021 09:16:51 +0100
Subject: Re: [PATCH] scsi: core: Cap initial sdev queue depth at
 shost.can_queue
To:     Ming Lei <ming.lei@redhat.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <dgilbert@interlog.com>
References: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
 <YH4aIECa/J/1uS5S@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <bba5f248-523d-0def-1a3e-bafeb2b7633f@huawei.com>
Date:   Tue, 20 Apr 2021 09:14:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YH4aIECa/J/1uS5S@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.165]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/04/2021 01:02, Ming Lei wrote:
> On Tue, Apr 20, 2021 at 12:06:24AM +0800, John Garry wrote:
>> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
>> exceed shost.can_queue.
>>
>> However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
>> initial sdev queue depth greater than can_queue.
>>
>> Stop this happened by capping initial sdev queue depth at can_queue.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>> Topic originally discussed at:
>> https://lore.kernel.org/linux-scsi/85dec8eb-8eab-c7d6-b0fb-5622747c5499@interlog.com/T/#m5663d0cac657d843b93d0c9a2374f98fc04384b9
>>
>> Last idea there was to error/warn in scsi_add_host() for cmd_per_lun >
> 

Hi Ming,

> No, that isn't my suggestion.

Right, it was what I mentioned.

> 
>> can_queue. However, such a shost driver could still configure the sdev
>> queue depth to be sound value at .slave_configure callback, so now thinking
>> the orig patch better.
> 
> As I mentioned last time, why can't we fix ->cmd_per_lun in
> scsi_add_host() using .can_queue?
> 

I would rather not change the values which are provided from the driver. 
I would rather take the original values and try to use them in a sane way.

I have not seen other places where driver shost config values are 
modified by the core code.

Thanks,
John
