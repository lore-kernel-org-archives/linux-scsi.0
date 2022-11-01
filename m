Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A33C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 16:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiKAQ2W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 12:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKAQ2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 12:28:12 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB1C1CFD1
        for <linux-scsi@vger.kernel.org>; Tue,  1 Nov 2022 09:28:08 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id i3so13899567pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 01 Nov 2022 09:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qiR3B2/GfOQGokpM6bJ4gV/YmZHPPXBcn9imh5EJz3Y=;
        b=dJKVfTcjABQzI6ghrGUL7YeCosJvh42S9Rs35nNGIf4RiWGwtM6yqw0Vrj+VhzVppr
         8+UknqN/iscM5L/z6rzPDr4o3On6tdGz48/I4wOhFCcZeHBH7rkQUdFwLb4UsISgcyRV
         19vlY6JjjncChsvdssb9wDn2/o7u9xnb9q4A5QcBTGNNHfFCSFOZ1hzj/qV9QRm2Wl+g
         KtwBtQFuK/4lRo6NwvutJPODOGfHza4GpwWks+d5yRAEBF9azcFoAksGedasnw8zy2XQ
         5Vcio7fJMMn6gKF9namWph99RXe8X5OI5fgRRkoMEgLBY0j0KN+syHCRLXwHXtp9bBc7
         X76A==
X-Gm-Message-State: ACrzQf14dSkl/9Q2uJ3YhVVE7H5mzVJyUEGtqlc+4WQ6SDUcrI8Vi3DY
        LnqC9d6Vg80G+6VJ6epX9weQkgFo14k=
X-Google-Smtp-Source: AMsMyM6Zy1JnRhubZiF17aTTdCWleX35tyu3ERDjMGTzjBkE6yTT4gEJsPAFK7OGCK1sCeFzdxsZiw==
X-Received: by 2002:a05:6a00:1506:b0:56d:e63a:f5e7 with SMTP id q6-20020a056a00150600b0056de63af5e7mr1574252pfu.27.1667320088260;
        Tue, 01 Nov 2022 09:28:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8574:e82f:b860:3ad0? ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0056d73ef41fdsm4212990pfq.75.2022.11.01.09.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 09:28:07 -0700 (PDT)
Message-ID: <54e0d667-8f14-5788-c1ce-5b9d6d8a0060@acm.org>
Date:   Tue, 1 Nov 2022 09:28:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] scsi: scsi_debug: Make the READ CAPACITY response
 compliant with ZBC
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
References: <20221031224755.2607812-1-bvanassche@acm.org>
 <af9b39f5-037f-5dea-8c14-0e020e275b9a@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <af9b39f5-037f-5dea-8c14-0e020e275b9a@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/22 20:23, Damien Le Moal wrote:
> On 11/1/22 07:47, Bart Van Assche wrote:
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -1899,6 +1899,10 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>>   			arr[14] |= 0x40;
>>   	}
>>   
>> +	/* Set RC BASIS = 1 for host-managed devices. */
> 
> No it is not necessarily set. It is up to the device vendor to choose if
> RC_BASIS is set or not, based on the device implementation.
> Applicability of RC = 0 or RC = 1 depends on the presence of conventional
> zones. so:
> 
> 1) If there are conventional zones, then using RC_BASIS = 1 or = 0 are
> both OK with HM devices. In the case of RC_BASIS = 0, the host can issue a
> report zones and get the device max lba from the report header (sd_zbc.c
> does that).
> 2) If there are no conventional zones, then using RC_BASIS = 0 does not
> make much sense, but nothing in the ZBC text prevent it either...
> 
> So we should refine this and maybe add an option to allow specifying rc
> basis ?
Hi Damien,

If I remember correctly the conclusion from a previous conversation is 
that setting RC BASIS = 1 for host-managed devices is what is done by 
all SMR vendors and is always correct for host-managed devices.

I think the description of the my patch is correct, namely that it makes 
the READ CAPACITY response compliant with ZBC. I did not claim that my 
patch is the only possible approach for making the READ CAPACITY 
response ZBC compliant.

Are there any use cases for reporting RC BASIS = 0 in combination with 
the capacity of conventional zones for host-managed devices other than 
testing the Linux kernel ZBC code?

Thanks,

Bart.
