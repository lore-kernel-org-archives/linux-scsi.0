Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ED64AFE12;
	Mon,  7 Sep 2026 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784828; cv=none; b=cFD03l0Vc8GqgloIEdxhZLmbHF/dWC+OwHopfRsYreD+7i4QR7T+vK4DsQbN911gJTJCsqoSEbm8NXwx2pAII8/jGbUQGwZ0sAhz1VvAXkuJA622uSxUmJxy4apw4PwBPFjSR3AOaC8qtlaa6P+n+vTY80B/yr61FY9gpnorLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784828; c=relaxed/simple;
	bh=BMkWRE+Jer3wxbXkIQ2rpbU0HADys+EW4Zn1AIpE64A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AKqpkdwJ97tDZiINiXdQtSsxtGPeBZsbVduZmOAdsAXmTdy385uQwmY35Rl5t+zaxqbZxv/nNpAAJ65OFYf14IDN6b5sykuFX8ncbrvp1qnRD/GaZaqYeS+sV9bBH/i6zc7jdwJXNlkvpQaiXgmObHtaM6Npq1AtDWJRUewFlJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w1Qelq7Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NzN8PKta; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FmxBmYkH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sWUIHzGL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w1Qelq7Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NzN8PKta";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FmxBmYkH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sWUIHzGL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A60FD1F750;
	Mon,  7 Sep 2026 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spho1EoanIR4qdHhA4fnI0A4gnMCdYOvXFIg1O5EhO0=;
	b=w1Qelq7Zmg9ckPWCdSrai7iqGLwT87s9qED5gvlzwk6tdceSEwphLlcLvFJM0paew9E/Fu
	CHPNwZLEYEbQdEQIPyAlEZ/g25Yt/hsa1XqSCdbBY4Uaq7RFzWcqXAiW5DAjXmDLYgFr4e
	YBOmTjQMTLIcngrscV7ySqxnhQAoMIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spho1EoanIR4qdHhA4fnI0A4gnMCdYOvXFIg1O5EhO0=;
	b=NzN8PKtab6qLxAcFdJqbsYIUPgNeILwLKLrcRR8d+xof83xXUKVclhK9grfI9+A6roJp06
	XZ/Loa7gp9kYFZAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FmxBmYkH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sWUIHzGL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spho1EoanIR4qdHhA4fnI0A4gnMCdYOvXFIg1O5EhO0=;
	b=FmxBmYkHN+QFKu2mKOnUe+APDL6FzDNU1T349aH0oABFYetvQ0oworExRIn/8sN3shIXrp
	zMKnY1OL1TUHBg1tGXQ22zA2/iPZT568hXx0oap1+/WCLdF7AiRbwovPSMj3zCSFQGM9IN
	QHreMyIpA9G0VMwAbKN/fmyiO4ncIEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spho1EoanIR4qdHhA4fnI0A4gnMCdYOvXFIg1O5EhO0=;
	b=sWUIHzGLFEA5vklLq5KhhumheVgUUTeEVAgvNK9z8YPbwbJXUWRfkf293joVKYUTMmb26s
	zjJ40y2wJ4mLoQBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 513271339B;
	Mon,  7 Sep 2026 12:40:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I2zBErCwnmqMOgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 12:40:16 +0000
Message-ID: <c9948fa3-8bfc-4dc0-97e6-63bcde39bc27@suse.de>
Date: Mon, 7 Sep 2026 14:40:15 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 29/40] scsi: libiscsi: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-30-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: A60FD1F750
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
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor libiscsi to use scsi_set_sense() and replace all hard-coded
> additional sense codes and additional sense code qualifiers with the enum
> values defined in include/scsi/scsi_sense.h. This helps with code clarity
> as the sense codes being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/libiscsi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
