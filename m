Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A828641A76E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783342047; cv=none; b=u0mpRA7GPaD3Cco3SdtLUVaZ/E8ABsEKE1zcYyQ+MSHbDOHZAqBxd0tAlRRjxlEAERJoxBz+ML60S1pVrhIXhVIhuDvPLUMivwqbfdz8o70k8rWREVU90uHlcB0Z1vaFTWpp37+sAmR0HEnDpuq+M0ZoKsZoB38OIA6VqM9vdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783342047; c=relaxed/simple;
	bh=ficT0LPjT9S3lFo1u8HKnacwCeQGgrNbcBkxGjDsWOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ck9sp8AoXVxd1JPeWTyTys0LZkI4SfzkgJPi64jpNqAETHQWs0wO1L1tbZ+ICAIoNOKmn6XVmRV4D1Y3brB/adt3dm05liC8ZJwfmZzDYQxsiegMXxCLLyyaQY4LaQoSirpjDAgldo4w3ICQaKx+GtY3GyAEjrv5hdR+bd19o98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AzFFqyuc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ionMduO7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AzFFqyuc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ionMduO7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AzFFqyuc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ionMduO7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AzFFqyuc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ionMduO7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF23D758FF;
	Mon,  6 Jul 2026 12:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783342043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpMbaZo8Z9BuQb6i2Np0IL9ow4Z/6I+hQRZsrNnCO7I=;
	b=AzFFqyuc81mP+NoZW5o0so6Snjjf0psxa+BNN2bI0QbXovS8WH6CLNdfkDHZFgGDGYES9M
	zdPTmwcm6s/CZK8UXyeFirmNf8VdtoWPu1vKlLYBUrbRGxGOFft5W86FqJqAHwvW+Anx2T
	r2kRsvcmrbxFarTqMxKwfXWf6t13Uio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783342043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpMbaZo8Z9BuQb6i2Np0IL9ow4Z/6I+hQRZsrNnCO7I=;
	b=ionMduO7G9tJoa5b31iy4Cy+zbGcssbxLjnTlZNkvzUHor07edIxFlCRiptN/Dhj1ygADH
	dQ6HAhT59gp9BUCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783342043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpMbaZo8Z9BuQb6i2Np0IL9ow4Z/6I+hQRZsrNnCO7I=;
	b=AzFFqyuc81mP+NoZW5o0so6Snjjf0psxa+BNN2bI0QbXovS8WH6CLNdfkDHZFgGDGYES9M
	zdPTmwcm6s/CZK8UXyeFirmNf8VdtoWPu1vKlLYBUrbRGxGOFft5W86FqJqAHwvW+Anx2T
	r2kRsvcmrbxFarTqMxKwfXWf6t13Uio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783342043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpMbaZo8Z9BuQb6i2Np0IL9ow4Z/6I+hQRZsrNnCO7I=;
	b=ionMduO7G9tJoa5b31iy4Cy+zbGcssbxLjnTlZNkvzUHor07edIxFlCRiptN/Dhj1ygADH
	dQ6HAhT59gp9BUCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9D2B779AA;
	Mon,  6 Jul 2026 12:47:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CadLKNujS2paJAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Jul 2026 12:47:23 +0000
