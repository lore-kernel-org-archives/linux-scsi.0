Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473A35B650;
	Wed, 25 Feb 2026 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772023255; cv=none; b=V3KF7590dicONq7unI8bxIHqAUwZUUuEWOyR35GeVrdmpPKw1RMmlq2B//AyuioVOnkBLppfA/js8P3y86hyXVIV2VdM4R+43c4Z9Vu9gXy/FCiwq8bQPMqvJO9JrNrII3oW2yPd3rU+v3n5HX+IoT642B+glNVO/v7JcZ8Z7nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772023255; c=relaxed/simple;
	bh=ngaopgY039OjChM8qBLj6ujB7B8vDxU3MnbrCR2xlPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B7vOCjZ7Txx1JU7/Zh7LUOB+J+n+X1keQ9XHNmzcU6BLtXu8OKP99sFBGuhLyokuYxeLiXBZryyWn/RMzfRlzPgv19FEoqCUJWdMY6d/AI7uwDK+bhZ2nTbZO3Y1d+GF3I9gd3S/N8+TBL+zJtt5YsUE2pHcU9YOZ96oh5N5WfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=pWdD6mGI; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="pWdD6mGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772023252;
	bh=ngaopgY039OjChM8qBLj6ujB7B8vDxU3MnbrCR2xlPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pWdD6mGI99dJH6qGsQBVWGzvUP0BjC6j8ll7dXJ7r3qUj2dev2m56xdT5JREZegZx
	 oJHt7qifVuU+9NB3qfgmjgMXQelsciYLzjO3ZruDropQ7r7UbCYbRLWcG+kBCJXxyr
	 Z54s0yBU5k8OUs0qdu+im92weAONwkkcxqBj9x4v8l77u3xbTmcqQDoGrbX2S2VFmq
	 KAdm5Yi9IDKgkyG5sT/GcbcyH8gFV4j9LQlQretgY/ZDuqATS3ZsxBmZygEXC358kU
	 Y5V20tbJNW/YGHyIbL0x7Yjv2cTXyjT/BH2Ouy/jlwDtljXgjA2aDG7TRGjPMNj4OC
	 MKc3oKTR85SoQ==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A013417E0BA2;
	Wed, 25 Feb 2026 13:40:51 +0100 (CET)
Message-ID: <cad2e275-8b5d-4023-b3da-a191bfd065c5@collabora.com>
Date: Wed, 25 Feb 2026 13:40:51 +0100
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
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "broonie@kernel.org" <broonie@kernel.org>
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
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <5d9723fd6b4ff8430889efb33e0fc93a10c4a880.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 25/02/26 11:35, Peter Wang (王信友) ha scritto:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
>> @@ -187,6 +187,7 @@ struct ufs_mtk_host {
>>   	u16 ref_clk_gating_wait_us;
>>   	u32 ip_ver;
>>   	bool legacy_ip_ver;
>> +	u32 hibernate_idle_timer;
> 
> The name hibernate_idle_timer is somewhat confusing in
> terms of its intended use. I would suggest using
> backup_ahit or saved_ahit instead.
> 

In my opinion "ahit" is way less readable than "hibernate_idle_timer".

The hibernate_idle_timer member here stores the AUTO HIBERNATE IDLE TIMER, and
there is no other possible hibernation state in this driver.

Not sure why this could ever be confusing in terms of its intended use: its
intended use is to store the (auto) hibern8 idle timer, and the member is called
hibernate_idle_timer.

In my eyes, that matches 1:1 with its usage. Loud and clear.

Regards,
Angelo

> Thanks
> Peter
> 


