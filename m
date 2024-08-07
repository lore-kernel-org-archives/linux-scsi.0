Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7151E4EEA;
	Wed,  7 Aug 2024 12:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723034416; cv=none; b=QSbR27Vb8gUMLkhZbm6bmEcA0HlkKUjrRWlJeXWwt8blWo0PYfWr00ThmXVdw1i7p1KepjK1Byj5nnA+arWWOjQQQ/jC8ZOH21ZuCCC+D6BKi7BDtmyDdbioPz482ybG44yycThbvr6upskM/KDauxDPSYAsGLhYzPtRxxsvZu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723034416; c=relaxed/simple;
	bh=MMcCKjZD1qOXK3roZ92z5qYh77YkNshJlnPYXW8WsIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhqGTpnkhyQK1MWWes6BkuoqH/cnd+IxRx9TVUMEB6tSYerxFyQB2WhdY7MluvtC4LUcMuVe3i69N5Q1wLq9smU5LALvexGd6+ilkv/SRcTmR/kmG+hJW9hA1vDlB+q8ypTbSoCLMm5MbCbala4bIHxNHJ3GmfE1iFl3sqnlEk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i2lr4Tqi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OPn1so45; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i+Q3/YfZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=13AZM8WA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i2lr4Tqi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OPn1so45";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i+Q3/YfZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="13AZM8WA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A42421D11;
	Wed,  7 Aug 2024 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723034413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3D8zwa0EAIBkB3CAmMxugbCWHzPs+nDHC+oncyiz9A=;
	b=i2lr4TqiJlsJVU9BWjmeBMgrbYbjhrMZZTYxnSg9mmZTJQG8EQbQFqVU7ZQQYlUlRc3IMz
	frcTZDPPvvGzeGMi8KJO3Cly9njD1EKemXW+UYA+pT0vs/B+WpB2sbx/s3NWkwUNljSXYD
	+/yE06i/DbL3v2uorv/YxdqdIgIbosE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723034413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3D8zwa0EAIBkB3CAmMxugbCWHzPs+nDHC+oncyiz9A=;
	b=OPn1so4532CHDBcImGuWndEQYqC/43rT4zFOJnVwr/HorkTx5d08gC9+HNx+jfM7bMkUie
	qDA/8RQxOkMPZTCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="i+Q3/YfZ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=13AZM8WA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723034412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3D8zwa0EAIBkB3CAmMxugbCWHzPs+nDHC+oncyiz9A=;
	b=i+Q3/YfZLkqeva9wE8QJu2DWWpg8FyirSYyxU0+Sq6sJxVmoneZuKS4OK3S1HnLxTIDn/f
	MbMGJCNCjg2ZSjyeaID4AogpD2A4If+JlS+zI6BpITn33SbPqm6j0SE211xOd5rr0ba84o
	0vmeJmvhw+lf3M+hBFkTpMGWxbB0Ojw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723034412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3D8zwa0EAIBkB3CAmMxugbCWHzPs+nDHC+oncyiz9A=;
	b=13AZM8WAynpgxBBasMTgR7QvRiMPKF3AHMfPz/dfdbbB1Q8JHQEykIP9d1rsnNcAkLtlNP
	2gZ1X6qb8V8r2pDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F21E713297;
	Wed,  7 Aug 2024 12:40:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c0zLOitrs2bpRQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 07 Aug 2024 12:40:11 +0000
Date: Wed, 7 Aug 2024 14:40:11 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
	Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Jonathan Corbet <corbet@lwn.net>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Sridhar Balaraman <sbalaraman@parallelwireless.com>, "brookxu.cn" <brookxu.cn@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <253ec223-98e1-4e7e-b138-0a83ea1a7b0e@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
 <ZrI5TcaAU82avPZn@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrI5TcaAU82avPZn@fedora>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.01 / 50.00];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,lst.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 1A42421D11
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -0.01

On Tue, Aug 06, 2024 at 10:55:09PM GMT, Ming Lei wrote:
> On Tue, Aug 06, 2024 at 02:06:47PM +0200, Daniel Wagner wrote:
> > When isolcpus=io_queue is enabled all hardware queues should run on the
> > housekeeping CPUs only. Thus ignore the affinity mask provided by the
> > driver. Also we can't use blk_mq_map_queues because it will map all CPUs
> > to first hctx unless, the CPU is the same as the hctx has the affinity
> > set to, e.g. 8 CPUs with isolcpus=io_queue,2-3,6-7 config
> 
> What is the expected behavior if someone still tries to submit IO on isolated
> CPUs?

If a user thread is issuing an IO the IO is handled by the housekeeping
CPU, which will cause some noise on the submitting CPU. As far I was
told this is acceptable. Our customers really don't want to have any
IO not from their application ever hitting the isolcpus. When their
application is issuing an IO.

> BTW, I don't see any change in blk_mq_get_ctx()/blk_mq_map_queue() in this
> patchset,

I was trying to figure out what you tried to explain last time with
hangs, but didn't really understand what the conditions are for this
problem to occur.

> that means one random hctx(or even NULL) may be used for submitting
> IO from isolated CPUs,
> then there can be io hang risk during cpu hotplug, or
> kernel panic when submitting bio.

Can you elaborate a bit more? I must miss something important here.

Anyway, my understanding is that when the last CPU of a hctx goes
offline the affinity is broken and assigned to an online HK CPU. And we
ensure all flight IO have finished and also ensure we don't submit any
new IO to a CPU which goes offline.

FWIW, I tried really hard to get an IO hang with cpu hotplug.
