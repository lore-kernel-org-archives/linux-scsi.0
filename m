From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: RE: Strange Diamond Fireport 20 (53c875J Rev4) problems
Date: Fri, 3 May 2002 02:08:11 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020503012540.U355-100000@localhost.my.domain>
References: <000001c1f12f$249647b0$0700a8c0@JESTER>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <000001c1f12f$249647b0$0700a8c0@JESTER>
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Csaba_Hal=E1sz?= <hcs@ics2.ics.tvnet.hu>
Cc: linux-scsi@vger.kernel.org



On Wed, 1 May 2002, Csaba Hal=E1sz wrote:

> Dear G=E9rard,
>
> Thank you for your quick answer.
>
> I indeed had to remove the FE_RAM flag just as you said to get the dr=
iver
> loaded. I am using a "dd if=3D/dev/srx of=3D/dev/null bs=3D2048" comm=
and for
> testing. If I leave the FE_PFEN flag then I get this for my cd-rom:
>
> May  1 15:21:48 defiant kernel: sym0:5:0:internal error: cmd=3D11 !=3D
> 9f=3D(vdsp[0] >> 24)

Never seen this one before.
It might be a driver internal error, but it also happens if the chip is
lying about the actual value of the interrupted SCRIPTS address on a
phase mismatch (i.e. DSP register value not correct).

> May  1 15:21:48 defiant kernel: sym0: SCSI BUS reset detected.
> May  1 15:21:48 defiant kernel: sym0: SCSI BUS has been reset.
>
> (also with cmd=3D19)

Same as above.

> For my cd writer:
>
> May  1 16:39:12 defiant kernel: sym0:6:0:phase change 7-1 1@1b9fa778
> resid=3D1.
> May  1 16:39:12 defiant kernel: sym0: SCSI BUS reset detected.
> May  1 16:39:12 defiant kernel: sym0: SCSI BUS has been reset.
>
> If I remove the FE_PFEN flag as well, then I get this for my cd write=
r:
>
>
> May  1 15:49:34 defiant kernel: sym0:6: No MSG IN phase after reselec=
tion.
> May  1 15:50:04 defiant kernel: sym0:6:0: ABORT operation started.
> May  1 15:50:09 defiant kernel: sym0:6:0: ABORT operation timed-out.
> May  1 15:50:09 defiant kernel: sym0:6:0: ABORT operation started.
> May  1 15:50:14 defiant kernel: sym0:6:0: ABORT operation timed-out.
> May  1 15:50:14 defiant kernel: sym0:6:0: DEVICE RESET operation star=
ted.
> May  1 15:50:19 defiant kernel: sym0:6:0: DEVICE RESET operation time=
d-out.
> May  1 15:50:19 defiant kernel: sym0:6:0: BUS RESET operation started=
=2E
> May  1 15:50:19 defiant kernel: sym0: SCSI BUS reset detected.
> May  1 15:50:19 defiant kernel: sym0: SCSI BUS has been reset.
> May  1 15:50:19 defiant kernel: sym0:6:0: BUS RESET operation complet=
e.
> May  1 15:52:21 defiant kernel: sym0:6: No IDENTIFY after reselection=
=2E
> May  1 15:52:51 defiant kernel: sym0:6:0: ABORT operation started.
> May  1 15:52:56 defiant kernel: sym0:6:0: ABORT operation timed-out.
> May  1 15:52:56 defiant kernel: scsi: device set offline - not ready =
or
> command retry failed after bus reset: host 0 channel 0 id 6 lun 0
> May  1 15:53:06 defiant kernel: sym0:6:0: ABORT operation started.
> May  1 15:53:11 defiant kernel: sym0:6:0: ABORT operation timed-out.
> May  1 15:53:11 defiant kernel: scsi: device set offline - not ready =
or
> command retry failed after bus reset: host 0 channel 0 id 6 lun 0

The PFEN flag makes the driver enable SCRIPTS intructions prefetching.
When cleared, the driver does not enable this chip feature. Normally :)=
,
this should not affect the chip behaviour, since it is just a PCI
optimization that is enabled by default. The difference looks extremall=
y
weird to me.

