Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947ADC6379F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 14:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjASOnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 09:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjASOmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 09:42:35 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689A8875B8
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 06:40:37 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id v6so6211408ejg.6
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 06:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YA4pZyF7V/PvrW6YJCArLXIcNJ4ekuR5YzULeYjw5uw=;
        b=nA8KSlwwS3q3WcSsSIr363cX8fWLTe3nXhczH592sOgcVlsHTSUzGlgcC7YFGOZamN
         xCTCtpMfpir9EfZr9HkmS5Nh3OR4EwBeAS0r8A9dadgP3JuSvmcKX5WpI7BMvqJ3JKlU
         yg9/9t+42YsMFDz/LA6f5lQBRACzpepsnVRQXZthhD6Ufk/SBeMbB+UO/WP5wW91VCQM
         UqgGDoW4Qwhk++mmBKMJak3VXKOaIrBEWe3hYHOSQOkSMKNFHK7/UscGywznKuZYk/0y
         MhtvFwdzA98if1kvCmq7KP15Q1DYlUsEB4T2UuZwOxlTXX9u2WKp3IWbY2vS+WJefV1i
         EF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA4pZyF7V/PvrW6YJCArLXIcNJ4ekuR5YzULeYjw5uw=;
        b=7vEtaryHTImNlEVatNo1+hhTQ3QkwaAzQ/BTrhPPzqQTn+tAZh/Rsx2vPvDBTJE+uU
         z7dmUMXtBWlX/hXMjjcN+5gY5ddChYLAPUbzn0U0oDeLfk8Qa5QM0J1CCu6sXRYoulHs
         wjRsPYb3M/tm9QBuVCkYHVZDiY6UQe3kNdM/iQdcRsaOdsAbuPCyPiSltQDNXUtT+bwt
         5/O8YZg59oJ3vwfun2kWtB6NudjQh0kQNTTVyS0ur1//dNOq8KcmvCQ7WoETWeqzlSTg
         a0M7YCEdYd9OYoQurLoQWI6sbQQGky1cKeTrjj6Rsh58+q1B5KzIG6LFmkYK3ubcbgf+
         IGZw==
X-Gm-Message-State: AFqh2koxVujSJhuyTmwuOHz5j0FBNDYCJ0DoEfrX3Y/whPfnXobJt/AE
        XWuzDri+u14VHYZu8vVnHPkgRw==
X-Google-Smtp-Source: AMrXdXt+NJICZX+Mrucdw/D7Ei1CdvvOHslUw1VwxG1ensMJZbWrlIcCwB0DB92smedOcB+hm0tfPA==
X-Received: by 2002:a17:907:6e2a:b0:871:e9a0:eba7 with SMTP id sd42-20020a1709076e2a00b00871e9a0eba7mr15097175ejc.57.1674139235940;
        Thu, 19 Jan 2023 06:40:35 -0800 (PST)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id lb19-20020a170907785300b0084d1efe9af6sm16277962ejc.58.2023.01.19.06.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 06:40:35 -0800 (PST)
Message-ID: <3827d6e3-d9cb-7001-eb3d-c7fb2466263f@linaro.org>
Date:   Thu, 19 Jan 2023 16:40:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 0/2] qcom: add basic interconnect support to UFS
Content-Language: en-GB
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Brian Masney <bmasney@redhat.com>, andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20221117104957.254648-1-bmasney@redhat.com>
 <ebd7e9f1-da9b-253d-0053-2327fd86e7f1@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <ebd7e9f1-da9b-253d-0053-2327fd86e7f1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/11/2022 13:12, Krzysztof Kozlowski wrote:
> On 17/11/2022 11:49, Brian Masney wrote:
>> This patch set adds very basic support for the interconnect framework
>> to the Qualcomm portion of the UFS framework since the firmware on
>> these platforms expects the interconnect votes to be present. The
>> maximum throughput is requested to match what's already done in a few
>> other drivers.
>>
>> Here's the relevant entries from the interconnect_summary file in
>> debugfs that shows the two ICC paths are setup for the first UFS
>> host controller on the SA8540p automotive board (sc8280xp).
> 
> I wonder whether this is solving the same or orthogonal problem as my
> old patchset here:
> 
> https://lore.kernel.org/all/20220513061347.46480-1-krzysztof.kozlowski@linaro.org/

More or less it does. Vendor kernel scales both paths according to the 
gear selected. I was surprised to see just two entries there. sdm845 has 
22 entries in its msm-bus scaling table. What was the reason for just 
two entries in your case?

What was the net result for that patchset? Is it going to be merged 
anytime?

I think we can start with just a version of this patchset that enables 
static ICC config and then upgrade that with proper OPP tables, WDYT?

(I wrote 'a version' since I had to modify the patch to set avg_bw 
instead of setting the peak_bw and to pass different values instead of 
UINT_MAX, I'll send it).

-- 
With best wishes
Dmitry

