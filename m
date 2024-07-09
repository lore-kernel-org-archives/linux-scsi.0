Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F974365
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720549145; cv=none; b=DCJYgpJhp9sKpLD8lnGbBgm1oPzoTATZrGp7scdDMSN3uOT4MOKi2jsQ7FiXwCQq0eOLwyEsHBBSTGB5FVi8H7RUhZGUFq7UxHX93xdBeZ6fUtR0NR2hh+pwtCQUgw3IdF82NgltqSTRBPjxoOAjr64hSjMepVLwxfSdR19egjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720549145; c=relaxed/simple;
	bh=cXhI4k+hHbltLzWX2p6h8toimq13tMSUNHnILCdaCIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzQN8/etYeG5JeN6f5TgAIvqF1s8RosMhA4rD+suyOF7N45EZs0AbaOmiw82UoZ9nq2uuniT4Pac0jvZ0KtafZNws3O4WiRePj0wFE6qXCrzXLPsD9dPJ/1+LqCSz81jTQamzOZRdiThrcm8aNEk4uNMor610k///Ww0YWi8sKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TJSvuR7p; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TJSvuR7p"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WJTlV6kYBz6CmM6L;
	Tue,  9 Jul 2024 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720549140; x=1723141141; bh=oH5Oz9GI0N6/WQgJdLXpGQsz
	rt2cdW0kDUTK/yCezL0=; b=TJSvuR7pfs/+ADsOkMzrOR72XJHew/gQh6D571fF
	bp3AhrLimPo7oKVomLRpxRhOuGjuYNwdjeP/M/NUop3oWe62Z1bylXcgjs8P2j8S
	e8Ylx1Gkrz9fR1cTbw7vLdPHCx13g65cd29lwrNyM6XBlUtOhYJEhQGlHyaa7SR1
	rJUyg8ktK9df/vG2GIf2p+IJOTsThLJr9cirS2MWYSkPVQNBFRpIsd/ePGulA0Sc
	hKK9pnFW91IyJekDdbrHYcl5ZsU2nOc0q8B3b38V54T2oF93i2z72/ERggoK2HsX
	9a6rWJh40tMyJ9eMFKqgdyM+rTY6PrSleFavawhQJgIB2Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f_xultHrw4CG; Tue,  9 Jul 2024 18:19:00 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WJTlR3CFhz6CmM6D;
	Tue,  9 Jul 2024 18:18:59 +0000 (UTC)
Message-ID: <cb2ad7aa-baa0-4228-9d37-43e4562a9118@acm.org>
Date: Tue, 9 Jul 2024 11:18:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] scsi: ufs: core: Check LSDBS cap when !mcq
To: k831.kim@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "Ed.Tsai@mediatek.com" <Ed.Tsai@mediatek.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <CGME20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>
 <20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/24 10:25 PM, Kyoungrul Kim wrote:
> if the user set use_mcq_mode to 0, the host will try to activate the

set -> sets

> lsdb mode unconditionally even when the lsdbs of device hci cap is 1. so
> it makes timeout cmds and fail to device probing.

> +	/*
> +	 * UFS 3.0 has no MCQ_SUPPORT and LSDB_SUPPORT, but [31:29] as reserved
> +	 * bits with reset value 0s, which means we can simply read values
> +	 * regardless to version
> +	 */

Please change "UFS 3.0 has no" into "The UFSHCI 3.0 specification does
not define"

>   	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
> +	/*
> +	 * 0h: legacy single doorbell support is available
> +	 * 1h: indicate that legacy single doorbell support have been removed
> +	 */

have -> has

> +	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
>   	if (!hba->mcq_sup)
>   		return 0;
>   
> @@ -10449,6 +10459,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	}
>   
>   	if (!is_mcq_supported(hba)) {
> +		if (!hba->lsdb_sup) {
> +			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported\n",
> +				__func__);

A closing parenthesis is missing (")").

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index bad88bd91995..fd391f6eee73 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1074,6 +1074,7 @@ struct ufs_hba {
>   	bool ext_iid_sup;
>   	bool scsi_host_added;
>   	bool mcq_sup;
> +	bool lsdb_sup;
>   	bool mcq_enabled;
>   	struct ufshcd_res_info res[RES_MAX];
>   	void __iomem *mcq_base;

Please update the kernel-doc comment above struct ufs_hba for the new
lsdb_sup member and please move the new member above mcq_sup such that
the mcq_sup and mcq_enabled definitions remain adjacent.

Thanks,

Bart.
