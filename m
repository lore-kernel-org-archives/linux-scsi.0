From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH v2 -mm 4/6] ide: avoid DMA on the stack for
	REQ_TYPE_ATA_PC
Date: Thu, 5 Jun 2008 21:14:37 +0200
Message-ID: <20080605191437.GA7479@gollum.tnic>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212682248.13549.48.camel@localhost.localdomain>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1212682248.13549.48.camel@localhost.localdomain>
Sender: linux-arch-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, linux-arch@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 05, 2008 at 11:10:48AM -0500, James Bottomley wrote:
> On Mon, 2008-06-02 at 15:57 +0900, FUJITA Tomonori wrote:
> > Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
> > leads to memory corruption on a non-coherent platform.
> >=20
> > With regard to alignment and padding, ide-cd has the the dma safe
> > check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buff=
er
> > check to that check.
> >=20
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-cd.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index e3f085c..e12d602 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -1195,6 +1195,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_=
drive_t *drive, struct request *rq)
> >  		struct request_queue *q =3D drive->queue;
> >  		unsigned int alignment;
> >  		unsigned long addr;
> > +		unsigned long stack_mask =3D ~(THREAD_SIZE - 1);
> > =20
> >  		if (rq->bio)
> >  			addr =3D (unsigned long)bio_data(rq->bio);
> > @@ -1212,6 +1213,10 @@ static ide_startstop_t cdrom_do_block_pc(ide=
_drive_t *drive, struct request *rq)
> >  		alignment =3D queue_dma_alignment(q) | q->dma_pad_mask;
> >  		if (addr & alignment || rq->data_len & alignment)
> >  			info->dma =3D 0;
> > +
> > +		if (!((addr & stack_mask) ^
> > +		      ((unsigned long)current->stack & stack_mask)))
>=20
> That can basically become
>=20
> if ((addr & stack_mask)  =3D=3D ((unsigned long)current->stack & stac=
k_mask))
>=20
> to be a bit clearer, can't it?

yep, yep. Clearer it is :).
>=20
> I'm also not keen on the use of current->stack.  It looks like this
> commit:
>=20
> commit f7e4217b007d1f73e7e3cf10ba4fea4a608c603f
> Author: Roman Zippel <zippel@linux-m68k.org>
> Date:   Wed May 9 02:35:17 2007 -0700
>=20
>     rename thread_info to stack
>=20
> Introduced a task_stack_page() accessor to get this instead, so perha=
ps
> we should use it (I've cc'd Roman and linux-arch for opinions).
>=20
> > +			info->dma =3D 0;
> >  	}
> > =20
> >  	/* start sending the command to the drive */
>=20
> James
>=20

--=20
Regards/Gru=DF,
    Boris.
