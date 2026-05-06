Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1571149C6F;
	Wed,  6 May 2026 01:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778029862; cv=none; b=SbuyvHfBs3K+D66ctqR5XuC3lzPHrTyGr3UIFOteArTq+UGZbWceRe0ooy12XopuN8Yg/CQRVTlx0ruIlCycJt+ObwiTzokbJH1FwnTki7AUT9zLF7Ba6Z2W/00/ZAXw//o5wx0XBbqYfuulJPOVyY9PkFqaz41sf7wuYL8sfFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778029862; c=relaxed/simple;
	bh=RkLhcLrXVauydYrKsrABqVXoD9Sb2pNbxPAsYYGUFfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i898LzW9DjzydupzW/YPhEEU8w27jEtGZ4qZ/O2K6Okc+VziWO0zCWP0BsjpLlAQyq+R/KR5ZtTU8bjLBrksYM43d15RIBXs2KWLZ29MyGJr2I++IfF/+hug87sNelOdorbgeUISX+Ig9flwIhXJ4kkc4k9NN2i05hyoQXA520o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=XVV73trR; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="XVV73trR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1778028756;
	bh=RkLhcLrXVauydYrKsrABqVXoD9Sb2pNbxPAsYYGUFfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XVV73trRzWdgCF3a6jOKHNi9YwD8nQCerYqJ68Qvi8ECP+7lQTiHM9oThJtF0X+LZ
	 hey4+u8ax+HJjuPZOhF9gAawTgJaraxqOyqmFBLQ8Gu1bA3CH+GJJeMwghTYUwzIwD
	 8PbiQMAdRD/NEshJAtEGX556Ua8Qr7wA17vCXa9A=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 3A7EFBE516;
	Wed,  6 May 2026 00:52:36 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id AB6585F938;
	Wed,  6 May 2026 01:52:35 +0100 (BST)
Message-ID: <566ea0c5-3d8b-4ce4-8d42-e97ecabe5f9d@philpem.me.uk>
Date: Wed, 6 May 2026 01:52:35 +0100
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

Only that these are optional to the feature work and untested as I don't 
have hardware. I believe these drives use the same PD-1 mechanism and 
firmware so should behave the same, but I can't prove it.

The intent was to allow the 1-6 set to be merged (as these are tested) 
without 7/7 (which is not) to minimise the risk of regressions.

Thanks,
-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
