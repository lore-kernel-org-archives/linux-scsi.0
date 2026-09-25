Received: from mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E154347424F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 08:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790326231; cv=none; b=KiS2CetAY6oMWD5s+FlzfD4NNPJyR3qaj+zYDzUoS7EqC58eVdRwDLcEsD6Rn8lV7ycdEGwxg/mqNQU14K8yAhAam7jzj60FrF1FpCu5vNTT8xdZ/tQdFxho0xUSnQXTaHUTCKSI0I80WM6VijKb9IlirxIOLzl8NKGvZP9PV3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790326231; c=relaxed/simple;
	bh=L0K+KA9s3L/QiBV2j1QaI2BLig0y0a31CuR5n+OlJk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ts3XGdYuX0c7z3exg7SqSDitFK3B+/WMFaUTB5WscW5Iw3dokB7B0uZVIxlojFIABWpnFa8WevIxAhKhhE/MlPcVH5CJBLkRZhRV4G/WzeCmpWU6QTlhf8SrTI62kJ+QhGRQ+UkDf4cus64mk+vD2HmmGpKaW8YhfsnDwqIxr+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZFm7GgHB; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZFm7GgHB"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=L0K+KA9s3L/QiBV2j1QaI2BLig0y0a31CuR5n+OlJk0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790326224; v=1; x=1790931024;
 b=ZFm7GgHBA31eajv5llfWl+M0F1+1iGRuPxymcz+VBC3QtBreEHuwVZwqW5Eh4BUUwSI/Q+AU
 NmEnuAnF42bnQJICn408K8z61osAHMq0JeUWKH3sso+CIZkpoqxhnBRpHuDiETaJu9hWWHtkhCk
 GrcoanopR03VPDBxxjxhlwrw=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 57b7e60e8c4a0c8b;
	Fri, 25 Sep 2026 08:50:22 +0000
X-Mizu-Trace-ID: 57b7e60e8c4a0c8b
X-Migadu-Flow: FLOW_OUT
Message-ID: <5ec8b4ef-ba6a-4faa-919d-e099aedb453c@linux.dev>
Date: Fri, 25 Sep 2026 09:50:22 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] scsi: scsi_debug: Split resp_write_same()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <20122153e730550db9b05401ed14d0a8a20d4773.1790290090.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20122153e730550db9b05401ed14d0a8a20d4773.1790290090.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 23:54, Bart Van Assche wrote:
> Since the Clang thread-safety analyzer does not support conditional
> locking, split the function resp_write_same() such that all locking
> statements end up in the same branch of an if-statement.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
>   drivers/scsi/scsi_debug.c | 34 ++++++++++++++++++++++------------
>   1 file changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index ed8d69f305f8..d0d2cbac487b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5360,8 +5360,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>   	return ret;
>   }
>   
> -static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
> -			   u32 ei_lba, bool unmap, bool ndob)
> +static int __resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
> +			     u32 ei_lba, bool unmap, bool ndob)
>   {
>   	struct scsi_device *sdp = scp->device;
>   	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
> @@ -5373,20 +5373,14 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   						scp->device->hostdata, true);
>   	u8 *fs1p;
>   	u8 *fsp;
> -	bool meta_data_locked = false;
> -
> -	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
> -		sdeb_meta_write_lock(sip);
> -		meta_data_locked = true;
> -	}
>   
>   	ret = check_device_access_params(scp, lba, num, true);
>   	if (ret)
> -		goto out;
> +		return ret;
>   
>   	if (unmap && scsi_debug_lbp()) {
>   		unmap_region(sip, lba, num);
> -		goto out;
> +		return ret;
>   	}
>   	lbaa = lba;
>   	block = do_div(lbaa, sdebug_store_sectors);
> @@ -5422,9 +5416,25 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   	ret = 0;
>   unlock:
>   	sdeb_data_write_unlock(sip);
> -out:
> -	if (meta_data_locked)
> +	return ret;
> +}
> +
> +static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 ei_lba,
> +			   bool unmap, bool ndob)
> +{
> +	struct scsi_device *sdp = scp->device;
> +	struct sdebug_dev_info *devip = sdp->hostdata;
> +	struct sdeb_store_info *sip = devip2sip(devip, true);
> +	int ret;
> +
> +	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
> +		sdeb_meta_write_lock(sip);
> +		ret = __resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
>   		sdeb_meta_write_unlock(sip);
> +	} else {
> +		ret = __resp_write_same(scp, lba, num, ei_lba, unmap, ndob);
> +	}
> +
>   	return ret;
>   }
>   

