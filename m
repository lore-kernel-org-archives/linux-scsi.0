Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB9F328B7F
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866815; cv=none; b=ZVXO8w1tfssx9yJ5KbQky3qd9+OHmRW6rT4NyRFAhXwaCfi4xN8EfaOXlCIgMa0m+xMDOZlUc5RZZb9b37frzR4O3apxE8CLXF3Jk6LShatNPwa6Ov8NYn4VNSLaIyHCvANGJ2tqkuhbQ8ABTlp0zXqTBwv006TWs7jIt0a4n40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866815; c=relaxed/simple;
	bh=U4CnDGaDNX3HXGRIItjtT9BfZhMPu9Gh2Bu8C9s/6DE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gefkLCZZEcfagUSaU7M/PZJHy1r84ZDuP+gh1hF+f/ZlMbLKHopzY5EBkoQ6Zm2uemD8R0BmAlfGFPOUzMsDYr/8RKcmEBp6RmMpqs8H7oa6oSR5jtAb96aqrTTKXFXLpt7ONy+6SVw3cfG2jYzguH+2IrUlhSy6guvmYJRM1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dXfWs53v; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dXfWs53v"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fKS9p04ldz1XLyhN;
	Mon, 23 Feb 2026 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771866811; x=1774458812; bh=oPpFcSeau7Gf5T+AlcnvIXzz
	k2Xfytp8JNl+DHgmVgg=; b=dXfWs53vD0knK4w3w5yRjw2N0JQjKPpT+emD3JSw
	tn2PVNYOSXvf2Z/phY/tPI7RbCXvyEZCOYGLK745TDliTAAyTTMAG1qtA0HtdVuJ
	S0MD6kRSSPUK/baZd7evIdwW1Etyi+2+zD5ZuNtzSqxiATOEfLHXkLsQdYzxkS4F
	WLuC2TBK6UXToIPdVzfPgCdaJs6o0D1FOczByZhEsVNRyR1VxrvoIznnX5EpOfua
	N/LOHpoXLYL00Jb5QWDj7po49T9/O5N6RJhC2/AGqhOb9CcfA9uKFJC90hLWRstH
	vPuhDJlyrDQWfKnPJ3l52tD+WAh3/1YhyLVGPvplmnn5JA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F1Eg1G2IcSFi; Mon, 23 Feb 2026 17:13:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fKS9f6vcsz1XLyhM;
	Mon, 23 Feb 2026 17:13:26 +0000 (UTC)
Message-ID: <5017b907-16de-4d7f-a7c6-dbc504ffd1eb@acm.org>
Date: Mon, 23 Feb 2026 09:13:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@sandisk.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260223065657.2432447-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260223065657.2432447-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/26 10:56 PM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ec175a099459..44efb03765b9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -515,8 +515,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
>   
>   	if (hba->mcq_enabled) {
>   		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
> -
> -		hwq_id = hwq->id;
> +		if (hwq)
> +			hwq_id = hwq->id;
>   	} else {
>   		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>   	}

This will cause "-1" to be assigned to hwq_id instead of a queue number
if a request has already been completed. Wouldn't it be better to
introduce a new helper function that returns READ_ONCE(req->mq_hctx)
->queue_num instead of making the above change?

Thanks,

Bart.
