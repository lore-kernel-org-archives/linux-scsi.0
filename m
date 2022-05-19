Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4D4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 08:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiESIDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 04:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiESIDU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 04:03:20 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB9857179
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 01:03:18 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u30so7707353lfm.9
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 01:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h+5XYMbcVG/ukMH+8rM5pkWmGEN5A1VDZBupz3IskQ4=;
        b=ookNFxXo3dqEYboeqhuxEAIDVKM2ggkLyyJZrAXTVDXa5x4KcT3z346tW+efpnrjmX
         S+56zMWLsReakocli3x4AXTS6EqN32Nr2yCmZy03cUO4PcNLp1h6yCHSiA4+YFQ7WMRU
         LICyzxNlOt5FHOVfS3CFn1v/esPjRtQ1eNyKuNk+bg3N84W2THm/XuJ1JDJhpRv/Xh98
         ZFQT/WlNnMoVu4UXqHIARzIW/yx0OUE6MMvP7MhZup2YEdqEjZbW1gHifpJa9qdhmkEs
         HgHgYcV2D6Ona9aCCBBoA/5TAJ5K/8qobzisYfzFzNB5MOKFhRJqh1B5wd9qQcunFkyM
         gY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h+5XYMbcVG/ukMH+8rM5pkWmGEN5A1VDZBupz3IskQ4=;
        b=x6no5QWfoGuskfT5dHVRVxCTpsuJtBFGtLcuKExaDo2dUe8Jitgjv22SjDcZrx7gLu
         cnLU08+d4LHHVe/Yj/FURi+4C5DpaQNYQ2KOEkHLMFm8J0ancT5k7hPCKcVHumcBnuhM
         5W3xbDkotfMPxHF2QlPPzeQMBJvpBn5XTd96Km7FGzCiCQ0xA8w7zfyi0d6x4oiuTlVc
         18HJrGZBHaqW5xew8nDiMvW0PEwIdQb9hPsV5SdQotq1Lhou62LEx6Scy4jqM4c6mlIC
         mFZwHCNIofUxnJuxtICSOmQqWaAEq151h8flWYkIUti5wPHgakcPbQUQ5mpX3icirEls
         tyvQ==
X-Gm-Message-State: AOAM532bMl2hkrfFOmKD/FLFeh8H0uyY9f3AqioWaXxYxjjrbHPEvgji
        Spy3frozVdsuUc7gelGVuQRG+Q==
X-Google-Smtp-Source: ABdhPJzcdAmmROIvWFwwSM91fShqeasCgr925FoWEh4W9HiVHNX3YCiZf/CDs2u8H05VevxjMEcRTA==
X-Received: by 2002:a05:6512:449:b0:477:cb59:9fe5 with SMTP id y9-20020a056512044900b00477cb599fe5mr558965lfk.40.1652947396699;
        Thu, 19 May 2022 01:03:16 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id n14-20020ac242ce000000b0047255d211b8sm195035lfl.231.2022.05.19.01.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 01:03:16 -0700 (PDT)
Message-ID: <65a4c28d-6702-3a9f-f837-1ea69a428777@linaro.org>
Date:   Thu, 19 May 2022 10:03:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v2 4/6] PM: opp: allow control of multiple clocks
Content-Language: en-US
To:     Stephen Boyd <sboyd@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
 <20220411154347.491396-5-krzysztof.kozlowski@linaro.org>
 <20220425072710.v6gwo4gu3aouezg4@vireshk-i7>
 <dea39b1f-0091-2690-7f07-108d07ef9f3c@linaro.org>
 <20220510044053.ykn6ygnbeokhzrsa@vireshk-i7>
 <1e533194-7047-8342-b426-f607fddbfaa3@linaro.org>
 <20220511050643.hd5tcrojb3wkbg7t@vireshk-i7>
 <20220518235708.1A04CC385A9@smtp.kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220518235708.1A04CC385A9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/05/2022 01:57, Stephen Boyd wrote:
> Quoting Viresh Kumar (2022-05-10 22:06:43)
>> On 10-05-22, 15:09, Krzysztof Kozlowski wrote:
>>> On 10/05/2022 06:40, Viresh Kumar wrote:
>>>> IMHO, this is broken by design. I can easily see that someone wants to
>>>> have few variants of all other frequencies for the same frequency of
>>>> the so called "main" clock, i.e. multiple OPPs with same "main" freq
>>>> value.  I don't think we can mark the clocks "main" or otherwise as
>>>> easily for every platform.
>>>>
>>>> Stephen, any inputs on this ?
>>>
>>> In such case, matching opps by frequency would be a quite different API.
>>> The drivers can use now:
>>> https://github.com/krzk/linux/commit/ebc31798494fcc66389ae409dce6d9489c16156a#diff-b6370444c32afa2e55d9b6150f355ba6f4d20c5ed5da5399ea8295d323de8267R1200
>>>
>>> If you assume that this frequency can be used for multiple OPPs, then
>>> the API should be different. Something like:
>>> int dev_pm_opp_set_rate(struct device *dev, unsigned long *target_freqs,
>>>                         size_t num_freqs);
>>
>> At this point I am not looking for a new API, but just continuing the discussion
>> to understand what different hardwares want or look like.
> 
> I think for UFS they don't want a rate API at all. They want to set a
> "clock gear" and that translates into whatever that means for OPP; be it
> a clk frequency (or two), an interconnect bandwidth (or multiple?), and some
> performance state (or many) for any power domains. I think the gear
> design is built into the UFS spec. If it isn't then I'm misremembering
> things.

Yes, true. The clock frequencies are still changed with each gear, but
in general the UFS indeed operates on gear concept.

Best regards,
Krzysztof
