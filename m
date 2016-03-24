From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Wed, 23 Mar 2016 22:35:05 -0400 (EDT)
Message-ID: <502004640.24939720.1458786905087.JavaMail.zimbra@redhat.com>
References: <1458200385-32088-1-git-send-email-hare@suse.de> <56EC797A.8000104@sandisk.com> <56ED6DB1.1050202@suse.de> <56EF4D4A.6050000@sandisk.com> <56EF9F7E.2010300@suse.de> <1709049972.24310562.1458592857261.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:59706 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbcCXCfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 22:35:16 -0400
In-Reply-To: <1709049972.24310562.1458592857261.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Hello

Tested Hannes's scan disable patch (subject above) with hpsa module pat=
ch below.
Because of the way the hpsa works I created a module that will force th=
e scan when all scans are manual.
I also tested Hannes's patch with boot-from-san via F/C and validated t=
he patch in subject using Hannes's original dracut lunmask patch.

=46or Hannes's scan disable patch=20
Tested-by: Laurence Oberman <loberman@redhat.com>

linux16 /vmlinuz-4.4.5scan root=3D/dev/mapper/rhel-root ro crashkernel=3D=
512M@64M rd.lvm.lv=3Drhel/root rd.lvm.lv=3Drhel/swap console=3DttyS0,11=
5200n8 scsi_mod.scan=3Dmanual rd.hpsa=3D0 rdloaddriver=3Dhpsa

Additional HPSA module for dracut, needs to be cleaned up and reviewed =
internally here at Red Hat for a separate submission later.
Included for others who want to test this.
We need this for hpsa as this is by far the most popular boot controlle=
r we face.

diff -Nurp modules.d.orig/06hpsa/hpsa.sh modules.d/06hpsa/hpsa.sh
--- modules.d.orig/06hpsa/hpsa.sh	1969-12-31 19:00:00.000000000 -0500
+++ modules.d/06hpsa/hpsa.sh	2016-03-23 21:38:33.157233465 -0400
@@ -0,0 +1,6 @@
+#!/bin/sh
+### hpsa.sh: Called by the parse-hpsa.sh script to create the scan scr=
ipt ###
+### Laurence Oberman loberman@redhat.com
+. /lib/dracut-lib.sh
+### The actual script that scans the hpsa for LUNS=20
+/bin/sh /sbin/hpsa_scan.sh
diff -Nurp modules.d.orig/06hpsa/module-setup.sh modules.d/06hpsa/modul=
e-setup.sh
--- modules.d.orig/06hpsa/module-setup.sh	1969-12-31 19:00:00.000000000=
 -0500
+++ modules.d/06hpsa/module-setup.sh	2016-03-23 21:40:36.994767642 -040=
0
@@ -0,0 +1,14 @@
+#!/bin/sh
+#### Test the hpsa driver load with scan #####
+#### Laurence Oberman loberman@redhat.com=20
+### module-setup.sh - Required for every module
+### Standard script invocations required
+check() {
+	return 0
+}
+
+### Install the hpsa.sh in the module directory
+install() {
+	inst_hook cmdline 20 "$moddir/parse-hpsa.sh"
+	inst_simple "$moddir/hpsa.sh" /sbin/hpsa.sh
+}
diff -Nurp modules.d.orig/06hpsa/parse-hpsa.sh modules.d/06hpsa/parse-h=
psa.sh
--- modules.d.orig/06hpsa/parse-hpsa.sh	1969-12-31 19:00:00.000000000 -=
0500
+++ modules.d/06hpsa/parse-hpsa.sh	2016-03-23 21:42:28.141856121 -0400
@@ -0,0 +1,18 @@
+#!/bin.bash
+### Laurence Oberman loberman@redhat.com
+### parse-hpsa.sh=20
+### Parses the rd.hpsa=3Dx tp get the host number
+### Using rdloaddriver=3Dhpsa will enforce hpsa becoming scsi0
+
+for p in $(getargs rd.hpsa=3D); do
+(
+     echo "echo 1 > /sys/class/scsi_host/host$p/rescan" > /sbin/hpsa_s=
can.sh
+    _do_hpsa=3D1
+)
+done
+
+### Standard way to call the script from udev
+/sbin/initqueue --settled --unique --onetime /bin/sh /sbin/hpsa.sh
+#/bin/sh /sbin/hpsa.sh
+unset _do_hpsa
+


