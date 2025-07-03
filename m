Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671B293C45
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524196; cv=none; b=cSf2WzxZVGsWjVWgJrJd5EyPJ3HpBz2eRtKqleO1f5GamztYUmcJax5wISvOBhj3t4bge9c5mNHrBVbAPJcUt58ZtS07pFhQhPqD5VHYNP6V5XEDvYG4nCdpSaPqlFErIFgyhRsj1vUIdXUnhad6KiqOtnpyVE42ba9aQdSsjYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524196; c=relaxed/simple;
	bh=ECZsDDl1TKGG4YWaeZysqUnhyotAlHo4xWKR7RY0iE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J5isVS4CIXihAsg24hg36y73t/eHdxbSvtML92GzrRJ1qs2vqaotvpiyYdu8thYnGIlJO1Twrc+5iXbw2vBEccyQ4A1G3c1Ro7PpmxqeP1uFCxKDTbXtno3EpZgtb3Y9OlJHU4AjctAmiYEoh51z3sMFem4bpxGmQ/VsoR57hy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hdanQT/B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8f/nrZVz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hdanQT/B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8f/nrZVz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hdanQT/B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8f/nrZVz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hdanQT/B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8f/nrZVz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1F9E81F38D;
	Thu,  3 Jul 2025 06:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751524193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+2Q0mOGHh5KVfoOEylVWcUYpGF+d4DxD/1fzSg/ERY=;
	b=hdanQT/B/YrdbDJ252ztmualMT3ROdiRXiGELHqvpl+5vq5uftybIJQspM/Py2eo2a96QK
	JZVfJj3nDJHrS2qgm7liNhn8PueJ+E8aW9qqQFGPV9qi8nhswmLjlKsAhtJOFIi3pQlwal
	Jek0zACoiBu2CJHS5H2V0fjTR7qmOlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751524193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+2Q0mOGHh5KVfoOEylVWcUYpGF+d4DxD/1fzSg/ERY=;
	b=8f/nrZVz0G186gxGJsowBq8+kGM1HB97fcEz8pMxnKaifONmSVJQ906bG4VKNGRe4ZKUm0
	XiOAsK8ygvDXRZDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hdanQT/B";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="8f/nrZVz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751524193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+2Q0mOGHh5KVfoOEylVWcUYpGF+d4DxD/1fzSg/ERY=;
	b=hdanQT/B/YrdbDJ252ztmualMT3ROdiRXiGELHqvpl+5vq5uftybIJQspM/Py2eo2a96QK
	JZVfJj3nDJHrS2qgm7liNhn8PueJ+E8aW9qqQFGPV9qi8nhswmLjlKsAhtJOFIi3pQlwal
	Jek0zACoiBu2CJHS5H2V0fjTR7qmOlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751524193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+2Q0mOGHh5KVfoOEylVWcUYpGF+d4DxD/1fzSg/ERY=;
	b=8f/nrZVz0G186gxGJsowBq8+kGM1HB97fcEz8pMxnKaifONmSVJQ906bG4VKNGRe4ZKUm0
	XiOAsK8ygvDXRZDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 540BD1368E;
	Thu,  3 Jul 2025 06:29:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nNLzEmAjZmgsSQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:29:52 +0000
Message-ID: <1299faff-d6f0-43f7-9c94-89d23dff09ff@suse.de>
Date: Thu, 3 Jul 2025 08:29:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/10] nvme-pci: use block layer helpers to constrain
 queue affinity
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, storagedev@microchip.com,
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
 <20250702-isolcpus-io-queues-v7-4-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-4-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 1F9E81F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On 7/2/25 18:33, Daniel Wagner wrote:
> Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
> constraints provided by the block layer. This allows the NVMe driver
> to avoid assigning interrupts to CPUs that the block layer has excluded
> (e.g., isolated CPUs).
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   drivers/nvme/host/pci.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index a509dc1f1d1400bc0de6d2f9424c126d9b966751..5293d5a3e5ee19427bec834741258be134bdc2c9 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -2589,6 +2589,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
>   		.pre_vectors	= 1,
>   		.calc_sets	= nvme_calc_irq_sets,
>   		.priv		= dev,
> +		.mask		= blk_mq_possible_queue_affinity(),
>   	};
>   	unsigned int irq_queues, poll_queues;
>   	unsigned int flags = PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY;
> 

That was easy :-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
