Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7155C311954
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 09:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772013002; cv=none; b=oauHkoyQvMToXEvXZQPhoKwgFgd+YqNtbuYQX1RJIDmO8R6+lswcoq6r4psVZLsvUNaLyIC8MXq64FiNmBx0z+ltehP71jIpISok2IqvhJGrmJiNlVBwCk5GSMKQNlhTh/EvZSMz206DaNMl44z4UYvaf6cpIimxlq1Tg1YAIAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772013002; c=relaxed/simple;
	bh=nxq9aekKS+ewfGHK1jI2zOU2NjqcxDkxkMTBsnc361E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qjzRR/TQiptAa7sDDJvvJ006GP2jJ83nsAP1F2LS/q1f1FvETruivl/MOnhfuyLA32HwKRDOL8r9xAeHcFO2XDQRt1NPwragzuffhGOr8tsLxmYQMlODRVR7iKSYvcYaXFWFjqUMxtMaqjfwgMsBmOXo7gPT7Uw0c628h/1QdJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P0iFkKV+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P0iFkKV+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P0iFkKV+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P0iFkKV+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A726E3F737;
	Wed, 25 Feb 2026 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772012999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxq9aekKS+ewfGHK1jI2zOU2NjqcxDkxkMTBsnc361E=;
	b=P0iFkKV+W0VYTtbMmBuVPGkge0vEA3V1XtpwnY752ZrGyiy1aL5oyHoaFGMEkCq0+09My7
	LByvyb1QQuU/Mvk+rO31d+3vdY8WPCAcnZy65Umikw8OHDnSdY+w2Rwq69+pSPIMrl8EVm
	HX7NijQDSb2XzwblsnZx5rvIW0b7PsA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772012999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxq9aekKS+ewfGHK1jI2zOU2NjqcxDkxkMTBsnc361E=;
	b=P0iFkKV+W0VYTtbMmBuVPGkge0vEA3V1XtpwnY752ZrGyiy1aL5oyHoaFGMEkCq0+09My7
	LByvyb1QQuU/Mvk+rO31d+3vdY8WPCAcnZy65Umikw8OHDnSdY+w2Rwq69+pSPIMrl8EVm
	HX7NijQDSb2XzwblsnZx5rvIW0b7PsA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 570233EA65;
	Wed, 25 Feb 2026 09:49:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 79cYFMfFnmllMAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 25 Feb 2026 09:49:59 +0000
Message-ID: <bddb92c1b37685ddc331efacdc2afdc9b39684ec.camel@suse.com>
Subject: Re: linux-scsi project on GitHub & SCSI user space utilities
 maintenance
From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Paul Evans <pevans@redhat.com>, 
 =?UTF-8?Q?Tom=C3=A1=C5=A1_B=C5=BEatek?=	 <tbzatek@redhat.com>, Hannes
 Reinecke <hare@suse.de>, Lee Duncan	 <lduncan@suse.com>, Bart Van Assche
 <bvanassche@acm.org>, Mike Christie	 <michael.christie@oracle.com>, James
 Bottomley	 <James.Bottomley@HansenPartnership.com>, Chris Hofstaedtler
 <ze1ha@debian.org>,  Xose Vazquez Perez <xose.vazquez@gmail.com>, Daniel
 Horak <dhorak@redhat.com>
Date: Wed, 25 Feb 2026 10:49:58 +0100
In-Reply-To: <yq1pl5t5wlf.fsf@ca-mkp.ca.oracle.com>
References: <e99744196d8a0ca2bffec1d13109eea071c99096.camel@suse.com>
	 <yq1pl5t5wlf.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,redhat.com,suse.de,suse.com,acm.org,oracle.com,HansenPartnership.com,debian.org,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi Martin,

On Tue, 2026-02-24 at 22:49 -0500, Martin K. Petersen wrote:
>=20
> Martin,
>=20
> > While we have clones of the repositories there that were previously
> > maintained by Doug Gilbert, we haven't applied any changes,
>=20
> Because nobody has submitted any patches or pull requests.

Apparently nobody has understood that this was how you intended it to
work, me included. Was it your intention to manage this organization on
your own?

> > IMO the main problem is currently that people are lacking
> > permissions
> > to access the repositories in the linux-scsi organization.
>=20
> I am not sure I understand the "permissions to access". What is
> preventing anybody from cloning a repo and submitting a pull request?

I guess it's the fact that people don't understand that this is what
they're supposed to do. People are still creating issues and pull
requests on Doug's repository.=20
>=20

> > Once permissions are set up, we'd start to migrate the open issues
> > and
> > PRs from Doug's repos to the linux-scsi ones, and then start
> > working
> > on them.
>=20
> Ah, so the intent is to migrate open issues from Doug's repo? Is that
> even worth it?

I would say so, yes. There are currently 18 open issues and 18 PRs open
at doug-gilbert/sg3_utils. Not overwhelming, but not negligible
either.=C2=A0

It would be helpful if we could simply migrate them from there to
linux-scsi. Be it only to have a clean transition and be able to
redirect future issues or PRs to the new organization.

I'd prefer that over having to recreate the issues one by one. There
are certainly some that can simply be closed, but even that is
impossible for any of us to do in Doug's repos. Moving them to linux-
scsi in a batch and then either closing or merging them looks like the
cleanest way forward to me.

> Why not just send the relevant patches to linux-scsi to have them
> reviewed? Or open a new bug if web is preferred?
>=20
> Note that I don't have a problem adding people to the GitHub org,
> that's
> fine. But I really don't understand what is currently preventing
> people
> from submitting patches...

Personally, I misunderstood your intentions. I was expecting sort of a
"kick-off" for the new organization, possibly invitations for co-
maintainers, and a batch issue migration.=C2=A0I wasn't expecting that _you=
_
do all this; rather I thought that some people would collaborate to
make it happen. I was reluctant to duplicate issues manually before
this transition. And I admit it never occurred to me to send sg3_utils
patches to the mailing list.

I realize that these expectations were wrong. But apparently I was not
the only one who didn't quite understand. Perhaps we can use this email
thread to get everyone on the same page.

Thanks,
Martin
