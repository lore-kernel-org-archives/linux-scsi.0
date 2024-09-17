Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915AF13BAFA;
	Tue, 17 Sep 2024 18:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726597307; cv=none; b=lwyufLlaIQz26Ir21aJkDJfuitij+XzOc8mN7A5lDrK3qPkXAtTSZmesXLya4p3242t/WVYBbWma90QzoilXEJVtXjWlmiu5Whj3+NFbqIh9EdCHRCG++ZtDad65O/yc2eqTtjHPADihFBevpYEGFHntm/gzaRchB0Ze1BrFUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726597307; c=relaxed/simple;
	bh=d/FGdE5p3l5KSKe+3EQ85x/v/U3i1kvogPNYEAMP1MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r7eFrFs1xVUMZA29xzE9U6kjP1OPX92h2Bs//dPrh4nOCgCZIr4sMJ7lSGSj7+jbKfExuTZuIxh+TFO4tRNn44tiy0TsbUqoqvy33SNiKGd5foY05lgARGFo9O14s7sM1maMulKXVVwuJotuprhL8FVCpL5admg50FYle5lIPns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FaUNlyrj; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FaUNlyrj"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X7VVK07RgzlgMVT;
	Tue, 17 Sep 2024 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726597302; x=1729189303; bh=AWzpBz0NXcHkJr5RdTZqdjJ7
	Yk9gXxkmI8DiKLOd/lg=; b=FaUNlyrjWYKMUYXE7ISIpvvs8EyF+cw/Ti4a3w7G
	WK7bpk4cz/zYSBOkk9iebUZwADxY6xmY+cyhnD/UPibAu7iEqrXFkN/jgnyFJnpt
	Hs1QhcxXuNJfha/WbOEyOg5UvORsE1spOjxxny+It3XBllso4u5yqTU5aA08dcY/
	EJMOdi1AJvNQl3lwonPpUCzNn1PmR2e/PWi7vpRuk4tYT89BXpoxtbyp/tz4LSj3
	E+6cN+dDaWoAbxV8pAXrvoikh+7Lemp1nRjx82hD1l9oO3MzCyvGpB8v+laFqq9u
	CC+q8A0hawDfoChSDiQplULvTjikYnzp4yObs7Z5wdPdxg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZZpasyyRYEDL; Tue, 17 Sep 2024 18:21:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X7VVD6KwhzlgMVP;
	Tue, 17 Sep 2024 18:21:40 +0000 (UTC)
Message-ID: <5c15b6c8-b47b-40fc-ba05-e71ef6681ad2@acm.org>
Date: Tue, 17 Sep 2024 11:21:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240910044543.3812642-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 9:45 PM, Avri Altman wrote:
> Replace manual offset calculations for response_upiu and prd_table in
> ufshcd_init_lrb() with pre-calculated offsets already stored in the
> utp_transfer_req_desc structure. The pre-calculated offsets are set
> differently in ufshcd_host_memory_configure() based on the
> UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk, ensuring correct alignment and
> access.
> 
> Fixes: 26f968d7de82 ("scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> 
> ---
> Changes in v2:
>   - add Fixes: and Cc: stable tags
>   - fix kernel test robot warning about type mismatch by using le16_to_cpu
> ---
>   drivers/ufs/core/ufshcd.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8ea5a82503a9..85251c176ef7 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2919,9 +2919,8 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
>   	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
>   	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
>   		i * ufshcd_get_ucd_size(hba);
> -	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
> -				       response_upiu);
> -	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
> +	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
> +	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
>   
>   	lrb->utr_descriptor_ptr = utrdlp + i;
>   	lrb->utrd_dma_addr = hba->utrdl_dma_addr +

Please always Cc the author of the original patch when posting a
candidate fix.

Alim, since the upstream kernel code seems to work fine with Exynos UFS
host controllers, is the description of UFSHCD_QUIRK_PRDT_BYTE_GRAN
perhaps wrong? I'm referring to the following description:

	/*
	 * This quirk needs to be enabled if the host controller regards
	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
	 */
	UFSHCD_QUIRK_PRDT_BYTE_GRAN			= 1 << 9,

Thanks,

Bart.
