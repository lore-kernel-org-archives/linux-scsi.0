Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A722098;
	Tue,  7 Jan 2025 08:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736238030; cv=none; b=mZBcIGj1XUJ5Gm+oQVz9A0FjyROH5QLk7K8X85odrOz1txBITtaS5Saojk0f9EFiEotqA/9djbzzot0OGQQh9LyTBHF3eTq99g/zc6jpFCcq3lmIzDd7sLVI2MMwI08wd4Ow4zaVJuvKNqHRIr/C92GQvaNEJ5TeTocQXeICTa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736238030; c=relaxed/simple;
	bh=Guu4i61qBiDOmrZXg+6ykyNkW0L3rddQ3vVaHfgaL3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XysquddSiKsAYmKnRdTKg7MiOYB8XCJLZ42CNYehFxyVK5WLCR/0wViM7B9UswLNW4a8fnHu3//r91fM/yCLRHfYp+xX0jzB/U1y36SvvVs8dLX/eFbDnW6qpHF5fY3CycNZg/ul9NlP0e++fqEHdq5LXT5xs7P9A811yOP3SRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v/h6Miy8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Dlrk95B4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v/h6Miy8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Dlrk95B4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v/h6Miy8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Dlrk95B4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v/h6Miy8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Dlrk95B4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA1D41F385;
	Tue,  7 Jan 2025 08:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736238026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+NpXElqnQdxnRsTa1vwg3pxBiXOLmHQOU8loonEy8w=;
	b=v/h6Miy8Sv3zX6ZVNKWB1U1IevFwrVcQszLg2QVz/Q1iq5Xl0lBql+HInGwHkCoHFGmWqH
	97TlRA6VFDWxkaeibEi7vq5yaY2h8cJijZ7PGSHhjzmtitf9QaAsTdbbc8tJM3nZfwbcVU
	iu0J3yv7RvjOqIHqapVeMHqCZV7s4Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736238026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+NpXElqnQdxnRsTa1vwg3pxBiXOLmHQOU8loonEy8w=;
	b=Dlrk95B44rgWvjubse/VtdiLgKw7ly1KXmaZfY/UeSpPlBAP8I9Ry2DbqKZ8HgWBcCbrit
	i7wZV8FRCAm8seCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="v/h6Miy8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Dlrk95B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736238026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+NpXElqnQdxnRsTa1vwg3pxBiXOLmHQOU8loonEy8w=;
	b=v/h6Miy8Sv3zX6ZVNKWB1U1IevFwrVcQszLg2QVz/Q1iq5Xl0lBql+HInGwHkCoHFGmWqH
	97TlRA6VFDWxkaeibEi7vq5yaY2h8cJijZ7PGSHhjzmtitf9QaAsTdbbc8tJM3nZfwbcVU
	iu0J3yv7RvjOqIHqapVeMHqCZV7s4Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736238026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+NpXElqnQdxnRsTa1vwg3pxBiXOLmHQOU8loonEy8w=;
	b=Dlrk95B44rgWvjubse/VtdiLgKw7ly1KXmaZfY/UeSpPlBAP8I9Ry2DbqKZ8HgWBcCbrit
	i7wZV8FRCAm8seCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96BBF13763;
	Tue,  7 Jan 2025 08:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LT3JJMrjfGcUOQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 07 Jan 2025 08:20:26 +0000
Date: Tue, 7 Jan 2025 09:20:26 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Don Brace <don.brace@microchip.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 1/9] lib/group_cpus: let group_cpu_evenly return
 number of groups
Message-ID: <1d7b96ca-a015-4730-9035-abb69cd6cda4@flourine.local>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-1-5d355fbb1e14@kernel.org>
 <1a2fe8aa-d3e1-4e36-8cd5-27141c1d7178@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a2fe8aa-d3e1-4e36-8cd5-27141c1d7178@suse.de>
X-Rspamd-Queue-Id: AA1D41F385
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[39];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,oracle.com,marvell.com,microchip.com,redhat.com,linux.alibaba.com,linux-foundation.org,linutronix.de,suse.com,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLy1uc785cwzda5mnrw36e8hj5)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, Jan 07, 2025 at 08:51:57AM +0100, Hannes Reinecke wrote:
> >   void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
> >   {
> >   	const struct cpumask *masks;
> > -	unsigned int queue, cpu;
> > +	unsigned int queue, cpu, nr_masks;
> > -	masks = group_cpus_evenly(qmap->nr_queues);
> > +	nr_masks = qmap->nr_queues;
> > +	masks = group_cpus_evenly(&nr_masks);
> 
> Hmph. I am a big fan of separating input and output paramenters;
> most ABI definitions will be doing that anyway.
> Makes it also really hard to track whether the output parameters
> had been set at all. Care to split it up?

What API do you have in mind?
