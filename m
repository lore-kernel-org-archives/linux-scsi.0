From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer deref in QLA interrupt
Date: Mon, 11 Jul 2016 09:17:29 +0200
Message-ID: <20160711091729.57e67114@pluto.restena.lu>
References: <20160630170032.6dbaf496@pluto.restena.lu>
	<94d0470f-7555-8098-b382-a4fdac9b0709@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94d0470f-7555-8098-b382-a4fdac9b0709@leemhuis.info>
Sender: linux-kernel-owner@vger.kernel.org
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 8 Jul 2016 09:27:18 +0200 Thorsten Leemhuis wrote:
> Bruno Pr=C3=A9mont wrote on 30.06.2016 17:00:
> > In qla24xx_process_response_queue() rsp->msix->cpuid may trigger NU=
LL
> > pointer dereference when rsp->msix is NULL:
> > [=E2=80=A6]
> > The affected code was introduced by commit cdb898c52d1dfad4b4800b83=
a58b3fe5d352edde
> > (qla2xxx: Add irq affinity notification).
> >=20
> > Only dereference rsp->msix when it has been set so the machine can =
boot
> > fine. Possibly rsp->msix is unset because:
> > [    3.479679] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel =
HBA Driver: 8.07.00.33-k.
> > [    3.481839] qla2xxx [0000:13:00.0]-001d: : Found an ISP2432 irq =
17 iobase 0xffffc90000038000.
> > [    3.484081] qla2xxx [0000:13:00.0]-0035:0: MSI-X; Unsupported IS=
P2432 (0x2, 0x3).
> > [    3.485804] qla2xxx [0000:13:00.0]-0037:0: Falling back-to MSI m=
ode -258.
> > [    3.890145] scsi host0: qla2xxx
> > [    3.891956] qla2xxx [0000:13:00.0]-00fb:0: QLogic QLE2460 - PCI-=
Express Single Channel 4Gb Fibre Channel HBA.
> > [    3.894207] qla2xxx [0000:13:00.0]-00fc:0: ISP2432: PCIe (2.5GT/=
s x4) @ 0000:13:00.0 hdma+ host#=3D0 fw=3D7.03.00 (9496).
> > [    5.714774] qla2xxx [0000:13:00.0]-500a:0: LOOP UP detected (4 G=
bps). =20
>=20
> Bruno: Does that mean you actually tested that patch and it fixed the
> problem for you? It looks like it, but there is some confusion about =
it;
> that's one of the reasons why this patch didn't get any further yet
> afaics, so a quick clarification might help to finally get this fixed
> properly in mainline and stable.

Yes, it does fix the Oops for me.

I did not analyze the reason why rsp->msix is NULL (no idea if
it remains NULL forever on my hardware) - I just extracted messages
from qla driver shown during boot which seem to indicate a possible
reason why msix is NULL.
=46urther analysis should be done by someone with better knowledge of q=
la
driver than mine though I would be happy to perform tests.

Bruno


> Himanshu: While at it: Can you confirm this patch should get merged t=
o
> mainline? Seems Quinn is on PTO and his out-of-office reply mentioned
> you as one point of contact.
>=20
> Cheers, your regression tracker for Linux 4.7
>  Thorsten
>=20
> > CC: <stable@vger.kernel.org>
> > Signed-off-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> > ---
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> > b/drivers/scsi/qla2xxx/qla_isr.c index 5649c20..a92a62d 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -2548,7 +2548,7 @@ void qla24xx_process_response_queue(struct
> > scsi_qla_host *vha, if (!vha->flags.online)
> >  		return;
> > =20
> > -	if (rsp->msix->cpuid !=3D smp_processor_id()) {
> > +	if (rsp->msix && rsp->msix->cpuid !=3D smp_processor_id()) {
> >  		/* if kernel does not notify qla of IRQ's CPU change,
> >  		 * then set it here.
> >  		 */
> >=20
> > http://news.gmane.org/find-root.php?message_id=3D20160630170032.6db=
af496%40pluto.restena.lu=20
> > http://mid.gmane.org/20160630170032.6dbaf496%40pluto.restena.lu
> >  =20
