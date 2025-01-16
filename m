Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5CD1D79BE
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 09:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737019480; cv=none; b=dLS5SuT9go1GotzG/yJjjaa1KFxGOBq6XdhDinxn2qBCibQApoMkeO9gSfCO+o5jlXm1AjfsGF3VQRb8qArYRfZMh/QjI9KCyOBNvb4ENacC3fIOuNMrZ7BCGozi55W/WXmuii3OhlzUtcN4c3qrzyoBGeoewYMN5+XaQz83ync=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737019480; c=relaxed/simple;
	bh=wz/6VArm0fm4IK+UCKlCzR1Uz0mgnf9Z2nHw/aBWy9c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Bzna1F5S/IUU4G57zS4RXhU2H+x2ODlVkJOriY8Z/y2Ny7VLvMdN2o0W5Hnax1HtgkqDtx21QRBZRwbIa83ZIUrrai6YlcPQLZTnVANhk2kd2ufm/+SZ+1m+GdUduQgDNZ6CsmLcr+4ySXnNxFUWlBhgPTMdxsWwEGyfKgYirys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WBABoPfq; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WBABoPfq"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4363ae65100so6048005e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 01:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737019476; x=1737624276; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3lIaWSI2S+exW7AJdc9gF6v3PkwuGrMgeaYPmVrCZYI=;
        b=WBABoPfqO5GXPHk4+l212iVmfvolEeqlbvg+E2BIbuj++xJs4P9MzwkS4ZT0TPc0yl
         xiXhkcDHxk0k7+n88Df7LI4pZOGFZ0PC+W9q3c6yJw5pk7uYoBFryud5pwc1G3s44g+0
         zWlYhjKrgOqkJCS8gKL8TlCmaMmSvXPKZAAxmtrNYWD8yfEyMjKXzY7PURZpMsjDFd7O
         RnNyhSelOr3BgWcRoHBRZabvpUxMIswiSOLKUZva7EgCTAyBDROjIPv9AYPZPSNrebLF
         wp7wmwxcsBUcTcuAe0ROb4KGYYQ9knTqy0NMmyzY95OxtuEZyV3f08sMePhYHIY51XgE
         YGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737019476; x=1737624276;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3lIaWSI2S+exW7AJdc9gF6v3PkwuGrMgeaYPmVrCZYI=;
        b=C8AaJX/jnqcpzfWfbwwvwireKjh6nAN/3LHs6e0FP6hJyaTpCzWlHXV3kxC6pKxAk5
         VC3ics6cpgmN3O0ODe69VCEQUHgykHIEv8EG66Eb74jtAQ58f7QroMkGFs0AWagjaO80
         jmXkq92ukM88x5BZR5unvQHc/MvtB6F2PwXG2F9fPQ/d8GzRRyGDRJoggh72rgMLPAut
         sTtltPs78lyIllEIsAuMlv1+RNJNtqns/V4Loc6FhTsSbCVqNNhck3tJ2oewT/Pwbc1M
         syzQm6PDfYwBy24t8eWbQ7DjbVVrYJIy4jM+51jSxXWqXLxfBYenD+0DYdpVISy1d8jI
         i2vA==
X-Gm-Message-State: AOJu0Yz/KVoSh++T2kOVrp4GXX6XGr62rKTeFwwXwL87ctEarJuALWfy
	q5Wh+if2ud+u0mTWPNVpQj6gjO8N0NIs7/2k8KijlJ/LPlOCRs40UKWn3nYWuDY=
X-Gm-Gg: ASbGnctnCkoFMD1mixf0VJmJ3Ck8WtUTMHSEUxAVB5zaBowHgCLPlrrv8yhW4aMRCXS
	JU8bfhx1wtqit4fpa3XOFQ4w6hz/jY2gcSKBpOWOAechjPsHAVeMNGagD+Z+GYf9sGbS8pYJUJQ
	iiXSoTPIrrFRVnAqLARcHLZBR/8HxgZJIPFI7iuQkZheCsE6DoUzjPS5QEuLuKeWUTGOwNbXlwJ
	P6GnVlFsk3gfOZKEBvc3NBwE04mY0a4SIIxDIkI9dqXRsSG0rY4wNCXqOMrcT+TSbQj5PDPEVkF
	DfEAPqfnsAGq1PV4xODi0oDg93baF8w=
