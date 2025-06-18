Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3453E2F0032
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750267066; cv=none; b=m5LXkxrC2fg4P9BJWX+iI7SN+4ZNKsd302mNfKvH3vFNUklRPgZcAVbmoDwnRDyXy33/f+qJGR9qODc/zhWoE55Qdxd/aKtdIcq2n9cQMv02cc5I0BQ5OIBH64jsK+nGtsiGfxWc4fCe6bvly9RCEr+Au0rk8Q3ZAdy9K5ZexDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750267066; c=relaxed/simple;
	bh=gXXR7kgyY4SeGtwSs7b49R9w5BjiKKUl9+1pd35MjNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCED6lngNWQxMoiL3r6SGgj2UuCbsCfTMtUGqKVXF1mTsWSrx/SaNDishzvOBkZmXP2vgrrPueXzkjAWXIaVU7NSrp21lCVNF0EXTl02K/e//p+M74p38YXt6FjYNE7/V70EY5mzUxU1oQxNHDvrSFMEasnyayAMIrBjIoyoVeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F2S7FEnV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2S7FEnV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750267063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5cEFN65OmhFNR8F0AIk7bNFWAftwcBimGy3RuhXWUU=;
	b=F2S7FEnVh4pOsDqTeJMtClZPOocwi0imeLitufljhTSa/CUVez1+TX213Mqu1Cya4xiXIF
	jpkPmG7PKJUyQyDuqUVZG8dDj9GzPjZ+bIRcgl+VqBoPs+gUI/KsABMoiHUlwsuQscwufL
	6khVf/z2RzTm8MGX9Ok9buU/8j7zY8U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-P8WVlcaWPmutzaoBNlKk4Q-1; Wed,
 18 Jun 2025 13:17:37 -0400
X-MC-Unique: P8WVlcaWPmutzaoBNlKk4Q-1
X-Mimecast-MFC-AGG-ID: P8WVlcaWPmutzaoBNlKk4Q_1750267055
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9479E180136B;
	Wed, 18 Jun 2025 17:17:35 +0000 (UTC)
Received: from [10.22.64.21] (unknown [10.22.64.21])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A3DFB180045B;
	Wed, 18 Jun 2025 17:17:32 +0000 (UTC)
Message-ID: <62bfa26a-822b-462d-ba8d-e0d85610e278@redhat.com>
Date: Wed, 18 Jun 2025 13:17:31 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when
 FDMI times out
To: martin.petersen@oracle.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, revers@redhat.com,
 dan.carpenter@linaro.org, stable@vger.kernel.org, sebaddel@cisco.com,
 Karan Tilak Kumar <kartilak@cisco.com>
References: <20250618003431.6314-1-kartilak@cisco.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250618003431.6314-1-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Great Job.  Thanks Karan.

Reviewed-by: John Meneghini <jmeneghi@redhat.com>

Martin, if possible, please include these in 6.16/scsi-fixes.  These are critical bug fixes which are holding up the release of RHEL-9.7.

/John

