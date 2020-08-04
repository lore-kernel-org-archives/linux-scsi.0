Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C03FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 17:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269A6207FC
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 17:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgHDRDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 13:03:42 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2566 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgHDRDf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Aug 2020 13:03:35 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 8CEB3D9EE9533AB18F25;
        Tue,  4 Aug 2020 18:02:58 +0100 (IST)
Received: from [127.0.0.1] (10.47.11.189) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 4 Aug 2020
 18:02:57 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <bvanassche@acm.org>,
        <hare@suse.com>, <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
 <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0610dce9-a5d0-ebb8-757f-0c7026891e25@huawei.com>
Date:   Tue, 4 Aug 2020 18:00:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200728084511.GA1326626@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.11.189]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/07/2020 09:45, Ming Lei wrote:
>> OK, so dynamically allocating the sbitmap could be good. I was thinking
>> previously that we still allocate for nr_cpus size, and search a limited
>> range - but this would have heavier runtime overhead.
>>
>> So if you really think that this may have some value, then let me know, so
>> we can look to take it forward.

Hi Ming,

> Forget to mention, the in-tree code has been this shape for long
> time, please see sbitmap_resize() called from blk_mq_map_swqueue().

So after the resize, even if we are only checking a single word and a 
few bits within that word, we still need 2x 64b loads - 1x for .word and 
1x for .cleared. Seems a bit inefficient for caching when we have a 1:1 
mapping or similar. For 1:1 case only, how about a ctx_map per queue for 
all hctx, with a single bit per hctx? I do realize that it makes the 
code more complicated, but it could be more efficient.

Another thing to consider is that for ctx_map, we don't do deferred bit 
clear, so we don't ever really need to check .cleared there. I think.

Thanks,
John
