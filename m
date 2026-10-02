Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C642F709
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 08:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790930862; cv=none; b=WKBPGUuwjkt1FWlwR8YYjhqbOTVW4U2IjRWNBQAoieltEfGGQPjbi/UfUVPOseaGyjvSJm9ASi3mpbE8k3dgpPoIOnJ+BesYSa+dmwLYXKMlkQP7FvDq2Jz/nQd+i/gLWTiGAL4tct3ZA9wSyvKzzhMgg96Nk4et5G/nc1VZxl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790930862; c=relaxed/simple;
	bh=GSyELx9dwvoB/sio1I193Cn2G0vHc0XKaNmn/ELWTXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ulXX4oSHIxQxcROdmOxHCYBjpuLZrLPU2GuFyqDTZS1Bsc66/WLNAU8fSZdBGVnL2J0PCGRmwOF3PMaGRHmsJvn2ZA7Dai2mY4xT6mInBNxsHK7wMwM5ITX8satuapQNxANKINUA1ttc7fqVw0rg/ewbWmJ3OC3iyWgO1P9usqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=au6lywzG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kzwtsmNF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=moOi0BkU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xgP5hvSI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="au6lywzG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kzwtsmNF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="moOi0BkU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xgP5hvSI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 759731FE40;
	Fri,  2 Oct 2026 08:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790930849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJo+UVIUuiw6x3E4O2tfRmRePHyzUv16/nNBM6hDb70=;
	b=au6lywzGxsnTbCTSsh/FJCoUZ9tIo0nhBKyICTpsOSKoHK7yTI0JCVexgO2g48mBu5TP5n
	CwGd6Mu2pw/KYGT3XE3RAlAemKMpCAue4sz5DQ4B2F3ufZ7VDertxQMxeah5bDcZ3mHzzB
	2n0VVrmguvBSYwN/INuqTWGpzU5hEx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790930849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJo+UVIUuiw6x3E4O2tfRmRePHyzUv16/nNBM6hDb70=;
	b=kzwtsmNFVcCIO1hZ05buWk5wmi/WOVM3TsO133PbkdZkFQzSS3Svl0OJVA1r6qh6U9WmBF
	R0gjLNYzxoYVkuDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=moOi0BkU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xgP5hvSI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790930845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJo+UVIUuiw6x3E4O2tfRmRePHyzUv16/nNBM6hDb70=;
	b=moOi0BkU7xIbycGKqKOzGIEm6lrZvVT/PyZCXUEB+fAFULwltDw9EbLQI5jBO5y7iCX1A7
	JiDnN7AYDn08AH+zFuoWaSkROpZBzQWL5QfszUyB+U/qIPYVXR2Q7A+Oorq2Y/R6PCdH5J
	40c545l1EiMre45TEGZp2xadW/XrZgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790930845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJo+UVIUuiw6x3E4O2tfRmRePHyzUv16/nNBM6hDb70=;
	b=xgP5hvSIT7gp25j5vkdmC8CJRoytMWN+CxKYINqaGljdPoJw8aGY2L/CGMW4avxrJhV7GW
	t2aBEhmz7/x8UpDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3FB3C133CF;
	Fri,  2 Oct 2026 08:47:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HzMiB51vv2o3UAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 02 Oct 2026 08:47:25 +0000
Message-ID: <41b417e9-9bb4-4de7-bcd2-3ff99c30229a@suse.de>
Date: Fri, 2 Oct 2026 10:47:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix scsi_done() documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>,
 Hannes Reinecke <hare@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 759731FE40
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linux.dev:email,suse.de:mid,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim,linux.dev:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 9/25/26 8:08 PM, Bart Van Assche wrote:
> Commit 11b68e36b167 ("scsi: core: Call scsi_done directly") changed
> scsi_done from a function pointer member into a regular function.
> 
> Replace all references to the scsi_done function pointer member
> with references to the scsi_done() function.
> 
> Cc: John Garry <john.garry@linux.dev>
> Cc: Hannes Reinecke <hare@kernel.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   Documentation/scsi/scsi_mid_low_api.rst | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
