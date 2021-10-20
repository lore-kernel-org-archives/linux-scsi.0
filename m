Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065F7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 11:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D648461372
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 11:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhJTLQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 07:16:56 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4008 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhJTLQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 07:16:55 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HZ7FG37HVz6896K;
        Wed, 20 Oct 2021 19:10:26 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Wed, 20 Oct 2021 13:14:40 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 20 Oct 2021 12:14:39 +0100
Subject: Re: [PATCHSET v3] Batched completions
To:     Jens Axboe <axboe@kernel.dk>, <linux-block@vger.kernel.org>
References: <20211017020623.77815-1-axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b47e9ae3-52e0-8cfa-9dcb-bfd46ad4c46d@huawei.com>
Date:   Wed, 20 Oct 2021 12:14:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211017020623.77815-1-axboe@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/10/2021 03:06, Jens Axboe wrote:
> Hi,

+linux-scsi

> 
> We now do decent batching of allocations for submit, but we still
> complete requests individually. This costs a lot of CPU cycles.
> 
> This patchset adds support for collecting requests for completion,
> and then completing them as a batch. This includes things like freeing
> a batch of tags.
> 
> This version is looking pretty good to me now, and should be ready
> for 5.16.

Just wondering if anyone was looking at supporting this for SCSI 
midlayer? I was thinking about looking at it...

> 
> Changes since v2:
> - Get rid of dev_id
> - Get rid of mq_ops->complete_batch
> - Drop now unnecessary ib->complete setting in blk_poll()
> - Drop one sbitmap patch that was questionnable
> - Rename io_batch to io_comp_batch
> - Track need_timestamp on per-iob basis instead of for each request
> - Drop elevator support for batching, cleaner without
> - Make the batched driver addition simpler
> - Unify nvme polled/irq handling
> - Drop io_uring file checking, no longer neededd
> - Cleanup io_uring completion side
> 

