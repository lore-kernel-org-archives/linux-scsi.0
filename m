Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF251C6F7B
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727802812; cv=none; b=d0U/ghacHPBY0Fsj0xN+EkHPzF++gSuZ0XzKV4zab2ygmAWgQSXJ/NYW9qUXo3VA5UQlr7nCtmh8TzpsMJbsBFab3pVamJYLzfXzKG8/CD02/oQIri7M/7j4qhO2STRyihytbAepDvfA01vJSicB90m8qT1/ADedlj8HfrQ2niY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727802812; c=relaxed/simple;
	bh=Dp2XlJCKhIfjgcsiFYHaRaZrdnscz52+ahq5RHyNNgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGvUAqGMCT/6ZCjGoVKTf/UBMJFWoz0irwKLU2EapnGz56r6u8xik/2nEIQxDQT2BqOXhwitVmOBQ1wpz8yedSE4rLeSvwkNFvIzN9XMQ06CNTLxDxWRHrNQ3CDiiK3ZiOeO0nY6FskoPisT5qiVz5HT0IfA/mIarf6wG1tceJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D+rx8qTt; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D+rx8qTt"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJ4K56DQrzlgMVs;
	Tue,  1 Oct 2024 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727802807; x=1730394808; bh=bO8dlF7CS7mQ/xlMRn18nJvQ
	l4UrEFjLritlNoJz6B4=; b=D+rx8qTtYl3FdsNCXgOQpXULeMbuT8/l5Pwlh1iD
	NZUz4pWLWtanjaE276HssAuH4t3DDSL+B2ggTN1BH2QxejM1kW53p/6MBtu749VZ
	XqU4f23pEBZ9E2Q+t2EqQ+EYyX006Fl4EL5+kLBGqi9zVx3yNa81ahDWV/BRv2IZ
	0KZiUpZgbf4I4wy2EDozPRqO/YG3l2uDTC/artZ5uqS4remDjbU6qU5TqDvzPnps
	0r4Z0v1B7pM2jnMCbrFjBve3HpzVtyrJHNDzdSxY+MzQLdt7fGlb34E4g+0C7EP7
	dGp1GXMf8tWzgCLw8W4sw8sLcEWSOY0umWhQRkGpHvtvyQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vmh1PuD-CN95; Tue,  1 Oct 2024 17:13:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJ4K20vHkzlgMVr;
	Tue,  1 Oct 2024 17:13:25 +0000 (UTC)
Message-ID: <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
Date: Tue, 1 Oct 2024 10:13:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org
References: <20241001091917.6917-1-peter.wang@mediatek.com>
 <20241001091917.6917-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241001091917.6917-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 2:19 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> After the SQ cleanup fix, the CQ will receive a response with
> the corresponding tag marked as OCS: ABORTED. To align with
> the behavior of Legacy SDB mode, the handling of OCS: ABORTED
> has been changed to match that of OCS_INVALID_COMMAND_STATUS
> (SDB), with both returning a SCSI result of DID_REQUEUE.
> 
> Furthermore, the workaround implemented before the SQ cleanup
> fix can be removed.
> 
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 20 ++++----------------
>   1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 24a32e2fd75e..8e2a7889a565 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5417,10 +5417,12 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>   		}
>   		break;
>   	case OCS_ABORTED:
> -		result |= DID_ABORT << 16;
> -		break;
>   	case OCS_INVALID_COMMAND_STATUS:
>   		result |= DID_REQUEUE << 16;
> +		dev_warn(hba->dev,
> +				"OCS %s from controller for tag %d\n",
> +				(ocs == OCS_ABORTED? "aborted" : "invalid"),
> +				lrbp->task_tag);
>   		break;
>   	case OCS_INVALID_CMD_TABLE_ATTR:
>   	case OCS_INVALID_PRDT_ATTR:
> @@ -6466,26 +6468,12 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
>   	struct scsi_device *sdev = cmd->device;
>   	struct Scsi_Host *shost = sdev->host;
>   	struct ufs_hba *hba = shost_priv(shost);
> -	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> -	struct ufs_hw_queue *hwq;
> -	unsigned long flags;
>   
>   	*ret = ufshcd_try_to_abort_task(hba, tag);
>   	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
>   		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
>   		*ret ? "failed" : "succeeded");
>   
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
> -
>   	return *ret == 0;
>   }

As mentioned before, ufshcd_try_to_abort_task() cannot handle concurrent
scsi_done() calls. ufshcd_abort_one() calls ufshcd_try_to_abort_task()
without even trying to prevent that scsi_done() is called concurrently. 
Since this could result in a kernel crash, I think that it is important 
that this gets fixed, even if it requires modifying the SCSI core.

Bart.


