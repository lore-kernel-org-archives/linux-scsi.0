Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568CB4FD788;
	Thu, 15 Oct 2026 11:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792063363; cv=none; b=CfvgDf7pyBo1gaOuUmygmWf+rqMech9rVPOC3OLuCwOD757xoroCv1MA8ZU33Ryqy/7Vtz3GvsUh4Hr0FoNDWQixAsVvJy7naTv5jiOYDqhITs2eOX+w11mi3pj5Ej8tp7PsyGoLos/h7F+G5u9+6BqbW7CRIiyw7lyJWAcHFNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792063363; c=relaxed/simple;
	bh=llqqU4we6eRloN54nHJf/dm8JbByBlB9xb2+A8hWIwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QstQPcqwCJY/oVNsAQUekpvc65puT7Bj39TMUSzxfDqIdnUACB2gcL0E0yjSiKx3ZkXh6cvFoIWGTQvi8j8q7UOFEBolEi1LfSuCvIbQSrp6D30oauzcFTiFgijwBV/9DmIpWnv8Kk4G84N4o7kxM2+I7UpbKC8wJ5PgzTl7lng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a2EKGaTz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mm1xbbUl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a2EKGaTz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mm1xbbUl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a2EKGaTz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mm1xbbUl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a2EKGaTz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mm1xbbUl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E1A922246;
	Thu, 15 Oct 2026 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792063357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RQ7QFdl3nIsJQGI3osLG5XKZI5HfDdAs8KL/NgWLzI=;
	b=a2EKGaTz49+5OtTME5/fu5DvKGQ0YQwFSjaa1pEiVMwI5RxyvZ6i2VKh7njBrzTT1hQhiD
	6OPS1a5TfftLtYULpanIXEUb0I9/+WtaA6nT1GntyLo18vt7y/xoaAtTHVXkWGrM1us221
	4INzMetaNGC70qeSHCCXO67KWVFynhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792063357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RQ7QFdl3nIsJQGI3osLG5XKZI5HfDdAs8KL/NgWLzI=;
	b=mm1xbbUlUNAifWHToy0ea7SgByfmNgI26wbMQAu9vtyLEByEUsc8G0KKaA0/9A06GrRCIZ
	kSRrN0STL6toEUDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=a2EKGaTz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mm1xbbUl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792063357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RQ7QFdl3nIsJQGI3osLG5XKZI5HfDdAs8KL/NgWLzI=;
	b=a2EKGaTz49+5OtTME5/fu5DvKGQ0YQwFSjaa1pEiVMwI5RxyvZ6i2VKh7njBrzTT1hQhiD
	6OPS1a5TfftLtYULpanIXEUb0I9/+WtaA6nT1GntyLo18vt7y/xoaAtTHVXkWGrM1us221
	4INzMetaNGC70qeSHCCXO67KWVFynhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792063357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RQ7QFdl3nIsJQGI3osLG5XKZI5HfDdAs8KL/NgWLzI=;
	b=mm1xbbUlUNAifWHToy0ea7SgByfmNgI26wbMQAu9vtyLEByEUsc8G0KKaA0/9A06GrRCIZ
	kSRrN0STL6toEUDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D4E8132C9;
	Thu, 15 Oct 2026 11:22:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fapTLXy30Gr+SgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 15 Oct 2026 11:22:37 +0000
Date: Thu, 15 Oct 2026 13:22:35 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, tglx@kernel.org, aacraid@microsemi.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, frederic@kernel.org, bigeasy@linutronix.de, 
	ionut.nechita@windriver.com, corbet@lwn.net, vincent.guittot@linaro.org, mingo@redhat.com, 
	peterz@infradead.org, radu@rendec.net, akpm@linux-foundation.org, steve@abita.co, 
	sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, 
	nick.lange@gmail.com, marco.crivellari@suse.com, rishil1999@outlook.com, 
	linux-doc@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Message-ID: <2f32ffb6-d889-4281-a612-d4185311ca0d@flourine.local>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,outlook.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,microsemi.com,hansenpartnership.com,linutronix.de,windriver.com,lwn.net,linaro.org,redhat.com,infradead.org,rendec.net,linux-foundation.org,abita.co,ashe.io,gmail.com,suse.com,outlook.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLip3qrwmtdyuwmp1ydoxr43fi)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: 7E1A922246
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Thu, Sep 10, 2026 at 12:42:28PM -0400, Aaron Tomlin wrote:
> Maintainer guidance requested
> =============================
> 
> We would appreciate guidance from Frederic Weisbecker regarding preference
> on this front:
>         1.  Do you prefer keeping "managed_irq_strict" as an explicit
>             opt-in (as implemented in this series) to preserve historical
>             behaviour for existing users of "managed_irq"?
> 
>         2.  Or would you prefer upgrading the semantics of "managed_irq"
>             directly in place without introducing a new parameter, on the
>             grounds that the legacy post-allocation behaviour is already
>             broken for modern multiqueue hardware?

During Plumbers we had several discussions on this series. This is what I
remember we discussed and decided:

  - The current managed_irq behavior doesn't match the other flags of isolcpus.

  - Instead of introducing managed_irq_strict, it's better to change the
    existing managed_irq to follow the strict interpretation.

  - The main existing user of the current managed_irq mapping is
    RH with OpenShift. After discussing with Juri, it doesn't look like
    it is a real blocker to change to the strict interpretation.

  - If there are complaints about the managed irq behavior change, it's
    better to introduce a different flag for this. Though there have been
    many discussions and proposals on how to deal with isolation during the
    conference, and the general mood was that the placement of resources
    should be done during runtime. Thus it is likely that the old behaviour
    is not necessary at all if runtime configuration is possible.

Hope this helps to move forward with this series,
Daniel
