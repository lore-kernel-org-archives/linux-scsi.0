Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B217484;
	Thu, 27 Jun 2024 06:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470158; cv=none; b=C/XWxOwKT45wvfo1GAi6zFgpq+EG4yV30gmOdNSy3A9C6K9/WJ0/BvdPUrjTIqI0ukScdC++pdxNfZMmVrhXcJ4NysiG1bPkPV+xjp9v6F6dgcT+CNIomFTcowEGJyLmOrvAHdFMbepKBoS4msMde5ZvshKwYbgMGNm9cZDZ+8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470158; c=relaxed/simple;
	bh=UJBRBxlE3NJf4ZloscHYGBGfAGH3vL06TZjgrTfEock=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e3q6/vnn02xC60jUwzzc2owapJQW1hmIk8Acl4JEsAhhALEZVYqz0AcwqkUeyekPbdRU1tS80r9Cxe0Vj5YgNLL42D6eILYpS2Y4VygA3bJnrAOW4O0T0NpeKPwOS5rUisIEiQVK0QzZIwgruD6vUcgDi2bVPIg8i4dD3Y56MGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Hk3PLNb4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UH+txaUw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hS5u2/r7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hVeN0ynC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Hk3PLNb4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UH+txaUw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hS5u2/r7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hVeN0ynC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CDB2E21B32;
	Thu, 27 Jun 2024 06:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqRYErc1XtO94CzWu5K+bmAJkKnGxJcfIjeB2TdHT44=;
	b=Hk3PLNb4WV4dcHa60N9BepepUBKfwBzIB6bDH4/Mp+dCPZgAm1rdw1mVyP/DKdDRIzQ7JM
	H5QFpjNq2qEbq8fcfMwWJN0mtgZPNnrMt1EPHulfXYYyfS85AQsZV7gugPevjz0PE2EWyk
	nrRq0O4n1UiEwaTBiu0i7mc8oLhoawA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqRYErc1XtO94CzWu5K+bmAJkKnGxJcfIjeB2TdHT44=;
	b=UH+txaUwBnDdWYhkj1AZ6QU2/AuikTr4gRzxQuIPqHIGKPa5gTwM7MroaG2guUXzrZjqJa
	T0aFL8RFS4SBNABA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hS5u2/r7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hVeN0ynC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719470150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqRYErc1XtO94CzWu5K+bmAJkKnGxJcfIjeB2TdHT44=;
	b=hS5u2/r7SR835ZoALiNxNU/Kc2YA12LkkeLNfKs74v9x4QZBtFmlIu0nykoN1xjuV+TRh1
	yJZ05WxtIG3dd5Al9NzZuuT4NhuhS7ILzEjzGH1GxuU3JutrFS5+bNtORFHp5ULC1JlRbF
	tww5tcVptiTkCgW19ojuiW+Sk8eta0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719470150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqRYErc1XtO94CzWu5K+bmAJkKnGxJcfIjeB2TdHT44=;
	b=hVeN0ynCnp5C3Bucsr0PDijXGN8HUJJiFWE+FvLCyrl7tahd34oBGFmHcj2bbhKzQF1qHp
	LqQqIvuUEMApQLCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63A3F137DF;
	Thu, 27 Jun 2024 06:35:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LkvIFkYIfWaAagAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Jun 2024 06:35:50 +0000
