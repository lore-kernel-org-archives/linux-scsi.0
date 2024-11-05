Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0471E89C
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 08:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730795676; cv=none; b=iiC8hWGo3B3tgNbdJRtBBhptMsm8tUHUC2AS2wMrLmS6eVAWLinhUH0ccQl6mhnXlMy3d4NsCffLTr2eYvc6joi8lz+QYTfA1ewkNPSiLiv0in6O9h2VnTP2wz1ZBK7U9djfC7Ay7XnTk3+QzUx+y19tDN4u1HuTFhZSucFF+AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730795676; c=relaxed/simple;
	bh=Gl4du/uUnPK7PpxEdm9JpgeFUb5rw3uBvQ6jRuvEsCU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M3lhK+yW8/GT4yD3XMNJFlZeLS2kQenQYjBrAKqs+1nhE5tOIYW/0sYO57mFI/0WXf8YdCXnm+wkruQyUjxEZqjY2zpZa0VyBP0wQ0fwbDzLuWTIAMRhPwx3IQTQr2yuTeq+bRruf9wEKPislxzxabifLr7dbEkfSlw/dqGpxfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZhrQeTL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lRyIYvAm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZhrQeTL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lRyIYvAm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZhrQeTL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lRyIYvAm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZhrQeTL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lRyIYvAm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 85CF021C14;
	Tue,  5 Nov 2024 08:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730795673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gl4du/uUnPK7PpxEdm9JpgeFUb5rw3uBvQ6jRuvEsCU=;
	b=MZhrQeTLDNjMNQ/rCkNVGVhePhStGlGVy7hxp8RpwqJyJ4/vof6p1n+HNXFKTUV3PKMKeu
	5xT/oat5IQzTECZFVnDmzFiPBAFZbbJxaG40nPVsJ5oXCm1fFJmSboDjaO01sNVVxL4UW9
	79BTe/4z/FP1KDTloN3mDoDea04RwUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730795673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gl4du/uUnPK7PpxEdm9JpgeFUb5rw3uBvQ6jRuvEsCU=;
	b=lRyIYvAm1KUqwR9jpV7gnA9ZaVlI7X84Tq4fk2gKRrLK2tVfVCk1S02gUSdyjrzZ44Cno3
	6D4GpcvVe1bRVxCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MZhrQeTL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lRyIYvAm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730795673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gl4du/uUnPK7PpxEdm9JpgeFUb5rw3uBvQ6jRuvEsCU=;
	b=MZhrQeTLDNjMNQ/rCkNVGVhePhStGlGVy7hxp8RpwqJyJ4/vof6p1n+HNXFKTUV3PKMKeu
	5xT/oat5IQzTECZFVnDmzFiPBAFZbbJxaG40nPVsJ5oXCm1fFJmSboDjaO01sNVVxL4UW9
	79BTe/4z/FP1KDTloN3mDoDea04RwUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730795673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gl4du/uUnPK7PpxEdm9JpgeFUb5rw3uBvQ6jRuvEsCU=;
	b=lRyIYvAm1KUqwR9jpV7gnA9ZaVlI7X84Tq4fk2gKRrLK2tVfVCk1S02gUSdyjrzZ44Cno3
	6D4GpcvVe1bRVxCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6702413964;
	Tue,  5 Nov 2024 08:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y64TGJnYKWcjLAAAD6G6ig
	(envelope-from <tbogendoerfer@suse.de>); Tue, 05 Nov 2024 08:34:33 +0000
Date: Tue, 5 Nov 2024 09:34:16 +0100
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Magnus Lindholm
 <linmag7@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
Message-ID: <20241105093416.773fb59e@samweis>
In-Reply-To: <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
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
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85CF021C14
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[orcam.me.uk,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO

On Mon, 04 Nov 2024 20:40:40 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> Maciej,
>=20
> > force 32-bit DMA addressing for pre-ISP1040C hardware and let the
> > system determine whether 64-bit DMA addressing is available for
> > ISP1040C and later devices? =20
>=20
> Yep, that is the correct approach.
>=20
> Thomas: Can you confirm that your SGI hardware has a C rev 1040 ISP?

they are ISP1040B, so IMHO the revision is not the point.

Thomas.

--=20
SUSE Software Solutions Germany GmbH
HRB 36809 (AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
