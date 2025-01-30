Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BAC1F130B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 21:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738274295; cv=none; b=uSVRGFtf9UariUGro1zvm8t+XT4kwfdb5Lmb4taXknkueulHZCHfZarT+ekNgI0uxg/e4lx8avAaMouW/k/VtgCpSgv6Oby6Hyv73gRgRqTesWgRTJtLgCVyUmQCETtC/cNo3Mr1aRPrPGYBbHCXq/YG8e7Sfir4+t9Ul1hebKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738274295; c=relaxed/simple;
	bh=Xl29Ie2yZ+GM6WHT4h6iIz5V3d4fZuTzL0G69rkFn9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=egISgxgtLh7dJtuT/9OP2n3MPhUQpVyVP5hn3BmMbB7Oyx8YALm5Yvj4e2oW8/bdq3vZbRG5Veq+nNzR/jW7Mvvh9MPC8NO9gh3STIvfOv3yXal+ICuxvHdg6EAbasqVmF1SQr6B4DFUqXTxm1hKlXsna60A93mFd4YGvMlIWCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QmJJOD+B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QmJJOD+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738274293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDliS6YqXyc9XgvbmzdA6PzcrG3tRbwYtg8wwmvdQpI=;
	b=QmJJOD+BwvtOsrfhpCAZB1XWkZD/WpxU7TBlT4FYA4w9sLP8Nzvk5AYnkpB7p3FCt/hjBW
	U3OZ8mxC1qADP9wQCgbC4tqoCQMu5jvJXk5ONl0Nribsron721B2ZGjSXoPiDIEVxBWclF
	eu4u+upWZhZJD8v1J9muHbpnCEy0/rg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-iw6KKnANONGfcU11g3hgsw-1; Thu,
 30 Jan 2025 16:58:09 -0500
X-MC-Unique: iw6KKnANONGfcU11g3hgsw-1
X-Mimecast-MFC-AGG-ID: iw6KKnANONGfcU11g3hgsw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E41919560A1;
	Thu, 30 Jan 2025 21:58:08 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 690D819560A3;
	Thu, 30 Jan 2025 21:58:07 +0000 (UTC)
Message-ID: <e674e7ff-75d7-4df8-a16f-33484a01a734@redhat.com>
Date: Thu, 30 Jan 2025 16:58:06 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/6] scsi: scsi_debug: Reset tape setting at device
 reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-7-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com
In-Reply-To: <20250128142250.163901-7-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Kai, thank you for your patches.  These are much needed improvements to the
scsi_debug tape emulator. With these changes I find that my scsi_debug tests
are now actually useful!

I've created a bunch of improvements to my tape_reset_debug_sg.sh test at:

https://github.com/johnmeneghini/tape_tests/pull/1

These changes to my tape_tests have been tested with and are dependant upon your patches at:

https://lore.kernel.org/linux-scsi/20250128142250.163901-1-Kai.Makisara@kolumbus.fi/T/#t
-and-
https://lore.kernel.org/linux-scsi/20250120194925.44432-1-Kai.Makisara@kolumbus.fi/T/#t

Martin, please merge these patches.

/John

On 1/28/25 9:22 AM, Kai Mäkisara wrote:
> Set tape block size, density and compression to default values when the
> device is reset (either directly or via target, bus or host reset).
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index ceacf38cee71..c5d7e8b59ff2 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6730,6 +6730,20 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
>   	return 0;
>   }
>   
> +static void scsi_tape_reset_clear(struct sdebug_dev_info *devip)
> +{
> +	if (sdebug_ptype == TYPE_TAPE) {
> +		int i;
> +
> +		devip->tape_blksize = TAPE_DEF_BLKSIZE;
> +		devip->tape_density = TAPE_DEF_DENSITY;
> +		devip->tape_partition = 0;
> +		devip->tape_dce = 0;
> +		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
> +			devip->tape_location[i] = 0;
> +	}
> +}
> +
>   static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
>   {
>   	struct scsi_device *sdp = SCpnt->device;
> @@ -6743,8 +6757,10 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
>   		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
>   
>   	scsi_debug_stop_all_queued(sdp);
> -	if (devip)
> +	if (devip) {
>   		set_bit(SDEBUG_UA_POR, devip->uas_bm);
> +		scsi_tape_reset_clear(devip);
> +	}
>   
>   	if (sdebug_fail_lun_reset(SCpnt)) {
>   		scmd_printk(KERN_INFO, SCpnt, "fail lun reset 0x%x\n", opcode);
> @@ -6782,6 +6798,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
>   	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
>   		if (devip->target == sdp->id) {
>   			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> +			scsi_tape_reset_clear(devip);
>   			++k;
>   		}
>   	}
> @@ -6813,6 +6830,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
>   
>   	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
>   		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> +		scsi_tape_reset_clear(devip);
>   		++k;
>   	}
>   
> @@ -6836,6 +6854,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   		list_for_each_entry(devip, &sdbg_host->dev_info_list,
>   				    dev_list) {
>   			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> +			scsi_tape_reset_clear(devip);
>   			++k;
>   		}
>   	}

