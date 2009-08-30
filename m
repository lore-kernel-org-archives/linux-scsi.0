From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Sun, 30 Aug 2009 10:12:51 +0200
Message-ID: <200908301012.51126.a.miskiewicz@gmail.com>
References: <Pine.LNX.4.44L0.0908292301460.27655-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52506 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZH3IMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2009 04:12:53 -0400
Received: by fxm17 with SMTP id 17so2250693fxm.37
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2009 01:12:54 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0908292301460.27655-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Sunday 30 of August 2009, Alan Stern wrote:
> On Sun, 30 Aug 2009, Arkadiusz Miskiewicz wrote:
> > > Can you provide the dmesg log showing what happens during bootup =
with
> > > the patch applied?
> >
> > Hm, can console=3D point to netconsole somehow, so userspace messag=
es could
> > be seen via netconsole? Anyway from netconsole:
> >
> > Aug 30 01:07:16 rhea   13.144139] netconsole: network logging start=
ed
> > Aug 30 01:07:16 rhea   13.173297] SCSI subsystem initialized
> > Aug 30 01:07:16 rhea   13.189630] megaraid cmm: 2.20.2.7 (Release D=
ate:
> > Sun Jul 16 00:01:03 EST 2006) Aug 30 01:07:16 rhea   13.216688] meg=
araid:
> > 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006) Aug 30 01:07:=
16
> > rhea   13.238942] megaraid: probe new device 0x1000:0x0407:0x1000:0=
x0530:
> > Aug 30 01:07:16 rhea bus: 2:slot 3:func 0
> > Aug 30 01:07:16 rhea   13.271180] megaraid 0000:02:03.0: PCI INT A =
-> GSI
> > 27 (level, low) -> IRQ 27 Aug 30 01:07:16 rhea   13.316707] megarai=
d: fw
> > version:[414G] bios version:[A100] Aug 30 01:07:16 rhea   13.334528=
]
> > scsi0 : LSI Logic MegaRAID driver Aug 30 01:07:16 rhea   13.352156]
> > scsi[0]: scanning scsi channel 0 [Phy 0] Aug 30 01:07:16 rhea for:
> > non-raid devices
> > Aug 30 01:07:16 rhea   13.381065] Driver 'sd' needs updating - plea=
se use
> > bus_type methods Aug 30 01:07:16 rhea   13.420430] SGI XFS with ACL=
s,
> > security attributes, large block/inode numbers, no debug enabled Au=
g 30
> > 01:07:16 rhea   13.453259] SGI XFS Quota Management subsystem Aug 3=
0
> > 01:07:16 rhea   13.583779] VFS: Cannot open root device "802" or
> > unknown-block(8,2) Aug 30 01:07:16 rhea   13.602814] Please append =
a
> > correct "root=3D" boot option; here are the available partitions: A=
ug 30
> > 01:07:16 rhea   13.627824] Kernel panic - not syncing: VFS: Unable =
to
> > mount root fs on unknown-block(8,2) Aug 30 01:07:16 rhea   13.65263=
7]
> > Pid: 1, comm: swapper Not tainted 2.6.30.5-vs2.3.0.36.14-pre7-0.3 #=
4 Aug
> > 30 01:07:16 rhea   13.674797] Call Trace:
> > Aug 30 01:07:16 rhea   13.682138]  [<ffffffff8056e75d>] ?
> > panic+0x7a/0x12e Aug 30 01:07:16 rhea   13.697003]  [<ffffffff8056e=
851>]
> > ? printk+0x40/0x47 Aug 30 01:07:16 rhea   13.711890]=20
> > [<ffffffff8072e090>] ? mount_block_root+0x1d6/0x271 Aug 30 01:07:16=
 rhea=20
> >  13.729892]  [<ffffffff8072ecdb>] ? initrd_load+0x228/0x324 Aug 30
> > 01:07:16 rhea   13.746585]  [<ffffffff8072e24f>] ?
> > prepare_namespace+0xd5/0x18d Aug 30 01:07:16 rhea   13.764578]=20
> > [<ffffffff8072d6cf>] ? kernel_init+0x178/0x188 Aug 30 01:07:16 rhea=
 =20
