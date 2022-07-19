Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8B2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 22:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGSWoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240338AbiGSWoQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 18:44:16 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01375F103
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 15:44:15 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id q13-20020a17090a304d00b001f1af9a18a2so334387pjl.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 15:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AvbdLtb0n6v+dG5iB0jUCYcxb68bpVsaZAwbJnQM+O0=;
        b=tFwoilycp46bfkmdH7D73fXWPkKWQE5qJF0m08V6aXnnKP/wApBADUsqXpSwbubmZk
         rujOGWa5bqMAT7xnKvgQOCU2203kgUpqIs8y3boUdX+eaqgkV9X8O1gjq5Q9wzrHegtA
         MX7iJfrmsFPONKoDuV0p52yreonMNZ3Hz8KJcJ4YHOwvS82cbr1LAb0+drc/UvOAidYa
         6kpA28d1BuUPi6H9AViijfMYH3t3MYOIupK1xayqFIoEXw2rlFOPWrbtIxS0f53NucPm
         h3ZwBAdbgREvJWjWM9ld4bKydTT67k+C7mtIfrhdrgKjQVLi7nImW7RogrTsxZzbsX6X
         0Wpg==
X-Gm-Message-State: AJIora++tKVfd6JvO5dlxZFYD4i2V5KXJixup8KPP2SK99K/ZH2eij6d
        ywkBJ7NCIhz3ocr80FIPGZk=
X-Google-Smtp-Source: AGRyM1tClh1QJweGLovMBVkpYIdb8nq6V4LeQ2eUzxgN3VjpHW3EWBfrgqt7LO59BV5rmAMnsOcwWQ==
X-Received: by 2002:a17:902:e888:b0:16c:33f7:89cb with SMTP id w8-20020a170902e88800b0016c33f789cbmr36168338plg.2.1658270655295;
        Tue, 19 Jul 2022 15:44:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a7e0:78fc:9269:215b? ([2620:15c:211:201:a7e0:78fc:9269:215b])
        by smtp.gmail.com with ESMTPSA id w1-20020a17090a028100b001f216a9d021sm101204pja.40.2022.07.19.15.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 15:44:14 -0700 (PDT)
Message-ID: <dd412695-218e-2674-a97e-d93961299f0a@acm.org>
Date:   Tue, 19 Jul 2022 15:44:12 -0700
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
>> @@ -9601,6 +9602,7 @@ int ufshcd_alloc_host(struct device *dev, struct
>> ufs_hba **hba_handle)
>>          hba->dev = dev;
>>          hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
>>          hba->nop_out_timeout = NOP_OUT_TIMEOUT;
>> +       ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
>
> Where are you setting this variant for ufs-exynos?
> I would expect here a set_sg_entry_size vop.

The Exynos code used in Pixel 6 phones is available for download from a 
Google server but is not yet upstream unfortunately. This is why no 
ufshcd_set_sg_entry_size() call has been added in the ufs-exynos driver.

>> +#define ufshcd_set_sg_entry_size(hba, sg_entry_size)                   \
>> +       ({ (void)(hba); BUILD_BUG_ON(sg_entry_size != sizeof(struct
>> ufshcd_sg_entry)); })
>
> Why not static inline void?

Because sg_entry_size is used inside BUILD_BUG_ON(). The resulting code 
does not compile if the above macro is changed into a function.

Thanks,

Bart.
