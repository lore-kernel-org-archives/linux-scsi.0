Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4A82309BE
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 06:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757311576; cv=none; b=tt8fExz9iDGEQrSvrhf8bUhGs0RzfzKY3ZfCYDqd+3won/hiTcx/ygpC4TQ5VrBAQTk4roj8ajl2AE7hm0OtQJeN57UyichmcT7CH9Hv4shLZX1qJuU9lb9UjZcJ4NLoDrOPm0Hxj/mgrFemRjbRtazulbg00tKxZowVM/tEpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757311576; c=relaxed/simple;
	bh=MNMoO5ZSxMijP7k+fy9/RMrnO7AfGEmLlYWp2adgo4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ts4VuvWs3mg95Iep3BX6QM47AqF2n8MNG6RaVcKuw2A59gDOBrFAnw1O8inQ98t/vQfwh+38axvCgwi1Vf8kpBXY3lNrA60u4OEGpIJC1bpR+hG9erAIs0E1/DSX2V4f6WwpFmfuSLrWfGGT9M2yVBOq9dBAp9Je9PamdVwph8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VTTm5WU3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1apyA0jq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GZ2SbxOq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4HvCLfSc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VTTm5WU3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1apyA0jq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GZ2SbxOq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4HvCLfSc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF40F25D0F;
	Mon,  8 Sep 2025 06:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757311566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33zHN0Ci2nsYAA6yJPzugyK4uZYR8sPBN6+QhEOeME8=;
	b=VTTm5WU3gsVyWRU3QktGMLV/6wNuTlC1GvT11zmDJzV7/10JaU3gJN9oGS7GB8KBT+dpGE
	56mNP8wZI2ZadrUFtyNlxzQmk7l2dLItE2Rw6TbXEYpqj/cRVsGVdvDNaHgM3+i9d3MxpW
	m3VwxdFJbxGTRl1sWS0PSWYTWWZ1S0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757311566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33zHN0Ci2nsYAA6yJPzugyK4uZYR8sPBN6+QhEOeME8=;
	b=1apyA0jqX6EwDS5uRd6bE48pTBzQ3FGvNFkOm6J5aco914Br93cxhN9D1G1A+iNMb+SqK5
	U8h9sxulmcNDl5Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GZ2SbxOq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4HvCLfSc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757311565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33zHN0Ci2nsYAA6yJPzugyK4uZYR8sPBN6+QhEOeME8=;
	b=GZ2SbxOqRya+/f66Rdwoc0nc6Gz++0tmpkhcQZJK9vGquUwVgfq6ZpZQjsuPmU84U6B8/1
	RdX/7/vEtdd9n77a9ypbLiIgt+W7lZS4qRukvNrYHExqhaH6VP/pOtcQhLhU5YX7OlwWxa
	wC3uEpS4iTupAIB2cpAHXiuGSUIDUfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757311565;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33zHN0Ci2nsYAA6yJPzugyK4uZYR8sPBN6+QhEOeME8=;
	b=4HvCLfScqdpJvmaTSMixKtHACubY9c8sezJNuwyHjtTwciLeYslu9lj3jGbPWpM82DGgsU
	o2hBkBriWApNJiDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10C2013946;
	Mon,  8 Sep 2025 06:06:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3mn3AE1yvmhSLAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 08 Sep 2025 06:06:05 +0000
Message-ID: <8f493741-5e39-4a09-ac3a-0bf22479e88f@suse.de>
Date: Mon, 8 Sep 2025 08:06:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 01/12] scsi: aacraid: use block layer helpers to
 calculate num of queues
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, storagedev@microchip.com,
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
 <20250905-isolcpus-io-queues-v8-1-885984c5daca@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250905-isolcpus-io-queues-v8-1-885984c5daca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: CF40F25D0F
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 9/5/25 16:59, Daniel Wagner wrote:
> The calculation of the upper limit for queues does not depend solely on
> the number of online CPUs; for example, the isolcpus kernel
> command-line option must also be considered.
> 
> To account for this, the block layer provides a helper function to
> retrieve the maximum number of queues. Use it to set an appropriate
> upper queue number limit.
> 
> Fixes: 94970cfb5f10 ("scsi: use block layer helpers to calculate num of queues")
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   drivers/scsi/aacraid/comminit.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
