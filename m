Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453962905
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 17:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759945550; cv=none; b=enwkBs7qjzXTpPGu1Ws39b1fJumsnLb1x7jlUbgEyYw96YSKWtLRWe3kLv2hl0cIy2FuSURuGCrhqVNhs3OfRbeF6bRFumED0pGFzhjOFm5hOyblLic04JZQDt2v4QPnc7LmMH8ZZs2OuB5BNqOd00jCbmsEY8/iN8rabB66EZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759945550; c=relaxed/simple;
	bh=nVzsF8FoZOkY5Wib5uMI+1VTIt6Ff3a35yCaU0maUeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wn2nHAlwiRDdnUc2VoZQgedsb9UoUmPz4SkHd3rdD9V7eL6migKQvR3QkHMKXHpg9RCGF9Esyf6xtPwEl7PEXRDXzzPZkTJMTYCZNbxevBzsh7f80j+C2+ol/EeAh87O9cLsiSbil3Ke+0R6fIT0nmsL+KmYNAlQYdGIqraQvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NjVaD6tB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NjVaD6tB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4chgQf1Q1lzlgqVj;
	Wed,  8 Oct 2025 17:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759945542; x=1762537543; bh=rd0nIlpZ+c+jqQhytSxBweTo
	i9xbglU2yopC9Vl/e+o=; b=NjVaD6tBll4DdmwwF3esq736GrGTFvDfwa/YuQ1w
	RN5THCsBJR604ZA8Gon3q7hWJbNNTpWcqA8gNOphBE8jIYNAFp0j6rYLBzJGHLXN
	oMYfEdCbx3TS0fqrAthGK8WBkU4++QzPAd6T4HPC7dTcQA7XJ9JxLf5ov/Hi6AKN
	AuIyoDeGJqp3PMmBnazh8Pw9efzHf0vmW+9Yo/jYxePV9W5f09lZ2HeP70aLVMG4
	P/Oca6iYIzOOGvS5X6/VFJtm3jXjKBgEXPgY0W/UZL4ZUE9rEp/BIpQSH4+QcICE
	A3mN8EvrjjWKXinbuRcsC14VEcztoHI3EnFUQi2ocOz/wA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LJHjrfKlQtI0; Wed,  8 Oct 2025 17:45:42 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4chgQH4wXZzlh3sY;
	Wed,  8 Oct 2025 17:45:26 +0000 (UTC)
Message-ID: <95e34475-0248-4c79-aedc-2922debcc9f2@acm.org>
Date: Wed, 8 Oct 2025 10:45:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Fix error handler host_sem issue
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, qilin.tan@mediatek.com,
 lin.gui@mediatek.com, tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
 naomi.chu@mediatek.com, ed.tsai@mediatek.com, dan.carpenter@linaro.org
References: <20251008065651.1589614-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251008065651.1589614-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/25 11:55 PM, peter.wang@mediatek.com wrote:
> Fix the issue where host_sem is not released due to a new return
> patch in commit f966e02ae521. Check pm_op_in_progress before
> acquiring hba->host_sem to prevent deadlocks and ensure proper
> resource management during error handling. Add comment for
> use ufshcd_rpm_get_noresume() to safely perform link recovery
> without interfering with ongoing PM operations.
> 
> Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 22 ++++++++++++++--------
>   1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8185a7791923..ff7a3d60b11d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6670,6 +6670,20 @@ static void ufshcd_err_handler(struct work_struct *work)
>   		 hba->saved_uic_err, hba->force_reset,
>   		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
>   
> +	/*
> +	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
> +	 * even if an error occurs during runtime suspend or runtime resume.
> +	 * This avoids potential deadlocks that could happen if we tried to
> +	 * resume the device while a PM operation is already in progress.
> +	 */
> +	ufshcd_rpm_get_noresume(hba);
> +	if (hba->pm_op_in_progress) {
> +		ufshcd_link_recovery(hba);
> +		ufshcd_rpm_put(hba);
> +		return;
> +	}
> +	ufshcd_rpm_put(hba);
> +
>   	down(&hba->host_sem);
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	if (ufshcd_err_handling_should_stop(hba)) {
> @@ -6681,14 +6695,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>   	}
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> -	ufshcd_rpm_get_noresume(hba);
> -	if (hba->pm_op_in_progress) {
> -		ufshcd_link_recovery(hba);
> -		ufshcd_rpm_put(hba);
> -		return;
> -	}
> -	ufshcd_rpm_put(hba);
> -
>   	ufshcd_err_handling_prepare(hba);
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);

Thanks!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

