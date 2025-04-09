Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5F21148F;
	Wed,  9 Apr 2025 21:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744232413; cv=none; b=ZKZaPnvqvUaKtqo2g6nuv4HmXWykUFDOSgVjRja6Wmz/VZDoybPsslWiJ0CDJBSZ5XouNPkWPO2fCq82Vn5XD+/e1j54U86mWKsVbrRMJI+xBHXnLlHVrtxSQnM4YAarv209m4uFBuDyq/Skt1IjmA6aTqnDlK0h6VhPhXdfHVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744232413; c=relaxed/simple;
	bh=u9y+3WWgJyQXBNeDtdGlxMTb4ab/g/8Jj2VBJvdZcxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZYGhAlm6bL7LiyG/bMZOywPK76A82gkO6gKFKxl4U6P8dwsg55iXet1vn2YbBugo1WnKYpXFW/WMBsYvkeuBnwRY3ZXjf4OckWSeimlu7/n2xXOq8B+efr/rUtCAH76hZb3E4yYPsyKVmvaDkgtRs0slFIewtNZ30/xCdsON+x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Tu9YuzZS; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Tu9YuzZS"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZXwLq65xqzm22HC;
	Wed,  9 Apr 2025 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744232401; x=1746824402; bh=4qpDFoC7jRxlhD7xqwhzQhGg
	yvb+J8AtlP8vjZ317ng=; b=Tu9YuzZSu7T2UHbDvRpWrtn4uRosQ3C0b6s7XEYA
	B0ab7ir4m4iKX7BJ1bSeSH1o8JdiJIpRBo/DdQlhrUiisho8j8IzYAJWHSGFX3dg
	rVpooRaJGjgvnAk/klH9Z/i+wzOthYUh1i1UsTLUBiwQWpVUfR5MBOPGImQ2tTw+
	wgiiRHJZMUvNL2pL1PC1EMqQTawBLauXcyk/4PyOr3dgXdYtgyEXbOWiI1IUaH5D
	chDNTuLcjOaR8X5Kdm5RC3dA+x6FxhHhkYpHHDlJllZYy1W3/tGtpDxkbIRc8y1U
	ASRwg261OTtr5f02QwQbfa8wE4STj1j/SPO8wyHBjDSM9A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lxL8XKZCaJb9; Wed,  9 Apr 2025 21:00:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZXwLc2rFzzm0pKY;
	Wed,  9 Apr 2025 20:59:51 +0000 (UTC)
Message-ID: <2e19c458-4136-4860-b853-1314c4ab5952@acm.org>
Date: Wed, 9 Apr 2025 13:59:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
To: Chenyuan Yang <chenyuan0y@gmail.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, minwoo.im@samsung.com,
 manivannan.sadhasivam@linaro.org, viro@zeniv.linux.org.uk,
 cw9316.lee@samsung.com, quic_nguyenb@quicinc.com, quic_cang@quicinc.com,
 stanley.chu@mediatek.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250409204537.3566793-1-chenyuan0y@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250409204537.3566793-1-chenyuan0y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 1:45 PM, Chenyuan Yang wrote:
> A race can occur between the MCQ completion path and the abort handler:
> once a request completes, __blk_mq_free_request() sets rq->mq_hctx to
> NULL, meaning the subsequent ufshcd_mcq_req_to_hwq() call in
> ufshcd_mcq_abort() can return a NULL pointer. If this NULL pointer is
> dereferenced, the kernel will crash.
> 
> Add a NULL check for the returned hwq pointer. If hwq is NULL, log an
> error and return FAILED, preventing a potential NULL-pointer dereference.
> 
> This is similar to the fix in commit 74736103fb41
> ("scsi: ufs: core: Fix ufshcd_abort_one racing issue").
> 
> This is found by our static analysis tool KNighter.
> 
> Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
> Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
> ---
>   drivers/ufs/core/ufs-mcq.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 240ce135bbfb..2c8792911616 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -692,6 +692,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
>   	}
>   
>   	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
> +	if (!hwq) {
> +		dev_err(hba->dev, "%s: failed to get hwq for tag %d\n",
> +			__func__, tag);
> +		return FAILED;
> +	}
>   
>   	if (ufshcd_mcq_sqe_search(hba, hwq, tag)) {
>   		/*

This patch makes the ufshcd_cmd_inflight() check just above the
modified code superfluous. Please remove it.

Additionally, please change the error message such that it reports
that the command has already completed.

Thanks,

Bart.
