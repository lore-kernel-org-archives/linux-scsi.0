Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BFAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 17:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiGLROV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 13:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGLROU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 13:14:20 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07442ED5D
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 10:14:18 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id fz10so8366494pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 10:14:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jV3gi6AnRpFAV3v6xO8zm/6TrGDbVJBVCi2P9TIkBAE=;
        b=BNdsYr2a1+U1RFLK71bWraH/IoiCNnjX5ESdafvl2VP17RQ6yTjceQdVPBk6DeSCh8
         35a9fxatjJVxrgLPCEKQWcmCbDehiA3o5IaeSSBiCcRxTFiXRxqWn9fXaze75akQMl8r
         eTh0iaMhcMX8f+c/VECynBbzLGusOkS2xRivHDvoARamkUd2ig6iJ4pNChsslc90omjk
         T/Pe8Q8d/d6x9uCv4A/CN50ex1lFY6ygBp3owclynZHH3H7YYDofGjnS0GTe4QCnZt/n
         oZg4WVPLALJSJ+Meem5cESczpBhVhoUhoLPADUyr8GEbkcTButptInOd5iAsKC+6kO0Z
         PS/A==
X-Gm-Message-State: AJIora/jAz0/XqeftlhbShQjMdmUGeUs78Wv50KQ7GI8aNDpdt1d6WbB
        KhH5WmO8bGm9dgsD8uAiFBs=
X-Google-Smtp-Source: AGRyM1tm+WZlYvSvFKKSmn4sa9MB3eKuDw6wie3Fn9QiPhP5/cKOqZDTj/PkWFTNKLH0iiKoYA9XcQ==
X-Received: by 2002:a17:90b:4c4e:b0:1f0:48e7:7258 with SMTP id np14-20020a17090b4c4e00b001f048e77258mr5546907pjb.223.1657646058159;
        Tue, 12 Jul 2022 10:14:18 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:de3c:137c:f4d2:d291? ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902a38300b0016a034ae481sm7065636pla.176.2022.07.12.10.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 10:14:17 -0700 (PDT)
Message-ID: <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
Date:   Tue, 12 Jul 2022 10:14:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/22 16:28, Damien Le Moal wrote:
> On 7/12/22 08:11, Damien Le Moal wrote:
>> On 7/12/22 08:00, Bart Van Assche wrote:
>>> Using the RETURNED LOGICAL BLOCK ADDRESS field + 1 as the capacity (largest
>>> addressable LBA) if RC BASIS = 0 is wrong if there are sequential write
>>> required zones. Hence only use the RC BASIS = 0 capacity if there are no
>>> sequential write required zones.
>>
>> This does not make sense to me: RC BASIS == 0 is defined like this:
>>
>> The RETURNED LOGICAL BLOCK ADDRESS field indicates the highest LBA of a
>> contiguous range of zones that are not sequential write required zones
>> starting with the first zone.
>>
>> Do you have these cases:
>> 1) host-managed disks:
>> SWR zones are *mandatory* so there is at least one. Thus read capacity
>> will return either 0 if there are no conventional zones (they are
>> optional) or the total capacity of the set of contiguous conventional
>> zones starting at lba 0. In either case, read capacity does not give you
>> the actual total capacity and you have to look at the report zones reply
>> max lba field.
>> 2) host-aware disks:
>> There are no SWR zones, there cannot be any. You can only have
>> conventional zones (optionally) and sequential write preferred zones. So
>> "the highest LBA of a contiguous range of zones that are not sequential
>> write required zones starting with the first zone" necessarily is always
>> the total capacity. RC BASIS = 0 is non-sensical for host-aware drives.
> 
> What I meant to say here for the host-aware case is that RC BASIS is
> irrelevant. Both RC BASIS = 0 and = 1 end up with read capacity giving the
> actual total capacity. ANd for good reasons: the host-aware model is
> designed to be backward compatible with regular disks, which do not have
> RC BASIS, so RC BASIS = 0, always.
Hi Damien,

I agree that for host-aware block devices (conventional + sequential write
preferred zones) RC BASIS is irrelevant.

What I'm concerned about is host-managed block devices (conventional + sequential
write required zones) that report an incorrect RC BASIS value (0 instead of 1).
Shouldn't sd_zbc_check_capacity() skip the capacity reported by host-managed block
devices that report RC BASIS = 0?

Thanks,

Bart.