Message-ID: <e2feb368-5e78-495d-be06-380027663e1f@suse.de>
Date: Thu, 27 Jun 2024 08:35:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] ata: libata-core: Remove support for decreasing
 the number of ports
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-22-cassel@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240626180031.4050226-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDB2E21B32
X-Spam-Score: -4.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/26/24 20:00, Niklas Cassel wrote:
> Commit f31871951b38 ("libata: separate out ata_host_alloc() and
> ata_host_register()") added ata_host_alloc(), where the API allowed
> a LLD to overallocate the number of ports supplied to ata_host_alloc(),
> as long as the LLD decreased host->n_ports before calling
> ata_host_register().
> 
> However, this functionally has never ever been used by a single LLD.
> 
> Because of the current API design, the assignment of ap->print_id is
> deferred until registration time, which is bad, because that means that
> the ata_port_*() print functions cannot be used by a LLD until after
> registration time, which means that a LLD is forced to use a print
> function that is non-port specific, even for a port specific error.
> 
> Remove the support for decreasing the number of ports, such that it will
> be possible to assign ap->print_id earlier.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   drivers/ata/libata-core.c | 24 ++++++++++--------------
>   include/linux/libata.h    |  2 +-
>   2 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 591020ea8989..a213a9c0d0a5 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5550,24 +5550,19 @@ EXPORT_SYMBOL_GPL(ata_host_put);
>   /**
>    *	ata_host_alloc - allocate and init basic ATA host resources
>    *	@dev: generic device this host is associated with
> - *	@max_ports: maximum number of ATA ports associated with this host
> + *	@n_ports: the number of ATA ports associated with this host
>    *
>    *	Allocate and initialize basic ATA host resources.  LLD calls
>    *	this function to allocate a host, initializes it fully and
>    *	attaches it using ata_host_register().
>    *
> - *	@max_ports ports are allocated and host->n_ports is
> - *	initialized to @max_ports.  The caller is allowed to decrease
> - *	host->n_ports before calling ata_host_register().  The unused
> - *	ports will be automatically freed on registration.
> - *
>    *	RETURNS:
>    *	Allocate ATA host on success, NULL on failure.
>    *
>    *	LOCKING:
>    *	Inherited from calling layer (may sleep).
>    */
> -struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
> +struct ata_host *ata_host_alloc(struct device *dev, int n_ports)
>   {
>   	struct ata_host *host;
>   	size_t sz;
> @@ -5575,7 +5570,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
>   	void *dr;
>   
>   	/* alloc a container for our list of ATA ports (buses) */
> -	sz = sizeof(struct ata_host) + (max_ports + 1) * sizeof(void *);
> +	sz = sizeof(struct ata_host) + (n_ports + 1) * sizeof(void *);
>   	host = kzalloc(sz, GFP_KERNEL);
>   	if (!host)
>   		return NULL;
> @@ -5595,11 +5590,11 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
>   	spin_lock_init(&host->lock);
>   	mutex_init(&host->eh_mutex);
>   	host->dev = dev;
> -	host->n_ports = max_ports;
> +	host->n_ports = n_ports;
>   	kref_init(&host->kref);
>   
>   	/* allocate ports bound to this host */
> -	for (i = 0; i < max_ports; i++) {
> +	for (i = 0; i < n_ports; i++) {
>   		struct ata_port *ap;
>   
>   		ap = ata_port_alloc(host);
> @@ -5908,12 +5903,13 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
>   		return -EINVAL;
>   	}
>   
> -	/* Blow away unused ports.  This happens when LLD can't
> -	 * determine the exact number of ports to allocate at
> -	 * allocation time.
> +	/*
> +	 * For a driver using ata_host_register(), the ports are allocated by
> +	 * ata_host_alloc(), which also allocates the host->ports array.
> +	 * The number of array elements must match host->n_ports.
>   	 */
>   	for (i = host->n_ports; host->ports[i]; i++)
> -		kfree(host->ports[i]);
> +		WARN_ON(host->ports[i]);
>   
What a patently ugly check.
So you are relying on the caller to have zeroed the memory upfront.
But what happens if the caller allocated n_ports, zeroed the memory up 
to that point, and then filled in all 'ports' slots?
ports[n_ports - 1] is set to a pointer, but ports[n_ports] is _not_ 
allocated, and there is no guarantee it'll be zero.
Causing a memory overrun and all sorts of things.

This needs to go, as it's now pointless anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

