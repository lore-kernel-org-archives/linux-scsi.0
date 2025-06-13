Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF92E92D2
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 07:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749800247; cv=none; b=cF45vF6w/mVRezlG19KPFwAVtJJvL4C0AdHIonSArk47E3ClmoRqU+9OOSIqWOIGZZnDY0Qsz/zIrKT+PrJzTHlm41U60/iaRobAalr22LPUfgBsN6xmoDzUNFXBycTMkfNhFJOeUKsqkLEGOC8TeiR6WOJ+9WrZnanwSiLplb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749800247; c=relaxed/simple;
	bh=pgNGO5aspI9/4daXfO0wNJ68tx87JU3GHyFL5DAZMKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBJFBZG4LSN5/sbSRAZBYSNTlgWglSHT6QfVS5l8WiKjxOBlf0jYqQ8R8PEMFariCYJHGoFMVClVv0cAl7+Y53jyrd9mr7misf+DYcUH6AI1Dr3239DvCwL+w+3mXPE9DqMdSOXZ9FbkqnP1w0lgpo+eiqXHIVT4BkZy4gxJ720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AlIDdBIf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vj/7P+Gy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AlIDdBIf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vj/7P+Gy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AlIDdBIf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vj/7P+Gy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AlIDdBIf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vj/7P+Gy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A60B021204;
	Fri, 13 Jun 2025 07:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749800243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMF8B8oxVkvxZPMfNQbn9ATIifEf/04efYrZBy/YYkU=;
	b=AlIDdBIfjx3FeBnwW4yx4aa7zzed4+0YGEOZQr116CW+3ZJGrw6GOuNH7AYjQXEiYYASk5
	SBct1i8HasZvxr/qBqPWF62+CQO+SZ8KBqSBZp1VzDUPLwGmcxWHCxiqQElb69CBQbnKFt
	0LG49P/O0RCkpTKedxcJ9/AUn4niFhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749800243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMF8B8oxVkvxZPMfNQbn9ATIifEf/04efYrZBy/YYkU=;
	b=Vj/7P+GyJq4Jb8q/4rfWTCnaFXpq5IDUNOdTYOjVgxvEHVxZ2IbvjHLTGV6UFIONzSHYoh
	x1of7R8CN5MNqsCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AlIDdBIf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Vj/7P+Gy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749800243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMF8B8oxVkvxZPMfNQbn9ATIifEf/04efYrZBy/YYkU=;
	b=AlIDdBIfjx3FeBnwW4yx4aa7zzed4+0YGEOZQr116CW+3ZJGrw6GOuNH7AYjQXEiYYASk5
	SBct1i8HasZvxr/qBqPWF62+CQO+SZ8KBqSBZp1VzDUPLwGmcxWHCxiqQElb69CBQbnKFt
	0LG49P/O0RCkpTKedxcJ9/AUn4niFhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749800243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMF8B8oxVkvxZPMfNQbn9ATIifEf/04efYrZBy/YYkU=;
	b=Vj/7P+GyJq4Jb8q/4rfWTCnaFXpq5IDUNOdTYOjVgxvEHVxZ2IbvjHLTGV6UFIONzSHYoh
	x1of7R8CN5MNqsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81D3F13782;
	Fri, 13 Jun 2025 07:37:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dTAiHTPVS2hgHAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 13 Jun 2025 07:37:23 +0000
Date: Fri, 13 Jun 2025 09:37:22 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Cc: James Smart <james.smart@broadcom.com>, 
	Ram Vegesna <ram.vegesna@broadcom.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] scsi: elx: efct: fix memory leak in
 efct_hw_parse_filter()
Message-ID: <0e84f197-169a-471c-b2e7-17de6a79f76d@flourine.local>
References: <20250612163616.24298-1-v.shevtsov@mt-integration.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612163616.24298-1-v.shevtsov@mt-integration.ru>
X-Spamd-Result: default: False [-4.49 / 50.00];
	BAYES_HAM(-2.98)[99.91%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: A60B021204
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.49

On Thu, Jun 12, 2025 at 09:35:18PM +0500, Vitaliy Shevtsov wrote:
> strsep() modifies the address of the pointer passed to it so that it no
> longer points to the original address. This means kfree() gets the wrong
> pointer.
> 
> Fix this by passing unmodified pointer returned from kstrdup() to kfree().
> 
> Found by Linux Verification Center (linuxtesting.org) with Svace.
> 
> Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
> Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
