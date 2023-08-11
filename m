Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98122C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 00:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjHKApe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 20:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjHKApd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 20:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4F212D;
        Thu, 10 Aug 2023 17:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38E156581F;
        Fri, 11 Aug 2023 00:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3F8C433C8;
        Fri, 11 Aug 2023 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691714731;
        bh=TL2lGinnVfblYhXzBN1hM2/vDMpAf0+EW8bTRI0zmNo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oBIO4Um7iID0oSvut+Trfud+6Ej05D9FGCvSoMvkolWQk7t0YjDphWF0qQ3FGKUrO
         i8meZgFCu5QTqJve4o5HTbJ7Zlz6UI7gk8MYPQJsW5KV3vvvd/xvGZZKZtnhLuTpKT
         KbchN7gceHeEO1XXhTaHjThfJnERP6basokH9FN8PcbiL8XHVWGIs6Ub17tsE10LLx
         MSMGVuCoKcEV2wowM0LbmM1+IojR7AqlABAxqkbTU5k1lh/y0hG6Y337ITIgJj9K/j
         NWCuvN4sDuPf8lkZ9uC+FV6Sfl1GafkZos+q10cRDiYmr6IY+Uzf2ScOmKciL0wsBD
         69rtk9W7HZxZg==
Message-ID: <8aa716eb-e440-8a28-0c89-07729fcf1715@kernel.org>
Date:   Fri, 11 Aug 2023 09:45:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 2/7] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-3-bvanassche@acm.org>
 <06527195-8f6d-0395-a7d5-d19634a00ad2@kernel.org>
 <d83cb0aa-ae35-bb58-5cd0-72b8c03d934f@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <d83cb0aa-ae35-bb58-5cd0-72b8c03d934f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 23:00, Bart Van Assche wrote:
> On 8/9/23 18:36, Damien Le Moal wrote:
>> On 8/10/23 05:23, Bart Van Assche wrote:
>>> +static bool dd_use_zone_write_locking(struct request_queue *q)
>>> +{
>>> +	return q->limits.use_zone_write_lock && blk_queue_is_zoned(q);
>>
>> use_zone_write_lock should be true ONLY if the queue is zoned.
>> So the "&& blk_queue_is_zoned(q)" seems unnecessary to me.
>> This little helper could be moved to be generic in blkdev.h too.
> 
> Hi Damien,
> 
> use_zone_write_lock should be set by the block driver (e.g. a SCSI
> LLD) before I/O starts. The zone model information is retrieved by
> submitting I/O. It is not clear to me how to set use_zone_write_lock
> to true only for zoned block devices before I/O starts since I/O is
> required to retrieve information about the zone model.

See my other email. Once you know that the drive is zoned, then
use_zone_write_lock can default to true. That is trivial to do in
disk_set_zoned(), which is called by all drivers. I proposed adding an argument
to this function to override the default, thus allowing a device driver to set
it to false.

The limit default set to true as you have it in your current patch does not make
sense to me. It should be false by default and turned on only for zoned drive
that require zone write locking (e.g. SMR HDDs). With that, mq-deadline can even
be simplified to not even look at the q zoned model and simply us
q->limits.use_zone_write_lock to determine if locking a zone is needed or not.
That would be a lot cleaner.

Not that device scan and revalidation never write to the device. So that can be
done safely regardless of the current value for the use_zone_write_lock limit.


-- 
Damien Le Moal
Western Digital Research

