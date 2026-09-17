Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467E4DD3A0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650054; cv=none; b=IFx1gjhEeoB3oC7QNZEhQCRiUQheGLsQucaPq1BJI2aDJBIJ80pdWO1ScfNJuPVveK5JR6Iyyd0ecGZ0bgqCcIZPf33ssgLwNxopBWGDGdNBeBrjfqpUmFniKogzvG+IG441O2TTV/5cyZyV7d5KxiTkVoqRIvL9uyRLz0LFP+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650054; c=relaxed/simple;
	bh=buhUAPIG9gloAod5G2JL/MqkpFFPllsbn2Aa/XQPsIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kf7lCwki8S8nsI0aA0TIQuyAJWUZmVNmtpQJx8P8nurYbasqbuM89SZL7Y+8cZX+v1ACV4jnveyqixAuqHPh9uS8BeCBktlqKwe+Td52AYEFml6/Qx5q5ZFw7/XERpuU24b54cx5+q8Wo66lSn2QWQwQaGuzbAaP64fuhhmKd2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AcgVOeGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AcgVOeGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E8A1F000FF;
	Thu, 17 Sep 2026 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650031;
	bh=UbFx5IQ1WVkOmb+NX3KduZUjj9bfvfLUrK1qx5tPxEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AcgVOeGDKicl3brZ+Elj1CXMCiXi4HD5DC3oPz3VxX/WLVSqZrUjYgEmD4AEpGahQ
	 oTzx03AWqqGzwlYISHnR9AQWVIFuRVU2Tj+sQbSvxtlV7fsSqBNgPgTMiqO8euO3zJ
	 eunSWDsfO3K1PzAIDJki2fBA+nqn4xuDQg0L8N/z7gSoKfmMaQW/gqpXci15oKWK8/
	 VpQXPLKFi04zLoelgSEJlf2ufPX9UEg0IejOemrU9xhwJZGcaA+7DrtzlSEwPiziJR
	 528LvKOmJo9Z0sxc4qL2KrUCRXkv4y0VufchM2fpJLtaZTqkOLeRvAdE+5Qbc0ZB5r
	 GK8j3yarsN+rg==
Message-ID: <604fc11e-d1a1-4ebf-acf1-9017869bd8dc@kernel.org>
Date: Thu, 17 Sep 2026 20:00:28 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] scsi: scsi_debug: Do not advance the write pointer
 of a failed write
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917110316.1104863-6-cassel@kernel.org>
 <20260917110316.1104863-7-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917110316.1104863-7-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 18:03, Niklas Cassel wrote:
> resp_write_dt0() and resp_write_scat() advance the write pointer of a
> sequential write required zone by the transfer length of the command
> before looking at what do_device_access() returned. It returns -1 when
> the data direction of the command does not match the operation, and a
> short byte count when the data-out buffer is smaller than the transfer
> length, both of which an initiator can produce with SG_IO.
> 
> The zone state then describes more data than is on the medium, and a
> write at the position where the data really ends is terminated with
> UNALIGNED WRITE COMMAND, because the write pointer has moved beyond it.
> The zone has to be reset before it can be written to again.
> 
> Leave the write pointer alone unless all of the data was written. A host
> that retries the command writes at the write pointer, where whatever the
> failed command did write begins, so the retry overwrites it.
> 
> Advancing over the data that was written instead would be no better,
> because do_device_access() copies one logical block at a time and stops
> at the first short copy, so it can report a byte count that is not a
> multiple of the physical block size. That would leave the write pointer
> in the middle of a physical block, and ZBC requires a write to a
> sequential write required zone to end on a physical block boundary, so
> no write can leave a real device with such a write pointer.
> 
> resp_write_same() does not need the same treatment, as it writes with
> memmove() and cannot fail part way through.
> 
> Assisted-by: LLM
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>   modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
>       zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2
> 
> issuing WRITE(16) with sg_raw so that the data-out buffer is shorter
> than the transfer length and do_device_access() returns a short count.
> Sixteen logical blocks with a buffer of twelve, and eight blocks with a
> buffer of one, both leave the write pointer where it was, and the full
> sixteen block write then succeeds from there. Before this patch both
> advanced the write pointer by the full transfer length, and a write at
> the end of the data that had actually been written was then terminated
> with UNALIGNED WRITE COMMAND.
> ---
>  drivers/scsi/scsi_debug.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6941809dfdb7..3ce2dbdff177 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5150,8 +5150,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  	if (unlikely(scsi_debug_lbp()))
>  		map_region(sip, lba, num);
>  
> -	/* If ZBC zone then bump its write pointer */
> -	if (sdebug_dev_is_zoned(devip))
> +	/* If ZBC zone then bump its write pointer, if all data was written */
> +	if (sdebug_dev_is_zoned(devip) && ret == num * sdebug_sector_size)
>  		zbc_inc_wp(devip, lba, num);
>  	if (meta_data_locked)
>  		sdeb_meta_write_unlock(sip);
> @@ -5314,8 +5314,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  		 * writes behaviour as possible.
>  		 */
>  		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
> -		/* If ZBC zone then bump its write pointer */
> -		if (sdebug_dev_is_zoned(devip))
> +		/* If ZBC zone then bump its write pointer, if all data was written */
> +		if (sdebug_dev_is_zoned(devip) && ret == num_by)
>  			zbc_inc_wp(devip, lba, num);

This is *not* correct. As you note in the commit message, the buffer may be
smaller than the command length, in which case, do_device_access() returns the
smaller value, doing a partial write. And that is a thing in general with SCSI.
A command may not be processed entirely and completed with a non-zero residual.
For SMR, that translates into the WP advancing by the amount of data written, so
less than the command size. Such partial write with the WP being advanced may
also happen if a bad sector is encountered along the way and the drive fails to
remap it. An error is returned in such case, but the WP may still have advanced.
So here, the correct call should be:

		if (sdebug_dev_is_zoned(devip) && ret)
  			zbc_inc_wp(devip, lba, ret);

(the unit is wrong here since ret is in bytes, but you get the idea)

>  		if (unlikely(scsi_debug_lbp()))
>  			map_region(sip, lba, num);

And I am not sure about this... For now, I would leave it alone.


-- 
Damien Le Moal
Western Digital Research
