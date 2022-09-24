Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF30DC04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 01:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiIXBWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 21:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiIXBWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 21:22:23 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1E6107DCC
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 18:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663982542; x=1695518542;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j0figFZxEreBSY1Cx+kndYnHpnAJ/z2W8eA8gokM7Is=;
  b=pNKGDNmILbcYRteOlYnaoCJ/zPP8d+QIATcCa8vd3bJHzkx1U5SqNMN7
   81LC19s7Jvpr7jj8MtFRZEQQJ2c6rHYUCLsChoIq08879OrNbsuNhm0rW
   U2SIcSauec7X3eo3JBULNxk5PKmsYvZV8shqRNhBTlTC5/JXHvODam99+
   FR92eUhI6fG3Cd9JWCKCrPgbseJfnHkStvTmuHexce5Gyne/JSBEm3+uQ
   65FxngGkQFXrACNT5pJDwLObpgmk//fnb7EJSJDWkP9fUSUL1uTM2KArk
   EDr4ert09qDNOJs1kOoYrGbseCHdbiztoAm5wFB1wCW6WYAA2WXFCMlu+
   g==;
X-IronPort-AV: E=Sophos;i="5.93,340,1654531200"; 
   d="scan'208";a="316438458"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Sep 2022 09:22:22 +0800
IronPort-SDR: R1UGu10J+E1jljNFKmGYZJlVgBzbw8MzZFjRSkZP8J/C3ifAPSSTst7WZegtFI0glAjymvxzJ2
 6dtQu29UP5Ma5OHI8KBTnmbINSJYoaEclRVoN/NIp4NW3DzyD8p4TNWDOclQKkPpnjdmvvkFhG
 gTvLN04u2ddTCT8U9T+PYNIzY2/sqdKLox8lYdd2TCtYz5nEUnAOdY7AHW+vq+Xx3FvajDxUn/
 p975yvaQ5VQ8Xk+MamLofEqvdDjqG8bexZ36Z7WMUcC/TMxhHhYaH9eWSO5XIrNkaAjuetox6R
 e/k5y8buS9He7celwDoAGYKp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Sep 2022 17:36:53 -0700
IronPort-SDR: ChRiPuJjSLX6Sy4wC5JuhHqBu+w4HFvE+EHDrJfGujbYU5QWKUAW/JM8TuP3/2jq0cFCM4FKLI
 xlpw1TldxPqbjaoJkTYFeap4TURCQQGw5AJRGf4/2G9iHnW1i9MViVMXLMnuoAjmGz7RIPxUyR
 Kf1jHz7YWkAbXrV7IoVxvNcZUmd8bpL1OfgjlUeifXKauNs0/9VQycoEenhLdqhROh48ln7KO6
 9RNCyZfDaNJsBYGmAnXqsWfr2PhIHWXsXthBLlZNmejVnEQiKLn9XlcaeuBx6ylYEC1DcpG7jx
 3DM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Sep 2022 18:22:22 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MZB8F4JTnz1Rwtl
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 18:22:21 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1663982540; x=1666574541; bh=j0figFZxEreBSY1Cx+kndYnHpnAJ/z2W8eA
        8gokM7Is=; b=HE3yobUHVvBYIlWMJ/QWkRq7tLCgWTCTLvjkMMdZw+WB95AjRX+
        5sh8hJ0XRIeZz765wODHqKzd3pThIGJ7h1DaqQzRukFBMavLfuqXKOv+O+jlDNKz
        cUwrBr7wSdN7I3nWPAgvo0EIgrYx9PxBSnQzKVVHhjKajrLzZxq4d51PuXGVlvZb
        fPDuUQFbAucGQEz3lEkuUYiytF+/PRJhF7nlPEfFmntVHZqc/f7q/p3waEn4uU5r
        Gw1i99kYUKzJctqq850WK0XhGTMv1O+WANuDie1uSq5GDupaNm7Ztj7WBczZj+RK
        ln0qmS/sa+8+6ciIf7J4CouDdkZ82J6XEpg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hW43DQR9SZhL for <linux-scsi@vger.kernel.org>;
        Fri, 23 Sep 2022 18:22:20 -0700 (PDT)
