Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B327B369D6F
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005850; cv=none; b=LiZecZWSywvbPyP63bQycOH8/f8JExfvMeepwB0nITtyCLGfbt9Rfreq77LVcGv6jd5p3qpVzZg1Kzx0KUQUykN7tlSq7+8f2FIR17BZtNsEOl6E2hBlleKuwrcI0F91pC1Zafj7UN3X/MvbMX3XZUJulVQkHbc7uY/6/DAsSxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005850; c=relaxed/simple;
	bh=lCEWlk6vP9nwICOOWRNGYwdO5Cs+d8wClyGbrj/nTWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1BpL854E8W0i4T5BnmI2vgDp9RxXMTkUG38h0XcqqFnkZpAftsFW6YKLLxVoQ5FMAvk0ZsXXsN/zZ6/PUa6pKwUrbrnNh1r0YicAk+/0ihogHvO+je7RTjfBRUyNfobD1jBvVx10Ietw/0BVflZXusPIrc28uooJ/aPr6TdNQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BCu84SV2; arc=none smtp.client-ip=95.215.58.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BCu84SV2"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lCEWlk6vP9nwICOOWRNGYwdO5Cs+d8wClyGbrj/nTWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790005842; v=1; x=1790610642;
 b=BCu84SV2+EpI9OFp5JQ8tXw6RJUzdcOFV3PzTXo6EyewLJNhjqu01EefnYd/1fJRrHSXac5H
 Cu6+Qx1Bg7yu+kuqR+bE7LLjlT0XvEW91s4bahVTcrAq1/woZmDJPRGhTWLAmbDpEGzglaacNAW
 s9DHwF4SUjAEJp5mFQEkjwQE=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id fcf3e9721d2308c3;
	Mon, 21 Sep 2026 15:50:31 +0000
X-Mizu-Trace-ID: fcf3e9721d2308c3
X-Migadu-Flow: FLOW_OUT
Message-ID: <3049af11-b93e-4849-8cf6-463a27792ae5@linux.dev>
Date: Mon, 21 Sep 2026 16:50:31 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/10] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
 <20260921154015.2971990-21-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260921154015.2971990-21-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 16:40, Niklas Cassel wrote:
> When logical block provisioning is enabled, a command that writes user
> data marks the region that it wrote in the provisioning map, so that
> GET LBA STATUS reports the region as mapped. resp_write_dt0(),
> resp_write_scat() and resp_write_same() all call map_region() for that.
> 
> resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
> provisioning map untouched, and GET LBA STATUS keeps reporting the
> region as deallocated after it has been written. map_state(), which
> GET LBA STATUS uses, is the only reader of the map, so that is the whole
> of the effect.
> 
> Call map_region() the way resp_write_dt0() does, and take the zone
> metadata write lock across the access as it does when logical block
> provisioning is enabled. That lock is what serialises the provisioning
> map against resp_unmap(), which holds it while unmap_region() clears map
> bits and zeroes the data that they cover. resp_unmap() does nothing
> unless logical block provisioning is enabled, so the lock is only needed
> in that case.
> 
> Assisted-by: LLM
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>    modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
>        atomic_wr=1 lbpu=1
> 
> GET LBA STATUS reports a region that has never been written as
> deallocated, and reports it as mapped after a WRITE ATOMIC (16) of eight
> blocks. Only an ordinary WRITE did so before this patch.
> ---
> 
> Changes since v4: the meta_data_locked variable is gone, as suggested.
>   drivers/scsi/scsi_debug.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d07f6f891951..2e1a02c383a3 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6202,6 +6202,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   	u8 *cmd = scp->cmnd;
>   	u16 boundary, len;
>   	u64 lba, lba_tmp;
> +	bool lbp = scsi_debug_lbp();
>   	int ret;
>   
>   	if (!scsi_debug_atomic_write()) {
> @@ -6246,7 +6247,16 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   		}
>   	}
>   
> +	if (lbp)
> +		sdeb_meta_write_lock(sip);
> +
>   	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +	if (unlikely(lbp))

Is this supposed to be called if ret <= 0?

> +		map_region(sip, lba, len);
> +
> +	if (lbp)

Ignoring comment above, why not combine into a single if statement?

> +		sdeb_meta_write_unlock(sip);
 > +>   	if (unlikely(ret == -1))
>   		return DID_ERROR << 16;
>   	if (unlikely(ret != len * sdebug_sector_size))

