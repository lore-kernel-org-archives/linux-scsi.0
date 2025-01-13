Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8201BD9FF;
	Mon, 13 Jan 2025 07:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736753080; cv=none; b=QtIVPiLaKg+HjjUbB+XVln1jF/Cl9afP/8+p17Gx51uazKvlzVgv8Cd0UjLmGPszi+jg3eMO5EkdqIz1xLzvdPpNE0F2nmotiwNhDbHt90ia78lbcImRWmeCUA5n85+p7zzkdHMqpFH4PFdSlpDnf1NqqiZscVUELUUdqbtLAAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736753080; c=relaxed/simple;
	bh=aS8V9FGN2lfKGKcqz2shdu/uBmdKY3Anm6BAujdAr/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HyjS8N2IAfWlZNeTALL0nGcvQQ+aXDQK5+tSQM1RIjL2XStfpqxW2/P5q8Gc9aROCRSz37mO93v8pxrPX/ktp+g4nqno7zEjlMAwEVtDQOuhNJesxPnUk3Ls5kwpIh6C/r7OVWFCO/xuTqOUS4WBm6FVeiLwKsnGnvOk41oy2ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j+vgPO3m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AkTMaSqT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j+vgPO3m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AkTMaSqT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j+vgPO3m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AkTMaSqT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j+vgPO3m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AkTMaSqT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 359AA1F381;
	Mon, 13 Jan 2025 07:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736753077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnfZg9j1x8q2YZgngnPcpJ8AvSw0jeapwElcDEV5W84=;
	b=j+vgPO3mm5LlOOT0hPo2ZDSf39Z3I1ScmYH07C9zDmLvJTI8rFEvE53ngtebG0dsltsBwK
	GuP8jNZ5HXkjYqwBIexE6WW133+iDFw/oenXFD6SfRAfFUiGs2THw2d+cqjElkP/Lx6z4h
	ZEXkrnALVsuKxEGjiagwLK8kbqAHZfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736753077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnfZg9j1x8q2YZgngnPcpJ8AvSw0jeapwElcDEV5W84=;
	b=AkTMaSqT0P7Dekm0vOtBeZTfcofRT2wWngoanFAa1vV6XN+4xm6ubfkxahfZL1mSBbCRSD
	4R/TFwTO7b3VCHBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j+vgPO3m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AkTMaSqT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736753077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnfZg9j1x8q2YZgngnPcpJ8AvSw0jeapwElcDEV5W84=;
	b=j+vgPO3mm5LlOOT0hPo2ZDSf39Z3I1ScmYH07C9zDmLvJTI8rFEvE53ngtebG0dsltsBwK
	GuP8jNZ5HXkjYqwBIexE6WW133+iDFw/oenXFD6SfRAfFUiGs2THw2d+cqjElkP/Lx6z4h
	ZEXkrnALVsuKxEGjiagwLK8kbqAHZfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736753077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xnfZg9j1x8q2YZgngnPcpJ8AvSw0jeapwElcDEV5W84=;
	b=AkTMaSqT0P7Dekm0vOtBeZTfcofRT2wWngoanFAa1vV6XN+4xm6ubfkxahfZL1mSBbCRSD
	4R/TFwTO7b3VCHBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B063513310;
	Mon, 13 Jan 2025 07:24:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WBkqJ7S/hGcpLgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:24:36 +0000
Message-ID: <d3f26d2e-8533-4cf9-a422-16a46a3981d3@suse.de>
Date: Mon, 13 Jan 2025 08:24:36 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] block: add a store_limit operations for sysfs
 entries
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, nbd@other.debian.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-5-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250108092520.1325324-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 359AA1F381
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:dkim,suse.de:mid,suse.de:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,lst.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 1/8/25 10:25, Christoph Hellwig wrote:
> De-duplicate the code for updating queue limits by adding a store_limit
> method that allows having common code handle the actual queue limits
> update.
> 
> Note that this is a pure refactoring patch and does not address the
> existing freeze vs limits lock order problem in the refactored code,
> which will be addressed next.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> ---
>   block/blk-sysfs.c | 128 ++++++++++++++++++++++------------------------
>   1 file changed, 61 insertions(+), 67 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
