Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBEAC6379F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 17:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjBCRyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 12:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjBCRyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 12:54:37 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31374B18E
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 09:54:27 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id n13so5985485plf.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2023 09:54:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50evl/Ej9a+X/R02ojNK1P//dBMD9Nv3uYsAEvmXqX8=;
        b=HvYC3d9hpE2js8Ykh4l/5I37oh6auw3A0BJ0yHXNciFblIGBlHWQrWowEPjAiqlG3S
         JEWYeoeI9BbTrEryaGnNI9MiZydNVO1PofbR9eEn0ap6mZ9R1yX+x4+W3J0UwcfsJgWr
         cKErG3vjglXLhv/ydCG9duMPSMRvixZyonYMSGZEBUpH5Vm7t+JqvCxLaRnrZhJOwivQ
         NrnRkEj1/2pc5aUMO1UzgYEGcdUPm5DpHKiX0rf8DbxHj/BMgr8452O1CYEpk5zZ35Qn
         oERo6UB6xFGbwZUy/rEa744kJLGiIvcczIRHBpC9NUwxlyjxhqIKIg+KYrhc2kQPuOJZ
         ErgA==
X-Gm-Message-State: AO0yUKUDt3i0AF1ZWMrc8REagfF5a1WYveLkmFRKU/0AVZqmdoGxrUUz
        ib6uF1DC5DmggoY/oLjLhb8=
X-Google-Smtp-Source: AK7set/LeSxFvDotLrH0pGQA8WEX62CarSPma7i3adaMY7uXU2aVrpPpKJv+JVvfsOi1l8ZS3qQp+w==
X-Received: by 2002:a17:903:4101:b0:198:e94a:64b5 with SMTP id r1-20020a170903410100b00198e94a64b5mr1013151pld.10.1675446867057;
        Fri, 03 Feb 2023 09:54:27 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:b752:5d03:ec5e:7be5? ([2620:15c:211:201:b752:5d03:ec5e:7be5])
        by smtp.gmail.com with ESMTPSA id w22-20020a170902a71600b0019681ab4658sm1807348plq.309.2023.02.03.09.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 09:54:26 -0800 (PST)
Message-ID: <235d32fe-1d78-2eff-2e13-5ac82b337793@acm.org>
Date:   Fri, 3 Feb 2023 09:54:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS
 devices
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
References: <20230202220041.560919-1-bvanassche@acm.org>
 <Y9yp+H1qkuAxrB8j@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y9yp+H1qkuAxrB8j@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/23 22:30, Christoph Hellwig wrote:
> On Thu, Feb 02, 2023 at 02:00:39PM -0800, Bart Van Assche wrote:
>> Hi Martin,
>>
>> Measurements have shown that UFS devices perform better when using SYNCHRONIZE
>> CACHE instead of FUA. Hence this patch series that makes the SCSI core submit
>> a SYNCHRONIZE CACHE command instead of setting the FUA bit for UFS
>> devices. Please consider this patch series for the next merge window.
> 
> NAK.  This is a policy decision that might make sense for current UFS
> devices.  If you want to do it use the sysfs files from udev to quirk
> it up for them.  But there is nothing inherent in the UFS transport
> that speaks against using FUA.
> 
> And please lobby your suppliers to either don't claim FUA support or
> implement it in a useful way in the future.  Unlikely most of us you
> and your employer actually have that power in the market.

Hi Christoph,

We can ask our suppliers politely to not claim FUA support in future 
devices. However we still need patch 1/2 for existing UFS devices.

Bart.
