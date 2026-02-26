Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B99399024;
	Thu, 26 Feb 2026 10:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772102012; cv=none; b=njIoD0S7WRFBx2/tzWveCVwrZvlwIZvPLRM1/2ibW8zCcyieu43jeir6AgGlUZdUDWeHI0FRowCEzAoWi1bzOHA/hG6hRITZPyiepRORTMFC+QwhEQBxo0yjiwodOe2i/WYcBFRvfBuZMOhmO5GnAeqFXciQ44Bh3g9I8PPbrRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772102012; c=relaxed/simple;
	bh=jdsbqMmee99OyhJwJac7k9/iwfoy7HEhr67oW7RcG5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V2wQeoAI4ZjUpuZgPG2/P0ETDxqu+PqD4Zls6mpIKKs3IhmxrJSrHx+M8A1nhxci5zJMEjnMAcEaMSooclwICJND3hHNcL6gN4hLx78p/0i3XiPFtSINXwdryOyOxelBM5Iu2tA+o12xUN1S959UxIqyc0OJ1nRtMe61uCgJOws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=PRHn6pu+; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="PRHn6pu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772102009;
	bh=jdsbqMmee99OyhJwJac7k9/iwfoy7HEhr67oW7RcG5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PRHn6pu+LYe1i99VPr8a907RdPH5EhiuOOyQtA7a/NK/fnXla5CncaTSQKWOpYLQR
	 yLbX7w4Xe9MowggMHpLaITfeEpI+vsE0HWZUuixZchr0IlNWYy621A3ihrW9g7yvLE
	 CnJT3vghjIDsu/lmOBoB0OPGCB6zUTciwjtb27n7mBeY/enrvY4dfDucHEFtrbW+AX
	 c11jnZBAwJk2LQgPKxdFbQoEgV4ItyB2JHLJV9tLiX8kXhxpE9C1t/c9gxnUROXJqf
	 narGfuanBg48j2NvI4RInpxAiTp4PPsU2ExWCANyvvLuSv1UNVQEHNyJMV2QQ+JKGm
	 48XTfhIxKJXcw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EB06017E0097;
	Thu, 26 Feb 2026 11:33:28 +0100 (CET)
Message-ID: <20e7b970-df30-455e-8067-128de2dca022@collabora.com>
Date: Thu, 26 Feb 2026 11:33:28 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 18/23] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 =?UTF-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "kernel@collabora.com" <kernel@collabora.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-18-b5f2907c6da7@collabora.com>
 <010d77378b9cca477439b92d92c8f5bfb2d4df65.camel@mediatek.com>
 <edf07a47-77be-4acc-8825-b14a5d1838df@collabora.com>
 <c7214effa728b74e753abc0dee8d655e036ca7fb.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <c7214effa728b74e753abc0dee8d655e036ca7fb.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 26/02/26 04:45, Peter Wang (王信友) ha scritto:
> On Wed, 2026-02-25 at 13:37 +0100, AngeloGioacchino Del Regno wrote:
>> We need to check both because UFS_MTK_CAP_BOOST_CRYPT_ENGINE depends
>> on:
>>    1. reg_vcore
>>    2. clocks (crypt_mux, crypt_lp, crypt_perf).
>>
>> Failing to check for both ufs_mtk_is_boost_crypt_enabled() and
>> reg_vcore here
>> will introduce a bug that may result in storage corruption.
>>
>> So yes, Nicolas is checking both because it is *required* to check
>> both.
>>
>> Regards,
>> Angelo
> 
> Hi AngeloGioacchino,
> 
> To clarify, BCE stands for UFS_MTK_CAP_BOOST_CRYPT_ENGINE.
> 
> BCE     reg_vcore   Action
> true	true	    If check is false, continue
> true	false	    This case cannot happen (X)
> false	true	    If check is true, return
> false	false	    If check is true, return
> Therefore, we only need to check whether BCE is
> true (to continue) or false (to return).
> 

Thanks for the information.

Now I agree. There's no need to check for that twice, as the cap is set
only when all clocks and when reg_vcore is not NULL - I missed the first
lines of the ufs_mtk_init_boost_crypt_function() from this patch, where
Nicolas is adding a check for that at the very beginning of this function.

This means that the UFS_MTK_CAP_BOOST_CRYPT_ENGINE flag is being set only
when all of the prerequisites (reg_vcore and clocks) are satisfied.

I agree with you, Peter, there's no need to check for both the vreg and
caps, as the cap can only be set if the vreg+clocks are present.

Nicolas, can you please fix that and send a v8 ASAP?

Thanks,
Angelo

> Thanks
> Peter


