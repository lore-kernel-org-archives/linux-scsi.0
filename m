Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05210EB64DD
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Aug 2023 02:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbjHLCoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 22:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjHLCoT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 22:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F97ABE;
        Fri, 11 Aug 2023 19:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C749761315;
        Sat, 12 Aug 2023 02:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E70DC433C7;
        Sat, 12 Aug 2023 02:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691808257;
        bh=M4sfcuiQRX1/IpSQgWaghEc+6VdRCThKXGQzhJDzX6A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hPDNgce9NCDxDJL4Tj6DEJ/opoFDyfCHercgNMSyR2yS+JM5Or+bWwDot5jHuU2dI
         158js+CoG43qNvNK491LPtrcEgJWntuxY2G8VJCbU0n25C50dXBRx0W3uDEup8vB2j
         0XFVcO3APfbribUyrboCTox87FB8BDDqbcz3zXQYSAAsfKcAuYifIvqg/yr7EQuMeY
         vNugEiwrKEEhiTAKJnCxZOp1vZq1nBMtp9t+Ue/d8CYjpdt+YjzzOg27X+cQ26EeJB
         ynUm/FkZbn3PbUCzmPmEFjCGqb0pySpApnaysvCe7xDxOoU60Q4lVpGrY+0pDI309B
         RwsHWWNaz4RPA==
Message-ID: <ed065146-2378-a60c-8482-9a4d3486db46@kernel.org>
Date:   Sat, 12 Aug 2023 11:44:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 1/7] block: Introduce the use_zone_write_lock member
 variable
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-2-bvanassche@acm.org>
 <8312a7c4-b3ef-873d-c4fa-825b7fce8be1@kernel.org>
 <3ebefe64-bb74-732e-68d1-faf9e3c5877b@acm.org>
 <554dd42f-ab73-9120-1a9c-0a12b5d7981b@kernel.org>
 <aa9cc0f6-b493-27ea-207c-0333e68911c3@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aa9cc0f6-b493-27ea-207c-0333e68911c3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 00:41, Bart Van Assche wrote:
> On 8/10/23 17:39, Damien Le Moal wrote:
>> On 8/10/23 23:02, Bart Van Assche wrote:
>>> My concerns about the above proposal are as follows:
>>> * The information about whether or not the zone write lock should be used comes
>>>     from the block driver, e.g. a SCSI LLD.
>>
>> Yes.
>>
>>> * sdp, the SCSI disk pointer, is owned by the ULD.
>>> * An ULD may be attached and detached multiple times during the lifetime of a
>>>     logical unit without the LLD being informed about this. So how to set
>>>     sdp->use_zone_write_lock without introducing a new callback or member variable
>>>     in a data structure owned by the LLD?
>>
>> That would be set during device scan and device revalidate. And if the value
>> changes, then disk_set_zoned() should be called again to update the queue limit.
>> That is already what is done for the zoned limit indicating the type of the
>> drive. My point is that the zoned limit should dictate if use_zone_write_lock
>> can be true. The default should be be:
>>
>> 	q->limits.use_zone_write_lock = q->limits.zoned != BLK_ZONED_NONE.
>>
>> And as proposed, if the UFS driver wants to disable zone write locking, all it
>> needs to do is call "disk_set_zoned(disk, BLK_ZONED_HM, false)". I did not try
>> to actually code that, and the scsi disk driver may be in the way and that may
>> need to be done there, hence the suggestion of having a use_zone_write_lock flag
>> in the scsi device structure so that the UFS driver can set it as needed as well
>> (and detect changes when revalidating). That should work, but I may be missing
>> something.
> 
> Hi Damien,
> 
> Adding a use_zone_write_lock argument to disk_set_zoned() seems wrong to 
> me. The information about whether or not to use the zone write lock 
> comes from the LLD. The zone model is retrieved by the ULD. Since both 
> pieces of information come from different drivers, both properties 
> should be modified independently.

OK. But I still think that disk_set_zoned() is the place where the default for
use_zone_write_lock should be set.

And we need a clean way for the LLD to change use_zone_write_lock.

> 
> Moving the use_zone_write_lock member variable into a data structure 
> owned by the ULD seems wrong to me because that member variable is set 
> by the LLD.
> 
> Reviewers are allowed to request changes for well-designed and working 
> code but should be able to explain why they request these changes. Can 
> you please explain why you care about the value of 
> q->limits.use_zone_write_lock for the BLK_ZONED_NONE case? If 

Because use_zone_write_lock should ever be true for !BLK_ZONED_NONE case.
Allowing use_zone_write_lock to be true even with zoned == BLK_ZONED_NONE forces
to always check that the device is zoned to ensure that the value of
use_zone_write_lock is valid. This is awckward and uselessly complicate things.

> dd_use_zone_write_locking() would be renamed and would be moved into 
> include/linux/blkdev.h and if reads of q->limits.use_zone_write_lock 
> would be changed into blk_use_zone_write_locking() calls then the value 
> of q->limits.use_zone_write_lock for the BLK_ZONED_NONE case wouldn't 
> matter at all.

Sure, that would work. But again, why the need to check both model and actual
value of use_zone_write_lock ? I do not think it is that hard to keep
use_zone_write_lock to false for the BLK_ZONED_NONE case. Then
blk_use_zone_write_locking() is reduced to returning the value of
use_zone_write_lock.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

