From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Thu, 05 Feb 2015 10:55:50 -0800
Message-ID: <1423162550.5848.21.camel@HansenPartnership.com>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
	 <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com>
	 <5B997489-2D5C-4F85-BAB8-317E62F694E5@kolumbus.fi>
	 <995891679.6002631.1423158020737.JavaMail.zimbra@redhat.com>
	 <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
	 <20150205185040.GB9303@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57484 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbbBESzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 13:55:53 -0500
In-Reply-To: <20150205185040.GB9303@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: "\"Kai =?ISO-8859-1?Q?M=E4kisara?= (Kolumbus)\"" <kai.makisara@kolumbus.fi>, Laurence Oberman <loberman@redhat.com>, Laurence Oberman <oberman.l@gmail.com>, Shane M Seymour <shane.seymour@hp.com>, linux-scsi@vger.kernel.org, jeffm@suse.com

On Thu, 2015-02-05 at 18:50 +0000, Bryn M. Reeves wrote:
> On Thu, Feb 05, 2015 at 07:46:32PM +0200, "Kai M=C3=A4kisara (Kolumbu=
s)" wrote:
> > > On 5.2.2015, at 19.40, Laurence Oberman <loberman@redhat.com> wro=
te:
> > > From: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
> > > I still think that the tape statistics should be exported like th=
e statistics of =E2=80=9Creal=E2=80=9D block devices, i.e., one sysfs f=
ile exporting on a single line the statistics that temporally belong to=
gether. James rejected this approach. I am leaving the decision about t=
his code to him. I will neither ack nor nak this code.
> > >=20
> > > I missed the earlier conversations with James, I will go search f=
or them.
> > > Do you mean add them so they are similar to the /proc/diskstats
>=20
> http://comments.gmane.org/gmane.linux.scsi/80497
>=20
> On Fri, Feb 22 2013 James Bottomley wrote:
> >>>> I'm afraid we can't do it the way you're proposing.  files in sy=
sfs must
> >>>> conform to the one value per file rule (so we avoid the ABI nast=
iness
> >>>> that plagues /proc).  You can create a stat directory with a bun=
ch of
> >>>> files, but not a single file that gives all values.
>=20
> Documentation/filesystems/sysfs.txt does not agree:
>=20
>   "Attributes should be ASCII text files, preferably with only one va=
lue
>   per file. It is noted that it may not be efficient to contain only =
one
>   value per file, so it is socially acceptable to express an array of
>   values of the same type."
>=20
> There's also ample precedent for this: sysfs disk and partition stats=
,
> SELinux cache and hash table stats (which have a pretty yucky 2d int
> array with column headers and a name: val format respectively).
>=20
> There's also a bunch of multivariate name=3Dvalue format stats files =
in
> the cgroups sysfs tree.
>=20
> > Not exactly. I mean the data exported in sysfs, for example:
> >=20
> > > cat /sys/block/sda/sda1/stat
> >   159740     9006  5941506    64461   124724    55907 12772208  359=
8677        0   299875  3663235
>=20
> I'd prefer to consume tape stats in this format too; it follows the
> principle of least surprise since it's shared with every other IO sta=
ts
> source (including device-mapper statistics) and it simplifies handlin=
g
> the counters in user space.

OK, the sysfs bikeshedders hang out on linux-api

https://www.kernel.org/doc/man-pages/linux-api-ml.html

If you can convince them, we'll do the single file approach.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
