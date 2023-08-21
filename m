Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC94EE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 12:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjHUMfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjHUMfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 08:35:43 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EC5C2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:35:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fee5ddc334so10767795e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692621337; x=1693226137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Psh1Yg7aHq2F7Ayg3BGMUuPWMlj2ugXpanVVFkKCEuQ=;
        b=wVLQitoO44zGDSIkeuTGrmXWXy4m/ccIYC2yFJRkTiA5uNLT+1Vtcp0ZWrnXsPHigu
         mS7iU954kNWzcx5zaWSNABfT5BZWyK1Mi+VwkHYdRxwECF6Q+WL7pYCKcrs0EQ+d4aZc
         Y8w6QGqtZ6GnzW6yV/b2L1BC06III5CYmCF6HzZ70BCxL6CQ/c6DGhpzOXU8Wg2O9rXf
         cWil4Zq/X4ibnBkog8X4EvRgOifd++368bzJW48Ro5XTM3+0ikgjnWu8B+2scLB74Afd
         BoEVWyEnnt/qd8/4MaH6xvGDrfbXb8E+7PVfhUUs2atkG0WhHDtDgSHyPdRt6QDaEIcc
         7xaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692621337; x=1693226137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Psh1Yg7aHq2F7Ayg3BGMUuPWMlj2ugXpanVVFkKCEuQ=;
        b=kl0S3J16dZK2ChuqPXAtCsjmKkZnYUeh5zNkx40C1NE3IrfaMpp03USrfwuFS4x6+6
         xQe32LWAzpitXg2FvmvWNaMW4LF+EvjFAt/J7xB6UsiEEOTgZrR0SiGCI5YqfqhJk9YD
         BTedMiuGkxpz9jG7lVLrGNDj2g2nZnoUD1uMEmewHxYKg7RSER2VeplwMfFsvJnUg+A4
         nPBCkZ45eIOCUNiIZEqyV7oRKmtI7dqp3yZ+oAWnvooQrQqV/MRFlnmPPihXaNRUmC60
         1QzR883N1c+kK6Hy1lJLPteNEVCZuwY1/Dl/pDY3phJwb13d0Cvcp4Hm86j1eqxl3fn5
         Aogg==
X-Gm-Message-State: AOJu0YxTJS+6OnNEIy552J3YiUTn3hC600i/sfLRifR1JUlD1CK11B6H
        G7MKOQ9wPvKv2deO0xf6MktyQQ==
X-Google-Smtp-Source: AGHT+IHJqN4nMiwLfU9x7kJBC0WVgqhplnduP2Vx5BXbnBtiFqUiiZX1EmQ7ZHdvMKsKKnYkVGhazg==
X-Received: by 2002:a05:600c:690e:b0:3fb:c257:9f48 with SMTP id fo14-20020a05600c690e00b003fbc2579f48mr4863816wmb.16.1692621337636;
        Mon, 21 Aug 2023 05:35:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3cb:7bb0:86ea:e59d:2685:7a39? ([2a01:e0a:3cb:7bb0:86ea:e59d:2685:7a39])
        by smtp.gmail.com with ESMTPSA id c1-20020a7bc001000000b003fee567235bsm8457053wmb.1.2023.08.21.05.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 05:35:37 -0700 (PDT)
Message-ID: <e46f177e-b35d-f6a8-35b1-d260f498c5cf@linaro.org>
Date:   Mon, 21 Aug 2023 14:35:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC, PATCH 1/1] rpmb: add Replay Protected Memory Block (RPMB)
 driver
Content-Language: en-US
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Cc:     Shyam Saini <shyamsaini@linux.microsoft.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, linux-scsi@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Tyler Hicks <code@tyhicks.com>,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>,
        Paul Moore <paul@paul-moore.com>,
        Allen Pais <apais@linux.microsoft.com>
References: <20230722014037.42647-1-shyamsaini@linux.microsoft.com>
 <20230722014037.42647-2-shyamsaini@linux.microsoft.com>
 <CAPDyKFoBC+GaGerGDEAjg9q4ayV9mMBKkfFk3nO-zcQzOZ_H6Q@mail.gmail.com>
 <b875892c-1777-d84a-987e-1b0d5ac29df@linux.microsoft.com>
 <94728786-b41b-1467-63c1-8e2d5acfa5e4@linaro.org>
 <CAFA6WYNPViMs=3cbNsEdhqnjNOUCsHE_8uqiDTzwCKDNNiDkCw@mail.gmail.com>
 <CAHUa44Ek0k2b-igA6Gd1ZXVzibTh2sNDMnE-weQwFFKEZ_1jOA@mail.gmail.com>
