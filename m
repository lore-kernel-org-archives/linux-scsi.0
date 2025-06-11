Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321D71C863B
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749656143; cv=none; b=ODlfQSgOfg7GlVsbQtnr9hxijWtOOSFULcgO0ee3ZFayAhycRTUiq7U3lE1m44PLc5DaXLFdE+ssquDpEhWmXQnEAhKLY2cqjZSoBBzvX4QiiIMAGgUC4Nkq2xfQMmfWGlrZcfUdY20oo0aJwRsIpbXamkuqoG14KTjmjotsw6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749656143; c=relaxed/simple;
	bh=lHXfJa297tIQDdcKbAvtnzLTGwV02IJTQic/rgiLhcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eFkoV79darEURJ9gO0q6vHhGZUSSlSKOo7J1EMoVipI9H3I+YvdXpVuuKlPFauuTmrcaPaXvkXNy+fnGJGQMbU4O8vc4frZgAT+Hhz3TnLCG81XTENPPbj9nmU/+BylTXRkgcB1vVpQdzpG61sLmwcjrhc3Vumu0KXaSWr61/No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2pZX4Q7F; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2pZX4Q7F"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bHV9K724qzm0jvG;
	Wed, 11 Jun 2025 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749656132; x=1752248133; bh=AhqAdwO7QNpmN5RfI79FPQWJ
	WB92sjYqxUm81PQ6dJk=; b=2pZX4Q7FRPe75WGTOc5wvFythI8IJh/OgzeR4xtI
	44CnQGHr+7Mt2+ldblz4mF5XP621J0NmoN5EobiJgMG9hT/8/wnkuWa4rzEMAp9p
	i8xBiMzd35E8wEvKen2jSLLcYpIYMnqlDgdiwHL1Ivy5rWiOT/AToHSUX/9Xfule
	u5IoI4ZQNfdTeJvhk7K0yP9jSPiTO++5UvT/mRk5kSIQKlwGGQO8YbJCr7d5glvh
	EQk+xtmvoubDBJdunvcfHuM2zsNas1E8M88TXiHDlaqRl/jc1GlAtaBthrqipob0
	KzLGf49oDezEspHMoPuZ6xTB964R8PSl2jivXYnz07oFlQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id At5UNtR89kcw; Wed, 11 Jun 2025 15:35:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bHV9H3BMVzm0pKm;
	Wed, 11 Jun 2025 15:35:30 +0000 (UTC)
Message-ID: <f1877d65-6b7b-4d71-899d-d6b3d8bafbdc@acm.org>
Date: Wed, 11 Jun 2025 08:35:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: Set a default optimal IO size if one is not
 defined
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250611122921.3960656-1-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250611122921.3960656-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 5:29 AM, Damien Le Moal wrote:
> +static void sd_set_io_opt(struct scsi_disk *sdkp, unsigned int dev_max,
> +			  struct queue_limits *lim)
> +{
> +	struct scsi_device *sdp = sdkp->device;
> +	struct Scsi_Host *shost = sdp->host;
> +
> +	lim->io_opt = shost->opt_sectors << SECTOR_SHIFT;
> +	if (sd_validate_opt_xfer_size(sdkp, dev_max))
> +		lim->io_opt = min_not_zero(lim->io_opt,
> +				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
> +	if (!lim->io_opt) {
> +		lim->io_opt = ALIGN_DOWN(lim->max_sectors << SECTOR_SHIFT,
> +					 sdkp->physical_block_size - 1);
> +		sd_first_printk(KERN_INFO, sdkp,
> +			"Using default optimal transfer size of %u bytes\n",
> +			lim->io_opt);
> +	}
> +}

shost->opt_sectors and lim->max_sectors both have type unsigned int so
when shifting these left there is a risk of overflow. As an example,
from the scsi_debug driver:

	.max_sectors =		-1U,

Shouldn't integer overflows be prevented instead of letting these
happen?

Thanks,

Bart.

