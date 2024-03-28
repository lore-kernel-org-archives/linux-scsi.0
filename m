Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2431311AC;
	Thu, 28 Mar 2024 21:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711661893; cv=none; b=ZGrvL65mH989FYhufw0hLCv1iyAVal8gqQqOWhQnrPywvNEyetcUuOWTI+L5N2Y/BtwHv41qcOtBFdPirOqVpUo2dYGI13jfUMZIi+INEzlFCdYq00EZsbDQdDZVIPaa/M7/6H+eSsa8zWNGhiVw04xr21uOrw+5j5Fv2LtxVa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711661893; c=relaxed/simple;
	bh=jQx77FV08xvh7ws9/FrSTIde127vGI6Xw/+HIcCmXFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EgKWVxCnTaZbyLlmtlRotWmP3s8wAm5YB7c2U516GApGUzTTiSaN/Mkb3isrk4u+9V+eG7HsZsiJlofSGM/JNw2b071+1r99PL0g1wRPIBTCTK9H2eA2rF/npXeetCGEoNE9PBOPsSvR+/RIk/G0kA2ro5T2I4kF9Psci79SWog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qT4k6f3J; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qT4k6f3J"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5H2q5dwJz6Cnk8t;
	Thu, 28 Mar 2024 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711661888; x=1714253889; bh=66AKkG3PE4cQTzggRWxgRNhO
	M7zTlOgr921WiYgCRQ4=; b=qT4k6f3JyJQBxUXRjsL8Om0gTzhKGsfTk957Swks
	qpxzTuUT94giBQhW8CqaEn0Vjbz1Y3cpmdRVqDzAWyi9IMZ/uY2MkZ0Fb3HC+WPr
	inVs0AGA65ZoFlINUUv+oJBh7IAAjoOMIPIjlv4OykZeK6Uk3XdxMahObbP2RGVz
	GW7NxcgQ/tbYFFoPhxUrXQ8+Y76khG0lVS8Qh4dlksmOKwL5L3nDqGzX6D01JjY2
	cSknGsp2sbwYlu1ynId+ndtgKYfqpTtsUvGwKo1sEg+Q+HV7tfnwLH+2RJ+6qN+e
	OiZVsud85jc7WJqDeMZmw3H0JBbRJ1O2DuDgdLxIXEwTJg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id t-6wXCmN5Kaw; Thu, 28 Mar 2024 21:38:08 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5H2k69fwz6Cnk8m;
	Thu, 28 Mar 2024 21:38:06 +0000 (UTC)
Message-ID: <38575b90-7cd1-48f9-8c86-a77ef372900d@acm.org>
Date: Thu, 28 Mar 2024 14:38:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/30] block: Remember zone capacity when revalidating
 zones
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-8-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> +		/*
> +		 * Remember the capacity of the first sequential zone and check
> +		 * if it is constant for all zones.
> +		 */
> +		if (!args->zone_capacity)
> +			args->zone_capacity = zone->capacity;
> +		if (zone->capacity != args->zone_capacity) {
> +			pr_warn("%s: Invalid variable zone capacity\n",
> +				disk->disk_name);
> +			return -ENODEV;
> +		}

SMR disks may have a smaller last zone. Does the above code handle such
SMR disks correctly?

Thanks,

Bart.
