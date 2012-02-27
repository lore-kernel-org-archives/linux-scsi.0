From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH 2/2] [SCSI] pm8001: Fix possible racing codition.
Date: Mon, 27 Feb 2012 13:06:32 +0800
Message-ID: <608226F8941E4DE49A175A8B3262BA41@usish.com.cn>
References: <1330263303-25177-1-git-send-email-santoshprasadnayak@gmail.com><F56E135C22654173B055597BC0C8DE09@usish.com.cn> <CAOD=uF5f5sP98RTDH68+tyVrgFmJ5rZG_h_X8Qu_-Nvtif3NbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOD=uF5f5sP98RTDH68+tyVrgFmJ5rZG_h_X8Qu_-Nvtif3NbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 'santosh prasad nayak' <santoshprasadnayak@gmail.com>
Cc: lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


The first is not called, just implement a interface, just reserved.

Thanks anyway.
Jack
>=20
> Thanks Jack for your response.
>=20
> 'process_oq'  is called at two places.
>=20
>=20
>  pm8001_8001_dispatch =3D {
>  =A0 =A0 =A0 =A0 =A0.......
>=20
>  =A0 =A0 =A0 =A0 .isr =A0 =A0 =A0 =A0 =A0 =A0 =3D pm8001_chip_isr -->=
 process_oq,     //   1st
> place
>  =A0 =A0 =A0 =A0 .isr_process_oq =A0=3D process_oq, =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0          //
>  2nd  place
>  =A0 =A0 =A0 =A0 .....
> }
>=20
> regards
> santosh
>=20
> On Mon, Feb 27, 2012 at 10:18 AM, Jack Wang <jack_wang@usish.com> wro=
te:
> > Infact , process_oq is only called in pm8001_chip_isr, but this pat=
ch
looks
> > OK for me. Move down the lock to process_oq is OK.
> >
> > Thanks for fix.
> > Acked-by : Jack Wang <jack_wang@usish.com>
> >
> >> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> >>
> >> There is a possble racing scenario.
> >>
> >> 'process_oq' is called by two routines, as shown below.
> >>
> >> pm8001_8001_dispatch =3D {
> >> =A0 =A0 =A0 =A0 =A0.......
> >>
> >> =A0 =A0 =A0 =A0 .isr =A0 =A0 =A0 =A0 =A0 =A0 =3D pm8001_chip_isr -=
-> process_oq,// A
> >> =A0 =A0 =A0 =A0 .isr_process_oq =A0=3D process_oq, =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 // =A0B
> >> =A0 =A0 =A0 =A0 .....
> >> }
> >>
> >> process_oq() --> process_one_iomb() --> mpi_sata_completion()
> >>
> >> In 'mpi_sata_completion', "pm8001_ha->lock" is first released.
> >> It means lock is taken before, =A0which is true for
> >> the context A, as 'pm8001_ha->lock' is taken in 'pm8001_chip_isr()=
'
> >>
> >> But for context B there is no lock taken before and pm8001_ha->loc=
k
> >> is unlocked in 'mpi_sata_completion()'. This may unlock the lock
> >> taken in context A. Possible racing ??
> >>
> >> If 'pm8001_ha->lock' is taken in 'process_oq()' instead of
> >> 'pm8001_chip_isr' then the above issue can be avoided.
> >>
> >> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> >> ---
> >> =A0drivers/scsi/pm8001/pm8001_hwi.c | =A0 =A06 +++---
> >> =A01 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> >> b/drivers/scsi/pm8001/pm8001_hwi.c
> >> index 838e3e2..6d9973b 100644
> >> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> >> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> >> @@ -3663,7 +3663,9 @@ static int process_oq(struct pm8001_hba_info
> > *pm8001_ha)
> >> =A0 =A0 =A0 void *pMsg1 =3D NULL;
> >> =A0 =A0 =A0 u8 uninitialized_var(bc);
> >> =A0 =A0 =A0 u32 ret =3D MPI_IO_STATUS_FAIL;
> >> + =A0 =A0 unsigned long flags;
> >>
> >> + =A0 =A0 spin_lock_irqsave(&pm8001_ha->lock, flags);
> >> =A0 =A0 =A0 circularQ =3D &pm8001_ha->outbnd_q_tbl[0];
> >> =A0 =A0 =A0 do {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mpi_msg_consume(pm8001_ha, cir=
cularQ, &pMsg1, &bc);
> >> @@ -3682,6 +3684,7 @@ static int process_oq(struct pm8001_hba_info
> > *pm8001_ha)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 } while (1);
> >> + =A0 =A0 spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> >> =A0 =A0 =A0 return ret;
> >> =A0}
> >>
> >> @@ -4087,12 +4090,9 @@ static u32 pm8001_chip_is_our_interupt(stru=
ct
> >> pm8001_hba_info *pm8001_ha)
> >> =A0static irqreturn_t
> >> =A0pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha)
> >> =A0{
> >> - =A0 =A0 unsigned long flags;
> >> - =A0 =A0 spin_lock_irqsave(&pm8001_ha->lock, flags);
> >> =A0 =A0 =A0 pm8001_chip_interrupt_disable(pm8001_ha);
> >> =A0 =A0 =A0 process_oq(pm8001_ha);
> >> =A0 =A0 =A0 pm8001_chip_interrupt_enable(pm8001_ha);
> >> - =A0 =A0 spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> >> =A0 =A0 =A0 return IRQ_HANDLED;
> >> =A0}
> >>
> >> --
> >> 1.7.4.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-sc=
si"
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
