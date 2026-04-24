Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3920A25DB12;
	Fri, 24 Apr 2026 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777071370; cv=none; b=VRJKpS2xki9YmfHDKhZkIz2AIpceuVzoDlFKCeVehKMXCFoDEleRBw9yAyRnVN5AfGdhouua3/i09oaZVrmUZvZMRILdYeaxUTscd0s+0WIv6fMtD4NOaOtFIUE7AZw4TsHl22uuJmZcDtFgshsx6ntVZP/J5iEIJxmSlqDp1VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777071370; c=relaxed/simple;
	bh=lqL2mlSpUN8CVPORkmc2oKWN9yGLQSNrcwCUuZmT0D4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ddljO7MXu8VDjKK9aczAr4DecczcC3ZMhxRMJoQzNccFyskIShVgAHqB6S2GJeLUGIMwtA/GF9AkjFQvMP4N0mT6iuAlnWfmEihdklxe6cCt51SAY+vky3yfMTatPeKrv75Svwbe3zndZJp5ygevXf2nZph4+8vBfCoOGpYvt7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MaZ7L+BV; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MaZ7L+BV"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2SxN4ZKsz1XM0nq;
	Fri, 24 Apr 2026 22:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777071361; x=1779663362; bh=lqL2mlSpUN8CVPORkmc2oKWN
	9yGLQSNrcwCUuZmT0D4=; b=MaZ7L+BVDIGalsO2C+WMEUaOVXljHEzOzXoIN0gf
	rHH4rLLwldCCavvU//v2uWVb8vKV9/lU0K4wLEOJ/zEET93cz/4/ZDxbsorCuV/K
	lr0fHZWY/69m4uFLZQXIbh1Tv8sOPoFWCxvvKUw6PIFlheYRJiq67dYL9Li9kKPV
	wN/MxK3JLXCik76EpganxgnUlVk6FC9zGIVFc01NdK66v4FC8jpcgzC0zQCq9Ujd
	ZudzmHryZa/xQreq6gmExLm3/4LjIBMp1m9fuVrBExkiQNfn52qZmwDjMaTcatRF
	cP3GLhmf+3c8pw68hD8Nj448uolKIAsWObabFjpaoxH0Ig==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GasHTLTR0J09; Fri, 24 Apr 2026 22:56:01 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sx93WmYz1XM2FN;
	Fri, 24 Apr 2026 22:55:55 +0000 (UTC)
Message-ID: <a496a84b-66c8-452e-99b6-622550afeae5@acm.org>
Date: Fri, 24 Apr 2026 15:55:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb()"
To: ed.tsai@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Avri Altman <avri.altman@sandisk.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 peter.wang@mediatek.com, alice.chao@mediatek.com, naomi.chu@mediatek.com,
 chun-hung.wu@mediatek.com, linux-scsi@vger.kernel.org
References: <20260424063603.382328-2-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260424063603.382328-2-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/26 11:35 PM, ed.tsai@mediatek.com wrote:
> Note that these DMA addresses are only used in ufshcd_print_tr() for
> error logging, so the impact is limited to misleading error logs.

Instead of fixing these offsets, please remove the ucd_rsp_dma_addr and
ucd_prdt_dma_addr members from struct ufshcd_lrb.

Thanks,

Bart.
