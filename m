Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B99E1C1F19;
	Mon, 13 Jan 2025 07:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752255; cv=none; b=eBJjnsHONHiYTKqBcT5YeD8LE1O18MH3uUv/iRCQaQvWLgjGBYyLoBmS/zYyOKoHwTlzTDgB+IocDeGWqjeMbNh7taL9i/aIRzspR17QoXLtqeDwyNMfxV6qW94lhv85gmbNKpKJorFY9vtf5+iveJirlX74159vxmM73JYA6Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752255; c=relaxed/simple;
	bh=nDcpc9oM6esN7t9hpa/KGfM41l2YKmD+pzcrwZxKi/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXsJHbQGky+/KlDpPX/jNs1bDqMyx21vRLW+9+0usxHBE2UgMdzbnZO7x/MxypY4d4sD2GL6ujB5f2Y0u8NBKuc0TWzv2pr/mdEDuaoEcVqii0UqEj8I9MSaxuK0CvsuqyF4s3iD7mS54I91kq+Io27zuiRsNyl5C6Z4Fio1n1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V6bHI8M+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a3V0UARb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V6bHI8M+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a3V0UARb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V6bHI8M+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a3V0UARb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V6bHI8M+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a3V0UARb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE3151F365;
	Mon, 13 Jan 2025 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADtA9uZm1LVPpmdIJhQwcmDJ4C+ndrkV3SUBTvBLTww=;
	b=V6bHI8M+cWkkYDaQqFwCBgAVhNR+3W3TJrNYZ5pfp6wMALLYtI62MEs/7sInGtd89rXpJR
	EOALsWi6ip070qp4MxHVhrM5WHcqI8YUe0KNJv0f7vlmiXMjb0WNo7fYeXtm/HanIew+Dk
	TcISJQHrWyZjiAN4Lu2Fc/mEQOcZO6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752244;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADtA9uZm1LVPpmdIJhQwcmDJ4C+ndrkV3SUBTvBLTww=;
	b=a3V0UARbBOswwoSugDe+yFWydZ/49MU6blmqnHSVkdMdzOdk2Do8SrwaTWw3I/aAYVjPCJ
	pn0X7IQ6pkk+4FDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V6bHI8M+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=a3V0UARb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADtA9uZm1LVPpmdIJhQwcmDJ4C+ndrkV3SUBTvBLTww=;
	b=V6bHI8M+cWkkYDaQqFwCBgAVhNR+3W3TJrNYZ5pfp6wMALLYtI62MEs/7sInGtd89rXpJR
	EOALsWi6ip070qp4MxHVhrM5WHcqI8YUe0KNJv0f7vlmiXMjb0WNo7fYeXtm/HanIew+Dk
	TcISJQHrWyZjiAN4Lu2Fc/mEQOcZO6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752244;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADtA9uZm1LVPpmdIJhQwcmDJ4C+ndrkV3SUBTvBLTww=;
	b=a3V0UARbBOswwoSugDe+yFWydZ/49MU6blmqnHSVkdMdzOdk2Do8SrwaTWw3I/aAYVjPCJ
	pn0X7IQ6pkk+4FDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D345F13876;
	Mon, 13 Jan 2025 07:10:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aJljMXO8hGeTKgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:10:43 +0000
Message-ID: <c7e13336-d9d3-4d36-84af-922d17a3999d@suse.de>
Date: Mon, 13 Jan 2025 08:10:43 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/9] scsi: use block layer helpers to calculate num of
 queues
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev,
 GR-QLogic-Storage-Upstream@marvell.com
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
 <20250110-isolcpus-io-queues-v5-4-0e4f118680b0@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250110-isolcpus-io-queues-v5-4-0e4f118680b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE3151F365
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 1/10/25 17:26, Daniel Wagner wrote:
> Multiqueue devices should only allocate queues for the housekeeping CPUs
> when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
> disturbed with OS workload.
> 
> Use helpers which calculates the correct number of queues which should
> be used when isolcpus is used.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   drivers/scsi/megaraid/megaraid_sas_base.c | 15 +++++++++------
>   drivers/scsi/qla2xxx/qla_isr.c            | 10 +++++-----
>   drivers/scsi/smartpqi/smartpqi_init.c     |  5 ++---
>   3 files changed, 16 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