X-Google-Smtp-Source: AGHT+IFEgF8BZ/mYTGL6mOSmrxd/cLDyZc/Tv7cZxz3UDZhV9tkkfFiLKZQrO9BAMPcCteDuw4L/HA==
X-Received: by 2002:a05:600c:1987:b0:434:fddf:5c0c with SMTP id 5b1f17b1804b1-436e2679e05mr308050335e9.4.1737019476004;
        Thu, 16 Jan 2025 01:24:36 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:69b:c51f:3072:d4f5? ([2a01:e0a:982:cbb0:69b:c51f:3072:d4f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c753c617sm52784235e9.37.2025.01.16.01.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 01:24:35 -0800 (PST)
Message-ID: <e61d05d3-eb9d-4b58-8a56-43263c58f513@linaro.org>
Date: Thu, 16 Jan 2025 10:24:33 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 8/8] ARM: dts: msm: Use Operation Points V2 for UFS on
 SM8650
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 bvanassche@acm.org, mani@kernel.org, beanhuo@micron.com,
 avri.altman@wdc.com, junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
 <20250116091150.1167739-9-quic_ziqichen@quicinc.com>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <20250116091150.1167739-9-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 16/01/2025 10:11, Ziqi Chen wrote:
> Use Operation Points V2 for UFS on SM8650 so that multi-level
> clock/gear scaling can be possible.


I've already sent a similar one at https://lore.kernel.org/all/20250115-topic-sm8x50-upstream-dt-icc-update-v1-10-eaa8b10e2af7@linaro.org/

Neil

> 
> Co-developed-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> ---
>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 51 +++++++++++++++++++++++-----
>   1 file changed, 43 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
> index 01ac3769ffa6..5466f1217f64 100644
> --- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
> @@ -2557,18 +2557,11 @@ ufs_mem_hc: ufs@1d84000 {
>   				      "tx_lane0_sync_clk",
>   				      "rx_lane0_sync_clk",
>   				      "rx_lane1_sync_clk";
> -			freq-table-hz = <100000000 403000000>,
> -					<0 0>,
> -					<0 0>,
> -					<100000000 403000000>,
> -					<100000000 403000000>,
> -					<0 0>,
> -					<0 0>,
> -					<0 0>;
>   
>   			resets = <&gcc GCC_UFS_PHY_BCR>;
>   			reset-names = "rst";
>   
> +			operating-points-v2 = <&ufs_opp_table>;
>   			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>   					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
> @@ -2590,6 +2583,48 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   			#reset-cells = <1>;
>   
>   			status = "disabled";
> +
> +			ufs_opp_table: opp-table {
> +					   compatible = "operating-points-v2";
> +					   // LOW_SVS
> +					   opp-100000000 {
> +							   opp-hz = /bits/ 64 <100000000>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <100000000>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>;
> +							   required-opps = <&rpmhpd_opp_low_svs>;
> +					   };
> +
> +					   // SVS
> +					   opp-201500000 {
> +							   opp-hz = /bits/ 64 <201500000>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <201500000>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>;
> +							   required-opps = <&rpmhpd_opp_svs>;
> +					   };
> +
> +					   // NOM/TURBO
> +					   opp-403000000 {
> +							   opp-hz = /bits/ 64 <403000000>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <403000000>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>,
> +									   /bits/ 64 <0>;
> +							   required-opps = <&rpmhpd_opp_nom>;
> +					   };
> +			   };
>   		};
>   
>   		ice: crypto@1d88000 {

