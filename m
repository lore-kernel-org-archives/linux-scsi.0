Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4626C215191
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 07:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170817; cv=none; b=C8a6Xs+KRteySakSFFYOfcD0i1M6ilFuM1YC8Th3U96rcHBJ4xu7aqUMhi7g2pQ/a6tVMpNH8Z2sOJ1A9WebP54/voGwok0xvdpe8HY3FMb0Eb5VAtbWtO8xi3XuNw6EtNs1lkKOf3kt/08QZnHASGA7ktCmbmquA7O6w85/XUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170817; c=relaxed/simple;
	bh=foCNjkjNiPAQiqFLR2hIBLVxWwkV0EBU2fQr5rcUGoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EaqAAYTG54BokwRrcwWUKzLrO++0pzzM9+srx6qb36WcVXYIB3BE5BctDHM4JWus4xCoDMhx4Sy9X11TWE5j+hL9akzsMLynhLv9jS376n+iHVQH7gKk54yq7DGSCQHT0XFdvFgU3zQqGW82nFI2j/manu7aGR1LfzsLCAlzyWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fYwT1eJ6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=De8RyRAG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fYwT1eJ6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=De8RyRAG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fYwT1eJ6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="De8RyRAG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fYwT1eJ6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="De8RyRAG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D88F2122E;
	Fri,  2 May 2025 07:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7JIh4OfU/57KUr5ma/2EzLGzU/zF05n+rTJTo7uAa8=;
	b=fYwT1eJ6/zJQkd7r2JXEcFmDg+DOAoBAPquufQ3xQ68RZ61Um8PUa9emRWpeKO9id+YmF7
	6pG83799yjcMeaezoV0VI8lsXXPOnpbK8LoaC9z4DoPbEbO6XdP8KhsdVwSgOO/HpLQVU2
	SEdLEkKVTslMblQhqDQH86KSyeSovqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7JIh4OfU/57KUr5ma/2EzLGzU/zF05n+rTJTo7uAa8=;
	b=De8RyRAGVaZkRwv2v0VOPgndfRrTPZQyriyjqUZ4MDYOyJNjRYNB6EqaEGFG1JCulpXx+m
	EuBYUgEpFYuptgDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYwT1eJ6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=De8RyRAG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7JIh4OfU/57KUr5ma/2EzLGzU/zF05n+rTJTo7uAa8=;
	b=fYwT1eJ6/zJQkd7r2JXEcFmDg+DOAoBAPquufQ3xQ68RZ61Um8PUa9emRWpeKO9id+YmF7
	6pG83799yjcMeaezoV0VI8lsXXPOnpbK8LoaC9z4DoPbEbO6XdP8KhsdVwSgOO/HpLQVU2
	SEdLEkKVTslMblQhqDQH86KSyeSovqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7JIh4OfU/57KUr5ma/2EzLGzU/zF05n+rTJTo7uAa8=;
	b=De8RyRAGVaZkRwv2v0VOPgndfRrTPZQyriyjqUZ4MDYOyJNjRYNB6EqaEGFG1JCulpXx+m
	EuBYUgEpFYuptgDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB57B13687;
	Fri,  2 May 2025 07:26:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YoLhL71zFGiqOAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 May 2025 07:26:53 +0000
Message-ID: <85125f21-0021-47f3-9136-d3367f89ddae@suse.de>
Date: Fri, 2 May 2025 09:26:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: remove the no_highmem flag in the host
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-6-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250502064930.2981820-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D88F2122E
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 5/2/25 08:49, Christoph Hellwig wrote:
> All users are gone now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c  | 3 ---
>   include/scsi/scsi_host.h | 2 --
>   2 files changed, 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
