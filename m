Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9F1C678DB
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 15:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCDPVg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Mar 2023 10:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDPVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2023 10:21:35 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917891C7C7
        for <linux-scsi@vger.kernel.org>; Sat,  4 Mar 2023 07:21:34 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id kb15so5581039pjb.1
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2023 07:21:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677943294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wlis/7bPjTjQKMrFwzBhS02AmIjbsLWpFaZsrqUv2Jo=;
        b=GuHZ1ZYv5bz6GUlu8vTVWVeGkRyFNY53dNAZC/2XIGDvBfsKBAeElCksGQJ+8R/svB
         0zOXsspTjDVe3O2SJK5bZzPoAxyVOuhYHMbSkEJ7WpINXTLMGBZ1zP0I109nYDC4pNkI
         3XesU/m8TDSTgul8vVK7swwlTaRsXvJqVWDLSIZdsMNgA7RNXbZrfYCyiZb6dZGxmNZM
         l8iSWSxuPLWk8MRxvpXcykr7NmEjjw2ONmAAaYOdAknZVfkNLdQrCGW6ImP8OUDbbsUv
         5KVWWYroxUSKR18XVfV+K1vv9x/XLDIqPUN+HtANE6Uf0MmP6rtGbEOFY6pH2ST7ATG0
         4tBw==
X-Gm-Message-State: AO0yUKV8ibUO/lhgKd7DiDXXO5ywh+85641hxPB2zL/B5ZQ1ixo6dKg8
        DejVWlOYW9j7l8VOIF6+sHCyxnsqHueDSA==
X-Google-Smtp-Source: AK7set84NyPmODEB0rsCx8+mmm3B0yqjfvaDCXLUMPX8vmAF574aW/ZmO06hcXLApRDMTEoYObjRyQ==
X-Received: by 2002:a17:90b:3912:b0:237:d2b0:dac9 with SMTP id ob18-20020a17090b391200b00237d2b0dac9mr5526626pjb.42.1677943293944;
        Sat, 04 Mar 2023 07:21:33 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090acb0a00b00230b8402760sm5134939pjt.38.2023.03.04.07.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 07:21:33 -0800 (PST)
Message-ID: <5b81a4b6-82b9-55a2-a75c-486886c96e9e@acm.org>
Date:   Sat, 4 Mar 2023 07:21:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
 <8be7cebf-a5dc-4742-1ef2-207d1797f2f3@acm.org>
 <23ac3205-d92a-b32f-d0e3-29604cf859cd@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <23ac3205-d92a-b32f-d0e3-29604cf859cd@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 19:03, Damien Le Moal wrote:
> On 3/4/23 03:03, Bart Van Assche wrote:
>> On 3/2/23 17:44, Shin'ichiro Kawasaki wrote:
>>> +	if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
>>> +	    (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_ZONE_APPEND) &&
>>> +	    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
>>> +	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
>>> +		scmd_printk(KERN_ERR, cmd,
>>> +			    "Sequential write request not aligned to the physical block size\n");
>>> +		goto fail;
>>> +	}
>>
>> I vote -1 for this patch because my opinion is that we should not
>> duplicate checks that must be performed by the storage controller anyway
>> inside the sd driver.
> 
> Sure, the drive will fail this request, so the end result is the same. But what
> is the point of issuing such unaligned request that we know will fail ? The
> error message also make it easier to debug as it clarifies that this is not a
> write pointer violation. So while this change is not critical, it does have
> merits in my opinion.

I think that there are other ways to debug software that triggers an 
unaligned write, e.g. ftrace.

Thanks,

Bart.

