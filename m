Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E690412B175
	for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708091675; cv=none; b=PDIIqRQmUKLQReWFjjfHvWyicSq6b+ulQ8/eAjaEWvBoGt4qcbN4JIMgXHaUZtK5qwVfKGmiwIZqQkIaHKJoTya6rDO/KAgMfMdcatU1iUxSsqLfOF+Hincb9o4ikHDFm3JBNvwBhGCW0M+TvLZvLhVTeSPb6tAT/Z7GOwogk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708091675; c=relaxed/simple;
	bh=NhmCUNDgsWt5+ADVtF0uTbpvzwT1bgHvCHWDDbqVurE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+SIy0nfZQMbgyXm8jT5EwboamUDr+sJZLbyqDFLemCZbVHKaxAtGMf3SIbmw+EwqCg3ZQSTva95PhwbGpqoYdjG3pf41aQc9URiFTpcy97QD9EHxJt1UHMJ2OMfpCI/O3AooJcxXYvkCzvA9orNxNc75wq/HnSTBIbuAbSrOis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HDGLgv9h; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HDGLgv9h"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1db51e55023so13255625ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 05:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708091673; x=1708696473; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WZ1AXsb/8YISAA45nMnA+ELNn4c9qOzlfcLWF36QQ1Q=;
        b=HDGLgv9h9RMuL5A5VDizsU7+Ezvh0+umtj+FZVTNCpGMXas+R/puAOb7P/GSCI5yfw
         QHdca3v08zziz9k6ss3Le0wUGKC6J30Fg8Fl/4fwXj+FXmpVW2RnjD5Wlj9Tj/uPi2Ip
         VDNFjgRraPHHQJ4Xgb+gMpMixj9rmlUX6orPeg06Ehg+GbNDTa2d3Gbc/gHZUSGY4EiF
         QtqQlpXfjuaklCXddNA0WUuPVyfgBhxvkOjScQYHwBBUMv0pmoR6fYL5mPVmThGKfLQm
         E43DenKim0dmkk69tlrC88vrmbqZKjZvqIJgHmSxLszn5XDHAKXQ9qvTfut4d1vKHtsU
         KvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708091673; x=1708696473;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ1AXsb/8YISAA45nMnA+ELNn4c9qOzlfcLWF36QQ1Q=;
        b=HTWxtRwFgb1H4RloINFjnKaUKpYZ5dPqBMMT95yRVa7xo73RUsw1vJZaNgXcWGxIlu
         WeOjTo5mSkcmGA2p8I3faITZqXRRQSzFj28hdLedJAr5spyMekjWcbq97MwWOf2B37cd
         UhFM++mqOD9PMPJ3P/QnJNPF9zB4coHQOLR40ZLIWpU2UqM35Q29IzhvUvXSlejdIdGA
         praZ4v3FvcZ7CcwUf0Pbg+Z6fofDvYksyZSrG7lRd7p1B1M7N83ndPy5uaaxYzbDJUOZ
         gJphvKJMiAPYr7PZLjJgYyLO4Un8PvS9pUq7GZieY44rRMGPXEm1rbXaBrbUqH9rAo9v
         GlQg==
X-Forwarded-Encrypted: i=1; AJvYcCUxoaXWpn8E0Mem/fBqn/DjhM4+SBu3csCWiGttw0CGAZnjOmnCaTsKLrmSb05ouUzvpIvX+dAGkfUAZi6N3iVtBImg4zLxvspmtg==
X-Gm-Message-State: AOJu0YzATZuy98l2URc3nBh9D7tdzmmmwctRxWElIvcAvTidmu5CC4Rg
	ZX7rPk6B2xHPJN2qSk9g7vNCbNbq2H9M75VZwUcVZyt/DC7gdvuk0JT7GKE+LA==
X-Google-Smtp-Source: AGHT+IG6Br18asjjyc6sQxw6JVym7Z2OCTsKAUJJzmDUZu4MebY4OOdpdvTZcZyMkQSZ2OYVxRzpSw==
X-Received: by 2002:a17:902:f681:b0:1d9:bf07:7e64 with SMTP id l1-20020a170902f68100b001d9bf077e64mr6398835plg.59.1708091673171;
        Fri, 16 Feb 2024 05:54:33 -0800 (PST)
Received: from thinkpad ([120.138.12.48])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903120c00b001db53ace011sm3010714plh.220.2024.02.16.05.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 05:54:32 -0800 (PST)
Date: Fri, 16 Feb 2024 19:24:27 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Gross <agross@kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/6] arm64: dts: qcom: msm8996: unbreak UFS HCD support
Message-ID: <20240216135427.GJ2559@thinkpad>
References: <20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org>
 <20240213-msm8996-fix-ufs-v2-2-650758c26458@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240213-msm8996-fix-ufs-v2-2-650758c26458@linaro.org>

On Tue, Feb 13, 2024 at 01:22:18PM +0200, Dmitry Baryshkov wrote:
> Since the commit b4e13e1ae95e ("scsi: ufs: qcom: Add multiple frequency
> support for MAX_CORE_CLK_1US_CYCLES") the Qualcomm UFS driver uses
> core_clk_unipro values from frequency table to calculate cycles_in_1us.
> The DT file for MSM8996  passed 0 HZ frequencies there, resulting in
> broken UFS support on that platform. Fix the corresponding clock values
> in the frequency table.
> 
> Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> index f6b6fdc12f44..80d83e01bb4d 100644
> --- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
> +++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
> @@ -2077,7 +2077,7 @@ ufshc: ufshc@624000 {
>  				<0 0>,
>  				<0 0>,
>  				<150000000 300000000>,
> -				<0 0>,
> +				<75000000 150000000>,
>  				<0 0>,
>  				<0 0>,
>  				<0 0>,
> 
> -- 
> 2.39.2
> 

-- 
மணிவண்ணன் சதாசிவம்
