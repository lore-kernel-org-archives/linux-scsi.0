Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2659530B53E
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789716792; cv=none; b=bF0hqBZvN9C3EHc+EmxrccFSPzPLhEkfxcrv0V0S1lZYXMPt6TyeMkOBl2bl6FUxM7ezkLW/B6g3rXFcqg09IolKZY4NMJra6/4V2oW35Mnf/aAFMoJuANKyRhkMR20hDL3KImZE3mrNRWGTk1CYValP2DBjdFGVy/Saidnx3iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789716792; c=relaxed/simple;
	bh=Lyy+JlHgNsa2ne1vIG6DxkonhoJwwRQlVKM+kMpvRgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EN6W6Ax1Oz2e/EhZZHtb5Rfgu2xa4SP1pWOiAK18+sQWnM2wIkGJ+8BnqHHWZv4w/bzNXe8EfI+MEMyfJQtrxdzTGg3ApcH1BXd2UDwmZw0n5DpHhajuNn3No7OVrZ7Ahy5pR5QpT2sjnvU0JPseSlxlia0CUdBXzAJZ72mbRKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ddc7/qRo; arc=none smtp.client-ip=91.218.175.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ddc7/qRo"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Lyy+JlHgNsa2ne1vIG6DxkonhoJwwRQlVKM+kMpvRgA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789716789; v=1; x=1790321589;
 b=Ddc7/qRoU+N0YPxx7XYM9MRnScAglRqSKg95VVT+0lHDyMKvRxFlDiJB0iczX8jlM28hs5lr
 jeIlLIuDN3APeCHDoBXo+m6pW0LnSlFcNpQ60YydVFrKKenP+h8Bd/2f8LcUaEtY8rJTcY7JkQl
 yMyhkVWglA4wIw1ZE/b2SbXw=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id e759b086abbb3931;
	Fri, 18 Sep 2026 07:33:09 +0000
X-Mizu-Trace-ID: e759b086abbb3931
X-Migadu-Flow: FLOW_OUT
Message-ID: <d9971f1c-6e8c-4e6b-889e-bb8d6449b451@linux.dev>
Date: Fri, 18 Sep 2026 08:33:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/10] scsi: scsi_debug: Validate the access parameters
 of WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-22-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260918062910.1709791-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 07:29, Niklas Cassel wrote:
> resp_atomic_write() validates the fields that are specific to an atomic
> write, the alignment and granularity of the transfer, the atomic
> boundary and the maximum transfer length, but it never validates the
> range that the command addresses. Every other command that writes user
> data calls check_device_access_params() first, which rejects a transfer
> that ends beyond the capacity of the device, one whose length exceeds
> the size of the store, and any write to a write protected device.
> 
> As a consequence a WRITE ATOMIC (16) past the end of the device is not
> terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
> reduces the LBA modulo the size of the store, so the command writes
> somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
> a device whose wp module parameter is set, which every other write
> refuses with DATA PROTECT.
> 
> Call check_device_access_params(). The zone checks that it ends with are
> unreachable, as atomic writes and ZBC emulation are mutually exclusive.

These are quite verbose commit messages ... LLM-generated, by chance?

> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
> Tested with:
> 
>    modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
>        atomic_wr=1
> 
> The device has a capacity of 262144 logical blocks. A WRITE ATOMIC (16)
> of eight blocks at LBA 262140 is now terminated with ILLEGAL REQUEST /
> LOGICAL BLOCK ADDRESS OUT OF RANGE; before this patch it completed with
> GOOD status, having written eight blocks at LBA 0 instead.
> 
> With the wp module parameter set to 1, a WRITE ATOMIC (16) is now
> terminated with DATA PROTECT / LOGICAL UNIT SOFTWARE WRITE PROTECTED,
> which is what an ordinary WRITE(16) has always returned; before this
> patch it completed with GOOD status and wrote the data.
> ---
>   drivers/scsi/scsi_debug.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 5243401701f9..5ae1241e4d8b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6246,6 +6246,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   		}
>   	}
>   
> +	ret = check_device_access_params(scp, lba, len, true);
> +	if (ret)
> +		return ret;
> +
>   	if (lbp) {
>   		sdeb_meta_write_lock(sip);
>   		meta_data_locked = true;

