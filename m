Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32282DCF60
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752851606; cv=none; b=to0ePbtWrVsvhMEDaUsc4F01UN2TLkzveE0bEsfA+XeMfPY7tZX2t8k0de28YcMilButQ9Vf38yDATOpqohwibxrXvjK8Vch47BNwGaO5EDrzAgVObB+beiiaQuCjgrK7h99M9R1iGYYYVzjLQNeN2qHStEkvjjJR7WalxBDelE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752851606; c=relaxed/simple;
	bh=tK99eACdiN8POKehLMTcLRKkz3ETDNCQeKrCHxbYd98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IlOq6qL6z57I0A5G6iKf5Xzwu1Ly2XUQe9j8CLoxcPBfiIDO7QEGEpmi2RGPATZ4xJMGmKa9Pqcz/oQ55YQDkVemTTXUq9wjw4gDs7v4+mBoEUQlGubKTmzgFg6RZD/+Lxm5kFQ6XcVHUaITAKHrdzTcnqi7WhmFnZi1cT/T2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4cIORkKN; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4cIORkKN"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkCwd2YB1zm174K;
	Fri, 18 Jul 2025 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752851598; x=1755443599; bh=ewDHWtsj3AFeozR0rjg1tVfn
	4EXPf5xtbOK1pz0V3m0=; b=4cIORkKN7DdT0uw0u44dvXDSsopw1fFoWNjvK3SA
	EKt8oOL/RhQzA1Iat8Qm6rPAHu0PTkw4XjP+tVYXvfJJgmKkMEyWsaXoj3wmBtj3
	B4msNZRezgW1oqKGmoWo+3vL+f1pMvtbYxwt66xT6MqL/LRhvVDcO5zwu4FQ1+3Y
	9hlzfxpWYrXmXYVnzKaK0Y6hgQ71OmbpjxFJ1eWF8FsKYSQnHIEpGKPyPVf2Fx5C
	KII+QyhKKkNO/LVDOGviTwldtiAuI+MVsfdHwJduIrgqKI1nmFZDeJKLRAIEbZW3
	H3v75vKM4E61TVlrBwkwjCx0aVyRHkRMp6nqfnnqTzigzw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1Y1LSqAZk1z0; Fri, 18 Jul 2025 15:13:18 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkCwH4KxTzm0ySb;
	Fri, 18 Jul 2025 15:13:02 +0000 (UTC)
Message-ID: <06cca9bf-e88a-4884-811b-ec103ca6f40f@acm.org>
Date: Fri, 18 Jul 2025 08:13:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] ufs: host: mediatek: Remove unnecessary boolean
 conversion
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250718095524.682599-1-peter.wang@mediatek.com>
 <20250718095524.682599-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250718095524.682599-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 2:51 AM, peter.wang@mediatek.com wrote:
> This patch removes unnecessary boolean conversions to ensure consistency
> with other usages in ufs-mediatek.c. The changes simplify the code by
> directly returning the result of bitwise operations without converting
> them to boolean values.

Hmm ... the conversion to boolean still happens but now happens 
implicitly (by the compiler) instead of explicitly (via !!).

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 182f58d0c9db..14f0130da653 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -96,28 +96,28 @@ static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
>   {
>   	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>   
> -	return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
> +	return (host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
>   }

How about removing the parentheses too since this patch makes the
parentheses unnecessary?

Otherwise this patch looks good to me.

Thanks,

Bart.

