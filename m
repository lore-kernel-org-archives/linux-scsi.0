Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E0336C5A6
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768291364; cv=none; b=Qn6/YPlx+l8A6s75B13JEDZ9jZqmoCgKAdTvmVlkxrY3+1Pn3kMbTCSTVtifIGLAZFnAOEgFBHiylUECdhkMtuNN8cM8jo7/FvxFsA65zhSM4oQr0sbC0iIB3uRPOq1zkC0fzK5s6lNUSETY1n8mUyoQ9DjhPYfOwMqw0ZcZxrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768291364; c=relaxed/simple;
	bh=CfGLLHtAMP5se33ly666hJEy8681yRbGQLMykeBbx1k=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=aTr2Oo5UsamTYTn5v8EtYyi1UTnB494XCWxjj/CplHS+O6pNT1Yrz2PnTDY6+pf7u9xQrKTGZogpolN82UEtijb16xisVcDtC2c5rG9ZjZrOEYE1kE2arOLpp0leSZ9kRhtD/r0PsWRJqluOEEh2QTHSmW2ksnZH9Jut5xl54zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BW0kqUjQ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BW0kqUjQ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ed987d51aso3586335e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 00:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768291353; x=1768896153; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g6A7r611q476j/8oCIaN8K7+Q8yqCShfdSd5Arz3Gpc=;
        b=BW0kqUjQPz7P/T47Y9g3A3OwkseZzCGJKk3QD2GbuTLwrFM5yj09E2CUTcsa7mUijz
         YlXMjyvrXvMQiYawHLxi8KIq22k7l0xmDXyhp06GI3QUjmqmWftacYZI1R1iddaAPAGi
         HsWMKJGWm1Y44zAycuTjyndNXkeguznUxLwVPyhx2o/N4RHA625ObBA+pSBu44wdmA+y
         luccyS/6WAEnLYfflRYuME2HpkD3BTJ3Pc/K7ST+wYayjlcSNn6JNZVhhSrEGRWXf1KB
         s96fIaPzf7RSw6HzjmtafWwfEMwJvwXqEhpy3q4DD1gBBP4ERRPeYc+YNFEw6yZp8c+C
         bZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768291353; x=1768896153;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6A7r611q476j/8oCIaN8K7+Q8yqCShfdSd5Arz3Gpc=;
        b=QDVXOG5fydo5V7XWZIZ1KK/G4Zz/A1b3JSj+CWa0sT1vGwbqxgTg+Se3JlQNY/xNl6
         dMLx443QQjAKTQJUhCE8Q72R1oL5r4lMj8TnG1t+q9ive3r/hvHztI72SrOctyQpxl47
         Mz+QS/wxDaanDe1qzHhcw1krAVISOh5yDgTeGrRs/LMyBqXaLMt9rn9hcdQosz1v3Gaz
         z+pP6j9jZUrPmt+tUb+3lc/wqtn6LKRq6orxnO5LyE/DeX/ZXg1vm7KsXm7YkP1D+cK/
         S8ntA6WqWHwDjkfYYwYz5emYaFbAtOR2HRYZr825KeDSibsV/9IDPfnaBqtREMujLwAL
         MQow==
X-Forwarded-Encrypted: i=1; AJvYcCV9pqoOQRWqY240rdtqqim2gYc7dvi8b5glotfxvZGo4Z4A1PJAnAlnSxI+gyVCKVD6TrcBz8XUKf92@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb/nG/T/9mSVZgl9YKlxXGTTYEaYqbz7NuL5Miz+aVFNpyxKJi
	K50f/3WJYthjSnjqfG/xbglkbpMoNHzaqNCHsfl+8VfV0e6+Msc26eaUZ9+nO/j3Z9E=
