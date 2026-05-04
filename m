Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972E91C68F
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913933; cv=none; b=ch5aejTUeGWQoXrY3/DLFtmSjpeMfkuPKOjq/PuZ7nOKJj0cOiFWntGAm6kIQELT6Ge1IRxyZsHsGhHFHATejK0I5e6rq1noNfwuOd1crtwHVn+k6cRNP0BX/NtrfWcSPP8pLGLNoTep3+rRRbHBxz4watQEs/BGSLNQuOox3zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913933; c=relaxed/simple;
	bh=F86q7Gjfro5WoJfqOqtAo/NBfc7hvrt0ezhD6y3lvs8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VuTEkDhIjhgR2OYn3Q1WzmGVY7dX7fI4/ms0JuCRzmeABHdjh0rgWZ4KMCe3pv/v/30MLnPo5bUS2+9M4gwubeG01uivpDyb/JKGA5Hn0J7EEkyWRwv+sCy6wm1w41qRLoB0HWAtVC8G7ZVsV55Exx1rz++SFu430VPbkkeOqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KlYAsjp9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KlYAsjp9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KlYAsjp9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KlYAsjp9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE8D35C8D0;
	Mon,  4 May 2026 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777913929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6K3DIcPFTaITC7M0Q6pncxGWN0WaOImZcHg3fMDJ6Jc=;
	b=KlYAsjp98z42NMyfy4wmyZNjwiIxG9M7W34aE3zPMreyCAVC4Lgo5u3YjQogFph4roYz8P
	vYY1uTCSHW/IMDrmo61a5ijgS6x7sswmfEuwOrd/r7RDoVC4yvLhTPPBZqLajHNC8MtAE1
	73bSqZ58knPT+SDMTyeljLm775v8BHg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KlYAsjp9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777913929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6K3DIcPFTaITC7M0Q6pncxGWN0WaOImZcHg3fMDJ6Jc=;
	b=KlYAsjp98z42NMyfy4wmyZNjwiIxG9M7W34aE3zPMreyCAVC4Lgo5u3YjQogFph4roYz8P
	vYY1uTCSHW/IMDrmo61a5ijgS6x7sswmfEuwOrd/r7RDoVC4yvLhTPPBZqLajHNC8MtAE1
	73bSqZ58knPT+SDMTyeljLm775v8BHg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70A6F593A3;
	Mon,  4 May 2026 16:58:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WrFrGknQ+GntcAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 04 May 2026 16:58:49 +0000
Message-ID: <61b4da9dcbee8fd71d1ecb2cfdca5c2408528bd7.camel@suse.com>
Subject: Re: [PATCH v2 0/2] Fix SAS wildcard scan on smartpqi and other
 controllers
From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Ranjan Kumar
	 <ranjan.kumar@broadcom.com>, Don Brace <don.brace@microchip.com>, Hannes
 Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Lee Duncan
	 <lduncan@suse.com>, Yihang Li <liyihang9@h-partners.com>, Jack Wang
	 <jinpu.wang@cloud.ionos.com>, John Garry <john.g.garry@oracle.com>
Date: Mon, 04 May 2026 18:58:48 +0200
In-Reply-To: <yq1y0i4csyi.fsf@ca-mkp.ca.oracle.com>
References: <20260421202018.511388-1-mwilck@suse.com>
	 <yq1y0i4csyi.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: AE8D35C8D0
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.51

Hi Martin, Ranjan, Don, Hannes, all,

I need some advice / guidance.

TL;DR:

- Does it make sense to pursue the idea of this patch by adding proper
locking and making some additional amendments?
- Otherwise, can we revert 37c4e72b0651 and find a different solution
for rescanning NVMe drives on mpt3sas and mpi3mr?

Long version:

Thanks for the link with the Gemini review. My current approach is
arguably too simplistic.

