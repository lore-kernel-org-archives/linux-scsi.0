From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Reported regressions for 4.7 as of Sunday, 2016-06-19
Date: Thu, 23 Jun 2016 09:22:40 +0200
Message-ID: <20160623072240.gt4wdjok27venxgr@c203.arch.suse.de>
References: <7cc588b7-f1cf-62a8-e45b-ec7d863ba51e@leemhuis.info>
 <CA+5PVA63r9xLXtiiVMxKPdgZD5VZ_8io1f=9MH520LAFBbe9kg@mail.gmail.com>
 <CA+55aFyyKjupjdd4tC82VEnZwb3AyEGJBVCJzdyvfgeUFGVfLw@mail.gmail.com>
 <yq1wpli2ewx.fsf@sermon.lab.mkp.net>
 <20160622115131.4bh7sh6uhmmhw44v@c203.arch.suse.de>
 <A19CCC3E-1B00-45A5-BA4B-2E082E98AF87@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A19CCC3E-1B00-45A5-BA4B-2E082E98AF87@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Boyer <jwboyer@fedoraproject.org>, Thorsten Leemhuis <regressions@leemhuis.info>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[+ Cc linux-scsi@vger.kernel.org ]

On Wed, Jun 22, 2016 at 03:57:35PM +0000, Quinn Tran wrote:
> Johannes,  Martin,
>=20
> Based on the screen shot/call trace,  it looks like this adapter is n=
ot using MSIX.  It defaulted back to MSI or INTx interrupt.  The code m=
ade an assumption  of MSIX is available.  There is no point in go throu=
gh that code segment.
>=20
> Can you try this work around?  It=E2=80=99s untested.  Thanks.
>=20
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ql=
a_isr.c
> index 5649c20..e033ecb 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2548,7 +2548,7 @@ void qla24xx_process_response_queue(struct scsi=
_qla_host *vha,
>         if (!vha->flags.online)
>                 return;
> =20
> -       if (rsp->msix->cpuid !=3D smp_processor_id()) {
> +       if (rsp->msix && (rsp->msix->cpuid !=3D smp_processor_id())) =
{
>                 /* if kernel does not notify qla of IRQ's CPU change,
>                  * then set it here.
>                  */
>=20

But this still does not fix the race which would be possible if the HBA=
 is
using MSI-X but triggering IRQs early enough.

Have a look at this (I admit theoretical) path:
qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
{
	[...]
	/* Enable MSI-X vectors for the base queue */
	for (i =3D 0; i < 2; i++) {
			qentry =3D &ha->msix_entries[i];
			if (IS_P3P_TYPE(ha))
				ret =3D request_irq(qentry->vector,
					qla82xx_msix_entries[i].handler,
					0, qla82xx_msix_entries[i].name, rsp);
			else
				ret =3D request_irq(qentry->vector,
					msix_entries[i].handler,
					0, msix_entries[i].name, rsp);
			if (ret)
				goto msix_register_fail;
							<--- IRQ arrives here
			qentry->have_irq =3D 1;
			qentry->rsp =3D rsp;
			rsp->msix =3D qentry;

			[...]


void qla24xx_process_response_queue(struct scsi_qla_host *vha,
        struct rsp_que *rsp)
{
[...]
	if (rsp->msix->cpuid !=3D smp_processor_id()) {
                  ^
                  \--- rsp->msix =3D=3D NULL

			/* if kernel does not notify qla of IRQ's CPU change,
			 * then set it here.
			 */
			rsp->msix->cpuid =3D smp_processor_id();
			ha->tgt.rspq_vector_cpuid =3D rsp->msix->cpuid;

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
