Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0948125E
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328796; cv=none; b=hbNGRKM+Er/QFHkREZyQt2uhJal6Cw9+WWhmrK9AvTM5cEjDk0kinBzLPgugTDNMAlDaTas33xbxa9WUWyo3m7VMlk2LV6YNiBlhD4Pdc6pq3bOUK3/KIFGUWU9NawXwOUYQGkcWQyGnKhSyW5TJJrSselbkwS+30HuC8EsnKXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328796; c=relaxed/simple;
	bh=yxkl7C7chl4bdK55Y6rDn+IjhcD7vfZw+HQ60A7CQ9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ihhfmAliNL+sUCiHNaJCo2veOpiPsFH3tJN2Kv1wiugkVgH8L8ql3QM8x9tge3AI28VPpNaebhc1nz4pHNAc7LQXUhpzy6/GtBhB1jCQDqfE2VyDfYXM+DghN8ZAv8WEU1siXFaA9QjUrRMIEGVIpuAD5w7SbA8PPVJrAOPdhqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tY+d5qPI; arc=none smtp.client-ip=91.218.175.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tY+d5qPI"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yxkl7C7chl4bdK55Y6rDn+IjhcD7vfZw+HQ60A7CQ9U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790328792; v=1; x=1790933592;
 b=tY+d5qPI5/b5cwVhRbfRxmrxa/v1XroWPLXmvUzQAinfk3/36UOQuz5orUa7eVctyQc0b5xU
 KqVZXeRm0hTmgEulDH2QPbWOqh4Dc5SYrFQenDk3j3P8ezF//jGcC6aX6FttIeOxoyjOZgarjUC
 S6vEsuewWOODhECZUtBQ1bns=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id a07215f3146a3e84;
	Fri, 25 Sep 2026 09:33:12 +0000
X-Mizu-Trace-ID: a07215f3146a3e84
X-Migadu-Flow: FLOW_OUT
Message-ID: <50999332-c140-40b6-b1fd-0720911ebbe2@linux.dev>
Date: Fri, 25 Sep 2026 10:33:11 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/11] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
 <20260925071726.140915-23-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260925071726.140915-23-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 08:17, Niklas Cassel wrote:
> When logical block provisioning is enabled, every command that writes
> user data calls map_region() so that GET LBA STATUS reports the region
> as mapped. resp_atomic_write() does not, so GET LBA STATUS keeps
> reporting a region as deallocated after a WRITE ATOMIC (16) has written
> it.
> 
> Call map_region() the way resp_write_dt0() does, holding the zone
> metadata write lock across the access. That lock is what serialises the
> map against resp_unmap(), which does nothing unless logical block
> provisioning is enabled.
> 
> Assisted-by: LLM
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: John Garry <john.garry@linux.dev>

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
>   drivers/scsi/scsi_debug.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c0bcf8155fc8..c407f4c5ac47 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6203,6 +6203,7 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   	u8 *cmd = scp->cmnd;
>   	u16 boundary, len;
>   	u64 lba, lba_tmp;
> +	bool lbp = scsi_debug_lbp();
>   	int ret;
>   
>   	if (!scsi_debug_atomic_write()) {
> @@ -6251,7 +6252,15 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   	if (scsi_bufflen(scp) < len * sdebug_sector_size)
>   		return DID_ERROR << 16;
>   
> +	if (lbp)
> +		sdeb_meta_write_lock(sip);
> +
>   	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +	if (lbp) {
> +		map_region(sip, lba, len);
> +		sdeb_meta_write_unlock(sip);
> +	}
> +
>   	if (unlikely(ret == -1))
>   		return DID_ERROR << 16;
>   	if (unlikely(ret != len * sdebug_sector_size))

