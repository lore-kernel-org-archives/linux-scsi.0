Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E72C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 19:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhKVTIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 14:08:04 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:43990 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbhKVTID (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 14:08:03 -0500
Received: by mail-pl1-f174.google.com with SMTP id m24so14919810pls.10
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 11:04:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xa+I9yVR9gwf4/4bLSgBTGVsxzvnWooS/A/IHz2fybs=;
        b=BV9yZlh097xYL5fbTS9VxZLzCYYRFitnC1ePCjPoYi0UxPIaoJdzbHVBjWE1jVmnOK
         UOhzkgPHCzownioUzCugQf6Yj3uWMRavEKMRJxeSrwgQoz0r7jZ4KrUB0n3lTlSHnd7t
         UUILvxPH+xp8gATvkKpMGPJ97qokzjKtJySlD/VAvEHw2aRPS/9oeF8nufj5fsAdYPs1
         jD7amNxIS3I8/byBd+P5Q+BzFmF/ic58Zx8w8Z1qq88LlVOJfAFtC53RWvcDknRXTvrh
         UAjapgv6nopBI7tdgbs/i67oB2Tg/x1E39roAvKXSKPAqY4zjDdpYK8m70R0IT4QXo/D
         Bnog==
X-Gm-Message-State: AOAM533iqoMm+vYdMdkvIfXGL0miSXJ5EA0A8kOMZkprkHX0f7z4SaQ4
        aDtDOMvuYKpZFEgPSl7ZzTw=
X-Google-Smtp-Source: ABdhPJxD33gZ9iTTKo3CZGE51xKWGbz14EO2lulDPWdoWcnX1GwDaLN2EsGrJYdMuBTJveObadtGFg==
X-Received: by 2002:a17:902:a584:b0:143:c2e3:c4 with SMTP id az4-20020a170902a58400b00143c2e300c4mr86320511plb.69.1637607895795;
        Mon, 22 Nov 2021 11:04:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3432:c377:2744:1125])
        by smtp.gmail.com with ESMTPSA id i185sm9581455pfg.80.2021.11.22.11.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 11:04:54 -0800 (PST)
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
From:   Bart Van Assche <bvanassche@acm.org>
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-6-bvanassche@acm.org>
 <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
 <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
Message-ID: <19abf385-da1a-4e6f-2101-1b721a3fdfb0@acm.org>
Date:   Mon, 22 Nov 2021 11:04:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 9:46 AM, Bart Van Assche wrote:
> On 11/22/21 12:58 AM, John Garry wrote:
>> On 19/11/2021 19:57, Bart Van Assche wrote:
>>> +{
>>> +    unsigned int opf = REQ_INTERNAL;
>>> +    struct request *rq;
>>> +
>>> +    opf |= data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT : 
>>> REQ_OP_DRV_IN;
>>> +    rq = blk_mq_alloc_request(q, opf, flags);
>>> +    if (IS_ERR(rq))
>>> +        return ERR_CAST(rq);
>>
>> I think that Christoph suggested elsewhere that we should poison all 
>> the scsi_cmnd
> 
> I had overlooked that comment. I will look into this.

If anyone comes up with a good approach for poisoning the scsi_cmnd I 
will look into this. Only overwriting struct scsi_cmnd is not acceptable 
since that would result in a memory leak. See also the memory allocation
statements in scsi_mq_init_request().

Thanks,

Bart.