From:   Jerome Forissier <jerome.forissier@linaro.org>
In-Reply-To: <CAHUa44Ek0k2b-igA6Gd1ZXVzibTh2sNDMnE-weQwFFKEZ_1jOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 8/21/23 13:18, Jens Wiklander wrote:
> On Mon, Aug 21, 2023 at 12:03 PM Sumit Garg <sumit.garg@linaro.org> wrote:
>>
>> On Mon, 21 Aug 2023 at 15:19, Jerome Forissier
>> <jerome.forissier@linaro.org> wrote:
>>>
>>>
>>>
>>> On 8/17/23 01:31, Shyam Saini wrote:
>>>>
>>>> Hi Ulf,
>>>>
>>>>> On Sat, 22 Jul 2023 at 03:41, Shyam Saini
>>>>> <shyamsaini@linux.microsoft.com> wrote:
>>>>>>
>>>>>> From: Alex Bennée <alex.bennee@linaro.org>
>>>>>>
>>>>>> [This is patch 1 from [1] Alex's submission and this RPMB layer was
>>>>>> originally proposed by [2]Thomas Winkler ]
>>>>>>
>>>>>> A number of storage technologies support a specialised hardware
>>>>>> partition designed to be resistant to replay attacks. The underlying
>>>>>> HW protocols differ but the operations are common. The RPMB partition
>>>>>> cannot be accessed via standard block layer, but by a set of specific
>>>>>> commands: WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY. Such a
>>>>>> partition provides authenticated and replay protected access, hence
>>>>>> suitable as a secure storage.
>>>>>>
>>>>>> The initial aim of this patch is to provide a simple RPMB Driver which
>>>>>> can be accessed by Linux's optee driver to facilitate fast-path for
>>>>>> RPMB access to optee OS(secure OS) during the boot time. [1] Currently,
>>>>>> Optee OS relies on user-tee supplicant to access eMMC RPMB partition.
>>>>>>
>>>>>> A TEE device driver can claim the RPMB interface, for example, via
>>>>>> class_interface_register(). The RPMB driver provides a series of
>>>>>> operations for interacting with the device.
>>>>>
>>>>> I don't quite follow this. More exactly, how will the TEE driver know
>>>>> what RPMB device it should use?
>>>>
>>>> I don't have complete code to for this yet, but i think OP-TEE driver
>>>> should register with RPMB subsystem and then we can have eMMC/UFS/NVMe
>>>> specific implementation for RPMB operations.
>>>>
>>>> Linux optee driver can handle RPMB frames and pass it to RPMB subsystem
>>>>
>>
>> It would be better to have this OP-TEE use case fully implemented. So
>> that we can justify it as a valid user for this proposed RPMB
>> subsystem. If you are looking for any further suggestions then please
>> let us know.
> 
> +1
> 
>>
>>>> [1] U-Boot has mmc specific implementation
>>>>
>>>> I think OPTEE-OS has CFG_RPMB_FS_DEV_ID option
>>>> CFG_RPMB_FS_DEV_ID=1 for /dev/mmcblk1rpmb,
>>>
>>> Correct. Note that tee-supplicant will ignore this device ID if --rmb-cid
>>> is given and use the specified RPMB instead (the CID is a non-ambiguous way
>>> to identify a RPMB device).
>>>
>>>> but in case if a
>>>> system has multiple RPMB devices such as UFS/eMMC/NVMe, one them
>>>> should be declared as secure storage and optee should access that one only.
>>>
>>> Indeed, that would be an equivalent of tee-supplicant's --rpmb-cid.
>>>
>>>> Sumit, do you have suggestions for this ?
>>>
>>
>> I would suggest having an OP-TEE secure DT property that would provide
>> the RPMB CID which is allocated to the secure world.
> 
> Another option is for OP-TEE to iterate over all RPMBs with a
> programmed key and test if the key OP-TEE would use works. That should
> avoid the problem of provisioning a device-unique secure DTB. I'd
> expect that the RPMB key is programmed by a trusted provisioning tool
> since allowing OP-TEE to program the RPMB key has never been secure,
> not unless the OP-TEE binary is rollback protected.

+1 if we can assume the same key won't be used for several devices, which
is probably reasonable.

> 
> Cheers,
> Jens
> 
>>
>> -Sumit
>>
>>>
>>> --
>>> Jerome
