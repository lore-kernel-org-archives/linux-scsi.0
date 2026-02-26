Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4BF2949E0;
	Thu, 26 Feb 2026 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772102171; cv=none; b=duqBMMB++qNMg5a5wY66I06xm7JTYiC71p+gObxpB4MV6eEefxsppdy3D647N6PgEhAKdwykit93XlsGUyzpF/iG4b8uNh/txqaBko9u9ls9Lh6ef6Cgf8qGgAy8Lpc7N7Z1tP05f9OqAFsDn3yxwxWOJU9zHup2aytSCCNBNXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772102171; c=relaxed/simple;
	bh=W3qLjNuC+QLK2F8P217EOXE0d8RIhLDiKC2NEPOx7v8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaSQLnQT6KuMGn0G64HJcfjySrlyUUgN/L2ag7398K4Gcln2FEhEDry6l3HsCys+99YEHU8J2JOLNgAvJ9bFAj9Zy1gAg1JUvY5KAzyeGBo+jTVmopCk1PzxzlloQifuTN97+qD72n7wUz8UEE44iRy5ilDlcECngGlxZeGdUt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=G3B4blNb; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="G3B4blNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772102169;
	bh=W3qLjNuC+QLK2F8P217EOXE0d8RIhLDiKC2NEPOx7v8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G3B4blNbzGIfSFsN2Pq23YbXZim4VHupb3i2mKyKj4xFv4ddYl4Sus69IZSY4lw7t
	 6i3gpratx3W9zv3kXHtvbOfl9x7tdqVZqqI21laWGAoq/8yUCaCC9bd0OqJM3K8qaT
	 g/FFF2doYJdQTsguQe+VkqThZ94g1f5Rng8kQXTj93PmZ+7sM+oa4TswUvr1tDvYfa
	 oBWqzoOAdgoPg10cd8Vk1HprIvxxB0YEa3NsPoWq2O9uwpXi3Djqf0LodAgvm4nL3s
	 F923l+cXyGnxkL14T07f6d3l4PLUpzdDw/rJMFjqYdv2NDs/AmzXSYMLGfdBq34uWs
	 e1XlOztdw9ebw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 24C5817E03E5;
	Thu, 26 Feb 2026 11:36:08 +0100 (CET)
Message-ID: <48e8f40b-f5f3-42b5-a97b-7a25d1dc0fb8@collabora.com>
Date: Thu, 26 Feb 2026 11:36:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
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
 <20260216-mt8196-ufs-v7-20-b5f2907c6da7@collabora.com>
 <5d9723fd6b4ff8430889efb33e0fc93a10c4a880.camel@mediatek.com>
 <cad2e275-8b5d-4023-b3da-a191bfd065c5@collabora.com>
 <6297edc9c2d6d1a323f188ef411205701a629d88.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <6297edc9c2d6d1a323f188ef411205701a629d88.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 26/02/26 04:46, Peter Wang (王信友) ha scritto:
> On Wed, 2026-02-25 at 13:40 +0100, AngeloGioacchino Del Regno wrote:
>> In my opinion "ahit" is way less readable than
>> "hibernate_idle_timer".
>>
>> The hibernate_idle_timer member here stores the AUTO HIBERNATE IDLE
>> TIMER, and
>> there is no other possible hibernation state in this driver.
>>
>> Not sure why this could ever be confusing in terms of its intended
>> use: its
>> intended use is to store the (auto) hibern8 idle timer, and the
>> member is called
>> hibernate_idle_timer.
>>
>> In my eyes, that matches 1:1 with its usage. Loud and clear.
>>
>> Regards,
>> Angelo
>>
>>
> 
> Hi AngeloGioacchino,
> 
> If you want to refer to the AUTO HIBERNATE IDLE TIMER,
> then you cannot omit "auto" because the UFS driver also
> has a manual hibernate method.
> However, "AUTO HIBERNATE IDLE TIMER" is too long,
> and we often use "ahit" instead (which is also used in
> the UFSHCI spec). For example:
> https://elixir.bootlin.com/linux/v6.19.3/source/include/ufs/ufshcd.h#L978
> 
> So, if you want to distinguish it from hba->ahit, I suggest
> using backup_ahit or saved_ahit instead.
> 

Okay, does "saved_auto_hibern8_idle_tmr" sound good for you instead?

Regards,
Angelo

> Thanks
> Peter

