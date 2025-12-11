Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9969219E8
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 19:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765479896; cv=none; b=N6RaYBnbmtyCwfjxU7NtVmbOAkna10zeEBFvJBENknBUVX4bstwEvVUuRWRdT1JhPS1Op94tkgYyPsgWjJg4T2RQvilca+u/GmppR8aLm59jUg3A6ayUEWQhTVKZyt6pNgWIBsL/tqlS2ZMl4ZKKYQ07Q7JQrWJXsur9zZ/LSd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765479896; c=relaxed/simple;
	bh=hNxgfYPlUoJ+5j7YgPHShghjgVaNx48Ecoox9CGVdZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEwh3nWGmJ0Due9xvI8BI6hVEfkIFNL022/pLQ9zXE6aANqteGAoTOQkrBVXNcsc930woeKi+JCx3YxAcrcNkhB+o/IwMZbrGogRNClGc0wl4uKENe6zOko2AjJJ3RUTEXnSgHpgYxVlGcpUSLf8FEqHxOJNxaLHfGlvST3lk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4XyAh3IM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4XyAh3IM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dS28Q2dHHzlfftc;
	Thu, 11 Dec 2025 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765479893; x=1768071894; bh=LkK1J736d6+FXE+/8WWNQAr2
	oJLemuKd4W1u9gNff1o=; b=4XyAh3IMwy9CSyCQBKeRwc6Ar96PR1nCjNdkcB/z
	5mRHOGqxqC6eoThxpV2AyztW3FFjm4hUEmOqB/HyVzQtczb5uSFaCy6tngb2Dsbp
	Z0PcHxtc4wFuy1nj42mWN1iv7NfKR7O5B8bjWAlLpLhtUySAVo9dS6VZ25ON0KkK
	6EJPfKyIm7y3/VhkGuZVhTOo0dcG+dFOzWtGKzZ7dnIXpEHfMJfcnFJV2PFVQE94
	q7g5Dn2OMrv1ocykGeaD7MGInCz0+gpJjhQ8dO+4q8s60ICnrdZzygMcpD9ZmQMO
	FOJ9nfWgVuwbZmTltbZdi6Empd7ErE45Xrr3rxxCFz56GA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FgLJcVzK8pJC; Thu, 11 Dec 2025 19:04:53 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dS28M075yzlfvpL;
	Thu, 11 Dec 2025 19:04:50 +0000 (UTC)
Message-ID: <760367f9-1cd4-4059-bbdd-9017823e8751@acm.org>
Date: Thu, 11 Dec 2025 11:04:49 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Fix atomic write enable module param
 description
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org
References: <20251211100651.9056-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251211100651.9056-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/25 2:06 AM, John Garry wrote:
> The atomic write enable module param is "atomic_wr", and not
> "atomic_write", so fix the module param description.
> 
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b2ab97be5db3d..047d56d23beab 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -7410,7 +7410,7 @@ MODULE_PARM_DESC(lbprz,
>   MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
>   MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
>   MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
> -MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
> +MODULE_PARM_DESC(atomic_wr, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
>   MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>   MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
>   MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

