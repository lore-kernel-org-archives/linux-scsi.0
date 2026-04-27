Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DE23B6BFA;
	Mon, 27 Apr 2026 12:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291965; cv=none; b=jGmIIaZTlp8MkCT5C8dLYP1NeGpyDxVvefjUOwH9ps+aYIxfQ2YTfUWXf0V6bgsu8huF1SorGEuDW5XwApHVFUx1swYEuOt39mxHvyH21qOIXYVwxq8S9AlYnnchYGMIDD8sE8reU0quy7x/pHTenhq72Zfs1iqC+H7ceuWQGVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291965; c=relaxed/simple;
	bh=giHwGTFD6wbmZRTrdyUEVWmsDYWotLmNnR/Uf5m1WPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SWR8eK4turUbKamD3BNQkHcwl6FW/Hfc+6JPC9KVPynziQEYEfE1lT+BU+p5KvvN9GUnesQOwBOfMhYldaIJJHijwDX9YFKFLULy8txRUPghtF0Bgx7xHzh6J3eAwhEUr2BrrQ31kpcPQzllVThQ5HYcBabbdyDFMRBO5JxwPrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=xkMJ2dfw; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="xkMJ2dfw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1777291961;
	bh=giHwGTFD6wbmZRTrdyUEVWmsDYWotLmNnR/Uf5m1WPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=xkMJ2dfwgvqUJ6FdfMRNgrFGImw/JAtEWny/p4MOb7C7WzoWl/DNjhX0f3IhVZ0hS
	 wvvjC6J6uYbmPPavQK20nwc0cc+JcMoIAO/deBCO47p8dxpUXltarNCRt5pZl/oulS
	 7TJovViC/KqZ69795bR/TyEUfKXC8DnPSPWkPJzw=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id ADE46BD366;
	Mon, 27 Apr 2026 12:12:41 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id F1A905FBA6;
	Mon, 27 Apr 2026 13:12:40 +0100 (BST)
Message-ID: <583f5450-38cb-4240-9518-785ba10bf306@philpem.me.uk>
Date: Mon, 27 Apr 2026 13:12:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] scsi: scsi_devinfo: extend BLIST_NO_LUN_1F to
 MATSHITA and NEC PD-1 variants
To: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-8-philpem@philpem.me.uk>
 <c1db6016-9b7d-454b-a4a8-c8f61391c5ae@suse.de>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <c1db6016-9b7d-454b-a4a8-c8f61391c5ae@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/04/2026 12:56, Hannes Reinecke wrote:
> On 4/26/26 21:09, Phil Pemberton wrote:
>> The Panasonic LF-1095/LF-1195 PD/CD combo drive was sold under three
>> OEM identities: COMPAQ "PD-1", MATSHITA "PD-1", and NEC "PD-1 ODX654P".
>> All three are the same drive mechanism with the same firmware family,
>> so they should share the BLIST_NO_LUN_1F quirk that was applied to the
>> COMPAQ variant: PDT 0x1f / PQ 0 INQUIRY responses on non-existent LUNs
>> are treated as "LUN not present" rather than as a phantom sdev.
>>
>> This patch is offered for completeness.  It has not been tested on the
>> MATSHITA or NEC variants -- the author only has access to the COMPAQ
>> unit -- but the drives are functionally identical and the flag is a
>> no-op on devices that do not exhibit the PDT 0x1f response.  Drop or
>> hold this patch if confirmation on real hardware is preferred before
>> extending the quirk.
>>
>> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
>> ---
>>   drivers/scsi/scsi_devinfo.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
>> index bfc2cbd43897..ab1ffa9433b7 100644
>> --- a/drivers/scsi/scsi_devinfo.c
>> +++ b/drivers/scsi/scsi_devinfo.c
>> @@ -201,7 +201,8 @@ static struct {
>>       {"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
>>       {"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
>>       {"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
>> -    {"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>> +    {"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
>> +                   BLIST_NO_LUN_1F},
>>       {"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | 
>> BLIST_INQUIRY_36},
>>       {"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | 
>> BLIST_INQUIRY_36},
>>       {"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
>> @@ -212,7 +213,8 @@ static struct {
>>       {"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
>>       {"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>       {"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>> -    {"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>> +    {"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
>> +                      BLIST_NO_LUN_1F},
>>       {"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
>>       {"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>       {"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> 
> Any specific reason why this patch is not merged with the previous one?
> Otherwise:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Cheers,
> 
> Hannes

Hi Hannes,

The short answer is because I don't have those two drives to test with. 
They're based on the same hardware platform but I'm assuming they have 
the same behaviour.

The idea of the separate patch is that if the lack of testing was an 
issue, it could be separated from the known-working parts in the first 6 
sections.

Thanks,
-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
