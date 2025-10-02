Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8CE254B18;
	Thu,  2 Oct 2025 16:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759421928; cv=none; b=iYcauDFfFcxnGXxKg35pPetCWo/2ipQO0Jx4Ugf5ipINBTf/1AKVk1M9NoMhjlVyd0Jkcb3HrAngzLLyiZSTCwuAzyujBheIjARzMlVh0YtvXH370EZc1djvC/2FqZb/H4to5GGlaqOPLiPkxR/4P9RIIEU4W45hVFmVFZwkkAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759421928; c=relaxed/simple;
	bh=Xpb0UrjdBAyJ3z38h4AY6vd6b5j/oH3Du6AYnBhX4Gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qIgxhjK1PnU8l90w4w2hhHWxO1qm6s8YLbNGRofqUZYw4IIJZGcWEdbS2CzOIWlGQLvVf/e5o3U8gZ0ybDo353As6LscUhqX8oGV88DRfx+whD613jSvPZXNSxHka49I/u/3fU1W1dNyRvA00DwCZjWzHN7M/yDj4xmg7e4jPdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fYhbQHa5; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fYhbQHa5"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ccxn16Pzpzm16kp;
	Thu,  2 Oct 2025 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759421924; x=1762013925; bh=7bhvhhJ4JLF206lcr1wauf4d
	j7rGe65pQmQJK6fM2+w=; b=fYhbQHa5xMCdyTKQc5fqLHry5o/Xr+W5VJucRfcX
	DuEQdNS3vA2O8tdFIrwxU79HFSrr53KOIpIqdiwibtKTlQn+M+8kdiaGpd7b3xuw
	jPGV5l3XPXp+FQ70B3oU2/e+taKlwozuYKnF4cKXYJw4upS3oN6LoyLReF9i1zkR
	iwthy6deQrdsyTABIu80q0NX+c4wl6yAENM8OZTPKSwTZqCaXly6eYzMSGj2lCWM
	cWuW35MBFACWUMHJGSq/iuPzzuLxvDbIJPcN2tOs82QakeiXotjbQEtEmRW7+ppI
	G8LpjuCRk8sse9UhOeECNceP6/FgB4yiAovETl3aD2AwhQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6LkNq16KtErJ; Thu,  2 Oct 2025 16:18:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ccxmw2bDTzm16lN;
	Thu,  2 Oct 2025 16:18:38 +0000 (UTC)
Message-ID: <900c7e79-2cc9-407f-92cb-c6544cbc86c1@acm.org>
Date: Thu, 2 Oct 2025 09:18:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
To: Wonkon Kim <wkon.kim@samsung.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924@epcas1p4.samsung.com>
 <20251002070027.228638-1-wkon.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251002070027.228638-1-wkon.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/25 12:00 AM, Wonkon Kim wrote:
>   static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>   {
>   	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
> -	u32 mode;
> +	u32 mode = 0;
>   
>   	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);

Wouldn't it be better to check the ufshcd_dme_get() return value rather
than to zero-initialize 'mode'? I think that would make 
ufshcd_is_pwr_mode_restore_needed() easier to read compared to applying
the above patch.

Thanks,

Bart.


