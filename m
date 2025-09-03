Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD072D1907
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756903338; cv=none; b=gh6lZLzgFlK6IVy9Q1CiKkPoqTvavXDB2CB1G9zOKWG2AwQfRQ8PZNMtqTGamkvU+N0c2hwU4K44foDcimV39bK5Jc6RyWsoZGIpEiHMh4CILzI0se55J2qbSUlDiJbWEAFNaPWz259W9ce72qzWlZziXPLB8IJ3rMVaz2b9HYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756903338; c=relaxed/simple;
	bh=ZwD2K02kgnEXLqi6lq5OPz8a+xK0+swNo3Gv/I81cI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdzxQH/+6jg1I87CU8nv3fvSN6aq4ARU+ss06ev5X+tf9trCZ6UVt3NcKRUywCMR4eZUKWWOvqqDoPEZfaxmA9anju6N1xL9WWRrzWwiK5UIi4fKfxjBuAjguSrcOajpuIMfLmeEX/JYE5qJOy5Ad/1kjx3c4/a/pCCjKIUCKcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0XinekcA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rOLV+Quj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0XinekcA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rOLV+Quj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0XinekcA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rOLV+Quj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0XinekcA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rOLV+Quj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53BA31F38A;
	Wed,  3 Sep 2025 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756903335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIgaM36KJeIX4j/P65jhT8FLAdsH3bur2uN5IZqRt1U=;
	b=0XinekcA5PGjWvzu5dKGsXcQT7L4bpSixC77gbR5vEAZRsXvd+prJA7H97aXMyub5lPq1S
	KO139GLFKGqJxlCXysAdE4E7b1HzcFD7iqZVtW2AwhraSGESQKXMe8x5HEwZjaQMZiUIn5
	SqXoizG3/7dZ1DNA5ym/bhw1xl0NlIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756903335;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIgaM36KJeIX4j/P65jhT8FLAdsH3bur2uN5IZqRt1U=;
	b=rOLV+QujrozXuF7co4MMb3R3fAcYJ1LJg4LnT+5RliXi3TdvA9TjNXaSb2cU6wdFBgfD7J
	zGLD5c6md+MZrJBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0XinekcA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rOLV+Quj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756903335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIgaM36KJeIX4j/P65jhT8FLAdsH3bur2uN5IZqRt1U=;
	b=0XinekcA5PGjWvzu5dKGsXcQT7L4bpSixC77gbR5vEAZRsXvd+prJA7H97aXMyub5lPq1S
	KO139GLFKGqJxlCXysAdE4E7b1HzcFD7iqZVtW2AwhraSGESQKXMe8x5HEwZjaQMZiUIn5
	SqXoizG3/7dZ1DNA5ym/bhw1xl0NlIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756903335;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIgaM36KJeIX4j/P65jhT8FLAdsH3bur2uN5IZqRt1U=;
	b=rOLV+QujrozXuF7co4MMb3R3fAcYJ1LJg4LnT+5RliXi3TdvA9TjNXaSb2cU6wdFBgfD7J
	zGLD5c6md+MZrJBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42BB013A31;
	Wed,  3 Sep 2025 12:42:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fTJHEKc3uGirMgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 03 Sep 2025 12:42:15 +0000
Date: Wed, 3 Sep 2025 14:42:10 +0200
From: Daniel Wagner <dwagner@suse.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v7 01/10] lib/group_cpus: Add group_masks_cpus_evenly()
Message-ID: <f4ed094f-7370-4121-9df6-454411452751@flourine.local>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
 <2b70fbd3-d63d-4bd3-8500-e14c41fc64b9@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b70fbd3-d63d-4bd3-8500-e14c41fc64b9@oracle.com>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL71uuc3g3e76oxfn4mu5aogan)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 53BA31F38A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On Fri, Jul 11, 2025 at 09:28:12AM +0100, John Garry wrote:
> > +/**
> > + * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
> > + * @numgrps: number of groups
> 
> this comment could be a bit more useful
> 
> > + * @cpu_mask: CPU to consider for the grouping
> 
> this is a CPU mask, and not a specific CPU index, right?

Yes, I've updated the documentation to:

/**
 * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
 * @numgrps: number of cpumasks to create
 * @mask: CPUs to consider for the grouping
 * @nummasks: number of initialized cpusmasks
 *
 * Return: cpumask array if successful, NULL otherwise. Only the CPUs
 * marked in the mask will be considered for the grouping. And each
 * element includes CPUs assigned to this group. nummasks contains the
 * number of initialized masks which can be less than numgrps. cpu_mask
 *
 * Try to put close CPUs from viewpoint of CPU and NUMA locality into
 * same group, and run two-stage grouping:
 *	1) allocate present CPUs on these groups evenly first
 *	2) allocate other possible CPUs on these groups evenly
 *
 * We guarantee in the resulted grouping that all CPUs are covered, and
 * no same CPU is assigned to multiple groups
 */
struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
				       const struct cpumask *mask,
				       unsigned int *nummasks)

> > +	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, cpu_mask, nmsk,
> > +				  masks);
> 
> maybe it's personal taste, but I don't think that it's a good style to
> always pass through 'fail' labels, even if we have not failed in some
> step

I'd rather leave it as it is, because it matches the existing code in
group_cpus_evenly. And there is also alloc_node_to_cpumask which does
the same. Consistency wins IMO.
