Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C0B511E92
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650706; cv=none; b=KCmGwNnSRshYABFLHLJhiIX3IuuwRNX0NRYJ1/XO7nHh2VUqucuI9m5kEbQmXOuG/+RwG0HTBw1Lv2ij3eqHekc4SBYqytizqrCPV9+bgLB3XmVCo2P2vcQIFZLdva+NXBFrmZplg3yGyReSKTqGMHuI3lrifobIx7lMFPqC8yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650706; c=relaxed/simple;
	bh=FFvLjpTMRUDJorNq6uBrh7GEEjl5OkgU9jtfEYYn300=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qu85Tu2aG2jSLCU4B+OH5JsCGp5VOKjXT8EFDwBcStACET5uwEtfKJR8Agk+rEfRW58eXbvObIugjRPbhdNlIgRBWwepi+gbKbvza83cCEmw2F9CudZ5JeXAp3D9JDb221hhJsvP1bgKfYdfhfBOayxC3VlL+PpB1rbfCAq55+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFOuIBUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFOuIBUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBF51F000FF;
	Thu, 17 Sep 2026 13:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650703;
	bh=o+LkK8neWBW/WzsP4jfaDbJsHrYeQKIgvwQkc9SQRd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CFOuIBUug7tSmsgTqE56I4AnSVirISRJapry494J+6FoXTdXKfX5P4pJgfEoOnoRy
	 Qpw+XGrtjMFYAkGjfflQJvF6CNcEVTRuHZCK6ENj+m/k6NbktCUdOYBAliGNvBzuZ3
	 /NR7haBJMt916r1pKLqMoLSRxiJl6nv2L5zDk3u6ERJ+MQy38oMSbX1qnWyh5uwkKB
	 JcjpIWh1N6MIAQ5P5kcLgrPTLZptbA+bSPjZqL1s37LbFhjhasMTLW6kt+rRrqWFj2
	 1m0n5ebYaUmYiqIcFYgNSJ2AuyvHmyVyc0xemkqcJ42slpS96qYJ0sLg5PjGgA3hH6
	 wgj84MCXwokXg==
Message-ID: <72659c27-3742-4760-8a5f-46d65ccf4012@kernel.org>
Date: Thu, 17 Sep 2026 20:11:39 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: scsi_debug: Do not write a partial physical
 block
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-10-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917125445.1376493-10-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 19:54, Niklas Cassel wrote:
> do_device_access() copies one logical block at a time and stops at the
> first short copy, so when the data-out buffer is smaller than the
> transfer length of the command it can write part of a physical block.
> An initiator can arrange that with SG_IO.
> 
> A device writes whole physical blocks, and ZBC-3 r06 (T10/BSR INCITS
> 579), 4.5.3.3.2, requires a write to a sequential write required zone to
> end on a physical block boundary, so a partly written physical block is
> not a state that a device can be left in.

Physical block aligned writes are mandated only with ZBC for wries to sequential
zones. Unaligned writes to conventional zones are accepted, like they are with
regular drives (though not recommended due to potential performance issues with
read-modify-write cycles).

> 
> Stop at the last whole physical block that the buffer holds. The bytes
> that are left over are not written, and are reported to the initiator as
> part of the residual.
> 
> With the default physblk_exp=0 the physical block size equals the
> logical block size and this changes nothing. Nothing changes either when
> the buffer holds all of the data that the command asks for, so a command
> that transfers fewer logical blocks than a physical block, which is
> legal outside a sequential write required zone, is unaffected.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>  drivers/scsi/scsi_debug.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 641dd6f93791..8ed7d5cd0ae0 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4290,6 +4290,19 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
>  
>  	fsp = sip->storep;
>  
> +	/*
> +	 * A data-out buffer that does not hold all of the data that the
> +	 * command asks for is written up to the last whole physical block
> +	 * that it does hold, so that a partial physical block is never
> +	 * written. The bytes that are left over are reported as a residual.
> +	 */
> +	if (do_write) {
> +		u32 avail = (sdb->length - sg_skip) / sdebug_sector_size;
> +
> +		if (avail < num)
> +			num = round_down(avail, 1U << sdebug_physblk_exp);

Nope, that is not correct. physical sector unaligned writes are OK with regular
disks. They are not for ZBC, but we should check that in
check_zbc_access_params() I think.

> +	}
> +
>  	block = do_div(lba, sdebug_store_sectors);
>  
>  	/* Only allow 1x atomic write or multiple non-atomic writes at any given time */


-- 
Damien Le Moal
Western Digital Research
