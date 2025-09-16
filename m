Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CDB1FBC92
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 08:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758011658; cv=none; b=KDMCCgMqxvR6+jNebCAT479tv9N2SxKgi6f6Kettt5fJMVfDsf5JKFoSy4yy1qwkbrR0cj2ogCAMDiv1Hn0AKafv5J0ikejdh8j+CQ+S4tpenrTY8N9fDA47Da4842nIflS2qwUrubRtWmtv5LMHfWUl4s3I1jkG+4j7QywV5dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758011658; c=relaxed/simple;
	bh=4F+THH5bIZePB7IQf7r9hTs5+iho0QpiclS60FzbE5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjGJBmPVkDfLSB9w3CPmh38/I+dpb2RPt9d6c5F7QZmexAYypsTKkIUzVWJR/j6NHhXruuBJt+HTc99WTUBDCLhwWEXUlLrZin0m1whA8jj3b61WJY58Xq1P8xz+RlziNOHfv52e3Iq8vyU42kr3/z4DR6IZgLXA3XFAnMqHeKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EuTzGNEH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TWrVx+2d; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EuTzGNEH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TWrVx+2d; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EuTzGNEH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TWrVx+2d";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EuTzGNEH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TWrVx+2d"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 005C221A7B;
	Tue, 16 Sep 2025 08:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758011655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fy2medfdVyzQT2II6Xrf2+0ScfZyZpmkwD4t6EuIZ9A=;
	b=EuTzGNEH/1rAe2BX5wnVW7BO92KETR1zB4+N6dbq5M1jaVLd2iS5Pw/QBRYJdfDHnD22xz
	IYex60HfcedrtIVYSaRgYX5i8AHhJpQt4eaIx/HFyK8suR9pdpzm5JpxRMqM0p5zl3+28e
	udR8FyAzdsaCSsUd7yUYLTQ2a0KBm8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758011655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fy2medfdVyzQT2II6Xrf2+0ScfZyZpmkwD4t6EuIZ9A=;
	b=TWrVx+2dHAKYkuUBfWC3GdMCcbfGB7IB8KZ85Z8qLEkjZx0foveXJVkpeJc3r1y+YmcP0G
	OwXS8E8+iautFWAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758011655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fy2medfdVyzQT2II6Xrf2+0ScfZyZpmkwD4t6EuIZ9A=;
	b=EuTzGNEH/1rAe2BX5wnVW7BO92KETR1zB4+N6dbq5M1jaVLd2iS5Pw/QBRYJdfDHnD22xz
	IYex60HfcedrtIVYSaRgYX5i8AHhJpQt4eaIx/HFyK8suR9pdpzm5JpxRMqM0p5zl3+28e
	udR8FyAzdsaCSsUd7yUYLTQ2a0KBm8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758011655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fy2medfdVyzQT2II6Xrf2+0ScfZyZpmkwD4t6EuIZ9A=;
	b=TWrVx+2dHAKYkuUBfWC3GdMCcbfGB7IB8KZ85Z8qLEkjZx0foveXJVkpeJc3r1y+YmcP0G
	OwXS8E8+iautFWAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E08F613A63;
	Tue, 16 Sep 2025 08:34:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FZdmNgYhyWi5IQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 16 Sep 2025 08:34:14 +0000
Message-ID: <aabc487c-ced6-499a-8231-6fc4866c12f9@suse.de>
Date: Tue, 16 Sep 2025 10:34:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/29] scsi: core: Make the budget map optional
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-4-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250912182340.3487688-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 9/12/25 20:21, Bart Van Assche wrote:
> Prepare for not allocating a budget map for pseudo SCSI devices by
> checking whether a budget map has been allocated before using a budget
> map.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi.c     |  2 ++
>   drivers/scsi/scsi_lib.c | 14 ++++++++++++--
>   2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9a0f467264b3..ff6b0973d3b4 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -216,6 +216,8 @@ int scsi_device_max_queue_depth(struct scsi_device *sdev)
>    */
>   int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   {
> +	WARN_ON_ONCE(!sdev->budget_map.map);
> +
>   	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
>   
>   	if (depth > 0) {
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9c67e04265ce..91a0c7f843c1 100644
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
> @@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>   {
>   	int token;
>   
> +	/*
> +	 * Do not allocate a budget token for reserved SCSI commands. Budget
> +	 * tokens are used to enforce the cmd_per_lun limit. That limit does not
> +	 * apply to reserved commands.
> +	 */
> +	if (!sdev->budget_map.map)
> +		return INT_MAX;
> +

Strictly speaking it's not related to reserved commands, but rather to 
cmd_per_lun. Wouldn't it be better to introduce a way to disable 
cmd_per_lun (eg by setting it to INT_MAX or somesuch), and then disable
the budget map when cmd_per_lun is disabled?

Other than that I really like the idea of being able to disable the
budget map. I always wondered if we won't be better off with dropping
the budget map for HBAs with a shared host tagset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
