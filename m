Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085F91ACECD
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 07:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744617078; cv=none; b=Ac+IBpNT352HhdMkTR90Qu2Lh5MZGFkh3RDICo0SQPwFsmoL/f2d6ZvzoxBA713px9mB28bKAxv1XPCtHcV4V7eFIikw5uy5BROmUFsLCv1prvfaBHNsKviVOwRlxHmKiCeal25R6VafyFpwMQaTSU67y8d3yCV+///Vbfoqw2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744617078; c=relaxed/simple;
	bh=ko/P1m7xZzhuBMwiB8qtH/1RMjxDoBHhgLxpW41nwrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfRjKWmDu9M0qZclnWn2JHIZ7X1cLjzEryfvMwDMrflSs5SITJxesk5CQC2ePIfhTIhQOU0EJQZHNluL/HqeT5QQ4Qe+GifdZeZEzFjO8ntq5kvEH0QmLLBJe4He3RmyT7VB/b7QkL1S+gquIX6bSmleJOmYfNSZIq/tOJUNock=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WhoEarbt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hEkKVgAz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WhoEarbt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hEkKVgAz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WhoEarbt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hEkKVgAz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WhoEarbt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hEkKVgAz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3CB3C21169;
	Mon, 14 Apr 2025 07:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744617069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4Nqye6OxjaWqK7MliMY16hKvt/ySbQ/u8awpN1fXXk=;
	b=WhoEarbt2KDhHYG9b1UlMnX6hOz22z8J+t6QV7rAdPiEeeHnHMl2qvHHbhm4bD9dE7ERiz
	Ixh6++Z52EFGC1mS3ZUFmvlIXKUept3teInRbiEplzG0hE4e2DEPXREfjwj8YpD7Q1KqM9
	DwuQY8BHaIHLlzIWUq8tZpasxgRp76I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744617069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4Nqye6OxjaWqK7MliMY16hKvt/ySbQ/u8awpN1fXXk=;
	b=hEkKVgAzTzHBBfYD714uYDsQ7LNVe6AzIkS3Qd2OjDueQ88ipDjzdX4gR4LK6mxgsNMESi
	EnRbdpkXm/wPGVDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1744617069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4Nqye6OxjaWqK7MliMY16hKvt/ySbQ/u8awpN1fXXk=;
	b=WhoEarbt2KDhHYG9b1UlMnX6hOz22z8J+t6QV7rAdPiEeeHnHMl2qvHHbhm4bD9dE7ERiz
	Ixh6++Z52EFGC1mS3ZUFmvlIXKUept3teInRbiEplzG0hE4e2DEPXREfjwj8YpD7Q1KqM9
	DwuQY8BHaIHLlzIWUq8tZpasxgRp76I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1744617069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4Nqye6OxjaWqK7MliMY16hKvt/ySbQ/u8awpN1fXXk=;
	b=hEkKVgAzTzHBBfYD714uYDsQ7LNVe6AzIkS3Qd2OjDueQ88ipDjzdX4gR4LK6mxgsNMESi
	EnRbdpkXm/wPGVDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EF40136A7;
	Mon, 14 Apr 2025 07:51:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eNVeBW2+/GeAEgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 14 Apr 2025 07:51:09 +0000
Date: Mon, 14 Apr 2025 09:51:08 +0200
From: Daniel Wagner <dwagner@suse.de>
To: David Laight <david.laight.linux@gmail.com>
Cc: Daniel Wagner <wagi@kernel.org>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lpfc: use memcpy for bios version
Message-ID: <6f6b4f8c-e9f3-4962-af48-baf48a91c0a9@flourine.local>
References: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
 <20250413190238.2cb8ec64@pumpkin>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413190238.2cb8ec64@pumpkin>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Sun, Apr 13, 2025 at 07:02:38PM +0100, David Laight wrote:
> On Wed, 09 Apr 2025 13:34:22 +0200
> Daniel Wagner <wagi@kernel.org> wrote:
> 
> > The strlcat with FORTIFY support is triggering a panic because it thinks
> > the target buffer will overflow although the correct target buffer
> > size is passed in.

BTW, still trying to figure out what is happening here. It was observed
on ppc64el but so far creating a crash dump is not working.

> > Anyway, instead memset with 0 followed by a strlcat, just use memcpy and
> > ensure that the resulting buffer is NULL terminated.
> > 
> > BIOSVersion is only used for the lpfc_printf_log which expects a
> > properly terminated string.
> > 
> > Signed-off-by: Daniel Wagner <wagi@kernel.org>
> > ---
> >  drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> > index 6574f9e744766d49e245bd648667cc3ffc45289e..a335d34070d3c5fa4778bb1cb0eef797c7194f3b 100644
> > --- a/drivers/scsi/lpfc/lpfc_sli.c
> > +++ b/drivers/scsi/lpfc/lpfc_sli.c
> > @@ -6003,9 +6003,9 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
> >  	phba->sli4_hba.flash_id = bf_get(lpfc_cntl_attr_flash_id, cntl_attr);
> >  	phba->sli4_hba.asic_rev = bf_get(lpfc_cntl_attr_asic_rev, cntl_attr);
> >  
> > -	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
> > -	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
> > +	memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
> >  		sizeof(phba->BIOSVersion));
> > +	phba->BIOSVersion[sizeof(phba->BIOSVersion) - 1] = '\0';
> 
> Isn't that just strscpy() ?

strscpy does more work to ensure everything is correct and has the
advantage that it wont copy the whole buffer unnecessary. Given how
small the work is BIOSVersion is 8 bytes and bios_ver_str is 32 bytes
and there are other places in the driver doing something similar thing,
I opted for the traditional memcpy with an explicit NULLing. Obviously,
it also avoids using any of the fortify features :)
