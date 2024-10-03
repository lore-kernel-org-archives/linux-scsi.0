Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797AF4437A;
	Thu,  3 Oct 2024 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727974643; cv=none; b=jdEaxDgCY/X9kdnH5kUZo9VeX7ZuvDcNcqCMCkVzMrdjGPuLYxRU3o7PfzhzkvTKjWStGYzq/d+8aQgs/YctDTt5rymuqbveMcM1Fg2ME/aXmMCykLIyRGr+KghwP1Q30dO3hoQApKCtDp+9sF6D6RjkHtyd9pFcDd2IRBaXLLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727974643; c=relaxed/simple;
	bh=VsFk6+TLPudgQmDGtl8MwvmIGXQ0r5uoVYcc0y4VebM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gcVMmldit+PZ7vRhxzvdgEPXqJEeVRcBXWmMkXliCHbvyOVqxo/cAjZMqFrV2lLj8mzBMfXLc+TR0VJpxvoZpnyOFgnhrzb43hhBJU4ZNdTpEeBjqKjtMGisXLEmk/gfMUjb1nzRPyMizu28DQvCLcAgRPwPpKu58Bo+vA40aaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Nd9ituMU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Nd9ituMU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XKHsR4Ddvz6ClY9K;
	Thu,  3 Oct 2024 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727974632; x=1730566633; bh=iwZDtLuPiBweZtFFan7lukAN
	DXRNJFfOg0qVvy7GloA=; b=Nd9ituMUY9C275MemzLyjIipvpuwiPkCh8tfyXum
	l1EJ+iKnusea3xMXuBoO1jl/kilb7PA/b0vck9Go17qqxeypOvHMZMMeH4LnpwBW
	CwmvbCToAmORqw5TgOQBYbOtHDwX2Fwj4LL4vPsaq5HUGABCZ/Q0vt9CEAJYgjkN
	Yy6n+5SvPHq7UYqyKkZGlraKaLlTeB7co2JhYIaT1qEV6TUKl41QlJkqhmNWUfBy
	uKctoPE6nxckm6qQufrCVlGlhI9FwvrRNYr/+T/kz/fLqKirpgrrdgv5jIyxFEAo
	H80e2Cae+O2pmeGIF9DedhyeGI7wHhBN2WTbo7N0NBV1Fw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aBjs9AcdSAbO; Thu,  3 Oct 2024 16:57:12 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:5e69:f68f:46b8:95af] (unknown [104.135.204.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XKHsM6037z6ClY9J;
	Thu,  3 Oct 2024 16:57:11 +0000 (UTC)
Message-ID: <15d49b6b-3654-4cad-b770-be36a406e356@acm.org>
Date: Thu, 3 Oct 2024 09:57:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: wd33c93: Don't use stale scsi_pointer value
To: Finn Thain <fthain@linux-m68k.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Daniel Palmer <daniel@0x0f.com>, Michael Schmitz <schmitzmic@gmail.com>,
 stable@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 8:29 PM, Finn Thain wrote:
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index a44b60c9004a..dd1fef9226f2 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -831,7 +831,7 @@ wd33c93_intr(struct Scsi_Host *instance)
>   		/* construct an IDENTIFY message with correct disconnect bit */
>   
>   		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
> -		if (scsi_pointer->phase)
> +		if (WD33C93_scsi_pointer(cmd)->phase)
>   			hostdata->outgoing_msg[0] |= 0x40;
>   
>   		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
