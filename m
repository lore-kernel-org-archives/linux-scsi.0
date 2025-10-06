Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B9322D4DC
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734740; cv=none; b=LcbsCzE/T1AN+azxISKFlHTGqEOIw9VzLAZomcVa8uByigw8Ex0UNvW27WmvmTCIXaHXQaeyRPab9IP3Ep4s3IIZsnDSoN0lxB+Cl0tEQBQy2j/HiCygfMcPfMwiZih65LelLwpqma/8UXTV22mT9v9a4cErltJN3Y9NzvuCNZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734740; c=relaxed/simple;
	bh=f1ufKixUqQ/oqqU25IifeBo7YgMI02/xC7HiDsq53a4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VBLRLhHUEKzkIa34WgbKYmOnZZPGAnl6GdonnPrmVpNyQwZgXvl+UitSziSrk7R3dvOHMG9Fc/b2/zyn7n5SYQFU+vUBv2rF632KazTm5CguCx6f4CErU2l0F0py3y+i5B6yLRgFQxnwxA996pdB5gw/p0b9mEPhcWPH0+jtZsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rHiT+RGz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8/Ph622O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P4nk+8JI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jy7KTyM8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rHiT+RGz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8/Ph622O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P4nk+8JI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jy7KTyM8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EFE0E1F452;
	Mon,  6 Oct 2025 07:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHhbPFdsLJYx/zxBHHGRu868JH+/9/dV403+GKghh/U=;
	b=rHiT+RGz25qkdoCmtNEvdUP4j746bWC5rJAAfXCQBReh7pIcuoj9ORj+KhQD5gosYFwouT
	xyX3Dd04DCiarCiuD/OVYE9/Al8y3Cg/LHTZ14cFOsRbyVopfmOagdGr/wW+kbtsKEsWT2
	Mt7d7RaSA7wnBT9AvVGMpCMBYNGWrNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHhbPFdsLJYx/zxBHHGRu868JH+/9/dV403+GKghh/U=;
	b=8/Ph622Ol2tVZlW/ja0f2VBz2/35RomRIHdUvkBBpty6LGZZ5k4sotT8f0xMQvGsAH9czC
	Zu/fmp3JHDW6hODA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P4nk+8JI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jy7KTyM8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHhbPFdsLJYx/zxBHHGRu868JH+/9/dV403+GKghh/U=;
	b=P4nk+8JIAIvkSOhVlCqjG1+Y8qQ0kTqjplgtLNs/kWynoOAH4yOes4OOEpRuvSZsb27Ut6
	FanG5lhByxBbIu1rxuZ0KBUHsUv7zL48SURdk/Ig4kgfVpTZ0k4W8x6Jr94DXtUekVHu5B
	U8kxnKf7Sk9D5+tckkFbSgYGoK/J57A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHhbPFdsLJYx/zxBHHGRu868JH+/9/dV403+GKghh/U=;
	b=jy7KTyM8RNQO3jrFokqGwmV9Y0XGEQeLnOD/wiqHw4vFwH2Hezz+rYhlBKBFdey7Dn3T8Q
	ytTcsJoCogH46lCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDA4913700;
	Mon,  6 Oct 2025 07:12:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9jTPLNBr42joFAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:12:16 +0000
Message-ID: <aa444145-33e4-432d-b382-5524e226e743@suse.de>
Date: Mon, 6 Oct 2025 09:12:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] scsi: scsi_debug: Add option to suppress returned
 data but return good status
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-9-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-9-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: EFE0E1F452
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
> This is used to test the earlier read_capacity_10()/16() retry patch.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 49 ++++++++++++++++++++++++++++-----------
>   1 file changed, 36 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
