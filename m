From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: 2.6.3 gdth driver NMI Watchdog detected LOCKUP
Date: Fri, 26 Mar 2004 13:49:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B51CDBDEB98C094BB6E1985861F53AF302DD6E@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:30642 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264079AbUCZMt1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 07:49:27 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Florian Lohoff <flo@rfc822.org>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,

thanks for reporting this problem. I will include the change into our n=
ew driver version and will send a patch for 2.6.4 on Monday next week t=
o Linus.

Achim Leubner
Research & Development
ICP vortex Computersysteme GmbH
Gostritzer Str. 61-63
D-01217 Dresden, Germany
Phone: +49-351-871-8291
=46ax: +49-351-871-8448
Email: achim_leubner@adaptec.com
Web: www.icp-vortex.com=A0


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Florian
> Lohoff
> Sent: Donnerstag, 25. M=E4rz 2004 21:05
> To: linux-kernel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> Subject: 2.6.3 gdth driver NMI Watchdog detected LOCKUP
>=20
>=20
> Hi,
> i got this NMI on one of our Machines - I have seen these kinds of de=
adlocks
> on 2.4 too - Iirc its a locking problem on long overdue requests and =
the scsi_eh
> kicking in. I think i spotted this already in 2.4.18 back in May 2002=
 (Mail attached).
>=20
> Dual PIII 1Ghz, Serverworks Chipset, ICP Vortex
> Vanilla 2.6.3
>=20
> 00:05.0 SCSI storage controller: ICP Vortex Computersysteme GmbH GDT =
6123RS/6523RS
>         Subsystem: ICP Vortex Computersysteme GmbH GDT 6123RS/6523RS
>         Flags: bus master, medium devsel, latency 32, IRQ 18
>         Memory at fe000000 (32-bit, prefetchable) [size=3D16K]
>         Expansion ROM at <unassigned> [disabled] [size=3D32K]
>         Capabilities: [80] Power Management version 2
>=20
> Adapter 0: Host Drive 0: resetted locally
> Adapter 0: Host Drive 0: resetted locally
> NMI Watchdog detected LOCKUP on CPU0, eip c0116e24, registers:
> CPU:    0
> EIP:    0060:[<c0116e24>]    Not tainted
> EFLAGS: 00000083
> EIP is at delay_tsc+0x14/0x20
> eax: 52bff37b   ebx: 000f0b90   ecx: 52b42ab1   edx: 00006b5a
> esi: c00981c0   edi: 00000000   ebp: 00000002   esp: f7fabe8c
> ds: 007b   es: 007b   ss: 0068
> Process scsi_eh_2 (pid: 18, threadinfo=3Df7faa000 task=3Df7dc6c00)
> Stack: ffffffff c01eade2 000f0b90 c0261ffd 000f0b90 0001734e c026258a=
 00000001
>        c00981c0 00000000 00000000 c009ae80 c00981c0 00000002 00000000=
 c02626e0
>        00000000 00000002 000186a0 000186a0 00000018 09000000 00000000=
 c00981c0
