Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6838F142900;
	Mon, 19 Aug 2024 10:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724065053; cv=none; b=rXNVX1dEjgrb+Z21zHufs8RWMSp1M8jrkKEaL5kO8Bpmgiqsu34tUY7SQothXYUKjf7nhPIKZdWCWAyDbT2Sfs1e2jAXAsOlumMbpTPKBj6fwWjeNP6bd8mMpGMI0g7DmyKFouU726diSZofOUsf7E0tMA1F5XtS/mIrpLsjsHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724065053; c=relaxed/simple;
	bh=EXnBZhRBDTjgOZaGOlzmFEXScQis9I93u6zh7wJFIcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cugWtVm50CfItDcvcNk2oDSHVMePTCnBzG3so3Zr5E8DUV+pPuykGKrYhhLuCkqzpYj40y+Sgtm4OVFo43Yn5rH7rxLfiVNdNyH+hVWS0/SdYgIWeUYMXVy2cbYbsAB7oQzspzNZTSESllHUrwlfibuw4zwRlgAi+m/uTXw3HUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqrHPf/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqrHPf/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF41C32782;
	Mon, 19 Aug 2024 10:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724065053;
	bh=EXnBZhRBDTjgOZaGOlzmFEXScQis9I93u6zh7wJFIcU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LqrHPf/wpTiFcS2kjZKdhodpWiHaPfsJ/ydvHxw8Bv1HfrGc/xFm5KGba/GZuLoK0
	 zuaEVkZ3ldcEIU91+kW7VDRZ7XGG0SWPmLffoqiURzZfRF1/+Obe450QWKwHrcZxJy
	 ohPXCr7im5Nl/2IwFTeZDERyXikloS40IGW/wwvCgHPkrToLcYA9Z5VVWndIzRyift
	 kXpHfgwXuakO374q+lfzRqKi++Fn/TjaS58dzATpJ1EUZwaJ/8aAweZNVuXJ9BGjWw
	 0vUmCWbc6c6q2CjBKgcnoIvFac+w/mG41TQ+ceQJKg5AnNjzyIrjzURXyAhfXnB0zE
	 3NXjkEjA+QDcQ==
Message-ID: <c1552d1f-e147-44d9-8cc6-5ab2110b4703@kernel.org>
Date: Mon, 19 Aug 2024 19:57:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 bvanassche@acm.org, linuxarm@huawei.com, prime.zeng@huawei.com,
 stable@vger.kernel.org
References: <20240819090934.2130592-1-liyihang9@huawei.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240819090934.2130592-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/24 18:09, Yihang Li wrote:
> If formatting a suspended disk (such as formatting with different DIF
> type), the disk will be resuming first, and then the format command will
> submit to the disk through SG_IO ioctl.
> 
> When the disk is processing the format command, the system does not submit
> other commands to the disk. Therefore, the system attempts to suspend the
> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
> command will fail because the disk is in the formatting process, which
> will cause the runtime_status of the disk to error and it is difficult
> for user to recover it. Error info like:
> 
> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4
> 
> To solve the issue, ignore the error and return success/0 when formatting
> in progress.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Yihang Li <liyihang9@huawei.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

The patch changed significantly, so I do not think you can retain Bart's review
tag...

In any case, this looks OK to me, so:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
> Changes since v4:
> - Rename the commit title.
> - Ignore the SYNC command error during formatting as suggested by Damien.
> 
> Changes since v3:
> - Add Cc tag for kernel stable.
> 
> Changes since v2:
> - Add Reviewed-by for Bart.
> 
> Changes since v1:
> - Updated and added error information to the patch description.
> 
> ---
>  drivers/scsi/sd.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index adeaa8ab9951..2d7240a24b52 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1823,13 +1823,15 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
>  				/* this is no error here */
>  				return 0;
> +
>  			/*
> -			 * This drive doesn't support sync and there's not much
> -			 * we can do because this is called during shutdown
> -			 * or suspend so just return success so those operations
> -			 * can proceed.
> +			 * If a format is in progress or if the drive does not
> +			 * support sync, there is not much we can do because
> +			 * this is called during shutdown or suspend so just
> +			 * return success so those operations can proceed.
>  			 */
> -			if (sshdr.sense_key == ILLEGAL_REQUEST)
> +			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
> +			    sshdr.sense_key == ILLEGAL_REQUEST)
>  				return 0;
>  		}
>  

-- 
Damien Le Moal
Western Digital Research

