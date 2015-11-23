From: Mark Salter <msalter@redhat.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Sun, 22 Nov 2015 20:50:11 -0500
Message-ID: <1448243411.8209.36.camel@redhat.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
	 <1447855399.3974.24.camel@redhat.com>
	 <1447894964.15206.0.camel@ellerman.id.au>
	 <20151119082325.GA11419@infradead.org>
	 <1448021448.14769.7.camel@ellerman.id.au>
	 <565055C6.5040801@linux.vnet.ibm.com> <20151122005635.1b9ffbe1@tom-T450>
	 <1448234410.8209.3.camel@redhat.com>
	 <CACVXFVMAm1niRvXqQXjOXW=ryy41d-ne09wSNbJUq3b9o6vJ7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMAm1niRvXqQXjOXW=ryy41d-ne09wSNbJUq3b9o6vJ7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-11-23 at 08:36 +0800, Ming Lei wrote:
> On Mon, Nov 23, 2015 at 7:20 AM, Mark Salter <msalter@redhat.com> wro=
te:
> > On Sun, 2015-11-22 at 00:56 +0800, Ming Lei wrote:
> > > On Sat, 21 Nov 2015 12:30:14 +0100
> > > Laurent Dufour <ldufour@linux.vnet.ibm.com> wrote:
> > >=20
> > > > On 20/11/2015 13:10, Michael Ellerman wrote:
> > > > > On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:
> > > > >=20
> > > > > > It's pretty much guaranteed a block layer bug, most likely =
in the
> > > > > > merge bios to request infrastucture where we don't obey the=
 merging
> > > > > > limits properly.
> > > > > >=20
> > > > > > Does either of you have a known good and first known bad ke=
rnel?
> > > > >=20
> > > > > Not me, I've only hit it one or two times. All I can say is I=
 have hit it in
> > > > > 4.4-rc1.
> > > > >=20
> > > > > Laurent, can you narrow it down at all?
> > > >=20
> > > > It seems that the panic is triggered by the commit bdced438acd8=
 ("block:
> > > > setup bi_phys_segments after splitting") which has been pulled =
by the
> > > > merge d9734e0d1ccf ("Merge branch 'for-4.4/core' of
> > > > git://git.kernel.dk/linux-block").
> > > >=20
> > > > My system is panicing promptly when running a kernel built at
> > > > d9734e0d1ccf, while reverting the commit bdced438acd8, it can r=
un hours
> > > > without panicing.
> > > >=20
> > > > This being said, I can't explain what's going wrong.
> > > >=20
> > > > May Ming shed some light here ?
> > >=20
> > > Laurent, looks there is one bug in blk_bio_segment_split(), would=
 you
> > > mind testing the following patch to see if it fixes your issue?
> > >=20
> > > ---
> > > From 6fc701231dcc000bc8bc4b9105583380d9aa31f4 Mon Sep 17 00:00:00=
 2001
> > > From: Ming Lei <ming.lei@canonical.com>
> > > Date: Sun, 22 Nov 2015 00:47:13 +0800
> > > Subject: [PATCH] block: fix segment split
> > >=20
> > > Inside blk_bio_segment_split(), previous bvec pointer('bvprvp')
> > > always points to the iterator local variable, which is obviously
> > > wrong, so fix it by pointing to the local variable of 'bvprv'.
> > >=20
> > > Signed-off-by: Ming Lei <ming.lei@canonical.com>
> > > ---
> > > =C2=A0block/blk-merge.c | 4 ++--
> > > =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > index de5716d8..f2efe8a 100644
> > > --- a/block/blk-merge.c
> > > +++ b/block/blk-merge.c
> > > @@ -98,7 +98,7 @@ static struct bio *blk_bio_segment_split(struct=
 request_queue *q,
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seg_s=
ize +=3D bv.bv_len;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bvprv=
 =3D bv;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bvprvp =3D =
&bv;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bvprvp =3D =
&bvprv;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0secto=
rs +=3D bv.bv_len >> 9;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0conti=
nue;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0}
> > > @@ -108,7 +108,7 @@ new_segment:
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0nsegs++;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0bvprv =3D bv;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0bvprvp =3D &bv;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0bvprvp =3D &bvprv;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0seg_size =3D bv.bv_len;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0sectors +=3D bv.bv_len >> 9;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> >=20
> > I'm still hitting the BUG even with this patch applied on top of 4.=
4-rc1.
>=20
> OK, looks there are still other bugs, care to share us how to reprodu=
ce
> it on arm64?
>=20
> thanks,
> Ming

Unfortunately, the best reproducer I have is to boot the platform. I ha=
ve seen the
BUG a few times post-boot, but I don't have a consistant reproducer. I =
am using
upstream 4.4-rc1 with this config:

=C2=A0=C2=A0http://people.redhat.com/msalter/fh_defconfig

With 4.4-rc1 on an APM Mustang platform, I see the BUG about once every=
 6-7 boots.
On an AMD Seattle platform, about every 9 boots.

I have a script that loops through an ssh command to reboot the platfor=
m under test.
I manually install test kernels and then run the script and wait for fa=
ilure. While
debugging, I have tried more minimal configs with which I have been una=
ble to
reproduce the problem even after several hours of reboots. With the abo=
ve mentioned
fh_defconfig, I have been able to get a failure within 20 or so boots w=
ith most
kernel builds but at certain kernel commits, the failure has taken a lo=
nger time to
reproduce.

=46rom my POV, I can't say which commit causes the problem. So far, I h=
ave not been
able to reproduce at all before commit=C2=A0d9734e0d1ccf but I am curre=
ntly trying to
reproduce with commit=C2=A00d51ce9ca1116 (one merge earlier than d9734e=
0d1ccf).
