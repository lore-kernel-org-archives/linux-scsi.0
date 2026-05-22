Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A51466B75
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779467555; cv=none; b=a1wGPCYnwlbuW3fGxORpGdtSv0gGHCO/AYgBL75gyFka8N4t+y3evT2xz2DTM9E/J/psB1DMGjwjcRtR7+H+qqpYY2nX1Wk0ACklEzSs325U3Vs3i++1LSu3nEShSnfzMh6gHI4UiVy/JYrishcIeS4U7sVfsVAOreIzV3Rgc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779467555; c=relaxed/simple;
	bh=stbJ65Q9o1XKxjwuDH5N7KywEL4O93V2OLHV73DLsNI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bzOrNsqU/TVmRkMh7ivkIms/LMPx0ifJb6bNaH7P19Ka9ayDHAgnnb5tEygxPwHdK8yO/QDxkQLYQ3ywzjV/UAeLtF5lQT0M6b3I41DTi1J5JGblTLezdYP+ILg2AW81x5eJ/e/HuOLvK/Mc0dlHpxgOu6Tqpkb8dq/00V1VX8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hzVqk+w3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KNhPrWNq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hzVqk+w3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KNhPrWNq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1E536C035;
	Fri, 22 May 2026 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779467549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ig+2MFXtFSiUFV2ofkYGPcDVxtgHznKc/cEE2ZkFmHs=;
	b=hzVqk+w3ci49irG/MKgGRfZXJvIH5IU4u2YlwQozrwRvfMPS/c5ykOqdMzWLlNarIfoyL9
	MaC6Bfpu9y4UFzsscQkBk+ZsjSwaa/WpPGT1Kz0W/LmxhULcz0CiXBacHJyOkj6OXuyELS
	RhPcfOMeZxMKHtwXwcIbaSl2l/mFkYk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KNhPrWNq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779467548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ig+2MFXtFSiUFV2ofkYGPcDVxtgHznKc/cEE2ZkFmHs=;
	b=KNhPrWNqZsitaF0QhN4h2z8zPLjSnT3I63bpRhomnG2TEnopcAytvBaEeMCkbCiuBYvuwY
	U9imz4nubvzrtNH0GLHM3jWlOBuE7FZy+GWZkm8cm+VMnVYMpev+iepOfSvNDPTbNLk1Z2
	BF8OxoyQqyXAX85RXkyHNYRxLqspKyY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8534D593A8;
	Fri, 22 May 2026 16:32:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3wZnHxyFEGogYgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 22 May 2026 16:32:28 +0000
Message-ID: <cf115b6142522889a62419c6ef9dc6b11837ccd3.camel@suse.com>
Subject: Re: [PATCH v3 2/2] Revert "scsi: Fix sas_user_scan() to handle
 wildcard and multi-channel scans"
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Don Brace
	 <don.brace@microchip.com>, ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>, 
	mpi3mr-linuxdrv.pdl@broadcom.com, storagedev@microchip.com, Sathya Prakash
 Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai
 <kashyap.desai@broadcom.com>, Sumit Saxena	 <sumit.saxena@broadcom.com>,
 MPT-FusionLinux.pdl@broadcom.com
Date: Fri, 22 May 2026 18:32:28 +0200
In-Reply-To: <9c6e8497-5e92-4d2b-ac87-3c941e6890a1@suse.de>
References: <20260513174236.430465-1-mwilck@suse.com>
	 <20260513174236.430465-3-mwilck@suse.com>
	 <9c6e8497-5e92-4d2b-ac87-3c941e6890a1@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: D1E536C035
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,microchip.com:email,suse.com:dkim,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Tue, 2026-05-19 at 11:08 +0200, Hannes Reinecke wrote:
> On 5/13/26 19:42, Martin Wilck wrote:
> > This reverts commit 37c4e72b0651e7697eb338cd1fb09feef472cc1a.
> >=20
> > Said commit causes excessive resource usage and even system freeze
> > with
> > some controllers, e.g. smartpqi and hisi_sas. The justification
> > provided
> > by the patch authors [1] was supporting a special mode of the
> > mpi3mr and
> > mpt3sas, so-called "Tri-mode", in which NVMe drives are exposed as
> > SCSI
> > devices on a separate channel. While that's useful for these
> > drivers, it
> > seems wrong to cause major breakage for other drivers for the sake
> > of
> > this feature.
> >=20
> > [1]
> > https://lore.kernel.org/linux-scsi/CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS=
4QohFOFGPqAs8ig@mail.gmail.com/
> >=20
> > Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
> > and multi-channel scans")
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Cc: Don Brace <don.brace@microchip.com>
> > Cc: storagedev@microchip.com
> > Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> > Cc: mpi3mr-linuxdrv.pdl@broadcom.com
> > Cc: MPT-FusionLinux.pdl@broadcom.com
> > Cc: Yihang Li <liyihang9@h-partners.c
> > ---
> > =C2=A0 drivers/scsi/scsi_scan.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> > =C2=A0 drivers/scsi/scsi_transport_sas.c | 60 +++++++------------------=
-
> > -----
> > =C2=A0 2 files changed, 13 insertions(+), 49 deletions(-)
> >=20
> While I'm generally in favour of keeping things simple,
> reverting the mentioned commit might cause regressions
> with te mpi3mr and/or mpt3sas controller.
> Have you tested with these controllers?

Frankly, no. There isn't much to test. Reverting 37c4e72b0651 restores
the pre-6.17 state. Which means that the wildcard scan for NVMe devices
on mpt3sas and mpi3mr, which was implemented by that commit, will not
work any more. As written before, I propose the revert because this
commit has severe side effects for wild-card scanning on other drivers.

The way forward remains to be clarified. This is why I have included
the mpi3mr/mpt3sas maintainers on the CC list of my patches from v1.

A relatively simple option would be to allow SAS drivers to override
the  sas_user_scan() function with driver-specific code, and do that
for mpi3mr.

Some guidance on the matter would be appreciated.

Regards
Martin

