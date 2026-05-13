Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907A83EDE4C
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 08:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778659399; cv=none; b=XzFy1A9sJHNixp0ioMiSdnCIOgCeC27/flMEArnLoF6dinrULCGRGC58p6c//aNRIaUc9d4Ojd7w9TnLoIFVm5Xp88d+oizvqbM5/CVoUx8mRyrtUTJYxSxxFsIaQcVP0uaD/KFzqIugotgGA0q3g0jap9OLvxoV4d5jcU/Jy+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778659399; c=relaxed/simple;
	bh=kmER5V9RmjDhqiznxB/q2g8j9SK9ME+qf42DXKW7vVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FQpcHLl7PUSQonPxB3Aim0VlY1hHy6fqyc9Pc6dqWrWJO76CyfV0N3QJV2hDKSakd8pGVWgP/7kVevvv45X/zFsHayuipHJou8I1i8do/vyaD9P+lmNWAcHccpu/VRD/oXlydEsm5Nlgd2v1XUyk+IpBb9HgWzejdXdyqJs+sEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2Q6NHiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2Q6NHiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE04EC2BCB7;
	Wed, 13 May 2026 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778659399;
	bh=kmER5V9RmjDhqiznxB/q2g8j9SK9ME+qf42DXKW7vVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i2Q6NHiPb9SN5DTC2LOoPu6goHdCVXQa2qdCFXXc5Z1EGnFABzX10e9pxGuSP8xRE
	 DE2wrwsZzgOdcytkZL+tDW/2NlW3tUCmqLQiPdlWNyTLRBs71ESJVYSuec7nk+wGb+
	 gZ1z8cVfWv/hwemjuiYxBtonpJhmx650vxdEo8Dsz8fF/tZ4NJQ/IX7ia9z3Ym3vo4
	 wLp7dU5daEzu8WIW2LD6+UxUFNKUAbwjli8N2dAjS2KLBfFr2eSrvcrZa+Stq3xPn2
	 hMH2Za/TzViXdM1/zRzJn0LZzxLUQw6wLFLYSoR3x34XwEupVkxsL+609EecK3BlKA
	 XJDgxP0c0EokQ==
Message-ID: <292bb057-f10e-4af1-b0fe-ca83d4f49d06@kernel.org>
Date: Wed, 13 May 2026 17:03:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Hannes Reinecke <hare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512194634.58145-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/26 04:46, Bart Van Assche wrote:
> Currently the vendor, model, and revision members of struct scsi_device
> are pointers to fixed-length strings that are not NUL-terminated.

s/NUL/NULL

> Fixed-precision format specifiers (e.g., "%.8s") are required whenever
> they are printed and strncmp() must be used to compare these fields.
> This is error-prone.
> 
> Convert these fields to fixed-size character arrays within struct
> scsi_device. Remove an !sdev->model check because sdev->model is now
> guaranteed not to be NULL.
> 
> This patch fixes a bug in the qla2xxx driver. It makes the following
> code safe:
> 
> 		if (state_flags & BIT_4)
> 			scmd_printk(KERN_WARNING, cp,
> 			    "Unsupported device '%s' found.\n",
> 			    cp->device->vendor);
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/hwmon/drivetemp.c  |  5 +----
>  drivers/scsi/scsi_scan.c   | 12 ++++++------
>  include/scsi/scsi_device.h |  7 ++++---
>  3 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
> index 002e0660a0b8..efe8b229bdbe 100644
> --- a/drivers/hwmon/drivetemp.c
> +++ b/drivers/hwmon/drivetemp.c
> @@ -306,13 +306,10 @@ static bool drivetemp_sct_avoid(struct drivetemp_data *st)
>  	struct scsi_device *sdev = st->sdev;
>  	unsigned int ctr;
>  
> -	if (!sdev->model)
> -		return false;
> -
>  	/*
>  	 * The "model" field contains just the raw SCSI INQUIRY response
>  	 * "product identification" field, which has a width of 16 bytes.
> -	 * This field is space-filled, but is NOT NULL-terminated.
> +	 * This field is space-filled and NUL-terminated.

s/NUL/NULL

>  	 */
>  	for (ctr = 0; ctr < ARRAY_SIZE(sct_avoid_models); ctr++)
>  		if (!strncmp(sdev->model, sct_avoid_models[ctr],
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index ef22a4228b85..6c3a5d451c1d 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -292,9 +292,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	if (!sdev)
>  		goto out;
>  
> -	sdev->vendor = scsi_null_device_strs;
> -	sdev->model = scsi_null_device_strs;
> -	sdev->rev = scsi_null_device_strs;
> +	strscpy(sdev->vendor, scsi_null_device_strs);
> +	strscpy(sdev->model, scsi_null_device_strs);
> +	strscpy(sdev->rev, scsi_null_device_strs);
>  	sdev->host = shost;
>  	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
>  	sdev->id = starget->id;
> @@ -905,9 +905,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	if (sdev->inquiry == NULL)
>  		return SCSI_SCAN_NO_RESPONSE;
>  
> -	sdev->vendor = (char *) (sdev->inquiry + 8);
> -	sdev->model = (char *) (sdev->inquiry + 16);
> -	sdev->rev = (char *) (sdev->inquiry + 32);
> +	strscpy(sdev->vendor, sdev->inquiry + 8);
> +	strscpy(sdev->model, sdev->inquiry + 16);
> +	strscpy(sdev->rev, sdev->inquiry + 32);
>  
>  	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
>  	if (sdev->is_ata) {
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 9c2a7bbe5891..029f5115b2ea 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -7,6 +7,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/blk-mq.h>
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_common.h>
>  #include <linux/atomic.h>
>  #include <linux/sbitmap.h>
>  
> @@ -137,9 +138,9 @@ struct scsi_device {
>  	struct mutex inquiry_mutex;
>  	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
>  	unsigned char * inquiry;	/* INQUIRY response data */
> -	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
> -	const char * model;		/* ... after scan; point to static string */
> -	const char * rev;		/* ... "nullnullnullnull" before scan */
> +	char vendor[INQUIRY_VENDOR_LEN + 1];
> +	char model[INQUIRY_MODEL_LEN + 1];
> +	char rev[INQUIRY_REVISION_LEN + 1];
>  
>  #define SCSI_DEFAULT_VPD_LEN	255	/* default SCSI VPD page size (max) */
>  	struct scsi_vpd __rcu *vpd_pg0;


-- 
Damien Le Moal
Western Digital Research
