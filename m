Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426F14689
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755044229; cv=none; b=XRwc3AjYid8dR7zBZ40VhcfRjb3Hyr4onBGBvhAHZRa6AyVTV3Dv1/TyFrPxpEGkidUmHhyzWF2RZqUHcmSfNjrhMlW77d03sIw+jP0tKFeigQMI8cwiDsq4kNR83zp8Obn1sIjSXnEJd8av/BVGdhJAOvfJaxODCEFrGlaBZrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755044229; c=relaxed/simple;
	bh=tNte6iVpBUyiBb1Rpjbk8YCIKpM11//PefPPysacCKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YsV21ftVe4bW9/M9ongOe2YaNNHvyBkB2OnL2EmAF4KCTzSpeFQ150V2IzcE/pHYmXEhVTZ1Cp1TCp6/4h5zG1uXO/CKO2Pe21sjKOXj05IpaA4Ci9qKD8wOIp6CCgkSx3k0ezN1UDCgYXm8YnzcojeKeDf9rifPtMtngJOmJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Qr8QTO5D; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Qr8QTO5D"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c1ppW0pGPzm0yQf;
	Wed, 13 Aug 2025 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755044224; x=1757636225; bh=EZbsMvrqt+El7F4dc4PLYqOx
	nv4rxZBGKS+pxD59C0U=; b=Qr8QTO5Danadm/cNjIBN+bMVC7mGKYhAnogeo2/V
	FHhYv11+RM7ckt/IpL/ZvF5WROZVDvoZt4+7Y0CwEaimrwOc3IlL5BBVheUDLvMq
	odD0z3xHJdQUbLvjyOvoSfQSzC1YaETo1J7YjKr/3SwjKlaEXOHw4lnszCLyclGb
	tjK9yCW8u9wV9/ybrzP5Oep/JTdlt98NSqK3IrgEfsJfi38/sH+0rKQ2vDP4FH/Y
	Xt8ZNVhOhySEAPoHnwDBxvkQKmnvKVadoKjRCw0VZfp607RI7QpN+N81tEhRXpJE
	pNzN2cLywxFTvP3gcPslbttM7jMloZrqUhj0136qAHkAuQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jxO5A_jwBEXA; Wed, 13 Aug 2025 00:17:04 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c1ppM3MYKzm0yNM;
	Wed, 13 Aug 2025 00:16:58 +0000 (UTC)
Message-ID: <de7aabce-0f59-482f-b431-420cd897e4b0@acm.org>
Date: Tue, 12 Aug 2025 17:16:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: scsi_debug: Add option to suppress returned
 data but return good status
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250716184833.67055-1-emilne@redhat.com>
 <20250716184833.67055-6-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716184833.67055-6-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/16/25 11:48 AM, Ewan D. Milne wrote:
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index aef33d1e346a..a8ec653d4795 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -230,6 +230,7 @@ struct tape_block {
>   #define SDEBUG_OPT_NO_CDB_NOISE		0x4000
>   #define SDEBUG_OPT_HOST_BUSY		0x8000
>   #define SDEBUG_OPT_CMD_ABORT		0x10000
> +#define SDEBUG_OPT_NO_DATA		0x20000
>   #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
>   			      SDEBUG_OPT_RESET_NOISE)
>   #define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
> @@ -1641,10 +1642,17 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
>   	if (scp->sc_data_direction != DMA_FROM_DEVICE)
>   		return DID_ERROR << 16;
>   
> -	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
> -				      arr, arr_len);
> -	scsi_set_resid(scp, scsi_bufflen(scp) - act_len);
> -
> +	/*
> +	 * Conditionally suppress DATA IN transfer and leave resid set to bufflen.
> +	 */
> +	if (unlikely((sdebug_opts & SDEBUG_OPT_NO_DATA) &&
> +		      atomic_read(&sdeb_inject_pending))) {
> +		scsi_set_resid(scp, scsi_bufflen(scp));
> +	} else {
> +		act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
> +					      arr, arr_len);
> +		scsi_set_resid(scp, scsi_bufflen(scp) - act_len);
> +	}
>   	return 0;
>   }
>   
> @@ -1665,13 +1673,21 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
>   	if (scp->sc_data_direction != DMA_FROM_DEVICE)
>   		return DID_ERROR << 16;
>   
> -	act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
> -				       arr, arr_len, skip);
> -	pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
> -		 __func__, off_dst, scsi_bufflen(scp), act_len,
> -		 scsi_get_resid(scp));
> -	n = scsi_bufflen(scp) - (off_dst + act_len);
> -	scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
> +	/*
> +	 * Conditionally suppress DATA IN transfer and leave resid set to bufflen.
> +	 */
> +	if (unlikely((sdebug_opts & SDEBUG_OPT_NO_DATA) &&
> +		      atomic_read(&sdeb_inject_pending))) {
> +		scsi_set_resid(scp, scsi_bufflen(scp));
> +	} else {
> +		act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
> +					       arr, arr_len, skip);
> +		pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
> +			 __func__, off_dst, scsi_bufflen(scp), act_len,
> +			 scsi_get_resid(scp));
> +		n = scsi_bufflen(scp) - (off_dst + act_len);
> +		scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
> +	}
>   	return 0;
>   }

Here and above, please combine the two scsi_set_resid() calls into a
single scsi_set_resid() call, e.g. by setting act_len to zero when the
DATA IN transfer is suppressed.

Thanks,

Bart.
