Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A53BB48
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831439; cv=none; b=sJ/4nZeZML0h3bOEMWv+00H8LGhrQijEA8kBLfbr5u3y3M/fxiFfMzB/b7N6RIJB6GG7NYLZs79+2IFy0RFi4hsws2xXh57aMIABHVoC84JSBsZmSTP+c4iqHzGhfnCWMcPXgHQmNgeOHq1lvEYgWxgI8ONXWmu7tbj7ULEwIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831439; c=relaxed/simple;
	bh=avw3seADXvthv5BwvZlqHtXib0+I2cdMmZx6sSUGlGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eyEfG5+ITh0BKsxUIdnwjUxyYLHlD4G9dEMQebmr08Bsx1m4PlqP0UcWj/uhki5f1UgZ2RscvXAXiVsqYBgV2P+egep5bCg+pn20Y06kQL1Wu8f/Lzosc+9MU9IjWFEA12GclNGrbx+z7JPwt33S7Mmh2dnkEZij8IkGqUE9NuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cupnAllB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cupnAllB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bJl0P2yKdzlgqTx;
	Fri, 13 Jun 2025 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749831428; x=1752423429; bh=zw8quaIQ+lLMP6whlgAjoSus
	0RD5h5yKdUxjhw5bMSc=; b=cupnAllBL6Qz/dwt3wJbcUlxHNW3fesKqUzr1xDA
	Xxyeh+hYRA0PdNZBtXnpaPEbn4edU1KNzPtTDmhq5xWg6EwceTmsY3o3fUSOZP+N
	HZGMB2hAIVDLcoHp4+XjMqjp8uYhQrOMsiFyYAS/YWWPLA32t6YJMzfTQqVu/eog
	kkAsiHk58tKCv3r1aLzME/diDHNMjFX4zqXdjrpkvgU9bs6xztOuCFfETDGGQ+O8
	dJT1WLWrl/GKLdT07Ib0WY/JxVlB6Y/t1dTCLgFF1IBA/Ky6o354tGpYAYcWBafM
	0iSxa2SudkflDCaZlgqCW201WKGB+V7/DgctZwlLDtodSA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8vtQhhwH4Voz; Fri, 13 Jun 2025 16:17:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bJl0L61HVzlgqV5;
	Fri, 13 Jun 2025 16:17:06 +0000 (UTC)
Message-ID: <3eb1100f-a0e4-4ed0-99e0-9e58c2cd5223@acm.org>
Date: Fri, 13 Jun 2025 09:17:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] scsi: sd: Prevent logical_to_bytes() from
 returning overflowed values
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250613062909.2505759-1-dlemoal@kernel.org>
 <20250613062909.2505759-2-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250613062909.2505759-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 11:29 PM, Damien Le Moal wrote:
> Make sure that logical_to_bytes() does not return an overflowed value
> by changing its return type from unsigned int (32-bits) to u64
> (64-bits). And while at it, also use a bit-shift instead of a
> multiplication, similar to logical_to_sectors() and bytes_to_logical().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 36382eca941c..53658679e063 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -213,9 +213,9 @@ static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blo
>   	return blocks << (ilog2(sdev->sector_size) - 9);
>   }
>   
> -static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
> +static inline u64 logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
>   {
> -	return blocks * sdev->sector_size;
> +	return (u64)blocks << ilog2(sdev->sector_size);
>   }

 From <linux/types.h>:

typedef u64 sector_t;

Hence, casting 'blocks' from type sector_t to type u64 is not necessary.

Since 'blocks' represents an LBA instead of a byte offset divided by
512, please consider changing "sector_t blocks" into "u64 logical_blocks".

Thanks,

Bart.
