Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE061C9DD6;
	Wed,  7 Aug 2024 12:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723033546; cv=none; b=aMtUpdez5P9XAgnGZSVOz+bdbGYQTSIgWmTHjY/pFZ4FbDQkEqhxcYDQKwEZGLGNr1NUQjcbyhrcrHfRoWEZgWdMZmc3qvVLTDZt3pUk7VMf7EXaJieDl6ysMMEuuQ8OnLTLu8/izkjRjvt/1PmY4vfrQADtVoTtC/g0gKW3JZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723033546; c=relaxed/simple;
	bh=KXUfVtnXLyXqEnbGZRas1EUNJDaDnjU5WDVJX9vPLkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZ8JUaO7o+Lxi9njP4COsg9O51+XdZL27ZUQSEYXoooYPWU3Py5XUAHBsTmGhxnKDSGOrv0mkPLR/eCb6oi5v27sxRLbHe+mKVsoAzh2LL6xG0QrGqsX+WGIUNcAZipNm+vVtb8TV956oBsTDoUoUTwSQTvuESQfh8cyVBwZ52s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bd3Wn+py; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8fQVj1Ps; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oop01eNG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J8Ka3YmO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bd3Wn+py";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8fQVj1Ps";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oop01eNG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J8Ka3YmO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5CA421F396;
	Wed,  7 Aug 2024 12:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723033541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yVWjAs9WXrl4kGgXGATPkVai9PljP0etPSTQQnS2QiI=;
	b=bd3Wn+py9efQxXW3smgg7jWhVe14RwWStx4yd+9rm3RSots00g1+pMF8Rxi99XkI0Oa3ZV
	ffKJfsoGd9hBJyR79g97A1yjz+avRUU3YYCJrFi9CxgZAD8tXLWQTLz5AuzkAA1I7R0hHZ
	HZuFqDRcKeYfr0PX9SAmW8igYpYe4tY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723033541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yVWjAs9WXrl4kGgXGATPkVai9PljP0etPSTQQnS2QiI=;
	b=8fQVj1Psr2pB7zzi/JFRxgVGhdNpUPbPydqVCH7CJ8h1B91xrbmHVjI8k2KN7bzY+/JOzM
	ULLsvKvFhNPorcDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oop01eNG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=J8Ka3YmO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723033540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yVWjAs9WXrl4kGgXGATPkVai9PljP0etPSTQQnS2QiI=;
	b=oop01eNGkx0mPBr5oUBWM9I23aXnYMryYtskQ6clC/qMJ7j1BufNd5fgbi7VxkLJbvuJC/
	faVEHigyzxcey6HK1izbuRtp7Om3kmkKMGiwHlV0K/+84vH+UIM2PeAZL6x1ylUaF7Mz7H
	9nU9fGSf6VEoXf6nprg90vwlmZnIkws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723033540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yVWjAs9WXrl4kGgXGATPkVai9PljP0etPSTQQnS2QiI=;
	b=J8Ka3YmONW96GsfVhq+lIJJXvXtL3PEvRJKVAvV1diw1Y6hN2UdE5T1a2fUvsbPp1uojOU
	sf7KQNJ7IfQSarDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E75313A7D;
	Wed,  7 Aug 2024 12:25:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /cv6DsRns2YzQQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 07 Aug 2024 12:25:40 +0000
Date: Wed, 7 Aug 2024 14:25:39 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Stefan Hajnoczi <stefanha@gmail.com>
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
	Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, virtualization@lists.linux.dev, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 00/15] honor isolcpus configuration
Message-ID: <f48a032f-e1e0-42fc-afc6-5aa5ccc3514d@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <CAJSP0QVod5DA2hdNFrpN+HZcfm6Bg11teRmt5d+MBTB1wH4vZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QVod5DA2hdNFrpN+HZcfm6Bg11teRmt5d+MBTB1wH4vZg@mail.gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.01 / 50.00];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[35];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,lst.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gitlab.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim]
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 5CA421F396
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -0.01

On Tue, Aug 06, 2024 at 09:09:50AM GMT, Stefan Hajnoczi wrote:
> On Tue, 6 Aug 2024 at 08:10, Daniel Wagner <dwagner@suse.de> wrote:
> > The only stall I was able to trigger
> > reliable was with qemu's PCI emulation. It looks like when a CPU is
> > offlined, the PCI affinity is reprogrammed but qemu still routes IRQs to
> > an offline CPU instead to newly programmed destination CPU. All worked
> > fine on real hardware.
> 
> Hi Daniel,
> Please file a QEMU bug report here (or just reply to this emails with
> details on how to reproduce the issue and I'll file the issue on your
> behalf):
> https://gitlab.com/qemu-project/qemu/-/issues
> 
> We can also wait until your Linux patches have landed if that makes it
> easier to reproduce the bug.

Thanks for the offer. I tried simplify the setup and come up with
producer using qemu directly instead with libvirt. And now it works just
fine. I'll try to figure out what the magic argument...
