Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1BF443311;
	Thu, 16 Jul 2026 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224340; cv=none; b=gSNle+xD2uT5guymLelWMSD4TKYOo5Fq8hMJlLMm2e/AlnAeWS9l+QTWm7lGfyYPpwViEGw8/tvhjjzBWCU+z4A1i6jKEUw3czLJlo6nCxFhkNaCYOju0FUzxLD8v9RgKXnHz3L5RCVW92RO4fAvVYl9kRc4iLogwtmXYhKBdUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224340; c=relaxed/simple;
	bh=uvMNZPdVFTKUNeV7KddQMV/BCy8il7x4ak3twHKWfrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=npDo4fKXcT2f4AULFGW1LsGQaNmKAoIyJv9nsQXoZvn1N2sIo0F2jkFqg+zt379LfswUud9UjZKJKzDQlMScyiic6ilFc2PS0y0wfJtV8X5rlBTW6kZtbbJveyLJyHSu2yk2eht3/+tPWe9HRBl2o5A72SD2trFq4HUfIJAPDuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PVyg/wJw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PVyg/wJw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h1LGV14cszlh306;
	Thu, 16 Jul 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784224331; x=1786816332; bh=/5xm14rqXUVUhdk3V20uVX4w
	tSRRkomErPcEVTC9B2A=; b=PVyg/wJwHnvLK2r/SKLmCXEvP+IKhRVWsroNzKyC
	4H0sIUY9P7zOXI/7OjyqG4AUWvG4cCyZ3ppegS1gYuKLBL3Z8f8r74JsZ7fKvie0
	q1dGZML5zBorzbbLSOb04CS3M/ziKdY7vk9UCoeAd3W1cQEKjQ5A6Pxk9uhcn56T
	0tXl5m3UTYHKIrC4xeXN1B90jdvZY5Kt98B40e8hwO4N8Qwc3zEZp9/Z17Tg9p0V
	c2+iGWkeeFHW6sehr5FxuJ/05fC8uwelDtpogZXuhunz8/vSE8D8PevDASRTGoKd
	AxprVnFTPnz4Ad6HRXQR1BswKmNqkqbsTguhe46lF0eO3g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tO7PHOv3qzmH; Thu, 16 Jul 2026 17:52:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h1LGJ3K0tzlh2rl;
	Thu, 16 Jul 2026 17:52:08 +0000 (UTC)
Message-ID: <7ba3ec37-cafc-47d1-9c41-1be3e996d787@acm.org>
Date: Thu, 16 Jul 2026 10:52:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] scsi: ufs: Fix NULL dereferences after tag lookup
To: liqiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <a761788934d27cef7cbd099674923fd1c7c00f48.1784182493.git.liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a761788934d27cef7cbd099674923fd1c7c00f48.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 11:19 PM, liqiang wrote:
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 13b60a2d06db..15850b0658f9 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -555,8 +555,8 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
>   int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>   {
>   	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
> -	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
> -	struct request *rq = scsi_cmd_to_rq(cmd);
> +	struct ufshcd_lrb *lrbp;
> +	struct request *rq;
>   	struct ufs_hw_queue *hwq;
>   	void __iomem *reg, *opr_sqd_base;
>   	u32 nexus, id, val;
> @@ -568,6 +568,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>   	if (!cmd)
>   		return -EINVAL;
>   
> +	lrbp = scsi_cmd_priv(cmd);
> +	rq = scsi_cmd_to_rq(cmd);
>   	hwq = ufshcd_mcq_req_to_hwq(hba, rq);
>   	if (!hwq)
>   		return 0;

Please drop this change. Calling scsi_cmd_priv(NULL) or
scsi_cmd_to_rq(NULL) is safe if the pointers returned by these functions
are not used.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3541da5b6f4d..f2a5fa624e74 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5857,13 +5857,14 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   			  struct cq_entry *cqe)
>   {
>   	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
> -	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
> +	struct ufshcd_lrb *lrbp;
>   	enum utp_ocs ocs;

Same comment here: calling scsi_cmd_priv(NULL) is safe if the returned
pointer is not used as is the case here.

>   
> -	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
> -		      le64_to_cpu(cqe->command_desc_base_addr)))
> +	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_addr = %#llx\n",
> +		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
>   		return;

The above change looks good to me.

Thanks,

Bart.
