Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A6A330B2E;
	Fri, 17 Oct 2025 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716496; cv=none; b=SN/Ug4ZFd6YdH3OZL9Ywi8Lsc8pUYDeyvUvUXM86Cn2QKVO39s4FWc4zXYP9ZHvS+0X09YP3hgVPy7XgcPL5AtTy38dD4N2WGxcpIOUCltM2S7JksapcGAFUD43q4XfMdtwObro0tfj1mPHTAInJgV7mXmXZEwZxv4GDVeXIa8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716496; c=relaxed/simple;
	bh=gaDJHeRZ5ZJwTcWXNPpZJZWDFxSnFNmaOa6R16saWag=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iQ7ypTsi5JVoBkAquq2sw6V/iOscPOh0vO7lmPpA+S4cgGTJosCWNBaTV8syao1RfRq9mHgBk0M1DGQpa7GcW2L2lFlDIqvOblNqewGyfOOAhPwkeXHtZJfwwlDrMBS1H9KoFlEhUpq+owhDuJPc6CrKbm4mi0wUNZABNZujnR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k4s7IrYQ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k4s7IrYQ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cp8XY4Jn4zm0yNQ;
	Fri, 17 Oct 2025 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760716492; x=1763308493; bh=mCwP44KgtAbXLi0MyxeUSmOX
	MKhYK79gH5zwJoe4tOg=; b=k4s7IrYQAAuHXF6d1TekKg7kWz3vFvOsmpvtRHQV
	L3Rz88j7v/YPuMaqAgAPDaaOrVtsHwYLDMUX5lxsu2u6TWV9elv7o1oR4v4AwD8E
	I7bHnH9zqaGQj+/rEE8e+NCy/oMRdGDr8owXZiUYiht3kJq4YoJJcr+36SJR71uJ
	Paw0gc3C2E80NFqcxHRs17LqQdBsMCJB+0jYygb99vOiRAEBPPK3mZ/011wHT/0q
	HLXGgHt0GQwiNulIc51ZzLm4Bf0qxYIDeZCFUnu60a7nhXHlGtPmlW7/B/4iZa0R
	2a/q3J9k+DeFmhz20R4Zlh/QQQCjKdXk5uEYH7M7ZERETg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u9wzuxrV_7jD; Fri, 17 Oct 2025 15:54:52 +0000 (UTC)
Received: from [192.168.15.91] (unknown [216.194.108.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cp8XR2zBLzm16kp;
	Fri, 17 Oct 2025 15:54:46 +0000 (UTC)
Message-ID: <5befc42a-9e00-4d03-a392-f2d823ffd872@acm.org>
Date: Fri, 17 Oct 2025 08:54:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Initialize a value of an attribute as
 returned by uic cmd
To: Wonkon Kim <wkon.kim@samsung.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca@epcas1p3.samsung.com>
 <20251014044046.84046-1-wkon.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251014044046.84046-1-wkon.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 9:40 PM, Wonkon Kim wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9a43102b2b21..6858f005cc8b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4273,8 +4273,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>   			get, UIC_GET_ATTR_ID(attr_sel),
>   			UFS_UIC_COMMAND_RETRIES - retries);
>   
> -	if (mib_val && !ret)
> -		*mib_val = uic_cmd.argument3;
> +	if (mib_val)
> +		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
>   
>   	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
>   	    && pwr_mode_change)
> @@ -4990,7 +4990,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
>   
>   static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
>   {
> -	int tx_lanes = 0, i, err = 0;
> +	int tx_lanes, i, err = 0;
>   
>   	if (!peer)
>   		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),

Please split this patch into two patches: a first patch with the
ufshcd_dme_get_attr() change and a second patch with the
ufshcd_disable_tx_lcc() change. Please also add a Fixes: tag to the
first patch. That will cause the first patch to be included
automatically in stable kernels and also in Android kernels.

Thanks,

Bart.
