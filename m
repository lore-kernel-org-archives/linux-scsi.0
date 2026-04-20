Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190C4344D83
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 11:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682889; cv=none; b=gNiNcBSpzUZVlzfIOkb8zkMEH+SzsT5o5vMWVHnU2XIsPbdEpBX8u0Yfwk2Jfj6dNc4Ihh3MWA6tYval9cnbYOlshQocho+Y8m1muT3x54UdYmMScIHjLQ0WKgK6X3wbGVkKLpo3NOboI0SvO2SX3JY2Pw5H2UacamcDaJ79pHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682889; c=relaxed/simple;
	bh=6qtJglX76vLEtjUsCoyA4jM8K4jh6BjLd4xjLMJzmTw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W77tnnDsBd+P+A1ABgkRp4hMh7w9mjGa5cu7h4e9NcOEp7nRQv3UXdsIe3/upgHWFsap8XR+6jK85GAojj6FhSjjX4X0OZafGbPgTXdXfEWPCoJjevFLy3SD5Tr1Jbi48yOf7bGVT0N2+JM+X9QC4zyNREkZ1Z3DfOw6yxEOQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q5GRnD9o; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HyKNX0n0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q5GRnD9o";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HyKNX0n0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55DE06A7D6;
	Mon, 20 Apr 2026 11:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776682885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQ9+alQMnlcHpCF0APIDTzNW0NXm3sz0kECDOCjkMEk=;
	b=Q5GRnD9oijwLtsNp70TbaIb2NiRyBIP1j9IkVL/Nv7IYmhqJlEknzKefWihjP/tvWGG/s7
	qru3cjANpIJDiaIKGzUZnr6bArGwiyAiblfbxCuikTiUwISf4+vQtflQ7BX3qGAw0HoLzS
	eVPW9HyawePpE8ZzuunldmtduCA+2mI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776682884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQ9+alQMnlcHpCF0APIDTzNW0NXm3sz0kECDOCjkMEk=;
	b=HyKNX0n0eby6LSrRi/q2xT48x07OHgD+wLZWNzqZ8WMp2GoKY8HLF06OnhOhdNB4/Ypao6
	w8u/iLpwI/QPdBHjwacjTzLS+L8j/YjYgb1u8alQvq+UIEfxubnCeHRWSpj4vSxTm/SULp
	draEWk3nvWc5hHnUVGBI8h68I8/aHsc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3199593AE;
	Mon, 20 Apr 2026 11:01:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3mJFOoMH5mmGIgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 20 Apr 2026 11:01:23 +0000
Message-ID: <b5f393cbaad0677129878415dd7864a8683d23d9.camel@suse.com>
Subject: Re: [PATCH 2/2] scsi: sas_user_scan: use scan_start if available
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Don Brace
	 <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>, 
	storagedev@microchip.com, Ranjan Kumar <ranjan.kumar@broadcom.com>, Sathya
 Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai
 <kashyap.desai@broadcom.com>, Sumit Saxena	 <sumit.saxena@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com, 	MPT-FusionLinux.pdl@broadcom.com, Yihang
 Li <liyihang9@h-partners.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, John
 Garry <john.g.garry@oracle.com>
Date: Mon, 20 Apr 2026 13:01:23 +0200
In-Reply-To: <abdf7c80-7cf4-489f-a105-5f0c4b6e206b@suse.de>
References: <20260415204850.799431-1-mwilck@suse.com>
	 <20260415204850.799431-3-mwilck@suse.com>
	 <e8843bfe-b4cb-4639-977e-a278f4578887@suse.de>
	 <84dd73f38214c2ff593a9f86d46d2100e111329a.camel@suse.com>
	 <abdf7c80-7cf4-489f-a105-5f0c4b6e206b@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,oracle.com:email,microchip.com:email,suse.com:mid,suse.com:email,ionos.com:email,broadcom.com:email,h-partners.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[microchip.com:email,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,ionos.com:email,h-partners.com:email,oracle.com:email,broadcom.com:email]
X-Spam-Flag: NO

