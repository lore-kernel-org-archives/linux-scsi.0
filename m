Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E40D4477FA;
	Mon,  7 Sep 2026 13:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789134; cv=none; b=bocmfeiD8EV6h4pYXTxzCzL+YoDjGC7kpNRKgnBaMThhJ+7JHDV6QVS/p8TEYTNW1wPgk+G0rn88KT01VUdsSKb7gj0u7MHd7YUhCJsplHph3g30wErxZ2jjb7mQBxRIi+nJRs7E65KSFkX+pLrZ2Tzt2bYq0CFrpoCWOwxrn10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789134; c=relaxed/simple;
	bh=0Y8QQVeaWWRLcQmQ/z3ysnD3dFXFJE1tVxW4bD38YRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ke57XttY11Tp+Qp28XyzKhsr3hOLzll2ygf4277QVfOVOHIAP+EEwe7B61+PeCbzv+TBAfgP+o7Tbi1EB0Ps6isVYM5tyulklMDAYyNI1Y3X5Z766yHRX0+qpuOEpx02lIRYelxRnIXwW99NsCQMP2X1XH9y3rZMkW4VqR2zA/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=c7nDvugt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z+V/kBAQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2C/H0joG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3+liLvur; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="c7nDvugt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z+V/kBAQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2C/H0joG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3+liLvur"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE186219EF;
	Mon,  7 Sep 2026 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788789126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl4GVliRl4sBbtp4xgVqZpI4d91O53niLdITBEIwngU=;
	b=c7nDvugtYIQaGsGGWMbzg3wcY3q+9alIfeH1I/MeBj4J/xiNiT0shH6QDlu2yo/bcbvVqK
	RiDAS2hqzbfDjDIgFW6OgNitK+I7nqbEq37MvPCMZouYvZE83UgERC0S9OuLuawJQcR5ip
	HYQPcN9P3+Zk949klkM5R9nYctbkpms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788789126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl4GVliRl4sBbtp4xgVqZpI4d91O53niLdITBEIwngU=;
	b=z+V/kBAQPMP0tgl675u4QNwD1zesq2I9SDwPv+JaellZwqOEPocUT79bf2uWoVJnoq8Jnm
	gWuF3V/q1S2WI4CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2C/H0joG";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3+liLvur
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788789122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl4GVliRl4sBbtp4xgVqZpI4d91O53niLdITBEIwngU=;
	b=2C/H0joGe+M5zPIe7Wd5wQcOKFzlkt4NxPJhPmfgQC/YDPEqLwPJljw7bOOLW/nB82WVPx
	YKmwBja3JOXBEmXJrLhgpWxYuOPju8fGVBUdp1AWNh7fX+0lHaxoUHJh7ZYKxQZWcyRUhD
	zyfZGkDza3B3/0+++jwO46gcAySu7Lw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788789122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl4GVliRl4sBbtp4xgVqZpI4d91O53niLdITBEIwngU=;
	b=3+liLvuroL+3V7ihLUfdQb5BmBtkNbmOGUCzh3vD9cshISwa9TrO1A3rkvCHlHYfvATnVw
	eX5XGRgPLHuiTXDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62FA513432;
	Mon,  7 Sep 2026 13:52:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 14ntFILBnmrBAwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:52:02 +0000
Message-ID: <8b1f8725-6ac0-4015-a687-165e41c6d5ac@suse.de>
Date: Mon, 7 Sep 2026 15:52:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/40] scsi: leapraid: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-21-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: BE186219EF
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
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the leapraid driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> With this change, the locally defined macros for ASC and ASCQ values are
> deleted.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/leapraid/leapraid_func.h |  7 -------
>   drivers/scsi/leapraid/leapraid_os.c   | 15 +++++++--------
>   2 files changed, 7 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
