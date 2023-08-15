Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDCBC04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 01:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjHOBxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 21:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjHOBxB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 21:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617C6B0;
        Mon, 14 Aug 2023 18:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F192964F90;
        Tue, 15 Aug 2023 01:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D78EC433C8;
        Tue, 15 Aug 2023 01:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692064379;
        bh=+gMtWyYUJ+r4hafaHAp80BOsmuUEuuPjy8FAmemD3t8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CxvpYlNJhagAqcqP3QxzhO1I0jxVVz+dfJS/nlkENcwOy1JelOFGlBNn2tf47nFl2
         ZoWiY6QdAnFSTGcyxbwRtTcdPvvSi4CaVv6GmiPxPfvCMAsAU/neqsHp+wTmg0zV7e
         8/esQChogF+CBobncvnYTY8IVwJCxJ8Dl6b9gTjKy5bVTVmAbvCvzwDgK72myrr+T+
         Ws85Sb1MTUAbUXmPKGPxwO4iChRsU5qYTVN4nZ1gkwCCOqBuzD67XiuIuUf2cF5bAY
         WvJGGYFsPvnk8mgMfMN7+NW+rS7gVSvEF5Fbw3EQq/AHxOzL861CXmHBxaXm30WjVO
         IGR/AbPAuW/YA==
Message-ID: <f50eea3e-fb4a-00b9-a357-62de7769286e@kernel.org>
Date:   Tue, 15 Aug 2023 10:52:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 5/9] scsi: core: Retry unaligned zoned writes
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-6-bvanassche@acm.org>
 <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
 <fd60a934-4b9f-97b2-6dd4-522d9194f9c7@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <fd60a934-4b9f-97b2-6dd4-522d9194f9c7@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/15/23 02:57, Bart Van Assche wrote:
> On 8/14/23 05:36, Damien Le Moal wrote:
>> On 8/12/23 06:35, Bart Van Assche wrote:
>>> +	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))
>>
>> This condition could be written as a little inline helper
>> blk_req_need_zone_write_lock(), which could be used in mq-dealine patch 2.
> 
> Hi Damien,
> 
> Since q->limits.use_zone_write_lock is being introduced, how about
> modifying blk_req_needs_zone_write_lock() such that it tests that new member
> variable instead of checking rq->q->disk->seq_zones_wlock? That would allow
> me to leave out one change from block/mq-deadline.c. I do not have a strong
> opinion about whether the name blk_req_needs_zone_write_lock() should be
> retained or whether that function should be renamed into
> blk_req_use_zone_write_lock().

Something like this ?

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 619ee41a51cc..a3980a71c0ac 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -57,7 +57,12 @@ EXPORT_SYMBOL_GPL(blk_zone_cond_str);
  */
 bool blk_req_needs_zone_write_lock(struct request *rq)
 {
-       if (!rq->q->disk->seq_zones_wlock)
+       struct request_queue *q = rq->q;
+
+       if (!q->limits.use_zone_write_lock)
+               return false;
+
+       if (!q->disk->seq_zones_wlock)
                return false;

        return blk_rq_is_seq_zoned_write(rq);

I think that is fine and avoids adding yet another helper.
I am OK with this.

-- 
Damien Le Moal
Western Digital Research

