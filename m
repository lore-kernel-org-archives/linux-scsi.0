Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC7126FD84
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760456820; cv=none; b=cGZDRVmAXUdsbd+KX732zextCTl/ULSn2H+kyWgFzXIQfXtFbHaBu84aJc+xhdJrGL07tYFhXjLi3nio2a7McQO9YMWGNOh0kjQn0K2wNGwTnYrfruR4oTIjI5bP2bZqibcPd/7syrYhuCjZiYCkSdKiMqOgvcjHkhiuG2do0aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760456820; c=relaxed/simple;
	bh=j3CQ/RO1nQ0p6Uz5wPrLfYjOmLlhvHLN2PZqennCovw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pRW16y2HxHElDSxqzQwx/nJzIKIoY0R0eN8/U2VVXlKopeLdxcjq6SOBO4tY3yYROD1NWI6CL+3+K0aYaZa7daicmUSqR44PesnK9dNOpA4TxugAm5ZzM7yynQcZQVtyl3AoGy3FsfOENqL/sBoa8Zu14PpohyG+xFurCTmOKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q0lgc2Z2; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q0lgc2Z2"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmJVp0ppFzlgqyn;
	Tue, 14 Oct 2025 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760456812; x=1763048813; bh=41wA36PDmhkunY1fcShaZGqO
	cjr8qbaTCvwQtvR3cYc=; b=q0lgc2Z2rCKoqzO7LWFpGajvWVZKHMhp47QdyrJJ
	GoLYNwouKm8vLx7i/GrrLwh3admP+NRxjmUO1AZVg8MAsu27zoWg66I22j5LJgzw
	IYhLY5vLQtLc+19yN3Xo/puH1+JOdXG3QZfK+hdHdkd6h8XoZOBQRkJ+sAteN8ss
	nX8TFNnuB85xtUHvAvBS5Vn3em6qhvTUbcWNAHUko1Ds2ZCHhcxKGR0GfcOZrrmN
	HNGcMLE78jNsWu/ttoOKWXaNO4g3kcuZuobVR/Pm+wguTSWJW079kgPKPTnN5GMy
	8C8OJniH1GSx6eIn3ksGfNjVAgcMjQK+XM85rFX27Rtzog==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G4BRsfDz7acL; Tue, 14 Oct 2025 15:46:52 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmJVS1Np3zlgqVm;
	Tue, 14 Oct 2025 15:46:39 +0000 (UTC)
Message-ID: <4c47f800-0536-452a-b64b-d177fa306418@acm.org>
Date: Tue, 14 Oct 2025 08:46:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] ufs: core: support dumping CQ entry in MCQ Mode
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, qilin.tan@mediatek.com,
 lin.gui@mediatek.com, tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
 naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20251014131758.270324-1-peter.wang@mediatek.com>
 <20251014131758.270324-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251014131758.270324-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/25 6:15 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d779cc777a17..b90500126b35 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -599,7 +599,8 @@ static void ufshcd_print_evt_hist(struct ufs_hba *hba)
>   }
>   
>   static
> -void ufshcd_print_tr(struct ufs_hba *hba, int tag, bool pr_prdt)
> +void ufshcd_print_tr(struct ufs_hba *hba, struct cq_entry *cqe,
> +		     int tag, bool pr_prdt)
>   {
>   	const struct ufshcd_lrb *lrbp;
>   	int prdt_length;
> @@ -618,6 +619,8 @@ void ufshcd_print_tr(struct ufs_hba *hba, int tag, bool pr_prdt)
>   
>   	ufshcd_hex_dump("UPIU TRD: ", lrbp->utr_descriptor_ptr,
>   			sizeof(struct utp_transfer_req_desc));
> +	if (cqe)
> +		ufshcd_hex_dump("UPIU CQE: ", cqe, sizeof(struct cq_entry));
>   	dev_err(hba->dev, "UPIU[%d] - Request UPIU phys@0x%llx\n", tag,
>   		(u64)lrbp->ucd_req_dma_addr);
>   	ufshcd_hex_dump("UPIU REQ: ", lrbp->ucd_req_ptr,
> @@ -648,7 +651,7 @@ static bool ufshcd_print_tr_iter(struct request *req, void *priv)
>   	struct Scsi_Host *shost = sdev->host;
>   	struct ufs_hba *hba = shost_priv(shost);
>   
> -	ufshcd_print_tr(hba, req->tag, *(bool *)priv);
> +	ufshcd_print_tr(hba, NULL, req->tag, *(bool *)priv);
>   
>   	return true;
>   }
> @@ -5536,7 +5539,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>   
>   	if ((host_byte(result) != DID_OK) &&
>   	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
> -		ufshcd_print_tr(hba, lrbp->task_tag, true);
> +		ufshcd_print_tr(hba, cqe, lrbp->task_tag, true);
>   	return result;
>   }
>   
> @@ -7763,9 +7766,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   		ufshcd_print_evt_hist(hba);
>   		ufshcd_print_host_state(hba);
>   		ufshcd_print_pwr_info(hba);
> -		ufshcd_print_tr(hba, tag, true);
> +		ufshcd_print_tr(hba, NULL, tag, true);
>   	} else {
> -		ufshcd_print_tr(hba, tag, false);
> +		ufshcd_print_tr(hba, NULL, tag, false);
>   	}
>   	hba->req_abort_count++;

So there are four callers of ufshcd_print_tr() and only one caller dumps
the CQE? Wouldn't it be better not to add any arguments to
ufshcd_print_tr() and instead add the code for dumping the CQE directly
in the only function that needs this functionality?

Thanks,

Bart.


