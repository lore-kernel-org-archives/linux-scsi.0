Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3022E7BB5
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 08:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757318907; cv=none; b=nyChn8CpaKpWXoy2PcH9lE9fqzL1FztXyED/eRNBMoFpMzg+ODx4ueeRI+A4hqYOQV0Zd9YAtli9QfKQA0S8WAlzX0M/v2tt6WMjV+TmNGJdIVquvz/Xa8kLLU5tHblXGq60tR5vKCX8g7+C2LYpupY/vDPSMzkvpCGHwxZ38JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757318907; c=relaxed/simple;
	bh=KlHyUYEthoEgZlA0iprUby6nKsW0V9HUhNrJBRjYfQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7uwh1IigwvwiUA6P8r/zHoVoad3j43tsjmVMiSjVRoe0X1recQdQf4qUTdfbhQg1wPOCkTniyOyxfN1fWIN8CI6Pno7u1TXpwh/hozNT2ujCgsclF2fAMfvid2CTWAq+w1CtjhhihCRaAIQsssB2aQaW+QfNb28fKFm9vzTc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GSc58UFV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kNG/Qagk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GSc58UFV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kNG/Qagk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GSc58UFV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kNG/Qagk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GSc58UFV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kNG/Qagk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 957BF2469A;
	Mon,  8 Sep 2025 08:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757318903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P5pBTmM/PWEIVyWVzMdHvPVxxzNBx2FFCHDJuwaqU5A=;
	b=GSc58UFVTBVemNfSv3K5RRd2PbzAN1t15CH2bb7KVWiEeeiENr6cRFcCAQqbn5o565xSml
	LwGcz1HXhk1H8PK2as9YUrEruyMEeIbUJ9pKVQdXGfvGQVE+hhv3ZWUPPriicLER27R+bf
	aG76KqGkXc6sjkAC8ztLmVGJcAyDq+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757318903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P5pBTmM/PWEIVyWVzMdHvPVxxzNBx2FFCHDJuwaqU5A=;
	b=kNG/Qagkulgsx/JdfRBRA8EW5Q2Nvo4I/vaaSU+/Din8rY4KuLeDH+TrlFeI5l090nAv2d
	ZRyL8bhtpnWEl/BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GSc58UFV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kNG/Qagk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757318903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P5pBTmM/PWEIVyWVzMdHvPVxxzNBx2FFCHDJuwaqU5A=;
	b=GSc58UFVTBVemNfSv3K5RRd2PbzAN1t15CH2bb7KVWiEeeiENr6cRFcCAQqbn5o565xSml
	LwGcz1HXhk1H8PK2as9YUrEruyMEeIbUJ9pKVQdXGfvGQVE+hhv3ZWUPPriicLER27R+bf
	aG76KqGkXc6sjkAC8ztLmVGJcAyDq+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757318903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P5pBTmM/PWEIVyWVzMdHvPVxxzNBx2FFCHDJuwaqU5A=;
	b=kNG/Qagkulgsx/JdfRBRA8EW5Q2Nvo4I/vaaSU+/Din8rY4KuLeDH+TrlFeI5l090nAv2d
	ZRyL8bhtpnWEl/BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7692913946;
	Mon,  8 Sep 2025 08:08:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9fvsHPeOvmhXTwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 08 Sep 2025 08:08:23 +0000
Date: Mon, 8 Sep 2025 10:08:23 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev, 
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <6ba78d1d-19e9-41dc-bc91-3c9da537cabe@flourine.local>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
 <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
 <ff66801c-f261-411d-bbbf-b386e013d096@suse.de>
 <d11a0c60-1b75-49ec-a2f8-7df402c4adf2@flourine.local>
 <321277a3-7dcc-414b-a329-71acfb504e91@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <321277a3-7dcc-414b-a329-71acfb504e91@suse.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 957BF2469A
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL71uuc3g3e76oxfn4mu5aogan)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,flourine.local:mid,suse.de:dkim];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,flourine.local:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On Mon, Sep 08, 2025 at 09:51:34AM +0200, Hannes Reinecke wrote:
> Wouldn't it be better to call 'cpumask_zero' before 'cpumask_and'?

I don't think this is necessary, from the docs :

  cpumask_and - *dstp = *src1p & *src2p

cpumask_and call bitmap_and which is:

static __always_inline
bool bitmap_and(unsigned long *dst, const unsigned long *src1,
		const unsigned long *src2, unsigned int nbits)
{
	if (small_const_nbits(nbits))
		return (*dst = *src1 & *src2 & BITMAP_LAST_WORD_MASK(nbits)) != 0;
	return __bitmap_and(dst, src1, src2, nbits);
}
