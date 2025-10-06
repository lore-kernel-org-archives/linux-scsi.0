Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368E6139579
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 06:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759733975; cv=none; b=FeMz7iL0zoPu9KpZsVoxAa2Sq6yU07145Oy+L1aD8jA8MkIhIOxWw1yXTQ8j/hFTExPPU4EX8NSuGvkZ7ux4dRxN0yzyw6LwKYImCZekrVv6qEe/iE6u9FQRpxWPMcv+J6x07bC3qPgOjrkdIZGy20s84Daxr9P2eJUrXtOfdW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759733975; c=relaxed/simple;
	bh=OVuSTvYS9jCsrvB+kwCG5Mr/xBEaVMGt+tgspbtQvlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=csCzUViColFvp4zctHL7MI+b6n1cPF1zrgoCNFHwuk21n2zTSonhhPDoDMvNkKpFUUqYgPti36/zVgJRpPX0qrtUFMK+w7JTCsvl18XjNN2XBx0/6YqFmDDI6VIHYhymUkaCxXRVq53bTh4O+zBiqyF8JBxVamQ+XRAOGjE6S3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xx19aSu9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AIEVEAd9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xx19aSu9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AIEVEAd9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xx19aSu9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AIEVEAd9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xx19aSu9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AIEVEAd9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55F9333757;
	Mon,  6 Oct 2025 06:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759733972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tqo7TF67v0Nt6BDb5wIfnKZ8RdtKsXNA+gooRShmJA8=;
	b=xx19aSu9j7qINDzSxj1Re6RgtYL+pMUtkgUWLz1WXgEfFJb/TUDH0VRDM0Wuq5SGXL28ma
	Tpj9XJEiUYqljAb4x8UIHMyqpyNIP0ejE6j3xWmDyyJHz+ubjAeZBBYFBaPES2Y50TId+b
	PmzKHp2ziCtpwIP6OsgAXTVe4QFbYK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759733972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tqo7TF67v0Nt6BDb5wIfnKZ8RdtKsXNA+gooRShmJA8=;
	b=AIEVEAd9r9CPHyYH0CLYOHIuzSoe5nP28veHT0KOOU1WMcY0OvHucuuyO7xghMScMlc0gm
	CA2nX8SqpQuynMBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xx19aSu9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AIEVEAd9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759733972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tqo7TF67v0Nt6BDb5wIfnKZ8RdtKsXNA+gooRShmJA8=;
	b=xx19aSu9j7qINDzSxj1Re6RgtYL+pMUtkgUWLz1WXgEfFJb/TUDH0VRDM0Wuq5SGXL28ma
	Tpj9XJEiUYqljAb4x8UIHMyqpyNIP0ejE6j3xWmDyyJHz+ubjAeZBBYFBaPES2Y50TId+b
	PmzKHp2ziCtpwIP6OsgAXTVe4QFbYK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759733972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tqo7TF67v0Nt6BDb5wIfnKZ8RdtKsXNA+gooRShmJA8=;
	b=AIEVEAd9r9CPHyYH0CLYOHIuzSoe5nP28veHT0KOOU1WMcY0OvHucuuyO7xghMScMlc0gm
	CA2nX8SqpQuynMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12B5D13995;
	Mon,  6 Oct 2025 06:59:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DDT1AtRo42imEQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 06:59:32 +0000
Message-ID: <0309e7b1-c5ad-4a78-890a-7f271ac46a6a@suse.de>
Date: Mon, 6 Oct 2025 08:59:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] scsi: Explicitly specify .ascq = 0x00 for ASC
 0x28/0x29 scsi_failures
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-2-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 55F9333757
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
> This does not change any behavior (since .ascq was initialized to 0 by
> the compiler) but makes explicit that the entry in the scsi_failures
> array does not handle cases where ASCQ is nonzero, consistent with other
> usage.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_scan.c | 2 ++
>   drivers/scsi/sd.c        | 1 +
>   2 files changed, 3 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
