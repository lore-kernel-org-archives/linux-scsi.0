Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1951B393D
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 20:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739997125; cv=none; b=eGuxWG6MkbH5sp8nMqSZ4DCoKvY1bMI3hMmMRLXqV6gXQfAgjgOqWVAU6NX2ug/PZy4AKfchVO083aeSFuf0dTFwmBiV1rshiW0xQ7cXvZ5yvaLMfbCLG9Zd5ACEJvCnQ61u255K20qqhOuLYIB/b+7/Ozwo78qQbznO+9AxXwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739997125; c=relaxed/simple;
	bh=e2+0xu5/JwLdtsWPOxf65WgI6XQF7titXXKdf1OeSBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rLYFAa3iu7B8uIFwXoME5XRRyiaOVyd/XYAiItVR17fVkoYxdBtRJZ5ASdLCyjSZVOvlJ5oiU/NRKaviW3lROWw6t2lAsJnyoFqaBygUpaM+DmKxqpCZzevJeEmi3re8WtxBDnPz4UbtGyOahbasgozu1Vfs3ovH53oMTcxMfQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iETSwJLv; arc=none smtp.client-ip=199.89.3.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iETSwJLv"
Received: from localhost (localhost [127.0.0.1])
	by 001.mia.mailroute.net (Postfix) with ESMTP id 4Yyp361xWDz1Xb87W;
	Wed, 19 Feb 2025 20:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739997121; x=1742589122; bh=3HNz/2YCL1dEMEc1WYydUAcN
	rlTYcWxZm42/IJSiyDo=; b=iETSwJLvo16y/D3sKbWyZCo6YXSZWA9uR7eKbFMX
	cifQxALKvpiTcit0GXCnBClYpW+gWUzbmYykTMu3kx2z+LXWg6TFFbHyZ+FFhrhb
	Z1ZUdY68LhKhgnSslHs7a0ZdOQ9M4LvYcRs5D4FisJHWPpIO/bbSdLO9ceGGD98R
	7DuMzAOpecy5873cOCFOsclK3oOk4BS7Wd5UyTTivkR4MqOJb5ekIkN2Tfd64H6r
	2ZMFaTI2dlBbhwgU/NR99CdS/bjWN6qrCUk8f7OpkmtULetjOtMLI9mJG5ebs8CI
	mS/RxymfqDaUMoN1Bi7sX6MdoypFpCHejLNxj/nXLpRtmg==
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([127.0.0.1])
 by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HVPflmjy0wg3; Wed, 19 Feb 2025 20:32:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 001.mia.mailroute.net (Postfix) with ESMTPSA id 4Yyp324CXyz1Xb87L;
	Wed, 19 Feb 2025 20:31:57 +0000 (UTC)
Message-ID: <226b78b1-a450-4104-8dfa-330294d0a53b@acm.org>
Date: Wed, 19 Feb 2025 12:31:56 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry
 request
To: Ye Bin <yebin@huaweicloud.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: zhangxiaoxu5@huawei.com
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250217021628.2929248-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/16/25 6:16 PM, Ye Bin wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be0890e4e706..f1cfe0bb89b2 100644
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
> +	if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
> +		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +
>   	if (!(req->rq_flags & RQF_DONTPREP)) {
>   		ret = scsi_prepare_cmd(req);
>   		if (ret != BLK_STS_OK)

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
