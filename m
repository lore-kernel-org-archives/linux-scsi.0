Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F172D1F5434
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2025 06:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751264999; cv=none; b=eKR6Ei73ZpWEpiRbMihTEauz91kv/96HMhcHZ9um4yoEYQkuaflyTjXX+f+t2WLiVjtIk3dDM3A4M5sgoXE4nCnoNkVDoHkpBFXPu9HMzFuJVwUzhLxvmWNPNXvVwh/HxWxfFx4B5O/otjwYC3U5cghtGZckD1PYvePU2AgDtbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751264999; c=relaxed/simple;
	bh=Ne94kVTsvLLZTJtik7jY1bcgtT6q57FsE7blIMe63gE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3dfJRupSQ5yTfBzFR2TCzH1STGy7Y6Kz6hdcWaA76HXHOdP3Gbhu4PvFXBz7jOdoBLvH+Bu87456Ak7kKph02UaxAi83yGEZPIxCYDBc8emyDVf+I2ghW5wW9uuXr0dEeV5B+jyGUH+bIIbLi4Vc2zOVN/5F+ukn/0HMNozg88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gnlWZzxR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=luRU9Bn8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gnlWZzxR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=luRU9Bn8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gnlWZzxR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="luRU9Bn8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gnlWZzxR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="luRU9Bn8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2386E2115F;
	Mon, 30 Jun 2025 06:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751264996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4a8monR3tF8KOIGOp3AbckiUTMIFvbQ7an8p9i9+Zs=;
	b=gnlWZzxRYsR9snuPxctWbr4YxmPgmEHuiFM7oI2VvnZYQ2NDI8leSkqPR+O/VNhaC43iTL
	uZLbXaHvhxJOAaAK/Hvo8zTSrNypTJq53WbOPN6EOiLmYnkuAZJTGNjNBZftvZByYKHUG4
	W7v28N0T2tx/5YqdNoqSDIBovRo9xSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751264996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4a8monR3tF8KOIGOp3AbckiUTMIFvbQ7an8p9i9+Zs=;
	b=luRU9Bn8IXGPA2rgPefjUqeEkRRlTkBo8DkYqMIVOXJbPMKyFkCvE/t2ZvUHKguJiZUWG0
	lIpUEZ9B4M3BEZDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751264996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4a8monR3tF8KOIGOp3AbckiUTMIFvbQ7an8p9i9+Zs=;
	b=gnlWZzxRYsR9snuPxctWbr4YxmPgmEHuiFM7oI2VvnZYQ2NDI8leSkqPR+O/VNhaC43iTL
	uZLbXaHvhxJOAaAK/Hvo8zTSrNypTJq53WbOPN6EOiLmYnkuAZJTGNjNBZftvZByYKHUG4
	W7v28N0T2tx/5YqdNoqSDIBovRo9xSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751264996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4a8monR3tF8KOIGOp3AbckiUTMIFvbQ7an8p9i9+Zs=;
	b=luRU9Bn8IXGPA2rgPefjUqeEkRRlTkBo8DkYqMIVOXJbPMKyFkCvE/t2ZvUHKguJiZUWG0
	lIpUEZ9B4M3BEZDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F14F213A6E;
	Mon, 30 Jun 2025 06:29:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FeVQOOMuYmj4VwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 30 Jun 2025 06:29:55 +0000
Date: Mon, 30 Jun 2025 08:29:55 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 0/5] blk: introduce block layer helpers to calculate num
 of queues
Message-ID: <38e19482-e07d-4130-88d2-fc0a4aa5ddc8@flourine.local>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

Hi Jens,

On Tue, Jun 17, 2025 at 03:43:22PM +0200, Daniel Wagner wrote:
> I am still working on the change request for the "blk: honor isolcpus
> configuration" series [1]. Teaching group_cpus_evenly to use the
> housekeeping mask depending on the context is not a trivial change.
> 
> The first part of the series has already been reviewed and doesn't
> contain any controversial changes, so let's get them processed
> independely.
> 
> [1] https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org

Would you mind to route this series via your tree? There are changes in
several different trees though all the patches have been acked/reviewed
by the corresponding maintainers. Would be great to get some weeks in
'next' so that this series gets some more testing.

Thanks a lot,
Daniel
