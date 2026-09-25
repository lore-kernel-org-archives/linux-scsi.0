Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D48A4749F6
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790326565; cv=none; b=bCHObCPCII2NBqSOkL0bOqkTUK83zW+a71U1dKATFvR7sbJWrRNfTtWbISPPnUxxrWrb38ic34xaZQJCmaTtH2gkkx0N8v+TWWs8HvDLj5uEs/XGFP+AoQ/oIh7Ksya7Lr1RBwlhfy0G0CEaKkdnxmd86ul++/ALWGbQ0ChXFg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790326565; c=relaxed/simple;
	bh=c3iEYiVVJ+jK8vctlhMGu0oaLWYTirxKW1mrmGv6OFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=um19TWDt5urXN7zR0xsgKXSB7Q+iapLt/NGMF/0SeE91+29qz2oWHJZFtlrI1xiAd7NBmd/dsvUC41RWVXEQxPW9m4cSJiTaGqnUCXCXDF+scVeIeOnR+iqWyFpHEPemiwwc2qpAZuZypN9iFPhxgZcKlDt1Pl+nBc2HaYwQpSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d0wOpNS8; arc=none smtp.client-ip=91.218.175.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d0wOpNS8"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=c3iEYiVVJ+jK8vctlhMGu0oaLWYTirxKW1mrmGv6OFk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790326559; v=1; x=1790931359;
 b=d0wOpNS8U+TtZORLaMTxrlkn7QcAZXq18b6CSm1XBayXoPbTmy6C/6hkr7jGqW6Bw1FQ8gaG
 CbvMJ8bJGTPHCTwbXo0k9q8wN2FcCKmeYCCjeAZ9tjObCVjWaqlpwR/QsjID7obtvHVtrIRmNcp
 9QwarsTcQEo9CbP1HUbNY3K8=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 8fcbfe74b0c3286e;
	Fri, 25 Sep 2026 08:55:59 +0000
X-Mizu-Trace-ID: 8fcbfe74b0c3286e
X-Migadu-Flow: FLOW_OUT
Message-ID: <93d9399e-6374-4b94-a26b-40bb8e9e5cc7@linux.dev>
Date: Fri, 25 Sep 2026 09:55:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] scsi: scsi_debug: Split corrupt_lbas()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <9484940ad7bb464786c9f52211129015ce8ec006.1790290090.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <9484940ad7bb464786c9f52211129015ce8ec006.1790290090.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 23:54, Bart Van Assche wrote:
> Move the inner logic of corrupt_lbas() into a new helper function
> __corrupt_lbas() and call it from separate locked and unlocked branches
> in corrupt_lbas(). This patch prepares for enabling context analysis.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
>   drivers/scsi/scsi_debug.c | 42 ++++++++++++++++++++-------------------
>   1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d0d2cbac487b..0f4637d1265a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4948,39 +4948,26 @@ static int resp_write_tape(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	return 0;
>   }
>   
> -static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
> -		u32 nr_bit_errors, s32 reftag_adjust)
> +static int __corrupt_lbas(struct sdeb_store_info *sip, u64 lba, u32 num,
> +			  u32 nr_bit_errors, s32 reftag_adjust)
>   {
> -	struct sdeb_store_info *sip = devip2sip(devip, false);
> -	bool meta_data_locked = false;
>   	u32 block, num_mapped, b, i;
> -	int error = 0;
> -
> -	if (sdebug_dev_is_zoned(devip) ||
> -	    sdebug_dix ||
> -	    scsi_debug_lbp())  {
> -		sdeb_meta_write_lock(sip);
> -		meta_data_locked = true;
> -	}
>   
>   	if (!sip) {
>   		pr_err("can't corrupt with fake_rw\n");
> -		error = -EINVAL;
> -		goto out_unlock;
> +		return -EINVAL;

These checks don't need locking, so could be in corrupt_lbas(). It does 
not make much difference though.

>   	}
>   
>   	if (num > sdebug_capacity || lba > sdebug_capacity - num) {
>   		pr_err("logical blocks out of bounds: %llu:%u", lba, num);
> -		error = -EINVAL;
> -		goto out_unlock;
> +		return -EINVAL;
>   	}
>   
>   	if (scsi_debug_lbp() &&
>   	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {
>   		pr_err("can't modify unmapped logical blocks: %llu:%u",
>   			lba, num);
> -		error = -EINVAL;
> -		goto out_unlock;
> +		return -EINVAL;
>   	}
>   
>   	/*
> @@ -5018,9 +5005,24 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
>   	}
>   	sdeb_data_unlock(sip, false);
>   
> -out_unlock:
> -	if (meta_data_locked)
> +	return 0;
> +}
> +
> +static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
> +			u32 nr_bit_errors, s32 reftag_adjust)
> +{
> +	struct sdeb_store_info *sip = devip2sip(devip, false);
> +	int error;
> +
> +	if (sdebug_dev_is_zoned(devip) || sdebug_dix || scsi_debug_lbp()) {
> +		sdeb_meta_write_lock(sip);
> +		error = __corrupt_lbas(sip, lba, num, nr_bit_errors,
> +				       reftag_adjust);
>   		sdeb_meta_write_unlock(sip);
> +	} else {
> +		error = __corrupt_lbas(sip, lba, num, nr_bit_errors,
> +				       reftag_adjust);
> +	}
>   	return error;
>   }
>   

