Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF242C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 18:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353575AbiBCSvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 13:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353564AbiBCSvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 13:51:33 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC0BC06173B
        for <linux-scsi@vger.kernel.org>; Thu,  3 Feb 2022 10:51:33 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v3so3040921pgc.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Feb 2022 10:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uPyNWYdldvQClpjjiS703OwIt+6qFtHfsijlmI8VUS4=;
        b=qlry1dOwLSSy7eo6Lv0yzWS9XU8CVkOd5nrLsm4EDZF9E5HYepSJGIy48e5W7Z3lCn
         fWy6vjZ/aX/tv7tvHz7hRAY01ofxb76d0rUvwli8Svnny+q7HziQAv4diaoM94Jk1uo6
         ljdLu+1PwhyAioYCXviWmcyKREcaL2PT5Dt620LpwRRQ36iMsBUDf7KU61KSKVayGZLH
         SrzUjvXDjkp4ijRkvNyK424ZifG8RfDYNysk7AF4bQc8L1YyJ4Tud6x5Vd4GStEmJsCo
         USJFU02iz0tJ7lQT2jY8xKhu02YthMXqwmfeFO3rcDIGSNIYYZezSr5wcnLi1LytFiPx
         GgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uPyNWYdldvQClpjjiS703OwIt+6qFtHfsijlmI8VUS4=;
        b=BSSHepLAWSSZi+8wGocUnE+7Q9U6trYslghA02YhZG/OQxH2//RpoPMlJrYzMhhvx/
         9Ci1WcjgskWtJGCK919AbXL+WrzmWclAgDE99Z0/P71yfmI/aWcvZ6oR9fFImoCj/d8k
         MZ/nUGxPVARQQ5t3WjwZitq48g1BIBnOuWCDQs4XCvwouijsnpc9eLIIpYIA9t3giQpm
         rpd2bCIFCg+r49xEKvac07XlbOdtR2VHvN3aJr/tvQiMi2UF6s1ks5yCAmcFtH9VDnrT
         PZV7tcTySE3D7Xi3/zMkpohwEDVY1Q4rLuQM2XiH/7gHYjC5hhzOT4GmlSW4hx40SxIh
         c+uA==
X-Gm-Message-State: AOAM5324Mn6z8hmwymq5AY+2Ik6Yoyl9izRZbQEnNyftzBhwtk7qCmah
        CdcbawXejctErRTloir79HLeZm8mvBlMpg==
X-Google-Smtp-Source: ABdhPJwc6AV0ALvNk3CFNwiAQO4/q4AoUNOOMScCFcdKWGHBm+0S68X3/qvGnUIdc6kBCVl6N4ByrQ==
X-Received: by 2002:a62:6385:: with SMTP id x127mr34730817pfb.10.1643914293077;
        Thu, 03 Feb 2022 10:51:33 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e1::19a8? ([2620:10d:c090:400::5:d477])
        by smtp.gmail.com with ESMTPSA id b12sm12745940pfm.154.2022.02.03.10.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:51:32 -0800 (PST)
Subject: Re: [PATCH 1/2] block: introduce BLK_STS_OFFLINE
To:     Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>, Song Liu <song@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220203064009.1795344-1-song@kernel.org>
 <20220203064009.1795344-2-song@kernel.org>
 <CAPhsuW6PNaYUb5xDxPX_gX=2fZdiRURRos5sT_Tsbngon1+eKw@mail.gmail.com>
 <f7489746-b8fb-bc9a-a706-e5926fa9e325@suse.de>
 <27583256-dc7d-74bd-115c-b0c835cd5c1b@kernel.dk>
 <C3D342B9-C4D0-4C3A-9582-EB15A5F5D7FF@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <02a0e0eb-dd85-414e-3cb9-5239040ee92b@kernel.dk>
Date:   Thu, 3 Feb 2022 11:51:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C3D342B9-C4D0-4C3A-9582-EB15A5F5D7FF@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 10:23 AM, Song Liu wrote:
> Hi Hannes and Jens,
> 
>> On Feb 3, 2022, at 5:47 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/3/22 12:24 AM, Hannes Reinecke wrote:
>>> On 2/3/22 07:52, Song Liu wrote:
>>>> CC linux-block (it was a typo in the original email)
>>>>
>>>> On Wed, Feb 2, 2022 at 10:40 PM Song Liu <song@kernel.org> wrote:
>>>>>
>>>>> Currently, drivers reports BLK_STS_IOERR for devices that are not full
>>>>> online or being removed. This behavior could cause confusion for users,
>>>>> as they are not really I/O errors from the device.
>>>>>
>>>>> Solve this issue with a new state BLK_STS_OFFLINE, which reports "device
>>>>> offline error" in dmesg instead of "I/O error".
>>>>>
>>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>>> ---
>>>>>  block/blk-core.c          | 1 +
>>>>>  include/linux/blk_types.h | 7 +++++++
>>>>>  2 files changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>>> index 61f6a0dc4511..24035dd2eef1 100644
>>>>> --- a/block/blk-core.c
>>>>> +++ b/block/blk-core.c
>>>>> @@ -164,6 +164,7 @@ static const struct {
>>>>>         [BLK_STS_RESOURCE]      = { -ENOMEM,    "kernel resource" },
>>>>>         [BLK_STS_DEV_RESOURCE]  = { -EBUSY,     "device resource" },
>>>>>         [BLK_STS_AGAIN]         = { -EAGAIN,    "nonblocking retry" },
>>>>> +       [BLK_STS_OFFLINE]       = { -EIO,       "device offline" },
>>>>>
>>>>>         /* device mapper special case, should not leak out: */
>>>>>         [BLK_STS_DM_REQUEUE]    = { -EREMCHG, "dm internal retry" },
>>>>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>>>>> index fe065c394fff..5561e58d158a 100644
>>>>> --- a/include/linux/blk_types.h
>>>>> +++ b/include/linux/blk_types.h
>>>>> @@ -153,6 +153,13 @@ typedef u8 __bitwise blk_status_t;
>>>>>   */
>>>>>  #define BLK_STS_ZONE_ACTIVE_RESOURCE   ((__force blk_status_t)16)
>>>>>
>>>>> +/*
>>>>> + * BLK_STS_OFFLINE is returned from the driver when the target device is offline
>>>>> + * or is being taken offline. This could help differentiate the case where a
>>>>> + * device is intentionally being shut down from a real I/O error.
>>>>> + */
>>>>> +#define BLK_STS_OFFLINE                ((__force blk_status_t)17)
>>>>> +
>>>>>  /**
>>>>>   * blk_path_error - returns true if error may be path related
>>>>>   * @error: status the request was completed with
>>>>> --
>>>>> 2.30.2
>>>>>
>>> Please do not overload EIO here.
>>> EIO already is a catch-all error if we don't know any better, but for 
>>> the 'device offline' case we do (or rather should).
>>> Please map it onto 'ENODEV' or 'ENXIO'.
>>
>> It's deliberately EIO as not to force a change in behavior. I don't mind
>> using something else, but that should be a separate change then.
> 
> Thanks for these feedbacks. Shall I send v2 with an extra patch that 
> changes EIO to ENODEV/ENXIO? Or shall we do that in a follow up patch? 
> Also, any preference between ENODEV and ENXIO? 

Yeah I think so, and perhaps put a mention in this patch on why EIO is
chosen to not change the user visible return value.

-- 
Jens Axboe

