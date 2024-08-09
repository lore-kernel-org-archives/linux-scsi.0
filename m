Received: from mail-m25486.xmail.ntesmail.com (mail-m25486.xmail.ntesmail.com [103.129.254.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813AC748F;
	Fri,  9 Aug 2024 01:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.129.254.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723165820; cv=none; b=S7IePLn7b2ZBd4twk2pI85rpnurByIIwLhVhdl2caqRiT+dqCz5CT6jBpQ4ao4Rd8jBdXqV0ZcbPogeA06SS7/JIV55BDvfFnj0YGhuODcpzxogQuqAaqRR09nhTpDKUX69EWzWV0x3cW96nR1kShc4SGQASBqMaKmfDvwkUQjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723165820; c=relaxed/simple;
	bh=KlEQ+D4Je6mwZIsRxTWmFaT5+xcMxIxm6HVAXnIsROw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F8kGnB1UhQjSjcoWq4FsAVqRl5Mw1kgnYlddrVep4IZqM4OcyKq+UW6/7vrI/DajpBy6BmL0OROSrS12QHlcWF5ZYta19944qECyzm5M264ddLxp2j2jZKw1ZR9c9NwmXtj9UGtpXTbMYZE1gmERAa7rVJFlxumdmMXDXEW0eu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=PjW7R72f; arc=none smtp.client-ip=103.129.254.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="PjW7R72f"
DKIM-Signature: a=rsa-sha256;
	b=PjW7R72fDWmkAA3u5H/IGzBoAANM/LQEhVfEcKg844Yg03yeyOR2bNDlyYqsyOhhDDvds/sVIoZ7TrmEE++lNokCPZoUATlN58MlIdYA9XmsbF9RSbqZT8810sPbO56P76i0ndFXLbmxCpWhf2Fbar8qjZzZBFnHPwmNFAjUbaY=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=cy550DiWB2ZzXUSUZQc3XZMosj7sndMJZrv8tyVP9mg=;
	h=date:mime-version:subject:message-id:from;
Received: from [172.16.12.69] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 7E561460205;
	Fri,  9 Aug 2024 08:53:05 +0800 (CST)
Message-ID: <a8305f20-ea58-40b5-93f6-2c44f151219c@rock-chips.com>
Date: Fri, 9 Aug 2024 08:53:05 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
To: Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <93a16a4a-6a12-446f-bfc9-e8aa907e0598@kernel.org>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <93a16a4a-6a12-446f-bfc9-e8aa907e0598@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQ0wYS1ZLTR9MTRlKQh5LThlWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91349fffc503aekunm7e561460205
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDY6Axw4CDI2Vgk3NCoXUSgO
	DQ9PCghVSlVKTElISk1PTENMSU9IVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQU9MTEs3Bg++

在 2024/8/8 18:36, Krzysztof Kozlowski 写道:
> On 08/08/2024 05:52, Shawn Lin wrote:
>> RK3576 contains a UFS controller, add init support fot it.
>>
>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>>
> 
> ...
> 
>> +	err = clk_prepare_enable(host->ref_out_clk);
>> +	if (err)
>> +		return dev_err_probe(dev, err, "failed to enable ref out clock\n");
>> +
>> +	host->rst_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);
>> +	if (IS_ERR(host->rst_gpio)) {
>> +		dev_err_probe(&pdev->dev, PTR_ERR(host->rst_gpio),
>> +				"invalid reset-gpios property in node\n");
>> +		err = PTR_ERR(host->rst_gpio);
> 
> No. Look at your code above - you have return dev_err_probe, so logical
> is that the syntax is err = dev_err_probe. Don't over-complicate the code.
> 
> Anyway, this is suspicious. You already have resets with four resets
> (!!!) and you claim you have fifth reset - GPIO? This looks just wrong,
> like you represent some properties which do not belong here.
> 

Thanks for the feadback.

Yes, we have 4 resets for controller, and one gpio to reset the
device. It happened to be called reset-gpios in DT but can be
any name if you like it to be. I added reset-gpios as a required one
listed in dt-bindings file, in patch 2.


 > Also, why do you leave the device in the reset state? Logical one
means
 > - reset is asserted. This applies to ufs_rockchip_device_reset() as > 
well
 > - that's just wrong code.


No, I tested it in linux-net and the output is HIGH, and leave the
device in active state.

In dts, we add:
reset-gpios = <&gpio4 RK_PD0 GPIO_ACTIVE_HIGH>;

so gpiod_set_value_cansleep(host->rst_gpio, 1) -> output HIGH for
gpio4_d0. Based on your comment, we should change the dts to use
GPIO_ACTIVE_LOW and then gpiod_set_value_cansleep（host->rst_gpio, 0）


Both can work, however IMO, isn't logical one means HIGH level in line 
more human readable?



> Where is your DTS so we can validate it?
> 

Will add it in the next version, as now the rk3576.dtsi is under
reviewed and UFS node was not added. So I was afraid to interfere
with that patch and just wanted to add incremental patch once
rk3576.dtsi got merged.

> Best regards,
> Krzysztof
> 
