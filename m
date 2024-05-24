Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CFB1AACC;
	Fri, 24 May 2024 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546392; cv=none; b=S3bQdSfGrELS5YL+aqd1HVINeWf/yZpYHtPdSDpQB6zrQ6zWYLZCxyKeo0Hwn//Jy8L3/qYs4wcEnxNM1YHPNOPEzJk+Rf5cuGUsEB8M7Z+PpLDvSa7shKNWguse1vhUXn6IflfRKj2wc7Oj9hox4yoKke0K9e344SkD48pIVm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546392; c=relaxed/simple;
	bh=M7BPVny6GRqRCRrBPsePpinTmhcQxMXr2fj7fwqN5P4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZipC5ZqMAXB+xEAz1TIZLpROJGbyR0aQWTcFRcMTlGnSnksq4Z+PVYGjdCP1hMBYfwA2VVUayWcDkIJbTembBhOwFRSVRCNR3MZJy0XpZIms4cQB5NNRuHmaRV3zVvA+6KNaLEsN/gC+ywtECRLqvT6GikDMxUCWTokoX4TvI9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hSWw7+pA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x9wUFStH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hSWw7+pA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x9wUFStH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hSWw7+pA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x9wUFStH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hSWw7+pA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x9wUFStH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 019D933A27;
	Fri, 24 May 2024 10:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716546389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cst0lpLCKeUOXJy5RfbmatmpaHhsUx8Kv9oyqv7TXXA=;
	b=hSWw7+pA168/443wCSXvZxpJ5LZLVBOlXCGSdD3I8VXGKtAvPeVFACaYF3YF1L47/Tl0oR
	XMmWtGHwRayep2gYZk3uF4NtPUT0vOapwScYSVac1P/ZXgBWzbec7e8cFU7yWuAeg+7hFC
	w0l+iwisEDzFqFb7+tBpeVf9o0UfcNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716546389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cst0lpLCKeUOXJy5RfbmatmpaHhsUx8Kv9oyqv7TXXA=;
	b=x9wUFStHTsPss42ckStJt+JuzE4tT7N8v5a64jUgRlyXAuk1QOoDnKS8LHtw2dYKjCNZOD
	PfKVjN2krbFV8WDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716546389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cst0lpLCKeUOXJy5RfbmatmpaHhsUx8Kv9oyqv7TXXA=;
	b=hSWw7+pA168/443wCSXvZxpJ5LZLVBOlXCGSdD3I8VXGKtAvPeVFACaYF3YF1L47/Tl0oR
	XMmWtGHwRayep2gYZk3uF4NtPUT0vOapwScYSVac1P/ZXgBWzbec7e8cFU7yWuAeg+7hFC
	w0l+iwisEDzFqFb7+tBpeVf9o0UfcNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716546389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cst0lpLCKeUOXJy5RfbmatmpaHhsUx8Kv9oyqv7TXXA=;
	b=x9wUFStHTsPss42ckStJt+JuzE4tT7N8v5a64jUgRlyXAuk1QOoDnKS8LHtw2dYKjCNZOD
	PfKVjN2krbFV8WDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D872413A6B;
	Fri, 24 May 2024 10:26:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ++f9M1RrUGZjCgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 24 May 2024 10:26:28 +0000
Message-ID: <a51b79db-c48c-4bd1-a32b-28c72e9edbb8@suse.de>
Date: Fri, 24 May 2024 12:26:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: core: Pass sdev to blk_mq_alloc_queue()
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 himanshu.madhani@oracle.com
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
 <20240524084829.2132555-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240524084829.2132555-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.56 / 50.00];
	BAYES_HAM(-2.27)[96.59%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -3.56
X-Spam-Flag: NO

On 5/24/24 10:48, John Garry wrote:
> When calling scsi_alloc_sdev() -> blk_mq_alloc_queue(), we don't pass
> the sdev as the queuedata, but rather manually set it afterwards. Just
> pass to blk_mq_alloc_queue() to have automatically set.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_scan.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 463ce6e23dc6..ec54d58fb6c0 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -334,7 +334,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	sdev->sg_reserved_size = INT_MAX;
>   
>   	scsi_init_limits(shost, &lim);
> -	q = blk_mq_alloc_queue(&sdev->host->tag_set, &lim, NULL);
> +	q = blk_mq_alloc_queue(&sdev->host->tag_set, &lim, sdev);
>   	if (IS_ERR(q)) {
>   		/* release fn is set up in scsi_sysfs_device_initialise, so
>   		 * have to free and put manually here */
> @@ -344,7 +344,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	}
>   	kref_get(&sdev->host->tagset_refcnt);
>   	sdev->request_queue = q;
> -	q->queuedata = sdev;
>   
>   	depth = sdev->host->cmd_per_lun ?: 1;
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

