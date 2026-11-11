Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387882;
	b=N7HxAIi5YbB3rqBK/UYhxyesHfqmAn45AQLs7W1pBV0njmRuH5ZOZPPEesxNg7pBudRD
	 GtZf7ysB6J96rUxtqX7f8t5mZm/S1KXlc1Vi+a3e6q53HKsCByt21btPLMhhHYiYF9/6Y
	 5GjwOwSxzq5bFRuwBdSgaYq40HSs2Ri4bYg7kQ17iK5UOEeEtc84yNa486/Z1imo/ePc6
	 FOd6EXpNIXGlYUWTdM7C50vBHbUf/HANcUEZbuPOuTelQG9FcwFU+aWpVguMxodaVMYl+
	 Fhy6W0gnrfg5Oshrs8My2h4MpeHb3DsQtJbI5eqIJp46UWRxhgpSo8Sd8duUetb/OKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387882;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=DV1OgHHTBAF1XctG06F7SeDucSGx6hal8QEtfbslYV8=;
	b=1SPlzLZiTHYTSV5TN0LaMolU+O9wYSMH0157C+Wp/qIeEaGJ8cIDxrmICVQHamfgr4gh
	 r3J2ump7lbxjBIPc4OX/6kJZsJPYPf6x5yvmJEbvQC4DyFbXZe9g+GnmQ7BObrMrYEPSG
	 GVOscYokJEj856MJD9OEfhnt9UmIxCT4iAx+rt9a4WE8Z0IcTbROyc+ka9rcqWSUyrFM+
	 JJKYwYdygmYq+qEtN8tN50+MKIukqgSPTAqMpY/vpU/8qwRa05rV0kFYbSSYjR2H1Rmzm
	 6NQIW46goaDqx4+ePRBFJHyprlbbFUEPU2QR3Pxq5BGnAUCdD6MXbvQsb7XRdRLqIgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y9Mco97l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB0B606A33F;
	Wed, 11 Nov 2026 09:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y9Mco97l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857961F00A0A;
	Wed, 11 Nov 2026 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794387882;
	bh=DV1OgHHTBAF1XctG06F7SeDucSGx6hal8QEtfbslYV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y9Mco97l5r6HnLH80/GNgE1rsFu6Fc5lbV15PBYbIjMxkDAEHkVDeKsQrrcjw2Zor
	 TSETIfBeNGGIdTWSVAVJNFEFH0h/4oViwcWg3w63EOy9rIAnt1YFkzgO2k5Ss5Dm7b
	 Kf3Ul/4tvynDJ7P3DbUAeSbY/UFDURMaNWC97bucH/RvdOEtZCGDqkWNeHHifIaido
	 lkY7DBwfw84CoWysrSNYotCDgtZnbwKvIOurTBSycoPfjf61a1owoxLk1huzYJZdlK
	 yUGEi1CT/9WJHUfWJX4nHH8unsQonqFXmgdQuT0FZZJNjjf8MpT8D50SXYhgnYrJza
	 RLCinMABTWLZA==
Message-ID: <23a6d8be-d4af-4cf9-bf48-8ab7272abc1e@kernel.org>
Date: Wed, 11 Nov 2026 18:04:40 +0900
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: scsi_debug: wrap around the store when zeroing
 a reset zone
To: Tal Zussman <tz2294@columbia.edu>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
 <20261110-scsi-debug-zone-reset-v1-1-28cb9184b5ea@columbia.edu>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261110-scsi-debug-zone-reset-v1-1-28cb9184b5ea@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/11/11 6:23, Tal Zussman wrote:
> zbc_rwp_zone() zeroes the blocks of a zone that is reset, using the
> start of the zone as an offset into the store. With virtual_gb set, the
> device and its zones can extend past the end of the store, which is
> only dev_size_mb in size. Writes wrap around in do_device_access(), but
> the memset() doesn't, so resetting a zone that has been written to can
> write past the end of the store.
> 
> On a device whose fifth zone starts exactly at the end of the store,
> write to that zone and reset it:
> 
>   # modprobe scsi_debug zbc=managed sector_size=4096 dev_size_mb=16 \
>         virtual_gb=1 zone_size_mb=4
>   # dd if=/dev/urandom of=/dev/sda bs=1M count=1 seek=16 oflag=direct
>   # blkzone reset -o 32768 -c 1 /dev/sda
> 
> The memset() starts at the first byte past the store, in the guard page
> after the vmalloc'ed area, for the 1 MiB that was written:
> 
> BUG: unable to handle page fault for address: ffffc90002c00000
> Oops: Oops: 0002 [#1] SMP KASAN NOPTI
> RIP: 0010:memset_orig+0x33/0xb0
> RDX: 0000000000100000 RSI: 0000000000000000 RDI: ffffc90002c00000
> Call Trace:
>  zbc_rwp_zone+0x1a7/0x2a0 [scsi_debug]
>  resp_rwp_zone+0x19c/0x450 [scsi_debug]
>  schedule_resp+0x2dd/0xbc0 [scsi_debug]
>  scsi_debug_queuecommand+0x1286/0x2950 [scsi_debug]
>  scsi_queue_rq+0x1d74/0x3200
>  blk_mq_dispatch_rq_list+0x3ad/0x23c0
> 
> The command never completes, so the reset returns EIO to userspace and
> the device is unusable afterwards.
> 
> Zero the blocks in a helper that wraps around at the end of the store,
> and that stops after one pass over it for a zone that is larger than
> the store.
> 
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  drivers/scsi/scsi_debug.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a922c8318a2f..1c27ea0f9b69 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6612,6 +6612,29 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
>  	return res;
>  }
>  
> +/*
> + * Zero the blocks of a zone that is being reset. The store can be smaller
> + * than the device, so wrap around at its end like do_device_access() does.
> + */
> +static void zbc_zero_blocks(struct sdeb_store_info *sip, sector_t lba,
> +			    sector_t num)
> +{
> +	/* One pass over the store zeroes all of it */
> +	num = min_t(sector_t, num, sdebug_store_sectors);

Why do you need to do this in a loop?
You can certainly calculate the total number of blocks that need zeroing and do
a single memset, no? What am I missing here?
> +
> +	while (num) {
> +		sector_t block = lba;
> +		u32 n;
> +
> +		block = sector_div(block, sdebug_store_sectors);
> +		n = min_t(sector_t, num, sdebug_store_sectors - block);
> +		memset(sip->storep + block * sdebug_sector_size, 0,
> +		       (size_t)n * sdebug_sector_size);
> +		lba += n;
> +		num -= n;
> +	}
> +}
> +
>  static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>  			 struct sdeb_zone_state *zsp)
>  {
> @@ -6629,8 +6652,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>  		devip->nr_closed--;
>  
>  	if (zsp->z_wp > zsp->z_start)
> -		memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
> -		       (zsp->z_wp - zsp->z_start) * sdebug_sector_size);
> +		zbc_zero_blocks(sip, zsp->z_start, zsp->z_wp - zsp->z_start);
>  
>  	zsp->z_non_seq_resource = false;
>  	zsp->z_wp = zsp->z_start;
> 


-- 
Damien Le Moal
Western Digital Research
