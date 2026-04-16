Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A133F595
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 09:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776333068; cv=none; b=F9XWU447Jcs5QY2sZg9dz27Qp37dotXBsgTAwwv5oSP638VVgW9hnUa0cqwTh9lH4xhOluaOP06wNTBGEJZ5RyMl40jgv7xCdTSBP0dawFIYXSf6/yowdjVJQPdP5f6z+Y4fLXuH/HkQ4c8lhqfFmfdrUUZ4CG/kRRzdg7AlFIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776333068; c=relaxed/simple;
	bh=GY+VciEXeY9KyLOq+bVVRV42Ofo9foFB9+0GcVcBoP0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GnMEiFUl8VgI0sGeriYrbvltoyZ5b7AX9clKdYS3+B3yqS0k3JSYYlUP0Y0XoXne085o/tf4Ix0B3oa58wSu2MBlQ5FenLzHgwuytFEDt6UBxpqhIumqbGqe085/oUwXiif4bsYENjfl439rsK3N95SoPTr95BatnnBIUAbVzUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA5A55BD00;
	Thu, 16 Apr 2026 09:51:05 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 558474BECD;
	Thu, 16 Apr 2026 09:51:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KrbREwmx4GnDAQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 16 Apr 2026 09:51:05 +0000
Message-ID: <84dd73f38214c2ff593a9f86d46d2100e111329a.camel@suse.com>
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
Date: Thu, 16 Apr 2026 11:51:04 +0200
In-Reply-To: <e8843bfe-b4cb-4639-977e-a278f4578887@suse.de>
References: <20260415204850.799431-1-mwilck@suse.com>
	 <20260415204850.799431-3-mwilck@suse.com>
	 <e8843bfe-b4cb-4639-977e-a278f4578887@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: AA5A55BD00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu, 2026-04-16 at 08:04 +0200, Hannes Reinecke wrote:
> On 4/15/26 22:48, Martin Wilck wrote:
> > Since 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
> > and
> > multi-channel scans"), a wildcard scan on a SAS host scans all
> > channels.
> > This can cause excessive resource usage and even system freeze with
> > some controllers, e.g. smartpqi. smartpqi and other drivers provide
> > the scan_start() and scan_finished() methods to scan devices
> > efficiently. Instead of blindly scanning every device, use these
> > methods to do the wildcard scan when available.
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
> > Cc: Yihang Li <liyihang9@h-partners.com>
> > Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> > Cc: John Garry <john.g.garry@oracle.com>
> >=20
> > ----
> > This patch has been tested successfully with smartpqi, but it would
> > affect other drivers that provide scan_start(), and we don't have
> > hardware to test them all. Affected drivers are aic94xx, hisi_sas,
> > hpsa, isci, mpi3mr, mpt3sas, mvsas, pm8001, and smartpqi.
> > I cc'd the maintainers of these drivers above.
> > ---
> > =C2=A0 drivers/scsi/scsi_transport_sas.c | 26 +++++++++++++++++++++++++=
+
> > =C2=A0 1 file changed, 26 insertions(+)
> >=20
> > diff --git a/drivers/scsi/scsi_transport_sas.c
> > b/drivers/scsi/scsi_transport_sas.c
> > index 1341270..2231609d 100644
> > --- a/drivers/scsi/scsi_transport_sas.c
> > +++ b/drivers/scsi/scsi_transport_sas.c
> > @@ -31,6 +31,7 @@
> > =C2=A0 #include <linux/string.h>
> > =C2=A0 #include <linux/blkdev.h>
> > =C2=A0 #include <linux/bsg.h>
> > +#include <linux/delay.h>
> > =C2=A0=20
> > =C2=A0 #include <scsi/scsi.h>
> > =C2=A0 #include <scsi/scsi_cmnd.h>
> > @@ -1702,6 +1703,26 @@ static void scan_channel_zero(struct
> > Scsi_Host *shost, uint id, u64 lun)
> > =C2=A0=C2=A0	}
> > =C2=A0 }
> > =C2=A0=20
> > +/*
> > + * For wildcard scans on hosts that provide a scan_start method,
> > + * use that instead of blindly scanning everything.
> > + */
> > +static int sas_user_scan_with_scan_start(struct Scsi_Host *shost)
> > +{
> > +	unsigned long start;
> > +
> > +	if (!shost->hostt->scan_finished || !shost->hostt-
> > >scan_start)
> > +		return 1;
> > +
> Technically 'scan_start' is optional (cf do_scsi_scan_host()), so it
> would be better to just check for 'scan_finished'.

That's why I chose to check for `scan_start`. I wanted to activate this
code path only for those drivers that provide both functions.=C2=A0

I have to say I don't quite understand in which scenario it makes sense
to check for the scan being finished without starting it beforehand.
Perhaps it works at driver load / boot time, but in the current use
case I have no clue how it would. Somehow we need to tell the driver
that it must trigger probing when the user writes to the "scan" sysfs
attribute.

>=20
> > +	start =3D jiffies;
> > +	shost->hostt->scan_start(shost);
> > +
> > +	while (!shost->hostt->scan_finished(shost, jiffies -
> > start))
> > +		msleep(10);
> > +
> > +	return 0;
> > +}
> > +
> > =C2=A0 /*
> > =C2=A0=C2=A0 * SCSI scan helper
> > =C2=A0=C2=A0 */
> > @@ -1721,6 +1742,11 @@ static int sas_user_scan(struct Scsi_Host
> > *shost, uint channel,
> > =C2=A0=C2=A0		break;
> > =C2=A0=20
> > =C2=A0=C2=A0	case SCAN_WILD_CARD:
> > +
> > +		if (id =3D=3D SCAN_WILD_CARD && lun =3D=3D SCAN_WILD_CARD
> > +			&& !sas_user_scan_with_scan_start(shost))
> > +			return 0;
> > +
> > =C2=A0=C2=A0		mutex_lock(&sas_host->lock);
> > =C2=A0=C2=A0		scan_channel_zero(shost, id, lun);
> > =C2=A0=C2=A0		mutex_unlock(&sas_host->lock);
>=20
> Wouldn't it be better to export do_scsi_scan_host() and call it
> here, seeing that it's doing exactly the same thing?

Sure, I can do that if it's preferred. But currently my function does
not do exactly the same thing, so I'd need to refactor
do_scsi_scan_host() slightly.

Thanks,
Martin
