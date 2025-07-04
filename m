Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863172D8788
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jul 2025 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751632222; cv=none; b=DYGn0tC3VpICLZxg9pYqdXDnZiw1+rhgArpj77yK4AXhbUn7Tw9w7/CO4mkfACEIcV94zhBBJZvCe0kb5vF/N3uKNfeEPLNtL72TCiY3MI4qyS0iw9GLlHfl+42x27QOH5eqDAvxiqE1sMotDbsIToKnpL8c1+uHTE4QDx0/lcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751632222; c=relaxed/simple;
	bh=EhqUgOJCJlnSDCmE5YbN+SmR7GZFhyPzjsXP0FF1GYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVhQ3X0t/VES1ApOCgKMtsYrPrKgLVH0mKrAvDOwstabiJPUaISQlDFEH+sO0qmAQDIJZwWUSJ6t60dDa2a0flPMre/90uTXvgdmPPoWggwGW4697Xx/7JKD8HZC2JG1XdDtiQBO7RYR/L6+Yhcmajug3Ab3btIuMqA+gy4lEf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1PNeuq6X; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qw5LBiTr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iUH4+5Vu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZffzaIRI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1PNeuq6X";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qw5LBiTr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iUH4+5Vu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZffzaIRI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 68609211B1;
	Fri,  4 Jul 2025 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751632218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q+FqtZMjtP4HpZ/jeTQTPK73EGvFDqPilJ5M/AUaOsg=;
	b=1PNeuq6XRG9MLSKh16/8j87kZJMB7EIl2HpEWVs2u8pn4ERdxbvgelzT1f5k+NPAxh1NA3
	DUhuhO33rqPurfYDV6Xd6LvxR7Ete9BU17kVZxsSQq6GNQ+XFFClvqd4nRp/A5nzVx5KTs
	zK1JxYRs9oPAk10lH1ZjkkCMs6fkV6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751632218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q+FqtZMjtP4HpZ/jeTQTPK73EGvFDqPilJ5M/AUaOsg=;
	b=Qw5LBiTryjPMOx7bvmSs0x5fIFEAlrw4PFmoc6rh/CevNJnTZQovkQFMhOVgGAycZXvDAG
	yQYm71qi29pWD2Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iUH4+5Vu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZffzaIRI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751632217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q+FqtZMjtP4HpZ/jeTQTPK73EGvFDqPilJ5M/AUaOsg=;
	b=iUH4+5VultHZW/BBXGA+BmaiSW4ERO0GGGCIXtyomlhI4kUC2UuvbntREmfxxaGRS6qiYD
	hi1IhXlsoGLh8tcEins5JEoHmBxUFBPxJeUY3VkbOuhDyn9Cwj64A1IV9uB8rq1TnEVLHk
	en7cLJ94w0kqDZkxYepKPUB6rC5hcZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751632217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q+FqtZMjtP4HpZ/jeTQTPK73EGvFDqPilJ5M/AUaOsg=;
	b=ZffzaIRI91Wrez4gmihemHyE278M17FvJei2kFPfkywnXuEZHbdJw/QsufVHUpEN//WEQT
	xO9k6fQKdvq5TrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41F8913A71;
	Fri,  4 Jul 2025 12:30:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ViIbEFnJZ2j/VAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 04 Jul 2025 12:30:17 +0000
Date: Fri, 4 Jul 2025 14:30:16 +0200
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
Subject: Re: [PATCH v7 05/10] scsi: Use block layer helpers to constrain
 queue affinity
Message-ID: <fdbc2ddc-830b-4727-88ae-5347fea8fca8@flourine.local>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-5-557aa7eacce4@kernel.org>
 <d95de280-8cd7-4697-933a-37dc53f4c552@suse.de>
 <2e7576e4-442f-4000-817d-6253374f5818@flourine.local>
 <c06d0ef2-6bd2-4f5d-895f-0255415b2a24@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c06d0ef2-6bd2-4f5d-895f-0255415b2a24@suse.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 68609211B1
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	RCPT_COUNT_TWELVE(0.00)[26];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RL71uuc3g3e76oxfn4mu5aogan)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[flourine.local:mid,suse.de:dkim]
X-Spam-Score: -4.51

On Fri, Jul 04, 2025 at 12:28:49PM +0200, Hannes Reinecke wrote:
> It really shouldn't be an issue when the cpus are distributed 'correctly'
> :-)

If I get the drift, we start to discuss how the mapping could be
normally, so not for isolcpus. The isolcpus case is just how many hwq
are available (and affinity):

 num queues to map = min(num housekeeping CPUs, #hwq)

and then it's common code, no special housekeeping mapping code.

> We have several possibilities:
> -> #hwq > num_possible_cpus: easy, 1:1 mapping, no problem

I agree, no problem here.

> -> num_online_cpu < #hwq < num_possible_cpus: Not as easy, but if we
>    ensure that each online cpu is mapped to a different hwq we don't
>    have a performance impact.

This should also be fairly straightforward too. First assign each online
CPU a hwq and distribute the rest of the hwq amount the rest of the
possible offline CPUs.

> -> #hwq < num_online_cpu: If we ensure that a) the number of online cpus
>    per hwq is (roughly) identical we won't have a performance impact.
>    As a bonus we should strive to have the number of offline cpus
>    distributed equally on each hwq.

__group_cpus_evenly is handling this pretty well.

> Of course, that doesn't take into accound NUMA locality; with NUMA locality
> you would need to ensure to have at least one CPU per NUMA node
> mapped to each hwq. Which actually would impose a lower limit on the
> number (and granularity!) of hwqs (namely the number of NUMA nodes), but
> that's fair, I guess.

Again __group_cpus_evenly is taking NUMA into account as I understand it.

> But this really can be delegated to later patches; initially we really
> should identify which drivers might have issues with CPU hotplug,
> and at the very least issue a warning for these drivers.

There are different ways I suppose. My approach is not to change the
drivers too much because I don't have access to all the hardware for
testing. Instead extend the core code so that the different cases are
covered.
