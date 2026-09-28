Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD5C43CE71
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 08:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583517; cv=none; b=LO4rXsJ+1czjaE5nFnK3DgU3wTVffvHiQ2ykWqm/D/hsTQ95ewYuSa8Gx2gToRp5gUDqCylo0YU/X4gwUH4GEIQHpu/OZ5cAziCSvMgdUIkSKfyN4LK7NGIJcE7CV1pddK5XIfWYju2tTTKQNwyi8G42z38+WwMPncmjfUNJzp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583517; c=relaxed/simple;
	bh=yvu/PYMakQ8i45nw68SaaNROhuF84DuQTro/1a5kkVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1k/R+FrYslmzTk6NyBI9i3hUOm69VG/LsQc3+plUYtD7vwy1CsVG/9WSC/HtdjfJo8sbxiSuncLhMAmrQr8GIN6aXs4W23A+PCSCEaosgAcPyTY/tmRaXE+vm5Kjs/bAHdXYDnBkYn9biMF/A41qp5BA1IPLEjw0Ry0xpwpmvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caJOZCfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caJOZCfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D187A1F000FF;
	Mon, 28 Sep 2026 08:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790583515;
	bh=S0gK6YWROZvdMywu2GZjyr6UVy0tUpUYwPRoBJ05DIE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=caJOZCfT6nt5Qkcbgs4/s5KGtXY7JBRqFqRbYoFGfe1q6rhh61UDep1qu38sMKo86
	 P+EXT21bwQIVD/SZui2514KNoMWuUWiRYZJ674e7gWS2R210VqGJC7q1zUAeg1tYke
	 UnVs2yo5UZ5ev2YfSLnaO+HPLO1w43v2zkjj0kGov7NzBG0JTRrSUHCRdbWHKFwvRt
	 eQqlPdpyE9hfJEq7fkTSGieIWySPagqwnt5sUsYNEwf7ka4ORv4B1jypDBXGyCs4oP
	 sAMWruiMOaiJ0uWadkOvbJ1mxwpaHe2SCkJ6FvWzEyQ/0tIqOXfPcHaj+rnZnLIYm7
	 diIwHaSVjifJQ==
Message-ID: <282c5adb-529b-4e02-b741-15082cc8a82b@kernel.org>
Date: Mon, 28 Sep 2026 10:18:33 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/12] scsi: scsi_debug: Report the residual of a
 write
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260928072102.725566-14-cassel@kernel.org>
 <20260928072102.725566-20-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260928072102.725566-20-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/28 9:21, Niklas Cassel wrote:
> Documentation/scsi/scsi_mid_low_api.rst defines the residual as the
> length of the data buffer less the number of bytes actually transferred,
> so a write whose data buffer is larger than its transfer length leaves
> one. resp_read_dt0() and resp_write_tape() report it, but the write
> paths for a disk do not, so such a write completes with GOOD status and
> a residual of zero while a READ of the same length into the same buffer
> reports it correctly.
> 
> Report it in resp_write_dt0(), resp_write_scat() and resp_atomic_write().
> 
> resp_write_scat() differs twice over. Its data-out buffer also holds the
> parameter list header and the LBA range descriptors, so what the command
> consumed is sg_off rather than the bytes that the last range
> transferred; and sg_off counts what was asked for rather than what was
> transferred, so it can exceed the buffer and needs a guard. A command
> with no LBA range descriptors or a buffer transfer length of zero
> transfers nothing, so the whole buffer is residual. An error, real or
> injected, can end the command after some ranges have been written, so
> the residual is reported on every exit once the parameter list has been
> fetched.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>   modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
>       zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2
> 
> An eight logical block WRITE(16) with a 5000 byte buffer reports
> resid=904, having transferred 4096. A READ(16) of the same length into
> the same buffer reported that before this patch and the WRITE reported
> 0. A buffer of exactly 4096 bytes reports 0, as does a 512 byte buffer,
> which is consumed in its entirety. WRITE ATOMIC (16) behaves like the
> WRITE, on a device that is not zoned.
> 
> WRITE SCATTERED (16) with one LBA range descriptor of eight blocks and a
> 5632 byte buffer reports resid=1024, having consumed 512 bytes of
> parameter list and 4096 bytes of data. The same command with a 1024 byte
> buffer completes and reports resid=0: sg_off reaches 4608, past the end
> of the buffer, and without the guard the residual would have been
> reported as 4294963712.
> 
> Changes since v9: the commit message cites the definition of the
> residual in Documentation/scsi/scsi_mid_low_api.rst.
> ---
>  drivers/scsi/scsi_debug.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 8f9d54269dce..691a5ad56161 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5162,6 +5162,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
>  			    my_name, num * sdebug_sector_size, ret);
>  
> +	scsi_set_resid(scp, scsi_bufflen(scp) - ret);

May be do this under a if:

	if (ret < scsi_bufflen(scp))
		scsi_set_resid(scp, scsi_bufflen(scp) - ret);

> @@ -6208,6 +6221,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  		return DID_ERROR << 16;
>  	if (unlikely(ret != len * sdebug_sector_size))
>  		return DID_ERROR << 16;
> +
> +	scsi_set_resid(scp, scsi_bufflen(scp) - ret);

And here too.

>  	return 0;
>  }

With that,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
