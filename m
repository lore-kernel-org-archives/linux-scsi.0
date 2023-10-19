Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40770C004C0
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 22:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbjJSWwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 18:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjJSWwk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 18:52:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF9B115;
        Thu, 19 Oct 2023 15:52:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00207C433C8;
        Thu, 19 Oct 2023 22:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697755422;
        bh=Inyd7JFVmnzV0aGnFK8J9Awp2e4R7syjG6p1dgX25Us=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iw3kdNAq+74wfflkL3JnueXg+Mkrb6C0071G+nF0gyRoaDNv3Sgwr0To0zfcbGBwt
         FtVFREkEKpThy3TsYvrdG/cKyAyxfGchtoFoDEhBm5JqsDD0j7s1PspudOaQDBuz5b
         VKsIk+FKdYb7/KWw38zg3lHluWa+AIoDhKP0Uja4vTcU9FiJy3b4RtQmte+PlPizSP
         cS6Sv4L5yrDCjge290n1ehZ3UYOiGLeLrGFjJAi5xQazqOAIwLKet+/LdfBBYBnMPY
         ZoziU01BRAEDWN/ghA8waNao2C8U1UaNCPifoTCKxsY3kpsylIrfWKXa2B9INOXEC3
         U9Wuu16S5CYSQ==
Message-ID: <0b5ad529-f9c0-4f13-8852-69ad72d27e57@kernel.org>
Date:   Fri, 20 Oct 2023 07:43:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/18] scsi: sd_zbc: Only require an I/O scheduler if
 needed
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-11-bvanassche@acm.org>
 <88133920-cb0c-43ea-a735-dee63267ffc8@kernel.org>
 <0e7a436d-2100-47ea-9fde-899b9ad67253@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0e7a436d-2100-47ea-9fde-899b9ad67253@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/23 01:54, Bart Van Assche wrote:
> On 10/18/23 17:26, Damien Le Moal wrote:
>> On 10/19/23 02:54, Bart Van Assche wrote:
>>>   	/* The drive satisfies the kernel restrictions: set it up */
>>>   	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
>>> -	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
>>> +	if (!q->limits.driver_preserves_write_order)
>>
>> Where is this limit introduced ? I do not see it anywhere in your patches. Did I
>> miss something ?
> 
> Hi Damien,
> 
> Please take another look at patch 01/18 of this series. I think that you
> have seen that patch before since a Reviewed-by tag was posted by you on
> August 17. See also 
> https://lore.kernel.org/linux-block/6d823671-db2b-2280-0c93-87d03a2f471e@kernel.org/.

Oops, yes, it was there :)
My apologies for the noise.

-- 
Damien Le Moal
Western Digital Research

