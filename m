Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7828418C90C
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 23:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722383272; cv=none; b=qnJ1JDjEANa2ahLkXOzXmzhsSlPWK4TSCFuXXUUHP/Djka+1NrqY0UwpahcO6P2rgvFzYVTMw8qzjYX+IG0iFyXv6mriRsGbUJBRtZ7U6M/WuQkj6xUtCDFzvF59gWal702DCyBMQjqe06XmMqLwvygvCNXTuA/BaOqMOOo28mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722383272; c=relaxed/simple;
	bh=gL4wnnY8axamTagcyu0p4aDv7QNa/BV2NwmfViuzQCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FoEDHsPdPSz0qpO6p3vyu2dTsGDpC0hRyLv7SOnZTJ/aWOS3O469MoKPaaX7RcM1Rj1a2mk1msPdcZzJLW29Ji26KuKKqGnYwiaP9B9bCNgQnVE7ms7auVnhCF4opvqbykik3ar2mfgpGycpyIw0wW3o8aEK344gdzw1KhJSAPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBOvL3DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBOvL3DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28915C32782;
	Tue, 30 Jul 2024 23:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722383271;
	bh=gL4wnnY8axamTagcyu0p4aDv7QNa/BV2NwmfViuzQCQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CBOvL3DYQQGpX2KyQN/1Qp0pIKIwrWODUyoJdips77HzMgJNPGxVy3vCc/9rIiXko
	 EzcpOoVnMLm9M6ps4k2akx5JAErhRgHhPDNzIfSbRuLZZcoZvTW6KeeXN7bR6nGmYB
	 TD3Fo03kzim+K7Zi/UKJAjgpoX2coIeSdho8NdUju115issj3weObzkHdfzvaTmf/A
	 HYWpbP2p9/W39RZimrEuUEDyIHc5zWDiuL8PNqEKR0T3Bf9oKo2wOOlQXNbHkIaXLQ
	 Ag2d0NjNSLwwLIQwhQqntUISiLv/+QTpc4Wnoy5jhuOtIz+XC3v8lG+WSMzYelfwet
	 5EkJzn1rmGShw==
Message-ID: <ba1abee6-8f02-40c6-9e60-eb68667aa0fe@kernel.org>
Date: Wed, 31 Jul 2024 08:47:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] scsi: sd: Do not split error messages
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-7-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240730210042.266504-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 06:00, Bart Van Assche wrote:
> Make it easier to find these error messages with grep. This patch has been
> created as follows:
> * Delete all occurrences of the following regular expression:
>   "[[:blank:]]*\\*\n[[:blank:]]*"
> * Split long lines manually where necessary.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

One nit below. With that fixed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> @@ -2856,8 +2857,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
>  	 */
>  	if (sdp->fix_capacity ||
>  	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
> -		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
> -				"from its reported value: %llu\n",
> +		sd_printk(KERN_INFO, sdkp,
> +				"Adjusting the sector count from its reported value: %llu\n",
>  				(unsigned long long) sdkp->capacity);

Can you fix the alignment of the format string while at it ? No need for that
extra tab, removing it will make the line shorter.

-- 
Damien Le Moal
Western Digital Research

