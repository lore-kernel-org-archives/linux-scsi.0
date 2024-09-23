Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F86D1A7250
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727115588; cv=none; b=L8xnPzq/LNqmSasC6SsH47AtiCgcoYppIrv92msvQ4jEpS9+9XBQpNsvEL4z1V+Cawrx37LScIlBcy0Mfg+ueQpZEXQCkyaFkcPfEDfH35wZ+zPS5+boa/Iced3/IDYm53dZdkm+Fef2LTdi9B1EwkWWBRP1cfsXOX5qhbFbRBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727115588; c=relaxed/simple;
	bh=oGQW3sjnjGQ4tB3VumSqI7UNmjgIbNdcdIf5xi5ZS3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZ0uQAgrvBxm5VNbPYy3NEGZaStS1hwShJr+Ng/B4tfsKCbLwGP3uSxb2RKmFBoSyi8p68emxsSvA9SCeYdqczWwyNc+DE+yFZcJj/8/+64LMofH9kvjdPwgkAsZ9+FXCg/C+BEM9/H06lHyfWXfXrA99v5GsR806t+LDCTy6Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s1YSmD+r; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s1YSmD+r"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XCB9G04yWz6ClY9Z;
	Mon, 23 Sep 2024 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727115575; x=1729707576; bh=/p5vp+3qkkITxzDJCERgzt5y
	UgLEHP0TY8OyGowAHEY=; b=s1YSmD+rynvq6OuTyYbXiq6tmK3qZhqY2aAJ8gO+
	5Xaw9v5Y6CTaDugwnmkJLMsABvvLUGoczmIQsqHa63a+TIrpaoIPbRB37INU8+7j
	3iVDtwHxotLfG+5zzbJJ+ePMqm+7v11lIFHgECnhcevCaszPDyJeqdzta6dXPpIk
	Obl4yvVZnn8HfWREexh7Ds6vGH3h5qNcuUIN7wfNklGoJLo33DQyHCr+8JgtJgiI
	0DEZZrAIhfBl7Urf/dKR1x0k6wEb7tuwILhBlhGI79EISbKTTfE3+pDZc/T4YtZZ
	kK/tP4T8flzzyIO+qYhOFU/IB2M8tZ/RfQ4pVEtPN4gOsg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RnVevXBzYcuz; Mon, 23 Sep 2024 18:19:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XCB8y2jg5z6ClY9Y;
	Mon, 23 Sep 2024 18:19:30 +0000 (UTC)
Message-ID: <f08fbc51-22a7-4c13-b9d4-ee7f4920bcfa@acm.org>
Date: Mon, 23 Sep 2024 11:19:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/3] ufs: core: fix error handler process for MCQ abort
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com
References: <20240923080344.19084-1-peter.wang@mediatek.com>
 <20240923080344.19084-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240923080344.19084-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/24 1:03 AM, peter.wang@mediatek.com wrote:
> When the error handler successfully aborts a MCQ request,
> it only releases the command and does not notify the SCSI layer.
> This may cause another abort after 30 seconds timeout.
> This patch notifies the SCSI layer to requeue the request.
> 
> Additionally, ignore the OCS: ABORTED CQ slot after MCQ mode
> SQ cleanup. This makes the behavior of MCQ mode consistent with
> that of legacy SDB mode.
> 
> Also, print logs for OCS: ABORTED and OCS_INVALID_COMMAND_STATUS
> for debugging purposes.

Although I like the approach of this patch, two comments below.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a6f818cdef0e..b5c7bc50a27e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5405,9 +5405,15 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>   		break;
>   	case OCS_ABORTED:
>   		result |= DID_ABORT << 16;
> +		dev_warn(hba->dev,
> +				"OCS aborted from controller = %x for tag %d\n",
> +				ocs, lrbp->task_tag);
>   		break;

Including the OCS status in this message seems redundant to me.

>   	case OCS_INVALID_COMMAND_STATUS:
>   		result |= DID_REQUEUE << 16;
> +		dev_warn(hba->dev,
> +				"OCS invaild from controller = %x for tag %d\n",
> +				ocs, lrbp->task_tag);

Also here, including the OCS status in this message seems redundant to me.

Please change "invaild" into "invalid".

> @@ -5526,6 +5532,18 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   			ufshcd_update_monitor(hba, lrbp);
>   		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
>   		cmd->result = ufshcd_transfer_rsp_status(hba, lrbp, cqe);
> +
> +		/*
> +		 * Ignore MCQ OCS: ABORTED posted by the host controller.
> +		 * This makes the behavior of MCQ mode consistent with that
> +		 * of legacy SDB mode.
> +		 */
> +		if (hba->mcq_enabled) {
> +			ocs = ufshcd_get_tr_ocs(lrbp, cqe);
> +			if (ocs == OCS_ABORTED)
> +				return;
> +		}

Why only ignore the OCS_ABORTED status in MCQ mode? Is my understanding
correct that MediaTek controllers can also report this status in legacy 
mode?

Thanks,

Bart.
