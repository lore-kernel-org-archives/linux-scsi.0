Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABA4195;
	Wed, 14 Aug 2024 01:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723599709; cv=none; b=eh0PDLl4pVoI3EXXZ8/iy5gTZtdsrW6qVlZgUkhRV+UqB1atMb32rtMMR5dkqo/T630hyyriQ7dyAvYtwV0J+NuVz/XM/y7u0PdD8W2Jl8Rk0ZMeo+sJ4dSePLGW30Qa+7U0vePtoQuqjQnQmBbpYJG1wge8vTeBDdKgsYtOA1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723599709; c=relaxed/simple;
	bh=ndoIQQGmfXCxhqDwh5Uh3xVbrVVoHqkoxLgmdSPBzVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WTVHWQnG9qsQTr7WpVJZfbl0kq1qWYA7DY0nPVC0RqlX6t2xetddvfhFad8NmupT513KI3jYBgzcBscUAJAuCzy6ZedjHRUXvoWJiX4iActUprh3xDTpsNXpBBdMN+b/8aFsM/afI8f5bVK6hiWVKyq399Q11gqyi7t9cXaOTiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mnx/++Ml; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mnx/++Ml"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wk9w43HWKzlgVnY;
	Wed, 14 Aug 2024 01:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723599697; x=1726191698; bh=rvs/VRBEmNk5DZozy8w5EZO0
	viZDCy22tk7qlebXLsI=; b=mnx/++MleogbbCyeg13MyyiWQdTrUVmyGKiMasa6
	hnmkOj1Wmy2/DnEuHkvzTINgbdATitQsCLhkX1X2Nd49TzGvqov3bLVta5uGYjJ5
	KqzdPGADqPa/ah4oq/X3uD0fxahUEqg33nDUt+nLvXpqc0N/O124nPAUpPz3aB7m
	FLMdxK5LO+8dOMTgGiB0vYn0pwoKiK9A97Eek642Le1IhWhjjXB6509J7trLkTCY
	GQlqDgV3zgxx0mHbpiYQR9QukOT2OQnzc8cUHjUhnxcDvFIeChx7y3kn1OfInYxB
	on9nlZib8zqcDZieknCclqhgsHasvqu9vOJLHBwYOcJqfw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OUEOPTwRH8iA; Wed, 14 Aug 2024 01:41:37 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wk9vx75nnzlgVnW;
	Wed, 14 Aug 2024 01:41:33 +0000 (UTC)
Message-ID: <b2fbe277-2819-4af4-9b36-b7407618cbf6@acm.org>
Date: Tue, 13 Aug 2024 18:41:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: fix bus timeout in ufshcd_wl_resume flow
To: ZhangHui <zhanghui31@xiaomi.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.co, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, huangjianan@xiaomi.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240813134729.284583-1-zhanghui31@xiaomi.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240813134729.284583-1-zhanghui31@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 6:47 AM, ZhangHui wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5e3c67e96956..e5e3e0277d43 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3291,6 +3291,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>   	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>   	int err;
>   
> +	if (hba->ufshcd_reg_state == UFSHCD_REG_RESET)
> +		return -EBUSY;
>   	/* Protects use of hba->reserved_slot. */
>   	lockdep_assert_held(&hba->dev_cmd.lock);

Does this change make ufshcd_exec_dev_cmd() unpredictable - it succeeds
if the controller is in the normal state and fails if error recovery
is ongoing? If so, which code paths does this affect and/or break?

Additionally, I think the above check is racy. hba->ufshcd_reg_state may
change after the above code checked it and before ufshcd_exec_dev_cmd()
has finished. Wouldn't it be better to make code that shouldn't be
executed while the error handler is ongoing wait until error handling
has finished?

Thanks,

Bart.

