Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DC919AA41;
	Tue, 13 Aug 2024 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723553632; cv=none; b=ftpUuxZH73xGHLSSKz1R9mTninyo8nDcPujH4DUVZNOr+ahM9YtAencIHWhMblhLbUVyjdLlcXqCiMhsb//++tQvvZ+/B9OZg47+fHrlBjCP2/KsJbNqD7GnTY35QB7D5sITdGt+cDTMeHZ7bviKYW0wEOeXyKTr+Bb8C0T0afc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723553632; c=relaxed/simple;
	bh=jwK2TlgIDhYpakRh1Z0xP+alf9Sez9NbvBRofDhBaw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQEH3d9YA4yP8HvAuaPugrgbPA4qNc0xuQqejbobxtBsRpI0r8z3uv1it+44Go29lbTN3n6Fnb+7f2e2PQlBCp0xNwkt9NTTv/k2bspR+ajYQUyopA09pAEmnnBRD54YZfbRTqc5Pjka+QtmLlxT7dpA/BJy0KntptvdCsk3StE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K4sW7RNY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1p5CVffu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=K4sW7RNY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1p5CVffu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K4sW7RNY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1p5CVffu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="K4sW7RNY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1p5CVffu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 51CB6203A9;
	Tue, 13 Aug 2024 12:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723553627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ldBhhXhLflU1qxSrHLUqzxurI60DSoqQk+G18vzng/Q=;
	b=K4sW7RNYFvfGPiJ1s4M9XTyUkNNoHbhFCX7/zdRo+Qze9s17TNOIZ+G1pGC8q147PNO3tt
	C7ZO5R8fUBb8oLsitIngMHXpkPjQte2VX/nkuj80uWcEPiI4/kggiS3ISplU96ioxRiby7
	R1GMI0V2arrVgBc2fhP1yasHYHDn580=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723553627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ldBhhXhLflU1qxSrHLUqzxurI60DSoqQk+G18vzng/Q=;
	b=1p5CVffu8orDjTT19oDab+6bz5B96IMGuu78zx1L/LcwehiGMx/tHU22DueaJ5ZNehbnpP
	xPfU7UE4k6H41ZDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K4sW7RNY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1p5CVffu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723553627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ldBhhXhLflU1qxSrHLUqzxurI60DSoqQk+G18vzng/Q=;
	b=K4sW7RNYFvfGPiJ1s4M9XTyUkNNoHbhFCX7/zdRo+Qze9s17TNOIZ+G1pGC8q147PNO3tt
	C7ZO5R8fUBb8oLsitIngMHXpkPjQte2VX/nkuj80uWcEPiI4/kggiS3ISplU96ioxRiby7
	R1GMI0V2arrVgBc2fhP1yasHYHDn580=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723553627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ldBhhXhLflU1qxSrHLUqzxurI60DSoqQk+G18vzng/Q=;
	b=1p5CVffu8orDjTT19oDab+6bz5B96IMGuu78zx1L/LcwehiGMx/tHU22DueaJ5ZNehbnpP
	xPfU7UE4k6H41ZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39A3013983;
	Tue, 13 Aug 2024 12:53:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wYcIDltXu2bpCQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 13 Aug 2024 12:53:47 +0000
Date: Tue, 13 Aug 2024 14:53:46 +0200
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
Message-ID: <ba8a2ccd-1893-42e1-8ed9-dde6c43a2c95@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
 <ZrY0jp7S0Xnk9VUw@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrY0jp7S0Xnk9VUw@fedora>
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 51CB6203A9
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,lst.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLbomrtoisjzkgzhj6iko5ju7u)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, Aug 09, 2024 at 11:23:58PM GMT, Ming Lei wrote:
> From above implementation, "isolcpus=io_queue" is actually just one
> optimization on "isolcpus=managed_irq", and there isn't essential
> difference between the two.

Indeed, the two versions do not differ so much. I understood, that you
really want to keep managed_irq as it currently is and that's why I
thought we need io_queue.

> And I'd suggest to optimize 'isolcpus=managed_irq' directly, such as:
> 
> - reduce nr_queues or numgrps for group_cpus_evenly() according to
> house-keeping cpu mask

Okay.

> - spread house-keeping & isolate cpu mask evenly on each queue, and
> you can use the existed two-stage spread for doing that

Sure if we can get the spreading sorted out so that not all isolcpus are
mapped to the first hctx.

Thanks,
Daniel
