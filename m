Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46A1189
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 12:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755518867; cv=none; b=YNf8+WMH2hEy2FKNsz3TZPAnD/FOsRrVYJucWzfKgBnq0OQS30WUDnk3NlvIPWUWqZzd078idsQBOp1W6ggtELd7eXvQKiZh+ZDO9tU1IbgQi7A5zeREGjpcAS9tG0Eil4glQ1phneaICxJQlzCELyv6wczdQQG8amMNz97JFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755518867; c=relaxed/simple;
	bh=8l1Aw0U0Ymcu4f5mdSIaHGAepgqHfDSYZw8Q5F0p3Dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TIde3nhyAOwm8xnUeVZ07caJJ8fLgrT5Xhv/mF+FkQQFsktsxX681/WE+ZjKo+qCQ36ti/U7JDBhjBNHTv7nlt8Jn19YBOWh8Zzi0we9J8EeZruj7bf2phAwNvjHN4t5/Q9MawGFgdB3yCN7OoNCTMloaU5a8lqKSgP1zg4GLo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qq78L8GF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5PtA/5DN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nRX1SK21; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zLJ8Vru9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qq78L8GF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5PtA/5DN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nRX1SK21";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zLJ8Vru9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA11A1F74C;
	Mon, 18 Aug 2025 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5bBvEjkDuFecWIQAly2QsB7UAomNK47HU/ZIMwWLo1E=;
	b=Qq78L8GFXUJXuiv9K3X99Fvb4snhnGfUWjsLQJ/O43U5E9BAPtd5OUPDl+Tju1irz2ZsWp
	soO94VN0lqpVT4MJ/F+ru/V2/C1Z1RFimZAocy5Ymk2xK5qIMzdN5qP0N7r5ssGgG0V46s
	LZY/hn4lACTrKRnxgsOU/LdczfjEEH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5bBvEjkDuFecWIQAly2QsB7UAomNK47HU/ZIMwWLo1E=;
	b=5PtA/5DNNx54lQNE2SKAg2W5+pjyHo/KyHn+YOc8NF86oBIYimfWeUYbbrdcU1Xi/OW2ky
	0iF4dxIMMCBsw3BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5bBvEjkDuFecWIQAly2QsB7UAomNK47HU/ZIMwWLo1E=;
	b=nRX1SK214ROcOnHCoUGD2vkyf4eX6OqconbFQccPjpXUbAzzg4XZtwepNkAzeD/+0JdwyX
	r8P+hHGsEl+rVhCVNn6vga10oqd+EKmZqyIn5XzEhQTv/iN9I75EZsRhZtuYrfvZdVmskJ
	pb/zBMy6VjafbGiqcghXotkbp2FifaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5bBvEjkDuFecWIQAly2QsB7UAomNK47HU/ZIMwWLo1E=;
	b=zLJ8Vru9EH7FM7usSiVVbp7n9nR4II0owT9fHQ8+jK78F2sCGGC/7MyhpWHD97L5a1yh6p
	yGc0ecenVAl4tKCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A1DD13A55;
	Mon, 18 Aug 2025 12:07:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yqdkJI8Xo2jJbQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:07:43 +0000
Message-ID: <8bc163a8-a2a5-4adb-91c7-6d3c627b4edd@suse.de>
Date: Mon, 18 Aug 2025 14:07:43 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/9] nvme: add NVME_CTRL_MARGINAL flag
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
 kees@kernel.org, gustavoars@kernel.org, jmeneghi@redhat.com,
 emilne@redhat.com
References: <20250813200744.17975-1-bgurney@redhat.com>
 <20250813200744.17975-3-bgurney@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250813200744.17975-3-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 8/13/25 22:07, Bryan Gurney wrote:
> Add a new controller flag, NVME_CTRL_MARGINAL, to help multipath I/O
> policies to react to a path that is set to a "marginal" state.
> 
> The flag is cleared on controller reset, which is often the case when
> faulty cabling or transceiver hardware is replaced.
> 
> Signed-off-by: Bryan Gurney <bgurney@redhat.com>
> ---
>   drivers/nvme/host/core.c | 1 +
>   drivers/nvme/host/nvme.h | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
