Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99DD86352;
	Mon, 20 Oct 2025 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760974869; cv=none; b=QsAkXHB+UhglNAGcqWHA2F5h7JvWrm7mluWPsYKMBzBXrtZQrYbhOKbHmjqlml9/YidP26I2T8ebOdyE+105dx09MiUiqYZCNCEfjnHMIlwd7InI2mrVKvgBBjBTbgdyAAqCnWgk8pks/zE0NR/LV/nuwHBXQUJxLYbstLH+UrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760974869; c=relaxed/simple;
	bh=Oo7DpZ4wl1wswOWuSb4aFqE1cYvWje2320z/a0W/Glo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=InTWmb4fh/UVPYTPUxjyNKh/QU4YW9SPbXIKqaKfFFicQDM99ygSYbIvSbMPmyJvx6zTWnjXLoYEBuoobkyet6U2SjWJhSzg1tkqXFGawic6OliowzUgI7I9lcEwzExaNomOeVahkBKk9+Ee6u2cLdUrTo66HjCRR+FFjmLEMO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vDdO+gK/; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vDdO+gK/"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cr05752FhzljBC1;
	Mon, 20 Oct 2025 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760974855; x=1763566856; bh=Oo7DpZ4wl1wswOWuSb4aFqE1
	cYvWje2320z/a0W/Glo=; b=vDdO+gK/7aLRcCYqexOk3vyB/qSdU1m71g/jSNSO
	WYA7nKpxkNrQs127L28ptZvN9LWzUJPJ3+/+/p5fjrZ8A/kEhFnrZ0MmpZv+1xvZ
	jMPv5odsVYbu6k5lpHWYCNVk/XAukCt0PnNiQGH0m7fI9/fJ9pOl0OllpUnL32sC
	FNMkeCMTD8CMgozwVMuqptLt8ntFgux8f5TpK1YO7+hlUr6BVn0buBxm3sJLkIlu
	Nj5FKVfHkAzQzi3hyYky5jWXqaHBORTRYJ/3f2TlAWRu/mCIs8xMz2opfK/tNJJb
	BPYpqW1A1UYXVV7F1JzmDKyz2vUfouC+TMJ5Nhr4bKWAiA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AT_bPrdYl-hz; Mon, 20 Oct 2025 15:40:55 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cr04l5K2pzlgqVl;
	Mon, 20 Oct 2025 15:40:38 +0000 (UTC)
Message-ID: <05167a77-f34e-4c75-aded-3c907c4ba446@acm.org>
Date: Mon, 20 Oct 2025 08:40:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] scsi: ufs: ufs-mediatek: Add UFS host support for
 MT8195 SoC
To: Macpaul Lin <macpaul.lin@mediatek.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Matthias Brugger
 <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Cc: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
 Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul@gmail.com>,
 MediaTek Chromebook Upstream
 <Project_Global_Chrome_Upstream_Group@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 1:57 AM, Macpaul Lin wrote:
> Add "mediatek,mt8195-ufshci" to the of_device_id table to enable
> support for MediaTek MT8195/MT8395 UFS host controller. This matches the
> device node entry in the MT8195/MT8395 device tree and allows proper driver
> binding.
Please always include a cover letter when posting a patch series. The
cover letter generated by git includes helpful information like a diffstat.

Thanks,

Bart.
