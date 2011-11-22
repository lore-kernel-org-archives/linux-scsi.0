From: NeilBrown <neilb@suse.de>
Subject: Re: raid1d crash at boot
Date: Tue, 22 Nov 2011 12:26:57 +1100
Message-ID: <20111122122657.69b14108@notabene.brown>
References: <20111119134139.GA30570@rere.qmqm.pl>
	<20111121123729.47c72c3b@notabene.brown>
	<1321859070.3654.7.camel@dabdike>
	<20111121192745.2c9ac9c0@notabene.brown>
	<20111122005037.GA7801@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.as93/mOnvgsVpe/wFCWs=Q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111122005037.GA7801@rere.qmqm.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-2?B?TWljaGGzIE1pcm9zs2F3?= <mirq-linux@rere.qmqm.pl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

--Sig_/.as93/mOnvgsVpe/wFCWs=Q
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 01:50:37 +0100 Micha=B3 Miros=B3aw <mirq-linux@rere.qmq=
m.pl>
wrote:

> On Mon, Nov 21, 2011 at 07:27:45PM +1100, NeilBrown wrote:
> > On Mon, 21 Nov 2011 08:04:30 +0100 James Bottomley
> > <James.Bottomley@HansenPartnership.com> wrote:
> > > On Mon, 2011-11-21 at 12:37 +1100, NeilBrown wrote:
> > > > Thank for the report.
> > > > However as this crash is clearly in the SCSI layer it makes sense t=
o reported
> > > > it to linux-scsi - so I have cc:ed this reply there.
> > > >=20
> > > > On Sat, 19 Nov 2011 14:41:39 +0100 Micha=B3 Miros=B3aw <mirq-linux@=
rere.qmqm.pl>
> > > > wrote:
> > > > > I get following BUG_ON tripped while booting, before rootfs is mo=
unted by
> > > > > Debian's initrd. This started to happen for kernels since sometime
> > > > > during 3.1-rcX.
> > > > >=20
> > > > > [    6.246170] ------------[ cut here ]------------
> > > > > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/s=
csi/scsi_lib.c:1153!
> > >=20
> > > I can tell you what it is:
> > >=20
> > >         /*
> > >          * Filesystem requests must transfer data.
> > >          */
> > >         BUG_ON(!req->nr_phys_segments);
> > >=20
> > > But the fault is in the layer above SCSI.  It means something sent a
> > > request with REQ_TYPE_FS but no actual data attached ... this is
> > > supposed to be impossible, hence the bug on.
> >=20
> > Thanks.... that sounds strangely familiar, but I cannot be sure and goo=
gle
> > doesn't help.
> >=20
> > Micha=B3: what are you using on the RAID1 - some filesystem (which one)=
or swap or something else?
>=20
> The whole stack is: ext4 over lvm over dm-crypt over md-raid1 over SATA
> drives.  The boot doesn't survive to the point where the initrd script as=
ks
> for md-crypt's key password.
>

That gives us lots of room for pointing the finger of blame, doesn't it?
I think it is -> his problem. :-)

=46rom the md part of the stack trace it looks most like a write request.  It
could be a retried read, but that is extremely unlike that early in boot.

So presumably it is some sort of zero-length REQ_FLUSH or something like th=
at.
md/raid1 will just pass those unchanged down.=20
My guess is that ext4 is generating this and something in the stack is
stripping the REQ_FLUSH .... though why it even tries before asking for a
password is beyond me.

Maybe someone of dm-devel can help?

If not we might need to try a debugging patch like this:


diff --git a/block/blk-core.c b/block/blk-core.c
index f43c8a5..59cb2ad 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1560,7 +1560,7 @@ generic_make_request_checks(struct bio *bio)
 			goto end_io;
 		}
 	}
-
+	WARN_ON(((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && nr_sectors =3D=3D 0);
 	if ((bio->bi_rw & REQ_DISCARD) &&
 	    (!blk_queue_discard(q) ||
 	     ((bio->bi_rw & REQ_SECURE) &&


NeilBrown


--Sig_/.as93/mOnvgsVpe/wFCWs=Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsr6YTnsnt1WYoG5AQIugg//TyyofYSNuKQMcOUdOy7ncYpxVf7bTzPO
9vl575Ab5KHzql8bGbNnDnGXDr09nTCLt/y4IO3AfP26k77t6rIKIZI0v0Fp9v7p
xu8EdjkMrtoIOHUJboqfefprH4c4l+QxAQ/ulQMDSlDRLqKGpoyWtO7VioM1GC1B
178b9rYlN1ZGpHZ/YyHb2vjJHOA6MceO+tiMe8GbO7Y+ZRCyhf+rCEYqfzIql+W2
9KnXbpCEY/TuBa8b4DpMvHOzPW/5Jj9d/ztEeuQ6CONpr1yrcLm54rafRCQpxCc1
+FJZA6fIxxfRRxKg5glNkU8Y/8QXIE74hL/DjYUEdwHAMAgdkRoQDpzAHDCr0FXn
Kv5WwdS44b+J5gnS3BrGy8/k9NlyCCKaqF+MRXBQ8BoVGv5de3dzngqWb14kHCR2
MPgKBHL3+IPxP3lG47GUAS5DiCELnxLx8Y5nwXXBJiMmn2lK2dtpFGSyvRHezBHL
vijnpEQkOpVjhpbUUY9aqJ82+3eDnOKV0LKMlUyzqs7x0zQsyUm63On8miinCr5k
/r0JItjfulGUyksoxUCd9tYi6wW6ijXtX8OE5+q7adz17rwDK6OtMcD3Djq7/HvD
MrIOIpjGiNACSfuhKsUCbE/PL2mttgypqrWIn7Sj3CH8InF3y12N1PfS9U3cc+md
cnROanK92j8=
=6zXV
-----END PGP SIGNATURE-----

--Sig_/.as93/mOnvgsVpe/wFCWs=Q--
