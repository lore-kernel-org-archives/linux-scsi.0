Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B602187570;
	Wed,  3 Jul 2024 19:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720033906; cv=none; b=IFKfX/XbMebltPfkBGd3Y8y+GnnCkO2UEnD2CASeor85mw3g2G6HWOd9ezgKHNhskfZIfkDgBSz+YBPa6nbaxMcwTdt795Tzg3ntNqqO6cjnvPu778+0eiZ5VrFomrI7tUFI9nqmWSYYpai/FFq6TSVFxUwGRpOptI5tbBRKRSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720033906; c=relaxed/simple;
	bh=3E3xPWB6kiGiSy2QWa5qKXmQoyeUU4QTQ749wteyoL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B00P7OrrqV0CFeBOvuR8YSUKMqPjcpQZ4c9zAIUuYcuCvt0geTepA2YVCboBBGxrIA1RNhQA17DOi2IVjBAnFgeYG3A0zkna4fupflKTmjIFL3wYq9F/SzQZCG4oPmk4pEGA3JfK32ExLAe1iZVi/P4cR4Wznt7IocY30Og99P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u8sAIh0k; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u8sAIh0k"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDqC3677jz6CmQyM;
	Wed,  3 Jul 2024 19:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720033898; x=1722625899; bh=6m7fScHfvSHfw4I4vLfsawbF
	PucKc6EUzaqYNkps4vk=; b=u8sAIh0kNsdEUfY3MOrGoAaI0TvCnPmXQIvsm6OL
	9lo1D2nPKU78UC38EZODq5CQOs72rsYWTiZ34GJHD/NZSo5kHfAoxLqvUd1FxkQf
	pzlLd7q2g8l0EhAnZU5ZEdoNbWcnoGNL9abkOrBFNyVJI2n0dHvX4bogQ3U/ZYL1
	lbpMsdd1GFrcet6GTtD1RTelariLEJ5bY5Pg24GFooW7dQEwEFYFe/Ya0qVnecC3
	5WwGEzGbhNfUGfiAqEM2NqMWJJhjyxNWxhQrWCD8evKYrm11Zi6/rHgre+AsG/dk
	rZ6Z4v4Ovq4TYoRvnaGAkqsRstdtEFlj6ajkzgNN3xt4aw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ot4i4DB33GKA; Wed,  3 Jul 2024 19:11:38 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDqBw15YRz6Cnv3Q;
	Wed,  3 Jul 2024 19:11:35 +0000 (UTC)
Message-ID: <64d7746e-4751-4f46-a603-ce07f586b2d2@acm.org>
Date: Wed, 3 Jul 2024 12:11:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1] scsi: ufs: ufshpb: Fix NULL deallocation in
 ufshpb_pre_req_mempool_destroy()
To: Aleksandr Mishin <amishin@t-argos.ru>,
 Daejun Park <daejun7.park@samsung.com>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20240703111751.23377-1-amishin@t-argos.ru>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240703111751.23377-1-amishin@t-argos.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 4:17 AM, Aleksandr Mishin wrote:
> No upstream commit exists for this commit.
> 
> The issue was introduced with commit 41d8a9333cc9 ("scsi: ufs: ufshpb:
> Add HPB 2.0 support").
> 
> In ufshpb_pre_req_mempool_destroy() __free_page() is called only if pointer
> contains NULL value.
> Fix this bug by modifying check condition.
> 
> Upstream branch code has been significantly refactored and can't be
> backported directly.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 41d8a9333cc9 ("scsi: ufs: ufshpb: Add HPB 2.0 support")
> Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
> ---
>   drivers/ufs/core/ufshpb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
> index b7f412d0f301..c649e8a10a23 100644
> --- a/drivers/ufs/core/ufshpb.c
> +++ b/drivers/ufs/core/ufshpb.c
> @@ -2120,7 +2120,7 @@ static void ufshpb_pre_req_mempool_destroy(struct ufshpb_lu *hpb)
>   	for (i = 0; i < hpb->throttle_pre_req; i++) {
>   		pre_req = hpb->pre_req + i;
>   		bio_put(hpb->pre_req[i].bio);
> -		if (!pre_req->wb.m_page)
> +		if (pre_req->wb.m_page)
>   			__free_page(hpb->pre_req[i].wb.m_page);
>   		list_del_init(&pre_req->list_req);
>   	}

Are any users of the 6.1 kernel using UFS HPB support? If not, another
possibility is to backport commit 7e9609d2daea ("scsi: ufs: core: Remove
HPB support").

Thanks,

Bart.
