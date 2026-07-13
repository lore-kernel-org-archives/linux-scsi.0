Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6650E270552
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783966068; cv=none; b=XhT3TxTnen7Xp/f1yYx6xctMScRM7tULaHdoQrbpXZOezGqpZUK9QNH45VD0litahKv46e24nSgAk48vscXjcXEIzyYN8WDTPVKOMFffCgN9EV1uuu6IVZguxw0+yXpkQEwBn4io5Ms+JEvHt1EmTmSiN0ZjglSoJfwf+YpYPMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783966068; c=relaxed/simple;
	bh=9jXOE3cnpKV0SrWXKUIOsJBwnB01t8vrC8J+fOQUeMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGeM32x4o9Dctt5dH5AlOueDCbRYp4mnyH/f8rngJyVNlHe3l6ePrGbVEtzCcUu05h3YRptLCX0i397nJhjqTSm7Ecik5gx8wl9+sMbWj3GgUGxjrY0gv2bAf7JafPrrbla4bpWezynCw5Yx18AD5raKXxrEd/lvgF0F24cNYD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ln7GBtWx; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ln7GBtWx"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cab97c86bdso11235ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783966067; x=1784570867; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+qVbRp+HK6CwM5MQDi7Qzigzhk3NjlBw18NuSK0e1UA=;
        b=ln7GBtWxRrDx0ncOQvBM5AH+N+Lg+lVrHIv0ZrqubCI7/WodVyACHBLdE2mmDNYcZR
         M7adaTrCxznQ1sBUKwPq0OL7ks83U6M/nAyrwr6B/0RO7bPRRyNYUC9upwRlowKZ1L29
         iHbzsnmhPp6sgLSUseoapLE1dHdI8pFSNcVZ48QZ7M359PQDEpW1VHyCdDvtJmr+BT7J
         siDXmg8wWWzjjLGJXPIV3YSewvZQ+oPH8GE6SnDQ3LuyRCr4fCotWc5IUtnzCoCEiclr
         6r9k9sXR+z4mMoqYE0kV2AyM6mDIS/dHmTgJJQoUC3FLhwt7jKmpUA4o1LlNXPojFvwn
         nGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783966067; x=1784570867;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+qVbRp+HK6CwM5MQDi7Qzigzhk3NjlBw18NuSK0e1UA=;
        b=mz03J3j0ku7Y7EXXQFG68wo+gpS30rD74oc/1pJqoCM/nt8lC2F74gYKfLcu6lW6VU
         481nCGz7FRsGJ+NR+KUcxc4nGri9Ld31mcv6/xrMHj4kFzOAVYpvJnew8bjwklop8xmB
         cBT4Srofam4Hf9NiL96XokCKqHY9QO4tUlc5kdheEl9aadPqouf8ICSgfdWxS9jJ/Ifg
         ZMaVStVw3wr4Xdj3x4C/c7kNdZnQhrElFO6MeuxDE8TYJmS/9gvAgIsrJ0uBWEIhlFyu
         3nBfYmJtm4V+2gHK/7XuN/Z7bdLHM/tJr2Xteoi3cB1Q+C12jp5eHuxhJBG5hO9CdDfJ
         KxdQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqk5OReRBFj3CTUN6VpXnsxveXzRceOI2rfzzJnG4dIrReBZl2Vjs2LLW72BohJq2Ut+tcWXKCJaifX@vger.kernel.org
X-Gm-Message-State: AOJu0Yw46CFY6cuaMwXfJoN6a0T79+3fGUUwrxgW3lX3Yb7sTzSRuqHA
	9BO80z4C+7RBDficNeHB63mk/OVnJoO1gFp9505nwI1lc3Cifj6O1nHKrdeqqceHwA==
