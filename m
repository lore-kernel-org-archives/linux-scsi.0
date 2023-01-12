Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10648C54EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 23:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjALXMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 18:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjALXMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 18:12:12 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E3716497
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:12:09 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id a184so14925110pfa.9
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2023 15:12:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FP1w+EKkF/Ua6A8h93yeNn9dPWHKc0y9opJaXcMcQ2U=;
        b=eguHcBUUReGm6n31DHKk3VVYrtPajWEoZMnk9F8YD3WONqwXG8uUvV1BYQn8rS1eIi
         ngXt9wsuEM8tK51XHYOECLjV+QB7CBShvUCvcRMuFrTMQBG7OHknQhSRLtkyaX6lA2tb
         kLcGGljdiZ4V/bdbdHemFdke82shRNQChBceFF9Rvj5LWsXbL6fF4WzCI479k++w19lN
         Gtz4vZaaDRQL+SGwGc+qUscW9QQ0sN6iezfdu6mrWNXucPlxbOWF2jHXb5aO3YNCXdYb
         XNiWzT6/vL39ACpcc+v0C8T8HK7bkQbibC4saLa21Gg1zFCWFVsS84oOTZhWKShPi/G5
         F1cA==
X-Gm-Message-State: AFqh2koNf2NZSZcuaVkEhNWJJ3f58gHDT7RqnlFiQn8bwpEJ9m08j+1Z
        H/7E6LHBmsmbJzVmPRJ4LZQ=
X-Google-Smtp-Source: AMrXdXs8n/EA9gTys+cv/xUE2rQ+nm6C/8bgoI2OoVxMAjyZsiNo6l2ecIi6uuqLzC/U9TWSLiLN/g==
X-Received: by 2002:a62:52d0:0:b0:582:c408:3ed1 with SMTP id g199-20020a6252d0000000b00582c4083ed1mr8039651pfb.32.1673565128921;
        Thu, 12 Jan 2023 15:12:08 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id w188-20020a6230c5000000b00581f76c1da1sm12323529pfw.191.2023.01.12.15.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 15:12:08 -0800 (PST)
Message-ID: <ddea8484-76fa-d2cb-5dde-51a343b9be66@acm.org>
Date:   Thu, 12 Jan 2023 15:12:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 3/3] scsi: ufs: Enable DMA clustering
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20230106215800.2249344-1-bvanassche@acm.org>
 <20230106215800.2249344-4-bvanassche@acm.org>
 <56f36c02-bc04-0587-2980-d28b7b75394f@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <56f36c02-bc04-0587-2980-d28b7b75394f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/9/23 23:56, Adrian Hunter wrote:
> On 6/01/23 23:58, Bart Van Assche wrote:
>> All UFS host controllers support DMA clustering. Hence enable DMA
>> clustering.
> 
> The patch history of ufshcd.c seems to suggest the dma_boundary
> setting was never intentional, but was inherited by default.
> 
> However, I guess it is not impossible that removing the setting
> exposes issues for existing controllers.
> 
> I suggest perhaps expanding upon the commit message and the
> cc list so more people will be aware of the change.
> 
> Possibly worth including the explanation in your reply to
> Avri concerning PRDT 256K DBC limit
> 
>>
>> Note: without patch "Exynos: Fix the maximum segment size", this patch
>> breaks support for the Exynos controller.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Otherwise:
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Hi Adrian,

I will make the requested changes.

Thanks for the review!

Bart.

