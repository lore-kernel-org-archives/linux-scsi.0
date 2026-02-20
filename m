Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A411F8691
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2026 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771599728; cv=none; b=M9OMWN0XUV9coBNCKnGzzSyRKXvQd9lBLtbPk8uCMm+wwf3leLJtZHzxEJiVbioq7nGVLeyxNh7SVlY/NJNJzvsEbFHaiZMkqIeugRq8LXpvDEoRZiPNsXQZ/MslKQBSNpsrC6zKQLNw42BKbu3p181rVMp7fGMgBosadzAMSSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771599728; c=relaxed/simple;
	bh=7uYyRSAdKMRd5mDitWwfp98DtUzANsIQdwTtCyHpDOM=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=egj1kFlggkgYxUgXtka1Gu9kpHXFZveAJVsblPlH16I9+Iplugwu+WZJy2sO8yoyisQp6oVX73D0RxbXE5YuhoWHaQGv5S+RfzhGa2Z8I7Bah/KB8voIkzGNroHgirHc1ZI6bPMmqVIS6OrkZu2fThFBYhVAG+wDX1pSq1AW0bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kE8bAE4S; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eiWxoaOm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kE8bAE4S";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eiWxoaOm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF82A5BCE3;
	Fri, 20 Feb 2026 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771599716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7uYyRSAdKMRd5mDitWwfp98DtUzANsIQdwTtCyHpDOM=;
	b=kE8bAE4Scyb82JxvvvPaI3thYPadPs/vRrEB9F4FshKlXLnor97yOY1DmDdecUEzKRup3q
	+R4D5ddEJW8mYCrdl+9IexQ3ajr6Q/WUtXDOA9RvW9uB3D52aYWVRaNhSeWEy8sTuk2zXv
	5fx3vHVG8cfng3Z/QbQwpV6ARalaMWM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eiWxoaOm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771599710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7uYyRSAdKMRd5mDitWwfp98DtUzANsIQdwTtCyHpDOM=;
	b=eiWxoaOmwgb0pAkEFC0uZICLf/atzTI7G+MMg0vSEcFLMqvNUuXoSh+rB9ycz480oZxCvT
	8QYyAYXMvdY97oH0gyIzRCnVfbtqdmhpZaWKgHnk5kA1ma/XHEUBchxW2XygTtbiNd75mm
	zuWETATkXg5f+82TcIZXmPEt5t4+S3U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A5153EA65;
	Fri, 20 Feb 2026 15:01:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WLiQJF53mGlcRQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 20 Feb 2026 15:01:50 +0000
Message-ID: <e99744196d8a0ca2bffec1d13109eea071c99096.camel@suse.com>
Subject: linux-scsi project on GitHub & SCSI user space utilities maintenance
From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Cc: Paul Evans <pevans@redhat.com>, =?UTF-8?Q?Tom=C3=A1=C5=A1_B=C5=BEatek?=	
 <tbzatek@redhat.com>, Hannes Reinecke <hare@suse.de>, Lee Duncan	
 <lduncan@suse.com>, Martin Wilck <martin.wilck@suse.com>, Bart Van Assche	
 <bvanassche@acm.org>, Mike Christie <michael.christie@oracle.com>, James
 Bottomley <James.Bottomley@HansenPartnership.com>, Chris Hofstaedtler
 <ze1ha@debian.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Daniel
 Horak <dhorak@redhat.com>
Date: Fri, 20 Feb 2026 16:01:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[redhat.com,suse.de,suse.com,acm.org,oracle.com,HansenPartnership.com,debian.org,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EF82A5BCE3

Hi Martin,

a while ago you created the linux-scsi organization on GitHub. Thanks
again for that. I think it's time that we move forward with this
organization. While we have clones of the repositories there that were
previously maintained by Doug Gilbert, we haven't applied any changes,
or moved any issues or PRs yet.

IMO the main problem is currently that people are lacking permissions
to access the repositories in the linux-scsi organization. I assume
that you have full admin rights. I think that we need 1-2 more people
with maintainer rights, and a few more people with write permissions,
to share the work load.

In private communication during the past two weeks, Red Hat and SUSE
have collected a few volunteers that would be willing to join this
organization:

Paul Evans <pevans@redhat.com> @pauljevans
Tom=C3=A1=C5=A1 B=C5=BEatek <tbzatek@redhat.com>, @tbzatek (as Paul's backu=
p)
Lee Duncan <lduncan@suse.com>, @gonzoleeman
Hannes Reinecke <hare@suse.de>, @hreinecke
Martin Wilck <mwilck@suse.com>, @mwilck

IMPORTANT: This is NOT an attempt by Red Hat and SUSE to take over the
organization. Quite to the contrary, we would be very happy if other
people and organizations / distributions joined in. I've added some
people the CC list who might be interested; I'd be grateful if this
message could be forwarded to others as well.

We'd be grateful if you could grant permissions to some of us.

None of the volunteers above will be able to devote a lot of resources
to the maintenance of these projects, but we hope to be able to
maintain them such that bugs get fixed and reasonable PRs merged.
Unless some additional and highly motivated volunteers show up, I
suppose this means that the tools will remain in maintenance mode.

Once permissions are set up, we'd start to migrate the open issues and
PRs from Doug's repos to the linux-scsi ones, and then start working on
them.

Best regards,
Martin
