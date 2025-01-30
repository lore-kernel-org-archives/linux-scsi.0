Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BD584D34
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738260833; cv=none; b=a227fBrdtJeNrcIqZxPGKnAQyF3OZcwfyEZl8sdrp4+1JCAL6gnmpPm9gFCfkgfVtitCU/stavrlbGyfJyeFdbpXKywMpp+9hODYwznV77g75H5q33OxEliL19f0PVuRz8Zu/Tew4SdYlnJDM38cGluwrBWlJkMnU9cKdm7ECpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738260833; c=relaxed/simple;
	bh=1SGZYsAKrX7NQQWU1oCwFM9Tj+3iQyVZsLaYi/Mh3kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofyBY45pIFBK6r8bqfq2+OHtz7PQt/XgZ2JOoKhuGTTUYMrgQPmwpIKKYem2pjGvW+EX9OL//mY1bmOAwsGWkGTyOzp157D5mDSuaUFeWcuSS6WcZQy888/qgRtCwSmsjbHhtBAlo48W2Fe5T9zOhmK3mpVlTam2jeEELYrM+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUUxScEF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUUxScEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738260830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QV/s47sHIX6/nmzVSs4prr8l9mDV9GkxtDn2FxTvvhE=;
	b=CUUxScEFq5WdiNK4kNpfu3YFHcr2qxjtX/mkyJTDtoDjWnnqATnmc4mbTFitI/HeNrpLh8
	hio6/HAqVLwVacGIlsMSdDHPR1fO+/PBvnH5OjsipHmLuKgg0XugzxSmCL663nAvEN5AsC
	P8RZR59RkIrkFdhtPiQIKBeufGnYsxA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-ijUg0kyoMtOtP0Fp4oh2lA-1; Thu,
 30 Jan 2025 13:13:43 -0500
X-MC-Unique: ijUg0kyoMtOtP0Fp4oh2lA-1
X-Mimecast-MFC-AGG-ID: ijUg0kyoMtOtP0Fp4oh2lA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3418F19560B2;
	Thu, 30 Jan 2025 18:13:42 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 401CD1800267;
	Thu, 30 Jan 2025 18:13:40 +0000 (UTC)
Message-ID: <b35750e2-ddee-4f67-9f4e-fca24ca3a187@redhat.com>
Date: Thu, 30 Jan 2025 13:13:39 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] scsi: scsi_error: Add counters for New Media and
 Power On/Reset UNIT ATTENTIONs
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, loberman@redhat.com
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
 <20250120194925.44432-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250120194925.44432-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 1/20/25 2:49 PM, Kai Mäkisara wrote:
> The purpose of the counters is to enable all ULDs attached to a
> device to find out that a New Media or/and Power On/Reset Unit
> Attentions has/have been set, even if another ULD catches the
> Unit Attention as response to a SCSI command.
> 
> The ULDs can read the counters and see if the values have changed from
> the previous check.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_error.c  | 12 ++++++++++++
>   include/scsi/scsi_device.h |  3 +++
>   2 files changed, 15 insertions(+)
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
> index 9c540f5468eb..f5c0f07a053a 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -247,6 +247,9 @@ struct scsi_device {
>   	unsigned int queue_stopped;	/* request queue is quiesced */
>   	bool offline_already;		/* Device offline message logged */
>   
> +	u16 ua_new_media_ctr;		/* Counter for New Media UNIT ATTENTIONs */
> +	u16 ua_por_ctr;			/* Counter for Power On / Reset UAs */
> +
>   	atomic_t disk_events_disable_depth; /* disable depth for disk events */
>   
>   	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */

