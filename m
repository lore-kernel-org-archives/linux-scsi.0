Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8501EC4F6
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 21:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954252; cv=none; b=LFv5cZtj2nqkxcZo44rp9GLHyuuvpWita4ZTy4LqKAOzpMp5epcoqF0Ne1aEIC4VFcMdZVZhYrtDo/8EtkkCzQ92lesSob6Ae4LhY1kA6hyucOKhxKvGiakkskKJv8ns0zpwvAJxCdw7UOqz6e0JGETrKAlYfq31u4lgoAGyZLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954252; c=relaxed/simple;
	bh=7MzIyv8Rw5FFldW530oSKpQK6JlSNYy5ufbzLYm2ckE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLmkpPXGuuVgerr0xvLtkO1y7r0OwqiwisdmP9H8mMlt1B3MKVDyibcwwrBTT5YH7TTlt/t0YOVfUDi5MbeAQK+aCDJToKsN8E7JzAkY+SW1R9tkRxVJ7f07a0+kuh/dI6FnnpGgAJSJX6XA2JXB1Bsdb4aq98bS94CbDeIdLaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2s57VHE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2s57VHE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733954247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SE7AcAeaxV0Mj2DU1Wb5h+M4CLznHN/l9NVB56KLBo0=;
	b=O2s57VHEiqYNib1615hEfiz0YA2faGqoP+6NyNgy/c6Opwkk2CK60+9cMf0oTmBqxKWQWj
	Zut/d+eeIGiQSnEeIxKbGbSA0HSJXTE2rqyxxfT655WzrdXdxlFy1rNY4Z8ZksQK8UyjaU
	5iUv755MNKSiYiW7oPsCekI2sLpY7qo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-0DL_IthOOo28bdAtZg0aFw-1; Wed,
 11 Dec 2024 16:57:24 -0500
X-MC-Unique: 0DL_IthOOo28bdAtZg0aFw-1
X-Mimecast-MFC-AGG-ID: 0DL_IthOOo28bdAtZg0aFw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BE71956095;
	Wed, 11 Dec 2024 21:57:23 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E2243000199;
	Wed, 11 Dec 2024 21:57:22 +0000 (UTC)
Message-ID: <05de7fab-2139-454d-9f5e-2ac36508e88e@redhat.com>
Date: Wed, 11 Dec 2024 16:57:22 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] scsi: scsi_error: Add counters for New Media and
 Power On/Reset UNIT ATTENTIONs
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <20241125140301.3912-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241125140301.3912-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 11/25/24 09:02, Kai Mäkisara wrote:
> The purpose of the counters is to enable all ULDs attached to a
> device to find out that a New Media or/and Power On/Reset Unit
> Attentions has/have been set, even if another ULD catches the
> Unit Attention as response to a SCSI command.
> 
> The ULDs can read the counters using the scsi_get_ua_new_media_ctr()
> and scsi_get_ua_por_ctr() macros (argument pointer to the scsi_device
> struct).
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_error.c  | 12 ++++++++++++
>   include/scsi/scsi_device.h |  9 +++++++++
>   2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 10154d78e336..6ef0711c4ec3 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -547,6 +547,18 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>   
>   	scsi_report_sense(sdev, &sshdr);
>   
> +	if (sshdr.sense_key == UNIT_ATTENTION) {
> +		/*
> +		 * increment the counters for Power on/Reset or New Media so
> +		 * that all ULDs interested in these can see that those have
> +		 * happened, even if someone else gets the sense data.
> +		 */
> +		if (sshdr.asc == 0x28)
> +			scmd->device->ua_new_media_ctr++;
> +		else if (sshdr.asc == 0x29)
> +			scmd->device->ua_por_ctr++;
> +	}
> +
>   	if (scsi_sense_is_deferred(&sshdr))
>   		return NEEDS_RETRY;
>   
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 9c540f5468eb..b184a5efc27e 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -247,6 +247,9 @@ struct scsi_device {
>   	unsigned int queue_stopped;	/* request queue is quiesced */
>   	bool offline_already;		/* Device offline message logged */
>   
> +	unsigned char ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTIONs */
> +	unsigned char ua_por_ctr;	/* Counter for Power On / Reset UAs */
> +
>   	atomic_t disk_events_disable_depth; /* disable depth for disk events */
>   
>   	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
> @@ -684,6 +687,12 @@ static inline int scsi_device_busy(struct scsi_device *sdev)
>   	return sbitmap_weight(&sdev->budget_map);
>   }
>   
> +/* Macros to access the UNIT ATTENTION counters */
> +#define scsi_get_ua_new_media_ctr(sdev) \
> +	((const unsigned int)(sdev->ua_new_media_ctr))
> +#define scsi_get_ua_por_ctr(sdev) \
> +	((const unsigned int)(sdev->ua_por_ctr))
> +
>   #define MODULE_ALIAS_SCSI_DEVICE(type) \
>   	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
>   #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"

