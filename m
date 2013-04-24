From: Hannes Reinecke <hare@suse.de>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 14:12:33 +0200
Message-ID: <5177CC31.7090700@suse.de>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de> <5177CB23.5090802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673Ab3DXMMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 08:12:35 -0400
In-Reply-To: <5177CB23.5090802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 04/24/2013 02:08 PM, Paolo Bonzini wrote:
> Il 24/04/2013 14:07, Hannes Reinecke ha scritto:
>> On 04/24/2013 01:17 PM, Paolo Bonzini wrote:
>>> Il 23/04/2013 22:07, James Bottomley ha scritto:
>>>> On Tue, 2013-04-23 at 15:41 -0400, Ric Wheeler wrote:
>>>>> For many years, we have used WCE as an indication that a device h=
as a volatile=20
>>>>> write cache (not just a write cache) and used this as a trigger t=
o send down=20
>>>>> SYNCHRONIZE_CACHE commands as needed.
>>>>>
>>>>> Some arrays with non-volatile cache seem to have WCE set and simp=
ly ignore the=20
>>>>> command.
>>>>
>>>> I bet they don't; they probably obey the spec.  There's a SYNC_NV =
bit
>>>> which if unset (which it is in our implementation) means only sync=
 your
>>>> non-NV cache.  For a device with all NV, that equates to nop.
>>>
>>> Isn't it the other way round?
>>>
>>> SYNC_NV =3D 0 means "sync all your caches to the medium", and it's =
what we do.
>>>
>>> SYNC_NV =3D 1 means "sync volatile to non-volatile", and it's what =
Ric wants.
>>>
>>> So we should set SYNC_NV=3D1 if NV_SUP is set, perhaps only if the =
medium
>>> is non-removable just to err on the safe side.
>>
>> Or use 'WRITE_AND_VERIFY' here; that's guaranteed to hit the disk.
>> Plus it even has a guarantee about data consistency on the disk,
>> which the normal WRITE command has not.
>=20
> The point is to _avoid_ hitting the disk. :)
>=20
Ah. Really?

Why do we discuss SYNCHRONIZE CACHE then?
I was under the impression that we're talking various 'barriers'
(or rather 'flush' nowadays) implementations.
Which require that some data needs to be written to disk before
continuing.

Or did I somehow misread the thread?

Confused,

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
