Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EA54A9D48;
	Mon,  7 Sep 2026 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784731; cv=none; b=GdzT4txw5cI2qcihysjFj9siDH14xS0DEk97pzgnMLIT1zMnqvaUDOxb58e1XaEe/CDhFF0tB8ifScJaCxVP00JbN0WiOOxpbhwRIXawKVbix8uJC3t4RfsGr19yHoxkprqnYmAaYvzqNhxtFWQ80R7nQoSFx8jsLDQJHfzHTX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784731; c=relaxed/simple;
	bh=ByJdevtXJ1fFEqwhFr6tdu7wap7JayMJbncwcvIhtRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hfekhZdpEf2owSa+CpJAQu2DOo0Zo6UrHCBCBPQp5Ka+2EJcja+d3KrtLymOFzrxJ6c+u79p9pemqfOTk48ifpWGAVxRv9unXuvwUbd6lURnha4kMtYEjz8B21O623Vmk3uwmSwx/5xjnwx+eVaDpnNqS3pnDAEo6cR5fcPreD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Gubyc/Wq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pU8kD8cS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z3+2QyBc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q0jFCICl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Gubyc/Wq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pU8kD8cS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z3+2QyBc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q0jFCICl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A34E921971;
	Mon,  7 Sep 2026 12:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EYl13lkLdAC2Jnsk4P+LHXnC0JEQWXtIX6p+pK3kloM=;
	b=Gubyc/WqVAvsnpHkrkR/CzbJyInsV50BJDk97xZJYgcbHEKWZpoe6DX4nPMox4h6d4xkgn
	7rc4pustObkeaLEmzu/WA60arH1Izh3V01Qq3UdoUnTALDrishegXELobScNQheMVt5iuI
	AGxAOZamGN8sOFNjE6MYOFvJGmNylDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EYl13lkLdAC2Jnsk4P+LHXnC0JEQWXtIX6p+pK3kloM=;
	b=pU8kD8cSylotZlv1Qgdskl8TY7HRC5FomD6kQvKJX5LbR5E6/oYdzxE9P5zFc1YjB6BWIO
	Eb31vlgWaMBTdiBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z3+2QyBc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=q0jFCICl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EYl13lkLdAC2Jnsk4P+LHXnC0JEQWXtIX6p+pK3kloM=;
	b=Z3+2QyBcT7gHfqkgQaZQ0nozR8nyuzEEHRel8YCaFx2ifWS8qtMGfUh0rENpv/olNRm98w
	ngik6AO+9hCugR+h2c7jO7p/T5XDg4o8oud5NBQQcShWNdcleueHd0fP3AGk3EvB5vrUOT
	299p1r0qar2w35ebd/Gtgzywv243Km8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EYl13lkLdAC2Jnsk4P+LHXnC0JEQWXtIX6p+pK3kloM=;
	b=q0jFCICl4ozlzh7ZUOllxL65IFMWV9q443gPJ756pxkdGf0hytK1B/t4NupbtrV69xYNMr
	zU0wkSNYD9FnbhDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 514F41339B;
	Mon,  7 Sep 2026 12:38:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b2K+Ek+wnmqIOAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:38:39 +0000
Message-ID: <57ca0536-c40f-4901-a392-f352337c87c4@suse.de>
Date: Mon, 7 Sep 2026 14:38:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 28/40] scsi: mvumi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-29-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A34E921971
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the Marvell UMI driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/mvumi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
