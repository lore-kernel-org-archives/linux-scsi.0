Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC543FB06C
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779181531; cv=none; b=cmXJxAhuxnSbB3Oft7ol5mzSPACsToWK5DOXwxTof8EFUHiLuKOP3vx/5JeINydCxfTmF01bGUzjfzicoDmUaH21jLtY2Hp5niA9zyXSO3yDImF0Mh0nqx2NZ9+31q9PP8Iyd9keN0U6DywXng2LtD8rvMYGc6/Y4DL7yKFTSpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779181531; c=relaxed/simple;
	bh=ZeY6sBICWO016u/FFy0Y3XXP3PS6VU1qHEqab8YYf9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fy3cUKhsJ8ZC9RN0+g4YUIBmDC6aBnS85ksjb2L6QgmjorQtoSkCk2SLTErXYkujLpuwn93E9tHZPSSWTaxjVbC4JEcXSlVUwyNsTZyYDD1hTHuc5J0yrq8DjkFMx9RMiujzFoT792l+81a0Vdiml4rdCzeCaMvc/qTFNh6hzDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p9TMxK8+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=se5veVGX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p9TMxK8+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=se5veVGX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p9TMxK8+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="se5veVGX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p9TMxK8+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="se5veVGX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A255B67F1A;
	Tue, 19 May 2026 09:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779181523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHjSMWSJH8BnvMOq4i0pukq/fJLFLZCu3uoiAcv9R60=;
	b=p9TMxK8+fY2/i8pyWZkRrUuENSi23I4W9N3lSHZfG4mOSU/OOXiv6YcnwU0GLMlz7UqoW/
	nQE4jLMGSlJdFHJo9cEWf41LC/B4xFQUZzoljC/ETpMVeSJ+y5155NkfshBL3YNX2w945W
	OnNJ+EI65WBUvEGpkbAyAWoPsu9j6yA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779181523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHjSMWSJH8BnvMOq4i0pukq/fJLFLZCu3uoiAcv9R60=;
	b=se5veVGXAXn+eAWcxzKRWLcO0hyGb/p0Qw6oyqVgEemZZRP5QfzSF/G/obDEmdpbVQMr/5
	ggdDiGQTlGvSx0BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779181523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHjSMWSJH8BnvMOq4i0pukq/fJLFLZCu3uoiAcv9R60=;
	b=p9TMxK8+fY2/i8pyWZkRrUuENSi23I4W9N3lSHZfG4mOSU/OOXiv6YcnwU0GLMlz7UqoW/
	nQE4jLMGSlJdFHJo9cEWf41LC/B4xFQUZzoljC/ETpMVeSJ+y5155NkfshBL3YNX2w945W
	OnNJ+EI65WBUvEGpkbAyAWoPsu9j6yA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779181523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHjSMWSJH8BnvMOq4i0pukq/fJLFLZCu3uoiAcv9R60=;
	b=se5veVGXAXn+eAWcxzKRWLcO0hyGb/p0Qw6oyqVgEemZZRP5QfzSF/G/obDEmdpbVQMr/5
	ggdDiGQTlGvSx0BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77A29593A8;
	Tue, 19 May 2026 09:05:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gLidHNMnDGoUMgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 19 May 2026 09:05:23 +0000
Message-ID: <14c670e6-0321-44f1-8d87-0d80f14423b8@suse.de>
Date: Tue, 19 May 2026 11:05:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: smartpqi: use shost_to_hba() in
 pqi_scan_finished()
To: Martin Wilck <martin.wilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microchip.com>,
 ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
 Martin Wilck <mwilck@suse.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
 storagedev@microchip.com, stable@vger.kernel.org
References: <20260513174236.430465-1-mwilck@suse.com>
 <20260513174236.430465-2-mwilck@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260513174236.430465-2-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,microchip.com:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 5/13/26 19:42, Martin Wilck wrote:
> From: Martin Wilck <martin.wilck@suse.com>
> 
> shost_to_hba() is used everywhere except to obtain pqi_ctrl_info
> from shosti, except in pqi_scan_finished(), where shost_priv() is used.
> This causes one pointer dereference to be missed, as shost->hostdata
> is a pointer in smartpqi. Fix it.
> 
> Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Don Brace <don.brace@microchip.com>
> Cc: Don Brace <don.brace@microchip.com>
> Cc: storagedev@microchip.com
> Cc: stable@vger.kernel.org
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 2026ac645d6a..5ec583dc2e7d 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2642,7 +2642,7 @@ static int pqi_scan_finished(struct Scsi_Host *shost,
>   {
>   	struct pqi_ctrl_info *ctrl_info;
>   
> -	ctrl_info = shost_priv(shost);
> +	ctrl_info = shost_to_hba(shost);
>   
>   	return !mutex_is_locked(&ctrl_info->scan_mutex);
>   }

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
