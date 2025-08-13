Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806A9303CB7
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107414; cv=none; b=XvguJYmck9jkQiAw1Hrr4oQv6Al6S/+EbuOHGGUdlOmqFNZE4Jd9gNOqbMx0q5fVgsuX7rU8IqanaHO2wXvmXwqyQHTYqZdh5RGpU6ZCuN8LmG2GSsmwtLZR5P0EKAhgrAdugjJAKLatfZoXYupz3dgRQDApBzyYkC4MdKipb2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107414; c=relaxed/simple;
	bh=V+ikqvY90DQRJvTEGADcxWxCYOW0HTy+dUDlTEgdOOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UmhrCZD+T10anjizyKZYFveWEBVDgltJ2YyVkqpx8+082/Zd0GdUixma0z17m51IjVF2jAjAtMawc0ZpctAh6gi2o/xqjK5uEvOJ4kfaBvers64EaeNWXsUC9fksDiuZ4LAJnxWRVEne/gGFXBgy7Z9lNQN9oKOd6IQEhhY6R8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tjriV75Y; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tjriV75Y"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2G9b4CV4zlvNRT;
	Wed, 13 Aug 2025 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755107410; x=1757699411; bh=N4bEyW3COAKK6HkHHVMD4swf
	2J+Nb7srE5su5kcTGwU=; b=tjriV75Yc5iBDm5gaA3OAz5s5y7YVt6rL7KNZKlM
	QQW3zLN0BGGzCxeTg9ob68HiYRa+YXBupKs3WEV+M9LJqS/GfwOirq60GsXJMNPw
	yNN4uLHrXv43zT/yAkMv3ZlOPyh+ZNEYdaUqSLxR+kkU8CC/5SJRtcX3gwQOxRsr
	/7yKz72ON4gfuEVBmSjORoxFyJwRuVxFT2JdASUYMLaya3uzb2iF/rAJ39LVhTLb
	BcntmWLjzhiFm2Ces32pwtSH29CmLRrXQ15gN8VbPPkIalrCTsH2Gn97JU78i0Zz
	hvNj2KtyS1KClCxv0/96Ibo0kFT49UvYIhB+1tKmTElh9w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a2nSOZxYw4jM; Wed, 13 Aug 2025 17:50:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2G9W6CHBzlvNR7;
	Wed, 13 Aug 2025 17:50:07 +0000 (UTC)
Message-ID: <31fd2c7b-9b1a-4ff3-9b9c-6eaef269a5ea@acm.org>
Date: Wed, 13 Aug 2025 10:50:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] scsi: sd: Have scsi-ml retry read_capacity_16 errors
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250716184833.67055-1-emilne@redhat.com>
 <20250716184833.67055-2-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716184833.67055-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 11:48 AM, Ewan D. Milne wrote:
> +		/*
> +		 * Do not retry Invalid Command Operation Code or Invalid
> +		 * Field in CDB.
> +		 */
> +		{
> +			.sense = ILLEGAL_REQUEST,
> +			.asc = 0x20,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = ILLEGAL_REQUEST,
> +			.asc = 0x24,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Do not retry Medium Not Present */
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x3A,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = NOT_READY,
> +			.asc = 0x3A,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Device reset might occur several times so retry a lot */
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x29,
> +			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},

For the first, second and fifth array elements above: leaving out .ascq
is the same as requiring that the ASCQ value is zero. I prefer to make
this explicit by adding ".ascq = 0," in these array elements.

Additionally, media_not_present() doesn't check the ASCQ value while
the above array only accepts ASCQ == 0 if ASC == 0x3a. Please either
mention this behavior change in the patch description or add the
following in the third and fourth array elements:
".ascq = SCMD_FAILURE_ASCQ_ANY,".

> +	memset(buffer, 0, RC16_LEN);

Isn't the preferred style "memset(buffer, 0, ARRAY_SIZE(buffer))"? This
makes it easier for readers to verify that the third argument is
correct.

Otherwise this patch looks good to me.

Thanks,

Bart.
