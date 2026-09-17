Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315D4B0E21
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 09:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637932; cv=none; b=ZagAQ9CgdRSQt4HP2hfnFe6U5KC1P2H0tcSpnGSAEt3tHOeAGpHyfsw6xhS8hI9AiQNOk4Z3+E/G4i4P5jSuwOEECHBpF4yW3MsBl4LOCRXAYMt8ltoAGYKNuqrr0F2iR3uBmSHYS5+2wDztie8e1/9rAmYK2NxZiUui8aNjb+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637932; c=relaxed/simple;
	bh=455axjZCXVW44rT+TQvuWWUtzuant2rrHc14Vj6EYBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHFW0AJfjtQLMIrzkmWjKNMf/u++NlJtMo/Nk1oddoOrcq1CqCOkF7RXT8+SmU/jD7XTyrLFJKVVt+7bfSQN9sFlXiLxzeSmkhzEx1HxPQiAyUm8xjvlFC5CUfcH1lom4mrNCiLyl2q+HwosIdgZQpvmZAekJPpQxGfW/w2QW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nwImZV/u; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nwImZV/u"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=455axjZCXVW44rT+TQvuWWUtzuant2rrHc14Vj6EYBE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789637911; v=1; x=1790242711;
 b=nwImZV/uKo7QWMguNqutejWh8omvc8KKqfyh+m8X9YkLKdjqFCFw53hNSxmFXw26itXtMCx1
 8PdSizQ1p+dXDipe2/voYl63M+qL6P8Ktch2FKwSE2AcVhgUZ21tFN//ukf7NlOnshYHlRRXSbO
 TneWJOGN0Y5zqBo6aMMGRR50=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 43410b35661b50ad;
	Thu, 17 Sep 2026 09:38:31 +0000
X-Mizu-Trace-ID: 43410b35661b50ad
X-Migadu-Flow: FLOW_OUT
Message-ID: <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev>
Date: Thu, 17 Sep 2026 10:38:30 +0100
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
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260917084553.559765-6-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 09:45, Niklas Cassel wrote:

So far we have not considered atomic writes for zoned devices - do 
devices which support both technologies exist? Or is this just hypothetical?

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
>    modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
>        zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2 atomic_wr=1
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
>   drivers/scsi/scsi_debug.c | 13 +++++++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6043,7 +6043,24 @@
>   		}
>   	}
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
>   	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +
> +	/* If ZBC zone then bump its write pointer */
> +	if (sdebug_dev_is_zoned(devip)) {
> +		zbc_inc_wp(devip, lba, len);
> +		sdeb_meta_write_unlock(sip);
> +	}
> +
>   	if (unlikely(ret == -1))
>   		return DID_ERROR << 16;
>   	if (unlikely(ret != len * sdebug_sector_size))

