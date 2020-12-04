Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C70C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 09:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC9A227BF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 09:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgLDJBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 04:01:55 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2203 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgLDJBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 04:01:55 -0500
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CnRSK1ndKz67LVb;
        Fri,  4 Dec 2020 16:58:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 4 Dec 2020 10:01:12 +0100
Received: from [10.47.5.251] (10.47.5.251) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Dec 2020
 09:01:12 +0000
Subject: Re: [PATCH v2 4/4] scsi: set shost as hctx driver_data
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20201203034100.29716-1-kashyap.desai@broadcom.com>
 <20201203034100.29716-5-kashyap.desai@broadcom.com>
 <3ee6826b-e010-8874-0447-da8e9b1e8971@huawei.com>
 <5d8d57aa81706e44b4e7a25dae606f39@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b1a4565b-ac96-be2e-499a-a2caac10cec2@huawei.com>
Date:   Fri, 4 Dec 2020 09:00:42 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <5d8d57aa81706e44b4e7a25dae606f39@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.5.251]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/12/2020 13:30, Kashyap Desai wrote:
>> -----Original Message-----
>> From: John Garry [mailto:john.garry@huawei.com]
>> Sent: Thursday, December 3, 2020 6:57 PM
>> To: Kashyap Desai <kashyap.desai@broadcom.com>; linux-
>> scsi@vger.kernel.org; linux-block@vger.kernel.org
>> Subject: Re: [PATCH v2 4/4] scsi: set shost as hctx driver_data
>>
>> On 03/12/2020 03:41, Kashyap Desai wrote:
>>> hctx->driver_data is not set for SCSI currently.
>>> Separately set hctx->driver_data = shost.
>>
>> nit: this looks ok to me, but I would have made as an earlier patch so
>> that you
>> don't add code and then remove it:
> 
> I added later - Just in case someone report issue in " scsi_commit_rqs" due
> to this patch, we can revert back easily.
> I tested scsi_mq_poll but not scsi_commit_rqs part.
> 

We should be a bit more confident in the patch :)

anyway,

Reviewed-by: John Garry <john.garry@huawei.com>

> 
>>
>>   >   static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
>>   >   {
>>   > -	struct request_queue *q = hctx->queue;
>>   > -	struct scsi_device *sdev = q->queuedata;
>>   > -	struct Scsi_Host *shost = sdev->host;
>>
>> Thanks,
>> John
>>

