Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02452C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 07:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5B3F20759
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 07:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgF3Hca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 03:32:30 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2416 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730089AbgF3Hc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 03:32:29 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 42C4B91FCEED01591AEA;
        Tue, 30 Jun 2020 08:32:28 +0100 (IST)
Received: from [127.0.0.1] (10.47.7.58) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 30 Jun
 2020 08:32:26 +0100
Subject: Re: About sbitmap_bitmap_show() and cleared bits (was Re: [PATCH RFC
 v7 07/12] blk-mq: Add support in hctx_tags_bitmap_show() for a shared
 sbitmap)
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        <chenxiang66@hisilicon.com>, <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-8-git-send-email-john.garry@huawei.com>
 <9f4741c5-d117-d764-cf3a-a57192a788c3@suse.de>
 <aad6efa3-2d7f-ca68-d239-44ea187c8017@huawei.com>
 <7ed6ccf1-6ad9-1df7-f55d-4ed6cac1e08d@suse.de>
 <8ffd5c22-f644-3436-0a9f-2e08c220525e@huawei.com>
 <84f9623e-961e-3c9b-eed6-795b64f1ab76@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a30ff47d-a06a-13d6-ef5d-8c90ba3261eb@huawei.com>
Date:   Tue, 30 Jun 2020 08:30:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <84f9623e-961e-3c9b-eed6-795b64f1ab76@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.58]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/06/2020 07:33, Hannes Reinecke wrote:
> On 6/29/20 5:32 PM, John Garry wrote:
>> Hi all,
>>
>> I noticed that sbitmap_bitmap_show() only shows set bits and does not 
>> consider cleared bits. Is that the proper thing to do?
>>
>> I ask, as from trying to support sbitmap_bitmap_show() for hostwide 
>> shared tags feature, we currently use blk_mq_queue_tag_busy_iter() to 
>> find active requests (and associated tags/bits) for a particular hctx. 
>> So, AFAICT, would give a change in behavior for sbitmap_bitmap_show(), 
>> in that it would effectively show set and not cleared bits.
>>
> Why would you need to do this?
> Where would be the point traversing cleared bits?

I'm not talking about traversing cleared bits specifically. I just think 
that today sbitmap_bitmap_show() only showing the bits in 
sbitmap_word.word may not be useful or even misleading, as in reality 
the "set" bits are sbitmap_word.word & ~sbitmap_word.cleared.

And for hostwide shared tags feature, iterating the busy rqs to find the 
per-hctx tags/bits would effectively give us the "set" bits, above, so 
there would be a difference.

Thanks,
John