> > 13.781282]  [<ffffffff8020ceba>] ? child_rip+0xa/0x20 Aug 30 01:07:=
16
> > rhea   13.796686]  [<ffffffff8072d557>] ? kernel_init+0x0/0x188 Aug=
 30
> > 01:07:16 rhea   13.812858]  [<ffffffff8020ceb0>] ? child_rip+0x0/0x=
20 Aug
> > 30 01:07:16 rhea   13.828253] Rebooting in 60 seconds
> >
> > ...
> >
> > and of course adding sleep 10 after scsi_wait_scan fixes boot
>
> Not especially helpful, I'm afraid.  If you could add some extra prin=
tk
> statements, it would be better.  For example, you might add some
> KERN_INFO messages to sd.c at the start of sd_probe(), just before th=
e
> async_schedule() call near the end, and at the start of
> sd_probe_async().  In addition, some messages demarking the various
> steps of wait_scan_init() in scsi_wait_scan.c would be good.

Aug 30 10:05:41 rhea   13.342770] netconsole: network logging started
Aug 30 10:05:41 rhea   13.372165] SCSI subsystem initialized
Aug 30 10:05:41 rhea   13.386641] megaraid cmm: 2.20.2.7 (Release Date:=
 Sun Jul 16 00:01:03 EST 2006)
Aug 30 10:05:41 rhea   13.414015] megaraid: 2.20.5.1 (Release Date: Thu=
 Nov 16 15:32:35 EST 2006)
Aug 30 10:05:41 rhea   13.436123] megaraid: probe new device 0x1000:0x0=
407:0x1000:0x0530:
Aug 30 10:05:41 rhea bus: 2:slot 3:func 0
Aug 30 10:05:41 rhea   13.468399] megaraid 0000:02:03.0: PCI INT A -> G=
SI 27 (level, low) -> IRQ 27
Aug 30 10:05:41 rhea   13.516699] megaraid: fw version:[414G] bios vers=
ion:[A100]
Aug 30 10:05:41 rhea   13.535997] scsi0 : LSI Logic MegaRAID driver
Aug 30 10:05:41 rhea   13.553565] scsi[0]: scanning scsi channel 0 [Phy=
 0]
Aug 30 10:05:41 rhea for: non-raid devices
Aug 30 10:05:41 rhea   13.586494] Driver 'sd' needs updating - please u=
se bus_type methods
Aug 30 10:05:41 rhea   13.607265] wait_scan_init: BEFORE wait_for_devic=
e_probe
Aug 30 10:05:41 rhea   13.625998] wait_scan_init: AFTER wait_for_device=
_probe
Aug 30 10:05:41 rhea   13.645813] wait_scan_init: BEFORE scsi_complete_=
async_scans
Aug 30 10:05:41 rhea   13.666926] wait_scan_init: AFTER scsi_complete_a=
sync_scans
Aug 30 10:05:41 rhea   13.687750] wait_scan_init: BEFORE async_synchron=
ize_full
Aug 30 10:05:41 rhea   13.708100] wait_scan_init: AFTER wait_for_device=
_probe
Aug 30 10:05:42 rhea   13.973100] SGI XFS with ACLs, security attribute=
s, large block/inode numbers, no debug enabled
Aug 30 10:05:42 rhea   14.005223] SGI XFS Quota Management subsystem
Aug 30 10:05:42 rhea   14.093763] VFS: Cannot open root device "802" or=
 unknown-block(8,2)
