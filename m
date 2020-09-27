Return-Path: <SRS0=qC8i=DE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BF0C4741F
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Sep 2020 16:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8AF23899
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Sep 2020 16:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdQBUzc/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgI0QP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Sep 2020 12:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgI0QPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Sep 2020 12:15:25 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FE6C0613CE;
        Sun, 27 Sep 2020 09:15:25 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x69so8303592lff.3;
        Sun, 27 Sep 2020 09:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L/xc46eYC0rZns9hNBhr248U6alDhReApEPhDLkCO6E=;
        b=VdQBUzc/6LpyDv2Xp8olbr6AbUms+2N2G53yQPXbznI2rqUR7RoPQd63+zLAC2VKRT
         krG6jeEqUHdq7uW+rPYqX6XC1xOaKONLfJ15kR+JwWGr9CJaCqXfTzsR3OkQ3jsShKA2
         +WwPvBMPm1B1Bo58AymftI3xbbco3d9uZPNHTe6pu+YzhAhkzn4TL+UJmpOfp8NWpXGb
         td3K6BsTCc/bV0JobIvZ8bddmrlz7lVZpSXTyexbITeMbFXnTZLZm3bATnXBtcbQCM45
         3A5WUwlwCxfNj4R0EE+9vd3V0qf+h4mJUM4tbvZMk22xAYWeYtMeDdsVX7wGtNj6Lsyw
         E3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L/xc46eYC0rZns9hNBhr248U6alDhReApEPhDLkCO6E=;
        b=e3XMf3hmjdUt9VqgNFZIMyOaHSOa9rXraloO/41qpsWHNTHm8vENLLPHSB/svcwr7y
         3/Dj1sVO8APlf893IjFVH3zNnEt8phlI8v3Oh6zTYwXPXDcDYxuHg4Jv2wFMopZkgW48
         HkrsjKQut7xsOmyRSHhA27Q32SEs5QD6OWyzD8LuJa+R7hC51OPL6Payrltr1PNi0P+U
         uszivldakKmZryU4fN1TvACRw6pliF1Ix9aRiXYT4AzJmTgKB21J5sP7DGKBh2LM7eRr
         1EZRb6i3c4nmCxbirgot4uw1kwBfN3xZFHQjN76qJTwzyxXoYQFyrUsWDYa4d4IDezV7
         CR4g==
X-Gm-Message-State: AOAM531LyzmebaJd0iqHBnPzsXOOU0DRwI+gYzV6SXYg9J6FS3CwF5GS
        T3oXVnpGOyh4ezASmtSn21HhJUCLN68=
X-Google-Smtp-Source: ABdhPJweeGA3s6tWwyWwovw6Rhzh1m2PRjg8htzqpYDmOK4ZLzVRz1hasBUTiHMhlNCsxJ185rYUew==
X-Received: by 2002:a19:8386:: with SMTP id f128mr2390970lfd.78.1601223323824;
        Sun, 27 Sep 2020 09:15:23 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:42b8:5974:65f4:959a:46a2:f702? ([2a00:1fa0:42b8:5974:65f4:959a:46a2:f702])
        by smtp.gmail.com with ESMTPSA id p9sm3134414ljj.52.2020.09.27.09.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2020 09:15:23 -0700 (PDT)
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     tasleson@redhat.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <1cfc145b-180a-d906-5d9b-638c483177c7@gmail.com>
 <90ef294c-2f37-2299-6253-68ea27e312b4@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <f276f116-a80c-fb98-0569-d7a6799868d4@gmail.com>
Date:   Sun, 27 Sep 2020 19:15:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <90ef294c-2f37-2299-6253-68ea27e312b4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27.09.2020 17:22, Tony Asleson wrote:

>>> Function callback and function to be used to write a persistent
>>> durable name to the supplied character buffer.  This will be used to add
>>> structured key-value data to log messages for hardware related errors
>>> which allows end users to correlate message and specific hardware.
>>>
>>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>>> ---
>>>    drivers/base/core.c    | 24 ++++++++++++++++++++++++
>>>    include/linux/device.h |  4 ++++
>>>    2 files changed, 28 insertions(+)
>>>
>>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>>> index 05d414e9e8a4..88696ade8bfc 100644
>>> --- a/drivers/base/core.c
>>> +++ b/drivers/base/core.c
>>> @@ -2489,6 +2489,30 @@ int dev_set_name(struct device *dev, const char
>>> *fmt, ...)
>>>    }
>>>    EXPORT_SYMBOL_GPL(dev_set_name);
>>>    +/**
>>> + * dev_durable_name - Write "DURABLE_NAME"=<durable name> in buffer
>>> + * @dev: device
>>> + * @buffer: character buffer to write results
>>> + * @len: length of buffer
>>> + * @return: Number of bytes written to buffer
>>
>>     This is not how the kernel-doc commenta describe the function result,
>> IIRC...
> 
> I did my compile with `make  W=1` and there isn't any warnings/error
> with source documentation, but the documentation does indeed outline a

    IIRC, you only get the warnings when you try to build the kernel-docs.

> different syntax.  It's interesting how common the @return syntax is in
> the existing code base.

    FWIW, I'm seeing @return: for the 1st time in my Linux tenure (since 2004).

> I'll re-work the function documentation return.

    OK, thanks. :-)

> Thanks

MBR, Sergei
