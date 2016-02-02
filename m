From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Tue, 2 Feb 2016 10:03:07 +0100
Message-ID: <20160202090307.GO27969@c203.arch.suse.de>
References: <568FE922.9090004@sandisk.com>
 <yq1oachqehs.fsf@sermon.lab.mkp.net>
 <1453251809.2320.56.camel@HansenPartnership.com>
 <20160131185455.00000ef7@localhost>
 <yq160y7q5ku.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbcBBJDL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 04:03:11 -0500
Content-Disposition: inline
In-Reply-To: <yq160y7q5ku.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sebastian Herbszt <herbszt@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dick Kennedy <dick.kennedy@avagotech.com>

On Mon, Feb 01, 2016 at 08:11:29PM -0500, Martin K. Petersen wrote:
> >>>>> "Sebastian" =3D=3D Sebastian Herbszt <herbszt@gmx.de> writes:
>=20
> >> The only change from the current workflow is that the DEL transiti=
on
> >> (now the reaped flag) is done before the spin lock is dropped whic=
h
> >> would fix a tiny window for two threads both trying to remove the
> >> same target, but there's nothing that could possibly fix an iterat=
ive
> >> soft lockup caused by restarting the loop, which is what the
> >> changelog says.
>=20
> Sebastian> James, Martin, what's the status of this patch?  I still h=
it
> Sebastian> the reported soft lockup on 4.5-rc1.
>=20
> And you have verified that Bart's patch applied on top of 4.5-rc1 sti=
ll
> fixes the lockup? (I know you tested a previous version)
>=20

I had an off list discussion/problem report from Dick Kennedy, pointed =
him
to this very patch and he verified it solved his problem (a lockup like
reported by Sebastian).

I'm not sure if he tested v4.4.X or v4.5-rcX though.

> I am concerned about queuing something as a stable fix if it is just
> masking a fundamental underlying problem. James' comment suggests tha=
t
> there is something else going on.
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering


--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
