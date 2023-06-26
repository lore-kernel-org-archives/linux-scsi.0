Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AB9EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 08:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjFZI0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjFZI0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 04:26:50 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4AC134
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 01:26:48 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51d884a22e7so2706525a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 01:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687768006; x=1690360006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iCwfCLmGr+YwLKDzpSRDNzcmlKtq/OgxEVAnrCx2V14=;
        b=bARJ0wqgggCOM6GwimVfc/kNML9tkM//5PspEe42+m78LBipSuxJOPeDxrQMP5fzU7
         dpHvjkZSfR8CVevig/zFSh5edVkBpMgQNmyJ70LAk2YdMLKGDUut0LVJKadLk5fJMRsj
         iT4PFlBbZOklS8rGXJj39ca/l+VkUQFwM8c2eDrM+j40o32GYzCOlRPaG3mMlo3n7Dzs
         4od5S/WStUai8GBDieq5J14iGwYhvKjC6s7Gd14guwPEqDFitG9n+kghf9Sbp8hc3px8
         dq1NfZ3hMuRFGVmF1l4IwC6KIN+Ui/7ZB3Lto9s4og6DU+sd8CN7Azd2lbSactKxDk5S
         x76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687768006; x=1690360006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCwfCLmGr+YwLKDzpSRDNzcmlKtq/OgxEVAnrCx2V14=;
        b=G2Zvxq+5RiKt+cMVOHgRIrbzuj5C0kqWIYEmCwR/9rMYfZhyVARL82FgNh/YO9H1OI
         +i7wsDXpa0hz/urH1zZMgvswURB0kS+fQCaDnxhaY5HRMplv0XnNS52TV2/kFznEgvrD
         /t/gf09R6LEKtuZrN9kOsaeR96kZePeKztAF+eWQOKhknMfU9ZPk5yh7WDrg/3lDG13a
         JEq4MdVHTloWKQ4Aiiv4izHpITswPtld7U4ZjrINwudOh70PebuSk2y6xc6lRNxFNSrx
         zxErIBFW7cISnMCsTc/YySyrnm7qgvU1zLy6wYI3RfO/eGHe7mYX1+1rJGqlWsglh4kY
         TXjg==
X-Gm-Message-State: AC+VfDwA0QhM7AaEpszeNhZ9iFhY4RnCihRtmcDCvyHLr3AweUwq6mgA
        +EWsDNUlwfE2YpEXIUANV7/CfQ==
X-Google-Smtp-Source: ACHHUZ7UU+DC+Z1k9XJVFPIvj9lEWS2FcpaiwVL9LdkmYYkT81PuPx4A4Rp3TFEWgKU/agNAqknMaQ==
X-Received: by 2002:aa7:c50b:0:b0:51d:91cc:32e8 with SMTP id o11-20020aa7c50b000000b0051d91cc32e8mr3116922edq.29.1687768006580;
        Mon, 26 Jun 2023 01:26:46 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id s2-20020a056402014200b0051bfc85afaasm2556479edu.86.2023.06.26.01.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 01:26:46 -0700 (PDT)
Message-ID: <c0ce5ce7-d18f-15b9-176e-822d99c638e2@linaro.org>
Date:   Mon, 26 Jun 2023 10:26:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 2/3] dt-bindings: ufs: qcom: Add reg-names property for
 ICE
Content-Language: en-US
To:     Luca Weiss <luca.weiss@fairphone.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
References: <20221209-dt-binding-ufs-v4-0-14ced60f3d1b@fairphone.com>
 <20221209-dt-binding-ufs-v4-2-14ced60f3d1b@fairphone.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221209-dt-binding-ufs-v4-2-14ced60f3d1b@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/06/2023 10:15, Luca Weiss wrote:
> The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add this
> in the bindings so the existing dts can validate successfully.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Iskren Chernev <me@iskren.info>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index eb3de2fde6b0..b5fc686cb3a1 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -80,6 +80,10 @@ properties:
>      minItems: 1
>      maxItems: 2
>  
> +  reg-names:
> +    minItems: 1
> +    maxItems: 2
> +
>    required-opps:
>      maxItems: 1
>  
> @@ -135,6 +139,8 @@ allOf:
>          reg:
>            minItems: 1
>            maxItems: 1
> +        reg-names:
> +          maxItems: 1

I see I reviewed, but I don't think the patch is correct. It allows any
reg-names. I think my advice from v1 was not understood. The names
should be defined in top-level.

Best regards,
Krzysztof

