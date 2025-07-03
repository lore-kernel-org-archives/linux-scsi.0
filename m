Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BAE292B20
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525031; cv=none; b=T8/EW+fGSXQo+opnw58ik6wzxvj5+vW4k5hi7YrhlDHNTUe9sIYFo44KHT/5J4OC1uwF6fLcXjTFn4w3XZRgohfiK8ruNVO9tIojS5V5uVhomRYvtx3K4UCMWeLsSW76c02rz1rgx6nFBAFIQJJvYhuq09GQ2LP9DfbJED0C390=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525031; c=relaxed/simple;
	bh=fgOL4X0nHZu3oKlism51xOOvq32ZRpdo1P4uSnZjuno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q9+X7agiYw0LCDTlBJIpP8F0JKuFc9DogJu/PQXnWA8nHBtDpvAcCft7TP3epl2V6bHeYTorecOiwmyuE0qHRuSuuJ03haB3bgrA4ZHvNDumdHSSvkWdkOCOB9BYgsr8L5cXRkNVzZvMGUJ1mPPuH7PEYDfhRZG2o0cKLoqYVT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dV9uC42U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0xiMX+VT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dV9uC42U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0xiMX+VT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dV9uC42U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0xiMX+VT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dV9uC42U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0xiMX+VT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AFD11F38D;
	Thu,  3 Jul 2025 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAQIzVPPbCYp4/TF0GfMAJgZhsA53Z+zM0DO9YWrwqg=;
	b=dV9uC42UbQkZNogR574n5ulIES8Lso3aBNEhmTnUO2SjnujNyIJqRBJC5djp+I6/Fntd9c
	yFXh83+J7u3qxx4X0+UP6UyuWYXBys5F3F152dFYs+lF6EBvBe0BsqOMfNC7b4VLThXiND
	Bt/W8Io+WPea4YJ/TMYmiQLwJIh+bAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAQIzVPPbCYp4/TF0GfMAJgZhsA53Z+zM0DO9YWrwqg=;
	b=0xiMX+VTiEHVtd2wgESqIdMO/DhTnbI2pBFvBfB+bhIsYqA6TWxzmOyp2xHvr4DN3yFJ7N
	Fmg7CN1hFsDcbBBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dV9uC42U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0xiMX+VT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751525027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAQIzVPPbCYp4/TF0GfMAJgZhsA53Z+zM0DO9YWrwqg=;
	b=dV9uC42UbQkZNogR574n5ulIES8Lso3aBNEhmTnUO2SjnujNyIJqRBJC5djp+I6/Fntd9c
	yFXh83+J7u3qxx4X0+UP6UyuWYXBys5F3F152dFYs+lF6EBvBe0BsqOMfNC7b4VLThXiND
	Bt/W8Io+WPea4YJ/TMYmiQLwJIh+bAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751525027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAQIzVPPbCYp4/TF0GfMAJgZhsA53Z+zM0DO9YWrwqg=;
	b=0xiMX+VTiEHVtd2wgESqIdMO/DhTnbI2pBFvBfB+bhIsYqA6TWxzmOyp2xHvr4DN3yFJ7N
	Fmg7CN1hFsDcbBBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5107C1368E;
	Thu,  3 Jul 2025 06:43:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ANtJEqImZmhDTQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 03 Jul 2025 06:43:46 +0000
Message-ID: <8a559a2c-c4f5-4ce2-9e1b-e960cd59fb9f@suse.de>
Date: Thu, 3 Jul 2025 08:43:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/10] virtio: blk/scsi: use block layer helpers to
 constrain queue affinity
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
 <20250702-isolcpus-io-queues-v7-6-557aa7eacce4@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250702-isolcpus-io-queues-v7-6-557aa7eacce4@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 0AFD11F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On 7/2/25 18:33, Daniel Wagner wrote:
> Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
> constraints provided by the block layer. This allows the virtio drivers
> to avoid assigning interrupts to CPUs that the block layer has excluded
> (e.g., isolated CPUs).
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   drivers/block/virtio_blk.c | 4 +++-
>   drivers/scsi/virtio_scsi.c | 5 ++++-
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index e649fa67bac16b4f0c6e8e8f0e6bec111897c355..41b06540c7fb22fd1d2708338c514947c4bdeefe 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -963,7 +963,9 @@ static int init_vq(struct virtio_blk *vblk)
>   	unsigned short num_vqs;
>   	unsigned short num_poll_vqs;
>   	struct virtio_device *vdev = vblk->vdev;
> -	struct irq_affinity desc = { 0, };
> +	struct irq_affinity desc = {
> +		.mask = blk_mq_possible_queue_affinity(),
> +	};
>   
>   	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
>   				   struct virtio_blk_config, num_queues,
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 96a69edddbe5555574fc8fed1ba7c82a99df4472..67dfb265bf9e54adc68978ac8d93187e6629c330 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -842,7 +842,10 @@ static int virtscsi_init(struct virtio_device *vdev,
>   	u32 num_vqs, num_poll_vqs, num_req_vqs;
>   	struct virtqueue_info *vqs_info;
>   	struct virtqueue **vqs;
> -	struct irq_affinity desc = { .pre_vectors = 2 };
> +	struct irq_affinity desc = {
> +		.pre_vectors = 2,
> +		.mask = blk_mq_possible_queue_affinity(),
> +	};
>   
>   	num_req_vqs = vscsi->num_queues;
>   	num_vqs = num_req_vqs + VIRTIO_SCSI_VQ_BASE;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
