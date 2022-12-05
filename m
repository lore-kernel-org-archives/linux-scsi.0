Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7FAC4708C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 11:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiLELhL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 06:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLELhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 06:37:09 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B34F1A056
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 03:37:08 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vp12so27058269ejc.8
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 03:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYONg2TQ0L+lF1d2DaA1qurYIm2vbfwZznXqOxGFnmA=;
        b=c6r33dyZUaRAYBqp/c+s1bzmydiZw5C/25gSmwq1LrhxlFMOfo3mmIL+0QbPQwYSFG
         kqpWcZtwGiQn0fFTjXFC/50jtt2pUTslqjMFR5hAEFnbg4I2sJloV4Lp0jldsCg+j58p
         Xrwz1c/VFjPeiRiN73DZPWNwdGyYocY6rhjsX8DodU8ePNeITAY6IrEHzdwzXvqfi5DP
         uv7tBzYvRNuVi+TxAIDkGH0eWKBYQzKSKN5Sqi5jlp/DtnrNpHk9IGzCXLzbGJRTmYCo
         aUzkeTl0Gtf4rHd8T0xO3ZIwEFltRyy18adXMsvjtWVRZX64d3BX7ydvsMFpWsZeFkrq
         jVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cYONg2TQ0L+lF1d2DaA1qurYIm2vbfwZznXqOxGFnmA=;
        b=wVRdQzYTT1tEa3G/G2ZV+WguLcclfq0azCkl3W97DyygD6xJV+y0lKqb9ASPW4CQ5T
         n5iqeKcKEPoDl7x/Oq6PazX8/kliHnCvSRwtz03yh4JbIDISE/oi6YYxU6Yd6dyKQFvX
         fzckTF6lzLei1M7QdM5sinPFsLSkfqO871Pcy5lS+6z5x2IKoDOjy9eIh0Tbeomvb9vS
         QoyKFaSZ92jZiNTtz5DIrNR+HuIH8Lzddj1uHDxIjyESeDhxWeEeUHqyv2/5ZW3wk7C6
         haYmVUsR7jul9BtyhyM2lbmDvEmGaF5CKIQ7M75brDCwqpd6DHIOT5wEIYeeZ8Y3d+Dm
         4QvQ==
X-Gm-Message-State: ANoB5pkOPt2K5tE9SElZBXWjrBD/uUsIv6FZNiGXNfdPsSa1kfKnAiJ1
        V6Re2JYTQV/OGPFlTuuTic9ddQ==
X-Google-Smtp-Source: AA0mqf4aKgFODxGCPta1Nv/wxBzu3tePNi5o9NMN2dx34jz14blVeWDZMfQ/sArMoICgz3V9zSWnpQ==
X-Received: by 2002:a17:907:9842:b0:7b9:9492:b3f4 with SMTP id jj2-20020a170907984200b007b99492b3f4mr47621577ejc.688.1670240227134;
        Mon, 05 Dec 2022 03:37:07 -0800 (PST)
Received: from [192.168.31.208] ([194.29.137.22])
        by smtp.gmail.com with ESMTPSA id ca24-20020a170906a3d800b007abafe43c3bsm6140594ejb.86.2022.12.05.03.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:37:06 -0800 (PST)
Message-ID: <61f2c58a-9ca8-3868-e3e0-31283e8b1728@linaro.org>
Date:   Mon, 5 Dec 2022 12:37:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sc8280xp: fix UFS DMA coherency
To:     Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221205100837.29212-1-johan+linaro@kernel.org>
 <20221205100837.29212-3-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20221205100837.29212-3-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 05/12/2022 11:08, Johan Hovold wrote:
> The SC8280XP UFS controllers are cache coherent and must be marked as
> such in the devicetree to avoid potential data corruption.
> 
> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> Cc: stable@vger.kernel.org      # 6.0
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>   arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index c4947c563099..23d1f51527aa 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -1430,6 +1430,7 @@ ufs_mem_hc: ufs@1d84000 {
>   			required-opps = <&rpmhpd_opp_nom>;
>   
>   			iommus = <&apps_smmu 0xe0 0x0>;
> +			dma-coherent;
>   
>   			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>   				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> @@ -1491,6 +1492,7 @@ ufs_card_hc: ufs@1da4000 {
>   			power-domains = <&gcc UFS_CARD_GDSC>;
>   
>   			iommus = <&apps_smmu 0x4a0 0x0>;
> +			dma-coherent;
>   
>   			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
>   				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
