Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF052E4252
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 07:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757316370; cv=none; b=G3ygl0mPpG0UaOKBdcsKGa91j4WMlVHzuTNvWlUMywCosKfJBd5epHXonrWC74H7HFV+lPZmrv8qsfr0lw7E5myGHUJKLsN7+zl5IFFSg9UP6V8FGMThSUHy/qdqbU0ZTex4qCCcgxHW78Sc7qEgSdUGxYGOA1nUtgtfUEDaE+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757316370; c=relaxed/simple;
	bh=cr8Y+j1Bw7kjEWcO3gXESae1Joncig4F/jhAK10OxY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nq+LQHRIDMxchO1pF2zZNIu23K1R4MMbp6le6QqrPIxCWS0atWwarnTK9g8Jv5E2MyStcEhYhln7C8o267MWfwpuRbBVAdQ5cYfnIoBUPSxwAbv8nAn+KZPkmGGkF80P/B19LfK8EQmaoT1dkvbvGFU13JPkYnXu/mx1K0ng4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DABA1266D1;
	Mon,  8 Sep 2025 07:26:05 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C891B13869;
	Mon,  8 Sep 2025 07:26:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MUfxMA2FvmjiQQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 08 Sep 2025 07:26:05 +0000
Date: Mon, 8 Sep 2025 09:26:05 +0200
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
Subject: Re: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <d11a0c60-1b75-49ec-a2f8-7df402c4adf2@flourine.local>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
 <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
 <ff66801c-f261-411d-bbbf-b386e013d096@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff66801c-f261-411d-bbbf-b386e013d096@suse.de>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: DABA1266D1
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00

On Mon, Sep 08, 2025 at 08:13:31AM +0200, Hannes Reinecke wrote:
> >   const struct cpumask *blk_mq_online_queue_affinity(void)
> >   {
> > +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
> > +		cpumask_and(&blk_hk_online_mask, cpu_online_mask,
> > +			    housekeeping_cpumask(HK_TYPE_IO_QUEUE));
> > +		return &blk_hk_online_mask;
> 
> Can you explain the use of 'blk_hk_online_mask'?
> Why is a static variable?

The blk_mq_*_queue_affinity helpers return a const struct cpumask *, the
caller doesn't need to free the return value. Because cpumask_and needs
store its result somewhere, I opted for the global static variable.

> To my untrained eye it's being recalculated every time one calls
> this function. And only the first invocation run on an empty mask,
> all subsequent ones see a populated mask.

The cpu_online_mask might change over time, it's not a static bitmap.
Thus it's necessary to update the blk_hk_online_mask. Doing some sort of
caching is certainly possible. Given that we have plenty of cpumask
logic operation in the cpu_group_evenly code path later, I am not so
sure this really makes a huge difference.
