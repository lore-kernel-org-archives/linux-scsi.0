Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20EA7442D;
	Fri, 31 May 2024 20:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186649; cv=none; b=IZ/p77EHa4gwvrmsE2CUIuoohZ4WeCqj0I0kB265xz5u6G6qH88FFCsKbepjC9Zdbr7yOSTNnHHMGCMZT52EK2xqv9WVdL62cLns4XwV09eAuF5O3zKUwvNJzpxmM+atBSsQwaYD8/fciJRvAGkW3LXVpb5ybYtvHKyhDf1O11g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186649; c=relaxed/simple;
	bh=iVyxCBgipN1/l7WejKasNNtGtZFAr+TSGnaoUVmpVNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sy/jEZT2TX9DLldpr3PPakOIZL4rskASFcxyC51PTFY3MG5rHWjk9W3YTx4fYxUOkDcVd+PMa9/lrDgWI8Gjc4n8Lh8dbNHnqWH6xoKwRgD/q0hIpZHqFPFzOeL3M8MVCZ7usHDEhH9cB3t3PcHi9ZqxLh+SvWRQ3DxZa7ds4eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bm1EuZZO; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bm1EuZZO"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VrZD072m3zlgMVh;
	Fri, 31 May 2024 20:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717186637; x=1719778638; bh=nyoplry9+EjDO2K6USEd2Rmd
	/CvDvmtOGGC+SvSL3Us=; b=Bm1EuZZOMUY78J7D90y3QmF5AwTTPzO08TNIRZsU
	JPjX01YaIBnUF/P2fd/HbwtSchjIbuulIRtLW3t5b1eit7uiP3a34HJyWwQicBi2
	yBbyrYQeS1LfNKmODjarAJXTiN62ZdhZIgbEDHiPT43SDNUgMIVxTNDbfXgrDwrm
	CedzA8QkuL1AGuDZkt88rUswzlzbAFv4ghEJcKyx+u4pOk6pZx1/EvGJt8YyW8eU
	prrLFJFr8llhWgbHVduzXCxSLWtE5tLM8cvmWDHtHmzvw8F39OD228UECNj4SqzL
	/+I3zSYFWGj3+2s3KdZ6smLZ01vCqyXMBqijt29cxM/X3w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sqvcXqvhu2j0; Fri, 31 May 2024 20:17:17 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VrZCx1Fg9zlgMVf;
	Fri, 31 May 2024 20:17:16 +0000 (UTC)
Message-ID: <c49fe0fa-9924-4ff8-9775-080b7b470d41@acm.org>
Date: Fri, 31 May 2024 13:17:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ufs: mcq: Prevent no I/O queue case for MCQ
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
 <CGME20240531104948epcas2p1a70f31cd4a1aa5d36267b4187d75056b@epcas2p1.samsung.com>
 <20240531103821.1583934-4-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240531103821.1583934-4-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/24 03:38, Minwoo Im wrote:
> If hba_maxq equals poll_queues, which means there are no I/O queues
> (HCTX_TYPE_DEFAULT, HCTX_TYPE_READ), the very first hw queue will be
> allocated as HCTX_TYPE_POLL and it will be used as the dev_cmd_queue.
> In this case, device commands such as QUERY cannot be properly handled.
> 
> This patch prevents the initialization of MCQ when the number of I/O
> queues is not set and only the number of POLL queues is set.
> 
> Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
> ---
>   drivers/ufs/core/ufs-mcq.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 46faa54aea94..4bcae410c268 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -179,6 +179,15 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
>   		return -EOPNOTSUPP;
>   	}
>   
> +	/*
> +	 * Device should support at least one I/O queue to handle device
> +	 * commands via hba->dev_cmd_queue.
> +	 */
> +	if (hba_maxq == poll_queues) {
> +		dev_err(hba->dev, "At least one non-poll queue required\n");
> +		return -EOPNOTSUPP;
> +	}
> +
>   	rem = hba_maxq;
>   
>   	if (rw_queues) {

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
