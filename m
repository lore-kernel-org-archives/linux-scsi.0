From: =?iso-8859-1?Q?Csaba_Hal=E1sz?= <hcs@ics2.ics.tvnet.hu>
Subject: RE: Strange Diamond Fireport 20 (53c875J Rev4) problems
Date: Wed, 1 May 2002 18:42:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000001c1f12f$249647b0$0700a8c0@JESTER>
References: <20020430021726.V1554-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020430021726.V1554-100000@localhost.my.domain>
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?'G=E9rard_Roudier'?= <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org

Dear G=E9rard,

Thank you for your quick answer.

I indeed had to remove the FE_RAM flag just as you said to get the driv=
er
loaded. I am using a "dd if=3D/dev/srx of=3D/dev/null bs=3D2048" comman=
d for
testing. If I leave the FE_PFEN flag then I get this for my cd-rom:

May  1 15:21:48 defiant kernel: sym0:5:0:internal error: cmd=3D11 !=3D
9f=3D(vdsp[0] >> 24)
May  1 15:21:48 defiant kernel: sym0: SCSI BUS reset detected.
May  1 15:21:48 defiant kernel: sym0: SCSI BUS has been reset.

(also with cmd=3D19)
=46or my cd writer:

May  1 16:39:12 defiant kernel: sym0:6:0:phase change 7-1 1@1b9fa778
resid=3D1.
May  1 16:39:12 defiant kernel: sym0: SCSI BUS reset detected.
May  1 16:39:12 defiant kernel: sym0: SCSI BUS has been reset.

If I remove the FE_PFEN flag as well, then I get this for my cd writer:

May  1 15:49:34 defiant kernel: sym0:6: No MSG IN phase after reselecti=
on.
May  1 15:50:04 defiant kernel: sym0:6:0: ABORT operation started.
May  1 15:50:09 defiant kernel: sym0:6:0: ABORT operation timed-out.
May  1 15:50:09 defiant kernel: sym0:6:0: ABORT operation started.
May  1 15:50:14 defiant kernel: sym0:6:0: ABORT operation timed-out.
May  1 15:50:14 defiant kernel: sym0:6:0: DEVICE RESET operation starte=
d.
May  1 15:50:19 defiant kernel: sym0:6:0: DEVICE RESET operation timed-=
out.
May  1 15:50:19 defiant kernel: sym0:6:0: BUS RESET operation started.
May  1 15:50:19 defiant kernel: sym0: SCSI BUS reset detected.
May  1 15:50:19 defiant kernel: sym0: SCSI BUS has been reset.
May  1 15:50:19 defiant kernel: sym0:6:0: BUS RESET operation complete.
May  1 15:52:21 defiant kernel: sym0:6: No IDENTIFY after reselection.
May  1 15:52:51 defiant kernel: sym0:6:0: ABORT operation started.
May  1 15:52:56 defiant kernel: sym0:6:0: ABORT operation timed-out.
May  1 15:52:56 defiant kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 0 channel 0 id 6 lun 0
May  1 15:53:06 defiant kernel: sym0:6:0: ABORT operation started.
May  1 15:53:11 defiant kernel: sym0:6:0: ABORT operation timed-out.
May  1 15:53:11 defiant kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 0 channel 0 id 6 lun 0

at which point dd returns, but rmmod locks up.
=46or my cd-rom:

May  1 15:58:24 defiant kernel: sym0:5: FAST-10 SCSI 10.0 MB/s ST (100.=
0 ns,
offset 15)
May  1 15:58:39 defiant kernel: sym0:5: No IDENTIFY after reselection.
May  1 15:59:09 defiant kernel: sym0:5:0: ABORT operation started.
May  1 15:59:14 defiant kernel: sym0:5:0: ABORT operation timed-out.
May  1 15:59:14 defiant kernel: sym0:5:0: ABORT operation started.
May  1 15:59:19 defiant kernel: sym0:5:0: ABORT operation timed-out.
May  1 15:59:19 defiant kernel: sym0:5:0: DEVICE RESET operation starte=
d.
May  1 15:59:24 defiant kernel: sym0:5:0: DEVICE RESET operation timed-=
out.
May  1 15:59:24 defiant kernel: sym0:5:0: BUS RESET operation started.
May  1 15:59:24 defiant kernel: sym0: SCSI BUS reset detected.
May  1 15:59:24 defiant kernel: sym0: SCSI BUS has been reset.
May  1 15:59:24 defiant kernel: sym0:5:0: BUS RESET operation complete.
May  1 15:59:32 defiant kernel: sym0:5: No IDENTIFY after reselection.

at which point the driver locks up, dd is stuck in "D" state and rmmod
says "device or resource busy".
Note that the transfer mode is synchronous, even though the SYM-1 drive=
r
uses async mode. Just to check that possibility I used the "setsync 5 0=
"
sysctl, but the results were the same.

Removing FE_LDSTR I get this:

May  1 16:30:53 defiant kernel: sym0:6: ERROR (81:0) (8-0-0) (0/5/0) @
(scripta c:00000000).
May  1 16:30:53 defiant kernel: sym0: script cmd =3D 00000000
May  1 16:30:53 defiant kernel: sym0: regdump: da 00 40 05 47 00 06 0f =
04 08
86 00 80 00 07 02 00 a0 2f 1e 02 ff ff ff.
May  1 16:30:53 defiant kernel: sym0: SCSI BUS reset detected.
May  1 16:30:53 defiant kernel: sym0: SCSI BUS has been reset.

May  1 16:31:09 defiant kernel: sym0:5: ERROR (81:0) (8-0-0) (f/35/0) @
(scripta c:00000000).
May  1 16:31:09 defiant kernel: sym0: script cmd =3D 00000000
May  1 16:31:09 defiant kernel: sym0: regdump: da 00 40 35 47 0f 05 0f =
04 08
85 00 80 00 07 02 00 a0 2f 1e 02 ff ff ff.
May  1 16:31:09 defiant kernel: sym0: SCSI BUS reset detected.
May  1 16:31:09 defiant kernel: sym0: SCSI BUS has been reset.

The other flags do not seem to have an effect on this problem, I even w=
ent
all the way to just FE_DBLR|FE_VARCLK.
I also tried using IO mapped mode instead of memory mapped, but that di=
dn't
help either.

Do you have any more suggestions?

Greets,
	Csaba

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
