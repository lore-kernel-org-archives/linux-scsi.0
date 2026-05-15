Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814249552D;
	Fri, 15 May 2026 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778858865; cv=none; b=G6WF8AsjEVmGvu2/jjm1R8r8UMkIE3X5OOyaf3bkI1ueZW+kSfBr85kQCG+y6uPa4Up3rNPWJCVNZbuQ0MIegzg17FYap3hid0J38DaLLqW/V1xdDCrDqC+RPfRscsNGnm2WVrJGNBsm6c82D9FKa2P1tOfUuOrldxk+CVpgNuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778858865; c=relaxed/simple;
	bh=dx8k3BK8KQImG9hsFL//BzOwDd524UUThJswDm6HbmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MlKJhvjSkC+d4QXydhkVoXnAXfr5/mdzm3kJxCAXry1dcLe/iq1BOb18cvAzMKz7YC1SSw5y/bcpIRNUUTIsfLvGnH+X5P6LSGBmXqoCKE+KbtIYSlEsZWOLzJD0MNzLOpVJsqV4qOJlbNPOkW8j381+32ZtzFNqdivqVVNTsoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ju1zWl5J; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ju1zWl5J"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gHB083bDJz1XM6Jl;
	Fri, 15 May 2026 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778858852; x=1781450853; bh=OG2WY8/5i/n3+u6CBSE3CYVE
	vqJAu+jfD7jrcYXWIA4=; b=Ju1zWl5JvPolg0DvFeoBKeCHTswSZqsoWCmwnwOe
	ujMBT5txoyZDt4S1pwxpX/vl+7FolU2XdH9lGADnRTzOvio+H3P1mwIWM6iYSDXK
	npK7fQCfI1gJb0XjT14UnUDxSnmunZzS/yg1XZ5m4cNVRCYkAAiXBqgu9+M11JvI
	BKQZdG47hGWNYqvZ4We2a6mkVTYqm7gzGQnJHGzfbfmFiaYwgHFBYJ6WLGysS+Zs
	xKw34IlD1h0KBXt/uxzNmYPfmHY+D9yXksOwgH7ZlPiMqn+1TyUxfAlsSc1DpzqJ
	ukaNBCiP/nJfqCKhi1An+b9lSAbNSCzjJT1M6VvwHPecqg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YeEnYe6cy7iZ; Fri, 15 May 2026 15:27:32 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gHB011xXTz1XM5kt;
	Fri, 15 May 2026 15:27:28 +0000 (UTC)
Message-ID: <9fde73e7-0108-48d7-a1a0-ccc9776beb5c@acm.org>
Date: Fri, 15 May 2026 08:27:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/11] scsi: ufs: Use trace_call__##name() at guarded
 tracepoint call sites
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <20260515135946.2238888-1-vineeth@bitbyteword.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260515135946.2238888-1-vineeth@bitbyteword.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/15/26 6:59 AM, Vineeth Pillai (Google) wrote:
>   static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
> @@ -432,8 +432,8 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
>   	if (!trace_ufshcd_upiu_enabled())
>   		return;
>   
> -	trace_ufshcd_upiu(hba, str_t, &rq_rsp->header,
> -			  &rq_rsp->qr, UFS_TSF_OSF);
> +	trace_call__ufshcd_upiu(hba, str_t, &rq_rsp->header,
> +			       &rq_rsp->qr, UFS_TSF_OSF);
>   }

Instead of making this change, please remove the 
trace_ufshcd_upiu_enabled() call because it is redundant.

>   static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
> @@ -445,15 +445,15 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>   		return;
>   
>   	if (str_t == UFS_TM_SEND)
> -		trace_ufshcd_upiu(hba, str_t,
> -				  &descp->upiu_req.req_header,
> -				  &descp->upiu_req.input_param1,
> -				  UFS_TSF_TM_INPUT);
> +		trace_call__ufshcd_upiu(hba, str_t,
> +					&descp->upiu_req.req_header,
> +					&descp->upiu_req.input_param1,
> +					UFS_TSF_TM_INPUT);
>   	else
> -		trace_ufshcd_upiu(hba, str_t,
> -				  &descp->upiu_rsp.rsp_header,
> -				  &descp->upiu_rsp.output_param1,
> -				  UFS_TSF_TM_OUTPUT);
> +		trace_call__ufshcd_upiu(hba, str_t,
> +					&descp->upiu_rsp.rsp_header,
> +					&descp->upiu_rsp.output_param1,
> +					UFS_TSF_TM_OUTPUT);
>   }

Same comment here: I think it would be better to remove the 
trace_ufshcd_upiu_enabled() call rather than
changing trace_ufshcd_upiu() into trace_call__ufshcd_upiu().

Thanks,

Bart.
