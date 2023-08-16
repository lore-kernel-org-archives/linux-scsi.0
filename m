Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985ECC04A6A
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 01:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240987AbjHPBNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 21:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbjHPBNP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 21:13:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48931FCE;
        Tue, 15 Aug 2023 18:13:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FE20644DD;
        Wed, 16 Aug 2023 01:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CC4C433C7;
        Wed, 16 Aug 2023 01:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692148383;
        bh=QjRJQDTbptRiTmupwSjSqxA9iaxB6Z7Rjtp+mkWFNJY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bwo2WNc9oMK10BMu4/1EFNUQIxxTQqY6uBnlWYOx2krA40wQtOYlgObeJDkrymNVG
         DLxzoFBlpiaisOMLn6MT5fcWjRP4c4LpWwAKOaZRQkW8kVUCcjT8x2DSnXvcnAcVL/
         fqrxK4AlmRzsXWS8q0K0LY8+5LF/+ZGiZ7tR3drfazPDvTNBYLbZMYGXUnvGgrm6Qz
         KWjVWpwdBDB7NypeI+Nc8fbsR6nHd/w71EedzouX/b/LyTHktbjv6UVqmMaZRZPKU4
         RvSrviZNR682fEe+uFdJ2nuUsVJa6uBitRvP+PVBRg3+lBap2wYan9pqLuySZQt4vL
         h1BZop7A3gO1w==
Message-ID: <2b73497c-0c0c-6eeb-91ca-000884a9898c@kernel.org>
Date:   Wed, 16 Aug 2023 10:13:01 +0900
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
 <3161926c-b1cb-9617-bf71-73b8711e86de@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <3161926c-b1cb-9617-bf71-73b8711e86de@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/23 02:29, Bart Van Assche wrote:
> On 8/14/23 05:36, Damien Le Moal wrote:
>> On 8/12/23 06:35, Bart Van Assche wrote:
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -1238,6 +1238,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>>>   	cmd->transfersize = sdp->sector_size;
>>>   	cmd->underflow = nr_blocks << 9;
>>>   	cmd->allowed = sdkp->max_retries;
>>> +	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))
>>
>> This condition could be written as a little inline helper
>> blk_req_need_zone_write_lock(), which could be used in mq-dealine patch 2.
> 
> The above test differs from the tests in the mq-deadline I/O scheduler.
> The mq-deadline I/O scheduler uses write locking if
> rq->q->limits.use_zone_write_lock && q->disk->seq_zones_wlock &&
> blk_rq_is_seq_zoned_write(rq). The above test is different and occurs
> two times in scsi_error.c and one time in sd.c. Do you still want me to
> introduce a helper function for that expression?

May be not needed. But a comment explaining it may be good to add.
I still think that added the test for use_zone_write_lock in
blk_req_needs_zone_write_lock() is needed though, for consistency of all
functions related to zone locking.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

