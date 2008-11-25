From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: next-20081119: general protection fault:
 get_next_timer_interrupt()
Date: Tue, 25 Nov 2008 11:57:10 +1100
Message-ID: <20081125115710.6c249f32.sfr@canb.auug.org.au>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com>
	<alpine.LFD.2.00.0811191308030.3119@localhost.localdomain>
	<a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com>
	<alpine.LFD.2.00.0811241816120.3301@localhost.localdomain>
	<1227554117.25499.46.camel@localhost.localdomain>
	<alpine.LFD.2.00.0811242018370.3235@localhost.localdomain>
	<20081124213517.GA25898@linux.vnet.ibm.com>
	<alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
	<20081125000902.GA24251@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Nov_2008_11_57_10_+1100_aE__mXCzjPipdqJT"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081125000902.GA24251@us.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: malahal@us.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__25_Nov_2008_11_57_10_+1100_aE__mXCzjPipdqJT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Nov 2008 16:09:02 -0800 malahal@us.ibm.com wrote:
>
> Thomas Gleixner [tglx@linutronix.de] wrote:
> > On Mon, 24 Nov 2008, Mike Anderson wrote:
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > Yeah, block could it be as well. Jens, Mike ?
> > >=20
> > > I added a comment to bug 12020 on Thursday about a few other systems =
that
> > > where seeing the signature shown in bug 12020. It appeared from debug=
 that
> > > there where a few paths that where adding timers for requests that wh=
ere
> > > not expected.
> > >=20
> > > http://bugzilla.kernel.org/show_bug.cgi?id=3D12020
> > >=20
> > > It would be good to know if the debug patch below effects your proble=
m as while.
> > >=20
> > > If it does we need to investigated a solution to resolve not adding a
> > > timer for these requests.
>=20
> The block timer code calls del_timer(), should it call del_timer_sync()?
> It is possible although unlikely that you are hitting del_timer_sync vs
> del_timer problem in the block timeout code. Can only be seen on SMP
> systems though!

Is this still a problem in next-20081121? In that tree, the block commit
"block: leave the request timeout timer running even on an empty list"
was changed to add this:

diff --git a/block/blk-core.c b/block/blk-core.c
index 04267d6..44f547c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -391,6 +391,7 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
+	del_timer_sync(&q->timeout);
 	kblockd_flush_work(&q->unplug_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);

After I spent some time bisecting a boot failure in PowerPC.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Nov_2008_11_57_10_+1100_aE__mXCzjPipdqJT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkrTWYACgkQjjKRsyhoI8xNIACgqG9aZ8bVpf+KQAVhDkRKMrSp
TBwAnjx4aD72iIEIt0OReFySaKSa77n8
=Jtea
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Nov_2008_11_57_10_+1100_aE__mXCzjPipdqJT--
