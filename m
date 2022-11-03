Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C66C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Nov 2022 18:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiKCSOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Nov 2022 14:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKCSOW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2022 14:14:22 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EBF6252;
        Thu,  3 Nov 2022 11:14:22 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d20so1628823plr.10;
        Thu, 03 Nov 2022 11:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AAumLxLnWfAM18CUZyhLKrEQTBxFDu0Nq3UHPT8n9DM=;
        b=fiBPUBEIxIE3XElAT/zeDtSLPL9owi4Cu2Y7HwcnCiCYtBkLW0QZClAZ5lbtgvtbNZ
         vqCp6yrCOlKTleMVslwJdnRmzs2LvwfFyd8fXls3GID7v77zPx+dts+PaYIjGCNBj55M
         u93rLP75yHvKpwM1xfFgfGteCaLP1KFFQpbGsiOHIBABYvdrkpwYxx501CieBouqVvBP
         X3Fdkedk1FAE3HMy+TviFA0/jWl59lJ5m7seNUkJ4zCB0g42I66Q1YadPYe1TGy+nAN8
         CqTJ+jCxm83teJsmAHENq+E4ReFRXJNEYrA+tMJByXnp8HJrriyqmd+GAuttIjJTWCIU
         Yixw==
X-Gm-Message-State: ACrzQf3Vnx2PXwclG1NyzVb25I2fZadMZbHXxZdcqikYWtGBFVnE7MV1
        4ZGxFZnXp/rKSOzp2wMi5c7APzsxG+M=
X-Google-Smtp-Source: AMsMyM7EErA8tHxPvzrZVcpD4tDFhNKSgLTGblrV/zcW9vCOr6QKeDAhLbttK1YYZeyphS7cjxvfow==
X-Received: by 2002:a17:90b:4d0e:b0:1f7:ae99:4d7f with SMTP id mw14-20020a17090b4d0e00b001f7ae994d7fmr49029090pjb.200.1667499261396;
        Thu, 03 Nov 2022 11:14:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:881a:8a80:fdae:8683? ([2620:15c:211:201:881a:8a80:fdae:8683])
        by smtp.gmail.com with ESMTPSA id q17-20020a17090311d100b00178b77b7e71sm958760plh.188.2022.11.03.11.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 11:14:20 -0700 (PDT)
Message-ID: <84af9938-81bc-7c58-2210-7da935312d6a@acm.org>
Date:   Thu, 3 Nov 2022 11:14:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
 <0123db70-6217-135a-4101-0609512e723b@acm.org>
 <7b8cdc82-0aca-2f41-2eed-299dacf95771@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7b8cdc82-0aca-2f41-2eed-299dacf95771@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/22 19:13, Mike Christie wrote:
> On 11/2/22 5:47 PM, Bart Van Assche wrote:
>> On 10/26/22 16:19, Mike Christie wrote:
>>> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
>>> +{
>>> +    switch (type) {
>>> +    case PR_WRITE_EXCLUSIVE:
>>> +        return SCSI_PR_WRITE_EXCLUSIVE;
>>> +    case PR_EXCLUSIVE_ACCESS:
>>> +        return SCSI_PR_EXCLUSIVE_ACCESS;
>>> +    case PR_WRITE_EXCLUSIVE_REG_ONLY:
>>> +        return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
>>> +    case PR_EXCLUSIVE_ACCESS_REG_ONLY:
>>> +        return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
>>> +    case PR_WRITE_EXCLUSIVE_ALL_REGS:
>>> +        return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
>>> +    case PR_EXCLUSIVE_ACCESS_ALL_REGS:
>>> +        return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>>> +    default:
>>> +        return 0;
>>> +    }
>>> +};
>>
>> Please leave out "default: return 0;" from the switch statement and add "return 0;" after the switch statement. That will make the compiler emit a warning if a value is added in enum pr_type but not in the above function.
> 
> Did you want that compiler warning functionality in the future code
> or are you asking me to do the above only if we go the switch based
> route?
> 
> Chaitanya requested me to make this array based in nvme/scsi. For this
> approach, I can add a WARN or printk warning if the pr_type passed in
> does not match a value in the array. I don't think I can do a compiler
> warning though.
> 
> I didn't care, but I think the compiler warning route might be better
> though.

Hi Mike,

Although I do not have a strong opinion about this, keeping the switch 
statement and moving the return statement out of the switch statement 
has the advantage that the compiler will warn if the switch statement is 
incomplete. I don't think that a similar warning would be emitted if the 
switch statement would be converted into an array lookup.

Thanks,

Bart.
