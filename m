Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF76FC04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 01:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiIXBAB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 21:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiIXA76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 20:59:58 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF8830F6C
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 17:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663981197; x=1695517197;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H7T05O47XpwCtajDZM5zYG5x8fGP2AaZXpX62UZ1rNk=;
  b=cdAMtiDPbZ1BkKC+J2TswD7MGqcJ+E+xcosUjUs42jw658w8zCO/NMao
   rc610n32VWkOQ8nWZQtumRF3FKcqopQ1RHE3y7UNP0UQdiA1w2TYE4Yxa
   jmiPkabqwO4wQf/SCq59gyXOBOKlomAw8WqaIGOyyKNswy8ei0sT84YwT
   qHEbEtDEN3SETg4MNYiZtlG7/xBx6RLd5A0DaYJ0NhOlKkCzl4Nsq06PU
   Edg5T3jvkChTVXq9gtF2T3vh/cLjHyPL5Dr2lf4+2RIGa0R63EipncM/W
   HSs7IKwwiVycFG4h1sKCl/7fKCiuDsrdBDiJOEyCaQYdXfIco76nJQaVb
   g==;
X-IronPort-AV: E=Sophos;i="5.93,340,1654531200"; 
   d="scan'208";a="316437423"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Sep 2022 08:59:53 +0800
IronPort-SDR: w08W7HO35ZrVfqpS8OrUmJzj/UAoaYRz6cIz4bM8GJN0BR69kYazcCJ5uxiFU2Ebs7KtB0cCh6
 LQOYTDLb0tHXUsswD3SlIjSVVZgmNhcO+58y8XH0Lk54BNyOIMQSOZfnNUDsFNmMuXAoHJmicV
 73wjhxu4eNrf8io+9ju0cvN6mvoHawMS/gDqFdvLexcIdksWgG3hy4NjLMlVH+M5YLDNlKsaEx
 JwQHwg+gdA1ytf/QlCx1jCvYXRYHDp0GcP+soPPzuuf/E3HSojxGA9MJor6PkUKDrZUcbubfg6
 C7XcbF6vcTTe0gBS5Q+q42+T
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Sep 2022 17:14:24 -0700
IronPort-SDR: rBCWsuod4Iro92tV2iJ/l9rg+T2Cq9F47bK7rOz6mCWRBenx9vewiaOGDNVjHAGd361AGoAoJN
 3yRsREtDf7kHUIc0G6YkxhPoDwErkPSgwGz+Rtg0yInNlzvmu00ZCy52jdwu+Pa1mWRfLTb5rg
 mPygc2Ej5dEpSkaWTwe1NTNfYjdDZOb/+4utd/3Y0qM4i1iclMnuqmgGFJVakWeWsJmLT5fOF0
 RTbcT4+DMjAgfblwGfdR5kpj3l476SdYJ4WCdTEd5XW72A0FdCXNLvZC7TccFWA3+D7oUiQMND
 fdc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Sep 2022 17:59:54 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MZ9fK14Fqz1RwtC
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 17:59:53 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1663981192; x=1666573193; bh=H7T05O47XpwCtajDZM5zYG5x8fGP2AaZXpX
        62UZ1rNk=; b=hpOSGwBu3+pGwvslvSOU82CjqOVm+828jdvQKOAZABYd3fzCvQY
        ouLJ/WGwyxeIeFP0C8Rput+7taAjNJlRPtjcwC3puYtjgrU1Rxq4mYbrQw64z2cq
        gdvj9h7eBYnkc+2JfgjyEs2yrljdBEOveeH0xBmS5TSRqhoHRj0wwSpqxcMWKYYH
        CgynmOIrOQyHTFQOrPjk1Wc1sF+s6N2jZNCEla7W6jcmQC9H72pmIJupLqEaI5gb
        bzYRyBXVOdmqXfUZWEbY+iu2YsSIRvD2RpAvQCUO/drepsrNZMK+boSyBHjKv3Bv
        bUX3/70Ag45jGKnIx/GffRovaLeHs7U5g3w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zEvtiGudcGC3 for <linux-scsi@vger.kernel.org>;
        Fri, 23 Sep 2022 17:59:52 -0700 (PDT)
