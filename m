Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508CC1DF97D
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 08:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747298212; cv=none; b=iQ1cI8SixoJeFU92jYwLCSMef9ufmW3xLYDY3SkNQ4jz7I6cjjqVcuCiaX5+01hPFskFoR9g8s+OO0w54crg+YR8UJteGgxzkXy+W1g/ESvOcbPkIgmHwlk/shuLfLexKb1Wupb60xDACdqh6et57rXaPwjTAPQ5dKcUOUUacmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747298212; c=relaxed/simple;
	bh=+c9NGYmiEkqdCnm5003uXEFhtfdeTB7uo/kvDiYpTHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiIrBthklsRSbGSaQbQC9zH4RlddMYjA6JTx1h7Dub+WebP3rHwa1prUsQFbZc/7/rZlgmdJbjioYIMGNBRNs+BZZ9cw+eNkJXMOjSoOrJulX39bF98uaf/L0hlFBsVZYEbY+qJo8kuD+BAtVCXHMj5rSFHbLh5I9brsG4uWiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aqC1eiDN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J/xY8Bkn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aqC1eiDN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=J/xY8Bkn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aqC1eiDN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J/xY8Bkn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aqC1eiDN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="J/xY8Bkn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 709EE211B5;
	Thu, 15 May 2025 08:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747298209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kvzf/cT7kFTGGu4qe+BKuApOCbvOUKO36BdytQuX9bg=;
	b=aqC1eiDNM7x3s6EozlAR5OWCQviVaAtCIVVgIiVqcB5WImfCQcQSz6EKUql/QHKN5ac2ld
	bqwy15BWMFuXP6q/FvItc1ldfOdTVkAafcpVQ2xzORslHnbLpp4moQX3Z7VPcHwnkoO917
	WandeC9N+tQ+ikWVdzmqhgEDCjiAF7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747298209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kvzf/cT7kFTGGu4qe+BKuApOCbvOUKO36BdytQuX9bg=;
	b=J/xY8BknbdxEFblaXLWVlGBNQFfjNKxZQlySvLAf7Ew69O48nQxw0BiCJEwyMZTGwEUpIE
	S+1f4MolWlZmm2Cg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aqC1eiDN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="J/xY8Bkn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747298209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kvzf/cT7kFTGGu4qe+BKuApOCbvOUKO36BdytQuX9bg=;
	b=aqC1eiDNM7x3s6EozlAR5OWCQviVaAtCIVVgIiVqcB5WImfCQcQSz6EKUql/QHKN5ac2ld
	bqwy15BWMFuXP6q/FvItc1ldfOdTVkAafcpVQ2xzORslHnbLpp4moQX3Z7VPcHwnkoO917
	WandeC9N+tQ+ikWVdzmqhgEDCjiAF7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747298209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kvzf/cT7kFTGGu4qe+BKuApOCbvOUKO36BdytQuX9bg=;
	b=J/xY8BknbdxEFblaXLWVlGBNQFfjNKxZQlySvLAf7Ew69O48nQxw0BiCJEwyMZTGwEUpIE
	S+1f4MolWlZmm2Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A0B6137E8;
	Thu, 15 May 2025 08:36:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uh33EKGnJWgzPAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 15 May 2025 08:36:49 +0000
Date: Thu, 15 May 2025 10:36:40 +0200
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
Subject: Re: [PATCH v6 8/9] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <8c162a99-05f5-408c-b513-4005690d56a2@flourine.local>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-8-9a53a870ca1f@kernel.org>
 <aB1qqNDEnHMlpMH_@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB1qqNDEnHMlpMH_@fedora>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 709EE211B5
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action

On Fri, May 09, 2025 at 10:38:32AM +0800, Ming Lei wrote:
> > +static bool blk_mq_map_hk_queues(struct blk_mq_queue_map *qmap)
> > +{
> > +	struct cpumask *hk_masks;
> > +	cpumask_var_t isol_mask;
> > +	unsigned int queue, cpu, nr_masks;
> > +
> > +	if (!housekeeping_enabled(HK_TYPE_IO_QUEUE))
> > +		return false;
> 
> It could be more readable to move the above check to the caller.

I wanted to avoid checking if housekeeping is enabled twice in a row.
I'll post the next version with your suggestion and see if this approach
is better.
