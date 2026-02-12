Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CECE299AAC
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 07:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770882752; cv=none; b=qbDCXGMw5u+bN6kA/UdtUdW8Gp5k3lia844lKSl7PWgkQwRgXd4+ucwt95jPTlbFQsF5e9D5PO3xgstIPIniFaUh3HVIOZj4bvtCd4bckN+Nzz0Uqggz/Ajl7hoLA8Z8fYTv8q6MRm2udlF0aCR7+VbOc12F1ahfVL8KoHy7mN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770882752; c=relaxed/simple;
	bh=VCtP5Jbs0wGks2HwsE+w2dcqNZ4v8WL4RgVfvG+c8rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao2A/nvAXC4KWkSt55CVeEwJQma3nQzKtDI1bO4ibVzcJEuHZ3mS/wn8XlOe3M88VILtINHYmn1XEu92Y0hZsLOqU7BYVYMG7NTrK8Lv2yVwQZCXM1O4e6MdFyqLE82KrJK7rECf3bZhLWEVZctlqQ5byVOpwWBK72rNnGrxblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EVW9NEkA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YeVO5mvd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EVW9NEkA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YeVO5mvd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EVW9NEkA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YeVO5mvd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EVW9NEkA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YeVO5mvd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA1B55BD96;
	Thu, 12 Feb 2026 07:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770882748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kycnw5UwTvJbOYBNujMr0exOv++Nwer9Dq4InJ4/93s=;
	b=EVW9NEkAhkCPWv4hjIW8zOYwT5c3k2E/5+CEWrjBe0ZjiPY2QTSrb3e5Lf6ZaqR0k98rZa
	SHfHM2BV1+kUKUpyghmR4Ew9S6v69ka4FMYpcwH3rX3NNp8E4+KCAT/jUBIT2q7FkLqaPz
	4AktbiWLJMJ43C/cCdT8ll9i5j9+j68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770882748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kycnw5UwTvJbOYBNujMr0exOv++Nwer9Dq4InJ4/93s=;
	b=YeVO5mvd2TR4End4l7/0i2R2jU8PsO/Uy/duLoLQqPRdu2ksP9RMpqEnMsj2SmbgV22Ic3
	yZXgDsPJwrHx8bBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EVW9NEkA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YeVO5mvd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770882748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kycnw5UwTvJbOYBNujMr0exOv++Nwer9Dq4InJ4/93s=;
	b=EVW9NEkAhkCPWv4hjIW8zOYwT5c3k2E/5+CEWrjBe0ZjiPY2QTSrb3e5Lf6ZaqR0k98rZa
	SHfHM2BV1+kUKUpyghmR4Ew9S6v69ka4FMYpcwH3rX3NNp8E4+KCAT/jUBIT2q7FkLqaPz
	4AktbiWLJMJ43C/cCdT8ll9i5j9+j68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770882748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kycnw5UwTvJbOYBNujMr0exOv++Nwer9Dq4InJ4/93s=;
	b=YeVO5mvd2TR4End4l7/0i2R2jU8PsO/Uy/duLoLQqPRdu2ksP9RMpqEnMsj2SmbgV22Ic3
	yZXgDsPJwrHx8bBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CDBD3EA62;
	Thu, 12 Feb 2026 07:52:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fIVUJbyGjWmxSwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Thu, 12 Feb 2026 07:52:28 +0000
Date: Thu, 12 Feb 2026 08:52:23 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>, 
	"tytso@mit.edu" <tytso@mit.edu>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>, 
	"willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
Message-ID: <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[22];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,lists.linux-foundation.org,acm.org,wdc.com,suse.de,lst.de,kernel.dk,grimberg.me,mit.edu,kernel.org,oracle.com,javigon.com,infradead.org,suse.cz,gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BA1B55BD96
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed, Feb 11, 2026 at 08:35:30PM +0000, Chaitanya Kulkarni wrote:
>    For the storage track at LSFMMBPF2026, I propose a session dedicated to
>    blktests to discuss expansion plan and CI integration progress.

Thanks for proposing this topic.

Just a few random topics which come to mind we could discuss:

- blktests has gain a bit of traction and some folks run on regular
  basis these tests. Can we gather feedback from them, what is working
  good, what is not? Are there feature wishes?
- Do we need some sort of configuration tool which allows to setup a
  config? I'd still have a TODO to provide a config example with all
  knobs which influence blktests, but I wonder if we should go a step
  further here, e.g. something like kdevops has?
- Which area do we lack tests? Should we just add an initial simple
  tests for the missing areas, so the basic infra is there and thus
  lowering the bar for adding new tests?
- The recent addition of kmemleak shows it's a great idea to enable more
  of the kernel test infrastructure when running the tests. Are there
  more such things we could/should enable?
- I would like to hear from Shin'ichiro if he is happy how things
  are going? :)
