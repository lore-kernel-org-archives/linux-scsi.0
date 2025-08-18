Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A6B3203B5
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755519797; cv=none; b=I1UoDRWCrNV0IuMD9WZwopzppuaAn5FeYDjO8k+1+HTsUMSvglir/u+Jul2wul8pF2p2rXvQ3CwlXSclvM28ZKATnwfJ9wAf3Ia7WyxiLS5dcUQ0wuW7WCv9puf1tQlMBz2LgTirOHttAh6nccNg1CcDKPAfP39vOiSHEiM9CJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755519797; c=relaxed/simple;
	bh=YzJILQS8rKElSqqObYnBR4GIAoZ5EszD7o6OIEviUPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWsECDlarja27McMd9TaaR5hU5lnXXBbEhusaRUhs4lTq+T4FX9Yq95cnj2nbTo7Bg5JcqMnGB5nIiUeK3cB74COau02KLGOMX6yf19Dt8DDhC+vGc4dZUdCILxvODN6yGPpoEWUkS81TMpdDRWV3XC0DwZozYGGd88+OUWU4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qWcKhlEF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UZlEdEHI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qWcKhlEF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UZlEdEHI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qWcKhlEF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UZlEdEHI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qWcKhlEF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UZlEdEHI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D971211F5;
	Mon, 18 Aug 2025 12:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755519793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RYpm11ht/cl8Um1HuwXSPGLlHpzf44zCKbJgAWwTQw=;
	b=qWcKhlEFbOlmvw3Q0tCMEs8m6xQUlPs2AAoP5iTkGbWEO/d5YFeuAJ3XbTsoP5rGM18OiL
	vMqqyKDHaS0/8Rr9a+hLCXiQmcse8uiyMUTIee+m2XvsGFrRdlyS4tex/sNVXqobR7ozbh
	ttpD/7RWU2xYbCe4UeIT2iSHe4MsmIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755519793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RYpm11ht/cl8Um1HuwXSPGLlHpzf44zCKbJgAWwTQw=;
	b=UZlEdEHIGu2uYQs2rGGNYeCeW1KnYRNS/NX3rjEMTebfeNz84c8QmGCEoYTofY7c/Y/AfA
	DsjxgI+DKid7xVCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755519793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RYpm11ht/cl8Um1HuwXSPGLlHpzf44zCKbJgAWwTQw=;
	b=qWcKhlEFbOlmvw3Q0tCMEs8m6xQUlPs2AAoP5iTkGbWEO/d5YFeuAJ3XbTsoP5rGM18OiL
	vMqqyKDHaS0/8Rr9a+hLCXiQmcse8uiyMUTIee+m2XvsGFrRdlyS4tex/sNVXqobR7ozbh
	ttpD/7RWU2xYbCe4UeIT2iSHe4MsmIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755519793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RYpm11ht/cl8Um1HuwXSPGLlHpzf44zCKbJgAWwTQw=;
	b=UZlEdEHIGu2uYQs2rGGNYeCeW1KnYRNS/NX3rjEMTebfeNz84c8QmGCEoYTofY7c/Y/AfA
	DsjxgI+DKid7xVCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2681813686;
	Mon, 18 Aug 2025 12:23:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YtTaBjEbo2izcgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:23:13 +0000
Message-ID: <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
Date: Mon, 18 Aug 2025 14:23:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250811173634.514041-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,oracle.com:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 8/11/25 19:34, Bart Van Assche wrote:
> The SCSI budget mechanism is used to implement the host->cmd_per_lun limit.
> This limit does not apply to reserved commands. Hence, do not allocate a
> budget token for reserved commands.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9c67e04265ce..0112ad3859ff 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> -	sbitmap_put(&sdev->budget_map, cmd->budget_token);
> +	if (cmd->budget_token < INT_MAX)
> +		sbitmap_put(&sdev->budget_map, cmd->budget_token);
>   	cmd->budget_token = -1;
>   }
>   
> @@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>   {
>   	int token;
>   
> +	/*
> +	 * Do not allocate a budget token for reserved SCSI commands. Budget
> +	 * tokens are used to enforce the cmd_per_lun limit. That limit does not
> +	 * apply to reserved commands.
> +	 */
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return INT_MAX;
> +
>   	token = sbitmap_get(&sdev->budget_map);
>   	if (token < 0)
>   		return -1;
> @@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
>   {
>   	struct scsi_device *sdev = q->queuedata;
>   
> -	sbitmap_put(&sdev->budget_map, budget_token);
> +	if (budget_token < INT_MAX)
> +		sbitmap_put(&sdev->budget_map, budget_token);
>   }
>   
>   /*

Good idea, but we should document that somewhere that 'INT_MAX' now has
a distinct meaning.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