Test log
--------

[    5.591817] HP HPSA Driver (v 3.4.14-0)
[    5.593799] hpsa 0000:05:00.0: can't disable ASPM; OS doesn't have A=
SPM control
[    5.597423] hpsa 0000:05:00.0: MSI-X capable controller
[    5.600181] hpsa 0000:05:00.0: only 16 MSI-X vectors available
[    5.602995] hpsa 0000:05:00.0: Logical aborts not supported
[    5.606011] hpsa 0000:05:00.0: HP SSD Smart Path aborts not supporte=
d
[    5.631300] scsi host0: hpsa

[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[    5.676569] clocksource: Switched to clocksource tsc
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
         Starting Show Plymouth Boot Screen...
[  OK  ] Reached target System Initialization.
[    5.708890] bnx2: QLogic bnx2 Gigabit Ethernet Driver v2.2.6 (Januar=
y 29, 2014)
[  OK  ] Started Show Plymouth Boot Screen.
[    5.749275] bnx2 0000:03:00.0 eth0: Broadcom NetXtreme II BCM5709 10=
00Base-T (C0) PCI Express found at mem f4000000, IRQ 16, node addr e4:1=
1:5b:b8:ea:6a
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
[    5.828145] bnx2 0000:03:00.1 eth1: Broadcom NetXtreme II BCM5709 10=
00Base-T (C0) PCI Express found at mem f2000000, IRQ 17, node addr e4:1=
1:5b:b8:ea:6c
[    5.905874] bnx2 0000:04:00.0 eth2: Broadcom NetXtreme II BCM5709 10=
00Base-T (C0) PCI Express found at mem f8000000, IRQ 18, node addr e4:1=
1:5b:b8:ea:6e
[    5.906632] bnx2 0000:04:00.1 eth3: Broadcom NetXtreme II BCM5709 10=
00Base-T (C0) PCI Express found at mem f6000000, IRQ 19, node addr e4:1=
1:5b:b8:ea:70
[    6.061847] bnx2 0000:04:00.1 enp4s0f1: renamed from eth3
[    6.098914] mlx5_core 0000:08:00.0: firmware version: 12.14.2036
[    6.147046] Emulex LightPulse Fibre Channel SCSI driver 11.0.0.0.
[    6.147054] [drm] Initialized drm 1.1.0 20060810
[    6.147148] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA =
Driver: 8.07.00.26-k.
[    6.147278] qla2xxx [0000:0e:00.0]-001d: : Found an ISP2432 irq 27 i=
obase 0xffffc900192b8000.
[    6.147618] qla2xxx [0000:0e:00.0]-0034:1: MSI-X: Unsupported ISP 24=
32 SSVID/SSDID (0x103C,0x7041).
[    6.352283] Copyright(c) 2004-2015 Emulex.  All rights reserved.
[    6.387626] scsi host2: Emulex LPe1150 PCIe Fibre Channel Adapter on=
 PCI bus 0b device 00 irq 44
[    6.439004] bnx2 0000:04:00.0 enp4s0f0: renamed from eth2
[    6.470541] scsi host1: qla2xxx
[    6.488476] qla2xxx [0000:0e:00.0]-00fb:1: QLogic HPAE312A - PCI-Exp=
ress Dual Port 4Gb Fibre Channel HBA.
[    6.540692] qla2xxx [0000:0e:00.0]-00fc:1: ISP2432: PCIe (2.5GT/s x4=
) @ 0000:0e:00.0 hdma+ host#=3D1 fw=3D7.03.00 (9496).
[    6.600102] qla2xxx [0000:0e:00.1]-001d: : Found an ISP2432 irq 45 i=
obase 0xffffc9001929c000.
[    6.648749] qla2xxx [0000:0e:00.1]-0034:3: MSI-X: Unsupported ISP 24=
32 SSVID/SSDID (0x103C,0x7041).
[    6.666651] mlx5_core 0000:08:00.1: firmware version: 12.14.2036
[    6.772560] bnx2 0000:03:00.0 enp3s0f0: renamed from eth0
[    7.056571] scsi host3: qla2xxx
[    7.074626] qla2xxx [0000:0e:00.1]-00fb:3: QLogic HPAE312A - PCI-Exp=
ress Dual Port 4Gb Fibre Channel HBA.
[    7.112413] qla2xxx [0000:0e:00.0]-500a:1: LOOP UP detected (4 Gbps)=
=2E
[    7.164549] qla2xxx [0000:0e:00.1]-00fc:3: ISP2432: PCIe (2.5GT/s x4=
) @ 0000:0e:00.1 hdma+ host#=3D3 fw=3D7.03.00 (9496).
[    7.225561] bnx2 0000:03:00.1 enp3s0f1: renamed from eth1
[    7.263344] [drm] radeon kernel modesetting enabled.
[    7.292316] [drm] initializing kernel modesetting (RV100 0x1002:0x51=
5E 0x103C:0x31FB).
[    7.337153] [drm] register mmio base: 0xF1CF0000
[    7.363142] [drm] register mmio size: 65536
[    7.387189] radeon 0000:01:03.0: VRAM: 128M 0x00000000E0000000 - 0x0=
0000000E7FFFFFF (64M used)
[    7.434215] radeon 0000:01:03.0: GTT: 512M 0x00000000C0000000 - 0x00=
000000DFFFFFFF
[    7.477250] [drm] Detected VRAM RAM=3D128M, BAR=3D128M
[    7.503412] [drm] RAM width 16bits DDR
[    7.524062] [TTM] Zone  kernel: Available graphics memory: 74007530 =
kiB
[    7.559905] [TTM] Zone   dma32: Available graphics memory: 2097152 k=
iB
[    7.595353] [TTM] Initializing pool allocator
[    7.619344] [TTM] Initializing DMA pool allocator
[    7.645975] [drm] radeon: 64M of VRAM memory ready
[    7.672908] [drm] radeon: 512M of GTT memory ready.
[    7.673258] mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (F=
eb 2014)
[    7.699187] qla2xxx [0000:0e:00.1]-500a:3: LOOP UP detected (4 Gbps)=
=2E
[    7.776438] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    7.832626] [drm] PCI GART of 512M enabled (table at 0x0000000031200=
000).
[    7.870378] radeon 0000:01:03.0: WB disabled
[    7.893537] radeon 0000:01:03.0: fence driver on ring 0 use gpu addr=
 0x00000000c0000000 and cpu addr 0xffff880031070000
