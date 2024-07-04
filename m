Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D8A47A53
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jul 2024 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720114898; cv=none; b=pMfwRZr5q6l+coPGWDpXoIJyVw0KjJmK+JpgBwXlJSZNBq+qKJTQxbemaRsBoV7FawpsFNU1VF9t5NEKP4A60jxD72+VfZLTsLbDLQoX7SSG36d9XdeqCJM3HOICq9CFbs8Ugf4XDxtcDaqqTfXVdh0HsQU25ZgqsQsXp77Qut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720114898; c=relaxed/simple;
	bh=Q9jH46RRikkGcqb3a3I/fPAXImB1PPkbElnA4O+m7yw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMxyqP2nk0y9zxfEoYxmMYBZ0h4GzVJ4KGX1y0YWE7GYlENXgsS6tM0rF1yFrA6FantZPx/P1C+JV338onq9hhtyWmQSuw/UiIdDXBBEHi6M8fph5NRkA/2itU7GI8QOlUy40nbwhadTaeE2PduiWDjvd6WrPnGVLBrA9bMbHAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XA7QtD6E; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XA7QtD6E"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WFP8b5Py1zllCSC;
	Thu,  4 Jul 2024 17:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720114893; x=1722706894; bh=bixGYAFihrOOfDA9ydD8BIZZ
	mTMt/TKNctyzJBjs10w=; b=XA7QtD6EDeVT1CgD4V8K3uJJ+u4hyutnESHQKN67
	ul5AduXuARdTNvJjPkjdVf1/4JzRy6VjgIVwyN+PUdxFTLfnqyf2NvpLRq3qXv6j
	n/LUvaIP3KLQy9leOFrL+O64FA6jC3dTg4y8L6uYQcU+W9RqhkAk0RJvOErH+EiN
	O4+RHV9l8DfQiIesSrRZ29hwtuxo5joB4hddQGvm2KkVWH1AbeTLyeOZ9eIBzHni
	5j8dM04/DDfbwm4RQCerQ6/LCfiNFzaopa3bEpyoi925pBBve6nqVMDELqFWpYKe
	AgBNIPqWceFGiNI5yYB0MDzsjpp3Kqr3eDfhaYQvZQow5g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jeOHXJnsAOmv; Thu,  4 Jul 2024 17:41:33 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WFP8X2QQ9zllCS9;
	Thu,  4 Jul 2024 17:41:31 +0000 (UTC)
Message-ID: <16e65435-4891-4b5b-966d-15ec807702ca@acm.org>
Date: Thu, 4 Jul 2024 10:41:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Check LSDBS cap when !mcq
To: k831.kim@samsung.com,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Minwoo Im <minwoo.im@samsung.com>, SSDR Gost Dev <gost.dev@samsung.com>
References: <CGME20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p8>
 <20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p8>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240704033829epcms2p818bb2892b4ec9536c85c1a7de925fc73@epcms2p8>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 8:38 PM, Kyoungrul Kim wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 1b65e6ae4137..c706645c0914 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2413,6 +2413,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>   	}
>   
>   	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
> +	hba->lsdb_sup = FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
>   	if (!hba->mcq_sup)
>   		return 0;
>   
> @@ -10449,6 +10450,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	}
>   
>   	if (!is_mcq_supported(hba)) {
> +		if (!hba->lsdb_sup) {
> +			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported\n",
> +				__func__, hba->lsdb_sup);
> +			err = -EINVAL;
> +			goto out_disable;
> +		}
>   		err = scsi_add_host(host, hba->dev);
>   		if (err) {
>   			dev_err(hba->dev, "scsi_add_host failed\n");
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
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 385e1c6b8d60..22ba85e81d8c 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -75,6 +75,7 @@ enum {
>   	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
>   	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
>   	MASK_CRYPTO_SUPPORT			= 0x10000000,
> +	MASK_LSDB_SUPPORT			= 0x20000000,
>   	MASK_MCQ_SUPPORT			= 0x40000000,
>   };

The LSDB bit is defined in the UFSHCI 4.0 specification but not in the
UFSHCI 3.0 specification. Has this patch been tested on a setup with a
UFSHCI 3.0 controller? I think that this patch breaks UFSHCI 3.0
support.

Bart.
