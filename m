Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3408186A
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 05:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742275439; cv=none; b=GnGIFptz8FJTm9FjHTYjbeFMGidQY9yYWAO30MBbdi13gsPfZu2B/oY51k7DKRUUv7MccWO9sJ0wqAnmAPGmUIycifYy3dUO5UOAOtiP/cMNP4IOsJHqoWxqTRfpaNPdbkl8zbvBYE3pG4Cvp0pOQpa0tLGtmzEUJwV3PcH7LeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742275439; c=relaxed/simple;
	bh=+6wTRmmn9IgGWFWLYYBguNMje+VK69ODef720Av4Ie8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRHEKj3gjZG5oPWrdJlfY7otYM9vq5eFmC2bahLB3n0M31qOmn5d3eQfdIe7SJzf4GMfeVS8d1uPFe8Yq/vZPcY2fcveZVwC2jpE7mrWAGF04QQIzt486J+B5uujFCFIDnwyScPuIQgHn4gZnSn1QWXC8sHDv2a5NoVwXKBz4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xnUzQ5w2; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xnUzQ5w2"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff64550991so3457967a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 22:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742275431; x=1742880231; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I3MFhv4iXPFGACGN68O6T+ndaCiilLWF8mxkeGzp5Wk=;
        b=xnUzQ5w26g9qTxz4M1XUQuAxrjLxUyuaaZYWEr65bW+rnePCMj7ClRTayJddL2/wrS
         OYbNm2Vlvk9pylGoC9x/b83k/hNRyy1N+TfhgoMRLwThOeJ2Ex9gR+Hbghe5F+VkHiJi
         pvVqUlpPcxtpxMtNuE0YmR0Jyk5evogSM54spkXlxufBFjBF+HzlYUtbNMsPpnxFEOZG
         bmWL7sGVuW0EFzUfamUcWwp9SOL8z/w68rzsSm6Pks+fl/dptj6iBxzsI2OOTWlNig0m
         yLL2Pd9JDiz7DF6PgGuMqflVRKDuhLZqvoQTokXmRhHTKf8tTpV5DFiggJBatLVoBWZv
         Y0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742275431; x=1742880231;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3MFhv4iXPFGACGN68O6T+ndaCiilLWF8mxkeGzp5Wk=;
        b=JSewoUOsz/hAuiFfYK5oCQbUXdEO0ov1Y6rT9WKE5oJ156WU2KapVVgjgjZXvrtenq
         vtJOV9xTzeuNWs/N6qqfmbcafzmlKzYTgT8S9gqClxXbwIolrP1eaCUpjopYJKFMY+Vd
         J5J59raZMB2zyuBL6iBsIjWcnGyx27x0ohYYnYnoqCDCNVlnTjSMVeRWSd8yQ82d5dRx
         iYm/wG7CdqLvEGMzOs91CkYP7y4OjV/RfRx5u9sG814smu93JCBJRB5QXFJeb92XdFXN
         9ilDsRnTqvLisvgctBkatnhQ5/eFAi4ZCQXDa8Ym0mc9txQhC1SX+CqvTvIZv1hoGHeV
         aqig==
X-Forwarded-Encrypted: i=1; AJvYcCW0el6iyT88mx4eTio2SDD6dqKQyS6DfivswaTzw8kr32tqBm+WU7piuNEjMnMHawDP19gzq4QiTde1@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp5M4TqdBGJtsqErdT+T+YXzrS9DFoZqM0tZ3KYGi7WBN0IaUv
	36MJHSJUg/I+/EX2jcrSYwYxdGUfgaV1qTnmH3juFc63MAp7wcb6oReJWYIYWg==
X-Gm-Gg: ASbGncsZj7OskI7ixYQZMSA/LoyeXTpbnTd/08b1v2tvHDM8fbe4nvfLfpqOKqmTS3w
	jGTmpal3RvtnsdBnas9vPqt7gO8gRq7iqeBMVuT5fRW97GOw6t4lxEewRZk8S8qR62h306jtGvC
	a8faWY7ZRENGDBOpi4j3duAq2kUyzZGdJ94qqTOKMqrnIWt52PwwXGGA2l2HausYj8C3Ka0NuaD
	5wbZwIRAWuy3XYFBNElfxS1M2jp+geriZ8wCtQK7P1yBOFfU2q8246YYY5whpkww5NNvnPzLAv/
	Mw4PrLozmMIfNOKNLIShyOwwefUzC7Rd0XFGn/tlcTvyBnF3MVJXtkBM
X-Google-Smtp-Source: AGHT+IHfQA8coXckUEYvZiBZ+6HlXKMz1xOJjAr8oflE+640yjM8m0J94JHhMX0+3laFnw472xG0Dg==
X-Received: by 2002:a17:90b:1e4b:b0:2fa:15ab:4dff with SMTP id 98e67ed59e1d1-301a5b99192mr1208448a91.31.1742275430993;
        Mon, 17 Mar 2025 22:23:50 -0700 (PDT)
Received: from thinkpad ([120.56.195.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301539d3f40sm7168928a91.4.2025.03.17.22.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 22:23:50 -0700 (PDT)
Date: Tue, 18 Mar 2025 10:53:43 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Melody Olvera <quic_molvera@quicinc.com>
Cc: Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Trilok Soni <quic_tsoni@quicinc.com>, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2 3/6] dt-bindings: ufs: qcom: Document the SM8750 UFS
 Controller
Message-ID: <20250318052343.do36phv6qxhimpab@thinkpad>
References: <20250310-sm8750_ufs_master-v2-0-0dfdd6823161@quicinc.com>
 <20250310-sm8750_ufs_master-v2-3-0dfdd6823161@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310-sm8750_ufs_master-v2-3-0dfdd6823161@quicinc.com>

On Mon, Mar 10, 2025 at 02:12:31PM -0700, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Document the UFS Controller on the SM8750 Platform.
> 
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index a03fff5df5ef2c70659371bf302c59b5940be984..6c6043d9809e1d6bf489153ab0aea5186d3563cc 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -43,6 +43,7 @@ properties:
>            - qcom,sm8450-ufshc
>            - qcom,sm8550-ufshc
>            - qcom,sm8650-ufshc
> +          - qcom,sm8750-ufshc
>        - const: qcom,ufshc
>        - const: jedec,ufs-2.0
>  
> @@ -158,6 +159,7 @@ allOf:
>                - qcom,sm8450-ufshc
>                - qcom,sm8550-ufshc
>                - qcom,sm8650-ufshc
> +              - qcom,sm8750-ufshc
>      then:
>        properties:
>          clocks:
> 
> -- 
> 2.46.1
> 

-- 
மணிவண்ணன் சதாசிவம்
