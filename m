Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465727702B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 08:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753258163; cv=none; b=mmf5avvB3gfqdbYRTrV8Ch8J8VAf8Vkhb09NMR6lHmmqYQDvfh9VgRDhRQrtFHq/Lmgz/3W5wqgm9la7nK0a3CdNNlEG8Smp2N/xvONpvWFhu5IA1Z4rhReX9i6C+/s3eEzT/H3G1J1xI+mSb0RsBpugRjjhDjDntlkwwW4a5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753258163; c=relaxed/simple;
	bh=Bf+zdMow+rtiL4TSmFslqOgPzPdZhVRq78syu+3irhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d7PHp5RL+EzC26RqKqRPz0EqN/UVvPCYP8NVOSMBcEAbXsJ+gG/T9LawfKuDiz8D/kMPSfUm6LxsMPq+OJ/0fi5QNIFRidu3NZ72Rs1a0YEwXZRdBfRwGnFi5N0gUqebCFOLRw9bwiR+9dw0SMoxWptOhMGXi1Cd0yfl+mlb1lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGnvIXdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGnvIXdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FAAC4CEE7;
	Wed, 23 Jul 2025 08:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753258162;
	bh=Bf+zdMow+rtiL4TSmFslqOgPzPdZhVRq78syu+3irhM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=GGnvIXdzwyKI8VealT778QyJw5cy0IQruCccgIUMVxOcap07MMJF8GXD+0ssMUjdG
	 /w0adDCuSFpPeEYIf90y+2PaejKNxdkJRthMULmCAgIxBWE4ijTEBCnYyf3nu+GbLF
	 NLqCf9Jq/SMlvsIw9gjNCWLRIhBOg7tqOCZIyOH9CnGShw5jugmgEcLLP3rCoIxPHI
	 M5q8mXiXmE6Mpei92KNVln2ibzICDGxc1bs7faSvn6P8eEtI6X8LZkah2DA8l0OioC
	 fdgc1xQ2jt8x0AJuRPIPZCsc7LZr9ibIhY3rnep6yBur4B2vzOOeSKmiWmw7MjGgv2
	 KXBfwWoMP6pbw==
Message-ID: <c186fd4f-0310-4dcc-8d88-24d4778a416e@kernel.org>
Date: Wed, 23 Jul 2025 17:06:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: libsas: Move declarations of internal functions
 to sas_internal.h
To: John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-4-dlemoal@kernel.org>
 <455b2819-d28e-4692-846c-6f078ab0d0cf@oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <455b2819-d28e-4692-846c-6f078ab0d0cf@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/23/25 4:52 PM, John Garry wrote:
> On 23/07/2025 06:39, Damien Le Moal wrote:
>> void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
>> +void sas_ata_end_eh(struct ata_port *ap);
>> +
>>   static inline void sas_ata_wait_eh(struct domain_device *dev)
>>   {
>>       if (dev_is_sata(dev))
>>           ata_port_wait_eh(dev->sata_dev.ap);
>>   }
> 
> this function stands out a bit now. Why make it inline?

Because it is only 2 lines... But sure, the compiler will probably inline it
anyway, so I can keep it as it was.

> 
>> +
>> +void sas_probe_sata(struct asd_sas_port *port);
> 
> Apart from comment, above, which is really a comment on an earlier patch:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 


-- 
Damien Le Moal
Western Digital Research
