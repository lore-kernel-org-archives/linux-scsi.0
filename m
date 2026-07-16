Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F333FE65F
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209592; cv=none; b=AP3No837hfIScWE3FVt4D0kh423HHTh2AiDiXMsGECd333XNN9+H0wf23PyuHIbAPdMY5qbvbykN7+GcxQwh5P3nyxV1wLs7u1Pt5kwgC+rJ9hMRrAISeebVGoRvjxCGMPkhy1TUmw22b0TVobe5vn+HQags0R+vey313fh0rm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209592; c=relaxed/simple;
	bh=OeHc1Tm2mbq8Crsz/kuw/NXKNQeCHjyYO6vsG7zdQvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hpdkPqGci96mM4clsVO2s2yf6VN6CLjyG71VuPpVAqjjkOlfPyIhSXlEvfGO6ygYIJZIzbma/pKUOJnwznqTPsKU5hHdI7q8EpTc5GLJcZqzvkQuQhpt2qkfY2XSPdhjvNMPAqIm1SBad5zCewyCp5Ol7AJqiHIKEa2cpylsjCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dq97WEFO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hKidRiMh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dq97WEFO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hKidRiMh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dq97WEFO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hKidRiMh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dq97WEFO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hKidRiMh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB1373DF3;
	Thu, 16 Jul 2026 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784209583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0jJhCIYFNU8W3Q0K2i5x3VUoS6HEEiR76IAl2WEn8A=;
	b=dq97WEFO874nR08ZnpdKtdssoWwNXn5zl9155JzxB4MGVTsz4czzg/MOVrmCaG6KUlKQnq
	rmWmh7FpclShlegl9SjJoQadnhOUSzQLxpt0iJwPa+HRL4uutQbYIL5piHxksIz9WKTnlj
	eiYZ6UjR5lXef2WzRYStkgaYsFO4mo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784209583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0jJhCIYFNU8W3Q0K2i5x3VUoS6HEEiR76IAl2WEn8A=;
	b=hKidRiMh9SzxmqxZI6+di48tiJrrdXgnb6nvOEwvkwZjs2OGX3p8aS1UBh8619fabQre6I
	3Y8XCNhk8ZTaPACw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784209583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0jJhCIYFNU8W3Q0K2i5x3VUoS6HEEiR76IAl2WEn8A=;
	b=dq97WEFO874nR08ZnpdKtdssoWwNXn5zl9155JzxB4MGVTsz4czzg/MOVrmCaG6KUlKQnq
	rmWmh7FpclShlegl9SjJoQadnhOUSzQLxpt0iJwPa+HRL4uutQbYIL5piHxksIz9WKTnlj
	eiYZ6UjR5lXef2WzRYStkgaYsFO4mo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784209583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D0jJhCIYFNU8W3Q0K2i5x3VUoS6HEEiR76IAl2WEn8A=;
	b=hKidRiMh9SzxmqxZI6+di48tiJrrdXgnb6nvOEwvkwZjs2OGX3p8aS1UBh8619fabQre6I
	3Y8XCNhk8ZTaPACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B48EB779AD;
	Thu, 16 Jul 2026 13:46:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TtWjK6/gWGqoGAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 16 Jul 2026 13:46:23 +0000
Message-ID: <08bd0674-316d-4cb6-96f2-93b6f38a4ce4@suse.de>
Date: Thu, 16 Jul 2026 15:46:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>
References: <20260716083847.926102-1-dlemoal@kernel.org>
 <20260716083847.926102-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260716083847.926102-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/16/26 10:38 AM, Damien Le Moal wrote:
