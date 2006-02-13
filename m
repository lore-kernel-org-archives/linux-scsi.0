From: Fredrik Roubert <roubert@df.lth.se>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Mon, 13 Feb 2006 18:10:52 +0100
Message-ID: <20060213171052.GI18853@igloo.df.lth.se>
References: <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <Pine.LNX.4.60.0602130043540.19775@poirot.grange> <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.df.lth.se ([194.47.250.47]:39877 "EHLO df.lth.se")
	by vger.kernel.org with ESMTP id S932244AbWBMRLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 12:11:05 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0602130043540.19775@poirot.grange> <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sat 11 Feb 22:06 CET 2006, Guennadi Liakhovetski wrote:

> We know that, but because noone could reproduce such a situation, we
> couldn't test any fixes.

;-)

> ...and your 64-bit dual-core CPU makes it even more fun. On the other
> hand, it means we won't be able to test it on highmem... Unless you
> agree to swap it to a 32-bit machine for a test:-)

I actually have an old Pentium machine standing by that I could use for
testing (when the driver seems to work).

> Do you have, maybe, a test machine without important data on it for
> first tests, or at least, backup all your valuables. You've been
> warned:-)

;-) I depend on ReiserFS and good luck ... That's enough most of the ti=
me.

On Mon 13 Feb 00:47 CET 2006, Guennadi Liakhovetski wrote:

> Ok, if you feel adventurous, you might try the patch below.

OK, that patch compiles with the following warnings:

drivers/scsi/dc395x.c: In function =91dump_register_info=92:
drivers/scsi/dc395x.c:1226: warning: format =91%i=92 expects type =91in=
t=92, but argument 5 has type =91size_t=92
drivers/scsi/dc395x.c: In function =91data_in_phase0=92:
drivers/scsi/dc395x.c:2322: warning: comparison of distinct pointer typ=
es lacks a cast
drivers/scsi/dc395x.c: In function =91dc395x_init_one=92:
drivers/scsi/dc395x.c:4357: warning: =91ptr=92 may be used uninitialize=
d in this function

Then it gives the following syslog output when I load the module and tr=
y
to scan an image:

=46eb 13 18:00:39 skalman kernel: dc395x: Tekram DC395(U/UW/F), DC315(U=
) - ASIC TRM-S1040 v2.05, 2004/03/08
=46eb 13 18:00:39 skalman kernel: ACPI: PCI Interrupt 0000:04:05.0[A] -=
> GSI 20 (level, low) -> IRQ 19
=46eb 13 18:00:39 skalman kernel: dc395x: Used settings: AdapterID=3D07=
, Speed=3D0(20.0MHz), dev_mode=3D0x57
=46eb 13 18:00:39 skalman kernel: dc395x:                AdaptMode=3D0x=
0f, Tags=3D4(16), DelayReset=3D1s
=46eb 13 18:00:39 skalman kernel: dc395x: Connectors:  Termination: Aut=
o Low High
=46eb 13 18:00:39 skalman kernel: dc395x: Performing initial SCSI bus r=
eset
=46eb 13 18:00:39 skalman kernel: scsi3 : Tekram DC395(U/UW/F), DC315(U=
) - ASIC TRM-S1040 v2.05, 2004/03/08
=46eb 13 18:00:41 skalman kernel:   Vendor: HP        Model: C2520A    =
        Rev: 3503
=46eb 13 18:00:41 skalman kernel:   Type:   Processor                  =
        ANSI SCSI revision: 02
=46eb 13 18:00:41 skalman kernel:  3:0:2:0: Attached scsi generic sg2 t=
ype 3
=46eb 13 18:02:57 skalman kernel: dc395x: reselect: w/o disconnected cm=
ds <02-0>
=46eb 13 18:02:57 skalman kernel: dc395x: disconnect: Unexpected resele=
ction <02-0>
=46eb 13 18:04:57 skalman kernel: dc395x: eh_abort: (pid#751) target=3D=
<02-0> cmd=3Dffff81007eb64080
=46eb 13 18:04:57 skalman kernel: dc395x: eh_abort: Command in progress=
<6>dc395x: eh_bus_reset: (pid#751) target=3D<02-0> cmd=3Dffff81007eb640=
80
=46eb 13 18:04:57 skalman kernel: dc395x: doing_srb_done: pids G:751(02=
-0)

Cheers // Fredrik Roubert

--=20
S=F6rbyplan 5       |  +46 8 7609169 / +46 708 776974
SE-163 71 Sp=E5nga  |  http://www.df.lth.se/~roubert/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
