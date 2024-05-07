Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA546BFC0
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 09:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073057; cv=none; b=qyXyaoo5Qu2AArp60MViDTsdFTKT2MowjCKSUPxZuardLfVMwZXRx4eA03CwT3dUtcCBFTbMwriyx0bT5LeFcsDFOeldegI0koIRo76WJsj/HHLMipopwk/eJphKid/xnJ3EKy5zgXTVhqMmJVZ7VYkTE52STHmH33uQELJ2HKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073057; c=relaxed/simple;
	bh=TOviUTBTYg8bZF4vS4xiXzkSLeTJ/VEm3Qep0h1Qn4M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EAe3dXA77fSNJkMRV/scsKtEQrYS3LjI6F85MPAIE5bcvCy6XfXEQdlmQYkxWOrwSB1vo0VhmQMqfvZbtTGQmwkewYJ1b1/i4KK8fu8TvLEqmvtlYk1gMqo0s83xq/eULfcqIDzQ5heotgVHwqEF1TXd0KLyjdm+BtXuHzB5oCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P4Bw/5nY; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bDJPr44Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P4Bw/5nY";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bDJPr44Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 61DD7206C8;
	Tue,  7 May 2024 09:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715073053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZux9p7BC/x4qi61wvU6BAJ9BuHKut7SfVZDT+CMvqE=;
	b=P4Bw/5nYsuItM9eLjGOCkWbl4NhAv8RRLYDZqhQpdDbZT+BtoD4XK93oMNGXmm+3JYd34x
	whHpRNXkRn1OVQuJss2qPPwqieT0vEOe0ZHUj/lhRJv3QMYfsCY5DtnXdcgo6Y4o3cB+H2
	AOI/PO8lFYDG8uD+OpO5DMvhWk1rrWw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=bDJPr44Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715073052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZux9p7BC/x4qi61wvU6BAJ9BuHKut7SfVZDT+CMvqE=;
	b=bDJPr44ZpNkjDWoEH/XYxGOVWVu/vBvmnYWW0qfpYEdvbtCDtSjvf0ioL4K+lMXDyXJsUX
	8CYURpqGSDCPvTzyaBJZXTqg8RJB3GvN9BqY6YyEgoBhxEMKvzIZyhhxrnVrT0BDCS0swa
	q9vVeLGSPHzEsZUDrnsU52idWX76wNY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EFA9139CB;
	Tue,  7 May 2024 09:10:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ln/8BRzwOWaqSQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 07 May 2024 09:10:52 +0000
Message-ID: <cd3e2be2ee204a614f69b76f7eefcc50b1e9c4b2.camel@suse.com>
Subject: Re: [PATCH v2] I/O errors for ALUA state transitions
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke
	 <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Ewan Milne
	 <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, 
	linux-scsi@vger.kernel.org, Rajashekhar M A <rajs@netapp.com>
Date: Tue, 07 May 2024 11:10:51 +0200
In-Reply-To: <20240506055433.GA5220@lst.de>
References: <20240503195606.13120-1-mwilck@suse.com>
	 <20240506055433.GA5220@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.23
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 61DD7206C8
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.23 / 50.00];
	BAYES_HAM(-2.72)[98.78%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On Mon, 2024-05-06 at 07:54 +0200, Christoph Hellwig wrote:
> > -static enum scsi_disposition alua_check_sense(struct scsi_device
> > *sdev,
> > -					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct
> > scsi_sense_hdr *sense_hdr)
> > +static enum scsi_disposition alua_handle_state_transition(struct
> > scsi_device *sdev)
> > =C2=A0{
> > =C2=A0	struct alua_dh_data *h =3D sdev->handler_data;
> > =C2=A0	struct alua_port_group *pg;
> > =C2=A0
> > +	/*
> > +	 * LUN Not Accessible - ALUA state transition
> > +	 */
> > +	rcu_read_lock();
> > +	pg =3D rcu_dereference(h->pg);
> > +	if (pg)
> > +		pg->state =3D SCSI_ACCESS_STATE_TRANSITIONING;
> > +	rcu_read_unlock();
> > +	alua_check(sdev, false);
> > +	return NEEDS_RETRY;
>=20
> This always returns NEEDS_RETRY, so you can drop the return value
> entirely and handle this in the callers.
>=20

I liked being able to write "return alua_handle_state_transition(...)"
in the caller. But np, I'll change it.

Martin

