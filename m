Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217F739902C;
	Wed, 25 Feb 2026 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772023058; cv=none; b=nKU+IO6J1iYexcnymg7P5leZ97os+XPwSF7KNsaEk7bk7JU4m0gdDFt2SLECpVbRQPOPSFlZMS0Sn8FTC6OHGHcFfSV/cNKJp0PsrHjSXS5uuTEFv2VcMe0OxCW5ywvFUlSDSvYbb/iYLr4VBf+CxmxKdXQxpssgTyYD0e02xsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772023058; c=relaxed/simple;
	bh=bZmckL3Yy8Teh5h9dCs5VOGu35lRyyRphjRBHRpxOD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLSrSCy4VoOEQV0fpu4dRsT9ZgexuCeTo9AaZW0jrniRAM7esmg1N6+1jxzaaOkD97Dsxnhv4iisGHTTcs1UorjVNSgYXRj+eCYA0bA5Cw/INk5bpq8iWzdloRfUZVUQ1o1TQ1HWqvdsfTVXMq0lRNS65SFPfQdjUVwcA6/Lnt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=jbVLFS2M; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="jbVLFS2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772023055;
	bh=bZmckL3Yy8Teh5h9dCs5VOGu35lRyyRphjRBHRpxOD0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jbVLFS2MsxEpQj+caszgA5d0ZbkwnS2Zr/hl9FkzC6cS4XZXj3onpz4CU7rPdQVKc
	 2iXclG/fHvfgyBQ0RVuylUQXOfKwjb84ZHaCaQPwxxoxfs874/cmZqnUsVJsVDjUEZ
	 RYspmveWD0K2HGdfJ0VxLxU8TaCpbfaZZpX6cYdDJIf41/V+5TXyVtDWno/uaBFb76
	 MR6b4vof+Kn015TGbuWZ4AbvCLprACkh30T66pjYS7LdmIACy90PjA30DcGBQY0yrk
	 pvZXuR7NH1VX3q6FIgpBhmC71XuB7H+6ZZRWSRrQifKRXEq4J5uEUkWOBQ79s3Irqy
	 dD9PMWFMjXkIw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 47CA017E012E;
	Wed, 25 Feb 2026 13:37:34 +0100 (CET)
Message-ID: <edf07a47-77be-4acc-8825-b14a5d1838df@collabora.com>
Date: Wed, 25 Feb 2026 13:37:33 +0100
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
 <20260216-mt8196-ufs-v7-18-b5f2907c6da7@collabora.com>
 <010d77378b9cca477439b92d92c8f5bfb2d4df65.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <010d77378b9cca477439b92d92c8f5bfb2d4df65.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 25/02/26 11:34, Peter Wang (王信友) ha scritto:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
>> @@ -519,15 +519,13 @@ static void ufs_mtk_boost_crypt(struct ufs_hba
>> *hba, bool boost)
>>   {
>>   	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>>   	struct ufs_mtk_crypt_cfg *cfg;
>> -	struct regulator *reg;
>>   	int volt, ret;
>>   
>> -	if (!ufs_mtk_is_boost_crypt_enabled(hba))
>> +	if (!ufs_mtk_is_boost_crypt_enabled(hba) || !host-
>>> reg_vcore)
>>   		return;
> 
> If host->reg_vcore is NULL,
> should ufs_mtk_is_boost_crypt_enabled be false?
> So we don’t need to check both, right?

We need to check both because UFS_MTK_CAP_BOOST_CRYPT_ENGINE depends on:
  1. reg_vcore
  2. clocks (crypt_mux, crypt_lp, crypt_perf).

Failing to check for both ufs_mtk_is_boost_crypt_enabled() and reg_vcore here
will introduce a bug that may result in storage corruption.

So yes, Nicolas is checking both because it is *required* to check both.

Regards,
Angelo
