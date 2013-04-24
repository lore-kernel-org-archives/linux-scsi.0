From: Hannes Reinecke <hare@suse.de>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 13:30:35 +0200
Message-ID: <5177C25B.1080709@suse.de>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab3DXLak (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 07:30:40 -0400
In-Reply-To: <1366747622.1939.6.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 04/23/2013 10:07 PM, James Bottomley wrote:
> On Tue, 2013-04-23 at 15:41 -0400, Ric Wheeler wrote:
>> For many years, we have used WCE as an indication that a device has =
a volatile=20
>> write cache (not just a write cache) and used this as a trigger to s=
end down=20
>> SYNCHRONIZE_CACHE commands as needed.
>>
>> Some arrays with non-volatile cache seem to have WCE set and simply =
ignore the=20
>> command.
>=20
> I bet they don't; they probably obey the spec.  There's a SYNC_NV bit
> which if unset (which it is in our implementation) means only sync yo=
ur
> non-NV cache.  For a device with all NV, that equates to nop.
>=20
>> Some arrays with non-volatile cache seem to not set WCE.
>>
>> Others arrays with non-volatile cache - our problem arrays - set WCE=
 and do=20
>> something horrible and slow when sent the SYNCHRONIZE_CACHE commands=
=2E
>=20
> These arrays sound to be out of spec, so we should probably just
> blacklist them.
>=20
Don't think so.
There is no time limit for the SYNCHRONIZE_CACHE command, so the
array might take all day to write out the cache.

In fact, I've recently had a rather heated discussion with a certain
storage vendor which reserved his right to take up to several
seconds when flushing the cache.
Might be that we're in fact talking about the same one ... are we on
a naming-and-shaming policy here ?
If so I could tell you some really _interesting_ details about their
behaviour ...

Also note that SYNCHRONIZE_CACHE was always problematic; and as
we're not even setting the LBA range we're even have cross-speak
when issuing it to partitioned devices.

>> Note that for file systems, you can override this behavior by mounti=
ng with our=20
>> barriers disabled (mount -o nobarrier .....). There is currently no =
way do=20
>> disable this for anything using the device directly, not through the=
 file system.
>>
>> Some applications run against block devices - not through a file sys=
tem - and=20
>> want not to slow to a crawl when they have an array in my problem se=
t.
>>
>> Giving them a hook to ignore WCE seems to be a hack, but one that wo=
uld resolve=20
>> issues with users who won't want to wait months (years?) for us to c=
onvince the=20
>> array vendors.
>>
>> Is this a hook worth doing?
>=20
> We already have the ability to set the cache type in sysfs.  It tries=
 to
> do a mode select back to the array, but the USB guys want it for the
> reverse problem (write back cache behind bridge declared as write
> through).
>=20
You can always set the 'IMMED' bit for these arrays :-)

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
