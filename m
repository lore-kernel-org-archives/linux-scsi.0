Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73EAC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 11:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F54D20760
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 11:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbgF3LiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 07:38:24 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2421 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731382AbgF3LiW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 07:38:22 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 011AE30E3D89DB2688FB;
        Tue, 30 Jun 2020 12:38:21 +0100 (IST)
Received: from [127.0.0.1] (10.47.7.58) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 30 Jun
 2020 12:38:19 +0100
Subject: Re: About sbitmap_bitmap_show() and cleared bits (was Re: [PATCH RFC
 v7 07/12] blk-mq: Add support in hctx_tags_bitmap_show() for a shared
 sbitmap)
From:   John Garry <john.garry@huawei.com>
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
 <a30ff47d-a06a-13d6-ef5d-8c90ba3261eb@huawei.com>
Message-ID: <c95f6566-0f17-9d11-a52a-ac7433c8a2f0@huawei.com>
Date:   Tue, 30 Jun 2020 12:36:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <a30ff47d-a06a-13d6-ef5d-8c90ba3261eb@huawei.com>
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

On 30/06/2020 08:30, John Garry wrote:
> On 30/06/2020 07:33, Hannes Reinecke wrote:
>> On 6/29/20 5:32 PM, John Garry wrote:
>>> Hi all,
>>>
>>> I noticed that sbitmap_bitmap_show() only shows set bits and does not 
>>> consider cleared bits. Is that the proper thing to do?
>>>
>>> I ask, as from trying to support sbitmap_bitmap_show() for hostwide 
>>> shared tags feature, we currently use blk_mq_queue_tag_busy_iter() to 
>>> find active requests (and associated tags/bits) for a particular 
>>> hctx. So, AFAICT, would give a change in behavior for 
>>> sbitmap_bitmap_show(), in that it would effectively show set and not 
>>> cleared bits.
>>>
>> Why would you need to do this?
>> Where would be the point traversing cleared bits?
> 
> I'm not talking about traversing cleared bits specifically. I just think 
> that today sbitmap_bitmap_show() only showing the bits in 
> sbitmap_word.word may not be useful or even misleading, as in reality 
> the "set" bits are sbitmap_word.word & ~sbitmap_word.cleared.
> 
> And for hostwide shared tags feature, iterating the busy rqs to find the 
> per-hctx tags/bits would effectively give us the "set" bits, above, so 
> there would be a difference.
> 

As an example, here's a sample tags_bitmap output:

00000000: 00f0 0fff 03c0 0000 0000 0000 efff fdff
00000010: 0000 c0f7 7fff ffff 0000 00e0 fef7 ffff
00000020: 0000 0000 f0ff ffff 0000 ffff 01d0 ffff
00000030: 0f80

And here's what we would have taking cleared bits into account:

00000000: 00f0 0fff 03c0 0000 0000 0000 0000 0000 (20 bits set)
00000010: 0000 0000 0000 0000 0000 0000 0000 0000
00000020: 0000 0000 0000 0000 0000 f8ff 0110 8000 (16 bits set)
00000030: 0f00					  (1 bit set)

Here's tags file output:

nr_tags=400
nr_reserved_tags=0
active_queues=2

bitmap_tags:
depth=400
busy=40
cleared=182
bits_per_word=64
map_nr=7
alloc_hint={22, 0, 0, 0, 103, 389, 231, 57, 377, 167, 0, 0, 69, 24, 44, 
50, 54,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0
, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
wake_batch=8
wake_index=0

[snip]

20+16+1=39 more closely matches with busy=40.

So it seems sensible to go this way for whether hostwide tags are used 
or not.

thanks,
John
