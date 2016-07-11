From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer deref in QLA interrupt
Date: Mon, 11 Jul 2016 10:29:48 +0200
Message-ID: <20160711102948.4e37a56f@pluto.restena.lu>
References: <20160630170032.6dbaf496@pluto.restena.lu>
	<94d0470f-7555-8098-b382-a4fdac9b0709@leemhuis.info>
	<20160711091729.57e67114@pluto.restena.lu>
	<8fadfa97-370f-7483-e80e-437f5338d3fd@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.restena.lu ([158.64.1.62]:57246 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbcGKI35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2016 04:29:57 -0400
In-Reply-To: <8fadfa97-370f-7483-e80e-437f5338d3fd@leemhuis.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 11 Jul 2016 09:30:30 +0200 Thorsten Leemhuis wrote:
> Bruno Pr=C3=A9mont wrote on 11.07.2016 09:17:
> > On Fri, 8 Jul 2016 09:27:18 +0200 Thorsten Leemhuis wrote: =20
> >> Bruno Pr=C3=A9mont wrote on 30.06.2016 17:00: =20
> >> > In qla24xx_process_response_queue() rsp->msix->cpuid may trigger=
 NULL
> >> > pointer dereference when rsp->msix is NULL:
> >> > [=E2=80=A6]
> >> > The affected code was introduced by commit cdb898c52d1dfad4b4800=
b83a58b3fe5d352edde
> >> > (qla2xxx: Add irq affinity notification).
> >> >=20
> >> > Only dereference rsp->msix when it has been set so the machine c=
an boot
> >> > fine. Possibly rsp->msix is unset because:
> >> > [    3.479679] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Chann=
el HBA Driver: 8.07.00.33-k.
> >> > [    3.481839] qla2xxx [0000:13:00.0]-001d: : Found an ISP2432 i=
rq 17 iobase 0xffffc90000038000.
> >> > [    3.484081] qla2xxx [0000:13:00.0]-0035:0: MSI-X; Unsupported=
 ISP2432 (0x2, 0x3).
> >> > [    3.485804] qla2xxx [0000:13:00.0]-0037:0: Falling back-to MS=
I mode -258.
> >> > [    3.890145] scsi host0: qla2xxx
> >> > [    3.891956] qla2xxx [0000:13:00.0]-00fb:0: QLogic QLE2460 - P=
CI-Express Single Channel 4Gb Fibre Channel HBA.
> >> > [    3.894207] qla2xxx [0000:13:00.0]-00fc:0: ISP2432: PCIe (2.5=
GT/s x4) @ 0000:13:00.0 hdma+ host#=3D0 fw=3D7.03.00 (9496).
> >> > [    5.714774] qla2xxx [0000:13:00.0]-500a:0: LOOP UP detected (=
4 Gbps).   =20
> >>=20
> >> Bruno: Does that mean you actually tested that patch and it fixed =
the
> >> problem for you? It looks like it, but there is some confusion abo=
ut it;
> >> that's one of the reasons why this patch didn't get any further ye=
t
> >> afaics, so a quick clarification might help to finally get this fi=
xed
> >> properly in mainline and stable. =20
> > Yes, it does fix the Oops for me. =20
>=20
> Thx for the feedback. The patch hit mainline late last week (it's
> included in rc7) and should hopefully make it to the stable trees in =
a
> week or two.

I got the queued notification from James last week and kept an eye
at the state on patchwork before that.

> > I did not analyze the reason why rsp->msix is NULL (no idea if
> > it remains NULL forever on my hardware) - I just extracted messages
> > from qla driver shown during boot which seem to indicate a possible
> > reason why msix is NULL.
> > Further analysis should be done by someone with better knowledge of=
 qla
> > driver than mine though I would be happy to perform tests. =20
>=20
> I have no idea about the details, but in case you missed it, this
> discussion might have some more relevant details:
> http://thread.gmane.org/gmane.linux.kernel/2247804/focus=3D2250727

I didn't see that thread, though it does have some insight.
Thanks for the reference!

Bruno

> Cheers, Thorsten
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
