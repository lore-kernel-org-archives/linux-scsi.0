From: Hannes Reinecke <hare@suse.de>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 14:07:17 +0200
Message-ID: <5177CAF5.6060506@suse.de>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab3DXMHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 08:07:19 -0400
In-Reply-To: <5177BF53.3040305@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 04/24/2013 01:17 PM, Paolo Bonzini wrote:
> Il 23/04/2013 22:07, James Bottomley ha scritto:
>> On Tue, 2013-04-23 at 15:41 -0400, Ric Wheeler wrote:
>>> For many years, we have used WCE as an indication that a device has=
 a volatile=20
>>> write cache (not just a write cache) and used this as a trigger to =
send down=20
>>> SYNCHRONIZE_CACHE commands as needed.
>>>
>>> Some arrays with non-volatile cache seem to have WCE set and simply=
 ignore the=20
>>> command.
>>
>> I bet they don't; they probably obey the spec.  There's a SYNC_NV bi=
t
>> which if unset (which it is in our implementation) means only sync y=
our
>> non-NV cache.  For a device with all NV, that equates to nop.
>=20
> Isn't it the other way round?
>=20
> SYNC_NV =3D 0 means "sync all your caches to the medium", and it's wh=
at we do.
>=20
> SYNC_NV =3D 1 means "sync volatile to non-volatile", and it's what Ri=
c wants.
>=20
> So we should set SYNC_NV=3D1 if NV_SUP is set, perhaps only if the me=
dium
> is non-removable just to err on the safe side.
>=20

Or use 'WRITE_AND_VERIFY' here; that's guaranteed to hit the disk.
Plus it even has a guarantee about data consistency on the disk,
which the normal WRITE command has not.

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
