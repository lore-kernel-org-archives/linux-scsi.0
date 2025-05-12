Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1274D24A07B
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747048076; cv=none; b=kUkzgnin4xcPDG02C4K22yUNABYF4syRSLOVAALv+P34hrPngDRRX1pwdsRmAEGTdXYIgk4XrMLLCuDD6VDuLzpPuhGHqHFj59creCvTOyiW3lXxfZTXde2AoQ/4cRxvpMMa/ld8kHA9fTyxGJ9BbMeOQ2R4k8pGeaOr5qCV6K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747048076; c=relaxed/simple;
	bh=a5hesHHed0WB99e3gDftAULm+dxzKOuTh7XgMfWK1mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSd4oYcdbIwaNmzpsfCL5JC4jBBQ6vMbBGGQjiKgg/Vn67/ngezyYfwXp8vP7c6TjxhsSWlfYrNl2rKXeVsUcEmC98RiHLQ2X8Zx95Hy+aybMswtNuuCcyUvu6IybOlwoXpW9dVW4sVZpKuzw5f0ngoQhO/tVB2vXZU5pJJ4RPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=THzPPblT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jsbKJ2Oh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z9RVOi+w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jsbKJ2Oh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="THzPPblT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jsbKJ2Oh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z9RVOi+w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jsbKJ2Oh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1A7221186;
	Mon, 12 May 2025 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747048073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=et5gDcoc8ekn1bmJBTtGTHZmagIiqCmt0KDfMdx6qZw=;
	b=THzPPblTmd9VV+AENJc1V/QdceVe7xM7O1rvZ8Nc1IDmI5ypwnWCKGBQoE0OTn/F8EmZLq
	wsEGDo3BRgAKcJtces2FLfpHXeiKI2m2Vgk9gavN5LBJmJYZ+j7UmQdyWEqCIsnzrVP2n1
	NFHp2BlRH7U3P2Os27c0cyBJOCNR4dc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747048073;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=et5gDcoc8ekn1bmJBTtGTHZmagIiqCmt0KDfMdx6qZw=;
	b=jsbKJ2OhWbeplsYXSX/iGej+Xx+hnXslqftpo8EDuUeG19R7kStcKolzQ9YWjD6S/+gaBA
	o975xMuEV69raSBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z9RVOi+w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jsbKJ2Oh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747048072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=et5gDcoc8ekn1bmJBTtGTHZmagIiqCmt0KDfMdx6qZw=;
	b=z9RVOi+wc/fFi3MmF5HsCHY5Gq1RuQxjD2olGshUh20a8Cns5ZWgR15XEjn3ifbcZ9zCEA
	Y+z0+oiEHXpPNyOBh0XPfvZREI372tjTngApG6Qx96Ch/rwE+2jTJy80y7SMPs+UuXX1eF
	M5lOi2d1zLrrhv5W9z0LmJjC28Dmc6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747048073;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=et5gDcoc8ekn1bmJBTtGTHZmagIiqCmt0KDfMdx6qZw=;
	b=jsbKJ2OhWbeplsYXSX/iGej+Xx+hnXslqftpo8EDuUeG19R7kStcKolzQ9YWjD6S/+gaBA
	o975xMuEV69raSBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D66D6137D2;
	Mon, 12 May 2025 11:07:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QlrxMYjWIWgwZAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 12 May 2025 11:07:52 +0000
Date: Mon, 12 May 2025 13:07:52 +0200
From: Daniel Wagner <dwagner@suse.de>
To: David Laight <david.laight.linux@gmail.com>
Cc: Daniel Wagner <wagi@kernel.org>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lpfc: use memcpy for bios version
Message-ID: <5da12dbf-4f18-44f7-9817-5e0dc70bddce@flourine.local>
References: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
 <20250413190238.2cb8ec64@pumpkin>
 <6f6b4f8c-e9f3-4962-af48-baf48a91c0a9@flourine.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f6b4f8c-e9f3-4962-af48-baf48a91c0a9@flourine.local>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F1A7221186
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Action: no action

On Mon, Apr 14, 2025 at 09:51:09AM +0200, Daniel Wagner wrote:
> On Sun, Apr 13, 2025 at 07:02:38PM +0100, David Laight wrote:
> > On Wed, 09 Apr 2025 13:34:22 +0200
> > Daniel Wagner <wagi@kernel.org> wrote:
> > 
> > > The strlcat with FORTIFY support is triggering a panic because it thinks
> > > the target buffer will overflow although the correct target buffer
> > > size is passed in.
> 
> BTW, still trying to figure out what is happening here. It was observed
> on ppc64el but so far creating a crash dump is not working.

FTR, finally got hold on the crash dump. As expected, the problem is
that bios_ver_str is not properly NUL terminated. strlcat expects that
both input strings are properly terminated.
