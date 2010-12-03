From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Fri, 03 Dec 2010 12:10:14 -0600
Message-ID: <1291399814.2881.66.camel@mulgrave.site>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <20101203212453W.fujita.tomonori@lab.ntt.co.jp>
	 <4CF905D1.6050903@kolumbus.fi>  <1291388776.2881.4.camel@mulgrave.site>
	 <1291395815.2814.376.camel@larosa>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0LCSKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 13:10:22 -0500
In-Reply-To: <1291395815.2814.376.camel@larosa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Cc: Kai =?ISO-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Kashyap Desai <Kashyap.Desai@lsi.com>

On Fri, 2010-12-03 at 18:03 +0100, Lukas Kolbe wrote:
> Am Freitag, den 03.12.2010, 09:06 -0600 schrieb James Bottomley:
> > On Fri, 2010-12-03 at 16:59 +0200, Kai M=C3=A4kisara wrote:
> > > On 12/03/2010 02:27 PM, FUJITA Tomonori wrote:
> > > >
> > > > Can we make enlarge_buffer friendly to the memory alloctor a bi=
t?
> > > >
> > > > His problem is that the driver can't allocate 2 mB with the har=
dware
> > > > limit 128 segments.
> > > >
> > > > enlarge_buffer tries to use ST_MAX_ORDER and if the allocation =
(256 kB
> > > > page) fails, enlarge_buffer fails. It could try smaller order i=
nstead?
> > > >
> > > > Not tested at all.
> > > >
> > > >
> > > > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > > > index 5b7388f..119544b 100644
> > > > --- a/drivers/scsi/st.c
> > > > +++ b/drivers/scsi/st.c
> > > > @@ -3729,7 +3729,8 @@ static int enlarge_buffer(struct st_buffe=
r * STbuffer, int new_size, int need_dm
> > > >   		b_size =3D PAGE_SIZE<<  order;
> > > >   	} else {
> > > >   		for (b_size =3D PAGE_SIZE, order =3D 0;
> > > > -		     order<  ST_MAX_ORDER&&  b_size<  new_size;
> > > > +		     order<  ST_MAX_ORDER&&
> > > > +			     max_segs * (PAGE_SIZE<<  order)<  new_size;
> > > >   		     order++, b_size *=3D 2)
> > > >   			;  /* empty */
> > > >   	}
> > >=20
> > > You are correct. The loop does not work at all as it should. Year=
s ago,
> > > the strategy was to start with as big blocks as possible to minim=
ize the=20
> > > number s/g segments. Nowadays the segments must be of same size a=
nd the=20
> > > old logic is not applicable.
> > >=20
> > > I have not tested the patch either but it looks correct.
> > >=20
> > > Thanks for noticing this bug. I hope this helps the users. The qu=
estion=20
> > > about number of s/g segments is still valid for the direct i/o ca=
se but=20
> > > that is optimization and not whether one can read/write.
> >=20
> > Realistically, though, this will only increase the probability of m=
aking
> > an allocation work, we can't get this to a certainty.
> >=20
> > Since we fixed up the infrastructure to allow arbitrary length sg l=
ists,
> > perhaps we should document what cards can actually take advantage o=
f
> > this (and how to do so, since it's not set automatically on boot). =
 That
> > way users wanting tapes at least know what the problems are likely =
to be
> > and how to avoid them in their hardware purchasing decisions.  The
> > corollary is that we should likely have a list of not recommended c=
ards:
> > if they can't go over 128 SG elements, then they're pretty much
> > unsuitable for modern tapes.
>=20
> Are you implying here that the LSI SAS1068E is unsuitable to drive tw=
o
> LTO-4 tape drives? Or is it 'just' a problem with the driver?

The information seems to be the former.  There's no way the kernel can
guarantee physical contiguity of memory as it operates.  We try to
defrag, but it's probabalistic, not certain, so if we have to try to
find a physically contiguous buffer to copy into for an operation like
this, at some point that allocation is going to fail.

The only way to be certain you can get a 2MB block down to a tape devic=
e
is to be able to transmit the whole thing as a SG list of fully
discontiguous pages.  On a system with 4k pages, that requires 512 SG
entries.  From what I've heard Kashyap say, that can't currently be don=
e
on the 1068 because of firmware limitations (I'm not entirely clear on
this, but that's how it sounds to me ... if there is a way of making
firmware accept more than 128 SG elements per SCSI command, then it is =
a
fairly simple driver change).  This isn't something we can work around
in the driver because the transaction can't be split ... it has to go
down as a single WRITE command with a single output data buffer.

The LSI 1068 is an upgradeable firmware system, so it's always possible
LSI can come up with a firmware update that increases the size (this
would also require a corresponding driver change), but it doesn't sound
to be something that can be done in the driver alone.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
