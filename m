Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0D221274
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 07:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170849; cv=none; b=HWiJ6H9vGNEolO8RV6XiYxrasJCITGVe6NgrmmYwFhMggGJyDsFt29Jl9cF+Q8/JapwfAiu2yDl6wswfIGbqwh6m0zzvJiIlGc88bNfCU6UGxdqGYIWcgq9+lS+tJxlkGYzFHBf5NzUaDo7NYUKMwtUhFV1ZiVa7aH15uUTSmuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170849; c=relaxed/simple;
	bh=U/Mf7a8LVOInmzb1SADCnkSFTvUDImYBPNOEHch0enU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVBU/MTD3/kJC/2gh+wA+PyQ7bHJaCw8KTf050psSYZjsfbT4L+4dYFOb9te3TsvXxsMgJeFMF8g2i/shVmeMxrqdvctAcqaNCyyuLbyPqRl7aOGwo26Ga9cQT6vJxmZeBVUir6RbeC+vTW3Guu90cef2vMy34tbUnPn7ynY4xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tHVANqYJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8JzfdG0L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tHVANqYJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8JzfdG0L; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tHVANqYJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8JzfdG0L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tHVANqYJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8JzfdG0L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F32521227;
	Fri,  2 May 2025 07:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LehNLP4aFKmfjVjCiNiTfCnWhQDbiMcpDTK9kdHJbjk=;
	b=tHVANqYJETA7GUpEs2jpEDPM9ZO/6V3WIzvAN4zW1QxtovWUEPMguJpgpSH/GgMm7ggGMe
	xrRStzbWr+VrqgaPfiifZjJyNSBjCLpPuaiPsYzuw8VI2oYVUhEy9qOm9Hnwk7Xu+4rMOT
	XYfDlWTd5NN78huMKbvx9neQl0RCRCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LehNLP4aFKmfjVjCiNiTfCnWhQDbiMcpDTK9kdHJbjk=;
	b=8JzfdG0Lpo6m+sGRQ7ct01A9bGw0u6ofmVzYnEPiI2GooRvK5h7agKHm0j05gsACRO9f3x
	gpBPCuNPhemcFQBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LehNLP4aFKmfjVjCiNiTfCnWhQDbiMcpDTK9kdHJbjk=;
	b=tHVANqYJETA7GUpEs2jpEDPM9ZO/6V3WIzvAN4zW1QxtovWUEPMguJpgpSH/GgMm7ggGMe
	xrRStzbWr+VrqgaPfiifZjJyNSBjCLpPuaiPsYzuw8VI2oYVUhEy9qOm9Hnwk7Xu+4rMOT
	XYfDlWTd5NN78huMKbvx9neQl0RCRCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LehNLP4aFKmfjVjCiNiTfCnWhQDbiMcpDTK9kdHJbjk=;
	b=8JzfdG0Lpo6m+sGRQ7ct01A9bGw0u6ofmVzYnEPiI2GooRvK5h7agKHm0j05gsACRO9f3x
	gpBPCuNPhemcFQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23F0813687;
	Fri,  2 May 2025 07:27:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZhCgBd1zFGjHOAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 May 2025 07:27:25 +0000
Message-ID: <0a76977f-aa17-4aa6-93f4-c0b02ce1b137@suse.de>
Date: Fri, 2 May 2025 09:27:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] block: remove bounce buffering support
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-7-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250502064930.2981820-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 5/2/25 08:49, Christoph Hellwig wrote:
> The block layer bounce buffering support is unused now, remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/mips/configs/gcw0_defconfig  |   1 -
>   block/Makefile                    |   1 -
>   block/blk-map.c                   |   5 +-
>   block/blk-mq.c                    |   2 -
>   block/blk-settings.c              |   5 -
>   block/blk.h                       |  17 --
>   block/bounce.c                    | 267 ------------------------------
>   include/linux/blk_types.h         |   1 -
>   include/linux/blkdev.h            |   5 +-
>   include/trace/events/block.h      |  15 --
>   include/uapi/linux/blktrace_api.h |   2 +-
>   kernel/trace/blktrace.c           |   9 -
>   12 files changed, 3 insertions(+), 327 deletions(-)
>   delete mode 100644 block/bounce.c
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