[    7.953875] [drm] Supports vblank timestamp caching Rev 2 (21.10.201=
3).
[    7.990946] [drm] Driver supports precise vblank timestamp query.
[    7.997365] random: nonblocking pool is initialized
[    8.055710] [drm] radeon: irq initialized.
[    8.078772] [drm] Loading R100 Microcode
[    8.101197] [drm] radeon: ring at 0x00000000C0001000
[    8.129891] [drm] ring test succeeded in 1 usecs
[    8.655299] [drm] ib test succeeded in 0 usecs
[    8.678602] [drm] No TV DAC info found in BIOS
[    8.702772] [drm] Radeon Display Connectors
[    8.726801] [drm] Connector 0:
[    8.744275] [drm]   VGA-1
[    8.759047] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    8.793773] [drm]   Encoders:
[    8.811874] [drm]     CRT1: INTERNAL_DAC1
[    8.834626] [drm] Connector 1:
[    8.851683] [drm]   VGA-2
[    8.866289] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[    8.899111] [drm]   Encoders:
[    8.914856] [drm]     CRT2: INTERNAL_DAC2
[    8.973015] [drm] fb mappable at 0xE0040000
[    8.996545] [drm] vram apper at 0xE0000000
[    9.019109] [drm] size 786432
[    9.035977] [drm] fb depth is 8
[    9.053620] [drm]    pitch is 1024
[    9.072966] fbcon: radeondrmfb (fb0) is primary device
[    9.228858] Console: switching to colour frame buffer device 128x48
[    9.300257] radeon 0000:01:03.0: fb0: radeondrmfb frame buffer devic=
e
[    9.349479] [drm] Initialized radeon 2.43.0 20080528 for 0000:01:03.=
0 on minor 0
[   10.032430] hpsa 0000:05:00.0: scsi 0:3:0:0: added RAID             =
 HP       P410i            controller SSDSmartPathCap- En- Exp=3D1
[   10.098586] hpsa 0000:05:00.0: scsi 0:0:0:0: masked Direct-Access   =
  HP       DG146BB976       PHYS DRV SSDSmartPathCap- En- Exp=3D0
