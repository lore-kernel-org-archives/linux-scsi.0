Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C196F1B94F;
	Fri, 28 Jun 2024 19:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602759; cv=none; b=RXMoDZTyf51R26cr4OCHZSTBfTWbGhcrhh+7HJy+AxYdISrXRNpLLAhHz54wkQfL78kUDxN111Qzjg3XPRjkKRJRW4078Gps8AyoNPlGsuX2G8U/sTiSVyd/f9EVLSH7dplhZKfYyvZZ2ZuIzjfE51jW33kGPLRu8zKwkT85TYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602759; c=relaxed/simple;
	bh=ldQrrjqyWDTT6DvaUs37IaURxkD/yqnnKpMMKKsIF3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o/uOPiCf+/D74ji/3VM8nvkXziXu1YUxgPebeQd2weYVo0WPvfyrjXGF9PtkPuBUh9skKYLZUHc1A1sR66By9dnUGFM9a/645zRVqc6WEcjSbC/cYg1X61aYoYr/Qr0MaH9HRmWaDmP7mdEjigkhNDjF6vvjI2KeO4VHzcKAehc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oLIeblI8; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oLIeblI8"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W9lln0crgz6Cp2tZ;
	Fri, 28 Jun 2024 19:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719602750; x=1722194751; bh=Bi6EQ3Ahn62bMbJcMwKWnjyA
	I/cv78xLQF73J9lMcKs=; b=oLIeblI8LWMm/b79FMZiPYT2QwnUNcNQzRbM26tz
	FrWTD7lPjPU+2J07vVC+5lxXrSEorfbh3kC5kgNsC2XhPrh948P89MLaeaCskgzN
	Ny3paoHyzQznKfY8PsL16ajPd5RXOU2xT4pCvB57yBFhpzI+yDO9l8EZ+3r0JKGK
	03cDuOtqqEVSccZZEwm9KmPCzvpm3cNkfSBjj8RwRezpoBH6ndWX18sifez2KrCD
	pO6J2Vw35GCO+jv6yHVwDxWNvctguK5hZomwXByqajNWvIyFFu9zCZRDsD9ewqQp
	iHEi0A6gAv7h5cXs171dPOux+SSek25NPOAsNj+20FZnsw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LbY2I7nK4yfI; Fri, 28 Jun 2024 19:25:50 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W9llW6zpzz6Cnk90;
	Fri, 28 Jun 2024 19:25:43 +0000 (UTC)
Message-ID: <d6598130-0ca9-4908-9ccb-4836027ad75e@acm.org>
Date: Fri, 28 Jun 2024 12:25:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ufs: core: fix ufshcd_clear_cmd racing issue
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 stable@vger.kernel.org
References: <20240628070030.30929-1-peter.wang@mediatek.com>
 <20240628070030.30929-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240628070030.30929-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/24 12:00 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When ufshcd_clear_cmd racing with complete ISR,
> the completed tag of request's mq_hctx pointer will set NULL by ISR.
> And ufshcd_clear_cmd call ufshcd_mcq_req_to_hwq will get NULL pointer KE.
> Return success when request is completed by ISR beacuse sq dosen't
> need cleanup.
> 
> The racing flow is:
> 
> Thread A
> ufshcd_err_handler					step 1
> 	ufshcd_try_to_abort_task
> 		ufshcd_cmd_inflight(true)		step 3
> 		ufshcd_clear_cmd
> 			...
> 			ufshcd_mcq_req_to_hwq
> 			blk_mq_unique_tag
> 				rq->mq_hctx->queue_num	step 5
> 
> Thread B
> ufs_mtk_mcq_intr(cq complete ISR)			step 2
> 	scsi_done
> 		...
> 		__blk_mq_free_request
> 			rq->mq_hctx = NULL;		step 4

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
