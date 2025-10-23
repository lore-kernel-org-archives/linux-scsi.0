Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB9A3148B7
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761237025; cv=none; b=NW0To4e+neEkHXQ23ZoIB36RimU9lY875xkTGbfcAi1b/+LGp9rgxd1Hii9kgh4PHEzMzFntynoH+rgtqya106SHk5wcsDlMdbbKykbhKnlTcKfUvrmxu3iMPRi8jWOHBBb1w9LoRVRrpBJs0BT7qW1yX/rH2MjMrLsM4qS1sDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761237025; c=relaxed/simple;
	bh=aTTk4kDhx5D8gHyCoticA1VXq5ejY915UlUM5iqYqy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWdzAHky2SwEX4ggrC9gvBpqIPgBegBIvm+jdYmBD5bZxor6hCkOCjb89zXTzsKL64bDNb4kwHRK2UYCMlZ/TM2zionVoJ6+ZH9E4g7B+AycwUsP1iALPfD1j6pWRBOPsiHpovbzpGawnKkWIMuTGkGh9Hkyqhqr2wCqbKAHjV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3YZIE0YX; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3YZIE0YX"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4css2k0zZRzlgqV1;
	Thu, 23 Oct 2025 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761237020; x=1763829021; bh=AKSReftzl61gvWpgfJaBqjcu
	R31/WcRSCctp6tXXgQw=; b=3YZIE0YX7JuX7P1PE/7q8w+scMmG2zADZMePiToz
	kYkTo4edO2KrM1fqcjXVQASUcFcgORiTCxLUBUUc6lwC3ZQT5KNvKCpivHSnvVpq
	T8HBEaE+GqXA9JCPoN5MhI7Rxa8DZ2GqoyiMg1kSIJKjZRjM9pcoFmWkk2kzP/2a
	BJugtK9qaRJh8jLDBJPE9uLD9jvENv48vej6n8ijyNMA4Q0jlXEtoUJGm8tUUmWl
	bclAY3fji/EdjV65Vb0k1iULo+/QgIiPPFTsBjI1oaAg8lahmhGbn1GV+vhKJHJc
	U/S+5MzWX3LC+KxHvW1o6K2VmN5xz4ZiBROwtF8XSpeB+w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YGQPj4khg3n3; Thu, 23 Oct 2025 16:30:20 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4css2Z307Xzlgqyl;
	Thu, 23 Oct 2025 16:30:13 +0000 (UTC)
Message-ID: <57837e46-4b99-46e0-9fa4-627dd702c5e5@acm.org>
Date: Thu, 23 Oct 2025 09:30:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: advansys: Don't call asc_prt_scsi_host() ->
 scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, willy@infradead.org, hare@suse.com
Cc: linux-scsi@vger.kernel.org, ming.lei@redhat.com
References: <20251023085451.3933666-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251023085451.3933666-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/25 1:54 AM, John Garry wrote:
> The driver calls asc_prt_scsi_host() -> scsi_host_busy() prior to
> calling scsi_add_host(). This should not be done, and has raised issues for
> other drivers, like [0].
> 
> Function asc_prt_scsi_host() only has a single callsite, as above, where
> the shost busy count would always be 0.
> 
> Avoid printing the shost busy count to avoid this problem.
> 
> [0] https://lore.kernel.org/linux-scsi/20251014200118.3390839-3-bvanassche@acm.org/
> 
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 063e1b5818d34..06223b5ee6dae 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -2401,8 +2401,7 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
>   	struct asc_board *boardp = shost_priv(s);
>   
>   	printk("Scsi_Host at addr 0x%p, device %s\n", s, dev_name(boardp->dev));

Printing the SCSI host address is not useful because pointer mangling is
enabled by default.

> -	printk(" host_busy %d, host_no %d,\n",
> -	       scsi_host_busy(s), s->host_no);
> +	printk(" host_no %d,\n", s->host_no);
>   
>   	printk(" base 0x%lx, io_port 0x%lx, irq %d,\n",
>   	       (ulong)s->base, (ulong)s->io_port, boardp->irq);

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