The question is, then, what to do about 37c4e72b0651 ("scsi: Fix
sas_user_scan() to handle wildcard and multi-channel scans"). As a
matter of fact, this commit introduces severe regressions (system
stall) at least for smartpqi and hisi_sas.=C2=A0

Looking back at the discussion about this commit [2], it was submitted
to fix scanning of NVMe drives, which mpt3sas and mpi3mr may present as
SCSI targets in a certain mode of operation, in which these drivers use
the channel number to distinguish NVMe and SCSI devices from each
other. This use of the channel number is inconsistent with how other
SAS drivers use it. Therefore this commit broke SAS scanning for other
drivers. The obvious fix would  be to revert 37c4e72b0651. This is
actually what we (SUSE) have done in our downstream kernel so far.

This would mean that Broadcom would need to come up with a different
way to handle the scanning for mpt3sas and mpi3mr in "Tri-mode".

Other than that: I still believe that the general idea of using
scan_start() and scan_finished() not only for the initial host adapter
scan but also for rescan operations is reasonable.=C2=A0After all, a "dumb"
wildcard scan doesn't make a lot of sense for drivers "which find their
own targets", for which scan_start() and scan_finished were introduced
in 1aa8fab2acf1 ("[SCSI] Make scsi_scan_host work for drivers which
find their own targets").

But the issues pointed out by Gemini are real, and while I could fix
the locking, the problem that some drivers may reinitialize the
hardware in scan_start() is tricky. Some detailed replies on Gemini's
review are appended below.

Thanks,
Martin

[1] https://sashiko.dev/#/patchset/20260421202018.511388-1-mwilck%40suse.co=
m
[2] https://lore.kernel.org/linux-scsi/CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS=
4QohFOFGPqAs8ig@mail.gmail.com/

On Thu, 2026-04-30 at 12:30 -0400, Martin K. Petersen wrote:
>=20
> https://sashiko.dev/#/patchset/20260421202018.511388-1-mwilck%40suse.com


P.S: Detailed replies to Gemini's review:

> Does bypassing scsi_scan_host_selected() here skip necessary power
> management and serialization steps?
>=20
> Typically, wildcard scans go through scsi_scan_host_selected(), which
> secures the host adapter via scsi_autopm_get_host(), checks
> scsi_host_scan_allowed(), and takes shost->scan_mutex.
>
> By calling do_scsi_scan_host() directly, it appears scan_start()
could be
> invoked while the host adapter is runtime-suspended, which might lead
to
> hardware faults.

The call to scsi_scan_host_selected() was introduced in commit
37c4e72b0651, which my patch is intended to fix; before that commit,
scan_mutex was not taken in the sas_user_scan() code path. It's still
explicitly not taken for the important case of scanning channel 0;
sas_user_scan() takes only sas_host->lock, which protects just the rphy
list.

So yes, sas_user_scan_with_scan_start() code path should acquire the
scan_mutex. I suppose that the mutex should be acquired in
sas_user_scan(), actually.

> Also, without holding scan_mutex and checking
scsi_host_scan_allowed(),
> is there a race condition if a sysfs scan is triggered concurrently
with
> driver removal? If scsi_remove_host() tears down the host
asynchronously,
> the while loop in do_scsi_scan_host() might poll shost->hostt-
>scan_finished()
> after the driver module has unloaded, potentially causing a use-
after-free.

True. Taking the scan_mutex should fix this.

> Similarly, multiple concurrent sysfs writes could execute
scan_start()
> simultaneously without scan_mutex protection. Can this corrupt
internal
> driver state?

Right. Again, this can be fixed by taking scan_mutex.

> Additionally, is it safe to repurpose scan_start() for runtime sysfs
> scans?
>=20
> Historically, shost->hostt->scan_start() seems to be used exclusively
> for one-time asynchronous boot initialization in do_scan_async().
>=20
> Many SAS drivers might implement this as a hardware initialization
routine
> that resets physical links.
>=20
> If exposed to a runtime userspace sysfs trigger, could this
unintentionally
> bounce active SAS links, drop active I/O, or cause controller hangs
for
> drivers that assume scan_start() is only used during boot?

This is not the case for smartpqi, but other drivers (e.g. hisi_sas)
actually seem to enable PHYs in the scan_start() code path. Not sure
how this can be fixed in general. AFAICS it would require thorough
understanding of the hardware / firmware of all affected drivers, which
I don't have.

Would it make sense pass a flag to scan_start() indicating whether we
initiate a first-time scan or a rescan, and skip the hardware
initialization in the latter case?
