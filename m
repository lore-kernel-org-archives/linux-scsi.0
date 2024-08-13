Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179DD18A94E;
	Tue, 13 Aug 2024 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723554708; cv=none; b=SzMbdR8o/4wFtAQFujCKZswKiQleiBWUgvkR8MFOCPqsYaoA2XooFeKGzuky9nhQLOtDz0GBjfvFjXSk9Q7lmuq2HoTBsmQZxxXq3nB/8+gswDQI296kPkw4UvVkauKob/+528o8jvW1SKau6vusFHmtPrpC/PtnsokMXZqH1E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723554708; c=relaxed/simple;
	bh=nwrRtJCWatyFdWExCpf1lT5rClcrqjnVxyIfQtEz6Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQD1ZWly2giJMtz4hNfb8TauzoIzJdVGiHJryYzd6Sg8tVblfvWmfttp2nk3oNpJPXD8QK57j200rtsuC1QDROQlgNrKA2hTDofOn1QQUCGRNuDaA8YHZsBcDflsePjwzzgI98z78TCpsrVyi1SaQ6QKSvYBCo1JcEOVakiwEm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YdDshMQ7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jgOPz3i3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YdDshMQ7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jgOPz3i3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YdDshMQ7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jgOPz3i3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YdDshMQ7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jgOPz3i3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 25794203AD;
	Tue, 13 Aug 2024 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723554705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwrRtJCWatyFdWExCpf1lT5rClcrqjnVxyIfQtEz6Gk=;
	b=YdDshMQ7mxAV0JmLSj07L+9KBwxzqqdROUsHk7zW52djSfjt2r1H+mR0AfJZRzuk2w8yfX
	vv5bj/v6JTTBnlWHHXZ4Ss3AtQLlYksZuydh38qcf0wxRJg74gpxtK2rIsgwb85A4c7jeU
	Nns7Nr84GgwQXduUdiV1cIG9Nwke9Kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723554705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwrRtJCWatyFdWExCpf1lT5rClcrqjnVxyIfQtEz6Gk=;
	b=jgOPz3i3I+pHId0uPcovGl1gP+PcrknurukRnQ9/MIRbTNL2FznL1bIx+X+VU/S0YIXfBU
	3Bi2rUnnKahamfCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YdDshMQ7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jgOPz3i3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723554705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwrRtJCWatyFdWExCpf1lT5rClcrqjnVxyIfQtEz6Gk=;
	b=YdDshMQ7mxAV0JmLSj07L+9KBwxzqqdROUsHk7zW52djSfjt2r1H+mR0AfJZRzuk2w8yfX
	vv5bj/v6JTTBnlWHHXZ4Ss3AtQLlYksZuydh38qcf0wxRJg74gpxtK2rIsgwb85A4c7jeU
	Nns7Nr84GgwQXduUdiV1cIG9Nwke9Kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723554705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nwrRtJCWatyFdWExCpf1lT5rClcrqjnVxyIfQtEz6Gk=;
	b=jgOPz3i3I+pHId0uPcovGl1gP+PcrknurukRnQ9/MIRbTNL2FznL1bIx+X+VU/S0YIXfBU
	3Bi2rUnnKahamfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F16EB13983;
	Tue, 13 Aug 2024 13:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7myfOpBbu2buDwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 13 Aug 2024 13:11:44 +0000
Date: Tue, 13 Aug 2024 15:11:44 +0200
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
Message-ID: <6449daa0-b8e1-4c5d-86ad-19dada7c849e@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
 <ZrtX4pzqwVUEgIPS@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrtX4pzqwVUEgIPS@fedora>
X-Rspamd-Queue-Id: 25794203AD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,lst.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RLbomrtoisjzkgzhj6iko5ju7u)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,flourine.local:mid,suse.de:dkim]
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, Aug 13, 2024 at 08:56:02PM GMT, Ming Lei wrote:
> With patch 14 and the above change, managed irq's affinity becomes not
> matched with blk-mq mapping any more.

Ah, got it. The problem here is that I need to update also the irq
affinity mask for the hctx when offlining a CPU.
