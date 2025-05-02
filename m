Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92731FCFE2;
	Fri,  2 May 2025 08:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175730; cv=none; b=ndSxOJvl68ZAHL4G6rA25qnNg51NfccYuAkV7KvzG+avvm4Wd9NTbWIY3FN3y5mwml5tAS1aQri6K1rfl3kZLdu+ynqii3EXRIKBZSqHI50dl3p81OP+rDGHSy5qUpNQU+dS2Dl5y4cIK/6f+9JDJKJi7CbMl5DFEk4UCIykois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175730; c=relaxed/simple;
	bh=fe8rldfrPgRZg3hhLMIdxGvGDgxrjTFzytuQFtczGX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HlWZ4nbMCT2ay+XjOExeSDD6A36WVUtHgifLbJ5UiKVr98qBs4dDstwKkRaQtj/mpkHaSCd6Xvd/4mAssvnlCrgAm6DkM/rR1Ypcb8lKnwvoj8Bn2F1vGs+UhKJJ2+QsN49wp3mLQZ9P1wVxDGV2a2+MPmC5YwSM/FBdT4IfMrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.102] (213.87.139.230) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Fri, 2 May
 2025 11:48:38 +0300
Message-ID: <776e726b-7814-4a8c-ad13-853122bf85ef@omp.ru>
Date: Fri, 2 May 2025 11:48:32 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] usb-storage: reject probe of device one non-DMA HCDs
 when using highmem
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-block@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<usb-storage@lists.one-eyed-alien.net>, <linux-mm@kvack.org>
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-5-hch@lst.de>
Content-Language: en-US
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <20250502064930.2981820-5-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 05/02/2025 08:29:13
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 193072 [May 02 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 56 0.3.56
 52db7f275cc9b6820389ba9ab2ac225370e1c244
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.139.230
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/02/2025 08:32:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 5/2/2025 6:29:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 5/2/25 9:49 AM, Christoph Hellwig wrote:

> usb-storage is the last user of the block layer bounce buffering now,
> and only uses it for HCDs that do not support DMA on highmem configs.
> 
> Remove this support and fail the probe so that the block layer bounce
> buffering can go away.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/usb/storage/usb.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index d36f3b6992bb..49bbfe4610d5 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -1057,12 +1057,15 @@ int usb_stor_probe1(struct us_data **pus,
>  
>  	/*
>  	 * Some USB host controllers can't do DMA; they have to use PIO.
> -	 * For such controllers we need to make sure the block layer sets
> -	 * up bounce buffers in addressable memory.
> +	 * We can't support these controllers on highmem systems as the
> +	 * usb-storage code lacks the code to kmap or bounce buffer.
>  	 */
> -	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
> -	    bus_to_hcd(us->pusb_dev->bus)->localmem_pool)
> -		host->no_highmem = true;
> +	if (IS_ENABLED(CONFIG_HIGHMEM) &&
> +	    (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
> +	     bus_to_hcd(us->pusb_dev->bus)->localmem_pool)) {
> +		dev_warn(&intf->dev, "USB Mass Storage device not support on this HCD\n");

   Supported, perhaps?

[...]

MBR, Sergey

