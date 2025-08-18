Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A066E17A300
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 06:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497040; cv=none; b=EK3gfPyRGADCfCI58kFIAISmTq/ybi7xrbhSo5uZCwWvx+6Nol7+AtcQYDIKIysshnZcJACGzOlMpduNR2d8wzFCycxR7rNv0rT9xwAyaYtqrQuEdX7nu7+bpgNBoZFyz1euuSsD087vfI1IQIFwS0CQfiq/8Y+LaMJStduxh0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497040; c=relaxed/simple;
	bh=9SY1om2XkTFw0XC3NhJK4YOGvYDx2vRTpLInfBaznyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SEMowk2x5IWvHU6CsJ+lwXoJRt0abIqzvpzNQROeBrv96CF95B2Up7Jz+DLDa2rS0RNxqDLRFfRBvfnXEpr+Ly3N0AyD977Fp7GG6zo9JScAx16qy1UdrraKveYaRo4eE9+LZWv/VMtQOwhjUlsjF7lldyxBLHXK1UW5/yeEjng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NS9HKsIL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fnhv9cGZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NS9HKsIL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fnhv9cGZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NS9HKsIL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fnhv9cGZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NS9HKsIL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fnhv9cGZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 805561F45E;
	Mon, 18 Aug 2025 06:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755497035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi5ZxsYpORgkF+1KDIh+o646W1fqejvqpriSX42Ue+Y=;
	b=NS9HKsILOcoalMUflraT5Wo/4QlrjFMxMSo0aGXVH6y6M9zLUfbPlcPlSo8bY8AKp9dV+9
	lx4qHc1sRHJ6CGLxab0j9sK7TfXrt+bC0Nqkc/AEgLiLdIQthcYpjTiAQ1bmxv324b9deW
	nIwIJlOisyyTXtcmJADrKExCjZufzls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755497035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi5ZxsYpORgkF+1KDIh+o646W1fqejvqpriSX42Ue+Y=;
	b=Fnhv9cGZN6lWYRdnWE/ESsYODSqV27gyfVyboTDVAKLE26rymozTqwEZvkIwSikeDlVqjt
	JfgvpXA9CfPa81CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NS9HKsIL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fnhv9cGZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755497035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi5ZxsYpORgkF+1KDIh+o646W1fqejvqpriSX42Ue+Y=;
	b=NS9HKsILOcoalMUflraT5Wo/4QlrjFMxMSo0aGXVH6y6M9zLUfbPlcPlSo8bY8AKp9dV+9
	lx4qHc1sRHJ6CGLxab0j9sK7TfXrt+bC0Nqkc/AEgLiLdIQthcYpjTiAQ1bmxv324b9deW
	nIwIJlOisyyTXtcmJADrKExCjZufzls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755497035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi5ZxsYpORgkF+1KDIh+o646W1fqejvqpriSX42Ue+Y=;
	b=Fnhv9cGZN6lWYRdnWE/ESsYODSqV27gyfVyboTDVAKLE26rymozTqwEZvkIwSikeDlVqjt
	JfgvpXA9CfPa81CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D006313A55;
	Mon, 18 Aug 2025 06:03:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RAQjJi/ComiieAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 06:03:27 +0000
Message-ID: <83347952-255f-4362-a7e4-f9f501ce6cb5@suse.de>
Date: Mon, 18 Aug 2025 08:03:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-2-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250403211937.2225615-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 805561F45E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -6.51

On 4/3/25 23:17, Bart Van Assche wrote:
> Instead of requiring the caller to cast away constness, make
> scsi_cmd_to_rq() accept const arguments.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_logging.c | 10 +++++-----
>   include/scsi/scsi_cmnd.h    |  9 +++++----
>   2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index b02af340c2d3..5aaff629b999 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -28,7 +28,7 @@ static void scsi_log_release_buffer(char *bufptr)
>   
>   static inline const char *scmd_name(const struct scsi_cmnd *scmd)
>   {
> -	struct request *rq = scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
> +	const struct request *rq = scsi_cmd_to_rq(scmd);
>   
>   	if (!rq->q || !rq->q->disk)
>   		return NULL;
> @@ -94,7 +94,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
>   	if (!logbuf)
>   		return;
>   	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
> -				 scsi_cmd_to_rq((struct scsi_cmnd *)scmd)->tag);
> +				 scsi_cmd_to_rq(scmd)->tag);
>   	if (off < logbuf_len) {
>   		va_start(args, fmt);
>   		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
> @@ -374,8 +374,8 @@ EXPORT_SYMBOL(__scsi_print_sense);
>   void scsi_print_sense(const struct scsi_cmnd *cmd)
>   {
>   	scsi_log_print_sense(cmd->device, scmd_name(cmd),
> -			     scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag,
> -			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> +			     scsi_cmd_to_rq(cmd)->tag, cmd->sense_buffer,
> +			     SCSI_SENSE_BUFFERSIZE);
>   }
>   EXPORT_SYMBOL(scsi_print_sense);
>   
> @@ -393,7 +393,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
>   		return;
>   
>   	off = sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
> -				 scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag);
> +				 scsi_cmd_to_rq(cmd)->tag);
>   
>   	if (off >= logbuf_len)
>   		goto out_printk;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db..154fbb39ca0c 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -144,10 +144,11 @@ struct scsi_cmnd {
>   };
>   
>   /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
> -static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
> -{
> -	return blk_mq_rq_from_pdu(scmd);
> -}
> +#define scsi_cmd_to_rq(scmd)                                       \
> +	_Generic(scmd,                                             \
> +		const struct scsi_cmnd *: (const struct request *) \
> +			blk_mq_rq_from_pdu((void *)scmd),          \
> +		struct scsi_cmnd *: blk_mq_rq_from_pdu((void *)scmd))
>   
>   /*
>    * Return the driver private allocation behind the command.

Is there a cover letter for this patchset?
My mailer bunched it up under the first patch, leading to the wrong 
impression that it's just about converting to 'const' arguments...
(And me nearly ignoring the patchset altogether).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
