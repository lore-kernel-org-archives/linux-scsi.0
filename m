Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5CD1E89C
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 08:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730795610; cv=none; b=OLwd70OXAvwl5bITPYBT/oVNsvaiod/W50/pwKNOGZAPYrq8/6igbGbEafNcocvIFoR0MAsT9JgNRXBcJAmQJAlaB8oWgff3X9siXs7ON6TWWT2rKRea4VNijqYChppTNlmqqAQ41LoU4N+xxhEoGLLs0L+gJDl4hqBmlMWitJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730795610; c=relaxed/simple;
	bh=HIWMhoio8qm4qgtErkduRWVY3J9if+yDgtvJFWd9h7M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNaRc9m+w/+LsYUd2Nw0eV2F8VX1R3UFr3QG2EI2a3VaHv5oz1xvIlkDFyAeR5YvKQZ3FhXIawgwGCqBySYisZVDW6ONEKH1n5Zcbt0fdTB3lJhSH5oADouayRujiPR1PfC8QT2dQPYvLKHlIbAqg05zm+qO2OqM1m0W+MeYzmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FEf1/KIr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fO7elHdl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FEf1/KIr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fO7elHdl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FEf1/KIr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fO7elHdl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FEf1/KIr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fO7elHdl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F32D21C14;
	Tue,  5 Nov 2024 08:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730795603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M9ODG8zfEUi+vldIqZ3WuWm/xliVoTez+P6uAd1E5pQ=;
	b=FEf1/KIrPXXxILRXiAISw+vk71HB5HWUlfubfRbHkdOw2mp2ELhimcnCf72BNfbUB5bHHq
	IJzYqtcvw59UTd/n/NcjguRkWGma3ZTc7nlNMs+xSdEUl/VIyKgIG6PRzTfvbChv2Mn3LU
	gLoDJWIV1fSRI335Lw+DMG1JTNDAV5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730795603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M9ODG8zfEUi+vldIqZ3WuWm/xliVoTez+P6uAd1E5pQ=;
	b=fO7elHdlWd2LmY6g0nLsdGa3mn82YbrensLVr7YzhPHn3pkowF78/VWB/o9cH1hcAaMlZO
	aLla2oO6r+qvRICQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="FEf1/KIr";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fO7elHdl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730795603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M9ODG8zfEUi+vldIqZ3WuWm/xliVoTez+P6uAd1E5pQ=;
	b=FEf1/KIrPXXxILRXiAISw+vk71HB5HWUlfubfRbHkdOw2mp2ELhimcnCf72BNfbUB5bHHq
	IJzYqtcvw59UTd/n/NcjguRkWGma3ZTc7nlNMs+xSdEUl/VIyKgIG6PRzTfvbChv2Mn3LU
	gLoDJWIV1fSRI335Lw+DMG1JTNDAV5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730795603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M9ODG8zfEUi+vldIqZ3WuWm/xliVoTez+P6uAd1E5pQ=;
	b=fO7elHdlWd2LmY6g0nLsdGa3mn82YbrensLVr7YzhPHn3pkowF78/VWB/o9cH1hcAaMlZO
	aLla2oO6r+qvRICQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C75313964;
	Tue,  5 Nov 2024 08:33:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3jmJGVPYKWfcKwAAD6G6ig
	(envelope-from <tbogendoerfer@suse.de>); Tue, 05 Nov 2024 08:33:23 +0000
Date: Tue, 5 Nov 2024 09:33:21 +0100
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Magnus Lindholm <linmag7@gmail.com>, linux-scsi@vger.kernel.org,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: qla1280.c
Message-ID: <20241105093321.3ad1c1a7@samweis>
In-Reply-To: <alpine.DEB.2.21.2411042134240.9262@angie.orcam.me.uk>
References: <20241104204845.1785-1-linmag7@gmail.com>
	<alpine.DEB.2.21.2411042134240.9262@angie.orcam.me.uk>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8F32D21C14
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,hansenpartnership.com,oracle.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO

On Mon, 4 Nov 2024 21:52:36 +0000 (GMT)
"Maciej W. Rozycki" <macro@orcam.me.uk> wrote:

> On Mon, 4 Nov 2024, Magnus Lindholm wrote:
>=20
> >  Use dma_get_required_mask() to determine an acceptable DMA_BIT_MASK=20
> >  since on some platforms, qla1040 cards do not work with a 64-bit
> >  mask. For example, on alpha systems with more than 2GB ram a 64-bit DM=
A mask
> >  will result in filesystem corruption, but a 64-bit mask is required on
> >  IP30/MIPS. =20
>=20
>  This is missing the point, you get filesystem corruption because *your=20
> card* does not support 64-bit DMA addressing and not because your Alpha=20
> system has an issue with it.

I've checked one of my Octane boards and there are ISP1040B chips on
the board, so even ISP1040B is able to address 64bits.

How does the memory map look for more and 2GB ram on the ES40 ?

Thomas.

--=20
SUSE Software Solutions Germany GmbH
HRB 36809 (AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