X-Gm-Gg: AfdE7cnT7xfHUcCt+aqLjj5to39pFe5btYfyfrqVmiUIBYScXiX4SlDmCorUOMeNJq8
	c2tx5Ivf4E7Fexzc7ddKapjtzsvA6IIJ7BxPz5KLi3+sr+Th6x6Wb0T0h7BQk1t9gMcrUMXeAIK
	9w7l0NO87esi0bljUFK7reLWSOeDqxdB+TD4JQa41P92/SAPGrlOT/Ip4gvx1c/FslYS2ls/2RN
	RkWQXfLGtzcqCRNRIOBK9kEsHiwh2pXfaZvOwHkiHZ+XLtWviZ2KfphldtapnpVJlO7frvtt3hx
	gek4CqLdOK2zlkvDHGLo26PKjlSYxc/bo3PhmdILwumR50wY0dZ/jPQ2/fchk+Pe/fvK5jBUcbo
	sQuZI/SmOvnpXzBCSHWgDtI4HtKiWyBynyo10V1p/4pbHi+22XVaVSr+Coy+2NHp5l9zC2Hrm+3
	lJgjBcgB+nVbC7d7VGiWerAk4GfD9+3L4N4PvAlMSbNBbgEDO9BwwQdoO9YU0=
X-Received: by 2002:a17:903:120e:b0:2ce:7ae6:2a23 with SMTP id d9443c01a7336-2cee1cea1b1mr2289125ad.27.1783966066150;
        Mon, 13 Jul 2026 11:07:46 -0700 (PDT)
