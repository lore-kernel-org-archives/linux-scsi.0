From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Mon, 27 Feb 2012 16:29:50 +0800
Message-ID: <B76D77A74C894381BBF8365C5607758B@usish.com.cn>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com><20120226150720.GB4763@mwanda> <CAOD=uF4VGsM5AQTSCW4ZRr_n4HUSr0qO3fG_MAtsYgq=ogXvAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOD=uF4VGsM5AQTSCW4ZRr_n4HUSr0qO3fG_MAtsYgq=ogXvAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 'santosh prasad nayak' <santoshprasadnayak@gmail.com>, 'Dan Carpenter' <dan.carpenter@oracle.com>
Cc: lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks for fix.
Acked-by: Jack Wang <jack_wang@usish.com>
>=20
>  In 'mpi_sata_completion'
>  the first call for 'spin_unlock_irqrestore()' is with flags=3D0,
>  which is as good as 'spin_unlock_irq()' ( unconditional interrupt
>  enabling). If intention of the developer is to enable the interrupt
during
> execution of ' mpi_sata_completion' , then the code changes in the pa=
tch
> looks ok.
>=20
> If interrupt should not be enabled during execution of
> 'mpi_sata_completion' then
> we can use simple  spin_lock and spin_unlock.
>=20
>=20
> regards
> santosh
>=20
>=20
> On Sun, Feb 26, 2012 at 8:37 PM, Dan Carpenter <dan.carpenter@oracle.=
com>
> wrote:
> > On Sun, Feb 26, 2012 at 07:03:30PM +0530, santosh nayak wrote:
> >> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> >>
> >> Static checker is giving following warning:
> >> " error: calling 'spin_unlock_irqrestore()' with bogus flags"
> >>
> >> The code flow is as shown below:
> >> process_oq() --> process_one_iomb --> mpi_sata_completion
> >>
> >> In 'mpi_sata_completion'
> >> the first call for 'spin_unlock_irqrestore()' is with flags=3D0,
> >> which is as good as 'spin_unlock_irq()' ( unconditional interrupt
> >> enabling).
> >>
> >> So for better performance 'spin_unlock_irqrestore()' can be replac=
ed
> >> with 'spin_unlock_irq()' and 'spin_lock_irqsave()' can be replaced=
 by
> >> 'spin_lock_irq()'.
> >>
> >
> > process_oq() is called from the interrupt handler pm8001_chip_isr()
> > with interrupts disabled.
> >
> > drivers/scsi/pm8001/pm8001_hwi.c
> > =A04301 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&pm8001_ha->lock, flag=
s);
> > =A04302 =A0 =A0 =A0 =A0 =A0pm8001_chip_interrupt_disable(pm8001_ha)=
;
> > =A04303 =A0 =A0 =A0 =A0 =A0process_oq(pm8001_ha);
> > =A04304 =A0 =A0 =A0 =A0 =A0pm8001_chip_interrupt_enable(pm8001_ha);
> > =A04305 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&pm8001_ha->lock,=
 flags);
> >
> > Probably we should just be doing a spin_lock() and spin_unlock()
> > without re-enabling the IRQs. =A0Should we even be doing that in th=
e
> > irq handler anyway?
> >
> > regards,
> > dan carpenter
> >
