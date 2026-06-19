Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2B13469FC
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 06:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781848874; cv=none; b=N3ehLUpgALL3a2p7fEx16xoC2fURhz9N0neqPUwFhZlQRfwxJuT4Zs42fREpOzGzdwktXvWT5N76ASyBmaTGSi61kStqFPRSoY7dMCJqWm2u0NGbxoqpsb1/UAv+RZoiJtj1kIr0KgwJc3PweYrt5x25IWwYhN3qmjYMqZjgvro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781848874; c=relaxed/simple;
	bh=hipFTjcGzG3DkImMOReZVjtrLoYDHsw7tH1W0l2ropM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JspI+hN9fKK4iJWXvXERihapJcvAu968OVK0eNYIwcVzWN5iUYe7kRccl7UouFPrzBTnCWnJ+/GR7NsySBiheQo8712zPemjk8YG6b8sfTo5nU03JLgTRSL6pIxXPvIl76Y8vwjlG2oJRcHrX3xk1labTHc3Djbec542OZun1z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NYxhlSwz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uZmm69lv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NYxhlSwz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uZmm69lv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NYxhlSwz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uZmm69lv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NYxhlSwz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uZmm69lv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E0236D898;
	Fri, 19 Jun 2026 06:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781848871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0wZnjaktOP/FaCoTr+UzkdJdnQ1GP1gIg5OhfCnGcw=;
	b=NYxhlSwzku0DP2KcxQ9qem9t5USbYjIPNbJfQFAMYshO0qGVm6M/69NgrT9kPfW5KPMXdb
	12G9fNssSZZIzKvrvNhwuxncbYZVfnNhLfaTRUnYiuRqUHJRV6XFZyGb4gvzpUXvWKmtoi
	cflstZelzOwEK9jJM58Mw5CbR36jaUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781848871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0wZnjaktOP/FaCoTr+UzkdJdnQ1GP1gIg5OhfCnGcw=;
	b=uZmm69lvPcnYjCbqS6Gz3Wdq1RiC1csl0HPLWQWm2IP0vLNlWCK7u5WcK32ji8Gru9cevw
	BRvw7BcPk2z3ujDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NYxhlSwz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uZmm69lv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781848871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0wZnjaktOP/FaCoTr+UzkdJdnQ1GP1gIg5OhfCnGcw=;
	b=NYxhlSwzku0DP2KcxQ9qem9t5USbYjIPNbJfQFAMYshO0qGVm6M/69NgrT9kPfW5KPMXdb
	12G9fNssSZZIzKvrvNhwuxncbYZVfnNhLfaTRUnYiuRqUHJRV6XFZyGb4gvzpUXvWKmtoi
	cflstZelzOwEK9jJM58Mw5CbR36jaUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781848871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0wZnjaktOP/FaCoTr+UzkdJdnQ1GP1gIg5OhfCnGcw=;
	b=uZmm69lvPcnYjCbqS6Gz3Wdq1RiC1csl0HPLWQWm2IP0vLNlWCK7u5WcK32ji8Gru9cevw
	BRvw7BcPk2z3ujDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39348779A8;
	Fri, 19 Jun 2026 06:01:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UVNPDCfbNGp7FwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 19 Jun 2026 06:01:11 +0000
Message-ID: <020fbf65-35f6-468e-8465-c05ab5738aa7@suse.de>
Date: Fri, 19 Jun 2026 08:01:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] scsi: core: Add device reprobe support to
 scsi_rescan_device()
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, krishna.kant@purestorage.com
References: <20260618233508.97960-1-brian@purestorage.com>
 <20260618233508.97960-5-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260618233508.97960-5-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6E0236D898
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/19/26 01:35, Brian Bunker wrote:
> Update INQUIRY data on rescan and call device_reprobe() if PQ or type
> changed. Critical for ALUA unavailable state handling (SPC-4 5.15.2.4.4).
> 
> Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>   drivers/scsi/scsi_scan.c | 135 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 125 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
