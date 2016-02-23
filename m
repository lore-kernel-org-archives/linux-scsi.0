From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2][RESEND] scsi_transport_fc: LUN masking
Date: Tue, 23 Feb 2016 18:21:12 +0800
Message-ID: <56CC3298.2080001@suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
 <DDB9C85B850785449757F9914A034FCB44535951@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbcBWKVg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 05:21:36 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44535951@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/22/2016 07:39 PM, Seymour, Shane M wrote:
> Hi Hannes,
>=20
> How do you know that a request for an async scan is complete (I'm ass=
uming that you get
> add or change udev events)? Assuming that someone has manually starte=
d a scan on something
> (e.g. some newly presented devices after boot) and all scans are goin=
g
to be async how
> do you when it is complete rather than waiting in a work queue? An
example may be a sysfs
> file that contains unscanned, pending, scanning, scanned so you know
when it's complete
> at the appropriate level in sysfs (the hba and the rports) so you kno=
w
when can continue
> if you're polling the status (e.g. checking as part of system admin
work with newly
> presented rports so you can then do something with them).
>
Thing is, I don't.

We have had a similar discussion with the IBM zfcp folks, that it would
be desirable to have a marker in sysfs telling us that the rport is
stable (ie no scanning in progress).
However, this cannot be at the rport level (as the rport itself might b=
e
going away), but rather at some higher level (eg fc_host).

But this has nothing to do with the patchset, right?
We're just disabling the (existing) scan callback, and retrigger it onc=
e
the sysfs attribute has been cleared.

We don't change the behaviour during scanning with this patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
