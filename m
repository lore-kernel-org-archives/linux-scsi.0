Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBB340847
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 07:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715759412; cv=none; b=gpsb45aXuiUHNoyUvAeat4qvN6QUDgmz/P2om1TyHcdCd1p9+NZtiZYbs1/GzcLsO7v11iRaC+qc0o3uoo9jLR4VWX7E+9Zrr9GymCOLvDh/JjjOLBAB1aMteckq0MRAx2PW0L4/Ep/u2kd/R2/6F6vGxY0wiktTqvxPFNRZt0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715759412; c=relaxed/simple;
	bh=LoG+7gtU1o+7XCSOkjSuVQBBEuxkH1SzsEnGyxuBS14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2vsksrRgvfkI7iYXFAc+Ogqc46VfukvW0Z6V93bdZzFRoL5KN7HF/R9hIouX+FZXI6Zfp+xO/w2Hd8J+NiVVjBVyrVP+IALAnsEZ3dXS0WvuhX9tzEHFkjDCVTHsU3xLARVSRLSlOfJdYJlWX+9GZhnDZxFDchBfrYbrYeABWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YeHTprxI; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YeHTprxI"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-41fd5dc04e2so39959595e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 00:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715759408; x=1716364208; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2luu+TEKGzGGESWKjsQ/mAq5vIhVWQJ0g42DRjIbMDs=;
        b=YeHTprxIS/XNGwwPGNwBIs9B/yQ3IhS9vR/Dej9YdzzbaNBrVxK3+BdmVMFF5Dfdqg
         sOkSunh+8M4cB4X7RyxWwysdo0TP2b8D0Ug1bSLRo4QgMTFOC6BNRWJBFeccGAaT1xCo
         IjW87YZ02WyIHDXevVAslAzNO1h5epm+kGQLbx3xx413k4e3F+2sMOBO+blrHV32Bvm7
         frRRnRcPsT2hWfzW0u2gTEoQ1BNa/X6wGgna/D9VRYHGfUQDmOd/Hd2KufA6bGvHdQ0U
         C2JpMC5F23p+F347nCJUgNl5k7nQqpbO9rqwlDf/pOoUrYoMP4bkhokO3KyoQwH9+PyP
         pRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715759408; x=1716364208;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2luu+TEKGzGGESWKjsQ/mAq5vIhVWQJ0g42DRjIbMDs=;
        b=gbQec9ihNjP8mtu2tWUh3+xDwxmbrr7vS4iQ1L6aMcwVBlVfxBKFIl67EdZuUNyNYn
         fihC4Bi+sgsKk79v0aIzBl5tyQbb2rgc++K03wUWpzd3nzxpJBUMX/Xlt1lJEXggDKLL
         Oxv/ZmHRhOwTVshLUWxTj0c3XyNq34JbLeUgnCqTXPeu/zAliHeYWhyhZUM+Lic5hcfA
         w19Pt/WEM4BAd2Hxtm/BUXf20QVVKlapC/7hOWauvJX13x1uyg9AcsYg+b3dpw0D3kkY
         Hx4hXtYymcFzgtz23RTc6D6EbYm6g7P5mIg9E0dkz50uD7R7tH83zKVvR8iI/aJpyJI8
         Xlxg==
X-Forwarded-Encrypted: i=1; AJvYcCXWOaZ3q1ndX0URbUd8y94jyvOmRabBPoEDYZ6S60fAnnK1n/dTwqCJ7k2LMIGbvicqbN0Bb9pkY7q4Uh+bH/Rg7yWbnwlnn5oTwA==
X-Gm-Message-State: AOJu0Yz98bZ+cXqW8PjHaiSi6NtjKvSxOcff3YEg4eso1uj9S1x/pROg
	fjByk7l/1nO9TQkJwtQKi8zmVPCv+mxkFsdmInil8MD1ehwcX9U5W/h4XfU03Q==
X-Google-Smtp-Source: AGHT+IEwnw88k+dpNWTBc/h+G+M5vpa6Q0JqTHL3W0/n2a9dKdx0i4MEuejJLaApdV2aAiJ/HxYQGg==
X-Received: by 2002:a05:600c:450e:b0:418:dbad:c57d with SMTP id 5b1f17b1804b1-41feac5ba78mr111020505e9.28.1715759407711;
        Wed, 15 May 2024 00:50:07 -0700 (PDT)
Received: from thinkpad ([149.14.240.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42011d91edfsm129656185e9.44.2024.05.15.00.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 00:50:07 -0700 (PDT)
Date: Wed, 15 May 2024 09:50:05 +0200
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Conor Dooley <conor@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, Andy Gross <agross@kernel.org>,
	cros-qcom-dts-watchers@chromium.org, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: ufs: qcom: Use 'ufshc' as the node name
 for UFS controller nodes
Message-ID: <20240515075005.GC2445@thinkpad>
References: <20240514-ufs-nodename-fix-v1-0-4c55483ac401@linaro.org>
 <20240514-ufs-nodename-fix-v1-1-4c55483ac401@linaro.org>
 <20240514-buggy-sighing-1573000e3f52@spud>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240514-buggy-sighing-1573000e3f52@spud>

On Tue, May 14, 2024 at 07:50:15PM +0100, Conor Dooley wrote:
> On Tue, May 14, 2024 at 03:08:40PM +0200, Manivannan Sadhasivam wrote:
> > Devicetree binding has documented the node name for UFS controllers as
> > 'ufshc'. So let's use it instead of 'ufs' which is for the UFS devices.
> 
> Can you point out where that's been documented?

Typo here. s/Devicetree binding/Devicetree spec

https://github.com/devicetree-org/devicetree-specification/blob/main/source/chapter2-devicetree-basics.rst#generic-names-recommendation

- Mani

> Thanks,
> Conor.
> 
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > index 10c146424baa..37112e17e474 100644
> > --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > @@ -273,7 +273,7 @@ examples:
> >          #address-cells = <2>;
> >          #size-cells = <2>;
> >  
> > -        ufs@1d84000 {
> > +        ufshc@1d84000 {
> >              compatible = "qcom,sm8450-ufshc", "qcom,ufshc",
> >                           "jedec,ufs-2.0";
> >              reg = <0 0x01d84000 0 0x3000>;
> > 
> > -- 
> > 2.25.1
> > 



-- 
மணிவண்ணன் சதாசிவம்
