From: Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer deref in QLA interrupt
Date: Mon, 11 Jul 2016 09:30:30 +0200
Message-ID: <8fadfa97-370f-7483-e80e-437f5338d3fd@leemhuis.info>
References: <20160630170032.6dbaf496@pluto.restena.lu>
 <94d0470f-7555-8098-b382-a4fdac9b0709@leemhuis.info>
 <20160711091729.57e67114@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160711091729.57e67114@pluto.restena.lu>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Bruno_Pr=c3=a9mont?= <bonbons@linux-vserver.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bruno Pr=C3=A9mont wrote on 11.07.2016 09:17:
> On Fri, 8 Jul 2016 09:27:18 +0200 Thorsten Leemhuis wrote:
>> Bruno Pr=C3=A9mont wrote on 30.06.2016 17:00:
>> > In qla24xx_process_response_queue() rsp->msix->cpuid may trigger N=
ULL
>> > pointer dereference when rsp->msix is NULL:
>> > [=E2=80=A6]
>> > The affected code was introduced by commit cdb898c52d1dfad4b4800b8=
3a58b3fe5d352edde
>> > (qla2xxx: Add irq affinity notification).
>> >=20
>> > Only dereference rsp->msix when it has been set so the machine can=
 boot
>> > fine. Possibly rsp->msix is unset because:
>> > [    3.479679] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel=
 HBA Driver: 8.07.00.33-k.
>> > [    3.481839] qla2xxx [0000:13:00.0]-001d: : Found an ISP2432 irq=
 17 iobase 0xffffc90000038000.
>> > [    3.484081] qla2xxx [0000:13:00.0]-0035:0: MSI-X; Unsupported I=
SP2432 (0x2, 0x3).
>> > [    3.485804] qla2xxx [0000:13:00.0]-0037:0: Falling back-to MSI =
mode -258.
>> > [    3.890145] scsi host0: qla2xxx
>> > [    3.891956] qla2xxx [0000:13:00.0]-00fb:0: QLogic QLE2460 - PCI=
-Express Single Channel 4Gb Fibre Channel HBA.
>> > [    3.894207] qla2xxx [0000:13:00.0]-00fc:0: ISP2432: PCIe (2.5GT=
/s x4) @ 0000:13:00.0 hdma+ host#=3D0 fw=3D7.03.00 (9496).
>> > [    5.714774] qla2xxx [0000:13:00.0]-500a:0: LOOP UP detected (4 =
Gbps). =20
>>=20
>> Bruno: Does that mean you actually tested that patch and it fixed th=
e
>> problem for you? It looks like it, but there is some confusion about=
 it;
>> that's one of the reasons why this patch didn't get any further yet
>> afaics, so a quick clarification might help to finally get this fixe=
d
>> properly in mainline and stable.
> Yes, it does fix the Oops for me.

Thx for the feedback. The patch hit mainline late last week (it's
included in rc7) and should hopefully make it to the stable trees in a
week or two.

> I did not analyze the reason why rsp->msix is NULL (no idea if
> it remains NULL forever on my hardware) - I just extracted messages
> from qla driver shown during boot which seem to indicate a possible
> reason why msix is NULL.
> Further analysis should be done by someone with better knowledge of q=
la
> driver than mine though I would be happy to perform tests.

I have no idea about the details, but in case you missed it, this
discussion might have some more relevant details:
http://thread.gmane.org/gmane.linux.kernel/2247804/focus=3D2250727

Cheers, Thorsten
