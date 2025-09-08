Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4357021B19D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 06:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757311613; cv=none; b=tEz2LvIB/CKNBqKGywoDsIRtiQkMPAOeh9jjU9IlNf+5YqdddRTYJ/ZhpSfvEHHAHKYVjR0UHdaPvQOyATUr2uPYvZBsD37dPesKilPZns6sP61zn8jWyx4Uo+w0ImoZkIPI6f/Zruu6va09cA+f01XG6vyBKoz2zxo7A6FHamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757311613; c=relaxed/simple;
	bh=4MBhLQwKwWvDnH9b2XLB+qVPuq4edSgcvTrSLF6vp70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kd0o9JBjdSmPtazURr5uHNw/JUnvO2MJRWvzRMc/32FMC/cUiJBOEUsWne7jGeWuRvQBMIMrYhc8VzFSthRzaQ8v2/iPJZ8ip6uQaqFZl7rENpj81k7ZfO4S3crgAWGpr+MFJ2YxAUQB/1OmxFZb//DyCuU6jP00d/M6U+i6SCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U2nxfJLQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UwVN+qvH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U2nxfJLQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UwVN+qvH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U2nxfJLQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UwVN+qvH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U2nxfJLQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UwVN+qvH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8150524328;
	Mon,  8 Sep 2025 06:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757311610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xFZzfJXoXxPwgoa0qHx2eeXGF4g7NvJ/1E2n07w1X4=;
	b=U2nxfJLQ+eBJeeyIVteejGeIRSD+hutyE4HvUwlAHQ8lbohLK3gmZWmo0/TpPy49felGSD
	jJKim2HnUTPfL8EZMtgUoKKlEWhQbf1UBt/lIe05vYAaRXqdbWAckFpOamPIlhQzAgZNBC
	zPE913uXBTibfQEZ/UkTVqddI9PPQQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757311610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xFZzfJXoXxPwgoa0qHx2eeXGF4g7NvJ/1E2n07w1X4=;
	b=UwVN+qvH6DHTEkB2t6ab2MSXQpXY+mlTTNyb08CmcpuYR/HGxnaxFLjrsttfVymBkPbRMb
	+enSp0TUaU+1+wCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757311610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xFZzfJXoXxPwgoa0qHx2eeXGF4g7NvJ/1E2n07w1X4=;
	b=U2nxfJLQ+eBJeeyIVteejGeIRSD+hutyE4HvUwlAHQ8lbohLK3gmZWmo0/TpPy49felGSD
	jJKim2HnUTPfL8EZMtgUoKKlEWhQbf1UBt/lIe05vYAaRXqdbWAckFpOamPIlhQzAgZNBC
	zPE913uXBTibfQEZ/UkTVqddI9PPQQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757311610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xFZzfJXoXxPwgoa0qHx2eeXGF4g7NvJ/1E2n07w1X4=;
	b=UwVN+qvH6DHTEkB2t6ab2MSXQpXY+mlTTNyb08CmcpuYR/HGxnaxFLjrsttfVymBkPbRMb
	+enSp0TUaU+1+wCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79EE013946;
	Mon,  8 Sep 2025 06:06:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gwBSHHlyvmiILAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 08 Sep 2025 06:06:49 +0000
Message-ID: <69c22d3c-fe8d-4693-85e2-6d058556eeea@suse.de>
Date: Mon, 8 Sep 2025 08:06:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/12] lib/group_cpus: remove dead !SMP code
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
 <20250905-isolcpus-io-queues-v8-2-885984c5daca@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250905-isolcpus-io-queues-v8-2-885984c5daca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.28 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.18)[-0.903];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[25];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.28

On 9/5/25 16:59, Daniel Wagner wrote:
> The support for the !SMP configuration has been removed from the core by
> commit cac5cefbade9 ("sched/smp: Make SMP unconditional").
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   lib/group_cpus.c | 20 --------------------
>   1 file changed, 20 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
