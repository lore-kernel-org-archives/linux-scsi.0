Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC27D1FBF51
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2024 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731419583; cv=none; b=KLsUvvq2E6OYbmWXWZc2gHxniTAG+wms5idyVymCcotsGK+J7Qtzp6Q+t0UhIphPNl8/MnuDFA2dLKta5Q9wiJMFrQpN3t45m9rVPLudLeojROUZ9+ZBbU40Ko53x6e1OyZQV3aWBicTRL4ZVdi3IXd3RwEqjVQcrBKA0tsKGGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731419583; c=relaxed/simple;
	bh=ZM5XZiCogONgL5oF5W9D2qg8RQsq63f/rugcx9OspOo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kL9c0igHKphqfdEA7ktX5WxD6zJmc4U4EZ84P40ZB0EZgk77tpFtjAxNhq68IKnCIKtqrUJhispzPwoLoeLl1RDerBB821mnE4BTEj/PL7TJt3hCeIYlz2H5v7gDDw2g3dTpvZERRIMSEAjCU4bXhQdXfTyEKYvhMHUI8TIPspY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pEFHLc19; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nFvjy9QB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pEFHLc19; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nFvjy9QB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pEFHLc19";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nFvjy9QB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pEFHLc19";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nFvjy9QB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14A691F451;
	Tue, 12 Nov 2024 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731419580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/W8piaCyl6jsdgzxCncxSHZT+yFr0d9jg20wWL38+o=;
	b=pEFHLc19vOT+uHtBIt5iD9gczzl1rWuPIYCtRn/lWEel0lnKZmpDm1Eo03PR+MFA/bpbO5
	khb0k98Z5cPdxqDePtzZrjnBLt9t5nrDu2mwz9XdxCik5pQTbj70HZBQ1F6yg07oIh7D3N
	XsMV8cF/xKuKSdsGj+KxbNpEiD1oEUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731419580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/W8piaCyl6jsdgzxCncxSHZT+yFr0d9jg20wWL38+o=;
	b=nFvjy9QBCdAz38EpL664JbsKVf5GjLwO7o9Rpd3g82NnhFnOloB3PXwM74X4bVa2gK3jVq
	a/ykjqZEWQ256/DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731419580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/W8piaCyl6jsdgzxCncxSHZT+yFr0d9jg20wWL38+o=;
	b=pEFHLc19vOT+uHtBIt5iD9gczzl1rWuPIYCtRn/lWEel0lnKZmpDm1Eo03PR+MFA/bpbO5
	khb0k98Z5cPdxqDePtzZrjnBLt9t5nrDu2mwz9XdxCik5pQTbj70HZBQ1F6yg07oIh7D3N
	XsMV8cF/xKuKSdsGj+KxbNpEiD1oEUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731419580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/W8piaCyl6jsdgzxCncxSHZT+yFr0d9jg20wWL38+o=;
	b=nFvjy9QBCdAz38EpL664JbsKVf5GjLwO7o9Rpd3g82NnhFnOloB3PXwM74X4bVa2gK3jVq
	a/ykjqZEWQ256/DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB76213721;
	Tue, 12 Nov 2024 13:52:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7F6WOLtdM2fbcQAAD6G6ig
	(envelope-from <tbogendoerfer@suse.de>); Tue, 12 Nov 2024 13:52:59 +0000
Date: Tue, 12 Nov 2024 14:52:53 +0100
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
Message-ID: <20241112145253.7aa5c2ab@samweis>
In-Reply-To: <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com>
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
	<CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On Tue, 5 Nov 2024 20:24:58 +0100
Magnus Lindholm <linmag7@gmail.com> wrote:

> >  Thomas, Magnus, can you please check what hardware revision is actually
> > reported by your devices?  Also a dump of the PCI configuration space
> > would be very useful, or at the very least the value of the PCI Revision
> > ID register, which is independent from the hardware revision reported v=
ia
> > the device I/O registers. =20
>=20
> Below is some info from my Alpha ES40 with an ISP1040. I've added a
> printout of hardware revision number to the driver, as previously
> pointed out the revision numbers in qla1280.h is wrong so I've used
> info from NetBSD
> rev5 is a "B" which matches what is actually printed on the chip as
> well. This seems to be consistent with PCI Revision ID register.
>=20
> output from driver:
>=20
> qla1280: QLA1040 found on PCI bus 2, dev 4
> revision=3D5 <-- printout of cfg0 register 5 =3D rev B
> QLogic QLA1040 PCI to SCSI Host Adapter
> Firmware version:  7.65.06, Driver version 3.27.1
>=20
> #lspci -s 0001:02:04.0 -vvv
> 0001:02:04.0 SCSI storage controller: QLogic Corp. ISP1020/1040
> Fast-wide SCSI (rev 05)
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- =20
>         Latency: 248, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 52
>         Region 0: I/O ports at 200008000 [size=3D256]
>         Region 1: Memory at 209050000 (32-bit, non-prefetchable) [size=3D=
4K]
>         Expansion ROM at 209040000 [disabled] [size=3D64K]
>         Kernel driver in use: qla1280
>         Kernel modules: qla1280

0000:00:00.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (=
rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 8
	Region 0: I/O ports at 1f200000 [size=3D256]
	Region 1: Memory at 1f200000 (32-bit, non-prefetchable) [size=3D4K]
	Expansion ROM at 1f210000 [disabled] [size=3D64K]
	Kernel driver in use: qla1280

0000:00:01.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (=
rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at 1f400000 [size=3D256]
	Region 1: Memory at 1f400000 (32-bit, non-prefetchable) [size=3D4K]
	Expansion ROM at 1f410000 [disabled] [size=3D64K]
	Kernel driver in use: qla1280

qla1280: QLA1040 found on PCI bus 0, dev 0
qla1280 0000:00:00.0: enabling device (0006 -> 0007)
random: crng init done
cfg_0 5
scsi(0:0): Resetting SCSI BUS
scsi host0: QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.27.1
qla1280: QLA1040 found on PCI bus 0, dev 1
qla1280 0000:00:01.0: enabling device (0006 -> 0007)
scsi 0:0:1:0: Direct-Access     FUJITSU  MAW3073NC        0104 PQ: 0 ANSI: 3
scsi(0:0:1:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 0:0:2:0: Direct-Access     SEAGATE  SX118202LS       B808 PQ: 0 ANSI: 2
scsi(0:0:2:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
cfg_0 5
scsi(1:0): Resetting SCSI BUS

So the Octane 1040 chips are the same revision and working with 64bit addre=
ssing.

Thomas.

--=20
SUSE Software Solutions Germany GmbH
HRB 36809 (AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
