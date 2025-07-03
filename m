Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D211E29A9EE
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525964; cv=none; b=HCXSOEaIw3OXg4tmjldr6LjWK01SjTBx8naSug1MmL/iteCQxOiipL0rmTbGyc569EgbHD59yeVW/jmsrzebSU9QE0udoKKwPa5HcvGuxu+4t83+fvszmsYJJrC+Vc6XaKQcNnnXBxglkBzZe28iD9y7XXk/g0lWU1j9AxbAc84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525964; c=relaxed/simple;
	bh=HpO9GBcjZkV7Xi7e1U2fle/IMcSg5+uPPNVRuVDcUrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DYpY81o9siqYktfTZg0Z1uyhnoaOFPtwtfrb3kAWFBUrQ2lEvxhlThf10IXX/bFHEotOYNM3A6wPLOvhQksxrfvY5OnBbFBW5iAe6Vp90lH49TukxYVRmR+ECDVufrRp1R+9UV7Rw+7EyOGIZn4QEN70lbUZYUrImQEubLt5png=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lD4m3Ia2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DFJYZxpG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lD4m3Ia2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DFJYZxpG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lD4m3Ia2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DFJYZxpG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lD4m3Ia2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DFJYZxpG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00E7A21185;
	Thu,  3 Jul 2025 06:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Fsiib8zdgWaCro2EGpljFQE5UhciRXKPNK4B5GKkU8=;
	b=lD4m3Ia2bzln4Oczmb9c4Vf4N0xymKDAI+Tf03At9ibhppL78aaGByRkbDb99HWx2ELTis
	0hOdo0dfrReXXYne+Y+6DJ3VXEgac7e/AaS5B0VlWxsfphPjaqohfRb7u6BoahqGxNwWOr
	exgDCSz6ymKA2fzfkvfZyVgEKxLNmi8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Fsiib8zdgWaCro2EGpljFQE5UhciRXKPNK4B5GKkU8=;
	b=DFJYZxpG5gFrtWxpzRxIxg7Ez/VzxX0vzPYdi56Bs2Q74M8b3cP9CUkycv7CwlSgLo7woc
	4lsPG1AAgcE+q4AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lD4m3Ia2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DFJYZxpG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Fsiib8zdgWaCro2EGpljFQE5UhciRXKPNK4B5GKkU8=;
	b=lD4m3Ia2bzln4Oczmb9c4Vf4N0xymKDAI+Tf03At9ibhppL78aaGByRkbDb99HWx2ELTis
	0hOdo0dfrReXXYne+Y+6DJ3VXEgac7e/AaS5B0VlWxsfphPjaqohfRb7u6BoahqGxNwWOr
	exgDCSz6ymKA2fzfkvfZyVgEKxLNmi8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Fsiib8zdgWaCro2EGpljFQE5UhciRXKPNK4B5GKkU8=;
	b=DFJYZxpG5gFrtWxpzRxIxg7Ez/VzxX0vzPYdi56Bs2Q74M8b3cP9CUkycv7CwlSgLo7woc
	4lsPG1AAgcE+q4AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3175E13721;
	Thu,  3 Jul 2025 06:59:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VIEVCUcqZmiXUQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:59:19 +0000
Message-ID: <c98a6d1e-d3df-4865-9ef7-89ba485cf827@suse.de>
Date: Thu, 3 Jul 2025 08:59:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/10] docs: add io_queue flag to isolcpus
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
 <20250702-isolcpus-io-queues-v7-10-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-10-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLdd7zpc331qgmz6gw8s9zsqsb)];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 00E7A21185
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On 7/2/25 18:34, Daniel Wagner wrote:
> The io_queue flag informs multiqueue device drivers where to place
> hardware queues. Document this new flag in the isolcpus
> command-line argument description.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   Documentation/admin-guide/kernel-parameters.txt | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
