Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36217271458
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 21:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749848728; cv=none; b=g8Gxkt86RDI/nPhVx7OkGX3Iw0EfgmT/TEftdQvmAhURT1WkqetruIArFKmqGjz0Jf5Ox1XJfjRZQiLVr9Xq+UZ0dtiy2+8iOeedguNvoBlMoWF4qboHrsa0kUR2BORHY4BSTUFhV/itego4ZaGvpWEAkGvUEk+nLpRn+PZJw9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749848728; c=relaxed/simple;
	bh=6b9uhCaucq1HR1ltLnDBNKjqEplDpXU2+ROBPXl5mPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N0XGYr58VaYLJyhTC9abPvYZ2ajUHy07kFkQM0HjNxE1HElEmkvGXL+mEiWwcz1c9c2F1qvujWs27sD6yTEeaDgdn7CNtrm2o77h3vfKkMA+dBE/h+ZuWX/CLP51Hvo0Ye7Dv4pfI2N3HoxrSk0xtVBPIMWs3J0A1PWwL6NlhzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cLNUEQDK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cLNUEQDK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749848724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZRoIjhYsGtN1dGwrD8GFpMgCRv/BQTfuHtUSNNekCg=;
	b=cLNUEQDKsufYNc8afAjcCVU5dvBiGWJu37uZ/5s8MhwcqF2Y+wAmjiEdWyrbWpgPkJ0fDN
	nMc9MRQlaZ+yvf/UF3mf6D9mtPDdfCWF1BS6aPCqAyyw0+aaYjmwJe9b8DG8WrBybcUKUY
	z1bqCui7knf6nbPuJPTYJgl+P9VNLzI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553--J9CdwW_N-STTexnbez1Wg-1; Fri,
 13 Jun 2025 17:05:20 -0400
X-MC-Unique: -J9CdwW_N-STTexnbez1Wg-1
X-Mimecast-MFC-AGG-ID: -J9CdwW_N-STTexnbez1Wg_1749848719
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADECF195608E;
	Fri, 13 Jun 2025 21:05:18 +0000 (UTC)
Received: from [10.22.89.154] (unknown [10.22.89.154])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D23A130044CC;
	Fri, 13 Jun 2025 21:05:15 +0000 (UTC)
Message-ID: <304247e3-8c09-4fd4-90a9-ec23fcba2420@redhat.com>
Date: Fri, 13 Jun 2025 17:05:14 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI
 ABTS paths
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, revers@redhat.com, dan.carpenter@linaro.org
References: <20250612221805.4066-1-kartilak@cisco.com>
 <20250612221805.4066-3-kartilak@cisco.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250612221805.4066-3-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>

