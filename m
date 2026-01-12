Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882A13218B2
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768206372; cv=none; b=qlFE0+eMxiE6r3EJ7rnh2HEGzlq0cCl1Y/FvTdo6Ln9lSdWke83fFHZ+K22h/JFHdBHWaVoNtOR6vVVsf+7+S348caYVqOguVD2stEm9ctXL8pmSRQETjMXAFfgZ0YZjF5Wm3mSelX6hqPw5VFVfn9gS+6842n9zURAPwB+f1YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768206372; c=relaxed/simple;
	bh=crOxfXx3Bkxmg/62bNfuXm2ff0UCs2ZSN8ubtVaCd+U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YIEE9uERS6HVAohzTnKpZhvqoP6qeodC3yWvEED+rJG/TclwLCVCZmVkqoEwDXfAAPhURls/Rw0f+KIsX6gDtpA130v0IP2MNRn+bVJ7Pb9BesTDoHwbG4Wu3HJVNn8Wn5ykSPHKqGJSpM1APKtLk5WVd7yRPY9OuIuekiTcNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A1zQXDCo; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A1zQXDCo"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47a95efd2ceso53853745e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768206369; x=1768811169; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e2tN6b+lbrWfZ7oxTxnv+TGwJvGYGk587gJwGFobI+w=;
        b=A1zQXDCokwxTLxwTXKjvjpbpAoYa9yGj60ylrmySGVt0W9DT6AQXGrlSPv4aJzTqNP
         MWja4/xR2KgMHO4t89khmUlNpnKDbNWY9bVWvw1dc8S8ff2Mx/clZwjYLs+E2RolUtSi
         zs6JSYflGdZA7klxduXv8cHUDZMvELZBPeu43Q+LLdp+ysBxoKSUMf5pFKQKdiYP0Bz6
         d1V2yMqiiJwEvX6ExeqJJe6ek4tVDkLQpHdIN12ILbZzQJT4g+IkhmpXdOiRPKQAC2Th
         4v4ixWNg/xWvLAZAm3LU/tPJrtiIgSlNr+Tm2Y/a4clksRJIMK3K9M+Rk2B92zctKVYG
         0rFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768206369; x=1768811169;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2tN6b+lbrWfZ7oxTxnv+TGwJvGYGk587gJwGFobI+w=;
        b=lbcwR4ZiyjYCkMNJJSK8bu2JxzoZmSNf/SfNZ1qQHv6jG1zkZJ6ADyNhlOpphkbTWp
         3S2mu2Atiu/Lr/B6IrNyweFxtnG/C5OvCRhwxmEZhA5IdfKZv6+Y2uFOzAZMklNwmHCn
         kyqrpI2KEsN1GUiLj/J9GaJ9Lal0/bLAF4+ThbZkELz4OhzyjRkaeOyTSVw+CcelZ0a5
         IkJQh0PbokrQb9QDAfMBid7sNB20hTmwHFPua0VtHu6kuEsXZoU9IAollfEwRMpBKlA4
         nx455+9NSR2xlFT2QiWTgJeqSklKCXRc965V5xPTgFE2H7ob+s3F1NByInYM9rHi81yb
         HsdA==
X-Forwarded-Encrypted: i=1; AJvYcCV90VrvAQljnBKhGzvBeWCIFA+9wWwS8yj8rR0jW7u8RD1qc2AchBEkZ3LiWta3lT42Fh3gfmseSQo9@vger.kernel.org
X-Gm-Message-State: AOJu0YybNzrHSok+iB7/p/D6YkXMgRNDcTYBHkkAHGRFnbj3QAlWtRPd
	ttEUfjLA93HjjIx//Lu+yLsfH/oiYapSdMb4TLZlzoUn2d+RVh7pKagT/AjJShLcGvw=
X-Gm-Gg: AY/fxX5+SVA6jywcdECiW1sCzJbtQsQqfxLaZMBQMVWUpe+xF9DGQJ0Nae94g65aR8i
	wnSEmKs0W8W+4pJdUyymJJZcBLNW0w0q9BzMpV7mNEakXi6TPnZu2SnXNHgk2+xD2vAzBplfO2C
	gXSWp8kquFTKe+1e9cfUMjHLQu/BPJZ9d77wsUxT34rOUDUpp4DB6DT+vPaTRMkvwTWX7t6FJK/
	jxxcKxNUGuslcQG1YzgXKUQFcJU67OEIGj3wP9eKzs6CRR8HOUgvS7sy61OITkZbzw/lWcLh8NO
	Bble6XorwB2r3kMJTTRcpWK77cnemcVBrno7a/RsyT05Cji1SYEpCPNL1wldmsaGJEvgIJDrR6n
	BxIYW2VIk39Rrb/CAMTYzrrRQbvD2RGPYQy+VmXZRMkApixSG2JhiFE/yRsFrKSVL4OHePE/BTS
	8AdPYhWNkCKeWdWtYZcdfcfWMHf4VTxrAvmx3KzOwacQsrkMbZR1FcLdz+7u6H6NQ=
