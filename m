Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D157D41931B
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780658159; cv=none; b=M7rFncya1Kofj1CKFBnUe8/yRt5Xqed7IID/6B4jQ9dHM+SWPJ3MRsF4740SSm41p413W5zyKXdT8eo010gba0Fk9sTN9uHJ5Nyzj87n/IXVAq7fmCxxRFGwNl0Erxq86Z0KRjUrCKwkQo62ykM/i88B1PT8ucY/kzkhRK9aHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780658159; c=relaxed/simple;
	bh=kqxiOotK0FA1RkAiHhG2IBA+vwuPdIDMrIhttxYJopM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LeBgAeTa1isjxQug4bBwhXuyO4SVpZ3XPvuCJWwONO3UF7IxqSuShauDjNVY6nd9Lkl23E4xFPwSTsqk4r8kiYSKORdyGcMD+M3stFddbPq6UFFaFAlPPtiAvF8OOsgjzMEntEaIM3XRJXccMiQKvKHYncdpGBsIZUZaJdM3HoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rdukO1tZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rdukO1tZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rdukO1tZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rdukO1tZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 234DB68574;
	Fri,  5 Jun 2026 11:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780658156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqxiOotK0FA1RkAiHhG2IBA+vwuPdIDMrIhttxYJopM=;
	b=rdukO1tZQ/5OTSb2Pble2X5+mt7jVSomYJjZI5HxOr9IFFEqWcUuF8DUCzWjCCRJ5LU/Yz
	7fjso5eiR1Rv8WUsjawhAlGGqpYCcfPp+dxPrI9dSMN/B3SLZ2C+KrcbdTdwLzgtCXZp+s
	wcM8tiI5LK+Gw9CakFLXO2V3E31QnQg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780658156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqxiOotK0FA1RkAiHhG2IBA+vwuPdIDMrIhttxYJopM=;
	b=rdukO1tZQ/5OTSb2Pble2X5+mt7jVSomYJjZI5HxOr9IFFEqWcUuF8DUCzWjCCRJ5LU/Yz
	7fjso5eiR1Rv8WUsjawhAlGGqpYCcfPp+dxPrI9dSMN/B3SLZ2C+KrcbdTdwLzgtCXZp+s
	wcM8tiI5LK+Gw9CakFLXO2V3E31QnQg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBC1A779A9;
	Fri,  5 Jun 2026 11:15:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j0+SNOuvImqoEAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jun 2026 11:15:55 +0000
Message-ID: <91b28db156bf1a643cbe6b6380d2361f2b954a98.camel@suse.com>
Subject: Re: [PATCH] scsi: devinfo: broaden Promise VTrak E310/E610
 identification
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Alexander Perlis <aperlis@math.lsu.edu>, Nikkos Svoboda	
 <nsvoboda@math.lsu.edu>, Benjamin Marzinski <bmarzins@redhat.com>, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>, Christoph Hellwig
 <hch@lst.de>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>, SCSI-ML <linux-scsi@vger.kernel.org>,
 DM_DEVEL-ML	 <dm-devel@lists.linux.dev>
Date: Fri, 05 Jun 2026 13:15:55 +0200
In-Reply-To: <20260529205602.177515-1-xose.vazquez@gmail.com>
References: <20260529205602.177515-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.80

On Fri, 2026-05-29 at 22:56 +0200, Xose Vazquez Perez wrote:
> The Promise VTrak Ex10 series share the same hardware base and
> firmware.
> Consequently all interface variants, whether fibre channel ("f") or
> SAS ("s") in dual/single controller, exhibit the same SCSI behavior.
>=20
> Instead of adding separate blacklist entries for every specific model
> variant (such as E610f, E610s, E310f, E310s), consolidate and
> broaden the match strings to "VTrak E310" and "VTrak E610".
>=20
> Cc: Alexander Perlis <aperlis@math.lsu.edu>
> Cc: Nikkos Svoboda <nsvoboda@math.lsu.edu>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
