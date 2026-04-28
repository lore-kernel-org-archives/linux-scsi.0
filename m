Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957FE3F788E
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 13:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777381694; cv=none; b=eru34fzCW2lG9F7sv0A7op9jHz8bBqhSt5H5zwxEOw2QJPyEQCZuhH+TkQVjvxolNrwkQRc4UAsJCjeLMwziypAS7V1gPjGbu7wfg5L+debe+ubb+35aXKx0PgUlRonPCSxXRvVlmn9Lh7vsyL/eWgxvdHu1MdjE3vKinRufYNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777381694; c=relaxed/simple;
	bh=v54lbtqgbX4GavD38ynkXgqip7rcSqTMvrGrfyGrDm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eavsd5VWT3rKJpm2qASnvBi5RdxQeTEuxWXIvHiavrRDCkb4ve/jQmMNCL0tStZ/mfQ63c3zOMAKw/xpQh1gqjmWkxJjtatZNLVBqhKID2XPNoZVXpGfus1wWQZAeQEqTWF5lHraDuBYCvyGODeWSKu/FIep3LbbGJx2S+rvAgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Jn4mLfqL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6EraTIXp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q+IWzqzK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MbASWYe+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Jn4mLfqL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6EraTIXp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q+IWzqzK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MbASWYe+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DAD0B5BD2E;
	Tue, 28 Apr 2026 13:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777381692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qfHwNudJmxczCvGUPLLuGA5ZXHhapkdWdCgZlnCSfvo=;
	b=Jn4mLfqL1Yne+LRTncOG/xG6TZ10rCWgJS9tV54YLPXVZY20eEa4GSsxrKSdy5HqeX8S8q
	yEfPfKKno7m/KehSc1H3MYrfGj19D5YkQfPrM4leWSrk7HbB37bTXpy6Z7Mul5wtKy1sSr
	uMqhwgWtCnc56h8wfXQ34v9rL2LWl6w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777381692;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qfHwNudJmxczCvGUPLLuGA5ZXHhapkdWdCgZlnCSfvo=;
	b=6EraTIXpIKWlTiAwZb5Al0nEVUhM3n1R+WKiFZxL413mc7tCusd2r5uB1SnBve4HEmyIZ3
	Kw5pp+YHhgYY5vCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q+IWzqzK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MbASWYe+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777381691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qfHwNudJmxczCvGUPLLuGA5ZXHhapkdWdCgZlnCSfvo=;
	b=q+IWzqzKmn2cj4UTrE1TJfZ2507WKmlfZ5SjuemF29Ajc8QvC22TI53JNy9ARHYmtIcnrz
	shC80cTqdwJdCAzB3Td06ddHCljRiQC9BVCFAoltPDpFIW2Kc30xBxTKdcf5p6kSIfbVnV
	HcS8m4UPFU4B4zjz7+rZvbx9BDyd0ts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777381691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qfHwNudJmxczCvGUPLLuGA5ZXHhapkdWdCgZlnCSfvo=;
	b=MbASWYe+cBY5TqwnP9VcBhX+VcZXXGxcLNZXH81VjmLrDZSkCqnLx5xQo2RJoHvKAjLm4V
	BzCM97vrSFuE62Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B55F6593B0;
	Tue, 28 Apr 2026 13:08:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dPbrKzux8GmoVgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 28 Apr 2026 13:08:11 +0000
Date: Tue, 28 Apr 2026 15:08:10 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Florian Bezdeka <florian.bezdeka@siemens.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, axboe@kernel.dk, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, liyihang9@h-partners.com, 
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, 
	shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	maz@kernel.org, ruanjinjie@huawei.com, bigeasy@linutronix.de, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, longman@redhat.com, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, ming.lei@redhat.com, 
	tom.leiming@gmail.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, nick.lange@gmail.com, marco.crivellari@suse.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v12 00/13] blk: honor isolcpus configuration
Message-ID: <2d61b1f7-fc06-4fe1-8a6f-cc3a2f114ae1@flourine.local>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <e350389a5a635660267a7a13f06529da102a95d8.camel@siemens.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e350389a5a635660267a7a13f06529da102a95d8.camel@siemens.com>
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[atomlin.com,kernel.dk,kernel.org,lst.de,grimberg.me,redhat.com,microsemi.com,hansenpartnership.com,oracle.com,h-partners.com,broadcom.com,cloud.ionos.com,infradead.org,linaro.org,linux-foundation.org,huawei.com,linutronix.de,gmail.com,suse.de,nvidia.com,abita.co,ashe.io,suse.com,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[53];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,flourine.local:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DAD0B5BD2E

On Mon, Apr 27, 2026 at 12:55:20PM +0200, Florian Bezdeka wrote:
> This topic reminds me of a discussion started by Tobias [1] some time
> ago about IRQ spreading of network drivers. The problem was (and still
> is) that network drivers ignore any CPU isolation when spreading out
> device IRQs.
> 
> In general we have two different CPU isolation mechanisms:
>   - The static one, via isolcpus= cmdline parameter
>   - The dynamic one, via cgroups(v2) cpuset controller
> 
> This series is only taking the static "world" into account, right? Are
> there any plans to honor the CPU isolations configured the dynamic
> way?

Dynamic configuration would require every driver to fully support
reconfiguration during runtime. Only a handful of drivers, such as
nvme-pci, are currently able to handle this.

The first task, teaching a wide range of drivers to honor CPU isolation
at boot time, is already going to be a significant amount of work.

> It has been a while since the last investigations on my end. Last time I
> went through the code, the IRQ core was completely decoupled from the
> dynamic configuration via cgroups. Are there any plans to fix that gap?

Which use case are you actually aiming to support? While dynamic
reconfiguration would be ideal, the amount of work to get there is
significant. I won't be signing up for it.
