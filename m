Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816E8C0015E
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Aug 2023 02:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbjHLCtp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 22:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbjHLCtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 22:49:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B32130E7;
        Fri, 11 Aug 2023 19:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5006642A0;
        Sat, 12 Aug 2023 02:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB92C433C8;
        Sat, 12 Aug 2023 02:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691808584;
        bh=oiiYrMY4fXAFliNihHNUww9+1ATkMLlVtS4xA0Jfd8s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=caZLxlDxzMyDFKTHLCnfX4jx0e2O+5uE/9UeWKdC0Un7x+5ZdqyyRcwtmO+s40LlS
         UkxQdr9z5k72FqQIt+R1XdRPUcs0pJ2QaFDOKLNGOdVrVp0aokOqoMqiEb97uoYjtJ
         nKMegpa64fteEYgsoLclUu7Xj7Pd+KRDx9HrILj74XpjDTLRXRFkfifciyk5Ls5fz7
         U10h5Ajtx7aW6T58jER+jSKrCJ7f7eW9ATaectgXs3VEEaxoAfNGl4g3bCvOC971zu
         0FrduCZuw4l9q2oGK5eYQ62zT7sJXvBF2PW/VVUVjDGXAXR3Ei+s1VM3wZbn8Gehjk
         lshKafQ71jAwQ==
Message-ID: <dc83cb3b-b495-aa8c-fc96-c3f7ac56c262@kernel.org>
Date:   Sat, 12 Aug 2023 11:49:42 +0900
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
 <8aa716eb-e440-8a28-0c89-07729fcf1715@kernel.org>
 <92e109dc-c5ee-ce0c-002c-3323f3918503@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <92e109dc-c5ee-ce0c-002c-3323f3918503@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 00:49, Bart Van Assche wrote:
> On 8/10/23 17:45, Damien Le Moal wrote:
>> With that, mq-deadline can even be simplified to not even look at the
>> q zoned model and simply us q->limits.use_zone_write_lock to
>> determine if locking a zone is needed or not.
> 
> Hi Damien,
> 
> I think implementing the above proposal requires splitting 
> 'use_zone_write_lock' into two variables:
> (a) One member variable that indicates whether the zone write lock
>      should be used.
> (b) Another member variable that indicates whether or not the LLD
>      preserves the order of SCSI commands.
> 
> Member variable (b) should be set by the LLD and member variable (a) can 
> be set by disk_set_zoned().
> 
> Do you want me to implement this approach?
> 

Looking at your v8, this seems better.
I will have a more in-depth look Monday.

-- 
Damien Le Moal
Western Digital Research

