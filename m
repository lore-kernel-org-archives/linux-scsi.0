Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8BC270EC5
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2025 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747239132; cv=none; b=nlCLwfNoPd164WwNFOSZNhLYrzechCwxgk5bSr7g/Xv/GKDaGdUOS6SAOiwiIX1ybmBHziZKzfJS/lX3rSAmxeG5+IZ85cVdoOUow1jWZS+p9INDtYoni8zFL8CVFza9B0xGGfOFh67Uklq/GeVz+InoA/Bpwyx8+LgNIQpUAMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747239132; c=relaxed/simple;
	bh=Tc1WEC6mukBGISKXbX7oV3/8t3QATZkL0G9tUHp6EiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nsxgtx/405PErIUCIdv/I8IkugmG6njV6Wfrofz2X7HvXwZ5RpJeLQA5bOZYEmLtaC2Bg8cgw97RbTE2HtcwzeKeWB2eh0FMk4RD4PprWYrg2SnGJKoOUlKz+n2hB9lQXG52T2LWac9H0csnZIBO8HZ0f7h0P25PBTLvYySlDiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EJmOGm9P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lZHtHWmK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EJmOGm9P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lZHtHWmK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EJmOGm9P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lZHtHWmK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EJmOGm9P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lZHtHWmK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 32D5A1F385;
	Wed, 14 May 2025 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747239129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=STZQ8x0gSAX9WjIt5SVFokSpCJQ8PbOmFgE/9PLLIhE=;
	b=EJmOGm9PKixSH0pBR91qRqXYKq8qKdFnS6nqlcRpChmGnbpdfRKJgQdCHpXH9MTlBc9Vjn
	GOfCAMklY65GzKhDbBpgJwKm/30lDEGJQ4j8j/e7pH5Zq4y5Wjy8NSad4HsAFEpfcOBdEv
	ySZwBtHVBedzbw31oMKEZ6nZ8UZo130=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747239129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=STZQ8x0gSAX9WjIt5SVFokSpCJQ8PbOmFgE/9PLLIhE=;
	b=lZHtHWmK8s/xncFAvTbbHnL0HfsbqcJjLsrOs2UFu20Hk0aX881NBzWxAesZ590ueFCLn5
	3CoWIMsnzTcSf2BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747239129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=STZQ8x0gSAX9WjIt5SVFokSpCJQ8PbOmFgE/9PLLIhE=;
	b=EJmOGm9PKixSH0pBR91qRqXYKq8qKdFnS6nqlcRpChmGnbpdfRKJgQdCHpXH9MTlBc9Vjn
	GOfCAMklY65GzKhDbBpgJwKm/30lDEGJQ4j8j/e7pH5Zq4y5Wjy8NSad4HsAFEpfcOBdEv
	ySZwBtHVBedzbw31oMKEZ6nZ8UZo130=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747239129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=STZQ8x0gSAX9WjIt5SVFokSpCJQ8PbOmFgE/9PLLIhE=;
	b=lZHtHWmK8s/xncFAvTbbHnL0HfsbqcJjLsrOs2UFu20Hk0aX881NBzWxAesZ590ueFCLn5
	3CoWIMsnzTcSf2BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0BC6F13306;
	Wed, 14 May 2025 16:12:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g0F1AtnAJGhgNwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 14 May 2025 16:12:09 +0000
Date: Wed, 14 May 2025 18:12:04 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin <costa.shul@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	Waiman Long <llong@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 3/9] nvme-pci: use block layer helpers to calculate
 num of queues
Message-ID: <66cd13b0-3339-4495-8d1a-fae3211f92b9@flourine.local>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-3-9a53a870ca1f@kernel.org>
 <aB1eswAv6Tz2WDpc@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB1eswAv6Tz2WDpc@fedora>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On Fri, May 09, 2025 at 09:47:31AM +0800, Ming Lei wrote:
> On Thu, Apr 24, 2025 at 08:19:42PM +0200, Daniel Wagner wrote:
> > Multiqueue devices should only allocate queues for the housekeeping CPUs
> > when isolcpus=io_queue is set. This avoids that the isolated CPUs get
> > disturbed with OS workload.
> 
> The commit log needs to be updated:
> 
> - io_queue isn't introduced yet
> 
> - this patch can only reduce nr_hw_queues, and queue mapping isn't changed
> yet, so nothing to do with
> 
>  "This avoids that the isolated CPUs get disturbed with OS workload"

What about:

  The calculation of the upper limit for queues does not depend solely on
  the number of possible CPUs; for example, the isolcpus kernel
  command-line option must also be considered.

  To account for this, the block layer provides a helper function to
  retrieve the maximum number of queues. Use it to set an appropriate
  upper queue number limit.

I would use this version for the other patches as well,
s/possible/online/ where necessary.
