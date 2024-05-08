Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDD27B3EB
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 10:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715163316; cv=none; b=MXua/h7eygd79ZB8cCl9owFCv4m/eXTSycFwENtN4rrLLJS65RPDOoHgDJcW+0RpdcPIsGDYhah9jE+Rn5nJrhG3Qypk8RlIzUH/UQIPocG7USMPPcMQHeJ1bnEvF51FIeiCJ6jEnfJQDRtS66mbsR611sgdaZHXnGE8BlwkoVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715163316; c=relaxed/simple;
	bh=RrV782H1tFtpGJr6Gqq5wvaKPlurBfifDh2v7/3RNLw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qbCIzZl4UebIvW/bRzexB3kXEuQlm6xWGT7jUKuleQAm7zJ75z1u4r4q/iFV8eScrJN0oo9En3uFs31UbFin9OluXDT4eEEQU/g7zRwP8AgcYdnSNLOdoxzlegXkoWdMFtQyDN2K4C9YTMGyiD+/A21G8FlT7xx3eaSGHZVIqiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AaYWgC5m; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AaYWgC5m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AaYWgC5m";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AaYWgC5m"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2760F34F6B;
	Wed,  8 May 2024 10:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715163312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RrV782H1tFtpGJr6Gqq5wvaKPlurBfifDh2v7/3RNLw=;
	b=AaYWgC5m62JNHuoYx7Gfk+ACXOC6AlaAHsAdHfNQLwZxkN9CX9fixeoLitSnjPZMc+b5K5
	gvkc7WIbHMcLzsZb3fl+S//CIYOefJN0HiHQ7mLODwroo+6ApfNdYRihj2b1CCo+5kDYAQ
	9/UA4VS+nEcRKU33q4M2xE4L4WG1jtE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=AaYWgC5m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715163312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RrV782H1tFtpGJr6Gqq5wvaKPlurBfifDh2v7/3RNLw=;
	b=AaYWgC5m62JNHuoYx7Gfk+ACXOC6AlaAHsAdHfNQLwZxkN9CX9fixeoLitSnjPZMc+b5K5
	gvkc7WIbHMcLzsZb3fl+S//CIYOefJN0HiHQ7mLODwroo+6ApfNdYRihj2b1CCo+5kDYAQ
	9/UA4VS+nEcRKU33q4M2xE4L4WG1jtE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E17B61386E;
	Wed,  8 May 2024 10:15:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CIhyNa9QO2bHLgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 08 May 2024 10:15:11 +0000
Message-ID: <afc8819fcc0f9acf23ecea3730203444fed99713.camel@suse.com>
Subject: Re: [PATCH 0/3] qedf misc bug fixes
From: Martin Wilck <mwilck@suse.com>
To: martin.petersen@oracle.com, Lee Duncan <lduncan@suse.com>, Saurav
 Kashyap <skashyap@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Date: Wed, 08 May 2024 12:15:10 +0200
In-Reply-To: <CAPj3X_U4RWi+3Lgo9bOFNAUcyK9AfzNFJ0E9YhCQRf2qUS_W6w@mail.gmail.com>
References: <20240315100600.19568-1-skashyap@marvell.com>
	 <CAPj3X_U4RWi+3Lgo9bOFNAUcyK9AfzNFJ0E9YhCQRf2qUS_W6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.32 / 50.00];
	BAYES_HAM(-2.81)[99.19%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2760F34F6B
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.32

On Wed, 2024-05-01 at 15:28 -0700, Lee Duncan wrote:
> On Fri, Mar 15, 2024 at 3:06=E2=80=AFAM Saurav Kashyap <skashyap@marvell.=
com>
> wrote:
> > ...
>=20
> If not too late, for the series:
>=20
> Reviewed-by: Lee Duncan <lduncan@suse.com>
>=20

Martin P., any chance to get this set applied?

Thanks, Martin W.
