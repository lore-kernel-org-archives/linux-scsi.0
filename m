Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C332F0689
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764266687; cv=none; b=qBc1QGtVZ2NUF/Cib6cfWSxQ4k2erua9frq7FRTkynitCsMz69samLFoUuTyEEBP2f40qdVrAdfzqQS7c1HL2tpLg1/fQ459yrZgPQP9i/utVSytVrLXeVh7MeOC7cKfNdRnDg81n8gz1ZFt5LUQ0NiriilHHgXH4Om8a5qsDIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764266687; c=relaxed/simple;
	bh=Q5m9Rg7X+gTa1EqvJjkLkG0J4LPmpAD2f3XFaMHnOJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mEoiMto1QqgKw601doT2tD2xcM3th6GLD7js2srxE6f+pG5uZPIYD/e8zhh8kqa5ug6qx2SW8lESSKalnQ4m33qBoBpyVbMrDE0a6rJ8lCAen7gdXbt5Q4dGVBBG/lRyo9gToiiuAtbWRz3g9auq25b11USDwtB+7EpwQ/TEJpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vXbVKTlC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xvq9ax3j; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mY6fs0zl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xb7ggsTG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vXbVKTlC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xvq9ax3j";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mY6fs0zl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xb7ggsTG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3B1B05BCD1;
	Thu, 27 Nov 2025 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764266684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrVsWQvex/RQgwIgu4ehjepQn/x496uMZqhNRNqpUPo=;
	b=vXbVKTlCacXhBu7F2ytOj/2lBybiCANUMgsDD0HROYFHHenFyYS5JTuZxueIIcMqADo8Ex
	p8AVjaBLNKZ6+JFrHgrBcLWBVIM7s9dYldMKEgTo1Gjw+U9e/F+Xc97JBhx8IXYRAiqRJq
	LL4Tpc+//HCFiaHhJv5gqYrD0VRfVrc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764266684;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrVsWQvex/RQgwIgu4ehjepQn/x496uMZqhNRNqpUPo=;
	b=xvq9ax3jNpISVzlywrjDbV9MJv4PDcQvvyYogvnnTzRYouAqDXwQSPgrwQRwHWcGyQY4LK
	P5K6mZjePP/aGUDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mY6fs0zl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Xb7ggsTG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764266683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrVsWQvex/RQgwIgu4ehjepQn/x496uMZqhNRNqpUPo=;
	b=mY6fs0zlXPu0wSk/NrVdihuBZYQ9EZvkrjI0RrUFg1o/3QBONYlJUCjb1BeIY2rwQtwZeT
	nZTsvbvpaxNBIVs4I4K2EQE6j4mJwSpr5uGZdlq9sw1QIobABqUzDL4wQNzKxoih6Qrgve
	WkdjndsS7cZEOZ3NKxlAP8txQ9j6aCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764266683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrVsWQvex/RQgwIgu4ehjepQn/x496uMZqhNRNqpUPo=;
	b=Xb7ggsTG0oaDn75vqt8RM2xc1q+B8ahv/LO3G8opieTezUFRBQxFGmO05cRQGOQrSYolOh
	V1eyW/tDfUrkuiAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3AC83EA63;
	Thu, 27 Nov 2025 18:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VjnFLbqSKGmfXwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 27 Nov 2025 18:04:42 +0000
Message-ID: <bd803f19-1ed0-40e5-a010-95ddbbe49aaf@suse.de>
Date: Thu, 27 Nov 2025 19:04:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
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
 <20251127155424.617569-3-stefanha@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251127155424.617569-3-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3B1B05BCD1

On 11/27/25 16:54, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
> Reservation Report command has a u32 maximum length. Reject num_keys
> values that are too large to fit.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   drivers/nvme/host/pr.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
