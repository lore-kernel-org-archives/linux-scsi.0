From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Sun, 30 Aug 2009 01:27:35 +0200
Message-ID: <200908300127.35339.a.miskiewicz@gmail.com>
References: <Pine.LNX.4.44L0.0908251912370.3665-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45598 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbZH2X1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 19:27:41 -0400
Received: by bwz19 with SMTP id 19so2186861bwz.37
        for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 16:27:41 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0908251912370.3665-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Wednesday 26 of August 2009, Alan Stern wrote:
> On Tue, 25 Aug 2009, Arkadiusz Miskiewicz wrote:
> > On Tuesday 25 of August 2009, Arkadiusz Miskiewicz wrote:
> > > On Tuesday 25 of August 2009, you wrote:
> > > > On Tue, 2009-08-25 at 21:44 +0200, Arkadiusz Miskiewicz wrote:
> > > > > On Tuesday 25 of August 2009, James Bottomley wrote:
> > > > > > On Tue, 2009-08-25 at 21:24 +0200, Arkadiusz Miskiewicz wro=
te:
> > > > > > > What could be the reason for scsi_wait_scan not waiting u=
ntill
> > > > > > > all disks are found?
> > > > > > >
> > > > > > > I'm testing 2.6.30.5 on hardware with LSI Logic / Symbios=
 Logic
> > > > > > > MegaRAID 530 SCSI 320-0X RAID controller and modprobe
> > > > > > > scsi_wait_scan finishes earlier than disks are found.
> > > > > > >
> > > > > > > My initrd (romfs) does:
> > > > > > > insmod
> > > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_mod.ko
> > > > > > > insmod
> > > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/me=
garaid
> > > > > > >_mm. ko insmod
> > > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/megaraid/me=
garaid
> > > > > > >_mbo x. ko insmod
> > > > > > > /lib/modules/2.6.30.5-0.3/kernel/lib/crc-t10dif.ko insmod
> > > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/sd_mod.ko i=
nsmod
> > > > > > > /lib/modules/2.6.30.5-0.3/kernel/drivers/scsi/scsi_wait_s=
can.ko
> > > > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/exportfs/expor=
tfs.ko
> > > > > > > insmod /lib/modules/2.6.30.5-0.3/kernel/fs/xfs/xfs.ko
> > > > > > > if [ "${ROOT##/dev/}" !=3D "${ROOT}" ]; then
> > > > > > > rootnr=3D"$(busybox awk -v rootnode=3D"${ROOT##/dev/}" '$=
4 =3D=3D
> > > > > > > rootnode { print 256 * $1 + $2 }' /proc/partitions)"
> > > > > > > if [ -n "$rootnr" ]; then
> > > > > > > echo "$rootnr" > /proc/sys/kernel/real-root-dev
> > > > > > > fi
> > > > > > >
> > > > > > >
> > > > > > > Now if I add sleep few seconds or /bin/sh at the end of t=
his
> > > > > > > initrd, then boot and then disks are detected properly an=
d
> > > > > > > rootfs is mounted properly (after I exit from sh in case =
when
> > > > > > > /bin/sh is used).
> > > > > > >
> > > > > > > The question remains - why scsi_wait_scan doesn't wait?
> > > > > >
> > > > > > It's caused by the sd async patches.  What's happening is
> > > > > > wait_scan is waiting until all the scans are complete, but =
now sd
> > > > > > attachment may not be completed by the time that happens.  =
So,
> > > > > > although you have a scanned disk, you can't mount it withou=
t and
> > > > > > attached sd driver.
> > > > > >
> > > > > > Hopefully when
> > > > > > all initrds are configured to wait until root appears, this
> > > > > > problem will go away.
> > > > >
> > > > > Uh, ugly. I'll disable SCSI_SCAN_ASYNC here then.
> > > >
> > > > That won't actually help: the sd async scan is a separate mecha=
nism
> > > > not tied to that variable
> > >
> > > I assume there is no configurable way to disable this?
> >
> > I found this patch
> >
> > http://marc.info/?l=3Dlinux-scsi&m=3D124388639906873&w=3D2
> >
> > but it doesn't work on 30.5 (it's still not waiting untill everythi=
ng is
> > discovered)
>
> Did you remember to rebuild your initrd after applying this patch and
> rebuilding the module?

Patch was applied and module rebuilt. I'm 100% sure since I added print=
ks to confirm
(not included below).

>
> Can you provide the dmesg log showing what happens during bootup with
> the patch applied?

Hm, can console=3D point to netconsole somehow, so userspace messages c=
ould be seen
via netconsole? Anyway from netconsole:

Aug 30 01:07:16 rhea   13.144139] netconsole: network logging started
Aug 30 01:07:16 rhea   13.173297] SCSI subsystem initialized
Aug 30 01:07:16 rhea   13.189630] megaraid cmm: 2.20.2.7 (Release Date:=
 Sun Jul 16 00:01:03 EST 2006)
Aug 30 01:07:16 rhea   13.216688] megaraid: 2.20.5.1 (Release Date: Thu=
 Nov 16 15:32:35 EST 2006)
