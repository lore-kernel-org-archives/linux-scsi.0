Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217121865FC;
	Fri, 23 Aug 2024 16:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430045; cv=none; b=hqVSSKI3VqeoRIyY6fNXAF4VzcKlPUVdNsA5iBY19RV/n9JJr2WP2GrW1IoqRFj9RdaxMleIgZ6omWxRj0XbxHmNDW36Ct1Qf9JgzV3bp5HoupNo/SGKbY+2W3vnqFwvuXcHsDffnEzmwu7XupnBwZaeGPOfGm/Z57qfqZHtcH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430045; c=relaxed/simple;
	bh=NRzp4SExe6JM3R+LAd5N6wkMQfqrcnHMt15MgF++2VE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWGF710U01Hll/O9h3UZYy6gCzr3vWJaUIuDbkC5N/BhtyhbuW328imJ1lTUJhLCmKFEbTLDeYTjUJP5f9IJyOTR4WrsAu/izpdJGZBHs0a3C6rk0rQTgtPZV5HumBh47/Ik8dDDxyyr5SNDjzEp6cI7whFQUf9N3oYrn2xKblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s5zo7d1b; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s5zo7d1b"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wr50C3N80zlgVnK;
	Fri, 23 Aug 2024 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724430037; x=1727022038; bh=Rg5eyOwxNiG+PX9AoHJo/afz
	OMXnjg8jta0yJK0fqtI=; b=s5zo7d1bB/qegI6rBCiT0AjK7sOzRDHyrR+B47VH
	ddjqGp6VIrT5jUCdSzEMxoUgo9VZRKW9YdOiJYsfmoJeSVGDRH1Xqbnz7d26BJ5r
	A5dNKplZF/vlormqL2K42hH94Es9MCiei9Uz4kcOa5qEfNa1qy6Icd0PRwWeaUXp
	TRZrxMKGI1KcOwg0S3hpg7ijcd7bct/+xx7yaslSXGjbsfr7LwAvLomIdW/r0ZRk
	5+W8DPn5Oh+PHZMmn4QtGHBcciZCegwOW4eaAjlg6rmjNiAk7anlUqHwu3lQq3xH
	m/oUGJbOhj7BVJGKUEwePqdLTt6hyimx34+vjqh2VzpU4w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x-1rNW4qNJrD; Fri, 23 Aug 2024 16:20:37 +0000 (UTC)
Received: from [172.20.20.20] (unknown [98.51.0.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wr4zz3YT1zlgVnF;
	Fri, 23 Aug 2024 16:20:31 +0000 (UTC)
Message-ID: <c5906668-1110-4ecc-9249-32e92502dd13@acm.org>
Date: Fri, 23 Aug 2024 09:20:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ufs: core: complete scsi command after release
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 stable@vger.kernel.org
References: <20240823100707.6699-1-peter.wang@mediatek.com>
 <20240823100707.6699-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240823100707.6699-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 3:07 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0b3d0c8e0dda..4bcd4e5b62bd 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6482,8 +6482,12 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
>   		if (!hwq)
>   			return 0;
>   		spin_lock_irqsave(&hwq->cq_lock, flags);
> -		if (ufshcd_cmd_inflight(lrbp->cmd))
> +		if (ufshcd_cmd_inflight(lrbp->cmd)) {
> +			struct scsi_cmnd *cmd = lrbp->cmd;
> +			set_host_byte(cmd, DID_REQUEUE);
>   			ufshcd_release_scsi_cmd(hba, lrbp);
> +			scsi_done(cmd);
> +		}
>   		spin_unlock_irqrestore(&hwq->cq_lock, flags);
>   	}

Hmm ... isn't the ufshcd_complete_requests() call in ufshcd_abort_all()
expected to complete these commands? Can the above change lead to
scsi_done() being called twice, something that is not allowed?

Bart.

