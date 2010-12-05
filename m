From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Sun, 05 Dec 2010 11:53:03 +0100
Message-ID: <1291546383.2814.2890.camel@larosa>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <20101203212453W.fujita.tomonori@lab.ntt.co.jp>
	 <4CF905D1.6050903@kolumbus.fi>  <1291388776.2881.4.camel@mulgrave.site>
	 <1291395815.2814.376.camel@larosa> <1291399814.2881.66.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:55770 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab0LEKxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Dec 2010 05:53:07 -0500
In-Reply-To: <1291399814.2881.66.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Kai =?ISO-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Kashyap Desai <Kashyap.Desai@lsi.com>

Am Freitag, den 03.12.2010, 12:10 -0600 schrieb James Bottomley:
> On Fri, 2010-12-03 at 18:03 +0100, Lukas Kolbe wrote:
> > Am Freitag, den 03.12.2010, 09:06 -0600 schrieb James Bottomley:
> > > On Fri, 2010-12-03 at 16:59 +0200, Kai M=C3=A4kisara wrote:
> > > > On 12/03/2010 02:27 PM, FUJITA Tomonori wrote:
> > > > >
> > > > > Can we make enlarge_buffer friendly to the memory alloctor a =
bit?
> > > > >
> > > > > His problem is that the driver can't allocate 2 mB with the h=
ardware
> > > > > limit 128 segments.
> > > > >
> > > > > enlarge_buffer tries to use ST_MAX_ORDER and if the allocatio=
n (256 kB
> > > > > page) fails, enlarge_buffer fails. It could try smaller order=
 instead?
> > > > >
> > > > > Not tested at all.
> > > > >
> > > > >
> > > > > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > > > > index 5b7388f..119544b 100644
> > > > > --- a/drivers/scsi/st.c
> > > > > +++ b/drivers/scsi/st.c
> > > > > @@ -3729,7 +3729,8 @@ static int enlarge_buffer(struct st_buf=
fer * STbuffer, int new_size, int need_dm
> > > > >   		b_size =3D PAGE_SIZE<<  order;
> > > > >   	} else {
> > > > >   		for (b_size =3D PAGE_SIZE, order =3D 0;
> > > > > -		     order<  ST_MAX_ORDER&&  b_size<  new_size;
> > > > > +		     order<  ST_MAX_ORDER&&
> > > > > +			     max_segs * (PAGE_SIZE<<  order)<  new_size;
> > > > >   		     order++, b_size *=3D 2)
> > > > >   			;  /* empty */
> > > > >   	}
> > > >=20
> > > > You are correct. The loop does not work at all as it should. Ye=
ars ago,
> > > > the strategy was to start with as big blocks as possible to min=
imize the=20
> > > > number s/g segments. Nowadays the segments must be of same size=
 and the=20
> > > > old logic is not applicable.
> > > >=20
> > > > I have not tested the patch either but it looks correct.
> > > >=20
> > > > Thanks for noticing this bug. I hope this helps the users. The =
question=20
> > > > about number of s/g segments is still valid for the direct i/o =
case but=20
> > > > that is optimization and not whether one can read/write.
> > >=20
> > > Realistically, though, this will only increase the probability of=
 making
> > > an allocation work, we can't get this to a certainty.
> > >=20
> > > Since we fixed up the infrastructure to allow arbitrary length sg=
 lists,
> > > perhaps we should document what cards can actually take advantage=
 of
> > > this (and how to do so, since it's not set automatically on boot)=
=2E  That
> > > way users wanting tapes at least know what the problems are likel=
y to be
> > > and how to avoid them in their hardware purchasing decisions.  Th=
e
> > > corollary is that we should likely have a list of not recommended=
 cards:
> > > if they can't go over 128 SG elements, then they're pretty much
> > > unsuitable for modern tapes.
> >=20
> > Are you implying here that the LSI SAS1068E is unsuitable to drive =
two
> > LTO-4 tape drives? Or is it 'just' a problem with the driver?
>=20
> The information seems to be the former.  There's no way the kernel ca=
n
> guarantee physical contiguity of memory as it operates.  We try to
> defrag, but it's probabalistic, not certain, so if we have to try to
> find a physically contiguous buffer to copy into for an operation lik=
e
> this, at some point that allocation is going to fail.
>=20
> The only way to be certain you can get a 2MB block down to a tape dev=
ice
> is to be able to transmit the whole thing as a SG list of fully
> discontiguous pages.  On a system with 4k pages, that requires 512 SG
> entries.  From what I've heard Kashyap say, that can't currently be d=
one
> on the 1068 because of firmware limitations (I'm not entirely clear o=
n
> this, but that's how it sounds to me ... if there is a way of making
> firmware accept more than 128 SG elements per SCSI command, then it i=
s a
> fairly simple driver change).

Well, 2MB blocksizes actually do work - bacula is reporting a blocksize
of ~2MB for each drive while writing to it - only after there was memor=
y
pressure and a new tape got inserted, it is *not* possible anymore to
write to the tape with these blocksizes, and dmesg tells me one of thes=
e
every time bacula tries to read from or write to a tape:

[101883.958351] st0: Can't allocate 2097152 byte tape buffer.
[103901.666608] st0: Can't allocate 10249541 byte tape buffer.

No idea why it's trying 10MB, though.

I tested with the patch from Fujita, and this messages from before
applying the patch:=20

[158544.348411] st: append_to_buffer offset overflow.

do not appear anymore.
It didn't help on the not-being-able-to-write-after-memory-pressure
matter, though.

>  This isn't something we can work around
> in the driver because the transaction can't be split ... it has to go
> down as a single WRITE command with a single output data buffer.
>=20
> The LSI 1068 is an upgradeable firmware system, so it's always possib=
le
> LSI can come up with a firmware update that increases the size (this
> would also require a corresponding driver change), but it doesn't sou=
nd
> to be something that can be done in the driver alone.

If only LSI's website were a little more clear on where to find updated
firmware and what was the latest version :/.

--=20
Lukas


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
