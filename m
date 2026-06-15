Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09332F7F0F
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781516130; cv=none; b=EXMbWNXhjtQFcnEE0EtlmJNDxKdK+LiipAnxICpupEx899wFBqXHm93C/Rq+W2elApuLoC9iFpnyQBwzKAymhYdgl+fI/JOnMP/DFO+YZUiMncb6wdUS8E+RTKiqoOqQ+fYwX5I5mQ4Gdq2JNy0nPVPP8F3c+CzHvaSpnw7iKuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781516130; c=relaxed/simple;
	bh=TObyHCrog0J37zOBX+KTGoi74gpbHRQn8XN9jcDMGEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QN6SWIatgo9oBe3AK2knnDbBwIZYpTgg/BE3h2wPct9Tit61KTJJlDS2ISq0MERY8rvApugoXV7pFuRSZ2FEtjZgH1sRRTf7J5ZcjO4bcy/FQA5AJeF/J1Ei/mKByA9iGSjobGnZeLgvYdGta1jaoVSg83eF7VTejLDECzfy2cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LjEH6Qhh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Pt1yfHlk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A0wm2e9c; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VQtO9FdC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LjEH6Qhh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Pt1yfHlk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A0wm2e9c";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VQtO9FdC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C40D46AC95;
	Mon, 15 Jun 2026 09:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781516127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afhcBrMHwtuNpl6EOyz1Ve+TLR1X1Oc6pxCJDnx1z1w=;
	b=LjEH6QhheCbXn2yYPxvbrQS4POOD1+xCC+LO3SkvS9XwqOGQegNJetZOCT4begs2XLaB9J
	2h9aIEuCZvmyn/UuI2zWP4GX84GOGHRbAgh/rUEvfj0/D+nvYNAxwWZMIz8ctCyBduGet7
	0S/z0OyZJNnyU/3lUIEQQnfWF0NGB/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781516127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afhcBrMHwtuNpl6EOyz1Ve+TLR1X1Oc6pxCJDnx1z1w=;
	b=Pt1yfHlktWylvTPkHQFn+SL7QASL8d9bAifpFbwv1SSVHNKU59GDIYbOX9vsWqe1JyoSyT
	F65YD0EcejhkunAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A0wm2e9c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VQtO9FdC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781516126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afhcBrMHwtuNpl6EOyz1Ve+TLR1X1Oc6pxCJDnx1z1w=;
	b=A0wm2e9cm42qj6Nt6QFoHr1xCPbseD1yIj4YlRvk43PHySHrjrH5ewdfM1Olyx8hU8iSQ3
	GRuql8ut/sAK6Zwm/zYmWkILVhPVh21xP/+WBQFnp6M/SXNt8/h4o/m8LRASOp8gjWX3DZ
	YOWy+CzvrK4xB/kUSypZ0RXNMdThJLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781516126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afhcBrMHwtuNpl6EOyz1Ve+TLR1X1Oc6pxCJDnx1z1w=;
	b=VQtO9FdC4JV39U9SaPNzDuOosxdZ2fjfbcabW45ia/MaienRPG4n1qi1Ubkn42EwpAr0Ne
	0sFDJefdiMtxwlDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB1E0779A7;
	Mon, 15 Jun 2026 09:35:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xk9TKF7HL2qVRgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 15 Jun 2026 09:35:26 +0000
Date: Mon, 15 Jun 2026 11:35:25 +0200
From: Daniel Wagner <dwagner@suse.de>
To: WenTao Liang <vulab@iscas.ac.cn>
Cc: Ram Vegesna <ram.vegesna@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>, Kees Cook <kees@kernel.org>, James Smart <jsmart2021@gmail.com>, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: fix refcount leak in efct_hw_io_abort()
Message-ID: <b601d4e2-8b10-417d-8d4d-1c09e556e94a@flourine.local>
References: <20260611053037.63756-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611053037.63756-1-vulab@iscas.ac.cn>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C40D46AC95
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[broadcom.com,hansenpartnership.com,oracle.com,mt-integration.ru,kernel.org,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,iscas.ac.cn:email,suse.de:email,suse.de:dkim,flourine.local:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu, Jun 11, 2026 at 01:30:37PM +0800, WenTao Liang wrote:
> When efct_hw_reqtag_alloc() fails in efct_hw_io_abort(), the error
> path returns -ENOSPC without releasing the reference obtained via
> kref_get_unless_zero() earlier in the function. All other error
> paths correctly drop the reference. This causes a permanent
> reference leak on the io_to_abort object.
> 
> Additionally, the abort_in_progress flag is left set to true on
> this path, which means future abort attempts for the same I/O will
> immediately return -EINPROGRESS even though the abort was never
> submitted, effectively blocking recovery.
> 
> Fix this by adding the missing kref_put() call and reset
> abort_in_progress to false, matching the cleanup done in the
> efct_hw_wq_write() failure path below.
> 
> Cc: stable@vger.kernel.org
> Fixes: 63de51327a64 ("scsi: elx: efct: Hardware I/O and SGL initialization")
> Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>

Looks good to me.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
