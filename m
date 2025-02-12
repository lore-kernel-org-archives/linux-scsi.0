Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326EE260A2D
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 18:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386631; cv=none; b=UXQESoUzUyaz5voVO/tRRBdr+FH5i3M0cIiUaszjw6cRgaEPxTAmhp7goBPHp1GXYBouX8Tm0Uz+CqaUvAyEobJgr5ZhD0Amv5OrF3Hh/OoR0t15yEuCK1gxjFljiVG8bK2dYLTC5vWbDkfNU+tdDL9gRniqtOctMH9tOoWhgX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386631; c=relaxed/simple;
	bh=9Cr6Uw/rMIQAvgchMSd8RYknjObbuPr0Gr5m9E2HHO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stg8z6M5ydjVNw9DIb1DN+rSic7m1BAci8f8FdmDjmg1fXztSnz2HftUuJ/OHtPlVAxrwusdVSyqZUQjzBY/MmEbAd1P5jDWfZfTKrQHnmWlz+vcFZEg6VFr4jD29jCR7J3iXQdWo4Ozf9+gIFs2aUVIi8abuT8PsGJ6xHWRXwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4fQKToov; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4fQKToov"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YtSGr3K9RzlgTxf;
	Wed, 12 Feb 2025 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739386619; x=1741978620; bh=ZoN3YQWZuS7gLH6YxFu9pp95
	THUbAVtpkTvz38GaATY=; b=4fQKToov+7bwrlUC3Yjn57OE6wdkw/xyGLaZht05
	Vts8DefGP0zIq/wI7s7QqT3Z0kcJcvJSI+LPNmYNzv3EOwmrhk8ydBvdVR9FlkR3
	MFyFp4FTVTfRSgtxQ47IvIQgQXCaAYYvzsDDroDiHi6A3MJyulQ+MgvJFb5NodUv
	PIbu9PIH7R2yh85PBL7MHY2d5mUVwtaP9Gbtu6NkkIbgDI+ibparZq1ZsTJy36Kl
	L49kqD3IRA8CZMd9/VhGjdue02XsUgs1z+A2g6hjTyKyqiFuzhiEVe5LdCTK1yuO
	WWUKk1z1dZ4xyixQ1iw/AuGyHjDuMfDZbVqggc7Qwj24HQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dePFMeHZ9OkH; Wed, 12 Feb 2025 18:56:59 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YtSGZ2ZGzzlgTwc;
	Wed, 12 Feb 2025 18:56:53 +0000 (UTC)
Message-ID: <2fed801d-9cba-40cc-b50e-7ec9de041f1a@acm.org>
Date: Wed, 12 Feb 2025 10:56:53 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: add hba parameter to trace events
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com, subhashj@codeaurora.org, sutoshd@codeaurora.org
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250212101723.716477-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250212101723.716477-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 2:14 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
> index 84deca2b841d..e175020a2fcc 100644
> --- a/drivers/ufs/core/ufs_trace.h
> +++ b/drivers/ufs/core/ufs_trace.h
> @@ -83,17 +83,19 @@ UFS_CMD_TRACE_TSF_TYPES
>   
>   TRACE_EVENT(ufshcd_clk_gating,
>   
> -	TP_PROTO(const char *dev_name, int state),
> +	TP_PROTO(const char *dev_name, struct ufs_hba *hba, int state),
>   
> -	TP_ARGS(dev_name, state),
> +	TP_ARGS(dev_name, hba, state),
>   
>   	TP_STRUCT__entry(
>   		__string(dev_name, dev_name)
> +		__field(struct ufs_hba *, hba)
>   		__field(int, state)
>   	),
>   
>   	TP_fast_assign(
>   		__assign_str(dev_name);
> +		__entry->hba = hba;
>   		__entry->state = state;
>   	),

Why to include the HBA pointer in tracing events if this pointer is not
used in any TP_printk() call?

dev_name == dev_name(hba->dev) so the dev_name argument should be left
out from all tracing events that now have a HBA pointer as argument.

Thanks,

Bart.