> Call Trace:
>  [<c01eade2>] __delay+0x12/0x20
>  [<c0261ffd>] gdth_delay+0x2d/0x60
>  [<c026258a>] gdth_wait+0x6a/0xc0
>  [<c02626e0>] gdth_internal_cmd+0x100/0x1e0
>  [<c026582c>] gdth_eh_bus_reset+0x24c/0x2c0
>  [<c024e456>] scsi_try_bus_reset+0x56/0xf0
>  [<c024b7e4>] __scsi_iterate_devices+0x84/0xa0
>  [<c024e639>] scsi_eh_bus_reset+0x59/0xf0
>  [<c024eb80>] scsi_eh_ready_devs+0x50/0x80
>  [<c024ed20>] scsi_unjam_host+0xe0/0xf0
>  [<c024ee28>] scsi_error_handler+0xf8/0x150
>  [<c024ed30>] scsi_error_handler+0x0/0x150
>  [<c0108c19>] kernel_thread_helper+0x5/0xc
>=20
> Code: 29 c8 39 d8 72 f6 5b c3 8d 74 26 00 55 b8 00 e0 ff ff 57 56
> console shuts up ...
>  EIP is at __preempt_spin_lock+ 0x50/0x70
>=20
>=20
>=20
>=20
> I guess modifying "gdth_polling" needs to be move infront of taking t=
he
> lock and needs to be guranteed written out to mem (memory barrier ?
> atomic_set ?)
>=20
> drivers/scsi/gdth.c:gdth_eh_bus_reset
>=20
>    4779
>    4780     if (b =3D=3D ha->virt_bus) {
>    4781         /* host drives */
>    4782         for (i =3D 0; i < MAX_HDRIVES; ++i) {
>    4783             if (ha->hdr[i].present) {
>    4784                 GDTH_LOCK_HA(ha, flags);
>    4785                 gdth_polling =3D TRUE;
>    4786                 while (gdth_test_busy(hanum))
>    4787                     gdth_delay(0);
>    4788                 if (gdth_internal_cmd(hanum, CACHESERVICE,
>    4789                                       GDT_CLUST_RESET, i, 0, =
0))
>    4790                     ha->hdr[i].cluster_type &=3D ~CLUSTER_RES=
ERVED;
>    4791                 gdth_polling =3D FALSE;
>    4792                 GDTH_UNLOCK_HA(ha, flags);
>    4793             }
>    4794         }
>    4795     } else {
>    4796         /* raw devices */
>    4797         GDTH_LOCK_HA(ha, flags);
>    4798         for (i =3D 0; i < MAXID; ++i)
>    4799             ha->raw[BUS_L2P(ha,b)].io_cnt[i] =3D 0;
>    4800         gdth_polling =3D TRUE;
>    4801         while (gdth_test_busy(hanum))
>    4802             gdth_delay(0);
>    4803         gdth_internal_cmd(hanum, SCSIRAWSERVICE, GDT_RESET_BU=
S,
>    4804                           BUS_L2P(ha,b), 0, 0);
>    4805         gdth_polling =3D FALSE;
>    4806         GDTH_UNLOCK_HA(ha, flags);
>    4807     }
>    4808     return SUCCESS;
>    4809 }
>    4810
>=20
> vs.
>=20
> drivers/scsi/gdth.c:gdth_interrupt
>=20
>    3390     if (!gdth_polling)
>    3391         GDTH_LOCK_HA((gdth_ha_str *)dev_id,flags);
>    3392     wait_index =3D 0;
>=20
> So we have a small race.
>=20
> I would propose something like this:
>=20
>=20
> --- linux-2.6.3/drivers/scsi/gdth.c.orig	2004-03-25 20:58:18.00000000=
0 +0100
> +++ linux-2.6.3/drivers/scsi/gdth.c	2004-03-25 20:59:28.000000000 +01=
00
> @@ -4781,29 +4781,29 @@
>          /* host drives */
>          for (i =3D 0; i < MAX_HDRIVES; ++i) {
>              if (ha->hdr[i].present) {
> -                GDTH_LOCK_HA(ha, flags);
>                  gdth_polling =3D TRUE;
> +                GDTH_LOCK_HA(ha, flags);
>                  while (gdth_test_busy(hanum))
>                      gdth_delay(0);
>                  if (gdth_internal_cmd(hanum, CACHESERVICE,
>                                        GDT_CLUST_RESET, i, 0, 0))
>                      ha->hdr[i].cluster_type &=3D ~CLUSTER_RESERVED;
> -                gdth_polling =3D FALSE;
>                  GDTH_UNLOCK_HA(ha, flags);
> +                gdth_polling =3D FALSE;
>              }
>          }
>      } else {
>          /* raw devices */
> +        gdth_polling =3D TRUE;
>          GDTH_LOCK_HA(ha, flags);
>          for (i =3D 0; i < MAXID; ++i)
>              ha->raw[BUS_L2P(ha,b)].io_cnt[i] =3D 0;
> -        gdth_polling =3D TRUE;
>          while (gdth_test_busy(hanum))
>              gdth_delay(0);
>          gdth_internal_cmd(hanum, SCSIRAWSERVICE, GDT_RESET_BUS,
>                            BUS_L2P(ha,b), 0, 0);
> -        gdth_polling =3D FALSE;
>          GDTH_UNLOCK_HA(ha, flags);
> +        gdth_polling =3D FALSE;
>      }
>      return SUCCESS;
>  }
>=20
>=20
> --
> Florian Lohoff                  flo@rfc822.org             +49-171-22=
80134
>                         Heisenberg may have been here.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
