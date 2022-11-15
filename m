Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BD1C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 19:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKOTgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 14:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiKOTg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 14:36:29 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E48A19D
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 11:36:29 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id 130so15011650pfu.8
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 11:36:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MczfrwpMbhM2GnZ3LNIXRp27QI+ffBu8Q5rC+NPvpcI=;
        b=yPbS6dgdv8cCDIB2BfVRFJLfLhDpwQpIsQr1JMeMwD36TaqOGNe+DRTYOm52gNSluL
         Rp55sZiMKZkEFLlXugOHuq0mJ2+SSCb5cVAUyddteh7A/mSfY7o7MG8wtas10vsUJCdI
         tYA3H3Ijv1nbgjGampEG7Zwuhbz4Dod2LSbCHcMQGOwqzHFUI8xkGPKysSCtcNfIgZlv
         wT/CnCSltz7roJkjOSl1bxcde2T0M2W3Sziv4e9xU9KM7CBuoSZBP7G3Y66droADeE7J
         DB1yoqcWOgBITb8l6OFOPrJwnDGUMNfsFUGO2d4a7W1v1yXAnrOVjhhUj9ykjNYvpc9s
         uFPQ==
X-Gm-Message-State: ANoB5pn+xkRQAnPhtj9m34dB5xkwKcTK1Y3r6ibTWqh7Q5zqRiO6TvD6
        NkIw3+ta9F1C/G1Mp02/1a4=
X-Google-Smtp-Source: AA0mqf6nxuDwGP4yKjcNPotF3kHr3HmVz2UCyEoQKJuUC8ff0XvZ0htWZ7rUDZlLQwHwzV/uUxcpGg==
X-Received: by 2002:a63:f94d:0:b0:46f:fe3e:3ebe with SMTP id q13-20020a63f94d000000b0046ffe3e3ebemr17331809pgk.518.1668540988542;
        Tue, 15 Nov 2022 11:36:28 -0800 (PST)
Received: from ?IPV6:2620:0:1000:2514:e7a1:7837:d0eb:e4c8? ([2620:0:1000:2514:e7a1:7837:d0eb:e4c8])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902e88500b00177f82f0789sm10395046plg.198.2022.11.15.11.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 11:36:27 -0800 (PST)
Message-ID: <254a89ff-77b6-8e1a-a31b-4f5ecbc59520@acm.org>
Date:   Tue, 15 Nov 2022 11:36:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
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
 <DM6PR04MB657558167A98D2E9C0D63C57FC049@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657558167A98D2E9C0D63C57FC049@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/22 00:56, Avri Altman wrote:
> It is usually acceptable to temporarily use quirks while the hw get fixed.

The behavior supported by this patch is not a hardware bug - my 
understanding is that it is behavior that has been chosen on purpose by 
the Exynos design team.

I can convert this patch such that it uses a "quirk" flag instead of a 
kernel config option to enable support for Exynos encryption. However, 
doing that will add runtime overhead in the hot path for all UFS 
vendors, including those that are compliant with the UFSHCI 
specification. Is everyone OK with this?

Thanks,

Bart.