X-Gm-Gg: AY/fxX4lUF4sbFbgANE9vrTjCzURYiLiZAqjwj2Y9PwEKebxp6kdulz8NOneUYh+xoQ
	scQsxwDj4Sb6V+hQ7HBjvLVDjqRMCNHZBIsoVBBlSXhJ10jQRv5vC432CT0CPre7KhcMKMJroor
	6xfnJTEWc5PmNmj7L6ve+y+Gpyr9UF8Vmn5x6BKaMG+wwnOdvOCsPIT95vOkL/ZJCA5GMreTDNf
	TKkvWO2+x4R4xTmfjVSsULhqsPxOBBEhSvh/B0uHbU60M3Z+3bwTM9+I597+mZtQoNPwhCQem9u
	aLLR841vKFtBRhSnpXVJKGW8/7wdIk6yAVv8Qf3Ys9Z7ufI8XoZ/EC3f0+R44Rge2iwc3+e5Mqt
	DyaQ0PTWLGAPNfRQ2YbC0j0EZUXgusCE3+9ONP0bZ145Hvy2kRLVpHi4gJ44Z2SssoUHP3F/jkt
	W4r3Ph0/CZvtQ/d0h+UmTjW5kREfBsjKTCjqd4hBk=
X-Google-Smtp-Source: AGHT+IHrnnPCXrF0NOJBoPGixzBrnHBCDRj20M4yCZwqxFE51GxNlKuyIibw+hyJVZQowMJPsFEW1w==
X-Received: by 2002:a05:600c:4fc6:b0:477:5ad9:6df1 with SMTP id 5b1f17b1804b1-47d84b0aaa3mr221663015e9.3.1768291352911;
        Tue, 13 Jan 2026 00:02:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:3d9:2080::fa42:7768? ([2a01:e0a:3d9:2080::fa42:7768])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ecf6a5466sm109514045e9.11.2026.01.13.00.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 00:02:31 -0800 (PST)
