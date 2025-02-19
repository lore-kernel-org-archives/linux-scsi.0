Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D89257438
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 21:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002307; cv=none; b=jP4+AcZpUPnqDyengrZVveYRoX76QUef0cwLsd+pRZFuiIHaurz1WhDxPF2oqROoqEA04h6QcvnYRRQv/6YPdAvvkHj0uQmJwhhVKAbWqRG/GkVC1gtaK2TxBArDikCEQbYr37WS8UI4kZ89od2Q0e0XelJMYIp5WOjxtEARUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002307; c=relaxed/simple;
	bh=WQzMgzAoLmPbtL0kj6pLZHL1oMOXD8fqAb2aBpiDQjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nazofWyHdxLCh+m57dvFb7GiCJPzkCMqXSJzVztKzzMNyRfUcmwR9bBZ5vA9V7xbCDo6WkTiqElFukHNbgCJbS897+KRBtHGuf7zVOe3NGvQRhwvr0eOcEMqtYIToCo6dkMq/u7oVUhfHMBQOYUS1tyE8qxpawHWiCyC5te78iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQ7E2bc+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQ7E2bc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740002304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=73XdX3oQKc60afHTW9W+fXz+6Vo3O7FnSYg308eDq/Q=;
	b=EQ7E2bc+poUGitU8V6AOsFzVTCHmVL1kSo9246sLCLCB9KE1PZXJcGaDUvU9Z8Ja0JESvt
	nYsoE7RGAHrsG5K7NH2EkQrixInO2u/+FXkP7ioGvLEdcerYWze+JnLug0SIUrxBipO0YQ
	YvJBGkUCs7yb6O3XAehh/bky+W2WtTU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-zimW6qAVNpyuMZSq_2zk9Q-1; Wed,
 19 Feb 2025 16:58:21 -0500
X-MC-Unique: zimW6qAVNpyuMZSq_2zk9Q-1
X-Mimecast-MFC-AGG-ID: zimW6qAVNpyuMZSq_2zk9Q_1740002300
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42D4A1903089;
	Wed, 19 Feb 2025 21:58:20 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E094419412A3;
	Wed, 19 Feb 2025 21:58:18 +0000 (UTC)
Message-ID: <e34becca-c111-4eda-bed8-f0780079f3a2@redhat.com>
Date: Wed, 19 Feb 2025 16:58:17 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] scsi: scsi_debug: Reset tape setting at device
 reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
 <20250213092636.2510-7-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-7-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>


On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> Set tape block size, density and compression to default values when the
> device is reset (either directly or via target, bus or host reset).
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 0a5cd35c41de..7da1758da3f5 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6772,6 +6772,20 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
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
> @@ -6785,8 +6799,10 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
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
> @@ -6824,6 +6840,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
>   	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
>   		if (devip->target == sdp->id) {
>   			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> +			scsi_tape_reset_clear(devip);
>   			++k;
>   		}
>   	}
> @@ -6855,6 +6872,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
>   
>   	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
>   		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> +		scsi_tape_reset_clear(devip);
>   		++k;
>   	}
>   
> @@ -6878,6 +6896,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   		list_for_each_entry(devip, &sdbg_host->dev_info_list,
>   				    dev_list) {
>   			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> +			scsi_tape_reset_clear(devip);
>   			++k;
>   		}
>   	}

