Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9322828935E
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751523590; cv=none; b=iUhvqLQGRzh/xfVWxV5QPq3U8oYYcOJSK6Kq16wvBq9n09N6wG9q5lQgt47MyKKIy+8G7HDGM+q5BxRFlnaU9iayMfHbtkDd8KQ206pBDR/bZxeXCfztmbttkGP1lViT5Uo/+GWNz/rgdjCcFSwypwR8MW/gvljnUudDp7qgWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751523590; c=relaxed/simple;
	bh=bnRLGPo7uTXckbWJF4fZ3k2DHsWuhvAUBbsAXUkwySo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ANFfClA0bHoIGMZYm6/lEMQZAorYugeN53Cz8Sbn+jMXEUXc1lOsTa3ive3UVYXZkSKvxKyOXvsiqDdkh8UkEWuoc2wlYqc3b0+UpUlMsX9LOIGaJiotjZA1wuQnEUx2QZ0FtvAyRiwzyYQCE4r4VdH4sbUDSjOgHeds3Q/JgJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2VWvod62; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yZ7/bd4p; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2VWvod62; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yZ7/bd4p; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2VWvod62";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yZ7/bd4p";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2VWvod62";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yZ7/bd4p"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E0D91F38D;
	Thu,  3 Jul 2025 06:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751523581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohV0h+/at6s8qhvJO3e6EntcK+gCsiWXFp09ll+hPYY=;
	b=2VWvod62vCm9Hz7UlC9/Y0GGgwIai2bGXmyRhNz3r6p46dWFHZHDWY3ac/tbabjsiLuCDK
	stHMSVVU4UAaz9VMOlh+e4olCBzZOnXBSf/0bp59yA6zg5A0FYIoTbZ4A7izhZTYPmYzui
	b7o64TJ0sZWTN9QPJQJbczZk5Qw/9Kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751523581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohV0h+/at6s8qhvJO3e6EntcK+gCsiWXFp09ll+hPYY=;
	b=yZ7/bd4pV5+WVZBt2lQ7otvpAa8smuyu3SzsXqMqKO1WEadpZ7JamTU12JEVFGTQuTeaPO
	0Irq/m6uVOghHaCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2VWvod62;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="yZ7/bd4p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751523581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohV0h+/at6s8qhvJO3e6EntcK+gCsiWXFp09ll+hPYY=;
	b=2VWvod62vCm9Hz7UlC9/Y0GGgwIai2bGXmyRhNz3r6p46dWFHZHDWY3ac/tbabjsiLuCDK
	stHMSVVU4UAaz9VMOlh+e4olCBzZOnXBSf/0bp59yA6zg5A0FYIoTbZ4A7izhZTYPmYzui
	b7o64TJ0sZWTN9QPJQJbczZk5Qw/9Kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751523581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohV0h+/at6s8qhvJO3e6EntcK+gCsiWXFp09ll+hPYY=;
	b=yZ7/bd4pV5+WVZBt2lQ7otvpAa8smuyu3SzsXqMqKO1WEadpZ7JamTU12JEVFGTQuTeaPO
	0Irq/m6uVOghHaCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17F711368E;
	Thu,  3 Jul 2025 06:19:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I3a9A/wgZmhZRgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:19:40 +0000
Message-ID: <1ec7dfeb-b5d6-4aac-9567-db1ab7f9531d@suse.de>
Date: Thu, 3 Jul 2025 08:19:39 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] genirq/affinity: Add cpumask to struct
 irq_affinity
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
 <20250702-isolcpus-io-queues-v7-2-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-2-557aa7eacce4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLdd7zpc331qgmz6gw8s9zsqsb)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 5E0D91F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On 7/2/25 18:33, Daniel Wagner wrote:
> Pass a cpumask to irq_create_affinity_masks as an additional constraint
> to consider when creating the affinity masks. This allows the caller to
> exclude specific CPUs, e.g., isolated CPUs (see the 'isolcpus' kernel
> command-line parameter).
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   include/linux/interrupt.h | 16 ++++++++++------
>   kernel/irq/affinity.c     | 12 ++++++++++--
>   2 files changed, 20 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
