Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E385AD2C;
	Thu, 23 May 2024 22:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716505084; cv=none; b=Y3MqIRLfHST0OfohZwFaDIGPfNITSQvFlyHzlCi07Jmd86RbhoLnNSPLzpOB0mYKHoeJTP3QOnZTViE1Ox9sGu/WLLesgz91U5Dc9ZRuQZpp3iw+5EgLCeZFnDMk+WGwjtJ/kmqW3g7RXvBCMzxpuYzezXpRqob4JeXkYNgOsKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716505084; c=relaxed/simple;
	bh=Nso4LeDsPgRwA3y5ntfVwS2yTQVAL6W0NHdttW95LJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ruYJ2ap+JvhfPq/Bx3WnemeXu0P5x/kptRH71cS1I8++j6NW6T2c4dSUSZEKnu2uyQG0diCi66si8IN++EPveBz3p3U1CHfkrqj2hbPxqeemD+wmQJ0+FYHN/IDv60ECB3lw7JZ2KKfuF4qPPBmcG93i058mQa87iMS0D82Puhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Dt49AgH+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Dt49AgH+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vlk902D2Wz6Cnk97;
	Thu, 23 May 2024 22:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716505074; x=1719097075; bh=qqhCKQu3UeNC7jFMltKTGXCo
	QiUn9mf1IFe+KSvD1rs=; b=Dt49AgH+IFL9kNPGLTd0scEDmCsA+P7nUJxorxVq
	bnnPGkq42IcSEGpl8U8F5ZX/R/gWj+kuCRMjJPxpskyfVynodh5irQ29uODgdMw1
	gIvMio7Gdi5xe3SP0NZd96HaBknLt8cIsqyQmxeQR6w1UACi6dJjQjyXAhGZ48aA
	oPseuPddv3g7xLnB4RfPP0MOS4Pkt28b0SAz/wFkcnvelTzA3Lf2XVcWWAdAB6Dm
	GEdYBhzt5yuUgTc7dQ5fhAEG+Jtpjp6CiBfqc8chYm3+nQfcEfh+9n3RBtwgDdIj
	SmhGY5pB370awlisisVyHfjEdsYBb9/Bt2smZ7HT5vAfiQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bgQ_R7wUSVW2; Thu, 23 May 2024 22:57:54 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vlk8x2szcz6Cnk95;
	Thu, 23 May 2024 22:57:53 +0000 (UTC)
Message-ID: <0b911c95-1beb-49a3-a01b-c670b7ada3fb@acm.org>
Date: Thu, 23 May 2024 15:57:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Handle devices which return an unusually
 large VPD page count
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Peter Schneider <pschneider1968@googlemail.com>
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <20240521023040.2703884-1-martin.petersen@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240521023040.2703884-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/24 19:30, Martin K. Petersen wrote:
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3e0c0381277a..f0464db3f9de 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -350,6 +350,13 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
>   		if (result < SCSI_VPD_HEADER_SIZE)
>   			return 0;
>   
> +		if (result > sizeof(vpd)) {
> +			dev_warn_once(&sdev->sdev_gendev,
> +				      "%s: long VPD page 0 length: %d bytes\n",
> +				      __func__, result);
> +			result = sizeof(vpd);
> +		}
> +
>   		result -= SCSI_VPD_HEADER_SIZE;
>   		if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
>   			return 0;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
