Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20232EBBB5
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jul 2025 09:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751620918; cv=none; b=p9e+PBOvICSWCGuVu9xuGkQ2X4+Lx5d6sjwRROQDpLzIfjO885KnP9jGSPu0BnlRSb2ErYfpq64hsTfrc0T//qkGClxZ996M3eYkakGFBqLeiOnf76tZrx8nchWvLGtygtVaBZj3fnn574C1arpYFNZ4OGXO7jpG2lQb4iHAPW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751620918; c=relaxed/simple;
	bh=BCScqBO8AgTY7tekDwIiw7dj8X+T4EurNxV4DWxYGGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLuQuIIT9wiOfdSOgOeGWJ/I08NoKQ0pYzKhxc98gdIMOS3jAEglbmXBz4eVmRNDsJoJjw60QekAyhrlln7yzW5djsn1CQVcl6nQqryavRSXhETXwFFqmV5p4VlBzxsq1K8AIOw8XVYrkgW85Szy/yMGe+Hel50S7j/Q9SDhSUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EmN0pxRp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n2F5+5fc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R+MyKEol; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7j4T0NGp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EmN0pxRp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n2F5+5fc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R+MyKEol";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7j4T0NGp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCE311F38A;
	Fri,  4 Jul 2025 09:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751620915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5woB+8MxyV3T68ceBaY+75z4ul70wqMhMKbKCDmKZjU=;
	b=EmN0pxRpVaMhBUAUzucq+7X8P5sBGednjqHNm/DekL6I4UTrQUWZqrXtT+YRZBIE9Patk3
	97gTEQQGn9T0Nt+aFuQi1ufCDZtdg0r7YwNLTmGdEZ71zzdSJ5yxG4brG5wCizsg6KrdwG
	+hOjEgp4+xVFcHEczQMddymwrvWFlbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751620915;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5woB+8MxyV3T68ceBaY+75z4ul70wqMhMKbKCDmKZjU=;
	b=n2F5+5fcHOhQjLZpkaEFHKb4ePyf0CSogZTYDmloS5tzHhbF+ezlzohMClPPfi+TpHwAHq
	2clJgihwaiTFD7BA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=R+MyKEol;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7j4T0NGp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751620914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5woB+8MxyV3T68ceBaY+75z4ul70wqMhMKbKCDmKZjU=;
	b=R+MyKEolL2LbDXKCXiZ9deuHSz+B1/cUbwJSF54ooogriCF0jUt4L2fiVpNQAwJJSi5Pne
	3DA7yJ1VPgfqpJzyY4nceHitGg7mJ+Yz617XJTxDSqTPMhbxeLc7WdPIzLjt6+dDwRILZ5
	qstDfAAzHm/7vhb5vfuOHmAUGsMVaNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751620914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5woB+8MxyV3T68ceBaY+75z4ul70wqMhMKbKCDmKZjU=;
	b=7j4T0NGp7d7ugWNlrR0LYzq/FmEk3EP0/J6G+zNKlNcRDyyBajNb484cY4vyWkysycIygm
	WZAyCIvA0IAqtwBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9471F13757;
	Fri,  4 Jul 2025 09:21:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ooQ9JDKdZ2gbJAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 04 Jul 2025 09:21:54 +0000
Date: Fri, 4 Jul 2025 11:21:49 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v7 08/10] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <e2e62f99-164d-4e80-be1e-9affa724efd0@flourine.local>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-8-557aa7eacce4@kernel.org>
 <9025c412-9b6f-4714-a880-e8e6084e1b4c@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9025c412-9b6f-4714-a880-e8e6084e1b4c@suse.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: BCE311F38A
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	TO_DN_SOME(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL71uuc3g3e76oxfn4mu5aogan)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,flourine.local:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On Thu, Jul 03, 2025 at 08:58:02AM +0200, Hannes Reinecke wrote:
> > +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> > +		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
> > +
> > +		for_each_cpu(cpu, &hk_masks[idx]) {
> > +			qmap->mq_map[cpu] = idx;
> > +
> > +			if (cpu_online(cpu))
> > +				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);
> 
> Why cpu_online? Up until this point it really didn't matter if the affinity
> mask was set to 'online' or 'possible' cpus, but here you
> require CPUs to be online...

This part here tracks if the a hardware context has at least one
housekeeping CPU online. It is possible to provide configuration where
we end up with hardware context which have offline housekeeping CPUs and
online isolcpus. active_hctx tracks which of the hardware contexts is
usable which is used in the next step...

> > +		}
> > +	}
> > +
> > +	/* Map isolcpus to hardware context */
> > +	queue = cpumask_first(active_hctx);
> > +	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
> > +		qmap->mq_map[cpu] = (qmap->queue_offset + queue) % nr_masks;
> > +		queue = cpumask_next_wrap(queue, active_hctx);
> > +	}
> 
> Really? Doesn't this map _all_ cpus, and not just the isolcpus?

for_each_cpu iterates over is all CPUs which are not houskeeping CPUs
(mask is the housekeeping mask), thus these are all isol CPU. Note the
'andnot' part.

The cpumask_first/cpumask_next_wrap returns only hardware context which
have at least one housekeeping CPU which is online. Yes, it possible to
make this a bit smarter, so that we keep the grouping of the offline
CPUs intact, though I am not sure if it is worth to add complexity for a
corner case at least not yet.

> > +fallback:
> > +	/*
> > +	 * Map all CPUs to the first hctx to ensure at least one online
> > +	 * housekeeping CPU is serving it.
> > +	 */
> > +	for_each_possible_cpu(cpu)
> > +		qmap->mq_map[cpu] = 0;
> 
> I think you need to map all hctx, no?

The block layer is filtering out hctx which have no CPU assigned to it
when selecting a queue. This is really a failsafe mode, it just makes
sure the system boots.

> > +	/* Map housekeeping CPUs to a hctx */
> > +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> > +		for_each_cpu(cpu, dev->bus->irq_get_affinity(dev, offset + queue)) {
> > +			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> > +
> > +			cpumask_set_cpu(cpu, mask);
> > +			if (cpu_online(cpu))
> > +				cpumask_set_cpu(qmap->mq_map[cpu], active_hctx);
> 
> Now that is really curious. You pick up the interrupt affinity from the
> 'bus', which, I assume, is the PCI bus. And this would imply that the
> bus can (or already is) programmed for this interrupt affinity.

Yes, this is the case. irq_create_affinity_masks which use
group_cpu_evenly/group_mask_cpu_evenly for the number of requested IRQs.
The number of IRQs can be higher than the number of requested queues
here. It's necessary to use the affinity mask created by
irq_create_affinity_mask as input.

> Which would imply that this is a usable interrupt affinity from the
> hardware perspective, irrespective on whether the cpu is online or
> not. So why the check to cpu_online()? Can't we simply take the existing affinity
> and rely on the hardware to do the right thing?

Again, this is tracking if a htcx has online housekeeping CPU.
