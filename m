From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI scanning behavior
Date: Wed, 26 Aug 2015 15:02:43 +0200
Message-ID: <55DDB8F3.3020308@suse.de>
References: <55D65082.6020504@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbbHZNCp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 09:02:45 -0400
In-Reply-To: <55D65082.6020504@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 08/21/2015 12:11 AM, Brian King wrote:
> In one of our SAN test labs where there is some storage controller er=
ror injection going on,
> I'm seeing some interesting behavior. We are getting into a scenario,=
 when the target is coming
> back where we are going through SCSI scan for it and the Report LUNs =
we are issuing to it times
> out, so we fall back to a sequential LUN scan. When performing the se=
quential LUN scan, we=20
> end up adding a bunch of LUNs than we didn't previously see, 512 in f=
act. The target is reporting
> PQ=3D1, PDT=3D0 for every LUN that doesn't exist. When Report LUNs *d=
oes work*, it doesn't report
> these LUNs.=20
>=20
> In net, we end up with a different result if we do a sequential LUN s=
can compared to a report LUNs
> scan.
>=20
> Now, one could argue this is a defect in the SCSI target, since SPC s=
ays:
>=20
> The REPORT LUNS parameter data should be returned even though the dev=
ice server is not ready for other
> commands. The report of the logical unit inventory should be availabl=
e without incurring any media access
> delays. If the device server is not ready with the logical unit inven=
tory or if the inventory list is null for the
> requesting I_T nexus and the SELECT REPORT field set to 02h, then the=
 device server shall provide a default
> logical unit inventory that contains at least LUN 0 or the REPORT LUN=
S well known logical unit (see 8.2). A
> non-empty peripheral device logical unit inventory that does not cont=
ain either LUN 0 or the REPORT LUNS
> well known logical unit is valid.
>=20
Hey, join the club. I've had a similar array, which were returning a
default inventory during bootup. Leaving us with no chance to detect
if the default inventory was the correct one or not.

I even posted a patch some time ago; if you wish I can drag it out.

> However, I'm still left wondering why we are adding PQ=3D1, PDT=3D0 d=
evices in the sequential LUN scan at all.
> Are there media changer devices out there that we've seen respond lik=
e this? Even so, does it make sense
> to add PQ=3D1, PDT=3D0 LUNs for LUN > 0?
>=20
Yes, unfortunately we need this. NetApp arrays have a habit of
returning 'PQ=3D1' for unconnected LUN 0, even though higher LUNs are
present. So we need to add devices for PQ=3D1, otherwise we wouldn't
be able to scan them.
We _might_ be able to tweak this by ignoring devices with PQ=3D1 and
LUN!=3D0; however, it might break other things.

As a net result, do avoid sequential scan if at all possible.
I would rather work on getting REPORT LUNs to reliably report data.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
