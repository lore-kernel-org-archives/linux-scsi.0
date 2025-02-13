Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219C611CAF;
	Thu, 13 Feb 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739471072; cv=none; b=uJnkJkaKr03PlUvpJSTkhNWlz8flPWpVuiOGQIAUDBcWaNgIxf2r0D5HLcn/eJ0uWRnQgJYRtj/t97mg3jFse81Kkg04PVbY4KFxRlGKmhIcJ46Nta9RFl4CzvP2sUYH0YC8a+xDK397dHdpA45BR8AtL87FH7nNUt8w1X6LfQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739471072; c=relaxed/simple;
	bh=SWcQJVY6fjGqIc0KsyRyLC/M24sborSX2EWHracIT1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQ8yKk4SXc9uiHK8rA95KcpAma9/WfsTzig3TGpUouncSPBHXlvigy7Jangc1TIJRmOWNJFHm1Q9cvXmRNDGSbT7iIdDw88zsV7OwKC5imZytJEq9GJICZmmnF+b5pY/VsLst8qQ0bRn5kHmANhe3Z1sjJ5XVLWVyPRjvvZnUUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bEoSDBnI; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bEoSDBnI"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yv3Vk2YzTzlgTwy;
	Thu, 13 Feb 2025 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739471068; x=1742063069; bh=nQGC01Qrr3r1Q8S7grPrdh/m
	BZKDKvIk8yNSvcve6yc=; b=bEoSDBnIz5eCwEtun/yujhj2OGNyMmqLiFxA/MEf
	ZWuNXoMTeHhyssllR3HgZ3dyqArd7Kdw+0GigmGGsikIR9NdvxKHyXQl9gDkfZwC
	pmklBxTBP8sgO1t982kJsV6K2rH5xnuzcufrwB+JyaN6LpkIxki1kHLn/F6V5Csx
	DiDSvW1i+mnF5yZzm5mW6TwTXF9GrD0rM6kB9Th7A3rWqvBuLsQ5+sxDm56mV1tB
	nJLITIDqV7lY3bnhHwGqpoWMSLAzm2r5QmhE7AmA+OhFvNszAgYoFv8b0hrI3amo
	SgUhoDBcRwIyLB+naCWGfaWligdQXPgzNAAts/P/w/mDvw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AKyf3espKj9y; Thu, 13 Feb 2025 18:24:28 +0000 (UTC)
Received: from [100.118.141.233] (unknown [104.135.204.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yv3Vd6zskzlgTwj;
	Thu, 13 Feb 2025 18:24:25 +0000 (UTC)
Message-ID: <2c1fcd13-ffac-4590-a345-c5389d1ccc9f@acm.org>
Date: Thu, 13 Feb 2025 10:24:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy_pad()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org, storagedev@microchip.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250213114047.2366-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250213114047.2366-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 3:40 AM, Thorsten Blum wrote:
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c7ebae24b09f..968cefb497eb 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7236,8 +7236,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
>   
>   static void init_driver_version(char *driver_version, int len)
>   {
> -	memset(driver_version, 0, len);
> -	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
> +	strscpy_pad(driver_version, HPSA " " HPSA_DRIVER_VERSION, len);
>   }
>   
>   static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgtable)

Has it been considered to introduce a Coccinelle semantic patch that
performs this conversion? See also the scripts/coccinelle directory.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