The apparent errors reported (no MSG IN phase or No IDENTIFY after
reselection) that happen for both your cdw and cd) are probably not rea=
l.
Since SCSI-2, SCSI devices are required to send an IDENTIFY message aft=
er
reselection.

> at which point dd returns, but rmmod locks up.
> For my cd-rom:
>
> May  1 15:58:24 defiant kernel: sym0:5: FAST-10 SCSI 10.0 MB/s ST (10=
0.0 ns,
> offset 15)
> May  1 15:58:39 defiant kernel: sym0:5: No IDENTIFY after reselection=
=2E
> May  1 15:59:09 defiant kernel: sym0:5:0: ABORT operation started.
> May  1 15:59:14 defiant kernel: sym0:5:0: ABORT operation timed-out.
> May  1 15:59:14 defiant kernel: sym0:5:0: ABORT operation started.
> May  1 15:59:19 defiant kernel: sym0:5:0: ABORT operation timed-out.
> May  1 15:59:19 defiant kernel: sym0:5:0: DEVICE RESET operation star=
ted.
> May  1 15:59:24 defiant kernel: sym0:5:0: DEVICE RESET operation time=
d-out.
> May  1 15:59:24 defiant kernel: sym0:5:0: BUS RESET operation started=
=2E
> May  1 15:59:24 defiant kernel: sym0: SCSI BUS reset detected.
> May  1 15:59:24 defiant kernel: sym0: SCSI BUS has been reset.
> May  1 15:59:24 defiant kernel: sym0:5:0: BUS RESET operation complet=
e.
> May  1 15:59:32 defiant kernel: sym0:5: No IDENTIFY after reselection=
=2E
>
> at which point the driver locks up, dd is stuck in "D" state and rmmo=
d
> says "device or resource busy".
> Note that the transfer mode is synchronous, even though the SYM-1 dri=
ver
> uses async mode. Just to check that possibility I used the "setsync 5=
 0"
> sysctl, but the results were the same.
>
> Removing FE_LDSTR I get this:

When both FE_LDSTR and FE_PFEN are removed, the driver is expected to u=
se
the generic SCRIPTS instead of the LOAD/STORE based one. If only FE_LDS=
TR
is cleared, the driver should refuse to load your HBA. I will assume th=
at
you removed both FE_LDSTR and FE_PFEN.

> May  1 16:30:53 defiant kernel: sym0:6: ERROR (81:0) (8-0-0) (0/5/0) =
@
> (scripta c:00000000).
> May  1 16:30:53 defiant kernel: sym0: script cmd =3D 00000000
> May  1 16:30:53 defiant kernel: sym0: regdump: da 00 40 05 47 00 06 0=
f 04 08
> 86 00 80 00 07 02 00 a0 2f 1e 02 ff ff ff.
> May  1 16:30:53 defiant kernel: sym0: SCSI BUS reset detected.
> May  1 16:30:53 defiant kernel: sym0: SCSI BUS has been reset.
>
> May  1 16:31:09 defiant kernel: sym0:5: ERROR (81:0) (8-0-0) (f/35/0)=
 @
> (scripta c:00000000).
> May  1 16:31:09 defiant kernel: sym0: script cmd =3D 00000000
> May  1 16:31:09 defiant kernel: sym0: regdump: da 00 40 35 47 0f 05 0=
f 04 08
> 85 00 80 00 07 02 00 a0 2f 1e 02 ff ff ff.
> May  1 16:31:09 defiant kernel: sym0: SCSI BUS reset detected.
> May  1 16:31:09 defiant kernel: sym0: SCSI BUS has been reset.

Still very strange errors.
The interrupted address reported by the chip is 0xc which points inside=
 a
2 DWORDs SCRIPTS instruction. Normally, the SCRIPTS processor is suppos=
ed
to fetch at least 2 DWORDS and then try to decode.

> The other flags do not seem to have an effect on this problem, I even=
 went
> all the way to just FE_DBLR|FE_VARCLK.
> I also tried using IO mapped mode instead of memory mapped, but that =
didn't
> help either.
>
> Do you have any more suggestions?

Nothing really great at the moment. Just, trying another sym53c8xx HBA,=
 if
possible, with same hardware and software to really get 100% sure about
the peoblem being related to this particular HBA (or not).

Regards,
  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