On 6/12/25 6:18 PM, Karan Tilak Kumar wrote:
> Add logs in FDMI and FDMI ABTS paths.
> Modify log text in these paths.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_disc.c | 65 +++++++++++++++++++++++++++++++----
>   1 file changed, 58 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index 0ee1b74967b9..9e9939d41fa8 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -791,6 +791,7 @@ static uint8_t *fdls_alloc_init_fdmi_abts_frame(struct fnic_iport_s *iport,
>   static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
>   {
>   	uint8_t *frame;
> +	struct fnic *fnic = iport->fnic;
>   	unsigned long fdmi_tov;
>   	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
>   			sizeof(struct fc_frame_header);
> @@ -801,6 +802,9 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
>   		if (frame == NULL)
>   			return;
>   
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: FDLS send FDMI PLOGI abts. iport->fabric.state: %d oxid: 0x%x",
> +			 iport->fcid, iport->fabric.state, iport->active_oxid_fdmi_plogi);
>   		fnic_send_fcoe_frame(iport, frame, frame_size);
>   	} else {
>   		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
> @@ -809,6 +813,9 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
>   			if (frame == NULL)
>   				return;
>   
> +			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +				 "0x%x: FDLS send FDMI RHBA abts. iport->fabric.state: %d oxid: 0x%x",
> +				 iport->fcid, iport->fabric.state, iport->active_oxid_fdmi_rhba);
>   			fnic_send_fcoe_frame(iport, frame, frame_size);
>   		}
>   		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
> @@ -821,6 +828,9 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
>   					return;
>   			}
>   
> +			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +				 "0x%x: FDLS send FDMI RPA abts. iport->fabric.state: %d oxid: 0x%x",
> +				 iport->fcid, iport->fabric.state, iport->active_oxid_fdmi_rpa);
>   			fnic_send_fcoe_frame(iport, frame, frame_size);
>   		}
>   	}
> @@ -829,6 +839,10 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
>   	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
>   	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
>   	iport->fabric.fdmi_pending |= FDLS_FDMI_ABORT_PENDING;
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +		 iport->fcid, iport->fabric.fdmi_pending);
>   }
>   
>   static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
> @@ -2292,7 +2306,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
>   	spin_lock_irqsave(&fnic->fnic_lock, flags);
>   
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
> +		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
>   
>   	if (!iport->fabric.fdmi_pending) {
>   		/* timer expired after fdmi responses received. */
> @@ -2300,7 +2314,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
>   		return;
>   	}
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
> +		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
>   
>   	/* if not abort pending, send an abort */
>   	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
> @@ -2309,26 +2323,37 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
>   		return;
>   	}
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
> +		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
>   
>   	/* ABTS pending for an active fdmi request that is pending.
>   	 * That means FDMI ABTS timed out
>   	 * Schedule to free the OXID after 2*r_a_tov and proceed
>   	 */
>   	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			"FDMI PLOGI ABTS timed out. Schedule oxid free: 0x%x\n",
> +			iport->active_oxid_fdmi_plogi);
>   		fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_plogi);
>   	} else {
> -		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING)
> +		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
> +			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +						"FDMI RHBA ABTS timed out. Schedule oxid free: 0x%x\n",
> +						iport->active_oxid_fdmi_rhba);
>   			fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_rhba);
> -		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING)
> +		}
> +		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
> +			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +						"FDMI RPA ABTS timed out. Schedule oxid free: 0x%x\n",
> +						iport->active_oxid_fdmi_rpa);
>   			fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_rpa);
> +		}
>   	}
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
> +		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
>   
>   	fdls_fdmi_retry_plogi(iport);
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
> +		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
>   	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>   }
>   
> @@ -3743,12 +3768,26 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
>   
>   	switch (FNIC_FRAME_TYPE(oxid)) {
>   	case FNIC_FRAME_TYPE_FDMI_PLOGI:
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			"Received FDMI PLOGI ABTS rsp with oxid: 0x%x", oxid);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +			 iport->fcid, iport->fabric.fdmi_pending);
>   		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_plogi);
>   
>   		iport->fabric.fdmi_pending &= ~FDLS_FDMI_PLOGI_PENDING;
>   		iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +			 iport->fcid, iport->fabric.fdmi_pending);
>   		break;
>   	case FNIC_FRAME_TYPE_FDMI_RHBA:
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			"Received FDMI RHBA ABTS rsp with oxid: 0x%x", oxid);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +			 iport->fcid, iport->fabric.fdmi_pending);
> +
>   		iport->fabric.fdmi_pending &= ~FDLS_FDMI_REG_HBA_PENDING;
>   
>   		/* If RPA is still pending, don't turn off ABORT PENDING.
> @@ -3759,8 +3798,17 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
>   			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
>   
>   		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rhba);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +			 iport->fcid, iport->fabric.fdmi_pending);
>   		break;
>   	case FNIC_FRAME_TYPE_FDMI_RPA:
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			"Received FDMI RPA ABTS rsp with oxid: 0x%x", oxid);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +			 iport->fcid, iport->fabric.fdmi_pending);
> +
>   		iport->fabric.fdmi_pending &= ~FDLS_FDMI_RPA_PENDING;
>   
>   		/* If RHBA is still pending, don't turn off ABORT PENDING.
> @@ -3771,6 +3819,9 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
>   			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
>   
>   		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
> +			 iport->fcid, iport->fabric.fdmi_pending);
>   		break;
>   	default:
>   		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,

