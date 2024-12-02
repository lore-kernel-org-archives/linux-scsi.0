Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6476B1FDE11
	for <linux-scsi@vger.kernel.org>; Mon,  2 Dec 2024 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733150933; cv=none; b=nqcmtrSIz6YtlOtxLgAUOoWRKyn4byj5JNUNhIb7t66dElkL5PrGSBT0ZlB4JawDdVv/C95GVIPBRcufBVaNfdlzZW4S2oSKgn9LAT9Lu0oP7QPIDHVgc2Ez+pkdcW0TX3z/10QReOmIT1S9rtMT34hgTUsLuazy3FPk0nNQB+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733150933; c=relaxed/simple;
	bh=XYknei693eTxY8aq2XA9wDND4yyWPBY7zhkDQopy7l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huUgmSrxNxez2/J1IPA8snKMpHvPGENtJfgO6YxiTWXyBhvtJYFM89a8Om+lDK/z9S4MUQ4gecVYFLL9/CNhdOCgd3RZh7j4fqiDfoCP8MTXkmnx3FFab73ko4nPzaGk+oSZ6mI9G/QlSWto7CUwWJXSzqgqqFmeLMG7CTx2GZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hb8RGcuY; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hb8RGcuY"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21278f3d547so31856225ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2024 06:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733150932; x=1733755732; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GpKDAl11fDGEFH2u0shHgW2aMBuMgZUzlcce2vSqOBc=;
        b=hb8RGcuYKhOi7tMJgRYG8tTJ7+Ab1PeCtAzgDmTXJ6D/Y4h3Mst9WscRTg8KST32h+
         omXakHLVSviaq8a0esaR+3lCm1fpoKXI2MVGKUeB5tsZ1X81ryefdMt1bEP7KsVNzl+G
         imr8yt+UmHPkOo4X4TSFccdPnIe/b8gK6+mLjknlrmTKKY8Y/KpjYmuIZul3xn6yTt0l
         xaUB3Z42AI/2FYZTjNy9M8dsxQXl/YA5AAyc9zerb7Q7fOHoE00uDgzPii0SN2L2p622
         JV55ClJOMxlUu9ZU2zDOCaMdlnVXLALXvKENiNyOR6gyeRVecZiBbNCBfgeRdI/qpa+7
         lT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733150932; x=1733755732;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpKDAl11fDGEFH2u0shHgW2aMBuMgZUzlcce2vSqOBc=;
        b=PCW5JZpmOXHYwOXNthRqVenUWN2bULYgU570jp50nnXWAKZ5CfPuAQhLp80kIEI2Bu
         32z4r+XUAoaob22qHQyXNDTFKM8VkLzDEiXjd0AGJjDWT7C665cSQsXfEZyXec3DHDCs
         OJ6nPAAxGPrYpPBz+kUJEgvdeCUr/rCnp9Hv03i7Bl9zou45bpERjv72uWvBMSOpyKms
         qDcPO7nZj8H9ECiLXyaWEBJLWbfht+SEYvheNA7gWZ1GR/H6OgTfUbo7RFFBEi8u6PWS
         UGqsg4YIVZ1tMcspwgNR2FNO5biETSENYgJMYd1HOonT+lNomu1TSJLv0eLb75o5ALpx
         c3mg==
X-Forwarded-Encrypted: i=1; AJvYcCUdvUkJ3YvXIbZqRt//zmm75s/0tiC38aomBgDl2WEYjxrXCSgNDhEQ8sp6SVuXF7oL5WAcoxX8fmiz@vger.kernel.org
X-Gm-Message-State: AOJu0YwExfeeWJLxeaREvpa8JmpmZRZAmHpaF0GvIcbL1tE7cR9EmMUQ
	ZCoYN0oCi821INESfDztprKTCn+ttbEn3kIAyYtmK7lCxrh+Rv6A894z3Jxn5g==
X-Gm-Gg: ASbGncsHxFPqbZSDC85OGzedhVID+f6MKcP8HMCL4PsKaKy8ELiYyIPdf2xjNCzxZUR
	DehyaeCFB3IQemTbLGxMWxCRA2Bf4A24BaVltrfjiJX8V/bQmyHAw9Bh7zC9FJsXIgfGP4/hWc0
	aBjMtcChKXzFpIXXBaPnyRlIZyRUgyLGurquXg6sVw+E+lTJveq1w9Tc9GPPzOQuqmjt2KEQoYw
	qhwTIlpP3gTtv0iEB623EL9BaVQrMmQGn/xd3a7MMb8XcnPlpArGJ6f2tGd+Q==
X-Google-Smtp-Source: AGHT+IEqa+tt8+8vAVIq3UE9y4O1HQ9UBxGGwNoUbUmxwVoafsrUcqpH/ZT38yQrrxK6IssCIyvowg==
X-Received: by 2002:a17:902:f611:b0:215:3fc6:7994 with SMTP id d9443c01a7336-2153fc67ba5mr207835105ad.49.1733150931824;
        Mon, 02 Dec 2024 06:48:51 -0800 (PST)
Received: from thinkpad ([120.60.140.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2154704346asm57084655ad.18.2024.12.02.06.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 06:48:51 -0800 (PST)
Date: Mon, 2 Dec 2024 20:18:44 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Xin Liu <quic_liuxin@quicinc.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Gross <agross@kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	quic_jiegan@quicinc.com, quic_aiquny@quicinc.com,
	quic_tingweiz@quicinc.com, quic_sayalil@quicinc.com,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v3 3/3] arm64: dts: qcom: qcs615-ride: Enable UFS node
Message-ID: <20241202144844.erqdn5ltsblyhy27@thinkpad>
References: <20241122064428.278752-1-quic_liuxin@quicinc.com>
 <20241122064428.278752-4-quic_liuxin@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241122064428.278752-4-quic_liuxin@quicinc.com>

On Fri, Nov 22, 2024 at 02:44:28PM +0800, Xin Liu wrote:
> From: Sayali Lokhande <quic_sayalil@quicinc.com>
> 
> Enable UFS on the Qualcomm QCS615 Ride platform.
> 
> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

One question below.

> ---
>  arch/arm64/boot/dts/qcom/qcs615-ride.dts | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/qcs615-ride.dts b/arch/arm64/boot/dts/qcom/qcs615-ride.dts
> index ee6cab3924a6..79634646350b 100644
> --- a/arch/arm64/boot/dts/qcom/qcs615-ride.dts
> +++ b/arch/arm64/boot/dts/qcom/qcs615-ride.dts
> @@ -214,6 +214,22 @@ &uart0 {
>  	status = "okay";
>  };
>  
> +&ufs_mem_hc {

No 'reset-gpios' to reset the UFS device?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
