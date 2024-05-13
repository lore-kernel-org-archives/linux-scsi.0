Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A915356A
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2024 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715608285; cv=none; b=X///MO5tLnVuHvgPYFH9tQ3UwGO0TuLTk017KnkDyvEg52IYujbWQI5fDHopfWg5RUR6vUAEpTqwQ/jsis4FxI6EMM9vrDXvsNFYDQUDgpfms3LUhdq9lkZcKxHss25HRyi7wslFzmuMXlgIiFhtrisNIEve1Z7FXfStxNg84IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715608285; c=relaxed/simple;
	bh=SHYjsZ//dznYEJ+mbMcnsIbdv2RYdJdxxX/I6UtHRuQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DU+ir+UaSCXLnudJFff76nCJJv1ti7sY6MBUoSEdePHHJ3uZM4pD7Cf0/LVqGTiSoirWK1i3tg9o+atqyilCwD6O9pxBK1H/TIiBkkz9zILJmYp+H7d76JOEWrqGoJx/73KUGfJGiEyulonp6Ouoj1vA/vYFxUM3KM0AeGyjhFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sAHheE2B; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=e8wdCqvJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sAHheE2B";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="e8wdCqvJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A66365C112;
	Mon, 13 May 2024 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715608281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHYjsZ//dznYEJ+mbMcnsIbdv2RYdJdxxX/I6UtHRuQ=;
	b=sAHheE2B2QfGjbj1bAyUY0DxWQjH7/ndE7+pSHJaFQ47j1njoWOR7RRQpiEohAZ50dwtdI
	PsOaK9KhdYx9FrwyoIrD+4L9uBN7g3IHlDuxcavQEWUYG6A635zlmEXP6btK6Vi/K4Ji4B
	L17Vtqgjw2ktJ9ZsmcmVzOSQng2D9/E=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=e8wdCqvJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1715608280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHYjsZ//dznYEJ+mbMcnsIbdv2RYdJdxxX/I6UtHRuQ=;
	b=e8wdCqvJ4fUg4VVkOavvLaerjM8bn/PcmdTnd13CtTJbzwtYKYikci/dIkaJmQjzuquoSE
	pm9Ta8foHLn85MEXFzEdSMz4D+rLF39KSZtdJYz3eRz5HqK0qGGcyVthChcWos++iIDwXY
	KUqnikuWDgVtlNYX/4pQ3Y9zF2w0NtU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AB851372E;
	Mon, 13 May 2024 13:51:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eNiLFNgaQmYSIwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 13 May 2024 13:51:20 +0000
Message-ID: <a92a0786d687ab5f06d79005f2bb5c09d54e4a2e.camel@suse.com>
Subject: Re: [PATCH v4] I/O errors for ALUA state transitions
From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James
 Bottomley <jejb@linux.vnet.ibm.com>, Ewan Milne <emilne@redhat.com>, Mike
 Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, Bart
 Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>,
 Rajashekhar M A <rajs@netapp.com>
Date: Mon, 13 May 2024 15:51:19 +0200
In-Reply-To: <yq11q6bwyf6.fsf@ca-mkp.ca.oracle.com>
References: <20240508102426.19358-1-mwilck@suse.com>
	 <yq11q6bwyf6.fsf@ca-mkp.ca.oracle.com>
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
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,netapp.com:email]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A66365C112
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.51

On Wed, 2024-05-08 at 21:47 -0400, Martin K. Petersen wrote:
>=20
> Hi Martin!
>=20
> > From: Rajashekhar M A <rajs@netapp.com>
>=20
> I can't really apply this without a formal SoB from Rajashekhar.
>=20

This will be difficult, as this email is outdated and he's apparently
not with NetApp any more.

The patch looks very different now from what he originally submitted.
Would it be acceptable if I resubmit with myself and Hannes as patch
authors and him in a Co-authored-by: ?

Martin





