Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A74511E89
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650914; cv=none; b=cHKuIEMlMO+ndI8hrhpwdTtKBjkmBefGtBHu7BpKym8LJdSES4Mul8aSso5sRGPTePAxgkZu5ELGqsQ1VKndAkKw2vAbW7pcVpV3T2/pjIJYdi230vtnBwmukCrA1X4ngxxteDpdYSaTZvJWIJ6Lfmb3paWQz2Is3mjGi530icg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650914; c=relaxed/simple;
	bh=tkM+pE+4mgnBoIb28fM8Qq6oHN40T/L1P5DOBbSAOMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7OUThRoZq8WxRCwJnWmg4umLUEmnSmqki8LdxY2RzhEXxzJ6Bg0r3iW4ntBFfNBVUaUpPLfJO3m3p/cxkkTbEthR6Ro6sWgR4BvhDGx2D+UNJXGuorQZ58rVn1j4QTvtSBtIdxeWiwUIeKRNWSmp9XqSuor3sV7GLXzeZ6o5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeRLP89z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeRLP89z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05AB1F000FF;
	Thu, 17 Sep 2026 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650908;
	bh=XLwA5QE7uErNvhZ6MbOrvDWKS99lJhTnJPSgKjPJPKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OeRLP89zcUs4eESeqXh4xuZ4mZ3IiYrFcIkCovf8wZcnCgDe9E4WrsbCorN4jE/jm
	 ph8fOfNQVxJHq0Uya/xp0bkxvMU/WoTh5WZKkrclyGkByOnbSxcZO8KnccdQrkaCjh
	 thI5Y4h9+VtG3caBNGmt0yV4fHYN32wmeGJxEsqKnPdamgCZ8TkfXOPnHxSrbC1r0Y
	 Aw5GVyidfdPb/wraoMFHkDgInilakpZ898KjoKEVlh/euR3eanq7M281Qq2LQKbuNM
	 3ay4/+/dBBlYRnSbtCLa+bwR30pWDEQ5Ga7FdpE7TcvkWqxAwHL4EGm6cbtrgd28gK
	 n9PwC7cP0D/Rw==
Message-ID: <5cd95afa-b9d6-4993-a221-1560df8978dc@kernel.org>
Date: Thu, 17 Sep 2026 20:15:05 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-14-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917125445.1376493-14-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 19:54, Niklas Cassel wrote:
> WRITE ATOMIC (16) is a write command, so on a zoned device it is subject
> to the access requirements of the zone that it addresses, and it advances
> the write pointer of a sequential write required zone. See ZBC-3 r06
> (T10/BSR INCITS 579), 4.5.3.3.2 Write access pattern requirements for
> sequential write required zones.
> 
> resp_atomic_write() calls do_device_access() directly, without calling
> check_device_access_params() first and without advancing the write
> pointer afterwards. It is the only command that writes user data which
> does not; WRITE, WRITE SCATTERED and WRITE SAME all go through
> check_device_access_params(), which validates zone access for a zoned
> device.
> 
> As a consequence, with zbc=managed atomic_wr=1, a WRITE ATOMIC (16) can
> write anywhere within a sequential write required zone regardless of its
> write pointer and zone condition, into a gap zone, or across a zone
> boundary, and none of it is reflected in the zone state. The write
> pointer is left where it was, so a subsequent REPORT ZONES does not
> describe the data on the medium, and the next write at that write
> pointer overwrites data that was written without error.
> 
> Validate the access and advance the write pointer the way
> resp_write_dt0() does. The zone metadata write lock is already taken
> across the access for the provisioning map; take it for a zoned device
> too, as the write pointer has to be read and updated atomically with
> respect to other commands. Unlike an ordinary write, the write pointer
> is advanced only when all of the data was written, as an atomic write
> either completes or has no effect.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

See my comment on v2.

> ---
>  drivers/scsi/scsi_debug.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 33f2df26e5af..b57d25d7214c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6229,15 +6229,29 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  		}
>  	}
>  
> -	if (scsi_debug_lbp()) {
> +	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
>  		sdeb_meta_write_lock(sip);
>  		meta_data_locked = true;
>  	}
>  
> +	ret = check_device_access_params(scp, lba, len, true);
> +	if (ret) {
> +		if (meta_data_locked)
> +			sdeb_meta_write_unlock(sip);
> +		return ret;
> +	}
> +
>  	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
>  	if (unlikely(scsi_debug_lbp()))
>  		map_region(sip, lba, len);
>  
> +	/*
> +	 * If ZBC zone then bump its write pointer, but only if all of the data
> +	 * was written: an atomic write either completes or has no effect.
> +	 */
> +	if (sdebug_dev_is_zoned(devip) && ret == len * sdebug_sector_size)
> +		zbc_inc_wp(devip, lba, len);
> +
>  	if (meta_data_locked)
>  		sdeb_meta_write_unlock(sip);
>  


-- 
Damien Le Moal
Western Digital Research
