Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B65156CF
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730385578; cv=none; b=JXpIr3ugvGtv12VGmPJYRO7q7tnX4Nd/1DkkHVKSZ0JE4qDh69fW9XcpbktGPmsXwo8DDWSuJahK3SoGvIxobVtDOBKiqVwCbKvJY/wT23H9RRhf/h9RCLdF9Qxg/DdkCD0h62yPPzL0AbYKWKVv9Bl2QFEwabOMYBJ0V8qdqMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730385578; c=relaxed/simple;
	bh=f+6XLCFK7r3h4QGh8lv5gZCibfIsJP9raJpoX7w2zxw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TcVcptCrb3Ks2a9BqdV8FYx5q2o4i5uvFbJXKPygeNrjrcnC2UARFm3HsEQZ2Xqjj6I4RceCXZhyh8LKSjL1VU2hQDchnAjiyTslH/q2lj30rmpQ8WtQSDrYPpOesPY7g1UAAJEQeNNeKt65tgfOz06jHT+bNIGZtH4UxgujrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gv7VpV3l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qWsX6reA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gv7VpV3l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qWsX6reA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gv7VpV3l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qWsX6reA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gv7VpV3l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qWsX6reA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A5541FE84;
	Thu, 31 Oct 2024 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730385573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wP53ubKBMeqEALK63Y8rWS5AHJ0Nmp90sjkJ+5NMUW0=;
	b=gv7VpV3lvOBx188Nn5HR2fKAqx8N9KYx4DsnYdlyPC+oCyYRMfBcOGQkr1e3Jbw0pdcoic
	gQZHgpXa1TgQIsDlEMUy82hPOxiGGrfawdjO0blxTM/QGLr96VQunP2B0Hav+0h+WkL3ux
	yX030FOkU2kAPwqy0p+ZMNv5rVnoTi8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730385573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wP53ubKBMeqEALK63Y8rWS5AHJ0Nmp90sjkJ+5NMUW0=;
	b=qWsX6reAp7MBF1Sa94q3oWS3Iwf006235Ew5h0acw0vK/emuSeZzdL8FvywD7W+z0yd68P
	ug3uB4WtEGF0ILBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gv7VpV3l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qWsX6reA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730385573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wP53ubKBMeqEALK63Y8rWS5AHJ0Nmp90sjkJ+5NMUW0=;
	b=gv7VpV3lvOBx188Nn5HR2fKAqx8N9KYx4DsnYdlyPC+oCyYRMfBcOGQkr1e3Jbw0pdcoic
	gQZHgpXa1TgQIsDlEMUy82hPOxiGGrfawdjO0blxTM/QGLr96VQunP2B0Hav+0h+WkL3ux
	yX030FOkU2kAPwqy0p+ZMNv5rVnoTi8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730385573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wP53ubKBMeqEALK63Y8rWS5AHJ0Nmp90sjkJ+5NMUW0=;
	b=qWsX6reAp7MBF1Sa94q3oWS3Iwf006235Ew5h0acw0vK/emuSeZzdL8FvywD7W+z0yd68P
	ug3uB4WtEGF0ILBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73BED136A5;
	Thu, 31 Oct 2024 14:39:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BiH6GqWWI2fQEAAAD6G6ig
	(envelope-from <tbogendoerfer@suse.de>); Thu, 31 Oct 2024 14:39:33 +0000
Date: Thu, 31 Oct 2024 15:39:24 +0100
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
 mdr@sgi.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2] scsi: qla1280.c
Message-ID: <20241031153924.03e057d1@samweis>
In-Reply-To: <20241031125506.20215-1-linmag7@gmail.com>
References: <20241031125506.20215-1-linmag7@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9A5541FE84
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, 31 Oct 2024 13:54:08 +0100
Magnus Lindholm <linmag7@gmail.com> wrote:

> In order to prevent file system corruption on disks attached
> to 32-bit ISP1020/1040 cards in 64-bit enabled systems, while maintaing t=
he
> possibility to run other qlogic cards in 64-bit mode, limit DMA_BIT_MASK =
to 32-bit.
> [..]
>  #ifdef QLA_64BIT_PTR
> -	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
> -		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
> +	/* for 1020 and 1040, force 32-bit DMA mask */
> +	if (IS_ISP1040(ha))
> +		mask =3D DMA_BIT_MASK(32);
> +	else
> +		mask =3D DMA_BIT_MASK(64);


this breaks SGI Octane and SGI Origin systems:

qla1280: QLA1040 found on PCI bus 0, dev 0
qla1280 0000:00:00.0: enabling device (0006 -> 0007)
qla1280: Failed to get request memory
qla1280 0000:00:00.0: probe with driver qla1280 failed with error -12
qla1280: QLA1040 found on PCI bus 0, dev 1
qla1280 0000:00:01.0: enabling device (0006 -> 0007)
qla1280: Failed to get request memory
qla1280 0000:00:01.0: probe with driver qla1280 failed with error -12

They need 64bit DMA addresses.

Thomas.

--=20
SUSE Software Solutions Germany GmbH
HRB 36809 (AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
