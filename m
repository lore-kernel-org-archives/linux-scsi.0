Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A014A3D23
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 09:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636062; cv=none; b=bOBsRDUl2+jgDXay/D+xXMrbAbyelHbzMxetlCKK8x2sbJKszX70CLaXU0uxGAkOp9XKVUES4gbs+eswpbM/ZhBEiaaswQ0A/bb3AfGl71G1doyp5UPo7al4jfPekh3sG01ulYaGltWWMkpDaoxyx6EFsSPrRq+wv8Cl6GN510U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636062; c=relaxed/simple;
	bh=U1cN+vcnZbZwUZh4n4qEgLoXALTgY57dyquzSAYidj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDg2+p9sk4g7L3fzSyyJsM+0pD4KS2xM+2CJEXRt2+e5WyQAxXh9bfsetN6dufLA3fE9gE7bhBAAwI4rFI+EonT24H7r7GdupPMv6zj0hn1TwE22z2TTEvoiaiHqlMBZlANWdFAAypSNlD1nqBZzPbwVn696QYr8lKOTE1XkepU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQS6CngM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQS6CngM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C05A1F000FF;
	Thu, 17 Sep 2026 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636060;
	bh=F8V1wzC2CZM3vno4pJY9SkGA3heqNTtGW/lGU5EdVow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AQS6CngM0idhOvNE1oMln0ioeg9PohYFl52Q7hFgqDf55lvc4NHKI8ZkS1pYwKGll
	 /pz4mGAghgL32kC+Kob9aHw30FaGHAtPUM+CZGaqb1vP97F+tOxdvilPKV10uPFuAG
	 DxYnTHdkJzl8WDDcO/QUVDFscw9YZWVybtmgj3j0n9hZhRv8XNyrxiMuYu8EI10Ymr
	 hsERuWLkExooJGBemO+/tiqxQNH3iaXsHKcmlR2tsP3PyqGQL9FHQlBcnUkOqOzBK6
	 wdkdo2Bm+tlG+REr+WYaDfpFmSyQwhASN2q2SJCVZ0fHwKHMUcAT9yZSftzwhhMNna
	 m24j/ANIIbeJA==
Message-ID: <2cce3f47-5564-4080-b948-5c5c525d3d45@kernel.org>
Date: Thu, 17 Sep 2026 16:07:35 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917084553.559765-6-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 15:45, Niklas Cassel wrote:
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
> resp_write_dt0() does, holding the zone metadata write lock across both,
> since the write pointer has to be read and updated atomically with
> respect to other commands.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>   modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
>       zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2 atomic_wr=1
> 
> issuing WRITE ATOMIC (16) with sg_raw. Before this patch, an eight block
> atomic write at the write pointer of an empty sequential write required
> zone completes with GOOD status and leaves the write pointer unchanged,
> and one issued past the write pointer is accepted as well. After it, the
> former advances the write pointer by eight blocks and the latter is
> terminated with ILLEGAL REQUEST / UNALIGNED WRITE COMMAND.
> 
> A two block atomic write at the write pointer, which satisfies
> atomic_wr_gran and atomic_wr_align but is smaller than the 4096 byte
> physical block, is now rejected by the check added in the previous
> patch. An atomic write to a conventional zone is unaffected.
> ---
>  drivers/scsi/scsi_debug.c | 13 +++++++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6043,7 +6043,24 @@
>  		}
>  	}
>  
> +	if (sdebug_dev_is_zoned(devip))
> +		sdeb_meta_write_lock(sip);
> +
> +	ret = check_device_access_params(scp, lba, len, true);
> +	if (ret) {
> +		if (sdebug_dev_is_zoned(devip))
> +			sdeb_meta_write_unlock(sip);
> +		return ret;
> +	}
> +
>  	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +
> +	/* If ZBC zone then bump its write pointer */
> +	if (sdebug_dev_is_zoned(devip)) {
> +		zbc_inc_wp(devip, lba, len);
> +		sdeb_meta_write_unlock(sip);
> +	}

Shouldn't this go after the error checks below?
If the command failed, you do not want to advance the wp...

> +
>  	if (unlikely(ret == -1))
>  		return DID_ERROR << 16;
>  	if (unlikely(ret != len * sdebug_sector_size))


-- 
Damien Le Moal
Western Digital Research
