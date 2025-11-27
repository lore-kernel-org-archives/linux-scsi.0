Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1D29346F
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764257216; cv=none; b=oDccSYceAQOKjxVGPKhTr6hLxRYH6MRcqmVSY4g1pNwLSvNUCAv7XGguY1cVp6oqz4Ej0N4e1dfz5qGO/2NmbjvKTPr8Rt1cieVANokjxRn4Rl1IAEnsFkgMvyZAR4buFrihL61F9Li1JyyxYWNygOwTQm26QAiYdWmUUC1AhvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764257216; c=relaxed/simple;
	bh=Cv6xS/HscHxY5d1h/0zuIOQVM1dkHlyxfU15k8eEQmI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PWl1wHqwSVPzqxRrxX24jwH4tH01koEO6UWXbYpBAVWWx3kpHhOO1u2OPEgB3zYrdtFnHXDRERqJS/R/zGBBXH0Jeqh+N3l7926vM9pM7KBx0VYH5rKody0cdD2we1f3ooji7NWVOevozZtrZFE89xhFfNhHGDCX6sjgNF02LCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CgBBLOX3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PX69wfa5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CgBBLOX3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PX69wfa5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A69E33760;
	Thu, 27 Nov 2025 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764257213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSYQxm2vCMlBqGxEgSZb1OqD0ikq0lmeeIha9hUgwBI=;
	b=CgBBLOX3ex0ySfdBtRFm90pf7Wk5L7U2ztX2JNce1z9TzEAsN5Rh9VhJTj3qHvluqeuOJG
	/PKsNmXwMc6W6VE7ognTpF0JYICiCqRXUSKhdfWOkSbIDaau2KfbIrsFwhHgwPI9nYtZJx
	bMCyW6bTezfyaKX+W6NlCITfx5I/Vxg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PX69wfa5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764257212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSYQxm2vCMlBqGxEgSZb1OqD0ikq0lmeeIha9hUgwBI=;
	b=PX69wfa5WrplpZ+31MSsDbDg6UGNyuZWjz20POsvhbpZ7zLmJLAsvQw9epk3U3C/sUZB3J
	Qp1CDIZJggxvFPX+Gd8LUQtxq1SXkvScKaC8yLfOk0B6F3Np6q1wG5PSLK4TAEGNatnnpP
	3DA5gdSsyFq/jKKNzbdi9kpc4UTg9uQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D26AF3EA63;
	Thu, 27 Nov 2025 15:26:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CMNRMrttKGnJRQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 27 Nov 2025 15:26:51 +0000
Message-ID: <94bce7593f2980cef43860044e5b662c3d3c0ec7.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_dh: Return error pointer in
 scsi_dh_attached_handler_name
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, "James E . J . Bottomley"
	 <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>
Cc: linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Date: Thu, 27 Nov 2025 16:26:51 +0100
In-Reply-To: <20251121234834.1035028-1-bmarzins@redhat.com>
References: <20251121234834.1035028-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0A69E33760

On Fri, 2025-11-21 at 18:48 -0500, Benjamin Marzinski wrote:
> If scsi_dh_attached_handler_name() fails to allocate the handler
> name,
> dm-multipath (its only caller) assumes there is no attached device
> handler, and sets the device up incorrectly. Return an error pointer
> instead, so multipath can distinguish between failure and success
> where
> there is no attached device handler.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0drivers/md/dm-mpath.c=C2=A0 | 8 ++++++++
> =C2=A0drivers/scsi/scsi_dh.c | 8 +++++---
> =C2=A02 files changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index c18358271618..063dc526fe04 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -950,6 +950,14 @@ static struct pgpath *parse_path(struct
> dm_arg_set *as, struct path_selector *ps
> =C2=A0
> =C2=A0	q =3D bdev_get_queue(p->path.dev->bdev);
> =C2=A0	attached_handler_name =3D scsi_dh_attached_handler_name(q,
> GFP_KERNEL);
> +	if (IS_ERR(attached_handler_name)) {
> +		if (PTR_ERR(attached_handler_name) =3D=3D -ENODEV)
> +			attached_handler_name =3D NULL;

What's the point of continuing here if we know that the SCSI device
doesn't exist?

Thanks,
Martin

> +		else {
> +			r =3D PTR_ERR(attached_handler_name);
> +			goto bad;
> +		}
> +	}
> =C2=A0	if (attached_handler_name || m->hw_handler_name) {
> =C2=A0		INIT_DELAYED_WORK(&p->activate_path,
> activate_path_work);
> =C2=A0		r =3D setup_scsi_dh(p->path.dev->bdev, m,
> &attached_handler_name, &ti->error);
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 7b56e00c7df6..b9d805317814 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -353,7 +353,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
> =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 that may have a device handler att=
ached
> =C2=A0 * @gfp - the GFP mask used in the kmalloc() call when allocating
> memory
> =C2=A0 *
> - * Returns name of attached handler, NULL if no handler is attached.
> + * Returns name of attached handler, NULL if no handler is attached,
> or
> + * and error pointer if an error occurred.
> =C2=A0 * Caller must take care to free the returned string.
> =C2=A0 */
> =C2=A0const char *scsi_dh_attached_handler_name(struct request_queue *q,
> gfp_t gfp)
> @@ -363,10 +364,11 @@ const char
> *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
> =C2=A0
> =C2=A0	sdev =3D scsi_device_from_queue(q);
> =C2=A0	if (!sdev)
> -		return NULL;
> +		return ERR_PTR(-ENODEV);
> =C2=A0
> =C2=A0	if (sdev->handler)
> -		handler_name =3D kstrdup(sdev->handler->name, gfp);
> +		handler_name =3D kstrdup(sdev->handler->name, gfp) ? :
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ERR_PTR(-ENOMEM);
> =C2=A0	put_device(&sdev->sdev_gendev);
> =C2=A0	return handler_name;
> =C2=A0}
