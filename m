Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14900C6FA99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 18:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjCJS3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 13:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCJS3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 13:29:04 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E745A54F5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 10:29:03 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id v11so6536146plz.8
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 10:29:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678472943;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qZwXCNXk0s0Dfng3evTKExsmCC2l7q3cObrSOiUUoQ=;
        b=D5+rSjP40Hi3ZbfxG4Ndxk6aZsFNnW24pJ+n20S5OJImQKDD1B5znPLVMyyPU7PPZP
         B00AoGEVw9UAHAV55mDUOXi9bPcCPOA/GW0hkQOZG8KKB9MnBK1QlqeA+aWkH4wY9SAC
         MkGvMxJ/VjL5Y3JEvWhqVUM79VKBwpocf3yxA67qX1iWZXc43QmI5xxWNJjh47Z5aHz8
         A/eAt889NsBGqYLEVJzvJwUnqp2uQ+Uw2PG5+xVw3vEFXZJWPP15dwW7QGdFAAEEc3YZ
         bjLu0k+4EkvWcGKhQ90u+lC5fI05n/c8n1UOEduA2iw05G31KgJwk2LGg40+hCH5M3Ls
         2UCA==
X-Gm-Message-State: AO0yUKWcLfwzk+6LxOPeAtALShZ07A6V3PhT2tu1Sd3V+JuarADLy7nq
        KY3/U+oDw8McK19f+LGt/Ys/q3G7DnbZig==
X-Google-Smtp-Source: AK7set/HV6QBAUBRn70Uohm2LFVHs7VXTEjPWsvir2c+J5x2LQg7cc7++YrEOLVyMSIIPLZijI5ooA==
X-Received: by 2002:a05:6a20:9390:b0:c6:ff46:c713 with SMTP id x16-20020a056a20939000b000c6ff46c713mr32678503pzh.57.1678472942956;
        Fri, 10 Mar 2023 10:29:02 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id x14-20020a63484e000000b00502ea97cbc0sm203709pgk.40.2023.03.10.10.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 10:29:02 -0800 (PST)
Message-ID: <31bd3f35-72de-cf65-b6bd-a5962182658d@acm.org>
Date:   Fri, 10 Mar 2023 10:28:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 51/82] scsi: mac_scsi: Declare SCSI host template const
Content-Language: en-US
To:     Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-52-bvanassche@acm.org>
 <ad89ffce-8cb0-a7b1-887c-2c513e7ea5b2@linux-m68k.org>
 <e03dcd85-15cd-5cd7-7845-89086748d613@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e03dcd85-15cd-5cd7-7845-89086748d613@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/9/23 22:09, Michael Schmitz wrote:
> Hi Bart,
> 
> Am 10.03.2023 um 17:46 schrieb Finn Thain:
>> On Thu, 9 Mar 2023, Bart Van Assche wrote:
>>
>>> Make it explicit that the SCSI host template is not modified.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>  drivers/scsi/mac_scsi.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
>>> index 2e511697fce3..1d13f1ebc094 100644
>>> --- a/drivers/scsi/mac_scsi.c
>>> +++ b/drivers/scsi/mac_scsi.c
>>> @@ -422,7 +422,7 @@ static int macscsi_dma_residual(struct 
>>> NCR5380_hostdata *hostdata)
>>>  #define DRV_MODULE_NAME         "mac_scsi"
>>>  #define PFX                     DRV_MODULE_NAME ": "
>>>
>>> -static struct scsi_host_template mac_scsi_template = {
>>> +struct scsi_host_template mac_scsi_template = {
>>>      .module            = THIS_MODULE,
>>>      .proc_name        = DRV_MODULE_NAME,
>>>      .name            = "Macintosh NCR5380 SCSI",
>>>
>>
>> I think something went wrong there. No change is needed for
>> mac_scsi_template as it can't be made const.
> 
> I concur - and hope there wasn't a similar patch to atari_scsi.c (that 
> one's host template is also modified during probe).

This patch series does not modify the drivers/scsi/atari_scsi.c source file.

I will drop this patch.

Thanks,

Bart.

