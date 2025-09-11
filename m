Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B6826738C
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 06:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757572860; cv=none; b=ZgF8Y67LtdQTieV0BZrhh+iJPvNad5SgkwUiQ8EobPSeqmJClX0xTH2LS4AkN9+UxXoC2N337GaAXCg6/4TbBj0YkgfuZXL1DrcRvIVDxYEI58P3gT3pGzQGyt9Qip49I6nEPaHN03JFk9qD1RM/djJ+3BualEKSQ3IgVLZaK3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757572860; c=relaxed/simple;
	bh=oc3pfMxtwNalmPMOZFevwegSFiZUZK15z34En/YiVGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QXIWBY+ngstHhQB6Wla3tEwqUjs8EI8C56d7vGPZO+SrjIcMyo97yLlJXRau2Jotd+7m65yk/dc48Mas08xa1G7D9+IDn6kiGfxXfyjiQaPtZX//s8eepe5cDb+wqjX28RqjSIjy1CMvkFbnj9bsp87rdjkGLWMzE+9XsegrLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vuujZcv0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gHeHMCdN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=swdOLtFG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1T2MnEf2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vuujZcv0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gHeHMCdN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="swdOLtFG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1T2MnEf2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4B783FA8D;
	Thu, 11 Sep 2025 06:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757572856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f5LJGeMPUM4kaRt+2xWRpOD4y/a+ZDx0gdKKdb/GO4=;
	b=vuujZcv0GOnF53I0O5jfbyg4qyy0GZItpqsftuZ68n+VOgsxAMmhXIxCjCcOIdj0XjeE0e
	q8baiAl/erMOPgtWzrQsnQL8xWbdZPrxYGPMPZxCJlPd+DRtZx3f6ojk2KbqSAjVdz6ueV
	ReiVD5XDzN0vI6rVjCViKtw8cXbGa5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757572856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f5LJGeMPUM4kaRt+2xWRpOD4y/a+ZDx0gdKKdb/GO4=;
	b=gHeHMCdNa7C93YZ+DoxVaiaikhEfAcz0vQw6BYHZzivfhD2ddTkgk4vgAPCsjEqsjvS55V
	IwQLOooA8/pCczBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757572855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f5LJGeMPUM4kaRt+2xWRpOD4y/a+ZDx0gdKKdb/GO4=;
	b=swdOLtFGFV5DcLRpW4g8nFlAR0AsSVgSO0HUrlPUIkRKzHPmNI1Y3cmUz5h+Nh0mcZETXg
	nM1cIF6/3d4jHIsk2hSOsOh7mWySH/S+e5KgTMGvW2vqghNvYcLyoPnKTcpSsUQPbI/A8g
	WVaVZRus2URybOrwoFignMwaPEiIlmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757572855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f5LJGeMPUM4kaRt+2xWRpOD4y/a+ZDx0gdKKdb/GO4=;
	b=1T2MnEf2YdSCuWHMWLwfJvUpnsyyuzIBP1kpC23Y1u9ZGFBh0oF5V4EJdVIhAJG8smFdfo
	G/xl5zyruLuSntDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 792711372E;
	Thu, 11 Sep 2025 06:40:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GvwGHPduwmilTgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 11 Sep 2025 06:40:55 +0000
Message-ID: <efb81481-5af3-4bb6-b378-878dc24b9767@suse.de>
Date: Thu, 11 Sep 2025 08:40:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Improve IOPS in case of host-wide tags
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
 <20250910213254.1215318-4-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250910213254.1215318-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 9/10/25 23:32, Bart Van Assche wrote:
> The SCSI core uses the budget map to enforce the cmd_per_lun limit.
> That limit cannot be exceeded if host->cmd_per_lun >= host->can_queue
> and if the host tag set is shared across all hardware queues.
> Since scsi_mq_get_budget() shows up in all CPU profiles for fast SCSI
> devices, do not allocate a budget map if cmd_per_lun >= can_queue and
> if the host tag set is shared across all hardware queues.
> 
> On my UFS 4 test setup this patch improves IOPS by 1% and reduces the
> time spent in scsi_mq_get_budget() from 0.22% to 0.01%.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi.c        |  7 ++++-
>   drivers/scsi/scsi_lib.c    | 60 +++++++++++++++++++++++++++++++++-----
>   drivers/scsi/scsi_scan.c   | 11 ++++++-
>   include/scsi/scsi_device.h |  5 +---
>   4 files changed, 70 insertions(+), 13 deletions(-)
> 
That is actually a valid point.
There are devices which set 'cmd_per_lun' to the same value
as 'can_queue', rendering the budget map a bit pointless.
But calling blk_mq_all_tag_iter() is more expensive than a simple
sbitmap_weight(), so the improvement isn't _that_ big
(as demonstrated by just 1% performance increase).

> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9a0f467264b3..06066b694d8a 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -216,6 +216,8 @@ int scsi_device_max_queue_depth(struct scsi_device *sdev)
>    */
>   int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   {
> +	struct Scsi_Host *shost = sdev->host;
> +
>   	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
>   
>   	if (depth > 0) {
> @@ -226,7 +228,10 @@ int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   	if (sdev->request_queue)
>   		blk_set_queue_depth(sdev->request_queue, depth);
>   
> -	sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
> +	if (shost->host_tagset && depth >= shost->can_queue)
> +		sbitmap_free(&sdev->budget_map);
> +	else
> +		sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
>   
>   	return sdev->queue_depth;
>   }
I would make this static, and only allocate a budget_map if the
'cmd_per_lun' setting is smaller than the 'can_queue' setting.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0c65ecfedfbd..c546514d1049 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> -	sbitmap_put(&sdev->budget_map, cmd->budget_token);
> +	if (sdev->budget_map.map)
> +		sbitmap_put(&sdev->budget_map, cmd->budget_token);
>   	cmd->budget_token = -1;
>   }
>   
> @@ -445,6 +446,47 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
>   
> +struct sdev_in_flight_data {
> +	const struct scsi_device *sdev;
> +	int count;
> +};
> +
> +static bool scsi_device_check_in_flight(struct request *rq, void *data)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +	struct sdev_in_flight_data *sifd = data;
> +
> +	if (cmd->device == sifd->sdev)
> +		sifd->count++;
> +
> +	return true;
> +}
> +
> +/**
> + * scsi_device_busy() - Number of commands allocated for a SCSI device
> + * @sdev: SCSI device.
> + *
> + * Note: There is a subtle difference between this function and
> + * scsi_host_busy(). scsi_host_busy() counts the number of commands that have
> + * been started. This function counts the number of commands that have been
> + * allocated. At least the UFS driver depends on this function counting commands

But then please don't name the callback 'scsi_device_check_in_flight',
as 'in flight' means 'commands which have been started'.
Please name it 'scsi_device_check_allocated' to make the distinction
clear.

> + * that have already been allocated but that have not yet been started.
> + */
> +int scsi_device_busy(const struct scsi_device *sdev)
> +{
> +	struct sdev_in_flight_data sifd = { .sdev = sdev };
> +	struct blk_mq_tag_set *set = &sdev->host->tag_set;
> +
> +	if (sdev->budget_map.map)
> +		return sbitmap_weight(&sdev->budget_map);
> +	if (WARN_ON_ONCE(!set->shared_tags))
> +		return 0;

One wonders: what would happen if you would return '0' here if
there is only one LUN?

> +	blk_mq_all_tag_iter(set->shared_tags, scsi_device_check_in_flight,
> +			    &sifd);
> +	return sifd.count;
> +}
> +EXPORT_SYMBOL(scsi_device_busy);
> +
>   static inline bool scsi_device_is_busy(struct scsi_device *sdev)
>   {
>   	if (scsi_device_busy(sdev) >= sdev->queue_depth)
> @@ -1358,11 +1400,13 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
>   static inline int scsi_dev_queue_ready(struct request_queue *q,
>   				  struct scsi_device *sdev)
>   {
> -	int token;
> +	int token = INT_MAX;
>   
> -	token = sbitmap_get(&sdev->budget_map);
> -	if (token < 0)
> -		return -1;
> +	if (sdev->budget_map.map) {
> +		token = sbitmap_get(&sdev->budget_map);
> +		if (token < 0)
> +			return -1;
> +	}
>   
>   	if (!atomic_read(&sdev->device_blocked))
>   		return token;
> @@ -1373,7 +1417,8 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>   	 */
>   	if (scsi_device_busy(sdev) > 1 ||
>   	    atomic_dec_return(&sdev->device_blocked) > 0) {
> -		sbitmap_put(&sdev->budget_map, token);
> +		if (sdev->budget_map.map)
> +			sbitmap_put(&sdev->budget_map, token);
>   		return -1;
>   	}
>   
> @@ -1749,7 +1794,8 @@ static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
>   {
>   	struct scsi_device *sdev = q->queuedata;
>   
> -	sbitmap_put(&sdev->budget_map, budget_token);
> +	if (sdev->budget_map.map)
> +		sbitmap_put(&sdev->budget_map, budget_token);
>   }
>   
>   /*
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3c6e089e80c3..6f2d0bf0e3ec 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -218,6 +218,7 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
>   static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>   					unsigned int depth)
>   {
> +	struct Scsi_Host *shost = sdev->host;
>   	int new_shift = sbitmap_calculate_shift(depth);
>   	bool need_alloc = !sdev->budget_map.map;
>   	bool need_free = false;
> @@ -225,6 +226,13 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>   	int ret;
>   	struct sbitmap sb_backup;
>   
> +	if (shost->host_tagset && depth >= shost->can_queue) {
> +		memflags = blk_mq_freeze_queue(sdev->request_queue);
> +		sbitmap_free(&sb_backup);

What are you freeing here?
The sbitmap was never allocated, so you should be able to simply
return 0 here...

> +		blk_mq_unfreeze_queue(sdev->request_queue, memflags);
> +		return 0;
> +	}
> +
>   	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
>   
>   	/*
> @@ -1112,7 +1120,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	scsi_cdl_check(sdev);
>   
>   	sdev->max_queue_depth = sdev->queue_depth;
> -	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
> +	WARN_ON_ONCE(sdev->budget_map.map &&
> +		     sdev->max_queue_depth > sdev->budget_map.depth);
>   	sdev->sdev_bflags = *bflags;
>   
>   	/*
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 6d6500148c4b..3c7a95fa9b67 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -687,10 +687,7 @@ static inline int scsi_device_supports_vpd(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> -static inline int scsi_device_busy(struct scsi_device *sdev)
> -{
> -	return sbitmap_weight(&sdev->budget_map);
> -}
> +int scsi_device_busy(const struct scsi_device *sdev);
>   
>   /* Macros to access the UNIT ATTENTION counters */
>   #define scsi_get_ua_new_media_ctr(sdev) \
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
