Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7BBC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiKISf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiKISf1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:35:27 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185B26300
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:35:22 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id k7so17894291pll.6
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ylIF2AYBYLYRDJoNZTOERTcceSqhKKtfhn8u2jxzdVI=;
        b=E0BpyhuI9jY1TMBq1GH3olGAt85L7X9mCKFDQvWW4oZmBLQuAIRDWvfOILQJnL978T
         glKXRF9DKWBh9OKu8nAqQ+DNtuyv9OD3Us30Cgr4+JZ2+VN48jxZeQLsBXNgtTxa4+jH
         GilrWkDGkgVL+xGlga2C/U8s19G5+XsK5EBGOpolWDh0U+1aDV+C+qxftDSA4SmD0+v5
         CmmpkfExsOyJdIEpd/p9WYLv5m4viIPtj3bwhUYNk6UBbQPh6k2ouB24VgQdypdFVapy
         C/Wfl/6FPLdLw6b3Xa5V+Zf66gqkVlM81gpm15jlkRvQJg/SLOjGsMEYAYm3yV/C4SRW
         JWlg==
X-Gm-Message-State: ACrzQf1FTpyYLADESRw4Av37BmsWrIC71jrsuVarxgW/1UJf32OlhoSM
        uJnuf63tSm6Y1yyhOXcA+hY=
X-Google-Smtp-Source: AMsMyM4Ci2F56kAi6TJX5brn67Z9iHUSPZ9VejM9IU0Evw3fxqRopHyxFft6A0E2R0sEnjZOMV0ZGQ==
X-Received: by 2002:a17:902:e803:b0:186:5f82:3812 with SMTP id u3-20020a170902e80300b001865f823812mr1281176plg.51.1668018921437;
        Wed, 09 Nov 2022 10:35:21 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b0017d97d13b18sm9473448pla.65.2022.11.09.10.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:35:20 -0800 (PST)
Message-ID: <435bb076-644d-599c-b7ba-cfa630696221@acm.org>
Date:   Wed, 9 Nov 2022 10:35:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org>
 <Y2vwX3XlibvDi70/@sol.localdomain>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y2vwX3XlibvDi70/@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 10:24, Eric Biggers wrote:
> On Tue, Nov 08, 2022 at 03:33:39PM -0800, Bart Van Assche wrote:
>> +config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
>> +	bool "Variable size UTP physical region descriptor"
>> +	help
>> +	  In the UFSHCI 3.0 standard the Physical Region Descriptor (PRD) is a
>> +	  data structure used for transferring data between host and UFS
>> +	  device. This data structure describes a single region in physical
>> +	  memory. Although the standard requires that this data structure has a
>> +	  size of 16 bytes, for some controllers this data structure has a
>> +	  different size. Enable this option for UFS controllers that need it.
> 
> This shouldn't be a user-selectable option.  Just make it be enabled
> automatically when it is needed.  Like this:
> 
> config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> 	bool
> 	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO

Thanks Eric for having taken a look. I will include the above change in 
this patch when I repost it.

> Also, this patch doesn't make sense without the code that actually needs it, so
> I hope you plan to send that upstream too.  I haven't been able to do so yet,
> because no platform with this hardware actually can run the upstream kernel at
> all, as far as I know.  Maybe commit 06874015327 ("arm64: dts: exynos: Add
> initial device tree support for Exynos7885 SoC") changed that?  Any suggestions
> would be greatly appreciated...  How are you testing this?

My approach for maintaining the UFS driver in the Android kernel tree is 
to keep the diffs between the upstream UFS driver and the driver in the 
Android kernel tree as small as possible. This patch has been tested in 
the same way as my other UFS driver patches, namely by applying it on 
the Android kernel tree and by testing the Android kernel tree. For this 
patch in particular "applying" came down to integrating the changes from 
this patch that are not yet in the Android kernel tree.

Thanks,

Bart.
