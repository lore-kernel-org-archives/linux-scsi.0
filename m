Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B58219149D;
	Thu,  8 Aug 2024 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723137640; cv=none; b=t/YmhZD2hDWLjQyUeN55uRJP2e1rT20ZII33nKjH4e6TWdd2ffjFQjQWO9loNWwxcQVYX4k08VPt3/DMlO5NseByhHBsRJvdP3apqpJucMjdUoLk6slRAVA/eba+orhfheHpNIjfNY2THNBw6QlDpIuuCVCH+s6lxLVu6ujNM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723137640; c=relaxed/simple;
	bh=N0yRmV/6CdGXCtYec3fDqtYlHJ1n802DFUGTLoP+PHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aNhmJS2/Bji9qDXoj2otfa9/TvlMAAUkA/j5BKrHiWYGBrMftI9RvEDkMtBvVHhxoBWC0G1q8s1VDSSxkJAWhRJZE4TPXIIFZrli7A03cuhW382iLaVk3d/5Nc1Mfp8YHuiLsV53okxz2HMT8dJqIMkHfky7slNjI5Ynj5YFheg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i0RsvL3m; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i0RsvL3m"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wfv283PZsz6ClY8v;
	Thu,  8 Aug 2024 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723137629; x=1725729630; bh=ET8VdrzcM/WVtGZAl2LmiJ68
	uMT9nlprmdxZKXq3dlo=; b=i0RsvL3mxMyCckfhgnkCxg1Q0juSkX5K21MxnU/P
	036Tcxh9eO4fot9zEGM5VB7wW6Ws4/lGavWwzsYWUF6hFJXqKff3zrIVkOHEoAVh
	aKgFNB9YH5D4q+41LNEbtWCx4mR35BX2ioDID3G4ku8ZUEBMElBk31hHohqEkBhJ
	ikq0wOGqSQcBBpVwelj9d5KD47a058VSAFQOki2FOyDdX3FdPYB5QM3wS1++Ob6u
	8SXWBxeOIibgikI/KmGJ1ebEZOshLK97TDKHBD41R3hY7K964Npnlhwx37ISAW7+
	NrXGZcht5/4e1eMUJObEqC3HqzeO8Dx07KGEZgP451bndw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i5mRdFX6et78; Thu,  8 Aug 2024 17:20:29 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wfv232wJGz6ClY8t;
	Thu,  8 Aug 2024 17:20:27 +0000 (UTC)
Message-ID: <17c0a914-9bd7-43ef-b739-d2105ec46567@acm.org>
Date: Thu, 8 Aug 2024 10:20:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Have scsi-ml retry START_STOP errors
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 prime.zeng@huawei.com, linuxarm@huawei.com
References: <20240808034619.768289-1-liyihang9@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240808034619.768289-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 8:46 PM, Yihang Li wrote:
> When sending START_STOP commands to resume scsi_device, it may be
> interrupted by exception operations such as host reset or PCI FLR. Once
> the command of START_STOP is failed, the runtime_status of scsi device
> will be error and it is difficult for user to recover it.

How is the PCI FLR sent to the device? Shouldn't PCI FLRs only be
triggered by the SCSI LLD from inside an error handler callback? How can
a PCI FLR be triggered while a START STOP UNIT command is being
processed? Why can PCI FLRs only be triggered while a START STOP UNIT
command is being processed and not while any other command is being
processed?

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5cd88a8eea73..29f30407d713 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4088,9 +4088,20 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   {
>   	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
>   	struct scsi_sense_hdr sshdr;
> +	struct scsi_failure failure_defs[] = {
> +		{
> +			.allowed = 3,
> +			.result = SCMD_FAILURE_RESULT_ANY,
> +		},
> +		{}
> +	};
> +	struct scsi_failures failures = {
> +		.failure_definitions = failure_defs,
> +	};
>   	const struct scsi_exec_args exec_args = {
>   		.sshdr = &sshdr,
>   		.req_flags = BLK_MQ_REQ_PM,
> +		.failures = &failures,
>   	};
>   	struct scsi_device *sdp = sdkp->device;
>   	int res;

The above change makes the START STOP UNIT command to be retried
unconditionally. A START STOP UNIT command should not be retried
unconditionally.

Please take a look at the following patch series (posted yesterday):
https://lore.kernel.org/linux-scsi/20240807203215.2439244-1-bvanassche@acm.org/

Thanks,

Bart.
