Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2E3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 19:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiKOTEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 14:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiKOTEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 14:04:35 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92B22B271
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 11:04:34 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id c203so3825402pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 11:04:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0WLdYHZdONkk35AqbrTQyyPGr+fc79qhdEbMoCwKslg=;
        b=sLEseCplztUo9em9/fFCSX1bH8AM2fp+pYBfQfU6rEVOKimu7sUIx3bNDLnCVYaNJF
         VRXce9Ods+TuVqrnAjEvnSfJYlIFR431F/39C9FPl68PeUNEyEnNrZOep1h7qAx4atqs
         j9mmFTkk7UURb+wiVM2WU+3j5zPsY04BT66d7f9ppf7fTlu6l0JI3kZAQ43zsYJtS+Dt
         c/Rplk55+NF6PbjO6VDH6K9qoTu59wbHOB2KKRl0oOSrRjCn/jjNZUd4ormYT6ErUpxA
         0o/G944aiw5KYjNCl9cOHZYd085HKsRiCbID/YG3/I92BRVOWV0BDQnJ4iTTZ5SXJKlW
         v2Mg==
X-Gm-Message-State: ANoB5pnW5qgQbGiXrT9IDfVBKNBX5lxi2vwefOjL+0usQPAgJw3A8UIx
        oF71NivbbwHloEAL1l0OIAA=
X-Google-Smtp-Source: AA0mqf4qZbkirLHMECczMmrBax90Lv2dhnFa0vXdQvXRtGONb15psRqSLT9DWDfpS3SR1TfecO8KLw==
X-Received: by 2002:a62:17d8:0:b0:572:149c:e278 with SMTP id 207-20020a6217d8000000b00572149ce278mr10758815pfx.8.1668539074239;
        Tue, 15 Nov 2022 11:04:34 -0800 (PST)
Received: from ?IPV6:2620:0:1000:2514:e7a1:7837:d0eb:e4c8? ([2620:0:1000:2514:e7a1:7837:d0eb:e4c8])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a1d4b00b00212735c8898sm11910915pju.30.2022.11.15.11.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 11:04:33 -0800 (PST)
Message-ID: <9ac9800e-c506-133a-e676-99a53a223459@acm.org>
Date:   Tue, 15 Nov 2022 11:04:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
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
 <20221108233339.412808-6-bvanassche@acm.org> <Y2uechJH/4GFDs8h@infradead.org>
 <e343400f-2c87-8abf-5ebc-9c9a4a9030d4@acm.org>
 <Y3NETRqATLK2Z6LZ@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y3NETRqATLK2Z6LZ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 23:48, Christoph Hellwig wrote:
> On Wed, Nov 09, 2022 at 09:29:47AM -0800, Bart Van Assche wrote:
>> I'm not sure how to interpret your reply. Anyway, this patch is required to
>> use the encryption functionality of the UFS Exynos controller. The
>> "vendor-specific fields" text in the patch description refers to the
>> encryption fields since these follow the data buffer when using the Exynos
>> controller. Although it makes me unhappy that the UFS Exynos controller is
>> not compliant with the UFS specification, since it is being used widely I
>> think we need support for this controller in the upstream kernel.
> 
> The fact that in UFS no one sticks to the standard, and not one but
> us in the kernel being more strict and your employer sticking to that
> can fix it.

The above statement is too strong. The Exynos controller is the least 
compliant controller I'm aware of. Future Google Pixel devices will use 
a UFS controller that is compliant with the UFSHCI standard. 
Additionally, the Exynos UFS controller also occurs in devices produced 
by other companies than my employer.

> But that's not the point here - the point is that such fields are
> always implementation specific and never vendor specific.  Any
> particular vendor can, and often does, have various different
> implementation specific derivations from or extensions to a spec.
> 
> Just like there is no 'vendor' driver as there are plenty different
> drivers for the same device class from the same manufacturer.

Do you perhaps want me to change what Eric Biggers suggested into 
something more generic? I'm referring to the following suggestion from Eric:

config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
	bool
	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO

Thanks,

Bart.
