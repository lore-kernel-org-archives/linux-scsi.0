Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BFE145A1F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764669684; cv=none; b=Il3g+p7vTTo3NKamkgN8z4EMNoh/oVtL8y+7aJbi5SpWqfSP1/SQuCtXK7HbinkY3deUIXuGOvQlackCoKLdyb5Ovn8jTp2T6WSdI/j40Kz8nIwvn/FBExHkcM/h+rLxCgZNkYLHgM8vQeNy/hhtwXxYr4vRW7kGgSEpqdrn3oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764669684; c=relaxed/simple;
	bh=g75fuIEuv02i2I+MfKjyOCeN+qfE44uSE8u4CzNLI+c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q9l+VY0TN75t76WezAQ8+ab2DUIdRHYI6zu4Cbp7TnwQAt3Feenkg7MOVwko2KcdEInDVME9vh1W1QDK+XMjK95NSSzQ22EqT4HZo/Glp6vthZcjSdcz6oAoGAcYiBgKpFO2ydAr80v+MKZNek8Pu/fzpf1mfKp41w+J5NHKkkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eiV2j131; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eiV2j131; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eiV2j131";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eiV2j131"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 088905BCCC;
	Tue,  2 Dec 2025 10:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764669680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8vD+AnXlN9xpHIATXrHZf9DVaVEOEEdD4LgSOwCuJu8=;
	b=eiV2j131obPDneWm4QESb+44u8AeSV863R18UlK3Y+wwKrT4lWoqzAIb9ok6bUKCUWSUGd
	WMANW29QBeeCSkPKXhWiye7FXbqOUeelhxPdl+d4XdN97aOzXj+4f9DU2HhmbmvmELvVlq
	cjNaft4mzV1y70sX70E74dfdHP/xWfs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764669680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8vD+AnXlN9xpHIATXrHZf9DVaVEOEEdD4LgSOwCuJu8=;
	b=eiV2j131obPDneWm4QESb+44u8AeSV863R18UlK3Y+wwKrT4lWoqzAIb9ok6bUKCUWSUGd
	WMANW29QBeeCSkPKXhWiye7FXbqOUeelhxPdl+d4XdN97aOzXj+4f9DU2HhmbmvmELvVlq
	cjNaft4mzV1y70sX70E74dfdHP/xWfs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA0AE3EA63;
	Tue,  2 Dec 2025 10:01:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tD2zL++4LmmkfgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 02 Dec 2025 10:01:19 +0000
Message-ID: <5e67ffa808938d3aa93a14b272ef1450fa62b3ee.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_dh: Return error pointer in
 scsi_dh_attached_handler_name
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, Mikulas Patocka
 <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Date: Tue, 02 Dec 2025 11:01:19 +0100
In-Reply-To: <aS46EpB6dijzABwA@redhat.com>
References: <20251121234834.1035028-1-bmarzins@redhat.com>
	 <94bce7593f2980cef43860044e5b662c3d3c0ec7.camel@suse.com>
	 <aS46EpB6dijzABwA@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.26
X-Spam-Level: 
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.818];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]

On Mon, 2025-12-01 at 20:00 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 27, 2025 at 04:26:51PM +0100, Martin Wilck wrote:
> > On Fri, 2025-11-21 at 18:48 -0500, Benjamin Marzinski wrote:
> > > If scsi_dh_attached_handler_name() fails to allocate the handler
> > > name,
> > > dm-multipath (its only caller) assumes there is no attached
> > > device
> > > handler, and sets the device up incorrectly. Return an error
> > > pointer
> > > instead, so multipath can distinguish between failure and success
> > > where
> > > there is no attached device handler.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0drivers/md/dm-mpath.c=C2=A0 | 8 ++++++++
> > > =C2=A0drivers/scsi/scsi_dh.c | 8 +++++---
> > > =C2=A02 files changed, 13 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > index c18358271618..063dc526fe04 100644
> > > --- a/drivers/md/dm-mpath.c
> > > +++ b/drivers/md/dm-mpath.c
> > > @@ -950,6 +950,14 @@ static struct pgpath *parse_path(struct
> > > dm_arg_set *as, struct path_selector *ps
> > > =C2=A0
> > > =C2=A0	q =3D bdev_get_queue(p->path.dev->bdev);
> > > =C2=A0	attached_handler_name =3D scsi_dh_attached_handler_name(q,
> > > GFP_KERNEL);
> > > +	if (IS_ERR(attached_handler_name)) {
> > > +		if (PTR_ERR(attached_handler_name) =3D=3D -ENODEV)
> > > +			attached_handler_name =3D NULL;
> >=20
> > What's the point of continuing here if we know that the SCSI device
> > doesn't exist?
>=20
> we just know that it's not a SCSI device, so we clear
> attached_handler_name.=C2=A0 I suppose we could add another check to erro=
r
> out here if m->hw_handler_name is set. But if it is, the
> setup_scsi_dh()
> call just below will fail anyways, so there's not much difference.
>=20
> But if you think adding that extra check makes things clearer, I'm
> fine
> with that.

Yes, I think so. We know it makes no sense to call setup_scsi_dh(), wo
we shouldn't try.

Martin
