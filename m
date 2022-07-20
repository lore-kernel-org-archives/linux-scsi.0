Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6646CC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 16:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiGTQzu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiGTQzt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 12:55:49 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA97BC84
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 09:55:48 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d7so3669653plr.9
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 09:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i0/aDyLvFttIqWEOt/o7NzfKFXNnOWp6+DTVFkO7RNg=;
        b=hAfziH1eV2+cTiv5HiQhwRzhTB7sBbukARPnnpYRj5vWNBPZ3RohdLwLNsOM0Eyfbz
         BWW1dbQHdhrbkytvEwdt9DYgOdwUZ1c0jhq8whLgm6o9xjhQwIWv+viGHj0fJSysIZC7
         hm/JSnjGZykm4W4T+lzRc1gQZpyAQutSm9NEDdycSkRr5ZyBHX2Vg3JfGkz6TaBDCuKP
         tTzhcRwng4weegf595kk0jQMopLvDyEqVWZLwhP3nIjWq03w4VffEaqf419yPkuFLOK2
         /kXPDYmsa3YGT/vQvYqldTAm30QZgTcsLbY+nOJ7OgmGTDM8K07Q4SntPy7Pc/5itUXs
         FRYw==
X-Gm-Message-State: AJIora+6IE9FpNzkhXUTk9w7sFVRfWEN39pvig5xWMgZkNXpjOoFYzNq
        4vX41v/fwuy8s9coOzOBvHg=
X-Google-Smtp-Source: AGRyM1tl/TWvY5X6POQp8DztZhNFVPMUwXdlL9MF0fV62rMe1Zty8xVz7DztqcWYnmk0vQbSEY9u3w==
X-Received: by 2002:a17:90b:356:b0:1f2:1d4f:3bf0 with SMTP id fh22-20020a17090b035600b001f21d4f3bf0mr4580111pjb.236.1658336148315;
        Wed, 20 Jul 2022 09:55:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a7e0:78fc:9269:215b? ([2620:15c:211:201:a7e0:78fc:9269:215b])
        by smtp.gmail.com with ESMTPSA id f129-20020a625187000000b00525b61fc3f8sm14003375pfb.40.2022.07.20.09.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 09:55:47 -0700 (PDT)
Message-ID: <439b519a-2791-ceea-1f04-55add97bccd0@acm.org>
Date:   Wed, 20 Jul 2022 09:55:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20220715212515.347664-1-bvanassche@acm.org>
 <20220715212515.347664-6-bvanassche@acm.org>
 <DM6PR04MB6575E66298A6E29011FD9958FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575E66298A6E29011FD9958FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/22 04:15, Avri Altman wrote:
>> From: Eric Biggers <ebiggers@google.com>
>> +config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
>> +       bool "Variable size UTP physical region descriptor"
>> +       help
>> +         In the UFSHCI 3.0 standard the Physical Region Descriptor (PRD) is a
>> +         data structure used for transferring data between host and UFS
>> +         device. This data structure describes a single region in physical
>> +         memory. Although the standard requires that this data structure has a
>> +         size of 16 bytes, for some controllers this data structure has a
>> +         different size. Enable this option for UFS controllers that need it.
>
> Then this change should take the form of a quirk, AKA "opts" in exynos_ufs_drv_data.

Hi Avri,

I prefer a new CONFIG variable in combination with the 
ufshcd_set_sg_entry_size() function because:
* Without the new CONFIG variable, the hot path would become slightly 
slower for controllers that comply with the UFSHCI standard.
* I prefer to keep the details of the Exynos Physical Region Descriptor 
in the Exynos driver instead of in the UFSHCI core.

Thanks,

Bart.
