Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F4912E7E;
	Fri,  9 Aug 2024 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723182248; cv=none; b=iRIDm7BAuEHauA8JL3qyLNqwZZBZsw2TwxD8nhDBtGGXQuBycx6FjI2JuV9Tj1zUJb5eB+QF9zlDah82+R8WMlLU06bD9eEmG25pqfydflp/YQEipWbOH72NRNYnyYtUMP+owupTOT1qHXfRYTgGOrJmre6wlUACnux+opyk5BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723182248; c=relaxed/simple;
	bh=ce1dczaiqaHq/b4u6sE/IFDSyphVayC0ApbaS3hZQ30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgnPbLQ6Fn9ek230jdRaraD7KwwNd+RpuuHRzkYj3Ps6DcRqZsTg1ZePl7tFFfyatVPZ4HStkO4UsHet3N3WdcuhdxWZJeeJqtqE+JTuJJVCO/VcAMdakULuUVYhUHmt7wHEiiHpqU+th+xYGsXzIUvsJhApNZod4gmUjqOgqfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE8bmLk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE8bmLk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF67C32782;
	Fri,  9 Aug 2024 05:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723182248;
	bh=ce1dczaiqaHq/b4u6sE/IFDSyphVayC0ApbaS3hZQ30=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kE8bmLk/lJ6ygH9ZN0lMzWivl4SgsAqma4mSHhFN6/3cUtdhEx/rb7UU8vhHiSSnz
	 Z6jvgFXGnR045cUUf2u5h5Uycwx100JZFrKsjNf1Bx69pYOMUrx9HrEjsNK6jszINI
	 Z78ki7MLPa7rRH1bmz7iofHooDbciTHMc7f3a/hMYidh9/hmXZY6+BdXutCafveUt6
	 IrG/rt1WYkn9qUNpzUfgvAhVAcR/zaj7pw1IEa3Rtn6RjW+cmP+f+UByydh+J4LMfv
	 QSkUBcoGsbyuGpXQQqT7DUbZGkaWPqt0UqdbWe6ckcgR1zOtGRWGY0oFn0gFwQv0Du
	 wZxaGTTw5Wl8Q==
Message-ID: <4de61c50-0f84-40b6-8993-d4e82cf54be0@kernel.org>
Date: Fri, 9 Aug 2024 07:44:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
To: Shawn Lin <shawn.lin@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <93a16a4a-6a12-446f-bfc9-e8aa907e0598@kernel.org>
 <a8305f20-ea58-40b5-93f6-2c44f151219c@rock-chips.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <a8305f20-ea58-40b5-93f6-2c44f151219c@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/08/2024 02:53, Shawn Lin wrote:
> 在 2024/8/8 18:36, Krzysztof Kozlowski 写道:
>> On 08/08/2024 05:52, Shawn Lin wrote:
>>> RK3576 contains a UFS controller, add init support fot it.
>>>
>>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>>>
>>
>> ...
>>
>>> +	err = clk_prepare_enable(host->ref_out_clk);
>>> +	if (err)
>>> +		return dev_err_probe(dev, err, "failed to enable ref out clock\n");
>>> +
>>> +	host->rst_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);
>>> +	if (IS_ERR(host->rst_gpio)) {
>>> +		dev_err_probe(&pdev->dev, PTR_ERR(host->rst_gpio),
>>> +				"invalid reset-gpios property in node\n");
>>> +		err = PTR_ERR(host->rst_gpio);
>>
>> No. Look at your code above - you have return dev_err_probe, so logical
>> is that the syntax is err = dev_err_probe. Don't over-complicate the code.
>>
>> Anyway, this is suspicious. You already have resets with four resets
>> (!!!) and you claim you have fifth reset - GPIO? This looks just wrong,
>> like you represent some properties which do not belong here.
>>
> 
> Thanks for the feadback.
> 
> Yes, we have 4 resets for controller, and one gpio to reset the
> device. It happened to be called reset-gpios in DT but can be
> any name if you like it to be. I added reset-gpios as a required one
> listed in dt-bindings file, in patch 2.

Then explain in the bindings what this reset-gpios is for.
> 
> 
>  > Also, why do you leave the device in the reset state? Logical one
> means
>  > - reset is asserted. This applies to ufs_rockchip_device_reset() as > 
> well
>  > - that's just wrong code.
> 
> 
> No, I tested it in linux-net and the output is HIGH, and leave the
> device in active state.
> 
> In dts, we add:
> reset-gpios = <&gpio4 RK_PD0 GPIO_ACTIVE_HIGH>;

? Don't use random values, what is type of the reset line?

> 
> so gpiod_set_value_cansleep(host->rst_gpio, 1) -> output HIGH for
> gpio4_d0. Based on your comment, we should change the dts to use
> GPIO_ACTIVE_LOW and then gpiod_set_value_cansleep（host->rst_gpio, 0）
> 
> 
> Both can work, however IMO, isn't logical one means HIGH level in line 
> more human readable?

You mix logical level and line level.

If this is reset GPIO, then 1 means asserted so your code is bogus.

Maybe the the line is active low?

> 
> 
> 
>> Where is your DTS so we can validate it?
>>
> 
> Will add it in the next version, as now the rk3576.dtsi is under
> reviewed and UFS node was not added. So I was afraid to interfere
> with that patch and just wanted to add incremental patch once
> rk3576.dtsi got merged.
> 
>> Best regards,
>> Krzysztof
>>

Best regards,
Krzysztof

