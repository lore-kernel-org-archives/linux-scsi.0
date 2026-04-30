Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC3401A16
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 12:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777550965; cv=none; b=ooJoZbvH0lH7Y6tM9mK3uAMwlvbCpDuvM+DHCaxMU4crhbUzxJbBYYVcpt2jt3SrJHyzrzgJL84/60sMW+WjUqPbMr0vHo2N31iKtlyN+muiDToOzDmAPinu30Rcnu22Y85jL5lflzOD/kW7f438Fz5EyxserhaUpvhE6QYPGZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777550965; c=relaxed/simple;
	bh=fJoAwCoy2K1XeQNEUAVcC6yclLqZ8LS5SUtuOzKPgcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujsVzWvK+C4fi5veDt8thEBRyDKssy2aNhdFesRcuPXK0BmPc7zttEHao5gEJJJDyEaTkPV/tl/oCcJywnmtDLx01I1KgumkzGmAS5E5HIf/g6ygN81WAR1p+1eUD18aEmnLwPCMMJZzzVijXLkdgDHMb3jKQvQDKByp6edq/gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TNcm5UCp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4IM0G4gR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TNcm5UCp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4IM0G4gR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TNcm5UCp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4IM0G4gR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TNcm5UCp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4IM0G4gR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 838016A81C;
	Thu, 30 Apr 2026 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777550962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Aa3+xJkIiFQ/HkoTGqknWirRkC4uQdhQ2e/brY0CSM=;
	b=TNcm5UCpbnw+2gGvqCAGRfeD0cH38QV5yL+LXYPlsOtSG+xaNAl9iwMmKZe60OkiyvTzUE
	MPbrMpilr3x+K1Xnw2Noo3Eu23pmJB+LSg7C87OfPc92b/oWN7iW89zIzEWGRKdFS2t+9b
	KTms3z8JnAJNtr2spG8c3noa/cxyCZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777550962;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Aa3+xJkIiFQ/HkoTGqknWirRkC4uQdhQ2e/brY0CSM=;
	b=4IM0G4gRSzs4S7cZnW/tdU+quLXd8KPax9Zb9UyDXvquAiRwRIJd8/TZe8+HHRgQ/h/VcI
	nObOSROkCj2SocCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TNcm5UCp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4IM0G4gR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777550962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Aa3+xJkIiFQ/HkoTGqknWirRkC4uQdhQ2e/brY0CSM=;
	b=TNcm5UCpbnw+2gGvqCAGRfeD0cH38QV5yL+LXYPlsOtSG+xaNAl9iwMmKZe60OkiyvTzUE
	MPbrMpilr3x+K1Xnw2Noo3Eu23pmJB+LSg7C87OfPc92b/oWN7iW89zIzEWGRKdFS2t+9b
	KTms3z8JnAJNtr2spG8c3noa/cxyCZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777550962;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Aa3+xJkIiFQ/HkoTGqknWirRkC4uQdhQ2e/brY0CSM=;
	b=4IM0G4gRSzs4S7cZnW/tdU+quLXd8KPax9Zb9UyDXvquAiRwRIJd8/TZe8+HHRgQ/h/VcI
	nObOSROkCj2SocCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63645593B0;
	Thu, 30 Apr 2026 12:09:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /0o+GHJG82kjZQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 30 Apr 2026 12:09:22 +0000
Date: Thu, 30 Apr 2026 14:09:21 +0200
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
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
	Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v12 00/13] blk: honor isolcpus configuration
Message-ID: <8c074639-bb75-40be-a338-e80b93123477@flourine.local>
References: <20260422185215.100929-1-atomlin@atomlin.com>
 <e350389a5a635660267a7a13f06529da102a95d8.camel@siemens.com>
 <2d61b1f7-fc06-4fe1-8a6f-cc3a2f114ae1@flourine.local>
 <85415539137c61cdec145ac0ee299dbea7cdd2a1.camel@siemens.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85415539137c61cdec145ac0ee299dbea7cdd2a1.camel@siemens.com>
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[atomlin.com,kernel.dk,kernel.org,lst.de,grimberg.me,redhat.com,microsemi.com,hansenpartnership.com,oracle.com,h-partners.com,broadcom.com,cloud.ionos.com,infradead.org,linaro.org,linux-foundation.org,huawei.com,linutronix.de,gmail.com,suse.de,nvidia.com,abita.co,ashe.io,suse.com,vger.kernel.org,lists.linux.dev,lists.infradead.org,siemens.com];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[54];
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
X-Rspamd-Queue-Id: 838016A81C

On Wed, Apr 29, 2026 at 11:01:33PM +0200, Florian Bezdeka wrote:
> > Which use case are you actually aiming to support? While dynamic
> > reconfiguration would be ideal, the amount of work to get there is
> > significant. I won't be signing up for it.
> 
> The use case at hand is a RT enabled platform where the concrete RT
> workload is not known at boot time. RT applications are deployed "on-
> the-fly", nowadays using the existing container runtimes with some
> extended resource management on top.
> 
> Applications can request certain resources like isolated CPU cores,
> special IRQ affinities, PCI devices to pass through, ...,  so that the
> resource management on the system can take care of proper system
> configuration.


This is where I really question this use case. Currently, it takes quite
a lot of time to tune a system to work properly for RT workloads.
Between memory channel interference, GPU interference, and shared
transports everywhere, you end up with a fixed split: a set of CPUs
suitable for RT work and a set for housekeeping. This partitioning
generally does not change during runtime, even if the way you utilize
those two sets remains dynamic.

Furthermore, reconfiguring a system while running an active RT workload
is asking for trouble. I wouldn't be surprised if doing so triggered a
wide range of unpredictable side effects.
