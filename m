Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E51553805
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2024 08:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706516288; cv=none; b=CrVA/dqZ4msnWxwEbFvUzSX7Xw1jTM+eX83O6QWOfO/4gIcGqGCn9/1snuPdaL9LRDABJij7/bUbgqtzIzE1tQIQj6fJC8I3czQh0qOAmN+21unw7+PnvZDA23XQWYfrGFALTlitLB9gFyshPHANBYWU6vbRMTNH/7q0eqs3iP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706516288; c=relaxed/simple;
	bh=DFhSGuCmZAkqN5OgeWTFC41PjQCD7zNvSO+dCZlSKkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PCd8EL8Z+k0p9GSbi40K25H16gkP+E9vk1rkw79/bRpxBOfU37VZGg2NhU/yfybAIlJK3Tngesb1xroIfRPwJg0WjBjIyZXANP5HK9PkNbSR1hZjojbZXjIx6Optp4V2xWmUFwlabr60STP7NJEiq9ZOs7KYaVrwJqXX8QBkDkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bedTiy6S; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bedTiy6S"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a35b32bd055so72183166b.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2024 00:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706516285; x=1707121085; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5tK2QNFGt5/XkKFTt6LBQTu5SmY4cQAXJ0hKxiAOAbM=;
        b=bedTiy6SUDmlOh//MFL/i6fvLnMo2FBDOaYeO9f1xXcXAvBKwjySmHNX3kEH+4fnxx
         Vm8M/qX6eCXZZvKcL67CXJRLUHJLgi4vnKbUkNwJJ7R7eNkt+Yd3MIJAn1t/cOMHHE1F
         II9yetM2tp1BBaqB8p8D7IaLAXZTfcRuCGD3PkC5NJRgwvLrnVDwJ4j8VQQVD4L+WOaV
         9MYjTkwso1SFohb5TRgy0YNZV4pXdMOtCHjRd9kZgMSokxCJPCw+3h4sl20SG0a5K5J8
         RYDPW1a9avaJkuV8290Ui36HbsWpg4K6CH9lLhDyM0Gdfv20q/epxmmlB/z7LMcTyP2o
         QgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706516285; x=1707121085;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5tK2QNFGt5/XkKFTt6LBQTu5SmY4cQAXJ0hKxiAOAbM=;
        b=Z/x4Gfw1n3iZqvAzaCFU+7B188VjW6oOfetTZ4j85jtyosUMPWwpGRXM9FRsYbaXEL
         ns7igN1wMDkQjWlZehBC25cDazhCg/auu4zXDf3JdoGvhfmJZn8Q77RwiH8RFypirTvr
         nFmSiLiFriuFEO25ZbI04//7qGuw6P8IXG7Lo40yhA86cWlF5MxBmsOpP23c4zIzY6Wg
         /p0p2AyhKrcpO/9qBh+T3gnPnrqHbG0BmBGvqOs6W641Skq5+t7QXpUK8CKq2UA/axzt
         n0heCwEtInD+HdUUDB0eOxl8dpITKWPZLIniPSY7bVbLPBujERt1JqAhz8do8NP9s5Wp
         szrw==
X-Gm-Message-State: AOJu0YyK6WBFaa28F5NdVrszX7kPnjeR963E2NLUrOE8UxUd+ymfXqEH
	Fs9D9/19JboSnDa3bv/8o5bydb+rXy7YKfBaYRBTYIygJHCLl4hqBiMA9rM51tg=
X-Google-Smtp-Source: AGHT+IFgv6GsTPAfga862MCO8eyMKgW9fA+kGsyRxEMN4HkTywCg1Zi/ZUj4cMV5UbJLlAbH1y37XQ==
X-Received: by 2002:a17:906:f9c3:b0:a31:f7e:8a53 with SMTP id lj3-20020a170906f9c300b00a310f7e8a53mr4004848ejb.26.1706516284783;
        Mon, 29 Jan 2024 00:18:04 -0800 (PST)
Received: from [192.168.1.20] ([178.197.222.62])
        by smtp.gmail.com with ESMTPSA id gu24-20020a170906f29800b00a35b99df4a6sm777687ejb.38.2024.01.29.00.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 00:18:04 -0800 (PST)
Message-ID: <301be6d8-b105-4bba-a154-9caebc8013e3@linaro.org>
Date: Mon, 29 Jan 2024 09:18:02 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/15] dt-bindings: crypto: ice: document the hwkm
 property
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org,
 srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
 kernel@quicinc.com, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, quic_omprsing@quicinc.com,
 quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org,
 konrad.dybcio@linaro.org, ulf.hansson@linaro.org, jejb@linux.ibm.com,
 martin.petersen@oracle.com, mani@kernel.org, davem@davemloft.net,
 herbert@gondor.apana.org.au
References: <20240127232436.2632187-1-quic_gaurkash@quicinc.com>
 <20240127232436.2632187-14-quic_gaurkash@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20240127232436.2632187-14-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/01/2024 00:14, Gaurav Kashyap wrote:
> When Qualcomm's Inline Crypto Engine (ICE) contains Hardware
> Key Manager (HWKM), and the 'HWKM' mode is enabled, it
> supports wrapped keys. However, this also requires firmware
> support in Trustzone to work correctly, which may not be available
> on all chipsets. In the above scenario, ICE needs to support standard
> keys even though HWKM is integrated from a hardware perspective.
> 
> Introducing this property so that Hardware wrapped key support
> can be enabled/disabled from software based on chipset firmware,
> and not just based on hardware version.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml     | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 09e43157cc71..6415d7be9b73 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -25,6 +25,16 @@ properties:
>    clocks:
>      maxItems: 1
>  
> +  qcom,ice-use-hwkm:
> +    type: boolean
> +    description:
> +      Use the supported Hardware Key Manager (HWKM) in Qualcomm ICE
> +      to support wrapped keys. Having this entry helps scenarios where
> +      the ICE hardware supports HWKM, but the Trustzone firmware does
> +      not have the full capability to use this HWKM and support wrapped

How does it help in this scenario? You enable this property, Trustzone
does not support it, so what happens?

Also, which SoCs have incomplete Trustzone support? I expect this to be
a quirk, thus limited to specific SoCs with issues.

Best regards,
Krzysztof

