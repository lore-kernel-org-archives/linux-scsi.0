Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469893ACA52
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951132; cv=none; b=ZHu9f55P+diYfGBHZiSsaFoMedGhSyIGNJSDuW4m8cLfGBx2R8DOtWG8J75z2MYuCBa0iusZsTcoCJHnf2kU1H3JngzCojp4MCqBUbq9mhmu2yYvPIBJyek7OrDS+7hdVN2XS+sTzPR89tdxGph/IntPTxO+1K/G52fNYUejyg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951132; c=relaxed/simple;
	bh=vLWhWAx6OKJPKViZqYGDvb6uFz3jJrLtc2p8v4g42lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jF8Kzl6Y7YSp5Oem+FaYE8DCQdTwPBwTpbheb44uA7zGzuBbyeA4IaTInXGRgtOpKNHdP9C6IHQdJviwoDnS5wshUD+MXsDPOUjNzCd7zQXjsFouJssBIl6GGS9YgrABqnO4Ll/7Jw/wdMBq6+MjqeqIc/3t0H2JUJUkzR8VVNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=heMbiarK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="heMbiarK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fL3MG5lclzlh1WC;
	Tue, 24 Feb 2026 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771951128; x=1774543129; bh=CKkF4uDDvCX+6QA7K9hqucj5
	ZS+8povK3VMXmd/qNkw=; b=heMbiarKT2EbTdqQGTGJa3N3y3WJO1yP7yRoSGL3
	WXgB2R94vleDMPnbrlQyhb0XzieqPO5WiXRjwIKNcJmJh7bhez3uW5bHo+LY640O
	3KDYibdPODkSsSyTj8qJOvH9vCZHj8FAWkwlYdSumEIsaPsML2UZ3i2SBEzzj+Bm
	NhKQrYAUnnZ3ZWeM2CbnHOXztAFtmdXkfxMeM060FtxFoKvJ4jZF3MbpEH7eNezf
	w0iX9XEEb2GO4wyL/wW0xzpkgmemdyRRXLc/6x0+XDZKH9vuhwL5PIW0t3PWDKE3
	zoJBBm8FQ5kPU50oe3WibFbdYcd68mjFTn7b/tbpgh7zxQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2AfVCIT5UEfL; Tue, 24 Feb 2026 16:38:48 +0000 (UTC)
Received: from [172.20.150.38] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fL3MC0zgHzlfdfS;
	Tue, 24 Feb 2026 16:38:46 +0000 (UTC)
Message-ID: <c1e2f51a-7314-4470-985a-73341008ed7e@acm.org>
Date: Tue, 24 Feb 2026 08:38:46 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix shift out of bounds when MAXQ=32
To: WangShuaiwei <wangshuaiwei1@xiaomi.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 linux-scsi@vger.kernel.org, wanghui33@xiaomi.com
References: <20260224063228.50112-1-wangshuaiwei1@xiaomi.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260224063228.50112-1-wangshuaiwei1@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/26 10:32 PM, WangShuaiwei wrote:
> According to JESD223F, the maximum number of queues (MAXQ) is 32. When
> MCQ is enabled and ESI is disabled, nr_hw_queues=32 causes a shift overflow
> problem.
> 
> Fix this by using 64-bit intermediate values to handle the nr_hw_queues=32
> case safely.
> 
> Signed-off-by: wangshuaiwei <wangshuaiwei1@xiaomi.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 847b55789bb8..8e0d02a77a55 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7097,7 +7097,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
>   
>   	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
>   	if (ret)
> -		outstanding_cqs = (1U << hba->nr_hw_queues) - 1;
> +		outstanding_cqs = (1ULL << hba->nr_hw_queues) - 1;
>   
>   	/* Exclude the poll queues */
>   	nr_queues = hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

