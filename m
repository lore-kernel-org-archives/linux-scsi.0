Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA6436B061
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278156; cv=none; b=k7p/JYKHDfTftgHZA48sprwBTTabzOVhIg+6W7n2k72TE0mwR7Rh/6SV+AEwsm2EcFj3pF8vX6bgjtsLyD4kY14SXwm+IZrD9UnMAjv37y1RBqNLO/5YE578nUY1hgRfYAzeq3nJkTQ2I+DQjSr5w8/oCxD7uD79rYtmwm8GVNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278156; c=relaxed/simple;
	bh=0okSIpmJnRw6gG/m+qrnrDKqpE6JmNG9k8Pd/isDu3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9KP12S1fFa8RyGh3DLnRRhTL/Eaet4eJmivBSWBIq4pd+B/uJve/sHCTfYG4Ptc9HC1fBJGTZLCk1ribkRfT4gS3DmVlv73pl4LGv6slcU+xfMzZ9GalZ5PnModFNp/uQKKaM8jMqqK7Xw7W4dNJRDqZ6h7uOdFqZHoiKD15dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xODQuPi4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HUbjG2kr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vlMWWbsC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hrgPdw5t; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xODQuPi4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HUbjG2kr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vlMWWbsC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hrgPdw5t"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D02186A818;
	Mon, 27 Apr 2026 08:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777278152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mzb53ynZB3gcTHcvx2Hs0fjw73ZiGkmNNKx024tAA7U=;
	b=xODQuPi49KTeVNn2WbjATvhh8qOwz0Tn9bwIzcZmDQpewW8OBVpJCyUI73l6nDKsn1bUkb
	Z0vs6IR6KTfR+dFfXbnVP//rQL3mMvomyifQ44CPayQu3EnZb5Di73E9A1HV2MpAIAhemy
	vg/Ue5puuqkEueqnppzohIzmMeKliTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777278152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mzb53ynZB3gcTHcvx2Hs0fjw73ZiGkmNNKx024tAA7U=;
	b=HUbjG2krpf8BgbKpvLHGBOMhyRPJfr2NJdknncYIHE4fm7VzR4JqyibyEbsf5tm/9iqCgn
	AVx2yBLtzTxpEzCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vlMWWbsC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hrgPdw5t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777278150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mzb53ynZB3gcTHcvx2Hs0fjw73ZiGkmNNKx024tAA7U=;
	b=vlMWWbsC7s1rXgbj5W1RdaZlkCxRNQoDrf/+SPedDQ+zMsnHLgh1y+9rGb9OiGVUII+1Rp
	Od2amUtdLAUYu1nV1Rp+5verQQwmPZZ8No2g3s7eOLdC38/LOA1+zYbSKxbf55kZPUuG+M
	J6TiHIIwBELmC9gCZngy7NO5nkoCuyk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777278150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mzb53ynZB3gcTHcvx2Hs0fjw73ZiGkmNNKx024tAA7U=;
	b=hrgPdw5teI0+LNc1UN2eQCK84edRj9nMQz30sgaeilrD61o37YqE4gdNvk50hYZqyNaFgC
	c0vjF+DCxi9Rd7AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA553593B0;
	Mon, 27 Apr 2026 08:22:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fQ7GJ8Yc72koEgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 27 Apr 2026 08:22:30 +0000
Message-ID: <0a89cb03-31d6-4f5f-a84c-a838d4d99ab5@suse.de>
Date: Mon, 27 Apr 2026 10:22:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: Krishna Kant <krishna.kant@purestorage.com>
References: <20260424215324.99045-1-brian@purestorage.com>
 <20260424215324.99045-3-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260424215324.99045-3-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,purestorage.com:email,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: D02186A818
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/24/26 23:53, Brian Bunker wrote:
> The vendor, model, rev, and inquiry sysfs attributes read data directly
> from the inquiry buffer. When INQUIRY data can be updated during device
> rescan, these reads must be protected against concurrent updates.
> 
> Use the existing inquiry_mutex to protect access to these sysfs
> attributes. This ensures that userspace always sees consistent INQUIRY
> data, even if a rescan is updating the buffer concurrently.
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 74 +++++++++++++++++++++++++++++++++++----
>   1 file changed, 67 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfc3559e7e04f..c34c69487205f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -648,9 +648,63 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
>    */
>   sdev_rd_attr (type, "%d\n");
>   sdev_rd_attr (scsi_level, "%d\n");
> -sdev_rd_attr (vendor, "%.8s\n");
> -sdev_rd_attr (model, "%.16s\n");
> -sdev_rd_attr (rev, "%.4s\n");

Feels a bit odd, protecting 'vendor', 'model' etc, but leaving out
'type' and 'level'.
Any particular reason for this?
If we are prepared to accept that the inquiry data changes, we cannot
assume which fields will be changed, rather we have to expect that
_all_ fields can be changed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
