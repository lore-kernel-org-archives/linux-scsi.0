Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61D2126F1D;
	Tue,  4 Jun 2024 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717520414; cv=none; b=i8sIw/JYhcZcwjjUOZMqHcNqDY/ncIgFtdX6HNeog8Epw41BChQiCuvRounGn77/myYarkFFJA/SgLQa6n4s5jclJUuBA+RrE2BOPtkHXxzT6iarf5uf5WEBaDtx5iHMugtvS+eVvlMElqtU6+Gbr0Ohcb7r/aGrnxmmXRK8C+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717520414; c=relaxed/simple;
	bh=VBxYUCehWAGsDRiq8mq2XSqzkzgjMH/qkIIWw6rK7Mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhfwE1V6MVNO5PqsoIjveOjPMUJeyYYVnW2XNmfrVjlWPKx7Y4kd+wQzCDPpTRq07lLKaE2KndwQZmCPSpvwMP+dDLNDqJG05h3BWlhJ0xl0gASEaH997vCS9CGwLE0X7g7h8mVyo+2pg25lBlUhgAnhrFuZtsDQ9v5kvknUhAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ecGzG0kO; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ecGzG0kO"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vtxfg1Dv8z6CmQwP;
	Tue,  4 Jun 2024 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717520409; x=1720112410; bh=oMJt/T5I43uHjnP8jE57J4Y4
	u6DwpmodnYPB/PecwQU=; b=ecGzG0kOpyOkjsaBXePvdEJBgX6tI4S71ywSNR7r
	CWIFPzrjgxmJd2PcVWjjfcfMQMdz9lEzea+0J8I6aAxZuPf9pxtTuabOrwIfBiTC
	xHwRWhQ8wu03x4hleQlIUksb75MditX30Y2mM5sEiQK+rKJBmfYX7d0IYs3rktAp
	BXosnJXW2nJTbkxELvdGZGwJCCA8Qwl71gMVrXb3tvJbcFGxaRHlPTywMvCLVARW
	V9O+vRkpjy9VVvicWNj6BDMwQw6qW6+yHltxBJwDTJcza6xf0+6MuyaQKVX/6XOe
	H9i4dd3qOWTfBLxFl9qLrcXrY2xfluHpDvfhuWWe1MtNfg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7tneErAfTh6Y; Tue,  4 Jun 2024 17:00:09 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vtxfc5GC5z6CmR5y;
	Tue,  4 Jun 2024 17:00:08 +0000 (UTC)
Message-ID: <50211dcb-dc40-4bb5-8168-8f102f6bfb5c@acm.org>
Date: Tue, 4 Jun 2024 11:00:05 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Use READ(16) when reading block zero on large
 capacity disks
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Pierre Tomon <pierretom+12@ik.me>,
 Alan Stern <stern@rowland.harvard.edu>
References: <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
 <20240604144501.3862738-1-martin.petersen@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240604144501.3862738-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/24 08:45, Martin K. Petersen wrote:
>   static void sd_read_block_zero(struct scsi_disk *sdkp)
>   {
> -	unsigned int buf_len = sdkp->device->sector_size;
> -	char *buffer, cmd[10] = { };
> +	struct scsi_device *sdev = sdkp->device;
> +	unsigned int buf_len = sdev->sector_size;
> +	char *buffer, cmd[16] = { };

Maybe this is a good opportunity to change 'char' into 'u8'? It seems a
bit unusual to me to use signed char for a SCSI CDB and a data buffer.

Otherwise this patch looks good to me.

Thanks,

Bart.
