Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F5C30F943;
	Wed, 10 Sep 2025 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757492431; cv=none; b=h6jaDzo8mYj90erAtclnX/ZLVAfohHCfer4hTCAbgCwhbG1DopOxJJdFIeyLAd3jSQ1r8iJ48eJd+h5Wrr4SUucN8xeLFDtITvk99vCaDnEG0xS7xsMue83mkh5ZtCzoTVLEpIvWyqx8beUO/HEn3f6vCkdRbLm3oarOLdTk0v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757492431; c=relaxed/simple;
	bh=1uPEjYWxkLIek3T+4iAvG+2at77ecF4QIzsgSji0HkY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=n082HXAmoCfwtEO9k0iyQEvnf+8TZC6A6n634VBi2R4Aqlb1XHLVxby1r1vkNLRKeb6eXC5KhHY/qO+NYMXobKo/vO4cGTo3ZzYWHGlE5Iw7c3xAS8uxs2zdOXc5ihc4asyo1YGFLaRfwu1TRlNcd9VW6RiDypU76Wc1r1DHUWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mNNqA8px; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UOasHq1u; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mNNqA8px";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UOasHq1u"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1757492427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+CP7a9wws54uQZjmYM4sfmOi5aU+3bjgiGZVeJJmASM=;
	b=mNNqA8pxV739WOsKJHgEtTJOMzX94iX97K4Ca48VKToBLBDsOAuPRpnAviQ4cvMU6C0Bk7
	A5mfIda9JkS3gxSPqX4A+hpyJFgpGHWTOOfmtQ1HAe/wSFGkeSscPc9fAM+Jfxb59IH/1I
	0k0n5GyOhU6D34bkPuFoMEaCL7l9A95WcVb0RR++NMWymRaP241u2PPYxunvC6aJm4vHUH
	43q626KUuKnVAHYivEM6NNaQuk/ZUwrMjLOg4MQTbqZIE8CpvaFQ6G6f6wB1RBE188f9vN
	aeFANjWsi6tymtcat1kCVAgA1TyopPhL3jM96rdJctbl2DdhndatVkQKFYxAMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1757492427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+CP7a9wws54uQZjmYM4sfmOi5aU+3bjgiGZVeJJmASM=;
	b=UOasHq1uYa5lt0uQ97FDdS3UHchNqSx7ZJpnsh0V4afb/TZLgNqSAON8pWEePxp1gYSODg
	Qy/0se5U0TRUFnCw==
To: Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>, Aaron Tomlin
 <atomlin@atomlin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Waiman
 Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, Frederic
 Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev,
 GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v8 10/12] blk-mq: use hk cpus only when
 isolcpus=io_queue is enabled
In-Reply-To: <d11a0c60-1b75-49ec-a2f8-7df402c4adf2@flourine.local>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
 <20250905-isolcpus-io-queues-v8-10-885984c5daca@kernel.org>
 <ff66801c-f261-411d-bbbf-b386e013d096@suse.de>
 <d11a0c60-1b75-49ec-a2f8-7df402c4adf2@flourine.local>
Date: Wed, 10 Sep 2025 10:20:26 +0200
Message-ID: <87ms72u3at.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Sep 08 2025 at 09:26, Daniel Wagner wrote:
> On Mon, Sep 08, 2025 at 08:13:31AM +0200, Hannes Reinecke wrote:
>> >   const struct cpumask *blk_mq_online_queue_affinity(void)
>> >   {
>> > +	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
>> > +		cpumask_and(&blk_hk_online_mask, cpu_online_mask,
>> > +			    housekeeping_cpumask(HK_TYPE_IO_QUEUE));
>> > +		return &blk_hk_online_mask;
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

Sure,  but none of this is serialized against CPU hotplug operations. So
the resulting mask, which is handed into the spreading code can be
concurrently modified. IOW it's not as const as the code claims.

How is this even remotely correct?

Thanks,

        tglx
