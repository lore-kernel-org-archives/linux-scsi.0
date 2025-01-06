Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46B01DEFE8
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jan 2025 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736188238; cv=none; b=fllsK8uWnlJ+mJ+cmo9hPiR2fn8yKhzJJ3ytfr2g5DJZq1vMZglCg9aZY7S6eAjX9/Dx59tRLw9jfUKEaGPSOsIQbnMkqSyVs1ZrPTmbNsvNbjQ6csROhrhLljU196pJ3m2XKokUer6t5FTMym2EbH6crnpyRLdvr2IkoxfOzuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736188238; c=relaxed/simple;
	bh=iRS3zx0kaOx0u1lZiffMCVbwSjZWRFwrXBQYMuLZ1I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbRjOwDcLUF/95yDS0YsmKZuQtO6UJewKiah5Gfkti15mE+LuMG+pgpfL0/V1DC1q8P2pbGyUx0bH3PvfmfXSvqjn++HO4hK2ausCjQLm3KPmAbGMR+eLWJmK9MGhj55eTZwceUqpHWrarruyBDLnd1IcCH8MG1/ZLNZIgLAVr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FYU/9/V2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FYU/9/V2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YRjRH0jYzz6CmLxj;
	Mon,  6 Jan 2025 18:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736188230; x=1738780231; bh=hzo0qdIXPdPwojp33nYqdT42
	FD5TeRSJM3i3ynJsRvU=; b=FYU/9/V29NpoC5J/QjNSLQh7iJWb0fkBRJj0UZd5
	aekc8Yl0gjlM4MCz1MTluFCDBZNDpIjsOtEn9dwdQeZ93EojtwfJpVVORc2gIqlS
	6aOpP89RR65mBx3Q/ZzNj9PjYvTvTjy7xp/vzybSUQDxwftYMouRNrznkcPSXsaA
	r4ySA5UWjNIfEfoZ+65hyj8vaMtA40pzc+HPKvacTqUddso/vRZ5WqqiJ4zmQ+Jc
	9z4G0UD7NwEAC/6iAtowwEQxiHQyubXCeciunywpIaVcIgqGOWTR5SSET12XI6A+
	n/LFnvL9PbPaYOroXBiWJuckJXPI4l7KIof+MPtNG1+JPA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CNeQQM3pA_mb; Mon,  6 Jan 2025 18:30:30 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YRjR718rDz6CmLxY;
	Mon,  6 Jan 2025 18:30:26 +0000 (UTC)
Message-ID: <3e87b69b-38aa-413f-a2bf-388da21afaa0@acm.org>
Date: Mon, 6 Jan 2025 10:30:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: mpi3mr: fix possible crash when setup bsg fail
To: Guixin Liu <kanie@linux.alibaba.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <20241226121808.46396-1-kanie@linux.alibaba.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241226121808.46396-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/26/24 4:18 AM, Guixin Liu wrote:
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 10b8e4dc64f8..7589f48aebc8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2951,6 +2951,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>   		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
>   		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
>   	};
> +	struct request_queue *q;
>   
>   	device_initialize(bsg_dev);
>   
> @@ -2966,14 +2967,17 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
>   		return;
>   	}
>   
> -	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
> +	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
>   			mpi3mr_bsg_request, NULL, 0);
> -	if (IS_ERR(mrioc->bsg_queue)) {
> +	if (IS_ERR(q)) {
>   		ioc_err(mrioc, "%s: bsg registration failed\n",
>   		    dev_name(bsg_dev));
>   		device_del(bsg_dev);
>   		put_device(bsg_dev);
> +		return;
>   	}
> +
> +	mrioc->bsg_queue = q;
>   }

Next time, when including a call stack in the patch description, please
clean it up. This means removing the timestamps, the register dumps and
also the stack frames that start with " ? ". Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