> If a command timeout occurs while we have deferred non-NCQ commands
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred commands are never issued nor completed, thus leaving
> these commands to always be counted as "busy" for the SCSI host. This
> results in the test "shost->host_failed != scsi_host_busy(shost))" in the
> function scsi_error_handler() to always be true, keeping the SCSI EH task
> sleeping. Eventually, when the deferred commands also time out, the SCSI
> EH task is woken up and the timeout processing occurs.
> 
> Avoid this unnecessary SCSI EH task wake-up additional time by immediately
> scheduling a retry of all waiting deferred QCs, using the eh_timed_out
> SCSI host template operation. The function ata_scsi_eh_timed_out() is
> introduced to implement this operation.
> 
> However, ata_scsi_eh_timed_out() cannot use the function
> ata_scsi_requeue_deferred_qc() to force a retry of waiting deferred QCs,
> because this function completes the waiting QCs using ata_scsi_qc_done(),
> thus trigerring a requeue at the block layer, which itself may result in
> an immediate reissuing of the QCs, thus keeping the device in a busy state
> which prevents the SCSI EH task from waking up. To avoid this,
> ata_scsi_requeue_deferred_qc() is reimplemented as
> ata_eh_retry_deferred_qc() so that the retry of the waiting deferred QCs
> is scheduled through libata EH with ata_qc_schedule_eh(), with the waiting
> QCs flagged with ATA_QCFLAG_RETRY. Since ata_scsi_requeue_deferred_qc()
> was already called only when EH was already scheduled or running, this new
> scheduling of libata EH does not add overhead and guarantees that the
> device is not kept in a busy state, allowing the SCSI EH task to run and
> to execute libata EH. Once done, the deferred QCs retry is scheduled from
> ata_eh_finish() calling ata_eh_qc_retry(). This new path requires a small
> modification of __ata_eh_qc_complete() to avoid warnings due to the fact
> that deferred QCs are not flagged as active (ATA_QCFLAG_ACTIVE is not set
> as these QCs have not been issued yet).
> 
> Of note is that since ata_scsi_cmd_error_handler() already handles
> directly deferred QCs that timed out, ata_eh_retry_deferred_qc() always
> ignores a deferred QC that correspond to a timed out SCSI command.
> 
> Since ata_scsi_eh_timed_out() does not fully handle the timeout itself,
> this function returns SCSI_EH_NOT_HANDLED to have scsi_timeout() continue
> with the regular timeout handling, using scsi_abort_command() and
> scsi_eh_scmd_add(), thus preventing the wkae-up delay for SCSI EH task.
> 
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c   | 38 +++++++++++++++++++++-----
>   drivers/ata/libata-scsi.c | 56 +++++++++++++++++++++++----------------
>   drivers/ata/libata.h      |  2 +-
>   include/linux/libata.h    |  2 ++
>   4 files changed, 68 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 29ec0f7fef4a..7943593d49c8 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -546,6 +546,27 @@ static void ata_eh_unload(struct ata_port *ap)
>   	spin_unlock_irqrestore(ap->lock, flags);
>   }
>   
> +void ata_eh_retry_deferred_qc(struct ata_port *ap,
> +			      struct scsi_cmnd *timedout_scmd)
> +{
> +	struct ata_queued_cmd *qc;
> +	struct ata_link *link;
> +
> +	lockdep_assert_held(ap->lock);
> +
> +	/* Trigger EH for retrying any deferred qc that has not timed out. */
> +	ata_for_each_link(link, ap, PMP_FIRST) {
> +		qc = link->deferred_qc;
> +		if (!qc || qc->scsicmd == timedout_scmd)
> +			continue;
> +
> +		link->deferred_qc = NULL;
> +		cancel_work(&link->deferred_qc_work);
> +		qc->flags |= ATA_QCFLAG_RETRY;
> +		ata_qc_schedule_eh(qc);
> +	}
> +}
> +
>   /**
>    *	ata_scsi_error - SCSI layer error handler callback
>    *	@host: SCSI host on which error occurred
> @@ -947,11 +968,8 @@ static void ata_eh_set_pending(struct ata_port *ap, bool fastdrain)
>   
>   	ap->pflags |= ATA_PFLAG_EH_PENDING;
>   
> -	/*
> -	 * If we have a deferred qc, requeue it so that it is retried once EH
> -	 * completes.
> -	 */
> -	ata_scsi_requeue_deferred_qc(ap);
> +	/* If we have deferred QCs, tell EH to retry them. */
> +	ata_eh_retry_deferred_qc(ap, NULL);
>   
>   	if (!fastdrain)
>   		return;
> @@ -1214,9 +1232,17 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
>   	struct scsi_cmnd *scmd = qc->scsicmd;
>   	unsigned long flags;
>   
> +
> +	/*
> +	 * If we are retrying a deferred QC after a timeout, it is not active
> +	 * and all we need to do is to complete it directly.
> +	 */
>   	spin_lock_irqsave(ap->lock, flags);
>   	qc->scsidone = ata_eh_scsidone;
> -	__ata_qc_complete(qc);
> +	if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))
> +		qc->complete_fn(qc);
> +	else
> +		__ata_qc_complete(qc);

