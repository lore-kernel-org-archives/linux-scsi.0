Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0BA35948;
	Fri,  8 Aug 2025 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681173; cv=none; b=Sj2nv4dN+bQPVoE2uFjf9d2FZWtc7PjNqBzp5h1OrLhQqj+73idlCWD+rydry5vfpW3vsrv1LxdLQyJMTXHQwdLE4eRiM/AGKDCTsmJdBEDboMDq2X3VWQpWCnp0Ft9jzwZb5LU9HDjNvZppZEequLhwVwPORwdqMdVszSEKn38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681173; c=relaxed/simple;
	bh=jSHJ5Igu+EfYrB7/7crOIwWZ2z5j2gFmGxNzvUcT95Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XjD0gBMx6xkzn0HI8tA9ZBLUKFnhy9cZh5uWvI4WgQmpunLXwprH5j0afId1aWF41v5YGBXzDp0Jz1uTFHzL4VDYJM99G4O3uuiVleP36BMl230i8T2ctpDI2jAWFExKxqPPZZnMOEasvu9aLM6r4Zt5EHkCWSuYoHCnbKhXiWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uaPzr9SV; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uaPzr9SV"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bzDXX1mdVzlgqTr;
	Fri,  8 Aug 2025 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754681162; x=1757273163; bh=+WqddrqesMHWRXYIHDcFITv9
	cz7wR/vZjFGcvozYkb4=; b=uaPzr9SV2UC1I7yqmKIgrlq57yCPM9ffxkxylJuk
	OGxuPKX6z0qMbuUKYRNv33UVz3etTy7CA4QzCg5HMDy+0UT5xru+v2Z8XeTWn+R9
	TXjuQuA1OoUf0BlrXqyKlLv6lqNkK4Q2CyAuxGLwquE9QfiCXdRNVbxtbh2BkbkY
	uI7his+JPyiVrMqEmIyKTj6Wp0QmeBaoC3XAs07hUTw/sEa0a0yXU/9/K6VuepY9
	0jpv/G02JFqTB3FrsthyQG4KbuTc9EtuY4GSlQRTPTTMcofkOojHbgIKcyLodoqJ
	8lQ8TPzxsMVknbXIpo0W3+MmVExwXu3Dv/99b+clFIzeqw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NWp-P6Sw4AXp; Fri,  8 Aug 2025 19:26:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bzDXQ469KzlgqTq;
	Fri,  8 Aug 2025 19:25:57 +0000 (UTC)
Message-ID: <411260ff-d5c7-4f82-8c47-e66e4828c2b1@acm.org>
Date: Fri, 8 Aug 2025 12:25:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: sd: Fix build warning in sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>, dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <4786fbb9-5d25-4d86-b902-61cc78a9b138@kernel.org>
 <20250808182807.12625-1-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250808182807.12625-1-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/25 11:28 AM, Abinash Singh wrote:
> A build warning was triggered due to excessive stack usage in
> sd_revalidate_disk():
 > [ ... ]

New versions of a patch should be posted as a new email thread instead
of a reply. Otherwise there is a significant chance that the new version
gets overlooked.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4a68b2ab2804..c7fbfb801b40 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3696,10 +3696,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   	struct scsi_disk *sdkp = scsi_disk(disk);
>   	struct scsi_device *sdp = sdkp->device;
>   	sector_t old_capacity = sdkp->capacity;
> -	struct queue_limits lim;
> -	unsigned char *buffer;
> +	struct queue_limits *lim = NULL;
> +	unsigned char *buffer = NULL;
>   	unsigned int dev_max;
> -	int err;
> +	int err = 0;
>   
>   	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>   				      "sd_revalidate_disk\n"));
> @@ -3711,6 +3711,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   	if (!scsi_device_online(sdp))
>   		goto out;
>   
> +	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
> +	if (!lim) {
> +		sd_printk(KERN_WARNING, sdkp,
> +			"sd_revalidate_disk: Disk limit allocation failure.\n");
> +		goto out;
> +	}

Returning a negative value for some errors and zero in case of success
or in case of memory allocation failure is confusing.

Since none of the sd_revalidate_disk() callers care about the value
returned by this function, please change the return type of this
function into 'void'. Since that change is logically independent of 
allocating 'lim' dynamically, that change probably should be a patch on
its own.

Thanks,

Bart.
