Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB8267AE8
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739553676; cv=none; b=TGyQTalRwPDIunLXikGI+g+1UIL+f/KiTIq43GJF9ar5xDPJCWMz+NLttCr1ciCc7gbuvNd7He38UCQyAARH2c06SXlCmbsveonGhR2wuOQVfSucl1USeUp8MnRfYZGixXHSFxbQHidhzjcm1JsW2ktwU9LG4/6VgATpR/OTQ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739553676; c=relaxed/simple;
	bh=obdM12AlGBOhKR/3IHCjm+3WlhUUg0e/+bBEmWUH2SM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L6TBe6XyIJ8v6x+ZyLKmaoMipDAFcprPw7q64CqJglYuSuHygHwsTkfpJ4/b7el238XaVKKFRdy7M65BLXJg2fR+heRqcRd88IiFZnpd11VXjflLYNRO+ib1f1cu3UrdOHCgBDz76qg3lA6j2TMf7tPWI66g2XkRICtEfIcyiIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=L2pZB3LA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="L2pZB3LA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yvf38314bzlgTwv;
	Fri, 14 Feb 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739553667; x=1742145668; bh=GYLKe8LSHDfj8iz9A1H/pwOr
	k3BdaMOOtG5R2iw0+IA=; b=L2pZB3LAR8Yp/373dWXGG6+QJ6kIj7p1sDuvl/L0
	ooZI2CpFC7S9+O99tZT5+ffOGmdKmZcx24kAUihmmavgFw5ISsXG+sIBpP9cRamI
	gjS71WcFfWkHrr4b7hBk1xgcev/kJ8cIv2gu+P4k8QFkWOutcWH5tpdoDmL25HXL
	3qdPBSu1WXrELh4Kj8nO4QRmk21aebhZjQJeEHBVqmwNtB2b15899qgDplk4pzgm
	hxcybLCqm4XyKso4SpaSVObPguKmmoA/cwLYQ6z0xsGUJy2rRp+vBUqhxdNuyllc
	6f2RPTWKeoIFx8D/fbgW7kVv4IYevUOmbO/aN5eN6Y7i3A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fjGCy0vB-rwt; Fri, 14 Feb 2025 17:21:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yvf3603TRzlgTwp;
	Fri, 14 Feb 2025 17:21:05 +0000 (UTC)
Message-ID: <a6f9ccd2-7b71-45c2-b410-2a09bf76ec7f@acm.org>
Date: Fri, 14 Feb 2025 09:21:04 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: clear driver private data when retry
 request
To: Ye Bin <yebin@huaweicloud.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20250214011618.286238-1-yebin@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250214011618.286238-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 5:16 PM, Ye Bin wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be0890e4e706..c876b1c82153 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1669,13 +1669,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	if (in_flight)
>   		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   
> -	/*
> -	 * Only clear the driver-private command data if the LLD does not supply
> -	 * a function to initialize that data.
> -	 */
> -	if (!shost->hostt->init_cmd_priv)
> -		memset(cmd + 1, 0, shost->hostt->cmd_size);
> -
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>   	if (blk_rq_bytes(req))
>   		cmd->sc_data_direction = rq_dma_dir(req);
> @@ -1842,6 +1835,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>   		goto out_dec_target_busy;
>   
> +	/*
> +	 * Only clear the driver-private command data if the LLD does not supply
> +	 * a function to initialize that data.
> +	 */
> +	if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)
> +		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +
>   	if (!(req->rq_flags & RQF_DONTPREP)) {
>   		ret = scsi_prepare_cmd(req);
>   		if (ret != BLK_STS_OK)

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
