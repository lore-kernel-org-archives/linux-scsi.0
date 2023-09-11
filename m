Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0814BEE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbjIKG1o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjIKG1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:27:42 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AA1F5
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 23:27:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-401ec23be82so45344575e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 23:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694413655; x=1695018455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RJTJsFK3T0/Rm5w8uJvF7R9ahpNsdXBenI0aBQZljWI=;
        b=rounOXkfgIZsC7NkU4+jT+m5JD86820sfpExxOV1KSiPKJlRzc7IwKUk/tBvbcw5EY
         giLs9dV67Bp6yj6m/WnrEmSZ9DDJc/HuTF7xVoqeUtcO2MyPnQfNuU/cusM7j1Kgc5PN
         g/DxBMED7De/96bncj7UkyTmDdEL5scsnFtDY94XLLdMuxMWJeraBiJOavs40I1XxSsl
         J124lf19yYH+9Q5/gI+6lNQu1bxJEzQ4YLeZFQaECakijfHi8+tMGAUWXn6HXOE5K0k1
         jImOeUDt+qlQyri5authxf6sx0/JoIp+lxVKKQRyAoYXY3VqhzUAb4oRx29dQAdc8Qzx
         U0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694413655; x=1695018455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJTJsFK3T0/Rm5w8uJvF7R9ahpNsdXBenI0aBQZljWI=;
        b=tJwX5LaodXikG8dyqt8uydw9Noiwe319MQUMduLxFowgOTd5vN18V9/ENuscXvkFTf
         gP/ES/u8Zqt9HdO1CVpVyhSxpgqwX1L9uVuDPL+E/eNw9VjnBbeKOSJ5tsrLxvfpbZnW
         y403T97IhirmPYeUlLkl+u3J4J3IwzmrWmDdP/nyVal2+seDGPai6kFdNoMjucs2WkBP
         jeRocWaizZaxmW/TW2/BlrpYVXfr9zLrsRvQo1zJezV563btzyA1brBjgEsSFkCHna2B
         0K4jtNGPtufCswonzoVO7/oP2WUJgWOGCw09gUaNtpDVHq+r9ogRhJBmZ69N6PFGV+Gd
         FRdQ==
X-Gm-Message-State: AOJu0YwYQd1wPneu9BzG3VESC9T6Z3t9Xjlpzs0B8O2/JMXaJU4ySGGX
        ece9U85kBeHMyHj2GvlOkyKwhQ==
X-Google-Smtp-Source: AGHT+IHdUYdZOEzSeRxYewp5a8kC9KI+sz7pgbVDMTSbrYiymqBDmQF9SeR7P0v4wf06XCXdnmaRsA==
X-Received: by 2002:a5d:4e02:0:b0:317:5f04:bc00 with SMTP id p2-20020a5d4e02000000b003175f04bc00mr6273595wrt.27.1694413655449;
        Sun, 10 Sep 2023 23:27:35 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.214.188])
        by smtp.gmail.com with ESMTPSA id a11-20020aa7d74b000000b0052a404e5929sm4095585eds.66.2023.09.10.23.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Sep 2023 23:27:34 -0700 (PDT)
Message-ID: <0231fa19-bc71-db11-ffd4-8c922d110447@linaro.org>
Date:   Mon, 11 Sep 2023 08:27:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] scsi: ufs: qcom: dt-bindings: Add MCQ ESI property
Content-Language: en-US
To:     Ziqi Chen <quic_ziqichen@quicinc.com>, quic_asutoshd@quicinc.com,
        quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        adrian.hunter@intel.com, beanhuo@micron.com, avri.altman@wdc.com,
        junwoo80.lee@samsung.com, martin.petersen@oracle.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com
Cc:     linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1694163203-39123-1-git-send-email-quic_ziqichen@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1694163203-39123-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/09/2023 10:53, Ziqi Chen wrote:
> Document the description for the qcom,esi-affinity-mask.

This tells me nothing what is this feature for.

> 
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index bdfa86a..323595f 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -97,6 +97,10 @@ properties:
>      description:
>        GPIO connected to the RESET pin of the UFS memory device.
>  
> +  qcom,esi-affinity-mask:

Not tested. You also miss proper type.

> +    description:
> +       UFS MCQ ESI affinity mask. Affine ESI on registration according to this CPU mask.

And why is this a property of DT? Aren't you now describing driver?



Best regards,
Krzysztof

