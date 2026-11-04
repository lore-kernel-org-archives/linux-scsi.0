Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778820;
	b=JctoGmjB/qALtokBnkbbE2Nbitv74pKmvamYnECD/+G/aFHGLIuQXwZgpPyz33ccHeIp
	 klt9L8DQKo0dz8pRwVvV9Qy1uX8IMf4fpGKz8pZ38p22DE5oDr3ik7E/rWGmbFYwVGCuw
	 231ubq+eKG+cc/ClliyuyRTwcpCt2zrH+UmrZ63T7FZHFdVDaEAIfWCKMknQ2R8Rv6WuL
	 UPW19xef7bGAddIbgerZHG+ai7YNKE1nxt6ntGoc4d+lUfR00R4H/K5EguwjjjIjl0nyE
	 EVm2qr0WG7nosIWkYw4DjAap4A85jbeBbNoP2j1YSGWGPrlgx9DBgWuoX3mevjJJEew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778820;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=Kr64VP8LKlEZ2jJho9CorIFfn1vao1GJRn0coK0eeic=;
	b=uA6Ot7kRdShdfOx7J/p0NCddx9iNy3U+AH4HTiI6ak3BkcBm6gVMdbTIRrG5rh4CvrJM
	 9TSDTDIsnJQx23O7JzDsFiLWj8/gBku1TkFGuGZuxX2hr5vNyU96PAPGXYdI5n1SyoycL
	 h75vpSTYU1W34y+uLe0l5FqEpw0SFk7LrEsIVh+IeCkpLK7/4XupKLMElb3Lus8JzdbWW
	 SwbzkI51arn61iTkP1PjbT5OmtYtzZsTJPzyWpoQ+huOBdbOV33HlCXLnJK9xy14fNudV
	 gcOT326Vz75NmixiOuy92X4KtjVdAh/boXAyWJq3rJDM8lDE67913SudeZXnKW7ABQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RpK79ocU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="G/CrO4IA";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RpK79ocU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="G/CrO4IA";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD749606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 07:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD749606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RpK79ocU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=G/CrO4IA;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RpK79ocU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=G/CrO4IA
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 97C4E2205F;
	Wed,  4 Nov 2026 07:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793778817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kr64VP8LKlEZ2jJho9CorIFfn1vao1GJRn0coK0eeic=;
	b=RpK79ocUkol5rteG3sJydPVcMj8mo+h3cHcjyx53SpuVgCEsvKbZ9wUfwfLvU5ji8WxRKV
	PNxsbVhxsoiNlBtcBkv+HbRkqk+9fStheMzEYZ555Ui+zbO3Ak5LVKzPh0mB9RFBluX2cm
	7mGdeeSYxDg/25yJkpxFm9e03tkD7gM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793778817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kr64VP8LKlEZ2jJho9CorIFfn1vao1GJRn0coK0eeic=;
	b=G/CrO4IAK6JfyyshVnp3TxyAtbR5CfHjdG/qmINOINl2XI1NKuWlSdLZyxf5vKV8rRvib+
	Y/QHz/D6AN106mAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RpK79ocU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="G/CrO4IA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793778817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kr64VP8LKlEZ2jJho9CorIFfn1vao1GJRn0coK0eeic=;
	b=RpK79ocUkol5rteG3sJydPVcMj8mo+h3cHcjyx53SpuVgCEsvKbZ9wUfwfLvU5ji8WxRKV
	PNxsbVhxsoiNlBtcBkv+HbRkqk+9fStheMzEYZ555Ui+zbO3Ak5LVKzPh0mB9RFBluX2cm
	7mGdeeSYxDg/25yJkpxFm9e03tkD7gM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793778817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kr64VP8LKlEZ2jJho9CorIFfn1vao1GJRn0coK0eeic=;
	b=G/CrO4IAK6JfyyshVnp3TxyAtbR5CfHjdG/qmINOINl2XI1NKuWlSdLZyxf5vKV8rRvib+
	Y/QHz/D6AN106mAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52BFD134A5;
	Wed,  4 Nov 2026 07:53:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MdRqC4Hk6mqMUwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 04 Nov 2026 07:53:37 +0000
Message-ID: <77d0e1e8-4fff-4046-b1c0-a7d633ce3369@suse.de>
Date: Wed, 4 Nov 2026 08:53:36 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: myrs: drop the scsi_device reference in
 myrs_log_event
To: Wentao Liang <vulab@iscas.ac.cn>, Hannes Reinecke <hare@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <20261104021409.1467951-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261104021409.1467951-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,iscas.ac.cn:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 97C4E2205F

On 11/4/26 3:14 AM, Wentao Liang wrote:
> myrs_log_event() looks the physical device up with scsi_device_lookup(),
> which returns the device with an extra reference that the caller has to
> release with scsi_device_put().  The 'P' case only uses the device to
> print the event and to update the cached device state, but the reference
> is never dropped, so every physical device event leaks a scsi_device and
> prevents the device from being freed.
> 
> Drop the reference after the device has been used.
> 
> Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   drivers/scsi/myrs.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index 1192b01fab8e..1f248501a611 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
> @@ -877,6 +877,8 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
>   				break;
>   			}
>   		}
> +		if (sdev)
> +			scsi_device_put(sdev);
>   		break;
>   	case 'L':
>   		shost_printk(KERN_INFO, shost,

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
