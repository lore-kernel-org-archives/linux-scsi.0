Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48201238D27
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 12:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380831; cv=none; b=lXKZb5UwYxQLRkdTlLUryMXUVMdMgozuwOMlq023X5RYLNiG/rM5i3z8pbBy3pjrt4dWpBwZkD1bOp+ewmEsfmKtV+i8XZ5+JWlQ1X14OAZWoPUXZ8iQZWLUY/jexUbRer4Zl0ni6QZfDt6rRHKNeDK5jke7zmheEe1fUKoA8MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380831; c=relaxed/simple;
	bh=Rh7Kq8H/eSQ24EcQvilWdMKqZ9p4Ahck+Y2C05CRL2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIsxDuczvaGuL4PJN69ZOPQPp0oNdlXi8GzxO4X7X1zVnMnnyQdl1TLFjD7pwHOia3BYQuCGAvEYr83Z5jE/cXdnxLeTVVHkPSTewRsY3HYGvNHaw4nWpcGZf6C5N5MoXZaG/FReG9DPHmolfiBeMEm7bpA9hMPOry1w1Fj5SHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cRSf4YjR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dsHBhXA+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cRSf4YjR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dsHBhXA+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cRSf4YjR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dsHBhXA+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cRSf4YjR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dsHBhXA+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 181036A870;
	Tue, 28 Apr 2026 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777380824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNmfGQaXydSNVp/wD+ZDk5eV1VFql8i87Ef0v+yEIJc=;
	b=cRSf4YjRjRT9SmsdPEk3zl2zvIS93JUJW4kvlYYer+UL/ehPBz68JiN6aeLXLDsErOFcdE
	hic8XTGYfwNANj8VwNlJIGjcn8tjAyGNtu+HqTL9J0y+E+0aNOhExWb2m/uO/LlvXk25L4
	+qoqTG+U03m0e1IRsSAyQ5vhDGUr2r0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777380824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNmfGQaXydSNVp/wD+ZDk5eV1VFql8i87Ef0v+yEIJc=;
	b=dsHBhXA+c+Nr7Gwv+tgrjETsPTkf/4Pd/0f1FJj2eH+Y+kBsyjTaUJVvkyKkpDyioEpDoq
	z0siPCkKk+rFHyAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cRSf4YjR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dsHBhXA+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777380824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNmfGQaXydSNVp/wD+ZDk5eV1VFql8i87Ef0v+yEIJc=;
	b=cRSf4YjRjRT9SmsdPEk3zl2zvIS93JUJW4kvlYYer+UL/ehPBz68JiN6aeLXLDsErOFcdE
	hic8XTGYfwNANj8VwNlJIGjcn8tjAyGNtu+HqTL9J0y+E+0aNOhExWb2m/uO/LlvXk25L4
	+qoqTG+U03m0e1IRsSAyQ5vhDGUr2r0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777380824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNmfGQaXydSNVp/wD+ZDk5eV1VFql8i87Ef0v+yEIJc=;
	b=dsHBhXA+c+Nr7Gwv+tgrjETsPTkf/4Pd/0f1FJj2eH+Y+kBsyjTaUJVvkyKkpDyioEpDoq
	z0siPCkKk+rFHyAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3F2C593B0;
	Tue, 28 Apr 2026 12:53:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LRuNO9et8Gl9SAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 28 Apr 2026 12:53:43 +0000
Date: Tue, 28 Apr 2026 14:53:43 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, liyihang9@h-partners.com, 
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, 
	shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	maz@kernel.org, ruanjinjie@huawei.com, yphbchou0911@gmail.com, wagi@kernel.org, 
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com, hare@suse.de, 
	kch@nvidia.com, ming.lei@redhat.com, tom.leiming@gmail.com, steve@abita.co, 
	sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, 
	nick.lange@gmail.com, marco.crivellari@suse.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v12 05/13] blk-mq: add
 blk_mq_{online|possible}_queue_affinity
Message-ID: <c4927a2b-c18d-42ce-8a60-d6d388155671@flourine.local>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <20260422185215.100929-6-atomlin@atomlin.com>
 <20260427153416.MeVS8yxF@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427153416.MeVS8yxF@linutronix.de>
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[atomlin.com,kernel.dk,kernel.org,lst.de,grimberg.me,redhat.com,microsemi.com,hansenpartnership.com,oracle.com,h-partners.com,broadcom.com,cloud.ionos.com,infradead.org,linaro.org,linux-foundation.org,huawei.com,gmail.com,suse.de,nvidia.com,abita.co,ashe.io,suse.com,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_GT_50(0.00)[52];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 181036A870

On Mon, Apr 27, 2026 at 05:34:16PM +0200, Sebastian Andrzej Siewior wrote:
> Which driver uses cpu_possible_mask? This mask is assigned at boot time
> once the kernel figured how many CPUs are possible based on ACPI or
> whatever the system uses. This mask does not change.
> 
> I only see drivers/scsi/lpfc/lpfc_init.c using it. Looking at
> cpu_possible_mask might not be the right thing. It is usually the same
> thing as "online" except on system where ACPI thinks that something
> could be added via hotplug _or_ if the admin shuts down a CPU via
> cpuhotplug _or_ boots with less (there a command line option for
> that).

These HBAs are used on PowerPC which supports lpar (CPUs can be added
during runtime) I am told it's properly the only driver which is caring
about this type configuration, thus a bit of an odd ball.

> In case cpu_possible_mask != cpu_online_mask the intention is to
> allocate memory and setup irqs for the offline CPUs?

I can't answer this. The lpfc driver has several strategies implemented
how it spreads its resources.
