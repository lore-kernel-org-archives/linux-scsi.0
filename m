Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7B9155382
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 21:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731273097; cv=none; b=ff4zzM/MIK6FhzfR+O3PS4TirQKr1too4aCtULSS1YTuyLmw+ImYKKqx0901oUnAkB5RamvU88DMZlC+5HVCq0vRfmFMpvWADQnSU4+yOA9HvOFP84IBmNG7MZw2tsnS72JOBeButlLftG0Ov1c5TEd8kFBYFqQsdXKrHPmDsbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731273097; c=relaxed/simple;
	bh=X47E0ZFGIyueQnluj/y1Ngv8NR1eUFnLubKE776JgsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OoO4Y6v9TJkP34aL8WQybDMjorLX7V/qiSw3Dg05gTZg28YJ9uuuSPVb4nkSiRHRE5fwfjdQmaE2PLV9gpbAYwQj+ZOd8K+iEaBUot3w+ZTFiGw0JMlOjlPyzwrtEiWAVL3cLGi5OrniLQbdwpyZuiiStA35jam+UPTE5AbHsBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jNVzylS2; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jNVzylS2"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XmljF0W8DzlgMVN;
	Sun, 10 Nov 2024 21:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731273086; x=1733865087; bh=RsNMbYx7uGNx8ZhX8n56eBir
	XWLJyaGi2nVsHVHax34=; b=jNVzylS2w/To3dTe8yDMR6/se0FwUTaGj3zHcVCZ
	kQZVaDsd37HwBB5QCd7SN483cAR9H+dUeAGjBZqRa+QXFy36812J05Rc8FNUCfc5
	ckraY4xK6muXRSRiLFaf5kdpSVQIJR/h0YwcUExr6DXReLp63VqrxVdX2rghmN3S
	ActRrsi7kQjh7otyBVGts5xWPEa5gtwERmGRIpvANdCXlBjjWzjKxgSeHIBOqoDk
	OuYReOhOnnQbiUt7zqNbviWydg4z0VH8ZZxiVJFcDEfU9lFE3XoKr3m69Nux9nv5
	zE8LAT0dnUiZKU53pdOebEUauXZ6a26JXnuXE7TXcAErtQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rLF3vym6LXX0; Sun, 10 Nov 2024 21:11:26 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xmlj94PZbzlgT1M;
	Sun, 10 Nov 2024 21:11:25 +0000 (UTC)
Message-ID: <2799bf7b-2659-4962-9618-559e6f2afe15@acm.org>
Date: Sun, 10 Nov 2024 13:11:17 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 2/8] scsi: create multipath capable scsi host
To: himanshu.madhani@oracle.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
 <20241109044529.992935-3-himanshu.madhani@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241109044529.992935-3-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/24 8:45 PM, himanshu.madhani@oracle.com wrote:
>   #include "scsi_priv.h"
>   #include "scsi_logging.h"
> @@ -394,6 +395,14 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>   	struct Scsi_Host *shost;
>   	int index;
>   
> +#ifdef CONFIG_SCSI_MULTIPATH
> +	struct scsi_mpath *mpath_dev;
> +	size_t	size = sizeof(*mpath_dev);
> +
> +	size += num_possible_nodes() * sizeof(struct mpath_dev *);
> +	privsize = privsize + size;
> +#endif
> +
>   	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
>   	if (!shost)
>   		return NULL;
> @@ -409,6 +418,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>   	init_waitqueue_head(&shost->host_wait);
>   	mutex_init(&shost->scan_mutex);
>   
> +#ifdef CONFIG_SCSI_MULTIPATH
> +	INIT_LIST_HEAD(&shost->mpath_sdev);
> +#endif
>   	index = ida_alloc(&host_index_ida, GFP_KERNEL);
>   	if (index < 0) {
>   		kfree(shost);

 From Documentation/process/4.Coding.rst: "As a general rule, #ifdef use
should be confined to header files whenever possible." Please follow
this advice.

Thanks,

Bart.