Message-ID: <186438aa-a39e-4c85-9187-cd47d6abd2e7@linaro.org>
Date: Tue, 13 Jan 2026 09:02:30 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH v2 4/6] phy: qcom-qmp-ufs: Add Milos support
To: Luca Weiss <luca.weiss@fairphone.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org,
 Abel Vesa <abel.vesa@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-4-d3ce4f61f030@fairphone.com>
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
In-Reply-To: <20260112-milos-ufs-v2-4-d3ce4f61f030@fairphone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/26 14:53, Luca Weiss wrote:
> Add the init sequence tables and config for the UFS QMP phy found in the
> Milos SoC.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>   drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 96 +++++++++++++++++++++++++++++++++
>   1 file changed, 96 insertions(+)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index 8a280433a42b..df138a5442eb 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -84,6 +84,68 @@ static const unsigned int ufsphy_v6_regs_layout[QPHY_LAYOUT_SIZE] = {
>   	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V6_PCS_UFS_POWER_DOWN_CONTROL,
>   };
>   
> +static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_HSCLK_SEL_1, 0x11),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_HSCLK_HS_SWITCH_SEL_1, 0x00),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP_EN, 0x01),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_IVCO, 0x0f),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_IETRIM, 0x0a),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_IPTRIM, 0x17),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_VCO_TUNE_MAP, 0x04),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_BG_TIMER, 0x0e),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_VCO_TUNE_INITVAL2, 0x00),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_DEC_START_MODE0, 0x82),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_MODE0, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCTRL_MODE0, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_MODE0, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP1_MODE0, 0xff),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP2_MODE0, 0x0c),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_DEC_START_MODE1, 0x98),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_MODE1, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCTRL_MODE1, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_MODE1, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP1_MODE1, 0x32),
> +	QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP2_MODE1, 0x0f),
> +};
> +
> +static const struct qmp_phy_init_tbl milos_ufsphy_tx[] = {
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_TX_LANE_MODE_1, 0x05),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_TX_RES_CODE_LANE_OFFSET_TX, 0x07),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_TX_RES_CODE_LANE_OFFSET_RX, 0x0e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_TX_FR_DCC_CTRL, 0xcc),
> +};
> +
> +static const struct qmp_phy_init_tbl milos_ufsphy_rx[] = {
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_UCDR_FO_GAIN_RATE2, 0x0c),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_VGA_CAL_MAN_VAL, 0x3e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_RX_EQU_ADAPTOR_CNTRL4, 0x0f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE_0_1_B0, 0xce),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE_0_1_B1, 0xce),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE_0_1_B2, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE_0_1_B3, 0x1a),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE_0_1_B4, 0x0f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE_0_1_B6, 0x60),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE2_B3, 0x9e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE2_B6, 0x60),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE3_B3, 0x9e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE3_B4, 0x0e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE3_B5, 0x36),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_MODE_RATE3_B8, 0x02),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V6_RX_UCDR_PI_CTRL1, 0x94),
> +};
> +
> +static const struct qmp_phy_init_tbl milos_ufsphy_pcs[] = {
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x0b),
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x04),
> +	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x04),
> +};
> +
>   static const struct qmp_phy_init_tbl msm8996_ufsphy_serdes[] = {
>   	QMP_PHY_INIT_CFG(QSERDES_COM_CMN_CONFIG, 0x0e),
>   	QMP_PHY_INIT_CFG(QSERDES_COM_SYSCLK_EN_SEL, 0xd7),
> @@ -1165,6 +1227,11 @@ static inline void qphy_clrbits(void __iomem *base, u32 offset, u32 val)
>   }
>   
>   /* Regulator bulk data with load values for specific configurations */
> +static const struct regulator_bulk_data milos_ufsphy_vreg_l[] = {
> +	{ .supply = "vdda-phy", .init_load_uA = 140120 },
> +	{ .supply = "vdda-pll", .init_load_uA = 18340 },
> +};
> +
>   static const struct regulator_bulk_data msm8996_ufsphy_vreg_l[] = {
>   	{ .supply = "vdda-phy", .init_load_uA = 51400 },
>   	{ .supply = "vdda-pll", .init_load_uA = 14600 },
> @@ -1258,6 +1325,32 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v6 = {
>   	.rx2		= 0x1a00,
>   };
>   
> +static const struct qmp_phy_cfg milos_ufsphy_cfg = {
> +	.lanes			= 2,
> +
> +	.offsets		= &qmp_ufs_offsets_v6,
> +	.max_supported_gear	= UFS_HS_G4,
> +
> +	.tbls = {
> +		.serdes		= milos_ufsphy_serdes,
> +		.serdes_num	= ARRAY_SIZE(milos_ufsphy_serdes),
> +		.tx		= milos_ufsphy_tx,
> +		.tx_num		= ARRAY_SIZE(milos_ufsphy_tx),
> +		.rx		= milos_ufsphy_rx,
> +		.rx_num		= ARRAY_SIZE(milos_ufsphy_rx),
> +		.pcs		= milos_ufsphy_pcs,
> +		.pcs_num	= ARRAY_SIZE(milos_ufsphy_pcs),
> +	},
> +	.tbls_hs_b = {
> +		.serdes		= sm8550_ufsphy_hs_b_serdes,
> +		.serdes_num	= ARRAY_SIZE(sm8550_ufsphy_hs_b_serdes),
> +	},
> +
> +	.vreg_list		= milos_ufsphy_vreg_l,
> +	.num_vregs		= ARRAY_SIZE(milos_ufsphy_vreg_l),
> +	.regs			= ufsphy_v6_regs_layout,
> +};
> +
>   static const struct qmp_phy_cfg msm8996_ufsphy_cfg = {
>   	.lanes			= 1,
>   
> @@ -2166,6 +2259,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
>   
>   static const struct of_device_id qmp_ufs_of_match_table[] = {
>   	{
> +		.compatible = "qcom,milos-qmp-ufs-phy",
> +		.data = &milos_ufsphy_cfg,
> +	}, {
>   		.compatible = "qcom,msm8996-qmp-ufs-phy",
>   		.data = &msm8996_ufsphy_cfg,
>   	}, {
> 

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>

Thanks,
Neil
