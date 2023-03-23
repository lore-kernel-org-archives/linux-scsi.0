Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3338AC6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Mar 2023 10:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCWKug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Mar 2023 06:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCWKuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2023 06:50:06 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8071CF4D
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:49:16 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i5so37608549eda.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2023 03:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679568555;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jdmMkNYxmngZXiNYiht2ilt6fUvVv06Iyevz/3gM66w=;
        b=knL6YRcg5zsmePbOUt885QbvljOR9/ZH2VAfHYCS9NPtcEA99FIDn2aGyVoKH45TDP
         kY4TGvy1bFecBjHRiAzkZqafAk48jM42rPImDiVazQJ1K4uPnxp2X3H7l8YDR3vrKiaG
         bAhM3d45FMUaRUrZC/m5sz7RaK9Qq7EF0ndRb90gi0nndmoIde+euM2opzWTF0AVBNzf
         a6Kz7mgcLQzsLr5usmDkLqwLp8e2IO1FKBVUFCOSaq4hBEHR3RjyptFflQ7DOr7ctz1q
         6/+HA/yeiJUsx+d7tW+lmhylYdCBCGLRQI8MBYWB/0ecazdd0cphn8d2J3Jc2ePY4AAt
         uFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679568555;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdmMkNYxmngZXiNYiht2ilt6fUvVv06Iyevz/3gM66w=;
        b=rDM46DdgQg4h4fgzb1iUdMzwpGfqNaoPBXS1hqqh+T11/EBT1FURv16fHmaMmLIJZe
         mN/26+giHIVLg5g22rNF70tu1SMrFt1BQaYZN/V/RckxCxBQilKnMcmKqRlwjfwlplnX
         Zfoj173b5gaTg8jKNT4gTI+QLzHqQ8iMg0KpCeYTvLjzBUTQu618rJNUlQkTjD2z2/fB
         mAWO6/SExjYb0mdW+SzRBpGC4MQaWjud4d6T3f0eu5O61fgvEQGqn4mAHON8waJPB5jz
         HUXJUQy/c3R3G94ymOfxIdw8P1++L0szySW+WC99ARA98iIvN4l/t6k2oI/BYZwmTrGq
         V2lQ==
X-Gm-Message-State: AO0yUKUL/pCwQ0GPSUH7bPxbaVukoBHm8L9yKCRlQUsLmvNPxjfeTElo
        yixFMFMyiHn3S3dSZ7jdoPY7iw==
X-Google-Smtp-Source: AK7set+NsAafWsPdCnhOJpdiMsM9t3ZFahPLZkyds6zcH6FQTKUdAj8NfgayvaoFiyTcm1PQimdckg==
X-Received: by 2002:a05:6402:64e:b0:4fc:709f:7abd with SMTP id u14-20020a056402064e00b004fc709f7abdmr9636033edx.2.1679568554775;
        Thu, 23 Mar 2023 03:49:14 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:a665:ed1e:3966:c991? ([2a02:810d:15c0:828:a665:ed1e:3966:c991])
        by smtp.gmail.com with ESMTPSA id v4-20020a509544000000b004fb402a2a37sm9079721eda.33.2023.03.23.03.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 03:49:14 -0700 (PDT)
Message-ID: <9614782e-0d78-e8f2-a438-452cfa86f80b@linaro.org>
Date:   Thu, 23 Mar 2023 11:49:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 7/8] arm64: dts: qcom: sm8450: remove invalid reg-names
 from ufs node
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
 <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-7-3ead1e418fe4@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230323-topic-sm8450-upstream-dt-bindings-fixes-v1-7-3ead1e418fe4@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/03/2023 11:25, Neil Armstrong wrote:
> Fixes the following DT bindings check error:
> ufshc@1d84000: Unevaluated properties are not allowed ('reg-names' was unexpected)
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8450.dtsi | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> index ef9bae2e6acc..8ecc48c7c5ef 100644
> --- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> @@ -3996,7 +3996,6 @@ ufs_mem_hc: ufshc@1d84000 {
>  				     "jedec,ufs-2.0";
>  			reg = <0 0x01d84000 0 0x3000>,
>  			      <0 0x01d88000 0 0x8000>;
> -			reg-names = "std", "ice";

This is also part of:
https://lore.kernel.org/linux-arm-msm/20230308155838.1094920-8-abel.vesa@linaro.org/#Z31arch:arm64:boot:dts:qcom:sm8450.dtsi
but I actually wonder whether you just missed some binding patch?

Best regards,
Krzysztof

