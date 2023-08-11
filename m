Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B27BC41513
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 15:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbjHKPmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 11:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbjHKPlx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 11:41:53 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4602C30FB;
        Fri, 11 Aug 2023 08:41:51 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-26814f65d7fso1253370a91.0;
        Fri, 11 Aug 2023 08:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691768511; x=1692373311;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l9atXAzbLV1I+ffpGQ3bX0TNeuw810WriPRA+9aWewQ=;
        b=iML754nKYVF8o80I3zNDDHhmAeOyRKh8+9LYSOysnRvFAR45pXr8HKxpWhI8tXfFLw
         Hfcphusd4jvnrfpFEyyZYb/093Q+jh9J9ott4xrcpIzRPSX/9DXt3EiZbyneViBusj5w
         /sNok9EihlM1+5cQzN7akm7GpDMqiNuRhAHAdPb8MbfJMONUQVy7wsaBUHZ+K4ZeiA5U
         dfkkdAODrRwKgUVKxxe+PFDwiX2D8tdJAY20vUtJBmAUe0ERiFU1TTvPs1cd/1etPfay
         iNsSgRSMZy0IpxyoGp9sxBuz24D+6A7dBAbIEk39piH/TCR9jdrQwY91XcyzWKTxvIZ6
         Vjkw==
X-Gm-Message-State: AOJu0YwuEWYPv+Kl5sc3gNQgpHeCllVlYicC2VIlToX9c2+sdQNIoFoM
        6dzIjuALFIRaarLP6ZbAGFY=
X-Google-Smtp-Source: AGHT+IEbe4bshX88w1JnTmMBOQ6dmSOVsjsvmsOUE14RXpquC5dy2a3W01gt+uCfhMpQVJLWH4w/cw==
X-Received: by 2002:a17:90a:ce82:b0:269:5821:5808 with SMTP id g2-20020a17090ace8200b0026958215808mr1558904pju.32.1691768510602;
        Fri, 11 Aug 2023 08:41:50 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a40a:5c20:3595:c0ec? ([2620:15c:211:201:a40a:5c20:3595:c0ec])
        by smtp.gmail.com with ESMTPSA id f23-20020a170902ab9700b001a95f632340sm4085360plr.46.2023.08.11.08.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Aug 2023 08:41:50 -0700 (PDT)
Message-ID: <aa9cc0f6-b493-27ea-207c-0333e68911c3@acm.org>
Date:   Fri, 11 Aug 2023 08:41:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 1/7] block: Introduce the use_zone_write_lock member
 variable
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-2-bvanassche@acm.org>
 <8312a7c4-b3ef-873d-c4fa-825b7fce8be1@kernel.org>
 <3ebefe64-bb74-732e-68d1-faf9e3c5877b@acm.org>
 <554dd42f-ab73-9120-1a9c-0a12b5d7981b@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <554dd42f-ab73-9120-1a9c-0a12b5d7981b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 17:39, Damien Le Moal wrote:
> On 8/10/23 23:02, Bart Van Assche wrote:
>> My concerns about the above proposal are as follows:
>> * The information about whether or not the zone write lock should be used comes
>>     from the block driver, e.g. a SCSI LLD.
> 
> Yes.
> 
>> * sdp, the SCSI disk pointer, is owned by the ULD.
>> * An ULD may be attached and detached multiple times during the lifetime of a
>>     logical unit without the LLD being informed about this. So how to set
>>     sdp->use_zone_write_lock without introducing a new callback or member variable
>>     in a data structure owned by the LLD?
> 
> That would be set during device scan and device revalidate. And if the value
> changes, then disk_set_zoned() should be called again to update the queue limit.
> That is already what is done for the zoned limit indicating the type of the
> drive. My point is that the zoned limit should dictate if use_zone_write_lock
> can be true. The default should be be:
> 
> 	q->limits.use_zone_write_lock = q->limits.zoned != BLK_ZONED_NONE.
> 
> And as proposed, if the UFS driver wants to disable zone write locking, all it
> needs to do is call "disk_set_zoned(disk, BLK_ZONED_HM, false)". I did not try
> to actually code that, and the scsi disk driver may be in the way and that may
> need to be done there, hence the suggestion of having a use_zone_write_lock flag
> in the scsi device structure so that the UFS driver can set it as needed as well
> (and detect changes when revalidating). That should work, but I may be missing
> something.

Hi Damien,

Adding a use_zone_write_lock argument to disk_set_zoned() seems wrong to 
me. The information about whether or not to use the zone write lock 
comes from the LLD. The zone model is retrieved by the ULD. Since both 
pieces of information come from different drivers, both properties 
should be modified independently.

Moving the use_zone_write_lock member variable into a data structure 
owned by the ULD seems wrong to me because that member variable is set 
by the LLD.

Reviewers are allowed to request changes for well-designed and working 
code but should be able to explain why they request these changes. Can 
you please explain why you care about the value of 
q->limits.use_zone_write_lock for the BLK_ZONED_NONE case? If 
dd_use_zone_write_locking() would be renamed and would be moved into 
include/linux/blkdev.h and if reads of q->limits.use_zone_write_lock 
would be changed into blk_use_zone_write_locking() calls then the value 
of q->limits.use_zone_write_lock for the BLK_ZONED_NONE case wouldn't 
matter at all.

Thanks,

Bart.
