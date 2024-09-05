Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C65F188583;
	Thu,  5 Sep 2024 21:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725571013; cv=none; b=r0X5tW6E4msbaw+g/Dh0Ay+gmvwn5w9tw2p3FdHjKiYLo5t7ouy/g6c7WXYiETqa2Anjz7tWEpPhNU+mspCjNhgXNjFj85enQgnkarBE0ByUzzKgEjS1vDQ/ybMyuIMPHNBTcjIsOiMOAffpwUbG0jq+9T+CsUX5h2hs9uOnlIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725571013; c=relaxed/simple;
	bh=mkgaHAtecYvGuELnigUBtDygVelEKPQ8Kci4kOl7sRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLgnIGmpbIPWqrw4e/I9oUXi0RKhMexEM+FLV0oEcyCW0Q9JsNxdlMhMoJ9JsPF5ZrTlw6s3PMq3cD0zdjiUxFtoZwiGMefUAYFvzAaeepp3i3nFTkRD8x/9E41n/AnlUFW629E4OOhyxp0yr4HFHKlI4HK6p2CPad1ueswjXJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IEfSPC+n; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IEfSPC+n"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X0Bxt6gV5zlgMVQ;
	Thu,  5 Sep 2024 21:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725571003; x=1728163004; bh=zRqrbLL/IkYQjEdfxlAqcVOg
	FpFtctrQ9TMTQ5NK0Ac=; b=IEfSPC+njuqLZi/CcmLZbIT9BMmZ4yCAVYMVbcr3
	AxR0cxhu3HxW4Q3wcFsTfznLZjYWs3oNx5Fgx08Qezq0ZR59Rg1Ki7zzByoqV6sp
	buFoaLDo5fuIQuJpgqtJkpx7oNcUG2dHPg20NXd5FO+VXQ601FJ+sHKC0CfnsvxH
	+8g6sxZj/dzKhcbkbBXTdnGIrVe4AYCfC/HtWHeq1MD/dpRq/+KvP4KN6s9OV79/
	9E8eMDTmNWYCC9M0NE+Nf2OmMLtIefDuI5aKCy6sKeeRBQAvAR9iULGrJlhH3pYS
	9lt2LHAgoJ0E567pvY4MZEb0me02GKTvo1OuES1IFqea2A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MDlJSuh_GfjV; Thu,  5 Sep 2024 21:16:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X0Bxh55c2zlgMVL;
	Thu,  5 Sep 2024 21:16:40 +0000 (UTC)
Message-ID: <b31bf24f-588e-43e5-b71f-b4e9edd1b60a@acm.org>
Date: Thu, 5 Sep 2024 14:16:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ufs: core: requeue MCQ abort request
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20240902021805.1125-1-peter.wang@mediatek.com>
 <20240902021805.1125-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240902021805.1125-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/24 7:18 PM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index afd9541f4bd8..abdc55a8b960 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -642,6 +642,7 @@ static bool ufshcd_mcq_sqe_search(struct ufs_hba *hba,
>   		match = le64_to_cpu(utrd->command_desc_base_addr) & CQE_UCD_BA;
>   		if (addr == match) {
>   			ufshcd_mcq_nullify_sqe(utrd);
> +			lrbp->host_initiate_abort = true;
>   			ret = true;
>   			goto out;
>   		}

I think this is wrong. The above code is only executed if the SCSI core
decides to abort a SCSI command. It is up to the SCSI core to decide
whether or not to retry an aborted command.

> -	/* Release cmd in MCQ mode if abort succeeds */
> -	if (hba->mcq_enabled && (*ret == 0)) {
> -		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
> -		if (!hwq)
> -			return 0;
> -		spin_lock_irqsave(&hwq->cq_lock, flags);
> -		if (ufshcd_cmd_inflight(lrbp->cmd))
> -			ufshcd_release_scsi_cmd(hba, lrbp);
> -		spin_unlock_irqrestore(&hwq->cq_lock, flags);
> -	}
> +	/* Host will post to CQ with OCS_ABORTED after SQ cleanup */
> +	if (hba->mcq_enabled && (*ret == 0))
> +		lrbp->host_initiate_abort = true;

I think this code is racy because the UFS host controller may have 
posted a completion before the "lrbp->host_initiate_abort = true"
assignment is executed.

> + * @host_initiate_abort: Abort flag initiated by host

What is "Abort flag"? Please consider renaming "host_initiate_abort"
into "abort_initiated_by_err_handler" since I think that aborted
commands should only be retried if these have been aborted by
ufshcd_err_handler().

Thanks,

Bart.
