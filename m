Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D594776026
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749223904; cv=none; b=B+FD/ZpCaxws3LPS4tXvXpYLxg2zLaSl961sZumSFOS6WZArrOOUqmXog9Oq1QMbapGwJs0XOPRbb9W1+nFCJCz0inQC64QJGXDVLOuOeNxe7EXXYEdFNS50aNHW7zRqVxe67otMv/Kw9Kaybeo53qpjfwMdEC5Um1RH2G3d10c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749223904; c=relaxed/simple;
	bh=ts8dwlbbfaDCvJ505Qq6ciBe4/o68ORgX2CetiiL7UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hB99gEtNVTPOZVNXbEk5lhFgmZRbJuMXBxHNbr7vL7vAS3hrfQCTdq6833MkhRMJX7FDlRRlfhl8q35L7yyBhSHmi5Cu9ViMsOsQ+GwJRk/0hami9lI6NG51OF34zj+sJNDy+LGrIBcenXxwWN3wBU5zalv2GisDtpZCbRpP9qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kdo2FLY6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0YFAcE5i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kdo2FLY6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0YFAcE5i; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kdo2FLY6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0YFAcE5i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kdo2FLY6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0YFAcE5i"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1FC1C336A1;
	Fri,  6 Jun 2025 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749223900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTaxRHKwF+vzmXr0h8gchfeJdwPaFIf2cEMCCW/n7+A=;
	b=kdo2FLY6uImYG5myX98OBi1M5XgqczBq0Pj7pql0UDXaqgIoVf3R531K9uUlUTdyygWzO5
	GvheP0Nt5TJtxV53GFB/kbLM24NaPDSVCriNYC4BWFHwn8u/pL3Np7E4CkzXsfwML2Afgy
	LZ7AmLGGC3tuQ7Ke8oZ1dw25q54fQHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749223900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTaxRHKwF+vzmXr0h8gchfeJdwPaFIf2cEMCCW/n7+A=;
	b=0YFAcE5iTeNsslsFY3deRp4aKNCW6rXvHCWSidKaiIDLu8LWQ+TRPaCBB3vLKq7/MtpHhA
	vyDej2B7YEVbPxDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749223900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTaxRHKwF+vzmXr0h8gchfeJdwPaFIf2cEMCCW/n7+A=;
	b=kdo2FLY6uImYG5myX98OBi1M5XgqczBq0Pj7pql0UDXaqgIoVf3R531K9uUlUTdyygWzO5
	GvheP0Nt5TJtxV53GFB/kbLM24NaPDSVCriNYC4BWFHwn8u/pL3Np7E4CkzXsfwML2Afgy
	LZ7AmLGGC3tuQ7Ke8oZ1dw25q54fQHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749223900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTaxRHKwF+vzmXr0h8gchfeJdwPaFIf2cEMCCW/n7+A=;
	b=0YFAcE5iTeNsslsFY3deRp4aKNCW6rXvHCWSidKaiIDLu8LWQ+TRPaCBB3vLKq7/MtpHhA
	vyDej2B7YEVbPxDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0EFA31336F;
	Fri,  6 Jun 2025 15:31:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mXxgA9wJQ2g7LAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 06 Jun 2025 15:31:40 +0000
Date: Fri, 6 Jun 2025 17:31:39 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Yi Zhang <yi.zhang@redhat.com>, 
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"nbd@other.debian.org" <nbd@other.debian.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, 
	Tomas Bzatek <tbzatek@redhat.com>
Subject: Re: blktests failures with v6.15 kernel
Message-ID: <d1e5aefd-9669-4638-9466-951e69df1176@flourine.local>
References: <2xsfqvnntjx5iiir7wghhebmnugmpfluv6ef22mghojgk6gilr@mvjscqxroqqk>
 <7cdceac2-ef72-4917-83a2-703f8f93bd64@flourine.local>
 <rcirbjhpzv6ojqc5o33cl3r6l7x72adaqp7k2uf6llgvcg5pfh@qy5ii2yfi2b2>
 <CAHj4cs8SqXUpbT49v29ugG1Q36g5KrGAHtHu6sSjiH19Ct_vJA@mail.gmail.com>
 <38a8ec1a-dbca-43f1-b0fa-79f0361bbc0b@flourine.local>
 <14194a5f-e320-45e0-8f6c-019ce3bd4dbe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14194a5f-e320-45e0-8f6c-019ce3bd4dbe@kernel.dk>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[flourine.local:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

On Fri, Jun 06, 2025 at 09:03:11AM -0600, Jens Axboe wrote:
> On 6/6/25 8:58 AM, Daniel Wagner wrote:
> > FWIW, the contributor for the io_uring feature, stated that it improved
> > the performance for some workloads. Though, I think the whole
> > integration is sub-optimal, as a new io_uring is created/configured for
> > each get_log_page call. So only for a large transfers there is going to
> > help.
> 
> That's crazy... What commit is that?

adee4ed1c8c8 ("ioctl: get_log_page by nvme uring cmd")

ioctl: get_log_page by nvme uring cmd
Use io_uring for fetching log pages.

This showed about a 10% performance improvement for some large log pages.


https://github.com/linux-nvme/libnvme/commit/adee4ed1c8c8

Should I rip it out? I am not really attached to it.
