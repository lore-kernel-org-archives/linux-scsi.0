Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415FBC6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 10:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjCWKtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 06:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjCWKsy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 06:48:54 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB6A1E2A2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:47:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x3so84445319edb.10
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679568442;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZwBaazd46Os1h8UWb3mzhS3tM1p34VAmXxtP/Asef4g=;
        b=Dtslf0444+9v58G4yE+r0N4jTKSFCxfgxadg83fFpxNHJ4ac4nlxy0bFQDZh3eNAKB
         6WssITCbUrDgO1As33oV9qKLdQbyrHIJ2/gRtUdUK8XNctG/tWxxNfnYwi9XdL67Rwz2
         jN5zgGK5gewqPRnTYvHYAntqZ1Mrs6KMySeUgtH1R0O51kUmgjC5iviB4XcBg1oXkJ4C
         wsPdAy3FmmaFAuFdsxIiH2CG84/CHpAs1LMRnB5QWHwBtoXNosOoPlLukKgM+rmy+rJ4
         VrJPlkZfxEfp7h9c067CxWlfsxIXgtjVtA8ANFGhrqOP7GyVkLgwoh2y61aQiFLP4vgB
         YbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679568442;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwBaazd46Os1h8UWb3mzhS3tM1p34VAmXxtP/Asef4g=;
        b=lBTFcFvgUQO8XxCuzZPBegD8fjn+YDBIDgcZgtavsh0+0WzFlnVOkYlTI/PRJrbBHq
         DC1PPRgjU2roX8T/qx97KLA5ri4wZl6NkI4jsXrqXbbQtkpFhhndN+zbtEiOsqJpa83g
         1nYPZcqoQp2+OsNl6TpwEJ+AkH61eHMfrLGRn1O6x5nA/iyKNhCriiT2j2gtWi86C2Dx
         4cBAbrn6k3CZg/4L4rqMsyh21Gn1a7zCgpfFwKfav8dizA41KDLWQ1mUkbLzrP4K38DJ
         cPK3TS200XFZZRJsDXVnVCVPEW7dIy4KqBEV7nJZiTAbl/Cw3ExD7jtnB4b+qQuVsMLk
         1cZg==
X-Gm-Message-State: AO0yUKXe6Zn/VbmUsXvjpBN6fdGkI5E5XqLD0W5opHJHtiRXKp+p5WEI
        d6iFSdsl++SgVx4k+lI5YMgshg==
X-Google-Smtp-Source: AK7set+syZHTlqpATJV5H45QwNgqlRP+3WJYWaGjq6Y6tMtvCBdNqC47gy0P9OOBSjJ/vCiMdvKECQ==
X-Received: by 2002:a17:906:9457:b0:930:a74:52bb with SMTP id z23-20020a170906945700b009300a7452bbmr5414585ejx.14.1679568442296;
        Thu, 23 Mar 2023 03:47:22 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:a665:ed1e:3966:c991? ([2a02:810d:15c0:828:a665:ed1e:3966:c991])
        by smtp.gmail.com with ESMTPSA id q18-20020a170906b29200b008c607dd7cefsm8484887ejz.79.2023.03.23.03.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 03:47:21 -0700 (PDT)
Message-ID: <35e3aa8b-ccff-25fa-42da-d8934ef366c6@linaro.org>
Date:   Thu, 23 Mar 2023 11:47:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6/8] arm64: dts: qcom: sm8450: remove invalid npl clock in
 vamacro node
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Lee Jones <lee@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-scsi@vger.kernel.org
References: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-0-3ead1e418fe4@linaro.org>
 <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-6-3ead1e418fe4@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-6-3ead1e418fe4@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/03/2023 11:25, Neil Armstrong wrote:
> Fixes the following DT bindings check error:
> codec@33f0000: clocks: [[137, 57, 1], [137, 102, 1], [137, 103, 1], [137, 70, 1]] is too long
> codec@33f0000: clock-names: 'oneOf' conditional failed, one must be fixed:
> 	        ['mclk', 'macro', 'dcodec', 'npl'] is too long
> 
> The implementation was checked and this npl clock isn't used for the VA macro.
> 

This does not look correct. DTS looks good, you miss some patches in
your tree.

Best regards,
Krzysztof

