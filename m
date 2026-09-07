Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748033E1CFD;
	Mon,  7 Sep 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789426; cv=none; b=sZAyxGcnlxmlIZ0KUFTePH/iteFwZEc31DRZfC8YmP/ZgZbhQ7ujGSjdssi7GmMRi5pjMAfUP/cxHf9hUD1mlcDKA41D/sw7qhA8WHDjqeJPuw35BqXyMFyy23W8RYbgdzs+sokQ0cm+kcDRLvIUnJvvN/iOeUNK+yuwJkihxeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789426; c=relaxed/simple;
	bh=RMdfuv4csQ9cU4Re4Ti8069U2eb4RVtmc5uZ5QacDV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r6Ut08PHTBEZazETYPaOdwGvh5+aG2MuyHvjO2CzstBrqxJ8XYunu1NXIzwggdE0oXZfdc1F+sfMDz6s/4Aa0ZxadxuiwCvPz5OjIrK9evbt60hqreQpcudYBDPwkQ5bfCBFl2/PgrY49Ug9iTofSlO9rEhIXF4wUteJMT4ebNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oJqmEaez; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VWLzdLCM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HCkw00pQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=30Q0YB/P; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oJqmEaez";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VWLzdLCM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HCkw00pQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="30Q0YB/P"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3AC5F21983;
	Mon,  7 Sep 2026 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788789419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qpxGushWsDnJiG79MmNNtTZcAfpp0mHFJE+Vjlyl6Vk=;
	b=oJqmEaez/W9b6s8AXJG8h54gxrXjb5yRQgNq5TaEoOzzL6WU+niPOsPi3p3Mr7TbK80WCK
	vquSDYHRVTFg79yZ3ebNZdg9RFB3cn1ObduKdtZjY68iUsA9D70Y5Vv8GMpFw9pASFer8q
	dRSMnDdC5FYHI8O9ROxco1CYqFzAVZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788789419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qpxGushWsDnJiG79MmNNtTZcAfpp0mHFJE+Vjlyl6Vk=;
	b=VWLzdLCMd/VAjh+K8oM8mX4x9uIAnK+yfOeSHqOpQGDYuqi3bi+qMsNCPEW9aJQJFOSQqG
	deeIPkd2r4HF8mBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HCkw00pQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="30Q0YB/P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788789415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qpxGushWsDnJiG79MmNNtTZcAfpp0mHFJE+Vjlyl6Vk=;
	b=HCkw00pQUveLGeb9XKDRbUiWFURBolQ5M4FHOwm84YN5MW1JvyBk2E0jXArHPxHnJBVYKf
	34BFzmD3fA7nnGicf8pvQhUSHHcFAZwLVY6p+qIJMniOHCOd7c5SNWR8+Ee50O+W+ZIiqF
	WKx/Hx69tHkw1Rkyj5nEdjmu8zd4lHA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788789415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qpxGushWsDnJiG79MmNNtTZcAfpp0mHFJE+Vjlyl6Vk=;
	b=30Q0YB/P4m6+f6g96SnZVNL3ixawKz3K6Mz/hBSEJCVwjM+bfr1ypGPXUtuLWyqPDlJlvb
	e3Tw3VU8iz9mqKCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B430313432;
	Mon,  7 Sep 2026 13:56:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +EhIKqbCnmo4CAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:56:54 +0000
Message-ID: <b0c95f8c-da1c-447b-8205-42c9a5c8ec48@suse.de>
Date: Mon, 7 Sep 2026 15:56:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/40] scsi: sr: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-10-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 3AC5F21983
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sr.c       |  3 ++-
>   drivers/scsi/sr_ioctl.c | 29 +++++++++++------------------
>   2 files changed, 13 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
