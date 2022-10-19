Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29830C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 22:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiJSWEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 18:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJSWD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 18:03:58 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734491C19F7
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:03:57 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id y8so18478457pfp.13
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOjWRdI1mJt9L3SalQK5WfjUjryKob/B241hVj1tk9E=;
        b=NJUd99sGBdujkR9T8b+wsmxwYSLMTWqb7CCTKS5XZKecROpwTAFZ8JnwuKZCDQ4JYn
         nB0HFLasBdTFbzt9hagq5FWQtYi/RYYtp9CjUFw/HSrOmeHW1sDrC/kgAdr0aHl1mGrc
         NEnRTT2W+5oRUxClf9MCSNLUr4ZSlisws4J0IfUQBYrDoLwWFDRQIgX0izxPZZPETZLR
         T0kQdXS71HJDp2la0O2holJAnbWB8xuLP+xXh6KqQGCEMuq9lnikmnA2plpQIY0BiJV6
         2R/58g8yQsCt9Wt6SMLiQI2BcXgm3dkIHV/yENqeEhGIFG9sO76BHNrNBvJbwj+WQe7H
         o0TQ==
X-Gm-Message-State: ACrzQf2VD99COygRieb5XlezSocYp6qGQep+SQv4HMwR1mG7Mvmvvp0o
        ivcPIQxGBaDkF95cBAlVpa4=
X-Google-Smtp-Source: AMsMyM6NaWzIpsWAgfjlKJiqtQs2wxy/60D+CIHylfOpbypJelfHUlZ9nXMeOSvY5vY7aiRofgDG+Q==
X-Received: by 2002:a63:5b1b:0:b0:46b:173c:57c0 with SMTP id p27-20020a635b1b000000b0046b173c57c0mr9135544pgb.191.1666217036754;
        Wed, 19 Oct 2022 15:03:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090341c200b0017f7bef8cfasm11350695ple.281.2022.10.19.15.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 15:03:55 -0700 (PDT)
Message-ID: <334200c3-3866-66e8-fb55-4fa72a4689a1@acm.org>
Date:   Wed, 19 Oct 2022 15:03:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 02/35] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-3-michael.christie@oracle.com>
 <1c610cd3-505a-df66-dc05-1f7eb3e460af@acm.org>
 <48692e04-71a2-0b95-5713-8c25a0fee227@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <48692e04-71a2-0b95-5713-8c25a0fee227@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/22 09:18, Mike Christie wrote:
> On 10/4/22 5:27 PM, Bart Van Assche wrote:

>>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>>> index bac55decf900..9ab97e48c5c2 100644
>>> --- a/include/scsi/scsi_cmnd.h
>>> +++ b/include/scsi/scsi_cmnd.h
>>> @@ -65,6 +65,24 @@ enum scsi_cmnd_submitter {
>>>        SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
>>>    } __packed;
>>>    +#define SCMD_FAILURE_NONE    0
>>> +#define SCMD_FAILURE_ANY    -1
>>
>> This is the same value as -EPERM. Would something like 0x7fffffff be a better
>> choice for SCMD_FAILURE_ANY?
> 
> I didn't get that. All of this is used for the scsi_cmnd->result evaluation
> and retries (host, status, internal bytes) which are all positive and where
> we don't use -Exyx errors.

(just noticed that I had not yet replied to this email and that this 
conversation is also relevant for v4 of this patch series).

Last time I checked I found a few SCSI LLDs that assign -Exyz error 
values to the scsi_cmnd->result field, e.g. the scsi_debug driver. 
However, I'm not sure that is still the case today.

>>> +struct scsi_failure {
>>> +    int result;
>>> +    u8 sense;
>>> +    u8 asc;
>>> +    u8 ascq;
>>> +
>>> +    s8 allowed;
>>> +    s8 retries;
>>> +};
>>
>> Why has 'retries' type s8 instead of u8?
> 
> There is a:
> 
> #define SCMD_FAILURE_NO_LIMIT   -1
> 
> in the defines that got cut off when you replied which is used for some
> users that had no limit on retries.

Hmm ... isn't SCMD_FAILURE_NO_LIMIT a value that only should be assigned 
to the .allowed member and not to the .retries member? Is my 
understanding correct that the .retries member should be set to zero 
before execution of a SCSI command start and that the only manipulation 
that happens on that member is incrementing it in scsi_check_passthrough()?

Thanks,

Bart.

