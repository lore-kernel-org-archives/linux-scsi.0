Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B42C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 15:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357056AbiDLPYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 11:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357053AbiDLPXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 11:23:49 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EF01CB0C
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 08:21:29 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-de3ca1efbaso21092368fac.9
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qu3x8sdL450TLQDqbPVZSB+mpayh/+CyyZ7ypbjcaSU=;
        b=r6cizZbLbT+19O9rXJANpT82cGCsvqn2fYt+NJUHZ8fWAx5bqrlJO1ag9v+NDtvUQF
         dgcyRF7V4pQ6a7huSydcAB2zpQZk8DNUK/w6mGMoFUUeotYHOYeGBOucp9BP+KopXz7r
         O2xrj9ulrpRv7XGAdFDjVmdcUgtCQQcxy92strzrfd68YVAGjofGmylhBoURLQjuD1D/
         K7QretzqMAeumMbaAmOMG+age3q4DNJBSPh2Bu6J5lH3ChfrXR4DOZ+++4Pe2na04YJH
         dBjXX23PBn5/Kn3szYQOVTT+nCDJDBhpcIY4LO/cj9sRSW2GeCTIVQK95Qb2s8YHhm4i
         7Tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qu3x8sdL450TLQDqbPVZSB+mpayh/+CyyZ7ypbjcaSU=;
        b=emAlnlw8mNfFvoGl79cea8YqZGTzs1Qrre/SSqKRgB0BUOrgycKQMShmiv94qqzZJ1
         VnL883RHj1bjx9aYZlMj7V8q+J7FcH+LfFruVS7f8sgJbL4UCnhBE45M70y5bvDXXGLg
         mfllcc2LGKEqDD7vq7PrSfiK8rDttQB4EChg/qQjCocjGv3wXyjQdA6KzqsscZn4R1qd
         0paOXc4NJTTLHVRf0OylKTKV7zJDwXhBF79BcVshS6RNn3nKKWGriC9KvY19sJdIu/WP
         yiTd5vIdQLIMquTeSqMFY/4bYgHHGAN+yaBlmmjByzW8aIPGqyCSToQ0trbk35CUIjiX
         mlBg==
X-Gm-Message-State: AOAM530dVIBUc8U0RHlC2Ff024L+EtiGKlgzCdYuxdGPmO727oYEW/jL
        f6f5FY6JZGd+HBkQHc+d1BoBWA==
X-Google-Smtp-Source: ABdhPJwSMU6rLdoiFiE1YWIqEnAgFX38AXPmGE4lImEOYvnaGOANJ32c//Fqg3miUjWLSjDcu6Zvjw==
X-Received: by 2002:a05:6870:e893:b0:e2:ecbc:e581 with SMTP id q19-20020a056870e89300b000e2ecbce581mr2203328oan.193.1649776888814;
        Tue, 12 Apr 2022 08:21:28 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id n6-20020a9d6f06000000b005b266e43c92sm13460871otq.73.2022.04.12.08.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:21:27 -0700 (PDT)
Date:   Tue, 12 Apr 2022 08:23:42 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
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
Subject: Re: [RFC PATCH v2 2/6] dt-bindings: opp: accept array of frequencies
Message-ID: <YlWZfioKrHO9tqQv@ripper>
References: <20220411154347.491396-1-krzysztof.kozlowski@linaro.org>
 <20220411154347.491396-3-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411154347.491396-3-krzysztof.kozlowski@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon 11 Apr 08:43 PDT 2022, Krzysztof Kozlowski wrote:

> Devices might need to control several clocks when scaling the frequency
> and voltage.  Allow passing array of clock frequencies, similarly to the
> voltages.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
>  Documentation/devicetree/bindings/opp/opp-v2-base.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
> index 76c8acd981b3..1d7216008f95 100644
> --- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
> +++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
> @@ -50,6 +50,14 @@ patternProperties:
>            property to uniquely identify the OPP nodes exists. Devices like power
>            domains must have another (implementation dependent) property.
>  
> +          This can be also an array of frequencies for each clock provided to the
> +          device.  In such case value of 0 means the clock frequency should not
> +          be configured for given clock.
> +        minItems: 1
> +        maxItems: 16
> +        items:
> +          maxItems: 1
> +
>        opp-microvolt:
>          description: |
>            Voltage for the OPP
> -- 
> 2.32.0
> 
