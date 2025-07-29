Received: from smtp.smtpout.orange.fr (smtp-69.smtpout.orange.fr [80.12.242.69])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA2E2253A4;
	Tue, 29 Jul 2025 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753811170; cv=none; b=Z1nEzmsP4R2eXc3gLZSTkP4AshhkphZdYzVVwVSDaCAKWUnarub+vxc0xmeEhiCcUEDTP7WlmdCEtl4MbaC2/HHeqtfML59LA/JLWju1tO4PPpX1ME+npfLLVdoxrngrYaltzZGM4phPdNjlYNAX/7Mju66lqv/ZOBFWzMFvfm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753811170; c=relaxed/simple;
	bh=aSAuubOoZk2xBwNE0D2tRu3u7GFonE019Ql06DMqXJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dFPz9OpEwTfNkJjAWNJj4xZWNxTByY7lphd3gBvNd0a+T4J0pUtX4v/moy9oZQDQNtYrFKvOGph9Rx2OslDDu2tEXh1QiPQsJVQMQEnSuirrZLvbJiJfFHIqYJHLNhpPzcBENQrwwFJJULskL+v36UQEZmvlfBvkuH0byqcV6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=R/Q6KEB3; arc=none smtp.client-ip=80.12.242.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="R/Q6KEB3"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id goOiuRT6C5DGfgoOiuWHeR; Tue, 29 Jul 2025 19:45:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1753811157;
	bh=NJG6pmOoHfRxQ3083ukC1LQhV9BLsROAtVMoHOK2Xr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=R/Q6KEB3eWgp7Y/dfAEdxrjdE1OFHv0A1X1NxfYzvY2YvXEJ5plps3Nl5muH8bpGG
	 XBrt3z9vGsK5kpzKXymDQ3/soSd0uHA2y98o6PpEoUKqhWY472iA7yh3lwJtu6d044
	 v6aqpVkPM6Y9JcWkEgvCZQjv8MP1p04BJjR/1LIUSUM2WKaul8sYNOpmKK/ZTSCNw1
	 oumXPsBPLWpv93cfYQaQV8ioAPHqISmqC6/mzY4aUuKwuynU6W/tTk2kow2UdMzmQb
	 tARaucxjiBs6oPT/KlhTAXPwdKtCQQ7QOVm3eE9AOL4XxtCV78nMz+Rw7ztDJ/591h
	 ogCZGuK25uQcQ==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Tue, 29 Jul 2025 19:45:57 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <86f359c3-8eb6-4fd7-8411-12d12e301d61@wanadoo.fr>
Date: Tue, 29 Jul 2025 19:45:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static
 const
To: Colin Ian King <colin.i.king@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <20250729064930.1659007-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 29/07/2025 à 08:49, Colin Ian King a écrit :
> Don't populate the read-only arrays on the stack at run time, instead
> make them static const. Also reduces overall size.
> 
> before:
>     text	   data	    bss	    dec	    hex	filename
>   367439	  89582	   5952	 462973	  7107d	drivers/scsi/scsi_debug.o
> 
> after:
>     text	   data	    bss	    dec	    hex	filename
>   365847	  90702	   5952	 462501	  70ea5	drivers/scsi/scsi_debug.o

Hi,

out of curiosity, any idea why 'data' increase?

All my constification patches lead to data reduction.

> 
> (gcc 14.2.0, x86-64)

(same kind of behavior with 15.1.1)


CJ
