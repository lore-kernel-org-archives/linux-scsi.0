Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255197494;
	Thu,  5 Jun 2025 00:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082455; cv=none; b=QEdr8V8uJUSEPgWyRu3Qlp2skM/j4vEzxW/SimcFqMhQY3swQO0C72tRDve7dPGed4VkUUFpM4mJqXdjvhAZrPB45UaSFFDQoSgJ2R/tg5MInDcGm3EMUaOpbS8ECsN2GDom/92rf238MUZrPn5NCZ+q5el0Z4ZCcGJ1y+wPRdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082455; c=relaxed/simple;
	bh=OvPLCeB55L0RuDui/KZ+CQQzw8Bt/DaYKr8ttCBT4VY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YAcsvPM+rVmIyiBd59bSpiYgxCrx6YcQnjVvi8RIsczl624UhhnIuTneYe/nV28xsW4a6TTcRejDOCZxGkLQL3rMVyQq5HoiiSSu8/PuwV1720pUl4ReKK1HChe6WWA4JOVnY5kxcSB2X1GJzY+O6Psro+OluCPNIsWy2lJW6rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kd38s4ZY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kd38s4ZY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bCQ0s5W72zlgqV2;
	Thu,  5 Jun 2025 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749082444; x=1751674445; bh=J1hN6iDCB5et+MfuuqWoYZy/
	UgxCtxyLw1S7Uy+ea8E=; b=kd38s4ZYYqGHNRTD6GPK3WFRz1LfU+991Bm8vzgd
	aEy4flDgvmU+4I9ET7JUE4Tfv85zn3eaxyZibCLjiQONkYik/0u+A8SPP/9ySvSf
	7/JILcYL0u54dNTyVlO++36Ta3TRtu4ie2e3Mfo9Fq6r6qO/wiQkHiRnC8F3rW50
	LyALPYpPD6GKl1a9LlccW22BXFG5YfN4AtYxbI8SUx02TaRq6maJ7EpBNSG8Drtn
	coT97345B2J176DTCq9sp5r2O5ZadgqV/AP61MlTqTRJGE1tx+WE73tbZm6tJHva
	iQ8e2Ro+ikbHVlXR9Udhdnb99OveW2jkgNyQknSHuSTyKA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0RMwR_oiVVUf; Thu,  5 Jun 2025 00:14:04 +0000 (UTC)
Received: from [192.168.15.124] (59-115-185-62.dynamic-ip.hinet.net [59.115.185.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bCQ0k3zgdzlgqTy;
	Thu,  5 Jun 2025 00:13:57 +0000 (UTC)
Message-ID: <0959d3c2-b849-4826-8edf-d72a89fbadff@acm.org>
Date: Thu, 5 Jun 2025 08:13:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi/fcoe: simplify fcoe_select_cpu()
To: Yury Norov <yury.norov@gmail.com>, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250604234201.42509-1-yury.norov@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250604234201.42509-1-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/25 7:42 AM, Yury Norov wrote:
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index b911fdb387f3..07eddafe52ff 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1312,10 +1312,7 @@ static inline unsigned int fcoe_select_cpu(void)
>   {
>   	static unsigned int selected_cpu;
>   
> -	selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
> -	if (selected_cpu >= nr_cpu_ids)
> -		selected_cpu = cpumask_first(cpu_online_mask);
> -
> +	selected_cpu = cpumask_next_wrap(selected_cpu, cpu_online_mask);
>   	return selected_cpu;
>   }

Why does this algorithm occur in the FCoE driver? Isn't
WORK_CPU_UNBOUND good enough for this driver? And if it isn't
good enough, shouldn't this kind of functionality be integrated in
kernel/workqueue.c rather than having the above algorithm in a
kernel driver?

Thanks,

Bart.
