From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Thu, 20 Aug 2009 17:43:41 +0200
Message-ID: <200908201743.50167.eike-kernel@sf-tec.de>
References: <20090816004705.GA7347@infradead.org> <4A8D5442.1000302@redhat.com> <4A8D5FDB.7080505@rtr.ca>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1495252.XOLBvpv6Aq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47513 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZHTPn5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 11:43:57 -0400
In-Reply-To: <4A8D5FDB.7080505@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>, Neil Brown <neilb@suse.de>

--nextPart1495252.XOLBvpv6Aq
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mark Lord wrote:
> Ric Wheeler wrote:
> > Note that returning consistent data is critical for devices that are
> > used in a RAID group since you will need each RAID block that is used to
> > compute the parity to continue to return the same data until you
> > overwrite it with new data :-)
> >
> > If we have a device that does not support this (or is misconfigured not
> > to do this), we should not use those devices in an MD group & do discard
> > against it...
>
> ..
>
> Well, that's a bit drastic.  But the RAID software should at least
> not issue TRIM commands in ignorance of such.
>
> Would it still be okay to do the TRIMs when the entire parity stripe
> (across all members) is being discarded?  (As opposed to just partial
> data there being dropped)

I think there might be a related usecase that could benefit from=20
TRIM/UNMAP/whatever support in file systems even if the physical devices do=
=20
not support that. I have a RAID5 at work with LVM over it. This week I dele=
ted=20
an old logical volume of some 200GB that has been moved to a different volu=
me=20
group, tomorrow I will start to replace all the disks in the raid with bigg=
er=20
ones. So if the LVM told the raid "hey, this space is totally garbage from =
now=20
on" the raid would not have to do any calculation when it has to rebuild th=
at=20
but could simply write fixed patterns to all disks (e.g. 0 to first data, 0=
 to=20
second data and 0 as "0 xor 0" to parity). With the knowledge that some of =
the=20
underlying devices would support "write all to zero" this operation could b=
e=20
speed up even more, with "write all fixed pattern" every unused chunk would=
 go=20
down to a single write operation (per disk) on rebuild regardless which par=
ity=20
algorithm is used.

And even if things are in use the RAID can benefit from such things. If we=
=20
just define that every unmapped space will always be 0 when read and I writ=
e=20
to a raid volume and the other part of the checksum calculation is unmapped=
=20
checksumming becomes easy as we already know half of the values before: 0. =
So=20
we can save the reads from the second data stripe and most of the calculati=
on.
"dd if=3D/dev/md0" on an unmapped space is more or less the same as "dd=20
if=3D/dev/zero" than.

I only fear that these things are too obviously as I would be the first to=
=20
have this idea ;)

Greetings,

Eike

--nextPart1495252.XOLBvpv6Aq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqNbzYACgkQXKSJPmm5/E5LNQCdFqJ/6Rb+l/1Jdd8GNwG86+MF
g8sAmwXujLHOGE0WsLOAchKRWCzuayAG
=PtAF
-----END PGP SIGNATURE-----

--nextPart1495252.XOLBvpv6Aq--
