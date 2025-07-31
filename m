Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30D1241670
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 08:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753950477; cv=none; b=QbqNqUBEgFN2y2XJulG8B5ga6UZtJkygiEmPqWqatEkCqR8J/TT8lVTS2EJ4gdQJrPuT+ICjtlbMGRlTktQD4rICi/nGk6QpJREe1phy56H734sriTZAjcmtWENKanWkZ7UvKXyN5M5Ey1pSvhTV6Qu0+mf2Eg4GIezbR4IUc8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753950477; c=relaxed/simple;
	bh=m0VliDt6mG7e73Ft5cz8O655109qizhd2IELSJRaHqE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Vo8lcilSQ09E8+G9xQ3DIJVHq3qDbePlgYJWHkxey7GBEclR/Njxng5/4WHjbYgR6odSYkDS8AlLY138W1CyLWNw+ZX/ktp1QtpB7wB91kvqg3s3Vr169gvqnBmeFGqDnLBJu/hvQpNbkyZT63rZlMb17uAgpannTViCukZozKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cFLako8N; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cFLako8N"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a6cd1a6fecso546149f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 01:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753950473; x=1754555273; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=59VEHPWZZqDq/jb4P6PtlO3kvv48r5B/eFgvTOT42pE=;
        b=cFLako8NcXI+JP+YNuFRZe/3AJWyGZVDfZyk+ujwg4l+WkwgfMDj41766HFgdP4MoS
         w0g85H1nyZ7SCTuXSX63yUQdvbGFb6g87gDC5jTy0/8VyOp4/wnw1mlRLoAUdQ0YqG/X
         is4aS/O5mDRAClYuqepoYvhFYop654hpEmzFVdBICfxOUTz/Kcs2/38kslL8MdBceFj+
         6YP5cY011brSWe6RAk8mTrg+5UJ0MhdwA1mqdsU1a+p5h2RUJRa6SSPxZ4eKY1wdVwhG
         /XzqHOil+qqeCM3AzxOS/D4T6GMLkAaQkqvLGzC4VgJntdGNoIQNSisyGmjPCk75t8O3
         9lYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753950473; x=1754555273;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=59VEHPWZZqDq/jb4P6PtlO3kvv48r5B/eFgvTOT42pE=;
        b=AehCaocrnsN4cSYx4eLFuuBNmPTXKvvZShQb5LJe8h6Y5ahKvEgggjzDhS2ht3Vh7Y
         /+76Rp1n/u2M+Tv0y+bn9+2QcVij1BpBBB4Ow6cxl7MUgv+iLGr5w8wzk9U8RjgVPbjL
         7/TlYoJBp9o5dmZy6V7XgMxpjlplAtQeNym4ME5qIda1L5c6AbqTuZwCQGTq8d4UoOgz
         SU8CW0UOQ1qJVUoo5ZuSgHG8c0Ac7vv0laGUFnJcnuKd2pENWBwhSxPqADC364n1grmA
         P+D58a7w66V1TPcre9O/p2pNfaASLUwhmmiEEgYBWJ+Y87/bMecZdC0gJYkzdcoSQU04
         uMYw==
X-Forwarded-Encrypted: i=1; AJvYcCXEgkBXGQ8Cg32kWGS9yto9aWEXqL+sBWbyZX5e+BlWAs7jsyLcSuu7Yt1xLqWyyrmVLCKdTS2LEkw7@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrqm4haWUvAxt/gAGvl0OySAsavCnr8InkHrCKIg16SCcqiT8n
	DBGIMPTpssBzyjJo8FIOnZoLtKjWCrz6w96c4tAfXtiu8cEt4Z9M8t08eDGGjBwMYMc=
X-Gm-Gg: ASbGncsV5A2CLecdZvLBhaYoU0hUWrfcyti140LcQKHASCiCDHp0RdeKya7ZuAqPpX4
	JAtgusuv06mOthUBXYBXP12X7inzzJ+JlKuAqmxZoZQuxtHMbijQAdNmwhNtoEO6LmZ9bRX44ec
	7EgSqbTe8c5RFZbwR9TZJES2nMhm5lhPE70SqV79KTVsWhR1ZWlRoQBCWXgz/HoU7NkSeXYFJWn
	x7zCw2UQU2e/Sz0n+vHBtYO2SWEHd2OzVPlw56fzRYVG7x1CKygK1M4urIxF98wbPfxQmGt6Nmz
	rHh8wvoEXj+bNlDQwnCPMAsio6J/gDJP7HkOLNPe/YHXRTVIWQ9yW09COd7CcKYuTvCifCtJsmF
	DtNonNaN8Y0fDZkvyywzLYfilI5UoQNZvv4tiGh4ihfDo1BgzjY0Rhq/UATeWWeUPlhlVT4+xKb
	IfD1Xd7cI=