X-Google-Smtp-Source: AGHT+IEHe//EMfbw9CmlUYlXkRTQIfxEKVLk8LbEc0vmw0imeAGWpvdjD+oOFjRIpcjB4QO1aoBseQ==
X-Received: by 2002:a05:600c:8b43:b0:479:1ac2:f9b8 with SMTP id 5b1f17b1804b1-47d84b33b7bmr196273835e9.21.1768206368719;
        Mon, 12 Jan 2026 00:26:08 -0800 (PST)
Received: from ?IPV6:2a01:e0a:3d9:2080:2842:da44:d7db:b175? ([2a01:e0a:3d9:2080:2842:da44:d7db:b175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8661caffsm123763705e9.5.2026.01.12.00.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:26:08 -0800 (PST)
Message-ID: <543d9e55-c858-40f9-8785-c9f636850120@linaro.org>
Date: Mon, 12 Jan 2026 09:26:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
From: Neil Armstrong <neil.armstrong@linaro.org>
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
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
 <2486dc4b-71f3-4cd9-8139-b397407d7e4d@linaro.org>
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
In-Reply-To: <2486dc4b-71f3-4cd9-8139-b397407d7e4d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/26 14:53, Neil Armstrong wrote:
> Hi,
> 
> On 1/7/26 09:05, Luca Weiss wrote:
>> Add the nodes for the UFS PHY and UFS host controller, along with the
>> ICE used for UFS.
>>
>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>> ---
>>   arch/arm64/boot/dts/qcom/milos.dtsi | 127 +++++++++++++++++++++++++++++++++++-
>>   1 file changed, 124 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
>> index e1a51d43943f..0f69deabb60c 100644
>> --- a/arch/arm64/boot/dts/qcom/milos.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
>> @@ -797,9 +797,9 @@ gcc: clock-controller@100000 {
>>                    <&sleep_clk>,
>>                    <0>, /* pcie_0_pipe_clk */
>>                    <0>, /* pcie_1_pipe_clk */
>> -                 <0>, /* ufs_phy_rx_symbol_0_clk */
>> -                 <0>, /* ufs_phy_rx_symbol_1_clk */
>> -                 <0>, /* ufs_phy_tx_symbol_0_clk */
>> +                 <&ufs_mem_phy 0>,
>> +                 <&ufs_mem_phy 1>,
>> +                 <&ufs_mem_phy 2>,
>>                    <0>; /* usb3_phy_wrapper_gcc_usb30_pipe_clk */
>>               #clock-cells = <1>;
>> @@ -1151,6 +1151,127 @@ aggre2_noc: interconnect@1700000 {
>>               qcom,bcm-voters = <&apps_bcm_voter>;
>>           };
>> +        ufs_mem_phy: phy@1d80000 {
>> +            compatible = "qcom,milos-qmp-ufs-phy";
>> +            reg = <0x0 0x01d80000 0x0 0x2000>;
>> +
>> +            clocks = <&rpmhcc RPMH_CXO_CLK>,
>> +                 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>> +                 <&tcsr TCSR_UFS_CLKREF_EN>;
>> +            clock-names = "ref",
>> +                      "ref_aux",
>> +                      "qref";
>> +
>> +            resets = <&ufs_mem_hc 0>;
>> +            reset-names = "ufsphy";
>> +
>> +            power-domains = <&gcc UFS_MEM_PHY_GDSC>;
>> +
>> +            #clock-cells = <1>;
>> +            #phy-cells = <0>;
>> +
>> +            status = "disabled";
>> +        };
>> +
>> +        ufs_mem_hc: ufshc@1d84000 {
>> +            compatible = "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
>> +            reg = <0x0 0x01d84000 0x0 0x3000>;
>> +
>> +            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
>> +
>> +            clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>> +                 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
>> +                 <&gcc GCC_UFS_PHY_AHB_CLK>,
>> +                 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
>> +                 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
>> +                 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>> +                 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
>> +                 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
>> +            clock-names = "core_clk",
>> +                      "bus_aggr_clk",
>> +                      "iface_clk",
>> +                      "core_clk_unipro",
>> +                      "ref_clk",
>> +                      "tx_lane0_sync_clk",
>> +                      "rx_lane0_sync_clk",
>> +                      "rx_lane1_sync_clk";
>> +
>> +            resets = <&gcc GCC_UFS_PHY_BCR>;
>> +            reset-names = "rst";
>> +
>> +            interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>> +                     &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>> +                    <&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
>> +                     &cnoc_cfg SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
>> +            interconnect-names = "ufs-ddr",
>> +                         "cpu-ufs";
>> +
>> +            power-domains = <&gcc UFS_PHY_GDSC>;
>> +            required-opps = <&rpmhpd_opp_nom>;
>> +
>> +            operating-points-v2 = <&ufs_opp_table>;
>> +
>> +            iommus = <&apps_smmu 0x60 0>;
> 
> dma-coherent ?
> 
> and no MCQ support ?

So, people just ignore my comment ?

Milos is based on SM8550, so it should have dma-coherent, for the MCQ
I hope they used the fixed added to the SM8650 UFS controller for MCQ.

Neil

> 
> <snip>
> 
> Thanks,
> Neil

