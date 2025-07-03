Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A4F293C53
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525939; cv=none; b=Bxnbjy16uVOxXgzhcOqlDdVollD8xvcdKKLKVpRLdSgcVaoMwvD5JHpqLa8Za/+2DCjIPWsVgD5tZIytsiNeBkXVhTfNowj9TtxBvIye4/TMBeguh6z1kSzTbONE/4yIRl98aUJLHjsc7kz3255mg2C/CISCVznKlWviMCVmLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525939; c=relaxed/simple;
	bh=ORFK95pdE/a/p9yk/QkXLJouhq8Tba2lRrvY2NUCr5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OEDDVlhvOgyWjkIhgdc0jxOrnGqIPr4dpRNudVYevRYNVszQqzuuTkYgeD4hYZiLcMnvL0CHR8b5tJmrZpDKIPhrz0lvHlUnoPBU9LbvX0n6xC/SrmBvAF4lXo+ZHReSzwZUao8Xu6lpg9o32+H7e7pqK8CiCRnrVKoF+Gr/3v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EAYHu3n9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bW2LB+Tw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EAYHu3n9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bW2LB+Tw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EAYHu3n9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bW2LB+Tw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EAYHu3n9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bW2LB+Tw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F4131F38D;
	Thu,  3 Jul 2025 06:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feKfxtThbjBgMaSjHhS09nw5zr3XwlSISa7X5gVk0+0=;
	b=EAYHu3n9YzKxuyVeU1KdYrVv4/IUwCAiNfG14WQsYl897617M5VXptV5S6ni8i5oBxqn7d
	VzEG6q2C5IYNunQoBFmYmb+PYtS7/HGiYWZ21p3VBxWxjDtDO5NsH2Ik4TVw3VhiAYvw5A
	h/XKUcEWslsg4xFJTd35jDoEGTMDUQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feKfxtThbjBgMaSjHhS09nw5zr3XwlSISa7X5gVk0+0=;
	b=bW2LB+Tw7wBg50rxBT+vff05vehnW0/CYhOQ9U6UKnMkMQj7utbqGfnvZ3X7UwbvN/LoHC
	Hagf9GaSqU/gcFDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EAYHu3n9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bW2LB+Tw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feKfxtThbjBgMaSjHhS09nw5zr3XwlSISa7X5gVk0+0=;
	b=EAYHu3n9YzKxuyVeU1KdYrVv4/IUwCAiNfG14WQsYl897617M5VXptV5S6ni8i5oBxqn7d
	VzEG6q2C5IYNunQoBFmYmb+PYtS7/HGiYWZ21p3VBxWxjDtDO5NsH2Ik4TVw3VhiAYvw5A
	h/XKUcEWslsg4xFJTd35jDoEGTMDUQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feKfxtThbjBgMaSjHhS09nw5zr3XwlSISa7X5gVk0+0=;
	b=bW2LB+Tw7wBg50rxBT+vff05vehnW0/CYhOQ9U6UKnMkMQj7utbqGfnvZ3X7UwbvN/LoHC
	Hagf9GaSqU/gcFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B83413721;
	Thu,  3 Jul 2025 06:58:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 10nXCC4qZmhyUQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:58:54 +0000
Message-ID: <66bfaac0-03aa-4957-80a7-0f004bb2dc58@suse.de>
Date: Thu, 3 Jul 2025 08:58:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/10] blk-mq: prevent offlining hk CPUs with
 associated online isolated CPUs
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
 <20250702-isolcpus-io-queues-v7-9-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-9-557aa7eacce4@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 2F4131F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On 7/2/25 18:33, Daniel Wagner wrote:
> When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
> given hctx goes offline, there would be no CPU left to handle I/O. To
> prevent I/O stalls, prevent offlining housekeeping CPUs that are still
> serving isolated CPUs.
> 
> When isolcpus=io_queue is enabled and the last housekeeping CPU
> for a given hctx goes offline, no CPU would be left to handle I/O.
> To prevent I/O stalls, disallow offlining housekeeping CPUs that are
> still serving isolated CPUs.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 42 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
