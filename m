Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F83BED2D
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 23:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790294004; cv=none; b=Kcpr8xhxZDXA0IIIcydR7frNMHMmozeuKm9cea7aImhPW+sRHaTKROv+tQhG5YhTmrR7XV0kb71fGf/bhTZZu/hxgrbJweC4fI27m9B36OveI3c9l9Nzbc24BEUHsxAtW99O1pJRcDRQlTshLSDfH02e+/6oOcYzGrPWlsCcTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790294004; c=relaxed/simple;
	bh=ScpycZMlXIZiFNeKHxZq1vF26XZiCVrdlURUx5sxg1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jX5EFgQJmzdHL56fyqXD7DZOEENyAzsbBIcNUqyZ7KS4rU8r1E3tkA4xdb5/u85KK2inEFNxoeeUX6OOiPJMkNpZnYinAOhiPxYMlgdkZhPD5MhxLQKE0kX6PrUabOKgflL8+of0iuv8tufzH5InQTfL0rcdbh9tZEi6iDz7iyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgzGym2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgzGym2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD0A1F000FF;
	Thu, 24 Sep 2026 23:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790294002;
	bh=qBwAlHvrFYvuUfB84NpTXgaYAJ5C2bQhX4x+rHaxsEA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FgzGym2ZMS7w2uJBy5Y8jxgQLEtBm9VbFrEto9nTfKtW3DXXnOkyIttIuaWZi3kAY
	 qDqSUNlod3lyMhqJiNoWcHkM/4z/DFLdDIogXe+B8EYigwbCORFyCl23//4sudX2vf
	 rnDvYzPV5cm40DHnjACpfHlDMWnX0niDg4kfLLUbK9q8WtVWQuxAMTMDZHQK64p8id
	 Xmkpgkruf3NlSUwPqwDiioZ64ZcwBCBhWMhL7QKJBzrMcA76kv8FAER7Ts8cFWkYg4
	 KBOcTVfhTiesfVCgxomcKco+NfEp8bto5bRsU3UMRWx4g/kl6QD3Jm6rNANJay941d
	 ld869GmL7Ry1A==
Message-ID: <e543b623-6d31-47b9-a052-22dc00d2db42@kernel.org>
Date: Fri, 25 Sep 2026 08:53:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC
 (16) before writing it
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260924112127.3815255-13-cassel@kernel.org>
 <20260924112127.3815255-22-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260924112127.3815255-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/24/26 20:21, Niklas Cassel wrote:
> A write whose data-out buffer is shorter than its transfer length is
> short. An ordinary write transfers what the buffer holds and reports the
> rest as a residual, but an atomic write cannot be short: SBC-6 r02
> (T10/BSR INCITS 587), 4.28.1, requires each atomic write operation to
> write either all of its data or none of it, and 4.28.2 requires one that
> cannot complete to leave the LBAs that it specifies unaltered.
> 
> resp_atomic_write() does fail a short WRITE ATOMIC (16) with DID_ERROR,
> but only after do_device_access() has returned, and do_device_access()
> copies one logical block at a time, so by then the blocks that the
> buffer did hold have been written. An eight block WRITE ATOMIC (16) with
> a buffer of four fails having overwritten the first four.
> 
> Check the length of the buffer before writing anything, and fail the
> command with the same DID_ERROR as before.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>   modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
>       atomic_wr=1 lbpu=1
> 
> issuing a WRITE ATOMIC (16) of eight blocks through SG_IO with a buffer
> of four blocks of 0xaa. It fails with DID_ERROR before and after this
> patch, but before it the first four blocks read back as 0xaa afterwards,
> and after it all eight read back as they were. A WRITE ATOMIC (16) with
> a full buffer writes all eight blocks, as before.
> 
> New in v6.
> ---
>  drivers/scsi/scsi_debug.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index af1b27b48867..3b112ad58489 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6242,6 +6242,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  		}
>  	}
>  
> +	/* A failed atomic write must not have written any of its data */

At this point, the write was not yet done, right? So this comment seems
incorrect, and does not really match the commit message explanation. What about
simply:

	/* Short atomic writes are not allowed. */

With that fixed,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +	if (scsi_bufflen(scp) < len * sdebug_sector_size)
> +		return DID_ERROR << 16;
> +
>  	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
>  	if (unlikely(ret == -1))
>  		return DID_ERROR << 16;


-- 
Damien Le Moal
Western Digital Research
