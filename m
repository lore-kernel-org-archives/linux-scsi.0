From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Fri, 03 Dec 2010 09:06:16 -0600
Message-ID: <1291388776.2881.4.camel@mulgrave.site>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <20101203212453W.fujita.tomonori@lab.ntt.co.jp>
	 <4CF905D1.6050903@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab0LCPGX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 10:06:23 -0500
In-Reply-To: <4CF905D1.6050903@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?ISO-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkolbe@techfak.uni-bielefeld.de, linux-scsi@vger.kernel.org

On Fri, 2010-12-03 at 16:59 +0200, Kai M=C3=A4kisara wrote:
> On 12/03/2010 02:27 PM, FUJITA Tomonori wrote:
> > On Mon, 29 Nov 2010 19:09:46 +0200 (EET)
> > Kai Makisara<Kai.Makisara@kolumbus.fi>  wrote:
> >
> >>> This same behaviour appears when we're doing a few incremental ba=
ckups;
> >>> after a while, it just isn't possible to use the tape drives anym=
ore -
> >>> every I/O operation gives an I/O Error, even a simple dd bs=3D64k
> >>> count=3D10. After a restart, the system behaves correctly until
> >>> -seemingly- another memory pressure situation occured.
> >>>
> >> This is predictable. The maximum number of scatter/gather segments=
 seems
> >> to be 128. The st driver first tries to set up transfer directly f=
rom the
> >> user buffer to the HBA. The user buffer is usually fragmented so t=
hat one
> >> scatter/gather segment is used for each page. Assuming 4 kB page s=
ize, the
> >> maximu size of the direct transfer is 128 x 4 =3D 512 kB.
> >
> > Can we make enlarge_buffer friendly to the memory alloctor a bit?
> >
> > His problem is that the driver can't allocate 2 mB with the hardwar=
e
> > limit 128 segments.
> >
> > enlarge_buffer tries to use ST_MAX_ORDER and if the allocation (256=
 kB
> > page) fails, enlarge_buffer fails. It could try smaller order inste=
ad?
> >
> > Not tested at all.
> >
> >
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index 5b7388f..119544b 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -3729,7 +3729,8 @@ static int enlarge_buffer(struct st_buffer * =
STbuffer, int new_size, int need_dm
> >   		b_size =3D PAGE_SIZE<<  order;
> >   	} else {
> >   		for (b_size =3D PAGE_SIZE, order =3D 0;
> > -		     order<  ST_MAX_ORDER&&  b_size<  new_size;
> > +		     order<  ST_MAX_ORDER&&
> > +			     max_segs * (PAGE_SIZE<<  order)<  new_size;
> >   		     order++, b_size *=3D 2)
> >   			;  /* empty */
> >   	}
>=20
> You are correct. The loop does not work at all as it should. Years ag=
o,
> the strategy was to start with as big blocks as possible to minimize =
the=20
> number s/g segments. Nowadays the segments must be of same size and t=
he=20
> old logic is not applicable.
>=20
> I have not tested the patch either but it looks correct.
>=20
> Thanks for noticing this bug. I hope this helps the users. The questi=
on=20
> about number of s/g segments is still valid for the direct i/o case b=
ut=20
> that is optimization and not whether one can read/write.

Realistically, though, this will only increase the probability of makin=
g
an allocation work, we can't get this to a certainty.

Since we fixed up the infrastructure to allow arbitrary length sg lists=
,
perhaps we should document what cards can actually take advantage of
this (and how to do so, since it's not set automatically on boot).  Tha=
t
way users wanting tapes at least know what the problems are likely to b=
e
and how to avoid them in their hardware purchasing decisions.  The
corollary is that we should likely have a list of not recommended cards=
:
if they can't go over 128 SG elements, then they're pretty much
unsuitable for modern tapes.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
