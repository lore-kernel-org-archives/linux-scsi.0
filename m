Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07416376BE0;
	Fri, 24 Jul 2026 21:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784927894; cv=none; b=gPx/CJPqMUqb0MdiLB5wmvPXzcLh3maz52Lx9sYiofYh50cI+rxoyQvIrS6vI0xRH1KyComGSd++lslJPDgd9AwkFrx2BB7+eoWG6XLtiHiq2FoVi9e2ywM80oZWN00xAdBsIaN5AAps0X9q6dMINgV87WZF+de/flhB9Cxpgjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784927894; c=relaxed/simple;
	bh=WlkQTU+6bYVN+0cBhxLtmU4F9kbCHxY6kvW0RXmkHtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u22E8urJCws5YfO1HIxdXz10DaLj/fpry1SFHJO1ODbQV+A2TJm0L5T5Z6jzyXS38QC/AcJCtZ8Fj64RcG82Rc8SW878UPBR8rMA52tYOM+dXgHVOTXbApvADl6yaTyzxLFBhdnITB8ZzLBdOdnA6zkysahWyHGiqOxrQZUXvuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sMHjdQ4s; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sMHjdQ4s"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h6LSN2985z1XM30g;
	Fri, 24 Jul 2026 21:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784927888; x=1787519889; bh=JtymtIx9LDfJbYLG4w+UOTgd
	B/gHKgQjsvXBo6Arku0=; b=sMHjdQ4sBFdFO5bH3Xwvh9fCfYYZy86RyYY4yfWj
	7mH+Pwf491mBryrK6opqi2wREqBBAr+PoWdGbiebLWqYKzN0cV1esbDVR4XAX7o4
	3h+Af42kTtNJ8Cr6eV2eq6FVdO0djBxaajwSHsJ26UxsynrVgt95kneXZ1HjPKDN
	2EGXnWMidhiCegoiMKfmYl6sAoDXRdYtxBYATr72IIotuokZkGzvCwbujlzwTNw2
	0hK3TraRjg64d8MZwIFMvhZL7OA/zxygVrJLYk/Qq2pHd4ejsrXxBioCBlF/bkZ7
	s/t65mhd5KKUlefhc6CIJM+BnOiNLTOiQ5y9bSguVcTgFQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H8UmAWvmbvlb; Fri, 24 Jul 2026 21:18:08 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h6LSG5xWSz1XM4Tn;
	Fri, 24 Jul 2026 21:18:06 +0000 (UTC)
Message-ID: <90a7222e-6779-485c-80d1-e4b814a9ac23@acm.org>
Date: Fri, 24 Jul 2026 14:18:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: core: pair EH runtime PM get and put
To: Hongjie Fang <hongjiefang@asrmicro.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 jgarzik@redhat.com, stern@rowland.harvard.edu
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260623074408.1639663-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260623074408.1639663-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 6/23/26 12:44 AM, Hongjie Fang wrote:
> @@ -2383,12 +2384,16 @@ int scsi_error_handler(void *data)
>   		 * what we need to do to get it up and online again (if we can).
>   		 * If we fail, we end up taking the thing offline.
>   		 */
> -		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
> -			SCSI_LOG_ERROR_RECOVERY(1,
> -				shost_printk(KERN_ERR, shost,
> -					     "scsi_eh_%d: unable to autoresume\n",
> -					     shost->host_no));
> -			continue;
> +		autopm_put = false;
> +		if (!shost->eh_noresume) {
> +			if (scsi_autopm_get_host(shost) != 0) {
> +				SCSI_LOG_ERROR_RECOVERY(1,
> +					shost_printk(KERN_ERR, shost,
> +						     "scsi_eh_%d: unable to autoresume\n",
> +						     shost->host_no));
> +				continue;
> +			}
> +			autopm_put = true;
>   		}
>   
>   		if (shost->transportt->eh_strategy_handler)
> @@ -2407,7 +2412,7 @@ int scsi_error_handler(void *data)
>   		 * which are still online.
>   		 */
>   		scsi_restart_operations(shost);
> -		if (!shost->eh_noresume)
> +		if (autopm_put)
>   			scsi_autopm_put_host(shost);
>   	}
>   	__set_current_state(TASK_RUNNING);

Please capture the value of shost->eh_noresume in a local variable such 
that concurrent changes of shost->eh_noresume can't break the above
code.

Thanks,

Bart.
