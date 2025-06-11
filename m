Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA1C1DE3C3
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749656778; cv=none; b=dC+ADPwYLBd8gDJwzhKdwdwh8+iW7t/9i4B71rjsGtmuKtqpVCpN9lL6pnoswVn/GHWn45hUkM6S7/1BSF6EL2CgVHXB4dbk9gIzPpkPoO6MH5ss9sAm1o+sGQVWjLSDE9NrU03z2uEJft0bgaVUFx5SD/ZBC2lHdoaRjgK+7GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749656778; c=relaxed/simple;
	bh=8oNK3qitZXkrEipdiqTWBQBKfwJf3jqcij39ZN/CfVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Cf1k51ynsJmnIhQa3JFcRXyGm0b32MBjNXlO1h/OPsjhQCNCdibBKSG3/78c4UkZtCa/DGlI9qzFjIULnTbv4QzJWTB1EqmuwLnZrg9Jpyrkjbm3+XIESB9L0s5+vX3IOGlNgY1zbJwPr3IpOXMbTjIkfu8qSxP8eBekBD83HB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sYhCQOpf; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sYhCQOpf"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bHVPg3qnpzm0jvn;
	Wed, 11 Jun 2025 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749656774; x=1752248775; bh=1rWfkeVP8ZX21cLWACQfhqYC
	NsG4a5E5DcWvPEdGc6w=; b=sYhCQOpf3jgjBrhL7MflmN/t1w1gGCSUGuoF5PLR
	F5H0wso1JjSK6lHqCOKp8OANxW63grhufYx5lgMzN5wXS6Xy5eRH7AYOi2SfMjGB
	jVqwPOyYCF2LItviwhgb9K9wDN7JxcOCLISaZldBA+7CX/b7oPXBammmMWdOBLSv
	sf5z4N2gIZRuY19T01Y20auEnly1d2+1OsVJ5axFNCfDaY6jViSNRrAnJdnps+0w
	d6rZCrwX3KhyT/qwU1mOoj2FCzhMtGro+jLdRaWaAWYACAU1UEc9L0DSgq+XE8rN
	sXjyS4CiKAc0oVgjKNBY2hkWZkeRy7yi05++NdIqfv0EPg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id baGEXOJhh4qc; Wed, 11 Jun 2025 15:46:14 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bHVPc4Yl3zm1Hbf;
	Wed, 11 Jun 2025 15:46:11 +0000 (UTC)
Message-ID: <aca75eab-45b4-4afd-8319-e2662fd9d9e8@acm.org>
Date: Wed, 11 Jun 2025 08:46:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250611093421.2901633-1-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250611093421.2901633-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 2:34 AM, Damien Le Moal wrote:
> scsi_add_lun() tests the device vendor string of SCSI devices to detect
> if a SCSI device is in fact an ATA device, in order to correctly handle
> SATL power management. The function scsi_cdl_enable() also requires
> knowing if a SCSI device is an ATA device to control the state of the
> device CDL feature but this function does that by testing for the
> presence of the VPD page 89h (ATA INFORMATION page).
> sd_read_write_same() also has a similar test.
> 
> Simplify these different methods by adding the is_ata field to struct
> scsi_device to remember that a SCSI device is in fact an ATA one based
> on the device vendor name test. This filed can also allow low level
> SCSI host adapter drivers to take special actions for ATA devices
> (e.g. to better handle ATA NCQ errors).
> 
> With this, simplify scsi_cdl_enable() and sd_read_write_same().
Hi Damien,

There is only one "if (is_ata)" check in the SCSI core as far as I can
see. Can it be avoided that ATA code leaks into the SCSI core by
introducing a new function pointer, e.g. in struct Scsi_Host, and by
calling that new function pointer if it has been set from
scsi_cdl_enable()?

Thanks,

Bart.
