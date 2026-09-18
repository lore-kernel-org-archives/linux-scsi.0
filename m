Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639213D51E
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 07:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789716574; cv=none; b=BZk553EIxqLsqyFGIHPwoqeQg2lGeqjBYe4cNEkMezbzT2QK7mbjRw4+PTpYobAYD5RYLvtkkiBmMiPbckkIit8O3p4V0UBDqMJDDnA1CiZMyVq51Jv70aZfYzAzOd+ryDj/ETu/2w+OW36Io0fvR3Vdi3tdidD2WHhCDktQqz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789716574; c=relaxed/simple;
	bh=1vtu0Ca88wzRbZC53hoZAycAzD92Zh4Axz53RVwrID4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LGFAO/cJJHZJAT9pmchS1hOQxGJtopb2GTwpbOUUzo8+pMGlFUrDlks8M7YQ+ilxk8QXQVPk2Fdrmbm/7DZ9zSIFop7lW4ooe35hShAaWvRc9Kz10RVdsNd31gH9/GlI6kmwWIXRm4+H5Ui7H1AS8zwfv0gx7TK7JoklAbNRvyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G5BNinuh; arc=none smtp.client-ip=91.218.175.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G5BNinuh"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1vtu0Ca88wzRbZC53hoZAycAzD92Zh4Axz53RVwrID4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789716567; v=1; x=1790321367;
 b=G5BNinuh+QsCnctJBwU1VJP3sTj9sa6UtVP4JlJovAdD56wR/lJ9UJxYKSyWCoU3IKkpv/PK
 L4MomtdwRnDEOxRKXMppYRfGrVGJVl1oNtdmzLeLnx1EBZYfmqZCMqkIE53Uz6s+4i7eHm2/ubg
 h4A3mby3o5woU0IeaWrVpraQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 2c627144f1e79fbe;
	Fri, 18 Sep 2026 07:29:17 +0000
X-Mizu-Trace-ID: 2c627144f1e79fbe
X-Migadu-Flow: FLOW_OUT
Message-ID: <9838197a-4c2f-477c-b4bb-648f13922e19@linux.dev>
Date: Fri, 18 Sep 2026 08:29:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/10] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-21-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260918062910.1709791-21-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 07:29, Niklas Cassel wrote:
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
>   drivers/scsi/scsi_debug.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index cdea21b570c4..5243401701f9 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6200,6 +6200,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   	u8 *cmd = scp->cmnd;
>   	u16 boundary, len;
>   	u64 lba, lba_tmp;
> +	bool meta_data_locked = false;
> +	bool lbp = scsi_debug_lbp();
>   	int ret;
>   
>   	if (!scsi_debug_atomic_write()) {
> @@ -6244,7 +6246,18 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   		}
>   	}
>   
> +	if (lbp) {
> +		sdeb_meta_write_lock(sip);
> +		meta_data_locked = true;
> +	}
> +
>   	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> +	if (unlikely(lbp))
 > +		map_region(sip, lba, len);> +
> +	if (meta_data_locked)

Do we really need meta_data_locked variable? why not:
	if (lbp)
		sdeb_meta_write_unlock(sip);

> +		sdeb_meta_write_unlock(sip);
> +
>   	if (unlikely(ret == -1))
>   		return DID_ERROR << 16;
>   	if (unlikely(ret != len * sdebug_sector_size))

