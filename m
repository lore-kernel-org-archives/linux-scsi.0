Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4C92C9D
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 05:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776403924; cv=none; b=LyBZZjIyDwsrUro7h7tXRjEjILRxUma00yF8zmLPysjVdjkU6JIMxhQUMpTvNnxG2e8g78Y3Fje6Zjn0Ic2xL46vZmYPI3TzJ6xTDhCwSkWo7QDgckcn9uz+C8jWYuhhlUgRewb2SbOZwEkYnSeRddHiMJKJHFuZzf0vBUeVrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776403924; c=relaxed/simple;
	bh=d7bRsLapuwntOjfWGGFp7PQzYfcBx7jCRfVbJWAnNMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKSUBB/P4yfIGy5tw8xTCoFucbYilVzx6cwhjbxQbXimoCZ4pNkeGpjK7UCFnsilalKd/rdoZnsv245FtLUQEkNQOyMrEHFH7DpfSvr2qk5FlAx2Q7HRqQOnmMWmve/HVDgq+kggznX61msxV7XFV5GP3ztDftTQ1jxiDc860P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cSh6XLYo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OfuhIMUI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cSh6XLYo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OfuhIMUI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cSh6XLYo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OfuhIMUI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cSh6XLYo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OfuhIMUI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62F936A977;
	Fri, 17 Apr 2026 05:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776403921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcJ1xv8WO1MwO5JIxcQpgIdEg0gX5Ovb+tZE+wVQyvc=;
	b=cSh6XLYoczuVoNwydjYGrQzk027kmtlr6K6PT8C5ZsV1yYxWkhBD8bVIWGEA+9D3mfBqx6
	xVTjCGkWv6ReuL5T7zp9u2qXoQLriGBcAsJ/jg1ooTqdowOhH8+G5dJrL1br3apPPClITx
	Uc19t5YwDB3dt/8Di7aLE8BTv3fG/iI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776403921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcJ1xv8WO1MwO5JIxcQpgIdEg0gX5Ovb+tZE+wVQyvc=;
	b=OfuhIMUIs0PdpFY2KZj6J/LYx2dQwxIpWphPdIknb4gk4lN/pBAzwrr4KZyE9e7Hjwwj+6
	I7SR9f6Bfsm2bODw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776403921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcJ1xv8WO1MwO5JIxcQpgIdEg0gX5Ovb+tZE+wVQyvc=;
	b=cSh6XLYoczuVoNwydjYGrQzk027kmtlr6K6PT8C5ZsV1yYxWkhBD8bVIWGEA+9D3mfBqx6
	xVTjCGkWv6ReuL5T7zp9u2qXoQLriGBcAsJ/jg1ooTqdowOhH8+G5dJrL1br3apPPClITx
	Uc19t5YwDB3dt/8Di7aLE8BTv3fG/iI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776403921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcJ1xv8WO1MwO5JIxcQpgIdEg0gX5Ovb+tZE+wVQyvc=;
	b=OfuhIMUIs0PdpFY2KZj6J/LYx2dQwxIpWphPdIknb4gk4lN/pBAzwrr4KZyE9e7Hjwwj+6
	I7SR9f6Bfsm2bODw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AE5F593AE;
	Fri, 17 Apr 2026 05:32:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CPd4B9HF4WlxEQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 17 Apr 2026 05:32:01 +0000
Message-ID: <deac9af0-be69-4ffa-91d0-ca0410178a44@suse.de>
Date: Fri, 17 Apr 2026 07:32:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: scsi_dh_alua: increase default ALUA timeout to
 maximum spec value
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>,
 Riya Savla <rsavla@purestorage.com>
References: <20260416165512.26497-1-brian@purestorage.com>
 <20260416165512.26497-2-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260416165512.26497-2-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 4/16/26 18:55, Brian Bunker wrote:
> The ALUA handler maps a 0 value (no implicit transition timeout provided
> by the target) to the ALUA_FAILOVER_TIMEOUT constant, currently 60
> seconds. This means the kernel already does not accept an infinite
> transition time.
> 
> However, 60 seconds is insufficient for some arrays that may take
> longer to complete ALUA transitions. Since the highest value allowed
> by the SCSI specification for the implicit transition timeout is a
> single byte (255 seconds), change the default to 255. This way,
> when a target does not provide an explicit transition timeout, we
> default to the maximum value the spec allows rather than an arbitrary
> 60 second limit.
> 
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Riya Savla <rsavla@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index efb08b9b145a1..80ab0ff921d43 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -37,7 +37,7 @@
>   #define TPGS_MODE_EXPLICIT		0x2
>   
>   #define ALUA_RTPG_SIZE			128
> -#define ALUA_FAILOVER_TIMEOUT		60
> +#define ALUA_FAILOVER_TIMEOUT		255	/* max 255 (8-bit value) */
>   #define ALUA_FAILOVER_RETRIES		5
>   #define ALUA_RTPG_DELAY_MSECS		5
>   #define ALUA_RTPG_RETRY_DELAY		2

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