X-Google-Smtp-Source: AGHT+IHutITcGTP6sM1uPiPPQlQAOIps6AUtLnMPfzJ4YrdjZ/INr9hISLCa5ie3N9IayHVHJRzhQQ==
X-Received: by 2002:a5d:5d0a:0:b0:3b7:7d63:f4f2 with SMTP id ffacd0b85a97d-3b79502d719mr4843061f8f.48.1753950473206;
        Thu, 31 Jul 2025 01:27:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:5d4b:b132:363:7591? ([2a01:e0a:3d9:2080:5d4b:b132:363:7591])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3abec8sm1643212f8f.8.2025.07.31.01.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:27:52 -0700 (PDT)
Message-ID: <0f3a7ae4-08a1-401a-a41e-cb8db530de36@linaro.org>
Date: Thu, 31 Jul 2025 10:27:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH V1] ufs: core: Fix interrupt handling for MCQ Mode in
 ufshcd_intr
To: Nitin Rawat <quic_nitirawa@quicinc.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com, huobean@gmail.com, mani@kernel.org,
 martin.petersen@oracle.com, beanhuo@micron.com, peter.wang@mediatek.com,
 andre.draszik@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Palash Kambar <quic_pkambar@quicinc.com>
References: <20250728225711.29273-1-quic_nitirawa@quicinc.com>
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
In-Reply-To: <20250728225711.29273-1-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/07/2025 00:57, Nitin Rawat wrote:
> Commit 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service
> routine to a threaded IRQ handler") introduced a regression where
> the UFS interrupt status register (IS) was not cleared in
> ufshcd_intr() when operating in MCQ mode. As a result, the IS register
> remained uncleared.
> 
> This led to a persistent issue during UIC interrupts:
> ufshcd_is_auto_hibern8_error() consistently returned true because the
> UFSHCD_UIC_HIBERN8_MASK bit was set, while the active command was
> neither UIC_CMD_DME_HIBER_ENTER nor UIC_CMD_DME_HIBER_EXIT. This
> caused continuous auto hibern8 enter errors and device failed to boot.
> 
> To fix this, the patch ensures that the interrupt status register is
> properly cleared in the ufshcd_intr() function for both MCQ mode with
> ESI enabled.
> 
> [    4.553226] ufshcd-qcom 1d84000.ufs: ufshcd_check_errors: Auto
> Hibern8 Enter failed - status: 0x00000040, upmcrs: 0x00000001
> [    4.553229] ufshcd-qcom 1d84000.ufs: ufshcd_check_errors: saved_err
> 0x40 saved_uic_err 0x0
> [    4.553311] host_regs: 00000000: d5c7033f 20e0071f 00000400 00000000
> [    4.553312] host_regs: 00000010: 01000000 00010217 00000c96 00000000
> [    4.553314] host_regs: 00000020: 00000440 00170ef5 00000000 00000000
> [    4.553316] host_regs: 00000030: 0000010f 00000001 00000000 00000000
> [    4.553317] host_regs: 00000040: 00000000 00000000 00000000 00000000
> [    4.553319] host_regs: 00000050: fffdf000 0000000f 00000000 00000000
> [    4.553320] host_regs: 00000060: 00000001 80000000 00000000 00000000
> [    4.553322] host_regs: 00000070: fffde000 0000000f 00000000 00000000
> [    4.553323] host_regs: 00000080: 00000001 00000000 00000000 00000000
> [    4.553325] host_regs: 00000090: 00000002 d0020000 00000000 01930200
> 
> Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
> Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> ---
>   drivers/ufs/core/ufshcd.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index fd8015ed36a4..5413464d63c8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7145,14 +7145,19 @@ static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
>   static irqreturn_t ufshcd_intr(int irq, void *__hba)
>   {
>   	struct ufs_hba *hba = __hba;
> +	u32 intr_status, enabled_intr_status;
> 
>   	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
>   	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
>   		return IRQ_WAKE_THREAD;
> 
> +	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +	enabled_intr_status = intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> +
> +	ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> +
>   	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
> -	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
> -				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
> +	return ufshcd_sl_intr(hba, enabled_intr_status);
>   }
> 
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
> --
> 2.48.1
> 
> 

Thanks to [1], I was able to test this change on SM8650-QRD, and it fixed the issue:

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD

Thanks!
Neil

[1] https://lore.kernel.org/all/20250730082229.23475-1-quic_rdwivedi@quicinc.com/
