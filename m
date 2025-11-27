Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ECD2F9D82
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764266635; cv=none; b=DO+fmaKxDdGxXtjgix7Ftd0tr1CrmNAziC4WNf9Z25n1GJnuayFbG+lqUSg+RE3B4w0XH2kvV5wneKCltfl2qisUInSRKcc6gVjFOT+u95BVQm+Qw2QGes7EsXf/eAwyFyLk8KEWuBTVIMmK55Yg8paw77oAl+WMa7L6n/ODvQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764266635; c=relaxed/simple;
	bh=vkUHQROeX/mQl2Wj/R4EOZpNwjo0OQ7Z5Rt0f0IXsYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEVqIJIbDxG8YeAL61sufCNXOIE1DrE7Kt2luSyqT6WPvTUN50K46QYWurTFErSwpIH2vCKaKGOZhuLqdxJBXvjlIpkIegAtok83quHvMo1MZtIVeylPqvcxrNjxeh2VfJy71QqxFX6kxqj4QwAbDChZi8EgxRl3HYJV+3uStaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mQi2lsqh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JImYMuvY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZJg3kSoC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fUi6AXHs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mQi2lsqh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JImYMuvY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZJg3kSoC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fUi6AXHs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E9A23336A4;
	Thu, 27 Nov 2025 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764266632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXwOJqPQn7tI1KgWPuA2BrBC2jrBW1HxngC1Xi1a91I=;
	b=mQi2lsqh49h6oESXXOAmMchwCcvTGOaqPhGefxY1VXOWHqV3ZOa7ZPoz++rgeEU8nweFqY
	Ohzo1aFNxFthLYyB/ZiisFZvL8Xetd9WG2IFscr9YA4qcszHc42Dh32b+Ru1VjK57dN3eb
	aHqu1uKKfrjhNVitLqbJf118D08xfYY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764266632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXwOJqPQn7tI1KgWPuA2BrBC2jrBW1HxngC1Xi1a91I=;
	b=JImYMuvYdKON4oiSf/wJxQ6gUJ34OLb5icpD9AekipxqnZyMqM+Hld71rnwAToJJgzBxsz
	thk5AALAGdXLtcDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764266631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXwOJqPQn7tI1KgWPuA2BrBC2jrBW1HxngC1Xi1a91I=;
	b=ZJg3kSoCn20Hr4CNrS49ssji512WmJLHCX/RuUJWGL4JjpWqKqjoDDTZBYGSCNBz539QKY
	4dhcd5lhU3u5BAFGTAgBrdWYNWXliOqUvwZPLZEKHhxCs8Bjhje9+2lltHoKxNotjS6cMR
	NywImEGgiEv75/Er6HYPI0ZNvDrzKHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764266631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXwOJqPQn7tI1KgWPuA2BrBC2jrBW1HxngC1Xi1a91I=;
	b=fUi6AXHsPl8Gf5n9ra0dzrJz5N3bY89LF/LDJ5umaV3nbGJRPOVGSa9MnGQKnZ+vnGdlh8
	Ppl9VkI5IPTuXVDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81C593EA63;
	Thu, 27 Nov 2025 18:03:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RH4QHoeSKGnhXgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 18:03:51 +0000
Message-ID: <4eb8b77a-6553-42ec-ab85-a1cddb7d8f23@suse.de>
Date: Thu, 27 Nov 2025 19:03:51 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] scsi: sd: reject invalid pr_read_keys() num_keys
 values
To: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Christoph Hellwig <hch@lst.de>, Mike Christie <michael.christie@oracle.com>,
 linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
References: <20251127155424.617569-1-stefanha@redhat.com>
 <20251127155424.617569-2-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251127155424.617569-2-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 11/27/25 16:54, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The SCSI
> PERSISTENT RESERVE IN command has a maximum READ KEYS service action
> size of 65536 bytes. Reject num_keys values that are too large to fit
> into the SCSI command.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   drivers/scsi/sd.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
