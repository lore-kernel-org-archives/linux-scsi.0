From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [LSF/MM ATTEND] discuss blk-mq related to DM-multipath
 and status of XCOPY
Date: Thu, 08 Jan 2015 07:31:18 +0100
Message-ID: <54AE2436.2000004@suse.de>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>	<54AA90B1.1030201@suse.de> <yq17fwz8nwb.fsf@sermon.lab.mkp.net>	<54ACEF13.7000508@suse.de> <yq1vbki40ua.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbbAHGbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 01:31:20 -0500
In-Reply-To: <yq1vbki40ua.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/08/2015 12:39 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> Not quite. XCOPY is optional, and the system works well witho=
ut
> Hannes> it.  So the exception handling would need to copy things by h=
and
> Hannes> to avoid regressions.
>=20
> Or defer to user space.
>=20
> But it's really no different from how we do WRITE SAME which may or m=
ay
> not work. If it fails we fall back to writing zeroes.
>=20
> Hannes> Plus XCOPY requires some elaborate setup, and even if those
> Hannes> succeeded the array might still fail the command.  _And_ ther=
e
> Hannes> is no guarantee that that the XCOPY command is actually faste=
r
> Hannes> than the manual procedure.
>=20
> It saves the data a roundtrip on the fabric. That itself may be more
> valuable than a direct bandwidth win if there is concurrent I/O on th=
e
> wire.
>=20
But the array might prioritize 'normal' I/O requests, and treat XCOPY
with a lower priority. So given enough load XCOPY might actually be
slower than a normal copy ...

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
