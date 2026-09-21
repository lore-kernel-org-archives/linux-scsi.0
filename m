Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60664BB27C
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790006018; cv=none; b=ZTNxu+ZdG+JQNpYqdw4LkQv5LIvzY0pPz4xUTUaVwdLysmOYE8oshxZfZlSKljR4dsib0vBumk9mWhMEPedwjXdIOeaGaPmOb2buoKY0dw20no9T4wP4t4w/YU2aWGmJmcuRpvRcmMJdTfFgKGZbWPUnprFU1hd95rogh3IXmWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790006018; c=relaxed/simple;
	bh=S6t3qBE0znctNUR2xaTvaZJMssPcku1SWqhMKcTBEH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I6b2bKW644PRgY51CwPMU2ahqT/oqtrhh1aYaKzL8j2R6o4ZNuxvpzQ2zKXOF0zW0biNOr7pgXHjAs1wwM99Ef0sszdS4zg0bhgPH3XGu8BpUlXbUQW+TxA5MGCQNYoqSzU9/XWY57KC9NQvd/MyQL9ElxsS6L0Nh3dk+DvAeR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KkUJwNB3; arc=none smtp.client-ip=95.215.58.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KkUJwNB3"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=S6t3qBE0znctNUR2xaTvaZJMssPcku1SWqhMKcTBEH8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790006013; v=1; x=1790610813;
 b=KkUJwNB3DAliuf16QLDxKWKUEqxERBoo7pIBdn2Qt/s8PYtB+BoAvNtm5jdFaIn1rdKwm3xk
 DXeZAoe75w+ReU+df7Pz2Fp4/XAqDdnL9BUsp4m913J2D5uGxEFND9lIuju+iOcD/VA5k+ex8P/
 nArBWSLdAEztvIaoY3sCcYlk=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 18c8d8d5de123420;
	Mon, 21 Sep 2026 15:53:33 +0000
X-Mizu-Trace-ID: 18c8d8d5de123420
X-Migadu-Flow: FLOW_OUT
Message-ID: <d460d0ef-d182-44ca-82d3-dd29afbce565@linux.dev>
Date: Mon, 21 Sep 2026 16:53:33 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] scsi: scsi_debug: Evaluate scsi_debug_lbp() only
 once
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
 <20260921154015.2971990-16-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260921154015.2971990-16-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 16:40, Niklas Cassel wrote:
> corrupt_lbas(), resp_write_dt0() and resp_write_same() call
> scsi_debug_lbp() to decide whether to take the zone metadata lock, and
> then call it again to decide whether to read or write the provisioning
> map that the lock protects.
> 
> The result is not a constant. scsi_debug_lbp() is false while the
> fake_rw module parameter is set, and fake_rw can be written at any time,
> both as a module parameter and through its driver attribute in sysfs.
> The two calls can therefore disagree, and the later one can decide to
> touch the provisioning map after the earlier one decided not to take the
> lock that protects it.
> 
> Call it once and use the result throughout.
> 
> Assisted-by: LLM
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
> Tested with:
> 
>    modprobe scsi_debug sector_size=512 dev_size_mb=128 lbpu=1 lbpws=1
> 
> A WRITE(16) completes and GET LBA STATUS then reports the region as
> mapped, which covers resp_write_dt0(). A WRITE SAME and a WRITE SAME
> with the UNMAP bit set complete, and GET LBA STATUS reports the first
> region as mapped and the second as deallocated, which covers all three
> uses of the result in resp_write_same().
> 
> corrupt_lbas() is not covered. It is reached by writing to the corrupt
> file in debugfs, and that interface rejected the requests that were
> tried, for a reason that has nothing to do with this patch.
> 
> The window that the change closes was not reproduced. It needs fake_rw
> to be written between two calls, and was found by review.
> ---
>   drivers/scsi/scsi_debug.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 18aefe83b7b6..c68dba6dbbdd 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4953,12 +4953,13 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
>   {
>   	struct sdeb_store_info *sip = devip2sip(devip, false);
>   	bool meta_data_locked = false;
> +	bool lbp = scsi_debug_lbp();
>   	u32 block, num_mapped, b, i;
>   	int error = 0;
>   
>   	if (sdebug_dev_is_zoned(devip) ||
>   	    sdebug_dix ||
> -	    scsi_debug_lbp())  {
> +	    lbp)  {
>   		sdeb_meta_write_lock(sip);
>   		meta_data_locked = true;
>   	}
> @@ -4975,7 +4976,7 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
>   		goto out_unlock;
>   	}
>   
> -	if (scsi_debug_lbp() &&
> +	if (lbp &&
>   	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {

combine lines? Please consider elsewhere in this patch. However I think 
that we still like to enforce the 80 character line limit... well, some do.

Thanks

>   		pr_err("can't modify unmapped logical blocks: %llu:%u",
>   			lba, num);
> @@ -5035,6 +5036,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	struct sdeb_store_info *sip = devip2sip(devip, true);
>   	u8 *cmd = scp->cmnd;
>   	bool meta_data_locked = false;
> +	bool lbp = scsi_debug_lbp();
>   
>   	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
>   		     atomic_read(&sdeb_inject_pending))) {
> @@ -5102,7 +5104,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   
>   	if (sdebug_dev_is_zoned(devip) ||
>   	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
> -	    scsi_debug_lbp())  {
> +	    lbp)  {
>   		sdeb_meta_write_lock(sip);
>   		meta_data_locked = true;
>   	}
> @@ -5147,7 +5149,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	}
>   
>   	ret = do_device_access(sip, scp, 0, lba, num, group, true, false);
> -	if (unlikely(scsi_debug_lbp()))
> +	if (unlikely(lbp))
>   		map_region(sip, lba, num);
>   
>   	/* If ZBC zone then bump its write pointer */
> @@ -5374,8 +5376,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   	u8 *fs1p;
>   	u8 *fsp;
>   	bool meta_data_locked = false;
> +	bool lbp = scsi_debug_lbp();
>   
> -	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
> +	if (sdebug_dev_is_zoned(devip) || lbp) {
>   		sdeb_meta_write_lock(sip);
>   		meta_data_locked = true;
>   	}
> @@ -5384,7 +5387,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   	if (ret)
>   		goto out;
>   
> -	if (unmap && scsi_debug_lbp()) {
> +	if (unmap && lbp) {
>   		unmap_region(sip, lba, num);
>   		goto out;
>   	}
> @@ -5414,7 +5417,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   		block = do_div(lbaa, sdebug_store_sectors);
>   		memmove(fsp + (block * lb_size), fs1p, lb_size);
>   	}
> -	if (scsi_debug_lbp())
> +	if (lbp)
>   		map_region(sip, lba, num);
>   	/* If ZBC zone then bump its write pointer */
>   	if (sdebug_dev_is_zoned(devip))

