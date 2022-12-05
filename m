Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6BAC4708C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 11:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiLEL7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 06:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiLEL7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 06:59:14 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3BEE02F
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 03:59:13 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k79so11108494pfd.7
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 03:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JVDnYep+OGuO+Z3tpAIsly50JpE3CrqELGalA8PHONg=;
        b=N5wjABROTlnOf0xkjlrF9DD5NNlAXltNebNeRxy6Iv6U/IFxnXWNcch0ApbhNbuAXl
         aq5kgXkOXdXhCSD/TXtuGnck53j8/j46CwFfsglAkBnlBm2YAVb6ZXcTgUafrPfTKQgB
         7+Xo19wDL124a9m4i+RrLankKSnka65OFqOpGxVwHpl0sPH3U/NyCQFP7kWwfPeH3ykb
         DBjxyYWknWDfL0DlZr2bnBKKx8PVNOBMwAJ1BU6gQWxIgthRQaQjSFJaAknrZCbfI5ck
         I/LtR1ye1+e5jEKWC3Jw6EtnuDFfmfv7Ld0QOH9LYL9jlMTJMcD7uJMo9Xp7UUJHnJ4V
         lFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVDnYep+OGuO+Z3tpAIsly50JpE3CrqELGalA8PHONg=;
        b=g737KZVQaOeSQD5cCSfCXQFtrjzg0WGTkleeC6Ns0VJXbmKU4EeMWYPhdW2gteMpzz
         sZb1V6IfJ0qlkUT0udNdu9xa992kmCoQSv0xgyOUziyuO0SXTNBuGWk6suEyUwO2FNl2
         bJNJ02zkrlBbQ1b08sFM2/Fo3V8kJhckXzpS4ICCrCtF3eRG3yrJJeVinCqFxxXYTfxY
         SfxCebxb7Kzz0CSc57MkrMHGShM4HmiNn3vmzQUZNJUQ4exz9jDZY0J8KpgFRNIkJ9oT
         UxCjOnbj3Gbx1wgTPgtAopIJQmD7XNoVOR0dpy0HghrMKtMXLBs6WusXbeIvlgIYYyd0
         lAGg==
X-Gm-Message-State: ANoB5plR8cZbiHv46T4WoXFTWAhM5KNpPGC2p6SfABSNCgwToilRJiST
        mX8SD4FpQadQWmWjkbd1nukn
X-Google-Smtp-Source: AA0mqf6j5YhyfdVOKSjtKnCH3MyZNtcxxRSjvEhSz/uAs3E8YB7W4Bx982aZrQIQQ3CVU/0VtFH8dA==
X-Received: by 2002:a63:570e:0:b0:477:a381:84d with SMTP id l14-20020a63570e000000b00477a381084dmr53526864pgb.207.1670241553326;
        Mon, 05 Dec 2022 03:59:13 -0800 (PST)
Received: from thinkpad ([59.92.98.136])
        by smtp.gmail.com with ESMTPSA id i28-20020a056a00005c00b005771f5ea2ebsm789766pfk.135.2022.12.05.03.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 03:59:12 -0800 (PST)
Date:   Mon, 5 Dec 2022 17:29:06 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: ufs: qcom: allow 'dma-coherent' property
Message-ID: <20221205115906.GA20192@thinkpad>
References: <20221205100837.29212-1-johan+linaro@kernel.org>
 <20221205100837.29212-2-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221205100837.29212-2-johan+linaro@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2022 at 11:08:36AM +0100, Johan Hovold wrote:
> UFS controllers may be cache coherent and must be marked as such in the
> devicetree to avoid data corruption.
> 
> This is specifically needed on recent Qualcomm platforms like SC8280XP.
> 
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index f2d6298d926c..1f1d286749c0 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -44,6 +44,8 @@ properties:
>      minItems: 8
>      maxItems: 11
>  
> +  dma-coherent: true
> +

This property is not applicable to all SoCs. So setting true here will make it
valid for all.

Thanks,
Mani

>    interconnects:
>      minItems: 2
>      maxItems: 2
> -- 
> 2.37.4
> 

-- 
மணிவண்ணன் சதாசிவம்
