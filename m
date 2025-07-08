Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CE5221F26
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751964864; cv=none; b=RZTbmQyIMjAcTRPRtjm95maMZ+Orf0RAg/G96mAxRnZikKP8/Vdp194yOwzMjI2FQsaKnu02WAOvkdHRKyiqXHgw8TIWaVtvhZHibwprGUJ3Rwghd9VgaEFec0QoGjN7qhsd6pHlZGDV5AKSkb9Tce/+6MZQ16MWF72vDH7AhH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751964864; c=relaxed/simple;
	bh=O1J5164GRZX3C3L3/oZcPhL2fxdhGXIDUGXzkOzE9/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tVCpFCi4L0OWjZhgpCzA9GK256q9sqnFBWf4+IhYMiTGx1Zof6YyiNgYGSYKpCKo5gTvofvqWo2bYUZlP0tgGuTwc49tqhjt9tS2msrCGiWKxbFAp5PBpqjFFIW/QZVonKqA+rJdANrw7gzDLN79JZ3c9Ww1saB89DXZQoH2FsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w7DaIhBw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hXmytn9B; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w7DaIhBw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hXmytn9B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w7DaIhBw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hXmytn9B";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w7DaIhBw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hXmytn9B"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 248822117C;
	Tue,  8 Jul 2025 08:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751964860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DQLyyno1Vtj5Qcrm9Ui7niuTGMfPg+TxwX22SQW9X0=;
	b=w7DaIhBwQXlUPZ8D3yVdvNGhU+bA8SdiyzjTyXV08JqTQPfZRJw8qahIzFCa4Ms0EyuP4r
	r/hEw0AeVPdX8SYyNBOQCXYn8OIosb5QvZnTsWwDKBmD4lljD0KnTh6AqlZ3vvbbJcSKHw
	AbdBjWPocpECMYAVFE+w+6D+YfTft7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751964860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DQLyyno1Vtj5Qcrm9Ui7niuTGMfPg+TxwX22SQW9X0=;
	b=hXmytn9BcZeOntHu4uAtezPOLx5ZTdq96m0ap/CsOK+zxVM+ON+fGgGhX4mAYtccbTxaBD
	9DusXAUPz8YMGfDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w7DaIhBw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hXmytn9B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751964860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DQLyyno1Vtj5Qcrm9Ui7niuTGMfPg+TxwX22SQW9X0=;
	b=w7DaIhBwQXlUPZ8D3yVdvNGhU+bA8SdiyzjTyXV08JqTQPfZRJw8qahIzFCa4Ms0EyuP4r
	r/hEw0AeVPdX8SYyNBOQCXYn8OIosb5QvZnTsWwDKBmD4lljD0KnTh6AqlZ3vvbbJcSKHw
	AbdBjWPocpECMYAVFE+w+6D+YfTft7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751964860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DQLyyno1Vtj5Qcrm9Ui7niuTGMfPg+TxwX22SQW9X0=;
	b=hXmytn9BcZeOntHu4uAtezPOLx5ZTdq96m0ap/CsOK+zxVM+ON+fGgGhX4mAYtccbTxaBD
	9DusXAUPz8YMGfDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD0C913A68;
	Tue,  8 Jul 2025 08:54:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LRMzNbvcbGhOXwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 08:54:19 +0000
Message-ID: <42943746-771e-432e-b5e0-98267987ed65@suse.de>
Date: Tue, 8 Jul 2025 10:54:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when
 FDMI times out
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, jmeneghi@redhat.com, revers@redhat.com,
 dan.carpenter@linaro.org, stable@vger.kernel.org
References: <20250616162632.4835-1-kartilak@cisco.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250616162632.4835-1-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 248822117C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 6/16/25 18:26, Karan Tilak Kumar wrote:
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
> index c2b6f4eb338e..0ee1b74967b9 100644
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
> @@ -2244,6 +2266,21 @@ void fdls_fabric_timer_callback(struct timer_list *t)
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
>   	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, fdmi_timer);
> @@ -2289,14 +2326,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
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
> @@ -3714,11 +3744,32 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
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
> @@ -3728,10 +3779,16 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
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

Please make the version change a separate patch and add it as the last 
patch in the series. That way you'll have better tracking if all patches
from that series are applied.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
