From: Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer deref in QLA interrupt
Date: Fri, 8 Jul 2016 09:27:18 +0200
Message-ID: <94d0470f-7555-8098-b382-a4fdac9b0709@leemhuis.info>
References: <20160630170032.6dbaf496@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from basicbox7.server-home.net ([195.137.212.29]:47744 "EHLO
	basicbox7.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbcGHH1X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 03:27:23 -0400
In-Reply-To: <20160630170032.6dbaf496@pluto.restena.lu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?Bruno_Pr=c3=a9mont?= <bonbons@linux-vserver.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Bruno Pr=C3=A9mont wrote on 30.06.2016 17:00:
> In qla24xx_process_response_queue() rsp->msix->cpuid may trigger NULL
> pointer dereference when rsp->msix is NULL:
> [=E2=80=A6]
> The affected code was introduced by commit cdb898c52d1dfad4b4800b83a5=
8b3fe5d352edde
> (qla2xxx: Add irq affinity notification).
>=20
> Only dereference rsp->msix when it has been set so the machine can bo=
ot
> fine. Possibly rsp->msix is unset because:
> [    3.479679] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HB=
A Driver: 8.07.00.33-k.
> [    3.481839] qla2xxx [0000:13:00.0]-001d: : Found an ISP2432 irq 17=
 iobase 0xffffc90000038000.
> [    3.484081] qla2xxx [0000:13:00.0]-0035:0: MSI-X; Unsupported ISP2=
432 (0x2, 0x3).
> [    3.485804] qla2xxx [0000:13:00.0]-0037:0: Falling back-to MSI mod=
e -258.
> [    3.890145] scsi host0: qla2xxx
> [    3.891956] qla2xxx [0000:13:00.0]-00fb:0: QLogic QLE2460 - PCI-Ex=
press Single Channel 4Gb Fibre Channel HBA.
> [    3.894207] qla2xxx [0000:13:00.0]-00fc:0: ISP2432: PCIe (2.5GT/s =
x4) @ 0000:13:00.0 hdma+ host#=3D0 fw=3D7.03.00 (9496).
> [    5.714774] qla2xxx [0000:13:00.0]-500a:0: LOOP UP detected (4 Gbp=
s).

Bruno: Does that mean you actually tested that patch and it fixed the
problem for you? It looks like it, but there is some confusion about it=
;
that's one of the reasons why this patch didn't get any further yet
afaics, so a quick clarification might help to finally get this fixed
properly in mainline and stable.

Himanshu: While at it: Can you confirm this patch should get merged to
mainline? Seems Quinn is on PTO and his out-of-office reply mentioned
you as one point of contact.

Cheers, your regression tracker for Linux 4.7
 Thorsten

> CC: <stable@vger.kernel.org>
> Signed-off-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> b/drivers/scsi/qla2xxx/qla_isr.c index 5649c20..a92a62d 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2548,7 +2548,7 @@ void qla24xx_process_response_queue(struct
> scsi_qla_host *vha, if (!vha->flags.online)
>  		return;
> =20
> -	if (rsp->msix->cpuid !=3D smp_processor_id()) {
> +	if (rsp->msix && rsp->msix->cpuid !=3D smp_processor_id()) {
>  		/* if kernel does not notify qla of IRQ's CPU change,
>  		 * then set it here.
>  		 */
>=20
> http://news.gmane.org/find-root.php?message_id=3D20160630170032.6dbaf=
496%40pluto.restena.lu=20
> http://mid.gmane.org/20160630170032.6dbaf496%40pluto.restena.lu
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