Received: from [10.225.163.88] (unknown [10.225.163.88])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MZ9fH0Vlsz1RvLy;
        Fri, 23 Sep 2022 17:59:50 -0700 (PDT)
Message-ID: <a06df4ba-a968-0ee1-f8ff-062def0ec031@opensource.wdc.com>
Date:   Sat, 24 Sep 2022 09:59:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 1/5] block: enable batched allocation for
 blk_mq_alloc_request()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Pankaj Raghav <p.raghav@samsung.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, joshi.k@samsung.com,
        Pankaj Raghav <pankydev8@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-2-axboe@kernel.dk>
 <CGME20220923145245eucas1p107655755f446bb1e1318539a3f82d301@eucas1p1.samsung.com>
 <20220923145236.pr7ssckko4okklo2@quentin>
 <c7b76fa1-f7e3-3ac6-c92d-35baa0d9a40a@samsung.com>
 <2e484ccb-b65b-2991-e259-d3f7be6ad1a6@kernel.dk>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <2e484ccb-b65b-2991-e259-d3f7be6ad1a6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/22 05:54, Jens Axboe wrote:
> On 9/23/22 9:13 AM, Pankaj Raghav wrote:
>> On 2022-09-23 16:52, Pankaj Raghav wrote:
>>> On Thu, Sep 22, 2022 at 12:28:01PM -0600, Jens Axboe wrote:
>>>> The filesystem IO path can take advantage of allocating batches of
>>>> requests, if the underlying submitter tells the block layer about it
>>>> through the blk_plug. For passthrough IO, the exported API is the
>>>> blk_mq_alloc_request() helper, and that one does not allow for
>>>> request caching.
>>>>
>>>> Wire up request caching for blk_mq_alloc_request(), which is generally
>>>> done without having a bio available upfront.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  block/blk-mq.c | 80 ++++++++++++++++++++++++++++++++++++++++++++------
>>>>  1 file changed, 71 insertions(+), 9 deletions(-)
>>>>
>>> I think we need this patch to ensure correct behaviour for passthrough:
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index c11949d66163..840541c1ab40 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -1213,7 +1213,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
>>>         WARN_ON(!blk_rq_is_passthrough(rq));
>>>  
>>>         blk_account_io_start(rq);
>>> -       if (current->plug)
>>> +       if (blk_mq_plug(rq->bio))
>>>                 blk_add_rq_to_plug(current->plug, rq);
>>>         else
>>>                 blk_mq_sched_insert_request(rq, at_head, true, false);
>>>
>>> As the passthrough path can now support request caching via blk_mq_alloc_request(),
>>> and it uses blk_execute_rq_nowait(), bad things can happen at least for zoned
>>> devices:
>>>
>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>> {
>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>> 	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
>>> 		return NULL;
>>> ..
>>
>> Thinking more about it, even this will not fix it because op is
>> REQ_OP_DRV_OUT if it is a NVMe write for passthrough requests.
>>
>> @Damien Should the condition in blk_mq_plug() be changed to:
>>
>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>> {
>> 	/* Zoned block device write operation case: do not plug the BIO */
>> 	if (bdev_is_zoned(bio->bi_bdev) && !op_is_read(bio_op(bio)))
>> 		return NULL;
> 
> That looks reasonable to me. It'll prevent plug optimizations even
> for passthrough on zoned devices, but that's probably fine.

Could do:

	if (blk_op_is_passthrough(bio_op(bio)) ||
	    (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio))))
		return NULL;

Which I think is way cleaner. No ?
Unless you want to preserve plugging with passthrough commands on regular
(not zoned) drives ?

-- 
Damien Le Moal
Western Digital Research

