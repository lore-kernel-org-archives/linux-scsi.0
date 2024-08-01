Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE6185628;
	Thu,  1 Aug 2024 09:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504471; cv=none; b=JjJUSuvQShEJKA/MDeZFV+pjDdQUdVCs0zpl1qIww22u7Qk1jyGwLJZz7150VbDeuXqCDuzIdjB37SLvaF3AKZYRZq/sq1iIqmhbNiHqlmz4vxwPrURXP50F6n+ksa8HVw0i6cZLYdG0lnxDrP1wlxzfiY36S4GR0vLdHGPvhfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504471; c=relaxed/simple;
	bh=sa2Jp3lEd089t3MUpllE1ycq+eGZx/2kOuXtfmj9yFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s9UZ91eXRdsrT5mCmhYIJMTNlErGnbOVk744jVvk1H9tGpKiiWTeApO6tXJGUWTKXn15XOBxAv56kaI0Nc37SwdTVowe9bemF3XYOGJqjYCJgW28bRKtFbHWJrMlKdS/9uhalK5yudhyVdJ9LxFH1LDGYGyn9zC3C+j2VENYz2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6/6t1Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6/6t1Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917BDC4AF15;
	Thu,  1 Aug 2024 09:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504471;
	bh=sa2Jp3lEd089t3MUpllE1ycq+eGZx/2kOuXtfmj9yFI=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=d6/6t1BbPLH1M1pdX8uKBVAL6eDXTKbg+X8fDV1MZz26zCIpA3/fK5ZisnDcTZuuS
	 Qw6pxZe6nZDU1TP8G7ePuWabjDJv9b5aexxScWre+mmt5o4Bs2LlU8EvS/KAlUWsaT
	 qoCtxNIW3W1SmyS5aHete5v1HG+ofR+m/djgpSmVQe3f2IyBzt+2mR9Vr6vqtPJwQf
	 orleCC6Ewb3gH/JpsXEHd3AdnXraIRWsdqfjFwgQkQiKlgHEKr8r55gAM21gfyByXY
	 d8yMM40rCn2lYonqt6GzU2e9FJ4zBdSBSPyoyamNzSlzRG8TKJshcVfv3GwS8hpOAq
	 ZB92ZY66AmvTg==
Message-ID: <cd2fc5ab-7f0b-43ad-979b-575dcade429f@kernel.org>
Date: Thu, 1 Aug 2024 18:27:49 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ata: libata: Remove ata_noop_qc_prep()
To: John Garry <john.g.garry@oracle.com>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20240801090151.1249985-1-dlemoal@kernel.org>
 <46ab2af0-fccc-4836-a246-b50a88025c19@oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <46ab2af0-fccc-4836-a246-b50a88025c19@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/1/24 6:11 PM, John Garry wrote:
> On 01/08/2024 10:01, Damien Le Moal wrote:
>> The function ata_noop_qc_prep(), as its name implies, does nothing and
>> simply returns AC_ERR_OK. For drivers that do not need any special
>> preparations of queued commands, we can avoid having to define struct
>> ata_port qc_prep operation by simply testing if that operation is
>> defined or not in ata_qc_issue(). Make this change and remove
>> ata_noop_qc_prep().
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>> ---
>>   drivers/ata/libata-core.c     | 18 +++++++-----------
>>   drivers/ata/libata-sff.c      |  1 -
>>   drivers/ata/pata_ep93xx.c     |  2 --
>>   drivers/ata/pata_icside.c     |  2 --
>>   drivers/ata/pata_mpc52xx.c    |  1 -
>>   drivers/ata/pata_octeon_cf.c  |  1 -
>>   drivers/scsi/libsas/sas_ata.c |  1 -
>>   include/linux/libata.h        |  1 -
>>   8 files changed, 7 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index fc9fcfda42b8..b4fdb78579c8 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -4696,12 +4696,6 @@ int ata_std_qc_defer(struct ata_queued_cmd *qc)
>>   }
>>   EXPORT_SYMBOL_GPL(ata_std_qc_defer);
>>   -enum ata_completion_errors ata_noop_qc_prep(struct ata_queued_cmd *qc)
>> -{
>> -    return AC_ERR_OK;
>> -}
>> -EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
>> -
>>   /**
>>    *    ata_sg_init - Associate command with scatter-gather table.
>>    *    @qc: Command to be associated
>> @@ -5088,10 +5082,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>>           return;
>>       }
>>   -    trace_ata_qc_prep(qc);
> 
> I assume qc->err_mask must be zero here.

Yes it is, since this is a new command.

> 
>> -    qc->err_mask |= ap->ops->qc_prep(qc);
>> -    if (unlikely(qc->err_mask))
>> -        goto err;
>> +    if (ap->ops->qc_prep) {
>> +        trace_ata_qc_prep(qc);
> 

-- 
Damien Le Moal
Western Digital Research

