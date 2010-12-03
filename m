From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Fri, 03 Dec 2010 18:03:35 +0100
Message-ID: <1291395815.2814.376.camel@larosa>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <20101203212453W.fujita.tomonori@lab.ntt.co.jp>
	 <4CF905D1.6050903@kolumbus.fi>  <1291388776.2881.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:54947 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550Ab0LCRDo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 12:03:44 -0500
In-Reply-To: <1291388776.2881.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Kai =?ISO-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Kashyap Desai <Kashyap.Desai@lsi.com>

Am Freitag, den 03.12.2010, 09:06 -0600 schrieb James Bottomley:
> On Fri, 2010-12-03 at 16:59 +0200, Kai M=C3=A4kisara wrote:
> > On 12/03/2010 02:27 PM, FUJITA Tomonori wrote:
> > >
> > > Can we make enlarge_buffer friendly to the memory alloctor a bit?
> > >
> > > His problem is that the driver can't allocate 2 mB with the hardw=
are
> > > limit 128 segments.
> > >
> > > enlarge_buffer tries to use ST_MAX_ORDER and if the allocation (2=
56 kB
> > > page) fails, enlarge_buffer fails. It could try smaller order ins=
tead?
> > >
> > > Not tested at all.
> > >
> > >
> > > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > > index 5b7388f..119544b 100644
> > > --- a/drivers/scsi/st.c
> > > +++ b/drivers/scsi/st.c
> > > @@ -3729,7 +3729,8 @@ static int enlarge_buffer(struct st_buffer =
* STbuffer, int new_size, int need_dm
> > >   		b_size =3D PAGE_SIZE<<  order;
> > >   	} else {
> > >   		for (b_size =3D PAGE_SIZE, order =3D 0;
> > > -		     order<  ST_MAX_ORDER&&  b_size<  new_size;
> > > +		     order<  ST_MAX_ORDER&&
> > > +			     max_segs * (PAGE_SIZE<<  order)<  new_size;
> > >   		     order++, b_size *=3D 2)
> > >   			;  /* empty */
> > >   	}
> >=20
> > You are correct. The loop does not work at all as it should. Years =
ago,
> > the strategy was to start with as big blocks as possible to minimiz=
e the=20
> > number s/g segments. Nowadays the segments must be of same size and=
 the=20
> > old logic is not applicable.
> >=20
> > I have not tested the patch either but it looks correct.
> >=20
> > Thanks for noticing this bug. I hope this helps the users. The ques=
tion=20
> > about number of s/g segments is still valid for the direct i/o case=
 but=20
> > that is optimization and not whether one can read/write.
>=20
> Realistically, though, this will only increase the probability of mak=
ing
> an allocation work, we can't get this to a certainty.
>=20
> Since we fixed up the infrastructure to allow arbitrary length sg lis=
ts,
> perhaps we should document what cards can actually take advantage of
> this (and how to do so, since it's not set automatically on boot).  T=
hat
> way users wanting tapes at least know what the problems are likely to=
 be
> and how to avoid them in their hardware purchasing decisions.  The
> corollary is that we should likely have a list of not recommended car=
ds:
> if they can't go over 128 SG elements, then they're pretty much
> unsuitable for modern tapes.

Are you implying here that the LSI SAS1068E is unsuitable to drive two
LTO-4 tape drives? Or is it 'just' a problem with the driver?

I'll test both the above patch if it helps in our situation and report
back.

--=20
Lukas


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
