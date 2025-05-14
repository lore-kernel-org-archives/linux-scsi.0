Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1B327A131
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2025 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747238929; cv=none; b=Cbb5he9Pv9Tz3SGo+KfvnsxcSDcb0DyOUVbgqjAwYrcWnS1p+mCIyZQ9eOYHhdHI/usBQjw2hxb5HdrTxTbSlEz20c6lYjYTrc4gYHSFMptyX+smOtEfdwbZWD13aHd0BT3T/+ElmGxW0aE/DjD7Z/hdgAvJxVFdJnUnd19nGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747238929; c=relaxed/simple;
	bh=5fAT4CSDvQk622hLuqJhH4j1jI7xnRXlu4+YkixUDqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENwQ5XVYyNiSz9DTXKubBjOadoAWwZOX8tRG64F5bgsyAs/sTP+pMKp3WAXIv5kXspO07O4knZ4aj/x/ycuDvQTyhPCKZkD1bNZuN2txYQ+YmKBw29AvDBuACGC6E21ZuTurXCvmdHg+k9phDT1kWGKTqpipgF8xsyfSp3UZbaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HP9Skt9r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3ZEaJ1jc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HP9Skt9r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3ZEaJ1jc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HP9Skt9r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3ZEaJ1jc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HP9Skt9r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3ZEaJ1jc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 64FC6211C6;
	Wed, 14 May 2025 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747238925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwemYqSx1joAsHvddH5vUeTn++S/Lwwkxkdrd/VN3vE=;
	b=HP9Skt9rm7WKGVr9FhJS2qwWSQVBH16kWhzGzuXqPtnM/6MWapaWsEltEX2cHd7ywkHXvq
	0E1gGk0BDq0FfYCf0huIb9Nnnqf3kxOH2itS/Zdcz2F61nXWPZ2WD1YuyhF5cX29N06GNW
	325yGH3/h6im5SHcyN/Pr9/EpGCTqvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747238925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwemYqSx1joAsHvddH5vUeTn++S/Lwwkxkdrd/VN3vE=;
	b=3ZEaJ1jculhnrIBINmPnOy5TNzJkzkJPwTpxmwz3MwwbjatG7zMWo8waQCnZUs40+mCAsJ
	syFDyZQ1ARf5iiAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747238925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwemYqSx1joAsHvddH5vUeTn++S/Lwwkxkdrd/VN3vE=;
	b=HP9Skt9rm7WKGVr9FhJS2qwWSQVBH16kWhzGzuXqPtnM/6MWapaWsEltEX2cHd7ywkHXvq
	0E1gGk0BDq0FfYCf0huIb9Nnnqf3kxOH2itS/Zdcz2F61nXWPZ2WD1YuyhF5cX29N06GNW
	325yGH3/h6im5SHcyN/Pr9/EpGCTqvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747238925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PwemYqSx1joAsHvddH5vUeTn++S/Lwwkxkdrd/VN3vE=;
	b=3ZEaJ1jculhnrIBINmPnOy5TNzJkzkJPwTpxmwz3MwwbjatG7zMWo8waQCnZUs40+mCAsJ
	syFDyZQ1ARf5iiAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E58C13306;
	Wed, 14 May 2025 16:08:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1RI1Dw3AJGhoNgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 14 May 2025 16:08:45 +0000
Date: Wed, 14 May 2025 18:08:40 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Daniel Wagner <wagi@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 6/9] isolation: introduce io_queue isolcpus type
Message-ID: <706b08be-781c-45d6-8c16-93d6d97b4330@flourine.local>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-6-9a53a870ca1f@kernel.org>
 <2db989db-4849-46a9-9bad-0b67d85d1650@suse.de>
 <dd4719dc-5ac4-44d9-bccb-e867d322864e@flourine.local>
 <aB1iolILQcvvHDE9@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB1iolILQcvvHDE9@fedora>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On Fri, May 09, 2025 at 10:04:18AM +0800, Ming Lei wrote:
> > 			io_queue
> > 			  Isolate from IO queue work caused by multiqueue
> > 			  device drivers. Restrict the placement of
> > 			  queues to housekeeping CPUs only, ensuring that
> > 			  all IO work is processed by a housekeeping CPU.
> > 
> > 			  Note: When an isolated CPU issues an IO, it is
> > 			  forwarded to a housekeeping CPU. This will
> > 			  trigger a software interrupt on the completion
> > 			  path.
> > 
> > 			  Note: It is not possible to offline housekeeping
> > 			  CPUs that serve isolated CPUs.
> 
> This patch adds kernel parameter only, but not apply it at all, the above
> words just confuses everyone, so I'd suggest to not expose the kernel
> command line & document until the whole mechanism is supported.

I'll add this doc update as last patch.

> Especially 'irqaffinity=0 isolcpus=io_queue' requires the application
> to offline CPU in order, which has to be documented:
> 
> https://lore.kernel.org/all/cc5e44dd-e1dc-4f24-88d9-ce45a8b0794f@flourine.local/

Okay, so you want me to extend the above second note in this case. I'll
give it a go.
