Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AF5C0015E
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 13:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjHINpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 09:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjHINpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 09:45:43 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F9A1986;
        Wed,  9 Aug 2023 06:45:42 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-268b3ddc894so3874489a91.1;
        Wed, 09 Aug 2023 06:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691588742; x=1692193542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Dpl1Z+1e37FDIIxjHDTTIhIJ9sjPbxUhzPUxRhhyuI=;
        b=GBSzmq2sMNoyH0TWD/UqJGNJznJlSKeIaxd2VSJoDxdu79uUYGO2wbS6sZHkmcBy4x
         2E/0C0tOd4III1NQVNiHal6ynkVUAvxeCgnrlKRMGjTbL5HQxEMXHhheS+T2TcSmPe+r
         demdnajur08muKTUH3XOhFk6wHyWC7sWnh2sz+O2ZVCw11MDTwGQiGTddpYI82z/up9O
         NivALHkZ8fa2MExPMTYdEo3K0zXP+iUOLDmQ3sqoDorpLfOKgJJ32G5A8/ktCu0iUKCm
         KTgSyEECf+VLTReXeemz7MOOOaCdSU85sKKOBSlsCZ4JYvSYXY/fcFrwzHAnQlDtR+jU
         B11w==
X-Gm-Message-State: AOJu0YzMAPUGrxNUWW8xrSNlWHUE/IIxHlnsMtiAL1Ab62jCt61V+/9b
        piC/ZdA+uyNl51Ejk92yqiA=
X-Google-Smtp-Source: AGHT+IHBcvmWzou/w5ZYj6qiwXAbaSxwPp6ps8nZpIrsu22GqEvYIcdlm08UvbgT1jdVFtAi8nMHAA==
X-Received: by 2002:a17:90a:5314:b0:268:ce03:e17e with SMTP id x20-20020a17090a531400b00268ce03e17emr2035284pjh.47.1691588741442;
        Wed, 09 Aug 2023 06:45:41 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id nh10-20020a17090b364a00b002690aa4c292sm1462143pjb.39.2023.08.09.06.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 06:45:40 -0700 (PDT)
Message-ID: <49370c83-cbda-2c95-8f74-408dca738c75@acm.org>
Date:   Wed, 9 Aug 2023 06:45:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v6 1/7] block: Introduce the flag
 QUEUE_FLAG_NO_ZONE_WRITE_LOCK
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
References: <20230804154821.3232094-1-bvanassche@acm.org>
 <20230804154821.3232094-2-bvanassche@acm.org>
 <dd230762-804c-bb8a-24e0-123afd81e26c@kernel.dk>
 <ede0c18a-f5d0-94af-5175-9be54aa85082@acm.org>
 <067228e1-cd13-cf70-40fd-409f9b9ba557@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <067228e1-cd13-cf70-40fd-409f9b9ba557@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/23 15:27, Jens Axboe wrote:
> I don't think setting that flag by default makes a lot of sense, if the
> device in question isn't zoned. Maybe have variants of BLK_ZONED_* which
> has a locked and unlocked variant for each where it applies? Perhaps
> have the lock flag be common between them so you can check them in the
> same way? That'd keep the fact that it's zoned and if it needs locking
> in the same spot, rather than scatter them in two spots.

Hi Jens,

That's an interesting suggestion but there is a complication: the zone type
is set by different code than the code that decides whether or not locking
is required. For SCSI devices the zone type is set from inside
drivers/scsi/sd.c or drivers/scsi/sd_zbc.c while the locking requirements
come from the SCSI LLD (drivers/ufs/core/ufshcd.c). Additionally, the code
for converting between model type and model string in scsi_debug.c would
look weird if BLK_ZONED_* is split into locked and unlocked variants. See
also the zbc_model_strs_*[] arrays and the sdeb_zbc_model_str() function.

It should be possible to move the flag that indicates whether or not zone
locking is required into struct queue_limits next to "enum blk_zoned_model
zoned;". If nobody objects I will select this alternative.

Thanks,

Bart.


