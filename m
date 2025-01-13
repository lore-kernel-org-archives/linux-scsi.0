Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE511B7F4;
	Mon, 13 Jan 2025 07:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752086; cv=none; b=ZzL+7sh8Qz2xnipK5ubOgSGPf4FZYu1Asla/Hrqc5MbuFDEobOMJNkQNkfMy5EfANVAh2rnLdqnPIg9C489nOV/tw61nAuBOobrzl4zYxIHc364mXSvLch5fC0ZB219KOQbd3OdcnBdTFXnbxR2+8oS+xwEnsugNQbhdp1zJ1mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752086; c=relaxed/simple;
	bh=UQ/bILYCb6BTWhBYUZ/d+YcqU/4uMopsm7v8dhSn5Q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVCWUk5A+DlhvpgOi8r5nu+I3YmbjVqVePyySF7L1dMbXLrKV5mkdnMjANhUQUpd7HBvdo0TW9xtaKFfxF6PLDbdeuhyHVmeR20exV1aDfK39WJ2c4ycnUWjaZ/ntM9bFCiSVyXbtqgvupCVMFdjuxx7javTLaKnyz6IByT2KaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zIEEhLDX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZIaA65BX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zIEEhLDX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZIaA65BX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zIEEhLDX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZIaA65BX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zIEEhLDX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZIaA65BX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C17B2110A;
	Mon, 13 Jan 2025 07:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaoASj0lVyE9FAn2HXC0AYJQkjIkt1qbiCgs4Qbv0t0=;
	b=zIEEhLDX4fDlf6a1oijGTf8FJ+x0l2AxsT+9mYLNj+2bW1hTXo0qkjKRPWDpdbDbcH+JVC
	jnKjCHFzoaUmNlFFojAXnvyq6j4DV9hUkLmhK89z9g7J1/E4IMlLnMKOvG9z0galQOtKTT
	4Wi4h5geehYXWr3lRDH/GkC5DzEnBwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaoASj0lVyE9FAn2HXC0AYJQkjIkt1qbiCgs4Qbv0t0=;
	b=ZIaA65BXf7++yEAEDwkc/xaBmsjiRKDMdIcKCVF5Jl778oFlPYgZfSOC9+s01o2OQVFGpR
	JLA46C+jwjBFhoAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zIEEhLDX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZIaA65BX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaoASj0lVyE9FAn2HXC0AYJQkjIkt1qbiCgs4Qbv0t0=;
	b=zIEEhLDX4fDlf6a1oijGTf8FJ+x0l2AxsT+9mYLNj+2bW1hTXo0qkjKRPWDpdbDbcH+JVC
	jnKjCHFzoaUmNlFFojAXnvyq6j4DV9hUkLmhK89z9g7J1/E4IMlLnMKOvG9z0galQOtKTT
	4Wi4h5geehYXWr3lRDH/GkC5DzEnBwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaoASj0lVyE9FAn2HXC0AYJQkjIkt1qbiCgs4Qbv0t0=;
	b=ZIaA65BXf7++yEAEDwkc/xaBmsjiRKDMdIcKCVF5Jl778oFlPYgZfSOC9+s01o2OQVFGpR
	JLA46C+jwjBFhoAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A445913876;
	Mon, 13 Jan 2025 07:07:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a5BzJsu7hGfWKQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:07:55 +0000
Message-ID: <06ae6360-f252-47e9-b705-43270edee582@suse.de>
Date: Mon, 13 Jan 2025 08:07:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/9] lib/group_cpus: let group_cpu_evenly return number
 initialized masks
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev,
 GR-QLogic-Storage-Upstream@marvell.com
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
 <20250110-isolcpus-io-queues-v5-1-0e4f118680b0@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250110-isolcpus-io-queues-v5-1-0e4f118680b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C17B2110A
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 1/10/25 17:26, Daniel Wagner wrote:
> group_cpu_evenly might allocated less groups then the requested:
> 
> group_cpu_evenly
>    __group_cpus_evenly
>      alloc_nodes_groups
>        # allocated total groups may be less than numgrps when
>        # active total CPU number is less then numgrps
> 
> In this case, the caller will do an out of bound access because the
> caller assumes the masks returned has numgrps.
> 
> Return the number of groups created so the caller can limit the access
> range accordingly.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq-cpumap.c        |  6 +++---
>   drivers/virtio/virtio_vdpa.c |  9 +++++----
>   fs/fuse/virtio_fs.c          |  6 +++---
>   include/linux/group_cpus.h   |  3 ++-
>   kernel/irq/affinity.c        |  9 +++++----
>   lib/group_cpus.c             | 12 +++++++++---
>   6 files changed, 27 insertions(+), 18 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
