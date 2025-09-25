Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C552FB0B5
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815351; cv=none; b=e5guH0OOlhb8PhPyz08MhVUYpMsDkwMemPr4sGBsBvRL4guFo81BIlxfRzqWttYxdNcCukAkA2wvYWXI/qw/mGjcC06hNPTM/LIUWFFAJqj6cQBIbf3EEOD3fseX8ANiCRitzTqREpzCAQ6sTBPXQ7v5WxY/2kU7+OLDFcoRIqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815351; c=relaxed/simple;
	bh=JNJavTQjkknopqd0oPAIQcXO5xoI8oxuPjMPorcG+Ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mjHn5GriySATDNXQ8vukXM+fzuHc7GgnVI53MNNQiwcNH/tIShDiPdFSOhNWedm+eKUfbSLDTkk+vdCcY2y3Yg9yUlXwkcN7in6cmtL1FX4pB9hCpZw44k8qOusSvgGB/1Lpng2sQ2DaFPq0pVHG/MUlHrDkD87NXdMIqiUCTIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1+JeKSWi; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1+JeKSWi"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cXdS355M5zm0pJw;
	Thu, 25 Sep 2025 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758815344; x=1761407345; bh=JNJavTQjkknopqd0oPAIQcXO
	5xoI8oxuPjMPorcG+Ao=; b=1+JeKSWibrZVfErAUN4XyEsWCpGAEg2a4lkCqwj8
	OIyNgYY/ZSQALymCf7APRcppZqUWvXto9WdTvGAkRAjDxA5yqWMWKqppnOcN8p4P
	d29Ek/gMvhnLzC87fSJZX6ahQVCka2ITVQg0QY/jadcxqwIswgJjWm6hPFYzE/8A
	Lf2354m905SgoF6n1IkJpjwP8OCK2Id12/mKgPoyx4bMUr3rJhTRZin0GjdS0xpT
	ZOyU6410BB5xNx8IdgIeSm+rnK2++eFqIJp05cnHaGouAHveZcBJTndJDyvFvC1C
	dpRsU1tzuU7CmUEIoUv929DKDzdDvtbHDqgnPrZLXfHYVg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QXziTda_FYE4; Thu, 25 Sep 2025 15:49:04 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cXdRk626fzm0djt;
	Thu, 25 Sep 2025 15:48:49 +0000 (UTC)
Message-ID: <81e6af29-eb75-4149-8fbc-7e726fdd2acc@acm.org>
Date: Thu, 25 Sep 2025 08:48:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Fix runtime suspend error deadlock
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250925102420.3553715-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250925102420.3553715-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/25 3:22 AM, peter.wang@mediatek.com wrote:
> Tested-by: Bart Van Assche <bvanassche@acm.org>

Did I ever claim that I tested this patch? I think the Tested-by tag
should be removed.

Anyway, since this patch looks good to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
