Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129281F866B
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2025 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747244969; cv=none; b=UMHPtgiA7D3mEczoMUEsYbvsjAL0HIfkXNhnW9S/f4xxY0SAj2IVn1HQ7UQF1qXvpgpBkOYLyG/MqTwNqXt3pVEAembL+vXv6FjmNWpeZgFA2LK9jyzSoJLyaR12MBE6Ut8USAn69buKLe59Oy76DgyRanIRZE1O3VFhfFgMF80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747244969; c=relaxed/simple;
	bh=LxTfSd/7IAwsDPnzSG3cxLZevfygYzh7L/1opFHyldA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEnbUXC7iRVsTuprnM9wqVfyI3tI1Q9IhnjNLV8xEmHhTnpfS4Fe4el2Lv3eM2+GCJuYgy3Obgn55vhLYHe0H0hmmwjBU0wMbBMFk4RLtKSpKmRSmV0OxmInIQiX3w/COo2cYFZQJoIMoWdY6KxYZbjknS4YiSamOxePYaKk2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=c3z0KGJT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k5sUYedm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=slKEHsve; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MN5gXTrk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="c3z0KGJT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k5sUYedm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="slKEHsve";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MN5gXTrk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 130111F399;
	Wed, 14 May 2025 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747244966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DmGO+NabaKpfrrkQS+LCDqhwMzhbABcI3RxnkP+9bj4=;
	b=c3z0KGJTV2vnFpdTSyoUNzljvLnILUDEMaasdHw6Oy/kgmK5QP/4WAG2U5oGk/5IHTzO80
	QchKXHJ42LcNvWBb95zDXyUHEY8mFVS7vrpd/7W2cphVwkywbvRDTqjCmDLElXUJl2VEAc
	To3oJEh5ubYJIkUefzGn20v+kPsgd2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747244966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DmGO+NabaKpfrrkQS+LCDqhwMzhbABcI3RxnkP+9bj4=;
	b=k5sUYedmbXgKVYrKaS+vGV9REJF5079skawrmBEuivZnSzCWop+lC8+K9qbKY4J5EVM6hz
	OsUhOKvlfZSR4FCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747244965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DmGO+NabaKpfrrkQS+LCDqhwMzhbABcI3RxnkP+9bj4=;
	b=slKEHsveynpUG2MSh7A2qlx3v72ZYhuw7/NON85cE9u9CLH0L3QIoV+Qy0HNHySNg+6SKm
	L/EY/qawjhjhgFQIxsc3Q8KkB4VO1eYwU5v565MmjThEAK/pTrDyjMfnCIFZAei3XH3wac
	EUXiwfN9YHqXZELr5ZcFf3jdeOEpeZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747244965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DmGO+NabaKpfrrkQS+LCDqhwMzhbABcI3RxnkP+9bj4=;
	b=MN5gXTrkQKzK9YZEOjvXI5BWfonVrNqEbB2mOKVNSZWDE28CQr9myrvNbNCRc63QukAJIM
	z6O/jWSZdT7tvwAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE9A413306;
	Wed, 14 May 2025 17:49:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9B1SNqTXJGiNUwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 14 May 2025 17:49:24 +0000
Date: Wed, 14 May 2025 19:49:20 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Waiman Long <llong@redhat.com>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin <costa.shul@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 7/9] lib/group_cpus: honor housekeeping config when
 grouping CPUs
Message-ID: <770522cc-79fd-415b-9f4e-f25f8c73194e@flourine.local>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-7-9a53a870ca1f@kernel.org>
 <cd1576ee-82a3-4899-b218-2e5c5334af6e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd1576ee-82a3-4899-b218-2e5c5334af6e@redhat.com>
X-Spam-Level: 
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[flourine.local:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30

On Tue, May 06, 2025 at 02:18:32PM -0400, Waiman Long wrote:
> > +static struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
> > +					      const struct cpumask *cpu_mask,
> > +					      unsigned int *nummasks)

> > +struct cpumask *group_cpus_evenly(unsigned int numgrps,
> > +				  unsigned int *nummasks)
> > +{
> > +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> > +		return group_mask_cpus_evenly(numgrps,
> > +				housekeeping_cpumask(HK_TYPE_IO_QUEUE),
> > +				nummasks);
> > +	}
> > +
> > +	return group_possible_cpus_evenly(numgrps, nummasks);
> > +}
> 
> The group_cpus_evenly() isn't just used by block I/O. So you can't make it
> check only HK_TYPE_IO_QUEUE here. I will suggest to make it a bit more
> general and add helper function to specify the isolated cpumask the caller
> want to skip.

Okay, in this case I'd make group_mask_cpus_evenly a public interface
and drop the houskeeping bits in group_cpus_evenly.
