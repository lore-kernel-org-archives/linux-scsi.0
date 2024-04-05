Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8A17167F;
	Fri,  5 Apr 2024 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712346594; cv=none; b=e4o2DsYAXczXHnLqFkVpgVUwnOdWi/CY4IIVD+W8x4pgKGuCSxXnNFOmD66gPGgChA7/eY5eiK13RYdQq+ZmPvhask/Zfv0Vh/VlCEwM0U8zVWPHdBqLr1zYWmduVVUrcmaW3iWD3v4ctXRATJWgzlNCXpLpTY79gYVsiz21Zkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712346594; c=relaxed/simple;
	bh=U3QSasR0yisltW8MBdiQoRYfyS9iD5b2kWG5VrvCcEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hOlQcKSomcIaenZ6UcJldBJ7NzCve8n9qvVtLtMBGftenvH2FjvWtZ+sww9DdwJbFwfiNwAHUjO7zWhzpD8QxOX1942DN31cYj1vOx1KnJK9/nAzXhu0NoWAYfp4zV2Jw9dJCecbJq9xBOr4GWXsLNd1EAiUVi3dAW8SH0Ak6y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JY2cIlX+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JY2cIlX+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VB8G83wc6zll9bP;
	Fri,  5 Apr 2024 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712346590; x=1714938591; bh=HT9xP0CtOVxrpJticXq4asho
	6u7ldedY7tTiPEr3xEk=; b=JY2cIlX+Mo/QEehA3plIMOHeGpJVBv1OcFpmMpgW
	vkTn7ey4aVfI+w0/J/4LOohw4eGr34rG3vfpJ+9T23cPby+bNZR2UNj7z/Wqmfae
	TeX4IGx3LSW9wtpDEHhqm1MSoZCMgarl/zQcnwv41/KsQsu7YpjreZH6FRK/64OA
	caRhYX0omQcNwAeqqgR5mPOztcpCbAvQyFRbnXFD/KMGGahaxXmzE6wLoBipV7ZK
	9QMVqX+LaB19GSYzD+yIK+BpvGXOp0oFN5timrJ6FAjZcQe5TdzhoEQ3EhuH3HK4
	Foytsy9IJ5OBNPEjO6AlGpJLhbJ9apLPOL9CobERFUpgfA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1s3Lnt49qP5x; Fri,  5 Apr 2024 19:49:50 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VB8G635tgzll9bN;
	Fri,  5 Apr 2024 19:49:50 +0000 (UTC)
Message-ID: <5b36f7c4-faab-4cdc-ba80-e7135ba50242@acm.org>
Date: Fri, 5 Apr 2024 12:49:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix handling of SCMD_FAIL_IF_RECOVERING
Content-Language: en-US
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Mike Christie <michael.christie@oracle.com>
References: <20240325224417.1477135-1-bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325224417.1477135-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/24 15:44, Bart Van Assche wrote:
> There is code in the SCSI core that sets the SCMD_FAIL_IF_RECOVERING
> flag but there is no code that clears this flag. Instead of only clearing
> SCMD_INITIALIZED in scsi_end_request(), clear all flags. It is never
> necessary to preserve any command flags inside scsi_end_request().
> 
> Cc: stable@vger.kernel.org
> Fixes: 310bcaef6d7e ("scsi: core: Support failing requests while recovering")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ca48ba9a229a..2fc2b97777ca 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -633,10 +633,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   	if (blk_queue_add_random(q))
>   		add_disk_randomness(req->q->disk);
>   
> -	if (!blk_rq_is_passthrough(req)) {
> -		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
> -		cmd->flags &= ~SCMD_INITIALIZED;
> -	}
> +	WARN_ON_ONCE(!blk_rq_is_passthrough(req) &&
> +		     !(cmd->flags & SCMD_INITIALIZED));
> +	cmd->flags = 0;
>   
>   	/*
>   	 * Calling rcu_barrier() is not necessary here because the

Also for this patch, please help with reviewing this patch.

Thanks,

Bart.
