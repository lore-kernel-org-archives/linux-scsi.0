Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0641522094;
	Sun,  4 Feb 2024 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049869; cv=none; b=rEK2xpvbaHXcrBn8/E2Jn6mNgYWu0GPNRgRM67FmnnrOLPyDINMtSb5Yww9qOSEqRQhFIiOjSugcV0qipa1RMjSN4xY0cTNeeIVD0Q9D+9gc7BwXnSNk5JA3F4gbgOu4OOikopf1SYWUj+3fFjlt2rzAbPBc6/sHwq9RTH5WJeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049869; c=relaxed/simple;
	bh=SQl/OFIvzhjP69EhNNrf2xtxbKs0STTXpnRZO8t7q+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lx72NxUZIzmWkKoIeKE94eARwzbpKfPREeSkyreJ6OGy3FQYPsLg0Z0W2SBNTTcFlBftRZxwWiHpEuBtUiDDkDiPiWYCvdmlMmns0CNxPcqErC0lIyIcszcxlNpmapArjBUfz/pq0yU5nD8tvuKe6iHoqe9XRi41MboTSXB00/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hWKidjWB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=okqN9Uw8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hWKidjWB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=okqN9Uw8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hWKidjWB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="okqN9Uw8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hWKidjWB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="okqN9Uw8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 511082200A;
	Sun,  4 Feb 2024 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXu6gY1Y4HqvDAmyXH1Sl8R6EBE5ipkDFJe+SYdcW+g=;
	b=hWKidjWBVo3SuB3D4X8bZdOW/fFHG7WiKzGk0E1wFyMl5IfBYQkFy6As0IuY3cvOxyoGCZ
	hKoiwOjq1owe7FY44MQ7ADBg7mtfYgVqQNjy0eEAU5sOf3qMeHbmgLfoce2OpTjmGZYn9N
	1LpPw88Ed235C+pEZfYkq9myxT4BSd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXu6gY1Y4HqvDAmyXH1Sl8R6EBE5ipkDFJe+SYdcW+g=;
	b=okqN9Uw8GUoveabN0kaMNIdxzydE+U0qznRHyBrYpTXN5pKIBdlnd9dvq4vJ+gbkV6bySs
	XfptYEIBaQnBAnAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXu6gY1Y4HqvDAmyXH1Sl8R6EBE5ipkDFJe+SYdcW+g=;
	b=hWKidjWBVo3SuB3D4X8bZdOW/fFHG7WiKzGk0E1wFyMl5IfBYQkFy6As0IuY3cvOxyoGCZ
	hKoiwOjq1owe7FY44MQ7ADBg7mtfYgVqQNjy0eEAU5sOf3qMeHbmgLfoce2OpTjmGZYn9N
	1LpPw88Ed235C+pEZfYkq9myxT4BSd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXu6gY1Y4HqvDAmyXH1Sl8R6EBE5ipkDFJe+SYdcW+g=;
	b=okqN9Uw8GUoveabN0kaMNIdxzydE+U0qznRHyBrYpTXN5pKIBdlnd9dvq4vJ+gbkV6bySs
	XfptYEIBaQnBAnAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3356B132DD;
	Sun,  4 Feb 2024 12:31:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sLb1IIaDv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:31:02 +0000
Message-ID: <446f4bd8-66ba-47b5-b767-9e7cfa8f5a2a@suse.de>
Date: Sun, 4 Feb 2024 20:31:02 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/26] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE
 elevator feature
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-13-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-0.93 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.84)[85.24%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -0.93

On 2/2/24 15:30, Damien Le Moal wrote:
> With zone write plugging enabled at the block layer level, any zone
> device can only ever see at most a single write operation per zone.
> There is thus no need to request a block scheduler with strick per-zone
> sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
> feature. Removing this allows using a zoned ublk device with any
> scheduler, including "none".
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/ublk_drv.c | 2 --
>   1 file changed, 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

