Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502A2D879E
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820912; cv=none; b=TnefVdlNCE4ej5KZK6ZXylBfM4RgVwTzZQVstPBipq76ZDZ31w6kyZdZL9oOdFTb7SYuvcB0kk/sNtJuDQYzria2nLg0ZxGSq2fq0AVQTtt1lOV9k7tiTEbW8DOcOYLlEaDT9stOxJU0IoEA6cFR2T+W3esNRuVBvg7DkOIbXFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820912; c=relaxed/simple;
	bh=W4DVLlx7G3w0pDnS26DBkNwDb+7WjSO+2c4ylR42r1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VdmmgogX2MoO+i0qfAKn3EkJ8q3PpAtmRyGcDMHHO2j/kUEvaSAnHsCN5IXSZ81HwWfUg2MDlFZioYpJiVGq0MR3Iw94aIACWq3XyooE2Fth75F5wjwET5/sSSFFAaouK2smoddC/Aqe1rDMia2QMZis3PUU3ElIfbxYySCyczM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UppOnuVt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nFoJUnLf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UppOnuVt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nFoJUnLf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UppOnuVt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nFoJUnLf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UppOnuVt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nFoJUnLf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2C6A5BDBC;
	Wed, 18 Mar 2026 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qG44Zq4p1+0Ne32Lz9dXQxw3VOgeovn2TvKZ507Vgss=;
	b=UppOnuVtvpzfaK55LmmBPkZAsZjv1RwZX+xE5f9NwyObXa7YfLdMz/yp1NApu2kM2gAM0E
	3MPR14D3NdzSYX8crWHyL+fYORYGjsRA5fHfOh82hUgNeGs0roh2H5fj03IlNrYUh+W2jf
	I2Z4WBWxXbmlCAn493IfsQsnhW2Jiz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qG44Zq4p1+0Ne32Lz9dXQxw3VOgeovn2TvKZ507Vgss=;
	b=nFoJUnLfeU5/1O4ZuqHLmgBaJ6KSDxRCNPmUWsTl0OdG28YqHVTYys0QT51zi613jJE7gE
	xnPkB44EUz/DCzBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UppOnuVt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nFoJUnLf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qG44Zq4p1+0Ne32Lz9dXQxw3VOgeovn2TvKZ507Vgss=;
	b=UppOnuVtvpzfaK55LmmBPkZAsZjv1RwZX+xE5f9NwyObXa7YfLdMz/yp1NApu2kM2gAM0E
	3MPR14D3NdzSYX8crWHyL+fYORYGjsRA5fHfOh82hUgNeGs0roh2H5fj03IlNrYUh+W2jf
	I2Z4WBWxXbmlCAn493IfsQsnhW2Jiz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qG44Zq4p1+0Ne32Lz9dXQxw3VOgeovn2TvKZ507Vgss=;
	b=nFoJUnLfeU5/1O4ZuqHLmgBaJ6KSDxRCNPmUWsTl0OdG28YqHVTYys0QT51zi613jJE7gE
	xnPkB44EUz/DCzBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F5244273B;
	Wed, 18 Mar 2026 08:01:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1rxeJepbumlsUwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 08:01:46 +0000
Message-ID: <462cf891-d43c-47b9-9572-c88afb4a09f1@suse.de>
Date: Wed, 18 Mar 2026 09:01:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] scsi: alua: Add scsi_alua_prep_fn()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-11-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-11-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,oracle.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F2C6A5BDBC

On 3/17/26 13:07, John Garry wrote:
> Add a core version of alua_prep_fn() from scsi_dh_alua.c
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_alua.c | 23 +++++++++++++++++++++++
>   include/scsi/scsi_alua.h |  8 ++++++++
>   2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index d19d1845bc324..c269105dbae4a 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -608,6 +608,29 @@ void scsi_alua_sdev_exit(struct scsi_device *sdev)
>   	sdev->alua = NULL;
>   }
>   
> +blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
> +{
> +	struct alua_data *alua = sdev->alua;
> +	unsigned long flags;
> +	unsigned char state;
> +
> +	spin_lock_irqsave(&alua->lock, flags);
> +	state = alua->state;
> +	spin_unlock_irqrestore(&alua->lock, flags);
> +
> +	switch (state) {
> +	case SCSI_ACCESS_STATE_OPTIMAL:
> +	case SCSI_ACCESS_STATE_ACTIVE:
> +	case SCSI_ACCESS_STATE_LBA:
> +	case SCSI_ACCESS_STATE_TRANSITIONING:
> +		return BLK_STS_OK;
> +	default:
> +		req->rq_flags |= RQF_QUIET;
> +		return BLK_STS_IOERR;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(scsi_alua_prep_fn);
> +
>   int scsi_alua_init(void)
>   {
>   	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
> index 5b3a12861658f..c16d4adc915ec 100644
> --- a/include/scsi/scsi_alua.h
> +++ b/include/scsi/scsi_alua.h
> @@ -8,6 +8,7 @@
>   #ifndef _SCSI_ALUA_H
>   #define _SCSI_ALUA_H
>   
> +#include <linux/blk-mq.h>
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_device.h>
>   
> @@ -37,6 +38,8 @@ int scsi_alua_check_tpgs(struct scsi_device *sdev);
>   int scsi_alua_rtpg_run(struct scsi_device *sdev);
>   int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
>   
> +blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
> +
>   int scsi_alua_init(void);
>   void scsi_exit_alua(void);
>   #else //CONFIG_SCSI_ALUA
> @@ -56,6 +59,11 @@ static inline int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
>   {
>   	return 0;
>   }
> +static inline
> +blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
> +{
> +	return BLK_STS_OK;
> +}
>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>   {
>   	return 0;

Hmm. The 'prep_fn' thingie was implemented such that other drivers (like 
scsi_dh) could intercept the scsi prep function and inject their own
stuff. But now with this patchset the functionality is in the scsi core,
so really we should do away with the prep_fn here and call the functions
directly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
