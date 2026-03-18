Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0692336EAB4
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820737; cv=none; b=HhCAN2q6+wy3j2OU5ECjRmIm3xhCRCm5R8wdUl9KGjreJOQODfrnUCyOTxekyGbDMiHNqyRi/+NWTDTjQ2kgiH2uUG/4ae/swkU6r8m8b7/H2IolPo7Tx89WsTNxi5Z+xusWkPGuA2tuN1cUsbUyCTOYyIWkiRn05YEav3ojI6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820737; c=relaxed/simple;
	bh=Jwr9O2opezZHBsU12rj9oq5C0fSTspBUJa3XRuFtijo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJqAc/gGUtRCDj25mW7t5CEpzAPhFbZrC6qJZf+tAyA81DBDZgPlKp2MT/V7tnHnvAbdWv9bRUJjPXJjNseQk8V5VyIwwOOh1UjeaP4NanQreslysMnrzcUpMD9/ryY7h6f9nqZ4fLhVEMs2bQw/P72xBNfozdaXsYralEUE3vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IJsVhxTn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4xB+m6W7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IJsVhxTn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4xB+m6W7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IJsVhxTn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4xB+m6W7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IJsVhxTn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4xB+m6W7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D8175BDFF;
	Wed, 18 Mar 2026 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOR7k8+LMI3fSs9tGWPI8O90YKBv1WOd0NTTLSVOYNk=;
	b=IJsVhxTnJ6EpNlhreZIm0rY9jOQ6te2RGYfpCCTl3/vijWFPFMC/Ba7HjNgHuBDO8T+0HJ
	KK+bHNcvz7u8LQW56z5vtuPZqG7JfssLRP1jz7p7FuFC+YHlr3jyTRJnqUjA8uRkFan3gq
	zMyn7+fSclRRykRYIZtpOuDXk3T7rzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOR7k8+LMI3fSs9tGWPI8O90YKBv1WOd0NTTLSVOYNk=;
	b=4xB+m6W7ZA47solc/hDYyLnISBSnpEJ9ExW29rm0Nzp+i8JG129vW1dvnEPLjXH4wuB2hM
	pNq8mx/vPoCjQ+Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOR7k8+LMI3fSs9tGWPI8O90YKBv1WOd0NTTLSVOYNk=;
	b=IJsVhxTnJ6EpNlhreZIm0rY9jOQ6te2RGYfpCCTl3/vijWFPFMC/Ba7HjNgHuBDO8T+0HJ
	KK+bHNcvz7u8LQW56z5vtuPZqG7JfssLRP1jz7p7FuFC+YHlr3jyTRJnqUjA8uRkFan3gq
	zMyn7+fSclRRykRYIZtpOuDXk3T7rzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOR7k8+LMI3fSs9tGWPI8O90YKBv1WOd0NTTLSVOYNk=;
	b=4xB+m6W7ZA47solc/hDYyLnISBSnpEJ9ExW29rm0Nzp+i8JG129vW1dvnEPLjXH4wuB2hM
	pNq8mx/vPoCjQ+Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 123D04273B;
	Wed, 18 Mar 2026 07:58:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QSwoAj5bumksUAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 07:58:54 +0000
Message-ID: <1f964e4c-8dc8-4daa-8ef9-25e053d065ed@suse.de>
Date: Wed, 18 Mar 2026 08:58:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] scsi: alua: Add scsi_alua_handle_state_transition()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-10-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/17/26 13:06, John Garry wrote:
> Add an equivalent of alua_handle_state_transition() from scsi_dh_alua.c
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_alua.c | 11 +++++++++++
>   include/scsi/scsi_alua.h |  5 +++++
>   2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index 9c317e60d031e..d19d1845bc324 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -40,6 +40,17 @@ static struct workqueue_struct *kalua_wq;
>   #define ALUA_RTPG_DELAY_MSECS		5
>   #define ALUA_RTPG_RETRY_DELAY		2
>   
> +void scsi_alua_handle_state_transition(struct scsi_device *sdev)
> +{
> +	struct alua_data *alua = sdev->alua;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&alua->lock, flags);
> +	alua->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +	spin_unlock_irqrestore(&alua->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(scsi_alua_handle_state_transition);
> +
>   /*
>    * alua_tur - Send a TEST UNIT READY
>    * @sdev: device to which the TEST UNIT READY command should be send
> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
> index 2e664f20d9681..5b3a12861658f 100644
> --- a/include/scsi/scsi_alua.h
> +++ b/include/scsi/scsi_alua.h
> @@ -30,6 +30,8 @@ struct alua_data {
>   int scsi_alua_sdev_init(struct scsi_device *sdev);
>   void scsi_alua_sdev_exit(struct scsi_device *sdev);
>   
> +void scsi_alua_handle_state_transition(struct scsi_device *sdev);
> +
>   int scsi_alua_check_tpgs(struct scsi_device *sdev);
>   
>   int scsi_alua_rtpg_run(struct scsi_device *sdev);
> @@ -39,6 +41,9 @@ int scsi_alua_init(void);
>   void scsi_exit_alua(void);
>   #else //CONFIG_SCSI_ALUA
>   
> +static inline void scsi_alua_handle_state_transition(struct scsi_device *sdev)
> +{
> +}
>   static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
>   {
>   	return 0;

???
This doesn't handle a state transition, it just _sets_ the state 
transition. Please fold it into the patch where the state transition
is actually handled.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
