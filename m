Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA5E1A9FA4
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 07:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759734398; cv=none; b=YYEF0PP0NC/xekTChAbrxjtkZTvBvXF0P4BsglqIIxQPqwqNqFcFe7imCSyObnJrQ8WbpFvhnCUg+TFzIt1Y9VGuLEJuqx98BD/QIQcaA4Ropxdlie4Awnf/dkjxQ+IKIctFDo6vtIlhBEGmD1dQIOoSln2dytLMxemOeERUoYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759734398; c=relaxed/simple;
	bh=SKdVPhxh9+nXHDomwug5G6GxljMa6ZhqHEqihYrGSEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDs1YkCCawaLcfZ+LRhnQLO6OaNoX0nhMN7MRnbCHAbBYNJb3kI8L/b7uQvxqXKqkpMFO1KZ9P3sUmopUF2+RMed0pBn+kMnYRznTC2qqeWzpMTwX8+1zJXkcdZEqKrHIGmR8VZkBYdPxnDR29jgmLc5392NqO2kE4YIApsUTUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=unEiX/S8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dc8Ot9Ft; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RtvhdcLL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lodfoSa7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="unEiX/S8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dc8Ot9Ft";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RtvhdcLL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lodfoSa7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 817BD1F789;
	Mon,  6 Oct 2025 07:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgh2GezsJpxwc5Sgvgs8GNKjtQVxXSKTG4AHKpkgE54=;
	b=unEiX/S8OGNwY5aQasMR0Ah2CBpWScluh1kYaV9A9o6hrKzsKY4pa5istgE9O4x6oKNLdl
	Z4B05qeuH6N+M0Q5XOaGSY9psgDEETIrZ4XIIdJSXB75ttWV/wpvhqCVL423NWUSiGtvd6
	bGgVu9NbttnjWofDsuMZVNqZboYurf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgh2GezsJpxwc5Sgvgs8GNKjtQVxXSKTG4AHKpkgE54=;
	b=dc8Ot9Ftwdykg7m+1yCaEdOPi6ShQbh2Nodo0RZ77lo71xp+oXv7x+aF6BVHuz7HhbJzzC
	4u/gdCASXK3XL1Ag==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RtvhdcLL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lodfoSa7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759734393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgh2GezsJpxwc5Sgvgs8GNKjtQVxXSKTG4AHKpkgE54=;
	b=RtvhdcLL/D1XfC57miHrG+68rkn+NE+AuzwJ9UE76rN2pze9AjjKOXUzO92aPGOlW7OOSv
	Rv/r3CTXO/xsMzehMnz17+bU6vM2/kDg34P6uID9SxD2Rvy1iOjDINvCJoU78zjFkYA7bm
	daDdrFsOeL0DcEm6Ux6C0/Ip16pQz3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759734393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgh2GezsJpxwc5Sgvgs8GNKjtQVxXSKTG4AHKpkgE54=;
	b=lodfoSa7zZHyzWTYBIF5uh5PrVyViHiG6lF/xtCZxnzMljxagxa9SGO+hcUpLO4M07QjSe
	07Gw5vLjdsiz+9CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45E4A13995;
	Mon,  6 Oct 2025 07:06:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fs/iDnlq42h0EwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 06 Oct 2025 07:06:33 +0000
Message-ID: <231dbe9f-510c-4170-bdcc-d1ba2e79c837@suse.de>
Date: Mon, 6 Oct 2025 09:06:32 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 dlemoal@kernel.org
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-5-emilne@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251002192510.1922731-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 817BD1F789
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 10/2/25 21:25, Ewan D. Milne wrote:
> read_capacity_10() sets "sense_valid" in a different conditional statement prior to
> calling read_capacity_error(), and does not use this value otherwise.  Move the call
> to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
> from read_capacity_16() and read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/sd.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
