Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DCD32693A;
	Tue, 23 Dec 2025 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766491499; cv=none; b=FKiHDpcR8K639QlW+QFL/sJ3s6fldbDDnzMlPdSjW7hauzClPllW7aIQaJ3MMzs0ykxqqdkvTOiE5GyrKStkd9lxdwX8KMFmHYBxiM7/8uLavwKoTKwFcpUTkAC0oqhFmu5aE7lsasg4ltLvnsySgIyjPDQovC7Ceg9wN81YOF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766491499; c=relaxed/simple;
	bh=YBuvzt/NhTYWhzP+XmcIESOEGPy6LMoYjTaUBOofg0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=igElAJ5SatmcooHM4Z4KrGRHMBWRGqIVP/cB1d4FJ84HGHVAPjBzUlM5pZ+TeC+6PHx8GzfAubMCBtvEX1neHu4Wc6rtv5pzTMKBf6MMMeQSUQfRph233TNdJy9OO6ChPJkFgU+fc3RGCztwaMWjx5zB8k1ktfRT/MSKZHvvZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=jEOrOCkF; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="jEOrOCkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1766491495;
	bh=YBuvzt/NhTYWhzP+XmcIESOEGPy6LMoYjTaUBOofg0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jEOrOCkFycldj1VQlKzLPZ2QbJwhvQDjQ9yat1fYpn21EmGho3vxEKzrBIKqTYatI
	 wqSjnv9K40+cNzQB2bqONNJEB6cXB3g1My5TnMbmFuLkROFSqxxBBrj+gu2GFpbOEd
	 9b2U3/U8XN1BWup+cbV00mXqXJ+BuSgZQLsiO4nRgjgtErolMNBK0Dyxbunhor64GA
	 aXFyXyDhtJjKVOofDnRzC32Xfl9P8s3gEeUJ/5Hr2UtVtwcgef74+C7j2/SYcLJlRU
	 +/un8LadHThntKUc7/SgNGBZKMt7ceYLm4eWpDWFg759Rtk9W0IaDBOZ+/KQZ/D73o
	 6d6/oofkxuPkQ==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D93B617E0125;
	Tue, 23 Dec 2025 13:04:53 +0100 (CET)
Message-ID: <ddff4617-884d-4ac2-bc24-28f669104b2e@collabora.com>
Date: Tue, 23 Dec 2025 13:04:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/25] MediaTek UFS Cleanup and MT8196 Enablement
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>,
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 kernel@collabora.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-phy@lists.infradead.org
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 18/12/25 13:54, Nicolas Frattaroli ha scritto:
> In this series, the existing MediaTek UFS binding is expanded and
> completed to correctly describe not just the existing compatibles, but
> also to introduce a new compatible in the from of the MT8196 SoC.
> 
> The resets, which until now were completely absent from both the UFS
> host controller binding and the UFS PHY binding, are introduced to both.
> This also means the driver's undocumented and, in mainline, unused reset
> logic is reworked. In particular, the PHY reset is no longer a reset of
> the host controller node, but of the PHY node.
> 
> This means the host controller can reset the PHY through the common PHY
> framework.
> 
> The resets remain optional.
> 
> Additionally, a massive number of driver cleanups are introduced. These
> were prompted by me inspecting the driver more closely as I was
> adjusting it to correspond to the binding.
> 
> The driver still implements vendor properties that are undocumented in
> the binding. I did not touch most of those, as I neither want to
> convince the bindings maintainers that they are needed without knowing
> precisely what they're for, nor do I want to argue with the driver
> authors when removing them.
> 
> Due to the "Marie Kondo with a chainsaw" nature of the driver cleanup
> patches, I humbly request that reviewers do not comment on displeasing
> code they see in the context portion of a patch before they've read the
> whole patch series, as that displeasing code may in fact be reworked in
> a subsequent patch of this series. Please keep comments focused on the
> changed lines of the diff; I know there's more that can be done, but it
> doesn't necessarily need to be part of this series.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
> Changes in v4:
> - bindings: Redo the supply situation, as the avdd pins don't describe
>    the vcc(q2) card supplies.
> - bindings: format clock in mt8196 example more tersely.
> - phy: use devm_reset_control_get_optional_exclusive directly
> - driver: get and enable/disable the aforementioned avdd supplies.
> - Link to v3: https://lore.kernel.org/r/20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com
> 
> Changes in v3:
> - Split mediatek,ufs bindings change into two patches, one for
>    completing the existing binding, one for the MT8196
> - Add over a dozen driver cleanup patches
> - Add explicit support for the MT8196 compatible to the driver
> - Note: next-20251023, on which I based this, currently has a broken
>    build due to an unrelated OPP core change that was merged with no
>    build testing. I can't use next-20251022 either, as that lacks the
>    recent mediatek UFS changes. It is what it is.
> - Link to v2: https://lore.kernel.org/r/20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com
> 
> Changes in v2:
> - Reorder define in mtk_sip_svc.h
> - Use bulk reset APIs in UFS host driver
> - Link to v1: https://lore.kernel.org/r/20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com
> 

Whole series is

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