[   10.166547] hpsa 0000:05:00.0: scsi 0:1:0:0: added Direct-Access    =
 HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap- En- Exp=3D1
[   10.233884] scsi 0:1:0:0: Direct-Access     HP       LOGICAL VOLUME =
  6.40 PQ: 0 ANSI: 5
[   10.294476] sd 0:1:0:0: [sda] 286677120 512-byte logical blocks: (14=
7 GB/137 GiB)
[   10.337955] sd 0:1:0:0: [sda] Write Protect is off
[   10.365772] sd 0:1:0:0: [sda] Write cache: disabled, read cache: ena=
bled, doesn't support DPO or FUA
[   10.387947] lpfc 0000:0b:00.0: 0:1303 Link Up Event x1 received Data=
: x1 xf7 x10 x0 x0 x0 0
[   10.464599]  sda: sda1 sda2
[   10.481480] sd 0:1:0:0: [sda] Attached SCSI disk
[  OK  ] Found device /dev/mapper/rhel-root.
         Starting File System Check on /dev/mapper/rhel-root...
[  OK  ] Started File System Check on /dev/mapper/rhel-root.
=2E.
,,

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Laurence Oberman" <loberman@redhat.com>
To: "Hannes Reinecke" <hare@suse.de>
Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Martin K. Petersen=
" <martin.petersen@oracle.com>, "Christoph Hellwig" <hch@lst.de>, "Jame=
s Bottomley" <james.bottomley@hansenpartnership.com>, linux-scsi@vger.k=
ernel.org
Sent: Monday, March 21, 2016 4:40:57 PM
Subject: Re: [PATCHv3] scsi: disable automatic target scan

Hello Hannes

Please share latest scripts and an example of how you are using them.
I have some scripts from last November, that you posted but I am sure t=
hey have changed.
If not then I will modify them as appropriate, just let me know.

I have added the patches and booted the system set to async, so before =
I boot with scsi_mod.scan=3Dmanual want to prepare my test system.
This feature may be a very useful feature we would want to include in R=
HEL as we struggle with large LUN boot configurations all the time.
When you have time and thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Hannes Reinecke" <hare@suse.de>
To: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Martin K. Petersen=
" <martin.petersen@oracle.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "James Bottomley" <james.bottomle=
y@hansenpartnership.com>, linux-scsi@vger.kernel.org
Sent: Monday, March 21, 2016 3:15:10 AM
Subject: Re: [PATCHv3] scsi: disable automatic target scan

On 03/21/2016 02:24 AM, Bart Van Assche wrote:
> On 03/19/16 08:18, Hannes Reinecke wrote:
>> On 03/18/2016 10:56 PM, Bart Van Assche wrote:
>>> On 03/17/2016 12:39 AM, Hannes Reinecke wrote:
>>>> On larger installations it is useful to disable automatic LUN
>>>> scanning, and only add the required LUNs via udev rules.
>>>> This can speed up bootup dramatically.
>>>>
>>>> This patch introduces a new scan module parameter value 'manual',
>>>> which works like 'none', but can be overriden by setting the
>>>> 'rescan'
>>>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>>>> And it updates all relevant callers to set the 'rescan' value
>>>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>>
>>> Hello Hannes,
>>>
>>> Will setting scsi_scan_type to 'manual' allow a system to boot
>>> from a
>>> SCSI disk? If not, are there alternatives to this approach? Would
>>> it be
>>> a valid alternative to e.g. introduce a new threshold parameter suc=
h
>>> that only LUN numbers below this threshold are scanned during boot?
>>>
>> I have a patch for dracut, which will generate udev rules for all
>> devices required for mounting the root fs.
>> Once the system is booted properly I've got another patch for system=
d
>> which switches back to 'normal' scanning (ie by writing 'sync' into
>> /sys/modules/scsi_mod/parameters/scan) and rescan all scsi hosts.
>>
>> With that there's no need to have any arbitrary limits; only the
>> necessary devices are enabled during boot.
>=20
> Hello Hannes,
>=20
> That sounds like a really interesting approach. Will this approach
> also work if the SCSI host and/or LUN numbers change during a reboot?
>=20
It's independent on the SCSI host as it just looks for the rport ID
(FC WWPN, SAS ID, or iSCSI target name). The LUN number, however, is
fixed; the whole point of this exercise is that you want to blank
out individual LUNs behind a given target.
Hence you need to able to address the LUNs in the first place.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
