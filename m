Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71A7224237
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170672; cv=none; b=TNRjx2FUuLYKUmOhKPFXV2JNwD4Ts6iulJsJlVhhoUGlOgn0Ep0FYc22/MdZe7hAXd+SHJ+bS1o7+sOYALs+uBbPjSVu8xIxnP9sC9247d4VzKpPlC+KfOlOCI5YsUDqzrb4QOCQqr6OlIkVDqkaBPGRuaxKqhz2mkVB2sdLKe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170672; c=relaxed/simple;
	bh=4vp54kL6Yeyy+PGNKi7WYsUmqXlBmChy1Qa4Yb5AxxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FMuNqDiI4mRU7oZDQ4BUAKzwi/M5hg0ZVXsDUz+PMVFH/ys41iMQDfjyguq9kMbkKSZZpa4yvEx/vzcdSobONDWyfVIlFlK5pY7QOiA/55XLvaXoXwri54MqslIESSd7P1Fx7mvV8tKhVdg762hlksHOKNT+i6Ixfi4fHbalviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ryTAgF3s; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HFYEGdGH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A+KpCrTJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TCof81vc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ryTAgF3s";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HFYEGdGH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A+KpCrTJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TCof81vc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B54241F385;
	Fri,  2 May 2025 07:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Jpy3kA3EvG8tXSvkK0WCSKL/K4KU0ioXSifsdCwPYQ=;
	b=ryTAgF3sJXGLcexWW+0FRLjGuz1Xydw/0zDtpNQkQJj/5XujRYv6x5g+Q+8PZdiKKs3/nV
	CQpuUXItWXtzgdG3Fc3LquD0ShZmgtLOWr3GMv6CGRr6yXsgHVd/GD3XYPubiM82HaIGb9
	SmUkW/SrfjAIlZX9p4M5+t3TsaK7IbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Jpy3kA3EvG8tXSvkK0WCSKL/K4KU0ioXSifsdCwPYQ=;
	b=HFYEGdGHKRUUCiWNHYC7PEb7OslyfcZrefvrgngiC/aArM0990IiM/JcEYgQhH91b3ZuYg
	8CXdIiqbnbwJdLBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A+KpCrTJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TCof81vc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1746170668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Jpy3kA3EvG8tXSvkK0WCSKL/K4KU0ioXSifsdCwPYQ=;
	b=A+KpCrTJCRPdMiczSTim4Zy+HHYQLht2rJUci2wGZmh4Frdn+rBdTMaVd/t143DcVBPzje
	uwkzSqvdiVS/jFecVJZWnBVGiOvRVjZp8CW4cZ4zFpqpiK/DiUfIfogCvU4sqOtoFIjhG5
	AwbNVT5ZRBUmmurYMldLd0cwrXnPaeA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1746170668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Jpy3kA3EvG8tXSvkK0WCSKL/K4KU0ioXSifsdCwPYQ=;
	b=TCof81vch6sNOtqOOLe4H6oldonXbvqlXWUyxbXFRd0QoqXgA5qINI7IWKjHImxIBqi4id
	j26RccRuFJOulEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B66B13687;
	Fri,  2 May 2025 07:24:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ffvQFCxzFGjwNwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 May 2025 07:24:28 +0000
Message-ID: <40b4c1a8-666c-44ef-9f8c-9865aef94f3f@suse.de>
Date: Fri, 2 May 2025 09:24:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: make aha152x depend on !HIGHMEM
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-2-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250502064930.2981820-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B54241F385
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 5/2/25 08:49, Christoph Hellwig wrote:
> This is one of the last drivers depending on the block layer bounce
> buffering code.  Restrict it to run on non-highmem configs so that the
> bounce buffering code can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/Kconfig   | 1 +
>   drivers/scsi/aha152x.c | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