Aug 30 10:05:42 rhea   14.112812] Please append a correct "root=3D" boo=
t option; here are the available partitions:
Aug 30 10:05:42 rhea   14.137870] Kernel panic - not syncing: VFS: Unab=
le to mount root fs on unknown-block(8,2)
Aug 30 10:05:42 rhea   14.140707] scsi 0:0:6:0: Processor         ESG-S=
HV  SCA HSBP M29     1.08 PQ: 0 ANSI: 2
Aug 30 10:05:42 rhea   14.186854] Pid: 1, comm: swapper Not tainted 2.6=
=2E30.5-vs2.3.0.36.14-pre7-0.3 #4
Aug 30 10:05:42 rhea   14.209012] Call Trace:
Aug 30 10:05:42 rhea   14.216352]  [<ffffffff8056e75d>] ? panic+0x7a/0x=
12e
Aug 30 10:05:42 rhea   14.231214]  [<ffffffff8056e851>] ? printk+0x40/0=
x47
Aug 30 10:05:42 rhea   14.246097]  [<ffffffff8072e090>] ? mount_block_r=
oot+0x1d6/0x271
Aug 30 10:05:42 rhea   14.264099]  [<ffffffff8072ecdb>] ? initrd_load+0=
x228/0x324
Aug 30 10:05:42 rhea   14.280790]  [<ffffffff8072e24f>] ? prepare_names=
pace+0xd5/0x18d
Aug 30 10:05:42 rhea   14.298777]  [<ffffffff8072d6cf>] ? kernel_init+0=
x178/0x188
Aug 30 10:05:42 rhea   14.315481]  [<ffffffff8020ceba>] ? child_rip+0xa=
/0x20
Aug 30 10:05:42 rhea   14.330885]  [<ffffffff8072d557>] ? kernel_init+0=
x0/0x188
Aug 30 10:05:42 rhea   14.347077]  [<ffffffff8020ceb0>] ? child_rip+0x0=
/0x20
Aug 30 10:05:42 rhea   14.362470] Rebooting in 60 seconds..


>
> Let's see what these messages produce both with and without the "slee=
p
> 10" in your initrd.

with sleep

Aug 30 11:11:52 rhea kernel: [    6.950127] console [netcon0] enabled  =
                                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   13.116253] netconsole: network logging=
 started                                                               =
              =20
Aug 30 11:11:52 rhea kernel: [   13.145344] SCSI subsystem initialized =
                                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   13.160103] megaraid cmm: 2.20.2.7 (Rel=
ease Date: Sun Jul 16 00:01:03 EST 2006)                               =
              =20
Aug 30 11:11:52 rhea kernel: [   13.187529] megaraid: 2.20.5.1 (Release=
 Date: Thu Nov 16 15:32:35 EST 2006)                                   =
              =20
Aug 30 11:11:52 rhea kernel: [   13.209685] megaraid: probe new device =
0x1000:0x0407:0x1000:0x0530: bus 2:slot 3:func 0                       =
              =20
Aug 30 11:11:52 rhea kernel: [   13.241872]   alloc irq_desc for 27 on =
cpu 0 node 0                                                           =
              =20
Aug 30 11:11:52 rhea kernel: [   13.241876]   alloc kstat_irqs on cpu 0=
 node 0                                                                =
              =20
Aug 30 11:11:52 rhea kernel: [   13.241885] megaraid 0000:02:03.0: PCI =
INT A -> GSI 27 (level, low) -> IRQ 27                                 =
              =20
Aug 30 11:11:52 rhea kernel: [   13.286708] megaraid: fw version:[414G]=
 bios version:[A100]                                                   =
              =20
Aug 30 11:11:52 rhea kernel: [   13.305284] scsi0 : LSI Logic MegaRAID =
driver                                                                 =
              =20
Aug 30 11:11:52 rhea kernel: [   13.322942] scsi[0]: scanning scsi chan=
nel 0 [Phy 0] for non-raid devices                                     =
              =20
Aug 30 11:11:52 rhea kernel: [   13.355882] Driver 'sd' needs updating =
- please use bus_type methods                                          =
              =20
Aug 30 11:11:52 rhea kernel: [   13.379162] wait_scan_init: BEFORE wait=
_for_device_probe                                                      =
              =20
