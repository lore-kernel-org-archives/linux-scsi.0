Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C761FF7AF
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730842408; cv=none; b=WVY7aoqIxXL56KghxhMMVFfPm35+e0V1mcc19Y2EQ9iH8eXJiGeWPlNLnahhoB/Kef62EDtcnb6z9TlQb1MXA9357EmBfwkcm5EmR6Ph3LyJiuCxH7fZUd9xkWudOyaAgOj+gnjgsLfvqSRBMniGoMLxE467cAnlQ5NVH02tbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730842408; c=relaxed/simple;
	bh=o21YOeHQkFJ0SNOIzTYqKFE50kbliz7aygmd9wFQn5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V261ttut5vNkQMzV+OohtaKb6K2TlK+sQFTuMIkvxFKvMMq3S3zDeXN8z4Z1pOiQy0h1+8Y+w00v736XzcOpHeqEx1q69+g8feYcvJinElX5aZk3kFKcmwzYSwgM4Qfp3xqihzHKRxVdJpVSjyPCeMV8/GHEkKPi1jgPBC38BQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TTifaGIZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3ONvi4FJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TTifaGIZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3ONvi4FJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TTifaGIZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3ONvi4FJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TTifaGIZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3ONvi4FJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 221A621B4A;
	Tue,  5 Nov 2024 21:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730842405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iZKjyNvC929sEBW33CFPiuo/Zhj6CkSvB6Qzjuz6PM=;
	b=TTifaGIZrcJuDe0ZvdsLw2bCVVoeKSadk3Hesh3VE5F8L3DZhuxVOmM4Zj/YR0kOgyVbM5
	9p5tKQPegaWASMiznAK7mcU4UPL1mGm5bRc8Zsrc9Qyql/jtxt08Ic/5Jx737IBMQAwxmx
	HfgEOY4IcUpCniJOCv7r+oop0lrwBfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730842405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iZKjyNvC929sEBW33CFPiuo/Zhj6CkSvB6Qzjuz6PM=;
	b=3ONvi4FJpe+UgqGiV3NU1xcAkDqOVUlK8WfjRKytLniBoIL/MWR4FkBNMRLb31Bc9Kl1rs
	q4WIobwO+gaH2LAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TTifaGIZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3ONvi4FJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730842405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iZKjyNvC929sEBW33CFPiuo/Zhj6CkSvB6Qzjuz6PM=;
	b=TTifaGIZrcJuDe0ZvdsLw2bCVVoeKSadk3Hesh3VE5F8L3DZhuxVOmM4Zj/YR0kOgyVbM5
	9p5tKQPegaWASMiznAK7mcU4UPL1mGm5bRc8Zsrc9Qyql/jtxt08Ic/5Jx737IBMQAwxmx
	HfgEOY4IcUpCniJOCv7r+oop0lrwBfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730842405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iZKjyNvC929sEBW33CFPiuo/Zhj6CkSvB6Qzjuz6PM=;
	b=3ONvi4FJpe+UgqGiV3NU1xcAkDqOVUlK8WfjRKytLniBoIL/MWR4FkBNMRLb31Bc9Kl1rs
	q4WIobwO+gaH2LAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F298613964;
	Tue,  5 Nov 2024 21:33:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L+XkOSSPKmdrHAAAD6G6ig
	(envelope-from <tbogendoerfer@suse.de>); Tue, 05 Nov 2024 21:33:24 +0000
Date: Tue, 5 Nov 2024 22:33:19 +0100
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Magnus Lindholm
 <linmag7@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
Message-ID: <20241105223319.46c7563a@samweis>
In-Reply-To: <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
	<CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
	<yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
	<alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
	<CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
	<20241030102549.572751ec@samweis>
	<CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
	<alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
	<CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
	<alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
	<Zyh6tP-eWlABiBG7@infradead.org>
	<CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
	<alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk>
	<yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
	<20241105093416.773fb59e@samweis>
	<alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
	<yq15xp14fy7.fsf@ca-mkp.ca.oracle.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 221A621B4A
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[orcam.me.uk,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 05 Nov 2024 14:56:15 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> Maciej,
>=20
> >  Thomas, Magnus, can you please check what hardware revision is
> > actually reported by your devices? Also a dump of the PCI
> > configuration space would be very useful, or at the very least the
> > value of the PCI Revision ID register, which is independent from the
> > hardware revision reported via the device I/O registers. =20
>=20
> It would also be interesting to know what the 'enable 64-bit addressing'
> NVRAM flag is set to on Thomas' system.

there is no NVRAM on the Octane

Thomas.

--=20
SUSE Software Solutions Germany GmbH
HRB 36809 (AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