Message-ID: <6645eae1-a0e2-433f-a99f-cbf5ff511961@suse.de>
Date: Mon, 6 Jul 2026 14:47:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: fc_transport: vport and rport cleanup
 synchronization
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
References: <e16406ec-d4d6-4783-b79c-5c00263c133c@linux.ibm.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <e16406ec-d4d6-4783-b79c-5c00263c133c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 4/9/26 5:12 PM, Kyle Mahlkuch wrote:
> Imporve synchronization and cleanup logic in the fc_remove_host() and
> fc_rport_final_delete() to prevent use-after-free conditions during
> host removal
> 
> Vport cleanup:
>    - Mark all vports with FC_VPORT_DELETING under lock
>    - Cancel all vport work synchronously before removing from the list
>    - Synchronous deletion with fc_vport_terminate()
> 
> Rport cleanup, applied to rports and rport_binding
>    - Mark all rport with FC_PORTSTATE_DELETED under lock
>    - Cancel all timers and work synchronously before removing from the list
>    - Call fc_rport_final_delete() synchronously instead of queuing
> 
> fc_rport_final_delete():
>    - Calling cancel_delayed_work_sync() for any outstanding delayed work
>    - Clear FC_RPORT_DEVLOSS_PENDING under lock
>    - Flushing all pending work completes before destruction
> 
> Signed-off-by: Thinh Tran <thinhtr@linux.ibm.com>
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
> ---
>   drivers/scsi/scsi_transport_fc.c | 85 ++++++++++++++++++++++++--------
>   1 file changed, 64 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
> scsi_transport_fc.c
> index 123b22b52640..0adb9330befc 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -39,6 +39,7 @@ static void fc_li_stats_update(u16 event_type,
>   static void fc_delivery_stats_update(u32 reason_code,
>                        struct fc_fpin_stats *stats);
>   static void fc_cn_stats_update(u16 event_type, struct fc_fpin_stats 
> *stats);
> +static void fc_rport_final_delete(struct work_struct *work);
> 
>   /*
>    * Module Parameters
> @@ -2883,31 +2884,71 @@ fc_remove_host(struct Scsi_Host *shost)
>       struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
>       unsigned long flags;
> 
> -    spin_lock_irqsave(shost->host_lock, flags);
> -
>       /* Remove any vports */
> +    /* Mark FC_VPORT_DELETING for now */
> +    spin_lock_irqsave(shost->host_lock, flags);
>       list_for_each_entry_safe(vport, next_vport, &fc_host->vports, 
> peers) {
>           vport->flags |= FC_VPORT_DELETING;
> -        fc_queue_work(shost, &vport->vport_delete_work);
> +    }
> +    spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +    /*
> +     * remove all vport works synchronously BEFORE removing from list.
> +     * This prevents use-after-free when timers fire.
> +     */
> +    list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
> +        /* Cancel any pending work/timers */
> +        cancel_work_sync(&vport->vport_delete_work);
> +        /* Now safe to do synchronous deletion */
> +        fc_vport_terminate(vport);
>       }
> 
>       /* Remove any remote ports */
> +    /* Mark rports and rport_bindings with FC_PORTSTATE_DELETED for now */
> +    spin_lock_irqsave(shost->host_lock, flags);
>       list_for_each_entry_safe(rport, next_rport,
>               &fc_host->rports, peers) {
> -        list_del(&rport->peers);
>           rport->port_state = FC_PORTSTATE_DELETED;
> -        fc_queue_work(shost, &rport->rport_delete_work);
>       }
> 
>       list_for_each_entry_safe(rport, next_rport,
>               &fc_host->rport_bindings, peers) {
> -        list_del(&rport->peers);
>           rport->port_state = FC_PORTSTATE_DELETED;
> -        fc_queue_work(shost, &rport->rport_delete_work);
>       }
> -
>       spin_unlock_irqrestore(shost->host_lock, flags);
> 
> +    list_for_each_entry_safe(rport, next_rport,
> +            &fc_host->rports, peers) {
> +        /* Cancel ALL timers and work before removing from list */
> +        cancel_delayed_work_sync(&rport->fail_io_work);
> +        cancel_delayed_work_sync(&rport->dev_loss_work);
> +        cancel_work_sync(&rport->scan_work);
> +        cancel_work_sync(&rport->stgt_delete_work);
> +
> +        spin_lock_irqsave(shost->host_lock, flags);
> +        list_del(&rport->peers);
> +        spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +        /* Now safe to do final deletion synchronously */
> +        fc_rport_final_delete(&rport->rport_delete_work);
> +    }
> +
> +    list_for_each_entry_safe(rport, next_rport,
> +            &fc_host->rport_bindings, peers) {
> +        /* Cancel ALL timers and work before removing from list */
> +        cancel_delayed_work_sync(&rport->fail_io_work);
> +        cancel_delayed_work_sync(&rport->dev_loss_work);
> +        cancel_work_sync(&rport->scan_work);
> +        cancel_work_sync(&rport->stgt_delete_work);
> +
> +        spin_lock_irqsave(shost->host_lock, flags);
> +        list_del(&rport->peers);
> +        spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +        /* Now safe to do final deletion synchronously */
> +        fc_rport_final_delete(&rport->rport_delete_work);
> +    }
> +
>       /* flush all scan work items */
>       scsi_flush_work(shost);
> 
> @@ -2983,21 +3024,22 @@ fc_rport_final_delete(struct work_struct *work)
>           scsi_flush_work(shost);
> 
>       /*
> -     * Cancel any outstanding timers. These should really exist
> -     * only when rmmod'ing the LLDD and we're asking for
> -     * immediate termination of the rports
> +     * Cancel any outstanding delayed work synchronously.
> +     * This must be done BEFORE taking spinlock and BEFORE
> +     * any state changes, as cancel_delayed_work_sync() can sleep.
> +     *
> +     * These timers should only exist when rmmod'ing the LLDD
> +     * and we're asking for immediate termination of rports.
> +     */
> +    cancel_delayed_work_sync(&rport->fail_io_work);
> +    cancel_delayed_work_sync(&rport->dev_loss_work);
> +    cancel_work_sync(&rport->scan_work);
> +    /*
> +     * Now safe to clear the flag under spinlock since all
> +     * async work has been cancelled.
>        */
>       spin_lock_irqsave(shost->host_lock, flags);
> -    if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
> -        spin_unlock_irqrestore(shost->host_lock, flags);
> -        if (!cancel_delayed_work(&rport->fail_io_work))
> -            fc_flush_devloss(shost, rport);
> -        if (!cancel_delayed_work(&rport->dev_loss_work))
> -            fc_flush_devloss(shost, rport);
> -        cancel_work_sync(&rport->scan_work);
> -        spin_lock_irqsave(shost->host_lock, flags);
> -        rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
> -    }
> +    rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
>       spin_unlock_irqrestore(shost->host_lock, flags);
> 
>       /* Delete SCSI target and sdevs */
> @@ -3027,6 +3069,7 @@ fc_rport_final_delete(struct work_struct *work)
>       if (rport->devloss_work_q) {
>           work_q = rport->devloss_work_q;
>           rport->devloss_work_q = NULL;
> +        flush_workqueue(work_q);
>           destroy_workqueue(work_q);
>       }
> 
Similar remarks to the previous patch.
If we set 'SHOST_CANCEL' after we scheduled all these
elements and before calling scsi_flush_work() we can
inhibit further calls to fc_queue_work() and we won't
need this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