Aug 30 11:11:52 rhea kernel: [   13.397928] wait_scan_init: AFTER wait_=
for_device_probe                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   13.417739] wait_scan_init: BEFORE scsi=
_complete_async_scans                                                  =
              =20
Aug 30 11:11:52 rhea kernel: [   13.438822] wait_scan_init: AFTER scsi_=
complete_async_scans                                                   =
              =20
Aug 30 11:11:52 rhea kernel: [   13.459688] wait_scan_init: BEFORE asyn=
c_synchronize_full                                                     =
              =20
Aug 30 11:11:52 rhea kernel: [   13.479998] wait_scan_init: AFTER wait_=
for_device_probe                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   13.902193] scsi 0:0:6:0: Processor    =
     ESG-SHV  SCA HSBP M29     1.08 PQ: 0 ANSI: 2                      =
              =20
Aug 30 11:11:52 rhea kernel: [   15.930664] scsi[0]: scanning scsi chan=
nel 1 [Phy 1] for non-raid devices                                     =
              =20
Aug 30 11:11:52 rhea kernel: [   19.706530] scsi[0]: scanning scsi chan=
nel 2 [virtual] for logical drives                                     =
              =20
Aug 30 11:11:52 rhea kernel: [   19.727104] scsi 0:2:0:0: Direct-Access=
     MegaRAID LD 0 RAID5  280G 414G PQ: 0 ANSI: 2                      =
              =20
Aug 30 11:11:52 rhea kernel: [   19.757564] sd_probe: BEFORE async_sche=
dule                                                                   =
              =20
Aug 30 11:11:52 rhea kernel: [   19.770091] sd_probe: AFTER async_sched=
ule                                                                    =
              =20
Aug 30 11:11:52 rhea kernel: [   19.782507] sd_probe_async: ENTERED    =
                                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   19.793223] sd 0:2:0:0: [sda] 574218240=
 512-byte hardware sectors: (293 GB/273 GiB)                           =
              =20
Aug 30 11:11:52 rhea kernel: [   19.816173] sd 0:2:0:0: [sda] Write Pro=
tect is off                                                            =
              =20
Aug 30 11:11:52 rhea kernel: [   19.830525] sd 0:2:0:0: [sda] Mode Sens=
e: 00 00 00 00                                                         =
              =20
Aug 30 11:11:52 rhea kernel: [   19.830549] sd 0:2:0:0: [sda] Asking fo=
r cache data failed                                                    =
              =20
Aug 30 11:11:52 rhea kernel: [   19.846978] sd 0:2:0:0: [sda] Assuming =
drive cache: write through                                             =
              =20
Aug 30 11:11:52 rhea kernel: [   19.865496] sd 0:2:0:0: [sda] Asking fo=
r cache data failed                                                    =
              =20
Aug 30 11:11:52 rhea kernel: [   19.881920] sd 0:2:0:0: [sda] Assuming =
drive cache: write through                                             =
              =20
Aug 30 11:11:52 rhea kernel: [   19.900198]  sda: sda1 sda2 sda3       =
                                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   19.924019] sd 0:2:0:0: [sda] Attached =
SCSI disk                                                              =
              =20
Aug 30 11:11:52 rhea kernel: [   23.113336] eth0: no IPv6 routers prese=
nt                                                                     =
              =20
Aug 30 11:11:52 rhea kernel: [   23.754010] SGI XFS with ACLs, security=
 attributes, large block/inode numbers, no debug enabled               =
              =20
Aug 30 11:11:52 rhea kernel: [   23.786463] SGI XFS Quota Management su=
bsystem                                                                =
              =20
Aug 30 11:11:52 rhea kernel: [   23.915852] XFS mounting filesystem sda=
2                                                                      =
              =20
Aug 30 11:11:52 rhea kernel: [   24.050956] Ending clean XFS mount for =
filesystem: sda2                                                       =
              =20
Aug 30 11:11:52 rhea kernel: [   24.051050] VFS: Mounted root (xfs file=
system) readonly on device 8:2. =20

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
