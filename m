Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7D42D622
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 03:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711598359; cv=none; b=mrXxRzo8vty6ijMNzR8NLoff3xGbZsP77rLBphkqxFnv2VTAzTxuOORr9KdP+FOSPrnnc3r06IMlPO4zlkd92m5Fjcpe9oUmj/f+44RexNiNiko04Hu0Ubj21ezlWOvVZuXciUnLltg9VDKKem/TZqJ1cR9qz9nqBmNfoObSuMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711598359; c=relaxed/simple;
	bh=okEn6utwbpITb9k2PX8tO4MtO7QZXQhboupRJ92hruA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0b3VAX4eiRqNqAF/ONyQUrios/bnDbq4XAJebSL5p9gH39N6asL2dpvUTsY+vKw/UZBdZJ/SKW1Qk0HWsFPUgjrKkdZUL61lqZeEHqE5mCZICQ2KC/MkgMeJPSiLDejGsPLg0SrZnAM0EnHFuYHLkZSR7Ztgl2iqEFFwHVI5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fCFBP2sg; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fCFBP2sg"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e703e0e5deso475314b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 20:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711598357; x=1712203157; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w17nDhuJOeSnSYP0vy+UdWxKC15io0olSqGdTX2vBVs=;
        b=fCFBP2sgNWLDoxvKDzQOeIKkI0RuXre5WOVQUC7hg0JeEyhSwGPs/ZOmJVcHHRi0BN
         JdFsfeTKiD/hpxpCWvFJtmFgmPsyUQWoApl2yxt3hT82OvAM+nAT+wiodWbfd4iGVPG8
         jpABTCYmTyffN8LZWNQZpvNVUAwei5tXV294R5JxhA47xLVNOSXmWFbZCzIu9tSVIm3T
         Am9nsWQhcWv8KmoFRBmjOjmXlMYluondvX5qNrnQqYF+8N0pGCWhypqU/cXB8tfXP8z+
         4QmkUkCbD8/ypyhRLhebcANtziX9aAJRdPElWZTInCA+yZsHkmzqZzZxTBNN1gvJXvOU
         YeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711598357; x=1712203157;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w17nDhuJOeSnSYP0vy+UdWxKC15io0olSqGdTX2vBVs=;
        b=T/6XrljQRauKbgPZ2WLw8EIVUQJSH+Am9Xx6qUqBCcEW424KU4o87jJvaOGLaOKzfs
         4WQwt0dnJPMQ1CK4lij2mmiwQxToz6fpfHjo/PxC//vReANGfeUbeRCkpre8o34lP2Bd
         6gP0lqaAFFxRk5gafBQS2/OV7kk4hHFzfv62+ZfS+nS6HIgqWCgx+llf2SeIrk+b1K7y
         TKNybtDXSIWdbeWnC8tL95tNLcNRheCPSmfpWk9ApGGcuqcXMbxfhtPWkeQebkuISuiE
         Vf2k3yajupfJDdriaje8cPgjvV9b8/Ma9KMzDIKIiU6wuCztG8eeR8GROzoQqIw53COF
         JPJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpMz7Yfh7Semc8CyF9QvqoMb6x+h1NDWksogHZMgrNCOhZU1VsZUX0c6SkfZBCwSxYXWj7gAo2iT1BhlGouTP5YJ18mYz5r38JUg==
X-Gm-Message-State: AOJu0Yz+VgAA47BKpcefjVrSXnKOu4Q0cZmpmjulR47bUe2PBeawatu2
	YyADYZcABCMRnG5kTQ322Tq1SEQ9vJHoo/wiNwxN8+Y27R8jDkWM2nAUhVAtJgNiDG32C1yCDfU
	=
X-Google-Smtp-Source: AGHT+IEUbeEwMLKQUFqnunvwzqrLUk2M2HSuYDMYCQ9/F1sqZywek+e6UuBrqRFaBAI4gnDY+N/LLg==
X-Received: by 2002:a05:6a20:548a:b0:1a3:aa06:38c1 with SMTP id i10-20020a056a20548a00b001a3aa0638c1mr2329538pzk.13.1711598357453;
        Wed, 27 Mar 2024 20:59:17 -0700 (PDT)
Received: from thinkpad ([2409:40f2:201b:315f:8cec:6523:95f2:3f93])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090a718b00b0029b59bf77b4sm2489300pjk.42.2024.03.27.20.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 20:59:17 -0700 (PDT)
Date: Thu, 28 Mar 2024 09:29:09 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, Andy Gross <agross@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: ufs: qcom: document SC7180 UFS
Message-ID: <20240328035909.GB3212@thinkpad>
References: <20240326174632.209745-1-krzysztof.kozlowski@linaro.org>
 <20240326174632.209745-2-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240326174632.209745-2-krzysztof.kozlowski@linaro.org>

On Tue, Mar 26, 2024 at 06:46:31PM +0100, Krzysztof Kozlowski wrote:
> Document already upstreamed and used Qualcomm SC7180 UFS host controller
> to fix dtbs_check warnings like:
> 
>   sc7180-idp.dtb: ufshc@1d84000: compatible:0: 'qcom,sc7180-ufshc' is not one of ...
>   sc7180-idp.dtb: ufshc@1d84000: clocks: [[39, 99], [39, 7], [39, 98], [39, 107], [36, 0], [39, 106], [39, 105]] is too short
>   sc7180-idp.dtb: ufshc@1d84000: clock-names: ['core_clk', 'bus_aggr_clk', 'iface_clk', 'core_clk_unipro', ...] is too short
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../devicetree/bindings/ufs/qcom,ufs.yaml     | 34 ++++++++++++++++---
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index 1ab3d16917ac..7e6d442545ad 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -27,6 +27,7 @@ properties:
>            - qcom,msm8996-ufshc
>            - qcom,msm8998-ufshc
>            - qcom,sa8775p-ufshc
> +          - qcom,sc7180-ufshc
>            - qcom,sc7280-ufshc
>            - qcom,sc8180x-ufshc
>            - qcom,sc8280xp-ufshc
> @@ -43,11 +44,11 @@ properties:
>        - const: jedec,ufs-2.0
>  
>    clocks:
> -    minItems: 8
> +    minItems: 7
>      maxItems: 11
>  
>    clock-names:
> -    minItems: 8
> +    minItems: 7
>      maxItems: 11
>  
>    dma-coherent: true
> @@ -113,6 +114,31 @@ required:
>  allOf:
>    - $ref: ufs-common.yaml
>  
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc7180-ufshc
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 7
> +          maxItems: 7
> +        clock-names:
> +          items:
> +            - const: core_clk
> +            - const: bus_aggr_clk
> +            - const: iface_clk
> +            - const: core_clk_unipro
> +            - const: ref_clk
> +            - const: tx_lane0_sync_clk
> +            - const: rx_lane0_sync_clk
> +        reg:
> +          maxItems: 1
> +        reg-names:
> +          maxItems: 1
> +
>    - if:
>        properties:
>          compatible:
> @@ -250,7 +276,7 @@ allOf:
>          reg:
>            maxItems: 1
>          clocks:
> -          minItems: 8
> +          minItems: 7
>            maxItems: 8
>      else:
>        properties:
> @@ -258,7 +284,7 @@ allOf:
>            minItems: 1
>            maxItems: 2
>          clocks:
> -          minItems: 8
> +          minItems: 7

I'm getting confused by the clock requirements for qcom,ice. Why does specifying
the qcom,ice phandle require these clocks? These are the UFSHC clocks and
already defined above.

- Mani

>            maxItems: 11
>  
>  unevaluatedProperties: false
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
