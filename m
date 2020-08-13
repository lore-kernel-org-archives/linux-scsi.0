Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94747C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 04:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 738112076C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 04:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgHMEGj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 00:06:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9277 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgHMEGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Aug 2020 00:06:38 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AEF81B41A5826F961353;
        Thu, 13 Aug 2020 12:06:35 +0800 (CST)
Received: from [10.169.42.93] (10.169.42.93) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 13 Aug 2020
 12:06:13 +0800
Subject: Re: [PATCH 3/3] nvme-core: delete the dependency on
 REQ_FAILFAST_TRANSPORT
To:     Christoph Hellwig <hch@lst.de>
CC:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <kbusch@kernel.org>, <axboe@fb.com>, <sagi@grimberg.me>,
        <linux-scsi@vger.kernel.org>
References: <20200812081855.22277-1-lengchao@huawei.com>
 <20200812151340.GC29544@lst.de>
From:   Chao Leng <lengchao@huawei.com>
Message-ID: <f7301c1a-909c-d090-95f9-34af76154547@huawei.com>
Date:   Thu, 13 Aug 2020 12:06:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200812151340.GC29544@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.169.42.93]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/8/12 23:13, Christoph Hellwig wrote:
> On Wed, Aug 12, 2020 at 04:18:55PM +0800, Chao Leng wrote:
>> REQ_FAILFAST_TRANSPORT may be designed for scsi, because scsi protocol
>> do not difine the local retry mechanism. SCSI implements a fuzzy local
>> retry mechanism, so need the REQ_FAILFAST_TRANSPORT for multipath
>> software, if work with multipath software, ultraPath determines
>> whether to retry and how to retry.
>>
>> Nvme is different with scsi about this. It define local retry mechanism
>> and path error code, so nvme should retry local for non path error.
>> If path related error, whether to retry and how to retry is still
>> determined by ultraPath. REQ_FAILFAST_TRANSPORT just for non nvme
>> multipath software(like dm-multipath), but we do not need return an
>> error for REQ_FAILFAST_TRANSPORT first, because we need retry local
>> for non path error first.
> 
> This doesn't look wrong, but these kinds of changes really need to
> go along with block layer documentation of the intended uses of the
> flags.  In fact the SCSI usage also looks really confused to me and at
> very least needs better documentation if not changes.  So I think
Yes, SCSI do not define local retry, so complex processing logic is
required.
> you need to do a lot code archaeology, ping the authors and current
> maintainers and sort this out as well.
Now REQ_FAILFAST_TRANSPORT just used for multipath software, the patch
use the advantages of nvme, looks no bad effect.
> 
> More importantly if the above explanation makes sense we really need
> to kill blk_noretry_request off entirely and replace it with a check
> of the right set of flags in each caller as well.