On Mon, 2026-04-20 at 12:35 +0200, Hannes Reinecke wrote:
> On 4/16/26 11:51, Martin Wilck wrote:
> > On Thu, 2026-04-16 at 08:04 +0200, Hannes Reinecke wrote:
> > > On 4/15/26 22:48, Martin Wilck wrote:
> > > > Since 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle
> > > > wildcard
> > > > and
> > > > multi-channel scans"), a wildcard scan on a SAS host scans all
> > > > channels.
> > > > This can cause excessive resource usage and even system freeze
> > > > with
> > > > some controllers, e.g. smartpqi. smartpqi and other drivers
> > > > provide
> > > > the scan_start() and scan_finished() methods to scan devices
> > > > efficiently. Instead of blindly scanning every device, use
> > > > these
> > > > methods to do the wildcard scan when available.
> > > >=20
> > > > Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle
> > > > wildcard
> > > > and multi-channel scans")
> > > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > > Cc: Don Brace <don.brace@microchip.com>
> > > > Cc: storagedev@microchip.com
> > > > Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > > > Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> > > > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > > > Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> > > > Cc: mpi3mr-linuxdrv.pdl@broadcom.com
> > > > Cc: MPT-FusionLinux.pdl@broadcom.com
> > > > Cc: Yihang Li <liyihang9@h-partners.com>
> > > > Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> > > > Cc: John Garry <john.g.garry@oracle.com>
> > > >=20
> > > > ----
> > > > This patch has been tested successfully with smartpqi, but it
> > > > would
> > > > affect other drivers that provide scan_start(), and we don't
> > > > have
> > > > hardware to test them all. Affected drivers are aic94xx,
> > > > hisi_sas,
> > > > hpsa, isci, mpi3mr, mpt3sas, mvsas, pm8001, and smartpqi.
> > > > I cc'd the maintainers of these drivers above.
> > > > ---
> > > > =C2=A0=C2=A0 drivers/scsi/scsi_transport_sas.c | 26
> > > > ++++++++++++++++++++++++++
> > > > =C2=A0=C2=A0 1 file changed, 26 insertions(+)
> > > >=20
> > > > diff --git a/drivers/scsi/scsi_transport_sas.c
> > > > b/drivers/scsi/scsi_transport_sas.c
> > > > index 1341270..2231609d 100644
> > > > --- a/drivers/scsi/scsi_transport_sas.c
> > > > +++ b/drivers/scsi/scsi_transport_sas.c
> > > > @@ -31,6 +31,7 @@
> > > > =C2=A0=C2=A0 #include <linux/string.h>
> > > > =C2=A0=C2=A0 #include <linux/blkdev.h>
> > > > =C2=A0=C2=A0 #include <linux/bsg.h>
> > > > +#include <linux/delay.h>
> > > > =C2=A0=C2=A0=20
> > > > =C2=A0=C2=A0 #include <scsi/scsi.h>
> > > > =C2=A0=C2=A0 #include <scsi/scsi_cmnd.h>
> > > > @@ -1702,6 +1703,26 @@ static void scan_channel_zero(struct
> > > > Scsi_Host *shost, uint id, u64 lun)
> > > > =C2=A0=C2=A0=C2=A0	}
> > > > =C2=A0=C2=A0 }
> > > > =C2=A0=C2=A0=20
> > > > +/*
> > > > + * For wildcard scans on hosts that provide a scan_start
> > > > method,
> > > > + * use that instead of blindly scanning everything.
> > > > + */
> > > > +static int sas_user_scan_with_scan_start(struct Scsi_Host
> > > > *shost)
> > > > +{
> > > > +	unsigned long start;
> > > > +
> > > > +	if (!shost->hostt->scan_finished || !shost->hostt-
> > > > > scan_start)
> > > > +		return 1;
> > > > +
> > > Technically 'scan_start' is optional (cf do_scsi_scan_host()), so
> > > it
> > > would be better to just check for 'scan_finished'.
> >=20
> > That's why I chose to check for `scan_start`. I wanted to activate
> > this
> > code path only for those drivers that provide both functions.
> >=20
> > I have to say I don't quite understand in which scenario it makes
> > sense
> > to check for the scan being finished without starting it
> > beforehand.
> > Perhaps it works at driver load / boot time, but in the current use
> > case I have no clue how it would. Somehow we need to tell the
> > driver
> > that it must trigger probing when the user writes to the "scan"
> > sysfs
> > attribute.
> >=20
> The point here is not whether the functions have been called, but
> rather
> whether these function (callbacks) _exist_.

Sure.=20

> Technically it's possible to have a driver which just provides as=20
> 'scan_finished' callback but not 'scan_start' callback.
> Some drivers (like ipr or ibmvfc) have their own automatic probing,
> so
> 'scan_start' is pointless, and 'scan_finished' merely waits for the
> internal probing to finish.

Right. Automatic probing in these drivers will (I suppose) be started
at driver load time, and possibly on some external event, like an RSCN.

But the user expects something to happen when she executes=C2=A0
"echo - - - > .../scan". Thus I need a method to tell the driver that
it should (re)start probing. If no scan_start() callback exists, simply
waiting for scan_finished() will in the best case be a no-op with no
probing having happened, and in the worst case hang forever.=20

Therefore, for these drivers, I can't replace the current wildcard
scanning algorithm by an approach using just scan_finished().

Perhaps it's possible to add patches on top that implement scan_start()
for those drivers that currently provide scan_finished() but not
scan_start()1. But that's a different topic. This patch changes
behavior of quite a few drivers already, and I'd rather not add even
more.

> (I think :-)
>=20
> > >=20
> > > > +	start =3D jiffies;
> > > > +	shost->hostt->scan_start(shost);
> > > > +
> > > > +	while (!shost->hostt->scan_finished(shost, jiffies -
> > > > start))
> > > > +		msleep(10);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > =C2=A0=C2=A0 /*
> > > > =C2=A0=C2=A0=C2=A0 * SCSI scan helper
> > > > =C2=A0=C2=A0=C2=A0 */
> > > > @@ -1721,6 +1742,11 @@ static int sas_user_scan(struct
> > > > Scsi_Host
> > > > *shost, uint channel,
> > > > =C2=A0=C2=A0=C2=A0		break;
> > > > =C2=A0=C2=A0=20
> > > > =C2=A0=C2=A0=C2=A0	case SCAN_WILD_CARD:
> > > > +
> > > > +		if (id =3D=3D SCAN_WILD_CARD && lun =3D=3D
> > > > SCAN_WILD_CARD
> > > > +			&&
> > > > !sas_user_scan_with_scan_start(shost))
> > > > +			return 0;
> > > > +
> > > > =C2=A0=C2=A0=C2=A0		mutex_lock(&sas_host->lock);
> > > > =C2=A0=C2=A0=C2=A0		scan_channel_zero(shost, id, lun);
> > > > =C2=A0=C2=A0=C2=A0		mutex_unlock(&sas_host->lock);
> > >=20
> > > Wouldn't it be better to export do_scsi_scan_host() and call it
> > > here, seeing that it's doing exactly the same thing?
> >=20
> > Sure, I can do that if it's preferred. But currently my function
> > does
> > not do exactly the same thing, so I'd need to refactor
> > do_scsi_scan_host() slightly.
> >=20
> Please do, just to make clear where the differences are.
> (And to show future reviewers that we _did_ think about it :).

Ok, will do.

Thanks,
Martin
