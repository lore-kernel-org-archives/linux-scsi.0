Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C11217583
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730741131; cv=none; b=Oqg6msha17s2669zhPXhubssrWVOBpskgNpz+1120sFPgOChiQ/Kv8TiWc4x4T+qVGzdlW8OXdDDsTLd8etkP2XCLWRNy30y8zkbZjShzgFASVwLmZTyKgWerQu+GE6wbrSonO/Y7m3aOSTdAm3sLothk6Fp9LKVe+UzRZXohsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730741131; c=relaxed/simple;
	bh=yv2MHXpswypp+8KA5V1ZkFW5LDaHfB5TD5cnsBUKVAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+mp0T/TEjH/S2GiFHase0EfwMYSFxO6AJQFcnTbwy65kL4XVZzszmkZI7tOWJmGrT6YSuWNStV+vO0gtzgKWwvbbBgMPh+dp0Y5arDHfUuybKT8Tj4meqHRQiJ4HSaW9vyulJ6styuAHSrdVAArkcq/HBQyvDR3Gvxcv0n4VnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Nv3KX8II; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Nv3KX8II"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xhyz71021zlgMVP;
	Mon,  4 Nov 2024 17:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730741119; x=1733333120; bh=wv20iz3vfF9DsI0ZhwKI+RSC
	6FBeDp1+UpCba9gg4bU=; b=Nv3KX8IIiinNcmMrQNzmdrMVsBCrcs9HTIOK8thQ
	tDiJwyPI/F8Qk9BsNHKEUafc30zFJqEwIK5MfqCq78XuyxwALEiuJ7yjsH/rGoJv
	9FjdXH40OZtcg1ftGQErhY6ox6dbS6WwAghMzUBd/7JEa81e/bozNFEXx+M88/7x
	creLI9bLzU298xE26SdPTH7xhHWs4YCCk/Y2Eu6T80ceV3VsohaAPsDoMDI8mGW2
	nBl1/EFs5BccMusoUcZaV7C5BvbzkLxwaTfTRi4i3WmGEMhf/VsEINrYtIVzRwCd
	G93Vz+NsWn/IxpLvlIU+qxWmQONjYHOLxSWjQDEXGrYBQw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FWJXpexVGLGK; Mon,  4 Nov 2024 17:25:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xhyz2714zzlgMVN;
	Mon,  4 Nov 2024 17:25:18 +0000 (UTC)
Message-ID: <40e8ff4e-9ffc-4658-ae1f-69ceee5593cb@acm.org>
Date: Mon, 4 Nov 2024 09:25:17 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: Enable runtime power management
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
 Douglas Gilbert <dgilbert@interlog.com>
References: <20241030220310.1373569-1-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241030220310.1373569-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 3:03 PM, Bart Van Assche wrote:
> In 2010, runtime power management support was implemented in the SCSI core.
> The description of patch "[SCSI] implement runtime Power Management"
> mentions that the sg driver is skipped but not why. This patch enables
> runtime power management even if an instance of the sg driver is held open.
> Enabling runtime PM for the sg driver is safe because all interactions of
> the sg driver with the SCSI device pass through the block layer
> (blk_execute_rq_nowait()) and the block layer already supports runtime PM.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Fixes: bc4f24014de5 ("[SCSI] implement runtime Power Management")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/sg.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f86be197fedd..84334ab39c81 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -307,10 +307,6 @@ sg_open(struct inode *inode, struct file *filp)
>   	if (retval)
>   		goto sg_put;
>   
> -	retval = scsi_autopm_get_device(device);
> -	if (retval)
> -		goto sdp_put;
> -
>   	/* scsi_block_when_processing_errors() may block so bypass
>   	 * check if O_NONBLOCK. Permits SCSI commands to be issued
>   	 * during error recovery. Tread carefully. */
> @@ -318,7 +314,7 @@ sg_open(struct inode *inode, struct file *filp)
>   	      scsi_block_when_processing_errors(device))) {
>   		retval = -ENXIO;
>   		/* we are in error recovery for this device */
> -		goto error_out;
> +		goto sdp_put;
>   	}
>   
>   	mutex_lock(&sdp->open_rel_lock);
> @@ -371,8 +367,6 @@ sg_open(struct inode *inode, struct file *filp)
>   	}
>   error_mutex_locked:
>   	mutex_unlock(&sdp->open_rel_lock);
> -error_out:
> -	scsi_autopm_put_device(device);
>   sdp_put:
>   	kref_put(&sdp->d_ref, sg_device_destroy);
>   	scsi_device_put(device);
> @@ -392,7 +386,6 @@ sg_release(struct inode *inode, struct file *filp)
>   	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
>   
>   	mutex_lock(&sdp->open_rel_lock);
> -	scsi_autopm_put_device(sdp->device);
>   	kref_put(&sfp->f_ref, sg_remove_sfp);
>   	sdp->open_cnt--;

(replying to my own email)

Can anyone please help with reviewing this patch? This patch is
important for Android. The Android security software uses the sg driver
to communicate with the UFS RPMB so this patch is required to enable
run-time power management in Android devices with UFS storage. See also
https://android.googlesource.com/platform/system/core/+/refs/heads/main/trusty/storage/proxy/rpmb.c

Thanks,

Bart.


