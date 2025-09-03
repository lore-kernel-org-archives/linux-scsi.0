Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE3F2FCBE5
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756902997; cv=none; b=jG0bX13WmbnZP8G0TjwV1Bgm9iG6pJXsoopY2NAMOkhsLhlAVS6ghHck16mGPuUc+rf+GdJ0bYtMPaWMBKhWfM30+z/XT+gsQ2NFLkrBID3m/9Xo5p8kMnJsZAOt7SumZNHsZ36u5e7PkbtIQ6i/tBQzFLC2CyOYymNCryC+640=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756902997; c=relaxed/simple;
	bh=l/WUmSKmcloVy0aJQRPVTdT7iDD8Xpxi1iTBHrSsDs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UbHZIVB01mSF0Yxs1d2caJz42zrnXhi/KNfFaYcU8lxkeKumsWZSRczjlYUgtZ4lNxAODQcYfdZ8LGCeJKhoJo2yGTGc0EX5zA4FFNjMM25+qSn+h73j9t9nIySVHTPSHOcYPgr+FJe3Bqajwwj3BzP0l1geaQgFeCB8JkDDn/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kVjoFdCg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JC7gL9++; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kVjoFdCg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JC7gL9++; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kVjoFdCg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JC7gL9++";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kVjoFdCg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JC7gL9++"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53B3A1F453;
	Wed,  3 Sep 2025 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756902994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4dkn1xOtjZMvux09Ypde4SPog5LI5mjRt8sFdLaY4U=;
	b=kVjoFdCgu/5/fm2+jELu+JLMX4XJc08ulrCIWfDshl3SRtjuY50CbL41pdnlV1OKFRuenV
	FPAoq4yhQZqcXvNj3heuoiNr6bzpfxXstXbAkQ7u9kfZU81EfA4D+VFODrDuySMAohMReg
	zzO9RSlJ8LNx3dXJLq2V+Q8WFDVle98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756902994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4dkn1xOtjZMvux09Ypde4SPog5LI5mjRt8sFdLaY4U=;
	b=JC7gL9++1ZpB9YCxnC/6M9nz3W8JxHmybvcmSdFTfEWWWDkcRfZCWClUCvdzzxdxrLUTIf
	yBSx//eaP2+gDMAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kVjoFdCg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JC7gL9++
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756902994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4dkn1xOtjZMvux09Ypde4SPog5LI5mjRt8sFdLaY4U=;
	b=kVjoFdCgu/5/fm2+jELu+JLMX4XJc08ulrCIWfDshl3SRtjuY50CbL41pdnlV1OKFRuenV
	FPAoq4yhQZqcXvNj3heuoiNr6bzpfxXstXbAkQ7u9kfZU81EfA4D+VFODrDuySMAohMReg
	zzO9RSlJ8LNx3dXJLq2V+Q8WFDVle98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756902994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4dkn1xOtjZMvux09Ypde4SPog5LI5mjRt8sFdLaY4U=;
	b=JC7gL9++1ZpB9YCxnC/6M9nz3W8JxHmybvcmSdFTfEWWWDkcRfZCWClUCvdzzxdxrLUTIf
	yBSx//eaP2+gDMAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4149513A31;
	Wed,  3 Sep 2025 12:36:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XMvsD1I2uGj2MAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 03 Sep 2025 12:36:34 +0000
Date: Wed, 3 Sep 2025 14:36:33 +0200
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
Subject: Re: [PATCH v7 01/10] lib/group_cpus: Add group_masks_cpus_evenly()
Message-ID: <5397286b-bb1f-493b-9d7d-b4168a67efe6@flourine.local>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-1-557aa7eacce4@kernel.org>
 <db0cbbe2-792c-4263-8be9-14b76eb0f7e6@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db0cbbe2-792c-4263-8be9-14b76eb0f7e6@suse.de>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL71uuc3g3e76oxfn4mu5aogan)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 53B3A1F453
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On Thu, Jul 03, 2025 at 08:18:50AM +0200, Hannes Reinecke wrote:
> > +/**
> > + * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
> > + * @numgrps: number of groups
> > + * @cpu_mask: CPU to consider for the grouping
> > + * @nummasks: number of initialized cpusmasks
> > + *
> > + * Return: cpumask array if successful, NULL otherwise. And each element
> > + * includes CPUs assigned to this group.
> > + *
> > + * Try to put close CPUs from viewpoint of CPU and NUMA locality into
> > + * same group. Allocate present CPUs on these groups evenly.
> > + */
> 
> Description could be improved. Point is that you do not do any
> calculation here, you just call __group_cpus_evenly() with
> a different mask.

I updated the documentation, it matches with group_cpus_evenly but with
the constrain mask.
