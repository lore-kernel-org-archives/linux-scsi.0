Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E582DFA3D;
	Mon, 14 Apr 2025 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744648073; cv=none; b=oI0+6BFa+O5ukGrsUQ8+vsmvXtlKBkGM8Dsh3UziElUlpQXcjt0WalSt6ExrgpU/KpyHoYodrWUPIOkcFiLVGKOfCEK7gbgpsv5LmzFvfzth7kETu4T7hy2qDAJwsTdSB/FI1RdH4SH/ecieZsA/a5gZvtzMdL2n1uwxRfOm3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744648073; c=relaxed/simple;
	bh=GN6bGCm7c5dXhkkB/e5awNbM6ayXDhFIsgWWcafbMsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsUiSXqEbRoEjJOF8JOsJtTWwxmLs7R2aN87fJ19NZIzHhOcIWUSR3OykffK2ebn8pEHOyGLzskqSQdVJtKBcC3AzG8dv4itCYGGKV1S5/SrkMqqrojspOuKqzB2N8Y7/ggAykNx38k3mvz84wVYii671Zw/mO20K1xicNlKoXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h8AiMeby; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h8AiMeby"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Zbt4Q4T4Zzm0djJ;
	Mon, 14 Apr 2025 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744648067; x=1747240068; bh=eNupomQxpwde+WQEUUu1iZPF
	xc7hWF7E5h8lfr3oqq0=; b=h8AiMebya6nfhoA4vE5/mZP+oR4Xx3LGMGKZ79GZ
	hX4Wvi2ZyE4kPy2Lnv+4sjJnzXCvbJk/yFQ6ALyZ2T6Svd0ZCoXpg2OugSZdm9x9
	1pgEuoyXzXmOV190cMcvzVC+53bN7mZuf8oXz2fMFMN8QHTPwi9UZxoAC2y3hNO9
	pIsplrV7c6/wLRVj8IAR6kCr22rk0b/jvCmD+lT/+38seIOg/S/425sDXgpXCwUk
	Jjya4wDciU3XL2lDgCpBgma3n1POaYlEKTLftMPnClKMTnz49Pzg86BNXexpmMT5
	7oN9rKourfGx3ZTx2SuGFxfX5aGq/edljYyrGEXEXZNWYw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3so8gtFosdKX; Mon, 14 Apr 2025 16:27:47 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Zbt4D0g7fzm0ySq;
	Mon, 14 Apr 2025 16:27:39 +0000 (UTC)
Message-ID: <68dea32f-e1c9-4e17-902a-aadc0a8489f7@acm.org>
Date: Mon, 14 Apr 2025 09:27:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Add NULL check in
 ufshcd_mcq_compl_pending_transfer()
To: Chenyuan Yang <chenyuan0y@gmail.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, stanley.chu@mediatek.com,
 quic_cang@quicinc.com, quic_nguyenb@quicinc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250412195909.315418-1-chenyuan0y@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250412195909.315418-1-chenyuan0y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/25 12:59 PM, Chenyuan Yang wrote:
> Add a NULL check for the returned hwq pointer by ufshcd_mcq_req_to_hwq().
> 
> This is similar to the fix in commit 74736103fb41
> ("scsi: ufs: core: Fix ufshcd_abort_one racing issue").
> 
> Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
> ---
>   drivers/ufs/core/ufshcd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0534390c2a35..fd39e10c2043 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5692,6 +5692,8 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
>   			continue;
>   
>   		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
> +		if (!hwq)
> +			continue;
>   
>   		if (force_compl) {
>   			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