On 6/17/25 8:34 PM, Karan Tilak Kumar wrote:
> When both the RHBA and RPA FDMI requests time out, fnic reuses a frame
> to send ABTS for each of them. On send completion, this causes an
> attempt to free the same frame twice that leads to a crash.
> 
> Fix crash by allocating separate frames for RHBA and RPA,
> and modify ABTS logic accordingly.
> 
> Tested by checking MDS for FDMI information.
> Tested by using instrumented driver to:
> Drop PLOGI response
> Drop RHBA response
> Drop RPA response
> Drop RHBA and RPA response
> Drop PLOGI response + ABTS response
> Drop RHBA response + ABTS response
> Drop RPA response + ABTS response
> Drop RHBA and RPA response + ABTS response for both of them
> 
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Tested-by: Arun Easi <aeasi@cisco.com>
> Co-developed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
> Changes between v5 and v6:
>      - Incorporate review comments from John:
> 	- Rebase patches on 6.17/scsi-queue
> 
> Changes between v4 and v5:
>      - Incorporate review comments from John:
> 	- Refactor patches
> 
> Changes between v3 and v4:
>      - Incorporate review comments from Dan:
> 	- Remove comments from Cc tag
> 
> Changes between v2 and v3:
>      - Incorporate review comments from Dan:
> 	- Add Cc to stable
> 
> Changes between v1 and v2:
>      - Incorporate review comments from Dan:
>          - Add Fixes tag
> ---
>   drivers/scsi/fnic/fdls_disc.c | 113 +++++++++++++++++++++++++---------
>   drivers/scsi/fnic/fnic.h      |   2 +-
>   drivers/scsi/fnic/fnic_fdls.h |   1 +
>   3 files changed, 87 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index f8ab69c51dab..36b498ad55b4 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -763,47 +763,69 @@ static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
>   	iport->fabric.timer_pending = 1;
>   }
>   
> -static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
> +static uint8_t *fdls_alloc_init_fdmi_abts_frame(struct fnic_iport_s *iport,
> +		uint16_t oxid)
>   {
> -	uint8_t *frame;
> +	struct fc_frame_header *pfdmi_abts;
>   	uint8_t d_id[3];
> +	uint8_t *frame;
>   	struct fnic *fnic = iport->fnic;
> -	struct fc_frame_header *pfabric_abts;
> -	unsigned long fdmi_tov;
> -	uint16_t oxid;
> -	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
> -			sizeof(struct fc_frame_header);
>   
>   	frame = fdls_alloc_frame(iport);
>   	if (frame == NULL) {
>   		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
>   				"Failed to allocate frame to send FDMI ABTS");
> -		return;
> +		return NULL;
>   	}
>   
> -	pfabric_abts = (struct fc_frame_header *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
> +	pfdmi_abts = (struct fc_frame_header *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
>   	fdls_init_fabric_abts_frame(frame, iport);
>   
>   	hton24(d_id, FC_FID_MGMT_SERV);
> -	FNIC_STD_SET_D_ID(*pfabric_abts, d_id);
> +	FNIC_STD_SET_D_ID(*pfdmi_abts, d_id);
> +	FNIC_STD_SET_OX_ID(*pfdmi_abts, oxid);
> +
> +	return frame;
> +}
> +
> +static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
> +{
> +	uint8_t *frame;
> +	unsigned long fdmi_tov;
> +	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
> +			sizeof(struct fc_frame_header);
>   
>   	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
> -		oxid = iport->active_oxid_fdmi_plogi;
> -		FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
> +		frame = fdls_alloc_init_fdmi_abts_frame(iport,
> +						iport->active_oxid_fdmi_plogi);
> +		if (frame == NULL)
> +			return;
> +
>   		fnic_send_fcoe_frame(iport, frame, frame_size);
>   	} else {
>   		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
> -			oxid = iport->active_oxid_fdmi_rhba;
> -			FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
> +			frame = fdls_alloc_init_fdmi_abts_frame(iport,
> +						iport->active_oxid_fdmi_rhba);
> +			if (frame == NULL)
> +				return;
> +
>   			fnic_send_fcoe_frame(iport, frame, frame_size);
>   		}
>   		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
> -			oxid = iport->active_oxid_fdmi_rpa;
> -			FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
> +			frame = fdls_alloc_init_fdmi_abts_frame(iport,
> +						iport->active_oxid_fdmi_rpa);
> +			if (frame == NULL) {
> +				if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING)
> +					goto arm_timer;
> +				else
> +					return;
> +			}
> +
>   			fnic_send_fcoe_frame(iport, frame, frame_size);
>   		}
>   	}
>   
> +arm_timer:
>   	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
>   	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
>   	iport->fabric.fdmi_pending |= FDLS_FDMI_ABORT_PENDING;
> @@ -2245,6 +2267,21 @@ void fdls_fabric_timer_callback(struct timer_list *t)
>   	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>   }
>   
> +void fdls_fdmi_retry_plogi(struct fnic_iport_s *iport)
> +{
> +	struct fnic *fnic = iport->fnic;
> +
> +	iport->fabric.fdmi_pending = 0;
> +	/* If max retries not exhausted, start over from fdmi plogi */
> +	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
> +		iport->fabric.fdmi_retry++;
> +		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +					 "Retry FDMI PLOGI. FDMI retry: %d",
> +					 iport->fabric.fdmi_retry);
> +		fdls_send_fdmi_plogi(iport);
> +	}
> +}
> +
>   void fdls_fdmi_timer_callback(struct timer_list *t)
>   {
>   	struct fnic_fdls_fabric_s *fabric = timer_container_of(fabric, t,
> @@ -2291,14 +2328,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
>   		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
>   
> -	iport->fabric.fdmi_pending = 0;
> -	/* If max retries not exhaused, start over from fdmi plogi */
> -	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
> -		iport->fabric.fdmi_retry++;
> -		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> -					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
> -		fdls_send_fdmi_plogi(iport);
> -	}
> +	fdls_fdmi_retry_plogi(iport);
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
>   		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
>   	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> @@ -3716,11 +3746,32 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
>   	switch (FNIC_FRAME_TYPE(oxid)) {
>   	case FNIC_FRAME_TYPE_FDMI_PLOGI:
>   		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_plogi);
> +
> +		iport->fabric.fdmi_pending &= ~FDLS_FDMI_PLOGI_PENDING;
> +		iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
>   		break;
>   	case FNIC_FRAME_TYPE_FDMI_RHBA:
> +		iport->fabric.fdmi_pending &= ~FDLS_FDMI_REG_HBA_PENDING;
> +
> +		/* If RPA is still pending, don't turn off ABORT PENDING.
> +		 * We count on the timer to detect the ABTS timeout and take
> +		 * corrective action.
> +		 */
> +		if (!(iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING))
> +			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
> +
>   		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rhba);
>   		break;
>   	case FNIC_FRAME_TYPE_FDMI_RPA:
> +		iport->fabric.fdmi_pending &= ~FDLS_FDMI_RPA_PENDING;
> +
> +		/* If RHBA is still pending, don't turn off ABORT PENDING.
> +		 * We count on the timer to detect the ABTS timeout and take
> +		 * corrective action.
> +		 */
> +		if (!(iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING))
> +			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
> +
>   		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
>   		break;
>   	default:
> @@ -3730,10 +3781,16 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
>   		break;
>   	}
>   
> -	timer_delete_sync(&iport->fabric.fdmi_timer);
> -	iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
> -
> -	fdls_send_fdmi_plogi(iport);
> +	/*
> +	 * Only if ABORT PENDING is off, delete the timer, and if no other
> +	 * operations are pending, retry FDMI.
> +	 * Otherwise, let the timer pop and take the appropriate action.
> +	 */
> +	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
> +		timer_delete_sync(&iport->fabric.fdmi_timer);
> +		if (!iport->fabric.fdmi_pending)
> +			fdls_fdmi_retry_plogi(iport);
> +	}
>   }
>   
>   static void
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 6c5f6046b1f5..86e293ce530d 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -30,7 +30,7 @@
>   
>   #define DRV_NAME		"fnic"
>   #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.8.0.0"
> +#define DRV_VERSION		"1.8.0.1"
>   #define PFX			DRV_NAME ": "
>   #define DFX                     DRV_NAME "%d: "
>   
> diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
> index 8e610b65ad57..531d0b37e450 100644
> --- a/drivers/scsi/fnic/fnic_fdls.h
> +++ b/drivers/scsi/fnic/fnic_fdls.h
> @@ -394,6 +394,7 @@ void fdls_send_tport_abts(struct fnic_iport_s *iport,
>   bool fdls_delete_tport(struct fnic_iport_s *iport,
>   		       struct fnic_tport_s *tport);
>   void fdls_fdmi_timer_callback(struct timer_list *t);
> +void fdls_fdmi_retry_plogi(struct fnic_iport_s *iport);
>   
>   /* fnic_fcs.c */
>   void fnic_fdls_init(struct fnic *fnic, int usefip);

