Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0AEEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jul 2023 21:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjGEVzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjGEVzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 17:55:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C36F19A2;
        Wed,  5 Jul 2023 14:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A594D61759;
        Wed,  5 Jul 2023 21:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AFBC433C8;
        Wed,  5 Jul 2023 21:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688594100;
        bh=w559jmLes3Grvv9ri7rfosuFmLDh7JKyrtNKcFvxCr8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ye2wFl/EO9yyXVyL2E5g3TZMvlKwreJJckbMiRCqKW0nPn31I76JKHay2YvzSiZid
         qgHmVHFyFQHAVMlaJN3BNf2ZIEa8POGecLrlVNHfGJA/7UbHYm5k8CyhkY3N/w/ocC
         4qu0DDbYnVF2Smf6HAJHUnps8Q5dpYRr7tIGm5a8wqY+PUvYKh4AeK2tB0Z8/mk4bz
         ZSSyeWUp8aqrl21dqowUExXMQ1kyz04x1eyooyKX5wxt7wQIF/UyH59gm6CwsFC4mO
         S6UeolE4/s8mA6fdMlqj9awLUMkvCBnDoKtyU0hJfH7y51Q5nHVYN6VR60JDQIR54j
         /wyJ0X2DODDGw==
Message-ID: <030aa418-d88a-585f-8098-a0d69c978656@kernel.org>
Date:   Thu, 6 Jul 2023 06:54:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/2] mpt3sas: Perform additional retries if Doorbell read
 returns 0
Content-Language: en-US
To:     Ranjan kumar <kranjan.kernelbugtrack@gmail.com>
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        stable@vger.kernel.org
References: <20230628070511.27774-1-ranjan.kumar@broadcom.com>
 <20230628070511.27774-2-ranjan.kumar@broadcom.com>
 <f170e2ae-a416-7a0b-ff52-f446eaf78ab9@kernel.org>
 <CA+Uq_0ygAziCivFdWX+wg6AGKoGd1q6+9QH776fJScH4q_6d3A@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CA+Uq_0ygAziCivFdWX+wg6AGKoGd1q6+9QH776fJScH4q_6d3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/5/23 21:37, Ranjan kumar wrote:
> Hi Damien,
> Regarding delay:
> As Sathya already mentioned  as this is our hardware specific behavior and
> we are confident that the increased retry count
> is sufficient from our hardware perspective for any new systems too. So, we
> want to go with this change .

Fine. Adding a comment above the macro definitions to explain something like
that would be nice.

> Apart from that, I will change the name as suggested .
> 
> Thanks & Regards,
> Ranjan

Please avoid top posting.

> On Thu, 29 Jun 2023 at 05:24, Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> On 6/28/23 16:05, Ranjan Kumar wrote:
>>> Doorbell and Host diagnostic registers could return 0 even
>>> after 3 retries and that leads to occasional resets of the
>>> controllers, hence increased the retry count to thirty.
>>
>> The magic value "3" for retry count was already that, magic. Why would
>> things
>> work better with 30 ? What is the reasoning ? Isn't a udelay needed to
>> avoid
>> that many retries ?
>>
>>>
>>> Fixes: b899202901a8 ("mpt3sas: Add separate function for aero doorbell
>> reads ")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
>>
>> [..]
>>
>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h
>> b/drivers/scsi/mpt3sas/mpt3sas_base.h
>>> index 05364aa15ecd..3b8ec4fd2d21 100644
>>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
>>> @@ -160,6 +160,8 @@
>>>
>>>  #define IOC_OPERATIONAL_WAIT_COUNT   10
>>>
>>> +#define READL_RETRY_COUNT_OF_THIRTY  30
>>> +#define READL_RETRY_COUNT_OF_THREE   3
>>
>> Less than ideal naming I think. If the values need to be changed again, a
>> lot of
>> code will need to change. What about soemthing like:
>>
>> #define READL_RETRY_COUNT       30
>> #define READL_RETRY_SHORT_COUNT 3
>>
>>>  /*
>>>   * NVMe defines
>>>   */
>>> @@ -994,7 +996,7 @@ typedef void (*NVME_BUILD_PRP)(struct
>> MPT3SAS_ADAPTER *ioc, u16 smid,
>>>  typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16
>> smid,
>>>       u16 funcdep);
>>>  typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16
>> smid);
>>> -typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr);
>>> +typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr, u8
>> retry_count);
>>>  /*
>>>   * To get high iops reply queue's msix index when high iops mode is
>> enabled
>>>   * else get the msix index of general reply queues.
>>
>> --
>> Damien Le Moal
>> Western Digital Research
>>
>>
> 

-- 
Damien Le Moal
Western Digital Research