The original code did set a SCSI status, which I don't see here.
ata_scsi_qc_complete() will try to generate a status code from
the qc, which will be different from the original (DID_REQUEUE).
Sholdn't we set 'DID_REQUEUE', too?

>   	WARN_ON(ata_tag_valid(qc->tag));
>   	spin_unlock_irqrestore(ap->lock, flags);
>   
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 5868526301a2..1870669b8e05 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1685,28 +1685,6 @@ void ata_scsi_deferred_qc_work(struct work_struct *work)
>   	spin_unlock_irqrestore(ap->lock, flags);
>   }
>   
> -void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
> -{
> -	struct ata_link *link;
> -
> -	lockdep_assert_held(ap->lock);
> -
> -	/*
> -	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
> -	 * do not try to be smart about what to do with this deferred command
> -	 * and simply requeue it by completing it with DID_REQUEUE.
> -	 */
> -	ata_for_each_link(link, ap, PMP_FIRST) {
> -		struct ata_queued_cmd *qc = link->deferred_qc;
> -
> -		if (qc) {
> -			link->deferred_qc = NULL;
> -			cancel_work(&link->deferred_qc_work);
> -			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> -		}
> -	}
> -}
> -
>   static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
>   {
>   	struct ata_queued_cmd *qc = link->deferred_qc;
> @@ -1723,13 +1701,45 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
>   		return;
>   
>   	if (ata_port_eh_scheduled(ap)) {
> -		ata_scsi_requeue_deferred_qc(ap);
> +		ata_eh_retry_deferred_qc(ap, NULL);
>   		return;
>   	}
>   	if (!ap->ops->qc_defer(qc))
>   		queue_work(system_highpri_wq, &link->deferred_qc_work);
>   }
>   
> +static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
> +				       struct scsi_cmnd *scmd)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(ap->lock, flags);
> +	ata_eh_retry_deferred_qc(ap, scmd);
> +	spin_unlock_irqrestore(ap->lock, flags);
> +}
> +
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
> +	ata_scsi_retry_deferred_qc(ap, scmd);
> +
> +	/*
> +	 * Let scsi_timeout() know that it must continue with handling the
> +	 * timeout as we in fact did not do much here.
> +	 */
> +	return SCSI_EH_NOT_HANDLED;
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_eh_timed_out);
> +
>   static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
>   {
>   	struct ata_link *link = qc->dev->link;
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 700627596ce1..efaccebe93f5 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -180,7 +180,6 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
>   					struct ata_port *ap)
>   	__must_hold(ap->lock);
>   void ata_scsi_deferred_qc_work(struct work_struct *work);
> -void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
>   
>   /* libata-eh.c */
>   extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
> @@ -198,6 +197,7 @@ extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
>   			       unsigned int action);
>   extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
>   			unsigned int action);
> +void ata_eh_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd);
>   extern void ata_eh_autopsy(struct ata_port *ap);
>   const char *ata_get_cmd_name(u8 command);
>   extern void ata_eh_report(struct ata_port *ap);
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 30fdf673b887..51178acd68d7 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1153,6 +1153,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
>   #endif
>   extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
>   					     struct scsi_cmnd *cmd);
> +enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
>   #if IS_REACHABLE(CONFIG_ATA)
>   bool ata_scsi_dma_need_drain(struct request *rq);
>   #else
> @@ -1461,6 +1462,7 @@ extern const struct attribute_group *ata_common_sdev_groups[];
>   	.ioctl			= ata_scsi_ioctl,		\
>   	ATA_SCSI_COMPAT_IOCTL					\
>   	.queuecommand		= ata_scsi_queuecmd,		\
> +	.eh_timed_out		= ata_scsi_eh_timed_out,	\
>   	.dma_need_drain		= ata_scsi_dma_need_drain,	\
>   	.this_id		= ATA_SHT_THIS_ID,		\
>   	.emulated		= ATA_SHT_EMULATED,		\

Otherwise looks okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