Received: from [10.225.163.88] (unknown [10.225.163.88])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MZB8C3xM5z1RvLy;
        Fri, 23 Sep 2022 18:22:19 -0700 (PDT)
Message-ID: <4e9ae1d2-1db4-aff6-e280-6ea282161b7b@opensource.wdc.com>
Date:   Sat, 24 Sep 2022 10:22:18 +0900
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
 <a06df4ba-a968-0ee1-f8ff-062def0ec031@opensource.wdc.com>
 <ba0b3ae4-7001-af42-3549-cc52049ccccb@kernel.dk>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <ba0b3ae4-7001-af42-3549-cc52049ccccb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/22 10:01, Jens Axboe wrote:
> On 9/23/22 6:59 PM, Damien Le Moal wrote:
>> On 9/24/22 05:54, Jens Axboe wrote:
>>> On 9/23/22 9:13 AM, Pankaj Raghav wrote:
>>>> On 2022-09-23 16:52, Pankaj Raghav wrote:
>>>>> On Thu, Sep 22, 2022 at 12:28:01PM -0600, Jens Axboe wrote:
>>>>>> The filesystem IO path can take advantage of allocating batches of
>>>>>> requests, if the underlying submitter tells the block layer about it
>>>>>> through the blk_plug. For passthrough IO, the exported API is the
>>>>>> blk_mq_alloc_request() helper, and that one does not allow for
>>>>>> request caching.
>>>>>>
>>>>>> Wire up request caching for blk_mq_alloc_request(), which is generally
>>>>>> done without having a bio available upfront.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>  block/blk-mq.c | 80 ++++++++++++++++++++++++++++++++++++++++++++------
>>>>>>  1 file changed, 71 insertions(+), 9 deletions(-)
>>>>>>
>>>>> I think we need this patch to ensure correct behaviour for passthrough:
>>>>>
>>>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>>>> index c11949d66163..840541c1ab40 100644
>>>>> --- a/block/blk-mq.c
>>>>> +++ b/block/blk-mq.c
>>>>> @@ -1213,7 +1213,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
>>>>>         WARN_ON(!blk_rq_is_passthrough(rq));
>>>>>  
>>>>>         blk_account_io_start(rq);
>>>>> -       if (current->plug)
>>>>> +       if (blk_mq_plug(rq->bio))
>>>>>                 blk_add_rq_to_plug(current->plug, rq);
>>>>>         else
>>>>>                 blk_mq_sched_insert_request(rq, at_head, true, false);
>>>>>
>>>>> As the passthrough path can now support request caching via blk_mq_alloc_request(),
>>>>> and it uses blk_execute_rq_nowait(), bad things can happen at least for zoned
>>>>> devices:
>>>>>
>>>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>>>> {
>>>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>>>> 	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
>>>>> 		return NULL;
>>>>> ..
>>>>
>>>> Thinking more about it, even this will not fix it because op is
>>>> REQ_OP_DRV_OUT if it is a NVMe write for passthrough requests.
>>>>
>>>> @Damien Should the condition in blk_mq_plug() be changed to:
>>>>
>>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>>> {
>>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>>> 	if (bdev_is_zoned(bio->bi_bdev) && !op_is_read(bio_op(bio)))
>>>> 		return NULL;
>>>
>>> That looks reasonable to me. It'll prevent plug optimizations even
>>> for passthrough on zoned devices, but that's probably fine.
>>
>> Could do:
>>
>> 	if (blk_op_is_passthrough(bio_op(bio)) ||
>> 	    (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio))))
>> 		return NULL;
>>
>> Which I think is way cleaner. No ?
>> Unless you want to preserve plugging with passthrough commands on regular
>> (not zoned) drives ?
> 
> We most certainly do, without plugging this whole patchset is not
> functional. Nor is batched dispatch, for example.

OK. Then the change to !op_is_read() is fine then.

> 

-- 
Damien Le Moal
Western Digital Research

