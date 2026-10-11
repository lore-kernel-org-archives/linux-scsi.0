Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568743B3C0;
	Sun, 11 Oct 2026 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791722188; cv=none; b=Wpi/9zB2Ec3iDmQQRG1fuuRlPvYwunAbYoTWweet23jNT7BeWUyh2yH81v1L/HbRllqbhvFajxjHmP0rxWGdEmu2rgTQKiPy8jXr3RbfybsHMo1kfl47ojZeshQ4sv7L5tF+eYVTIS5bqdC9/fOCGX5XodiCqMtF6f4g0+vH7pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791722188; c=relaxed/simple;
	bh=R10yOSvD0fqRg4qqb0k38A3uupIsJ0VGiUVxAS7FerY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRmRLxFfWNyYUouBBUySTH8W8W9rN6Ehar5P6GNzJKru2r9xusl9eQNVXuX93BpjIG+cKXFmi4TP+JpmSZonnoAFty0MgJvTpUI8G8i6jCtt92vHiW2xQix+hQqlTpn4Ku8lYB/hqN3IIMLdG6zu9m39PeB06t9ITo/kKJ2vMbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vuPnk4ND; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1CIaHC/k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vuPnk4ND; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1CIaHC/k; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vuPnk4ND";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1CIaHC/k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vuPnk4ND";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1CIaHC/k"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 440A51F394;
	Sun, 11 Oct 2026 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791722181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olaofrwGl8T9NhHp9VCEFIBcwErQS3PK86N+qFcRHGw=;
	b=vuPnk4NDtXzs+WsmrEIxGhbUR6kYNunS0UM0sgvDYIS8JUw7oahxpMttwuwdM7pQNhvLNY
	UMRrR1yYjuXtAEAadsoS1ipYzGk7tuebFRkUUKc588xVcRd9RRzJJVNWNwkCNNnONQEMfy
	e8e+yLzfQDtOMb3ifhcV6bI/6KeCte4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791722181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olaofrwGl8T9NhHp9VCEFIBcwErQS3PK86N+qFcRHGw=;
	b=1CIaHC/kkRdbNaKNluyGMJyssl3unh9cC1n6juD0fP5KMPtLPzRUW7sLOupDgR3hpyXpiB
	Eax54VxwF3FB+uDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vuPnk4ND;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1CIaHC/k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791722181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olaofrwGl8T9NhHp9VCEFIBcwErQS3PK86N+qFcRHGw=;
	b=vuPnk4NDtXzs+WsmrEIxGhbUR6kYNunS0UM0sgvDYIS8JUw7oahxpMttwuwdM7pQNhvLNY
	UMRrR1yYjuXtAEAadsoS1ipYzGk7tuebFRkUUKc588xVcRd9RRzJJVNWNwkCNNnONQEMfy
	e8e+yLzfQDtOMb3ifhcV6bI/6KeCte4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791722181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olaofrwGl8T9NhHp9VCEFIBcwErQS3PK86N+qFcRHGw=;
	b=1CIaHC/kkRdbNaKNluyGMJyssl3unh9cC1n6juD0fP5KMPtLPzRUW7sLOupDgR3hpyXpiB
	Eax54VxwF3FB+uDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D93013408;
	Sun, 11 Oct 2026 12:36:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eFhFKcCCy2qAcgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Sun, 11 Oct 2026 12:36:16 +0000
Date: Sun, 11 Oct 2026 23:36:00 +1100
From: David Disseldorp <ddiss@suse.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Martin K .
 Petersen" <mkp@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lee Duncan <lduncan@suse.com>, Alexandru
 Hossu <hossu.alexandru@gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use crypto library API
Message-ID: <20261011233600.5bb5d6c9.ddiss@suse.de>
In-Reply-To: <20261001044857.169487-1-ebiggers@kernel.org>
References: <20261001044857.169487-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 440A51F394
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,suse.com,gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.01

This looks like a worthwhile clean-up and doesn't trigger any libiscsi
chap test regressions.
Reviewed-by: David Disseldorp <ddiss@suse.de>

I do have one minor concern: 

On Wed, 30 Sep 2026 21:48:57 -0700, Eric Biggers wrote:

> Make iscsi_target_auth.c call into the crypto library directly instead
> of going through crypto_shash.  This is simpler and much more efficient,
> as it avoids overhead of the crypto_shash layer.  The hash computation
> itself also no longer has error codes that need to be checked.
> 
> For simplicity, still do a memory allocation per operation to buffer the
> data (which is typically less than 50 bytes here) so that the one-shot
> digest functions can be used.  It's still much more efficient than doing
> the super slow crypto_alloc_shash().
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/target/iscsi/Kconfig             |   7 +-
>  drivers/target/iscsi/iscsi_target_auth.c | 192 +++++++++--------------
>  drivers/target/iscsi/iscsi_target_auth.h |   8 +-
>  3 files changed, 78 insertions(+), 129 deletions(-)
...
> @@ -113,17 +143,17 @@ static int chap_check_algorithm(const char *a_str)
>  		if (kstrtol(token, 10, &digest_type))
>  			continue;
>  
> -		digest_name = chap_get_digest_name(digest_type);
> -		if (!digest_name)
> +		if (fips_enabled && digest_type == CHAP_DIGEST_MD5)
>  			continue;

Could e.g. SHA1 also require fips filtering here in future? If so, would
it make sense to track the fips compat status (preferably at build time)
in chap_digest_algs?