Aug 30 01:07:16 rhea   13.238942] megaraid: probe new device 0x1000:0x0=
407:0x1000:0x0530:
Aug 30 01:07:16 rhea bus: 2:slot 3:func 0
Aug 30 01:07:16 rhea   13.271180] megaraid 0000:02:03.0: PCI INT A -> G=
SI 27 (level, low) -> IRQ 27
Aug 30 01:07:16 rhea   13.316707] megaraid: fw version:[414G] bios vers=
ion:[A100]
Aug 30 01:07:16 rhea   13.334528] scsi0 : LSI Logic MegaRAID driver
Aug 30 01:07:16 rhea   13.352156] scsi[0]: scanning scsi channel 0 [Phy=
 0]
Aug 30 01:07:16 rhea for: non-raid devices
Aug 30 01:07:16 rhea   13.381065] Driver 'sd' needs updating - please u=
se bus_type methods
Aug 30 01:07:16 rhea   13.420430] SGI XFS with ACLs, security attribute=
s, large block/inode numbers, no debug enabled
Aug 30 01:07:16 rhea   13.453259] SGI XFS Quota Management subsystem
Aug 30 01:07:16 rhea   13.583779] VFS: Cannot open root device "802" or=
 unknown-block(8,2)
Aug 30 01:07:16 rhea   13.602814] Please append a correct "root=3D" boo=
t option; here are the available partitions:
Aug 30 01:07:16 rhea   13.627824] Kernel panic - not syncing: VFS: Unab=
le to mount root fs on unknown-block(8,2)
Aug 30 01:07:16 rhea   13.652637] Pid: 1, comm: swapper Not tainted 2.6=
=2E30.5-vs2.3.0.36.14-pre7-0.3 #4
Aug 30 01:07:16 rhea   13.674797] Call Trace:
Aug 30 01:07:16 rhea   13.682138]  [<ffffffff8056e75d>] ? panic+0x7a/0x=
12e
Aug 30 01:07:16 rhea   13.697003]  [<ffffffff8056e851>] ? printk+0x40/0=
x47
Aug 30 01:07:16 rhea   13.711890]  [<ffffffff8072e090>] ? mount_block_r=
oot+0x1d6/0x271
Aug 30 01:07:16 rhea   13.729892]  [<ffffffff8072ecdb>] ? initrd_load+0=
x228/0x324
Aug 30 01:07:16 rhea   13.746585]  [<ffffffff8072e24f>] ? prepare_names=
pace+0xd5/0x18d
Aug 30 01:07:16 rhea   13.764578]  [<ffffffff8072d6cf>] ? kernel_init+0=
x178/0x188
Aug 30 01:07:16 rhea   13.781282]  [<ffffffff8020ceba>] ? child_rip+0xa=
/0x20
Aug 30 01:07:16 rhea   13.796686]  [<ffffffff8072d557>] ? kernel_init+0=
x0/0x188
Aug 30 01:07:16 rhea   13.812858]  [<ffffffff8020ceb0>] ? child_rip+0x0=
/0x20
Aug 30 01:07:16 rhea   13.828253] Rebooting in 60 seconds

and from ipmi console (this one is totally trashed, ipm console is crap=
 in this machine)

[    2.080325] Block layer SCSI generic (bsg) drive550 driver, 4 ports,=
 IRQ sharing enabled
[    2.553445] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4input/input0
[    2.950179] Fixed MDIO Bus: probed
[    2.960632] PNP: PS/2 Controller [PNP030er
[    3.097910] cpuidle: using governor menu
[    3.109941] TCP cubic registered
[    3.120MDISK: gzip image found at block 0
[    3.415767] VFS: Mounted root (romfs filesystem) readonlylow) -> IRQ=
 55
[    4.148743] e1000: 0000:03:04.1: e1000_probe: (PCI-X:100MHz:64-bit) =
00:04:23:[    4.353818] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.934118] e1000: eth0 NIC Linkraid: 2.20.5.1 (Release Date: Thu No=
v 16 15:32:35 EST 2006)
dules/2.6.30.5-v[   13.238942] megas/scsi/meg[   13.352156] scsi[0]: sc=
anning scsi channel 0 [Phy 0] for non-raid devices
araid/menel/drivers/scsi/scsi_wait_scan.ko
+ insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernelng: VFS: Un=
able to mount root fs on unknown-block(8,2)
[   13.652637] Pid: 1, comm: swapper Not  [<ffffffff8072d6cf>] ? kernel=
_init+0x178/0x188
[   13.781282]  [<ffffffff8020ceba>] ? child_r


initrd was doing:
=2E..
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/net/=
e1000/e1000.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/fs/configfs/=
configfs.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/net/=
netconsole.ko netconsole=3Dxxx
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/scsi=
/scsi_mod.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/scsi=
/megaraid/megaraid_mm.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/scsi=
/megaraid/megaraid_mbox.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/lib/crc-t10d=
if.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/scsi=
/sd_mod.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/drivers/scsi=
/scsi_wait_scan.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/fs/exportfs/=
exportfs.ko
insmod /lib/modules/2.6.30.5-vs2.3.0.36.14-pre7-0.3/kernel/fs/xfs/xfs.k=
o
=2E..

and of course adding sleep 10 after scsi_wait_scan fixes boot
>
> Alan Stern


--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
