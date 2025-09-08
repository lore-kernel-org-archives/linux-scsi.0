Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796112E610F
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 07:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757317901; cv=none; b=uVUoJtHHRUJcLvUippm09RqKBlKM+WnROnWUpPu3iGPj1sL1FkTaoXDm0fCYNVVLXLtE0AWRnxZocfWTYtlRhBel+PBCvmAqV6fVjaNoqm6jVyyqe3593KZsLCz8E+dciClBZKPV72X2Tua4yPk2UkAv3IXpmfWK7IVqCyJNgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757317901; c=relaxed/simple;
	bh=VwNJ/alyWPPhb4xl75jIWHk5g3q3g2XfFMDmbt30rFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTz3bjGbaiB/6zKUGXPwyeH1D2avLGibIL1QC1UquLKJDuvI6Kpkb7YZ5qKqE+ZZsy7oQdcjUqn/EycR2EvzzULJCN7t+2kAefo41kLuPHlacRA4Z1RRYZDtQ5gpgecvZjGhi0HwA4R11ffwqrzcBp4Nc+ftrs2pfAJLs9XFGD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kNtJht6C; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=A7r/uwl3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kNtJht6C; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=A7r/uwl3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kNtJht6C";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="A7r/uwl3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kNtJht6C";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="A7r/uwl3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA70E262BF;
	Mon,  8 Sep 2025 07:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757317895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3lgjYIhMxc2rNa9ntweEdciObdY98eJjBvA14F4bCY=;
	b=kNtJht6CJd6ZG1MA54sZKN0h5Btylpre0CryoB5D2SI2yiA0jbn1EW2D6oyKii5JOubqX8
	n2l4gwMsP7Wj8hos5bxkVH40ZaB9NxWm5W1qlbeHVS1I7CbJLp4kcA39ejoZ1YCULrHYMk
	ZhaT1hsu2MqKHarc6TiiGg4QDXhfrow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757317895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3lgjYIhMxc2rNa9ntweEdciObdY98eJjBvA14F4bCY=;
	b=A7r/uwl33QPZeS79BcomeFRmGPUTuswMqiBwkdKg0RA5p7cmvYyan6LdBhB/5VlvZkxNT6
	bhGnXwyGja8i5ODg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kNtJht6C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="A7r/uwl3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757317895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3lgjYIhMxc2rNa9ntweEdciObdY98eJjBvA14F4bCY=;
	b=kNtJht6CJd6ZG1MA54sZKN0h5Btylpre0CryoB5D2SI2yiA0jbn1EW2D6oyKii5JOubqX8
	n2l4gwMsP7Wj8hos5bxkVH40ZaB9NxWm5W1qlbeHVS1I7CbJLp4kcA39ejoZ1YCULrHYMk
	ZhaT1hsu2MqKHarc6TiiGg4QDXhfrow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757317895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3lgjYIhMxc2rNa9ntweEdciObdY98eJjBvA14F4bCY=;
	b=A7r/uwl33QPZeS79BcomeFRmGPUTuswMqiBwkdKg0RA5p7cmvYyan6LdBhB/5VlvZkxNT6
	bhGnXwyGja8i5ODg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D3E813869;
	Mon,  8 Sep 2025 07:51:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hY6VBgeLvmi+SQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 08 Sep 2025 07:51:35 +0000
Message-ID: <321277a3-7dcc-414b-a329-71acfb504e91@suse.de>
Date: Mon, 8 Sep 2025 09:51:34 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/12] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
To: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
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
 <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
 <ff66801c-f261-411d-bbbf-b386e013d096@suse.de>
 <d11a0c60-1b75-49ec-a2f8-7df402c4adf2@flourine.local>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <d11a0c60-1b75-49ec-a2f8-7df402c4adf2@flourine.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: AA70E262BF
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLdd7zpc331qgmz6gw8s9zsqsb)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 9/8/25 09:26, Daniel Wagner wrote:
> On Mon, Sep 08, 2025 at 08:13:31AM +0200, Hannes Reinecke wrote:
>>>    const struct cpumask *blk_mq_online_queue_affinity(void)
>>>    {
>>> +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
>>> +		cpumask_and(&blk_hk_online_mask, cpu_online_mask,
>>> +			    housekeeping_cpumask(HK_TYPE_IO_QUEUE));
>>> +		return &blk_hk_online_mask;
>>
>> Can you explain the use of 'blk_hk_online_mask'?
>> Why is a static variable?
> 
> The blk_mq_*_queue_affinity helpers return a const struct cpumask *, the
> caller doesn't need to free the return value. Because cpumask_and needs
> store its result somewhere, I opted for the global static variable.
> 
>> To my untrained eye it's being recalculated every time one calls
>> this function. And only the first invocation run on an empty mask,
>> all subsequent ones see a populated mask.
> 
> The cpu_online_mask might change over time, it's not a static bitmap.
> Thus it's necessary to update the blk_hk_online_mask. Doing some sort of
> caching is certainly possible. Given that we have plenty of cpumask
> logic operation in the cpu_group_evenly code path later, I am not so
> sure this really makes a huge difference.

Oh, that's okay. I'm perfectly fine to update the cpumask on every call.
What makes me wonder is the initialisation of blk_hk_online_mask;
it's zeroed _at boot_, and then all we do is calling cpumask_and()
for every invocation. So the mask will only increase in scope,
and never decrease.

Wouldn't it be better to call 'cpumask_zero' before 'cpumask_and'?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
