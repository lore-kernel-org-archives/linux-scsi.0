Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEA420A5F9;
	Tue,  8 Oct 2024 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728409150; cv=none; b=oX/GZ8lI/m7ZSF9r4Te1vdpMrYRoPH/uTMY+EBQXL2dcAENQmvZkH7rShC8PwkvAIuP/EJJghHolEaH/yeoVl3fMaT1vo+y7/DUVWI9mK7WrOSuHVvssJjhLsOboMWaErNlm1XH3kMWfTQ4JmqNa4vk4oFbqMzoe6KWXKPp4/7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728409150; c=relaxed/simple;
	bh=pVPoeLSwAAk+MhP2w215fgYvfbRl4QXVRIy24FVFU0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y5Ym8BV7teEZSF28mq6SiR7OadIQPpTEvkHvpNcYsHzvAb4GZHg1i8+DA8srYua2GN5XWqe406IJu1D0C91U0RDtM6yNm5Q+ylkQfEbQdJSKgfFg6seRPt6dbkn90ol+AW7nFp4gq9covCSi9ZKWi4HgvbZxYGYThOr9gwVN3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wG+lyD59; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wG+lyD59"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNNYL56WLzlgTWP;
	Tue,  8 Oct 2024 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728409138; x=1731001139; bh=VaCy1d6oT42CbA25Y6wFA1tH
	oxNRupG+1o0LjdZp+XY=; b=wG+lyD59i/sC8Kk0iQQFuI8i8rNant2FyKuJpUIA
	JdCVSEvTQsusxvuvtfqN7NkPd5ZSIITRDy6LjpWLJ0xTzUdf9zmdYlADhqUyDpTQ
	hvDLBrLGjtM+IXXD4aQSc5RiWg1u6JqQmWdbKu9ZxNbIgHN4LljFiAySyE1ZkY4p
	NMr/WGyLAKclUHjidpq52Ki36vSW82suWiHXY6oWcKGS0lTghQKzzi97nCaZNAvF
	hhKKsc/u0osQ7fDjA52OrwYD7wLej6bIkWXu4uaEMlXEWQn7AjfS0RYrRLRGOY3p
	2qvNsipIf3CnjQ1gf0wImqn7XH6UxhAH2eNq4eI0yOZURw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XdEfBOYOx29x; Tue,  8 Oct 2024 17:38:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNNYB1SGJzlgTWK;
	Tue,  8 Oct 2024 17:38:53 +0000 (UTC)
Message-ID: <7b3b29ee-8e2d-476b-8edd-290c3f00dc85@acm.org>
Date: Tue, 8 Oct 2024 10:38:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: configure individual LU queue
 flags
To: ed.tsai@mediatek.com, peter.wang@mediatek.com,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Stanley Jhu <chu.stanley@gmail.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: wsd_upstream@mediatek.com, chun-hung.wu@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
References: <20241008065950.23431-1-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241008065950.23431-1-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/24 11:59 PM, ed.tsai@mediatek.com wrote:
> +static void ufs_mtk_config_scsi_dev(struct scsi_device *sdev)
> +{
> +	struct ufs_hba *hba = shost_priv(sdev->host);
> +
> +	dev_dbg(hba->dev, "lu %llu scsi device configured", sdev->lun);
> +	if (sdev->lun == 2)
> +		blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, sdev->reqeust_queue);
> +}

There are no block drivers in the upstream kernel that set
QUEUE_FLAG_SAME_FORCE. An explanation is missing from the patch
description why this flag is set from the UFS driver instead of by
writing the value "2" into /sys/class/block/$bdev/queue/rq_affinity.
Additionally, an explanation is missing why QUEUE_FLAG_SAME_FORCE is
set but QUEUE_FLAG_SAME_COMP not.

Bart.
