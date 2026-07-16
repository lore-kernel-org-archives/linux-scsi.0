Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEBB42465F
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209632; cv=none; b=E/Nfbww5u9YW1z3Y1pHtWeHMEqp6JPKkTjzwkHvKiqgqhbQkl//2+xX2ukDOHaadJdAeHKuwQMuU2XTI/l2ogttELzGwP8etjhnm/MJkaauVvELCFTiWDINOhaRsQpVGiJluePZYV2x3fwFh9t8Ocgy+J0yA9kBawrdZ96qAhNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209632; c=relaxed/simple;
	bh=0WtXjB6WwYolKe1XepFFEIP+h0W2NaY7L/pE4Ob2j1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lNp8fxOngiMpO1g5XX3ZKauBHygGk7kQsDzk4pkUg2c/0NnVdadk3hc+kgLmJl3jtbluNvf0wRHkzAVbygH0yYN+KQlwCiK7kApuUa0hCmyVk3bHnY2cJRVXH0GMkdvBoL8x8dwS08GNQoQtjry9j9DrvKwRv7sv72keLDe8ly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZwPKquWA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t9ShfoCB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZwPKquWA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t9ShfoCB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZwPKquWA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t9ShfoCB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZwPKquWA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t9ShfoCB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D45223DF3;
	Thu, 16 Jul 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784209627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e01hDe7AeUVKeg6D9VB9uCJXyJQWuZecmSs/neZL6o8=;
	b=ZwPKquWAZKZUP1nA5oLMOTX55w5YRMk1Br1TlJhpRnOvr8yTyfWWkH3h6MPjn6czJBsC6k
	bCNBk9dqGRXgHF6rgDu5r2ICxGpqHBGZIuoOgHV6nkqOTvXndRNDD5n5oASrq+k8av8dSV
	xGGuRwa7gb2Sw0sgfDw3Nk4wgi2xNdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784209627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e01hDe7AeUVKeg6D9VB9uCJXyJQWuZecmSs/neZL6o8=;
	b=t9ShfoCB/KS2mCcLMhHkrmb1BiFkIQk+uTRrh55EICkSf4wRU5In0SgEL7M1NuHow+nT6m
	yJGL1heSc0JkJkAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784209627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e01hDe7AeUVKeg6D9VB9uCJXyJQWuZecmSs/neZL6o8=;
	b=ZwPKquWAZKZUP1nA5oLMOTX55w5YRMk1Br1TlJhpRnOvr8yTyfWWkH3h6MPjn6czJBsC6k
	bCNBk9dqGRXgHF6rgDu5r2ICxGpqHBGZIuoOgHV6nkqOTvXndRNDD5n5oASrq+k8av8dSV
	xGGuRwa7gb2Sw0sgfDw3Nk4wgi2xNdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784209627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e01hDe7AeUVKeg6D9VB9uCJXyJQWuZecmSs/neZL6o8=;
	b=t9ShfoCB/KS2mCcLMhHkrmb1BiFkIQk+uTRrh55EICkSf4wRU5In0SgEL7M1NuHow+nT6m
	yJGL1heSc0JkJkAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD1A0779AD;
	Thu, 16 Jul 2026 13:47:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 83rELdvgWGpaGQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 16 Jul 2026 13:47:07 +0000
Message-ID: <d47e2b74-9431-4552-afc5-2115f3244b4f@suse.de>
Date: Thu, 16 Jul 2026 15:47:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] scsi: libsas: terminate deferred commands on time
 out
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>
References: <20260716083847.926102-1-dlemoal@kernel.org>
 <20260716083847.926102-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260716083847.926102-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/16/26 10:38 AM, Damien Le Moal wrote:
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred command is never issued nor completed, thus leaving this
> command to always be counted as "busy" for the SCSI host. This results in
> the test "shost->host_failed != scsi_host_busy(shost))" in the function
> scsi_error_handler() to always be true, keeping the EH task sleeping.
> Eventually, when the deferred command also times out, the SCSI EH task
> is woken up and the timeout processing occurs.
> 
> Avoid this unnecessary additional SCSI EH trigger wait time with the same
> method as implemented in libata-scsi, using the eh_timed_out SCSI host
> template operation. The function sas_eh_timed_out() implements this
> operation and executes the function ata_scsi_retry_deferred_qc()
> for SATA devices.
> 
> Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c           |  4 ++--
>   drivers/scsi/libsas/sas_scsi_host.c | 15 +++++++++++++++
>   include/linux/libata.h              |  1 +
>   include/scsi/libsas.h               |  2 ++
>   4 files changed, 20 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
