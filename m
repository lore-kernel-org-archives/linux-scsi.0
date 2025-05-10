Received: from mail-m8327.xmail.ntesmail.com (mail-m8327.xmail.ntesmail.com [156.224.83.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFFF1C6FE8;
	Sat, 10 May 2025 05:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.224.83.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746856288; cv=none; b=lT4OATUmxXYnoQqfzDSsr49Sv+ceUn5FcWSnhCupVx9urXm56d/AIkuacJ86bsFO9dENAG8SZaWrJznKEj6w4qBX1pVtc8L+0cD+ubbopqu/cRSyhs9zUdMhCqYgQssVSO2KrymQB/Lj1pUUAB98IjKAhurd7Y2W5jiy8EQG7bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746856288; c=relaxed/simple;
	bh=KC0f4NcgvAuBmb2oh4vE1jM3mEtPu06HOF02kc+Ru0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VsAiFTP/XE9Jau8aFrorVISwxkmL8bDY91qzkKiFfRh6py96jKsT8geokr669RZXsw5KBB86NIF/QnoBrquOpPGQfYGhYXkCEGH4vyffCdP70XOFU5hXFmlDAFBD0JEw3c7AHlPmdpmYfCrkDLBQD+Sjux/fsPcIQB5IQIxHpr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sangfor.com.cn; spf=pass smtp.mailfrom=sangfor.com.cn; arc=none smtp.client-ip=156.224.83.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sangfor.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sangfor.com.cn
Received: from [172.16.212.10] (unknown [121.32.254.146])
	by smtp.qiye.163.com (Hmail) with ESMTP id 148f13876;
	Sat, 10 May 2025 09:15:13 +0800 (GMT+08:00)
Message-ID: <a497880a-e6a3-409d-8c4e-d5086459ce3a@sangfor.com.cn>
Date: Sat, 10 May 2025 09:15:13 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: smartpqi: Fix the race condition between
 pqi_tmf_worker and pqi_sdev_destroy
To: Don.Brace@microchip.com
Cc: dinghui@sangfor.com.cn, zengzhicong@sangfor.com.cn,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 storagedev@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250508125011.3455696-1-zhuwei@sangfor.com.cn>
 <CAF=wSYo0=US5Rj8Qbo7tbPLTtEVR-E=q4w07jCvU3nMroZBKmA@mail.gmail.com>
 <SJ2PR11MB8369E480AEB019041B756254E18AA@SJ2PR11MB8369.namprd11.prod.outlook.com>
From: zhuwei <zhuwei@sangfor.com.cn>
In-Reply-To: <SJ2PR11MB8369E480AEB019041B756254E18AA@SJ2PR11MB8369.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaTEtPVk5MShkdSU4dGhofGlYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKSUpVSElVSU5PVUpPTVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0
	tVSkJLS1kG
X-HM-Tid: 0a96b7c2b77509cekunm148f13876
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NCo6SAw*DDJDAVETDT0MShwi
	PCxPCw5VSlVKTE9NQ0hCTEpPSENMVTMWGhIXVQETDgweEjsIGhUcHRQJVRgUFlUYFUVZV1kSC1lB
	WUpJSlVISVVJTk9VSk9NWVdZCAFZQUlPTUo3Bg++



On 2025/5/9 23:19, Don.Brace@microchip.com wrote:
> 
> ---------- Forwarded message ---------
> From: Zhu Wei <zhuwei@sangfor.com.cn>
> Date: Thu, May 8, 2025 at 7:57 AM
> Subject: [PATCH] scsi: smartpqi: Fix the race condition between pqi_tmf_worker and pqi_sdev_destroy
> To: <don.brace@microchip.com>, <kevin.barnett@microchip.com>
> Cc: <dinghui@sangfor.com.cn>, <zengzhicong@sangfor.com.cn>, <James.Bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>, <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Zhu Wei <zhuwei@sangfor.com.cn>
> 
> 
> There is a race condition between pqi_sdev_destroy and pqi_tmf_worker.
> After pqi_free_device is released, pqi_tmf_worker will still use device.
> 
> Don: Thank-you for your patch, however we recently applied a similar patch to our internal repo.
> Don: But more checking is done for removed devices.
> Don: When this patch has been tested internally, we will post it up for review.
> Don: I will add a Reported-By tag with your name.

Ok, hope smartpqi gets better.

> Don: So Nak.
> 
> 
> 
> kasan report:
> [ 1933.765810] ==================================================================
> [ 1933.771862] scsi 15:0:20:0: Direct-Access     ATA      WDC  WUH722222AL WTS2 PQ: 0 ANSI: 6
> [ 1933.779190] BUG: KASAN: use-after-free in pqi_device_wait_for_pending_io+0x9e/0x600 [smartpqi]
> ......
> --
> 2.43.0
> 