Received: from google.com (249.65.83.34.bc.googleusercontent.com. [34.83.65.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e17470008sm241847a91.17.2026.07.13.11.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 11:07:45 -0700 (PDT)
Date: Mon, 13 Jul 2026 11:07:41 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v3 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <alUpbYeKFLrPvlFQ@google.com>
References: <20260713041252.463401-1-dlemoal@kernel.org>
 <20260713041252.463401-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713041252.463401-2-dlemoal@kernel.org>

On Mon, Jul 13, 2026 at 01:12:51PM +0900, Damien Le Moal wrote:
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred command is never issued nor completed, thus leaving this
> command to always be counted as "busy" for the SCSI host. This results in
> the test "shost->host_failed != scsi_host_busy(shost))" in the function
> scsi_error_handler() to always be true, keeping the EH task sleeping.
> Eventually, when the deferred command also times out, the SCSI EH task
> is woken up and the timeout processing occurs.
> 
> Avoid this unnecessary SCSI EH task wake-up additional time using the
> eh_timed_out SCSI host template operation. The function
> ata_scsi_eh_timed_out() is introduced to implement this operation. This
> function calls the new helper ata_eh_schedule_deferred_qc_retry() to
> schedule a retry through libata EH of all differed queued command, except
> for a differed queued commands that timed out as that case is handled in
> ata_scsi_cmd_error_handler().
> 
> Since ata_scsi_eh_timed_out() does not directly handles the timeout itself
> and eventual re-issuing of deferred commands, this function returns
> SCSI_EH_NOT_HANDLED to have scsi_timeout() continue with the regular
> timeout handling, using scsi_abort_command() and scsi_eh_scmd_add(), thus
> preventing the wkae-up delay for SCSI EH task.
> 
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-eh.c   | 35 ++++++++++++++++++++++++++++++++++-
>  drivers/ata/libata-scsi.c | 22 ++++++++++++++++++++++
>  drivers/ata/libata.h      |  2 ++
>  include/linux/libata.h    |  2 ++
>  4 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 05df7ea6954a..8e9d57c6f039 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -546,6 +546,31 @@ static void ata_eh_unload(struct ata_port *ap)
>  	spin_unlock_irqrestore(ap->lock, flags);
>  }
>  
> +void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
> +				       struct scsi_cmnd *scmd)
> +{
> +	struct ata_queued_cmd *qc;
> +	struct ata_link *link;
> +	unsigned long flags;
> +
> +	/*
> +	 * Trigger EH for retrying any deferred qc that is not the queued
> +	 * command for scmd.
> +	 */
> +	spin_lock_irqsave(ap->lock, flags);
> +	ata_for_each_link(link, ap, PMP_FIRST) {
> +		qc = link->deferred_qc;
> +		if (!qc || qc->scsicmd == scmd)
> +			continue;
> +
> +		link->deferred_qc = NULL;
> +		cancel_work(&link->deferred_qc_work);
> +		qc->flags |= ATA_QCFLAG_RETRY;


Gemini pointed out an issue:

ata_scsi_cmd_error_handler() would skip this command because
ATA_QCFLAG_ACTIVE flag is not set and qc != qc->dev->link->deferred_qc
because ata_eh_schedule_deferred_qc_retry() set link->deferred_qc to NULL.

https://github.com/torvalds/linux/blob/master/drivers/ata/libata-eh.c#L655-L657


> +		ata_qc_schedule_eh(qc);
> +	}
> +	spin_unlock_irqrestore(ap->lock, flags);
> +}
> +
>  /**
>   *	ata_scsi_error - SCSI layer error handler callback
>   *	@host: SCSI host on which error occurred
> @@ -1214,9 +1239,17 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
>  	struct scsi_cmnd *scmd = qc->scsicmd;
>  	unsigned long flags;
>  
> +
> +	/*
> +	 * If we are retrying a deferred QC after a timeout, it is not active
> +	 * and all we need to do is to complete it directly.
> +	 */
>  	spin_lock_irqsave(ap->lock, flags);
>  	qc->scsidone = ata_eh_scsidone;
> -	__ata_qc_complete(qc);
> +	if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))
> +		qc->complete_fn(qc);
> +	else
> +		__ata_qc_complete(qc);
>  	WARN_ON(ata_tag_valid(qc->tag));
>  	spin_unlock_irqrestore(ap->lock, flags);
>  
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 5868526301a2..89ef2eef72a0 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1730,6 +1730,28 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
>  		queue_work(system_highpri_wq, &link->deferred_qc_work);
>  }
>  
> +enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
> +{
> +	struct ata_port *ap = ata_shost_to_port(scmd->device->host);
> +
> +	/*
> +	 * ata_scsi_cmd_error_handler() takes care of timed-out deferred queued
> +	 * commands. However, if we had any other command time out and we have
> +	 * deferred queued commands, we must let scsi_timeout() handle them
> +	 * with scsi_eh_scmd_add() so that we do not unnecessarilly delay
> +	 * starting the SCSI EH task. So schedule all deferred queued commands
> +	 * for retry through EH.
> +	 */
> +	ata_eh_schedule_deferred_qc_retry(ap, scmd);
> +
> +	/*
> +	 * Let scsi_timeout() know that it must continue with handling the
> +	 * timeout as we in fact did not do much here.
> +	 */
> +	return SCSI_EH_NOT_HANDLED;
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_eh_timed_out);
> +
>  static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
>  {
>  	struct ata_link *link = qc->dev->link;
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 700627596ce1..e1fdecd93ccf 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -198,6 +198,8 @@ extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
>  			       unsigned int action);
>  extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
>  			unsigned int action);
> +void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
> +				       struct scsi_cmnd *scmd);
>  extern void ata_eh_autopsy(struct ata_port *ap);
>  const char *ata_get_cmd_name(u8 command);
>  extern void ata_eh_report(struct ata_port *ap);
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 96e626d6a7ca..327da43d7496 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1153,6 +1153,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
>  #endif
>  extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
>  					     struct scsi_cmnd *cmd);
> +enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
>  #if IS_REACHABLE(CONFIG_ATA)
>  bool ata_scsi_dma_need_drain(struct request *rq);
>  #else
> @@ -1464,6 +1465,7 @@ extern const struct attribute_group *ata_common_sdev_groups[];
>  	.ioctl			= ata_scsi_ioctl,		\
>  	ATA_SCSI_COMPAT_IOCTL					\
>  	.queuecommand		= ata_scsi_queuecmd,		\
> +	.eh_timed_out		= ata_scsi_eh_timed_out,	\
>  	.dma_need_drain		= ata_scsi_dma_need_drain,	\
>  	.this_id		= ATA_SHT_THIS_ID,		\
>  	.emulated		= ATA_SHT_EMULATED,		\
> -- 
> 2.55.0
> 
