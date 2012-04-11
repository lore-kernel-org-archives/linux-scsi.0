From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.38->3.0+
Date: Wed, 11 Apr 2012 13:40:03 +0400
Message-ID: <4F855173.40902@msgid.tls.msk.ru>
References: <4F75E46E.2000503@msgid.tls.msk.ru> <20120405232913.GA6640@quack.suse.cz> <4F7E74F4.90604@msgid.tls.msk.ru> <20120410022628.GN18323@dastard> <4F83CC86.2010805@msgid.tls.msk.ru> <20120410151326.GA4936@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:33116 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab2DKJkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 05:40:07 -0400
In-Reply-To: <20120410151326.GA4936@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 10.04.2012 19:13, Jan Kara wrote:
> On Tue 10-04-12 10:00:38, Michael Tokarev wrote:
[]
>>   2.6.38:
>>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
>>   100+0 records in
>>   100+0 records out
>>   104857600 bytes (105 MB) copied, 1.73126 s, 60.6 MB/s
>>
>>   3.0:
>>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
>>   100+0 records in
>>   100+0 records out
>>   104857600 bytes (105 MB) copied, 29.4508 s, 3.6 MB/s
>>
>> That's about 20 times difference on direct read from the
>> same - idle - device!!

>   Huh, that's a huge difference for such a trivial load. So we can rule out
> filesystems, writeback, mm. I also wouldn't think it's IO scheduler but
> you can always check by comparing dd numbers after
>   echo none >/sys/block/sdb/queue/scheduler

The scheduler makes very little difference.

> Anyway, the most likely cause seems to be some driver issue (which would
> also explain why you can see it only on one machine). I'd also compare very

Yes, it appears to be mptspi driver (CCing linux-scsi@).

Another problem we've hit while trying various kernels/options
(and which makes whole experiment very dangerous for us) -- after
loading 3.0+ kernel, the machine does not always boot back to
older kernel, often freezing while mptspi is initializing or
starting doing something, so that only hard reset helps.  And
since this is a remote production server, the fact that it can
freeze any time we do some experiments makes the whole issue
quite difficult.  It appears that 3.0+ driver does something
with the controller which makes at least 2.6.32 kernel/driver
misbehave, at least sometimes.

> closely config files of the two kernels if there isn't some unexpected
> difference...

There's one difference between my 2.6.38 and 3.0 configs --
in 3.0+ I enabled CONFIG_SCSI_SCAN_ASYNC.  But due to the
above I'm not sure I want to experiment right now again,
as I need some remote hands to bring the machine back if
it'll stuck again.

And there's at least two quite significant (I think)
differences in dmesg output.

3.0 kernel:
[    2.807983] Fusion MPT base driver 3.04.19
[    2.808064] Copyright (c) 1999-2008 LSI Corporation
[    2.809826] Fusion MPT SPI Host driver 3.04.19
[    2.810003] mptspi 0000:08:07.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
[    2.810347] mptbase: ioc0: Initiating bringup
[    3.223351] ioc0: LSI53C1030 B2: Capabilities={Initiator}
[    4.113981] scsi4 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=27
[    4.482468] mptspi 0000:08:07.1: PCI INT B -> GSI 28 (level, low) -> IRQ 28
[    4.482674] mptbase: ioc1: Initiating bringup

the extra warning and 15-sec delay:
[   19.480030] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, doorbell=0x24000000
[   20.120020] mptbase: ioc0: Attempting Retry Config request type 0x4, page 0x1, action 2
[   20.120173] mptbase: ioc0: Retry completed ret=0x0 timeleft=4500

[   20.121075] scsi 4:0:0:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S25J PQ: 0 ANSI: 3
[   20.121186] scsi target4:0:0: Beginning Domain Validation
[   20.131738] scsi target4:0:0: Ending Domain Validation
[   20.131865] scsi target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[   20.133037] scsi 4:0:1:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
[   20.133136] scsi target4:0:1: Beginning Domain Validation
[   20.145040] scsi target4:0:1: Ending Domain Validation
[   20.145169] scsi target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[   20.146368] scsi 4:0:2:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
[   20.146470] scsi target4:0:2: Beginning Domain Validation
[   20.156885] scsi target4:0:2: Ending Domain Validation
[   20.157013] scsi target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[   20.158196] scsi 4:0:3:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
[   20.158297] scsi target4:0:3: Beginning Domain Validation
[   20.168737] scsi target4:0:3: Ending Domain Validation
[   20.168868] scsi target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[   20.172797] scsi 4:0:4:0: Direct-Access     IBM-ESXS MAW3073NC     FN C206 PQ: 0 ANSI: 4
[   20.172898] scsi target4:0:4: Beginning Domain Validation
[   20.192801] scsi target4:0:4: Ending Domain Validation
[   20.192934] scsi target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU HMCS (6.25 ns, offset 127)
[   20.753704] scsi 4:0:8:0: Processor         IBM      32P0032a S320  1 1    PQ: 0 ANSI: 2
[   20.753810] scsi target4:0:8: Beginning Domain Validation
[   20.754545] scsi target4:0:8: Ending Domain Validation
[   20.754671] scsi target4:0:8: asynchronous
[   23.572044] sd 4:0:0:0: [sdb] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   23.573106] sd 4:0:0:0: [sdb] Write Protect is off
[   23.573204] sd 4:0:0:0: [sdb] Mode Sense: cb 00 00 08
[   23.574437] sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   23.577515] sd 4:0:1:0: [sdc] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   23.578569] sd 4:0:1:0: [sdc] Write Protect is off
[   23.578676] sd 4:0:1:0: [sdc] Mode Sense: cb 00 00 08
[   23.579773] sd 4:0:1:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   23.582656] sd 4:0:2:0: [sdd] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   23.583718] sd 4:0:2:0: [sdd] Write Protect is off
[   23.583813] sd 4:0:2:0: [sdd] Mode Sense: cb 00 00 08
[   23.585126] sd 4:0:2:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   23.589278] sd 4:0:3:0: [sde] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   23.590356] sd 4:0:3:0: [sde] Write Protect is off
[   23.590456] sd 4:0:3:0: [sde] Mode Sense: cb 00 00 08
[   23.591613] sd 4:0:3:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   23.595105] sd 4:0:4:0: [sdf] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   23.597872] sd 4:0:4:0: [sdf] Write Protect is off
[   23.597980] sd 4:0:4:0: [sdf] Mode Sense: cf 00 00 08
[   23.599393] sd 4:0:4:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   23.605403]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
[   23.608453]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 >
[   23.619822]  sde: sde1 sde2 sde3 sde4 < sde5 sde6 sde7 >
[   23.620675]  sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 sdd7 >
[   23.622831] sd 4:0:0:0: [sdb] Attached SCSI disk
[   23.624151]  sdf: sdf1 sdf2 sdf3 sdf4 < sdf5 sdf6 sdf7 >
[   23.705272] sd 4:0:1:0: [sdc] Attached SCSI disk
[   23.740272] sd 4:0:2:0: [sdd] Attached SCSI disk
[   23.743111] sd 4:0:4:0: [sdf] Attached SCSI disk
[   23.743997] sd 4:0:3:0: [sde] Attached SCSI disk
[   34.480015] mptbase: ioc1: ERROR - Wait IOC_READY state (0x20000000) timeout(15)!
[   38.870012] ioc1: LSI53C1030 B2: Capabilities={Initiator}
[   39.270011] ioc0: LSI53C1030 B2: Capabilities={Initiator}
[   40.553990] scsi5 : ioc1: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=28

And 2.6.32 (without dmesg timestamps compiled in):

Fusion MPT base driver 3.04.12
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.12
mptspi 0000:08:07.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B2: Capabilities={Initiator}
scsi4 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=27
scsi 4:0:0:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S25J PQ: 0 ANSI: 3
scsi target4:0:0: Beginning Domain Validation
scsi target4:0:0: Ending Domain Validation
scsi target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
sd 4:0:0:0: [sda] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
scsi 4:0:1:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
sd 4:0:0:0: [sda] Write Protect is off
scsi target4:0:1: Beginning Domain Validation
sd 4:0:0:0: [sda] Mode Sense: cb 00 00 08
sd 4:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda:
scsi target4:0:1: Ending Domain Validation
scsi target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
 sda1 sda2 sda3 sda4 <
sd 4:0:1:0: [sdb] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
scsi 4:0:2:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
scsi target4:0:2: Beginning Domain Validation
sd 4:0:1:0: [sdb] Write Protect is off
sd 4:0:1:0: [sdb] Mode Sense: cb 00 00 08
sd 4:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda5
 sdb: sda6
scsi target4:0:2: Ending Domain Validation
scsi target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
 sda7 >
sd 4:0:2:0: [sdc] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
scsi 4:0:3:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
scsi target4:0:3: Beginning Domain Validation
sd 4:0:2:0: [sdc] Write Protect is off
sd 4:0:2:0: [sdc] Mode Sense: cb 00 00 08
 sdb1 sdb2 sdb3 sdb4 <
sd 4:0:2:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb5
 sdc: sdb6
scsi target4:0:3: Ending Domain Validation
sd 4:0:0:0: [sda] Attached SCSI disk
scsi target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
 sdb7 >
 sdc1 sdc2 sdc3 sdc4 < sdc5
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 215, comm: blkid Not tainted 2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e5b0a>] ? touch_atime+0xea/0x130
 [<c10a23ee>] ? generic_file_aio_read+0x41e/0x6f0
 [<c10d3370>] ? do_sync_read+0x0/0x110
 [<c10d3446>] ? do_sync_read+0xd6/0x110
 [<c1057a30>] ? autoremove_wake_function+0x0/0x40
 [<c1024ca8>] ? kunmap_atomic+0x58/0x70
 [<c10ba9b5>] ? handle_mm_fault+0x2e5/0x9c0
 [<c10f9c94>] ? block_llseek+0xb4/0xe0
 [<c10d3c5f>] ? vfs_read+0x8f/0x190
 [<c10d31b8>] ? vfs_llseek+0x38/0x50
 [<c10d3d9c>] ? sys_read+0x3c/0x70
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818c5 ]---
bdi-block not registered
 sdc6
sd 4:0:3:0: [sdd] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
sd 4:0:3:0: [sdd] Write Protect is off
sd 4:0:3:0: [sdd] Mode Sense: cb 00 00 08
 sdc7 >
sd 4:0:3:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 215, comm: blkid Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e5b0a>] ? touch_atime+0xea/0x130
 [<c10a23ee>] ? generic_file_aio_read+0x41e/0x6f0
 [<c10d3370>] ? do_sync_read+0x0/0x110
 [<c10d3446>] ? do_sync_read+0xd6/0x110
 [<c1057a30>] ? autoremove_wake_function+0x0/0x40
 [<c10e0ffc>] ? do_vfs_ioctl+0x6c/0x550
 [<c10f9c94>] ? block_llseek+0xb4/0xe0
 [<c10d3c5f>] ? vfs_read+0x8f/0x190
 [<c10d31b8>] ? vfs_llseek+0x38/0x50
 [<c10d3d9c>] ? sys_read+0x3c/0x70
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818c6 ]---
bdi-block not registered
 sdd: sdd1
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 261, comm: mdev Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e753b>] ? inode_setattr+0xab/0x170
 [<c10e73a8>] ? inode_change_ok+0xa8/0x190
 [<c10e77c0>] ? notify_change+0x1c0/0x330
 [<c10d2c09>] ? sys_fchmodat+0xb9/0xe0
 [<c10d2c50>] ? sys_chmod+0x20/0x30
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818c7 ]---
bdi-block not registered
 sdd2 sdd3 sdd4 <
scsi 4:0:4:0: Direct-Access     IBM-ESXS MAW3073NC     FN C206 PQ: 0 ANSI: 4
scsi target4:0:4: Beginning Domain Validation
 sdd5 sdd6
sd 4:0:1:0: [sdb] Attached SCSI disk
 sdd7 >
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in:
scsi target4:0:4: Ending Domain Validation
scsi target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU HMCS (6.25 ns, offset 127)
 mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 283, comm: blkid Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e5b0a>] ? touch_atime+0xea/0x130
 [<c10a23ee>] ? generic_file_aio_read+0x41e/0x6f0
 [<c10d3370>] ? do_sync_read+0x0/0x110
 [<c10d3446>] ? do_sync_read+0xd6/0x110
 [<c1057a30>] ? autoremove_wake_function+0x0/0x40
 [<c1024ca8>] ? kunmap_atomic+0x58/0x70
 [<c10ba9b5>] ? handle_mm_fault+0x2e5/0x9c0
 [<c10f9c94>] ? block_llseek+0xb4/0xe0
 [<c10d3c5f>] ? vfs_read+0x8f/0x190
 [<c10d31b8>] ? vfs_llseek+0x38/0x50
 [<c10d3d9c>] ? sys_read+0x3c/0x70
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818c8 ]---
bdi-block not registered
sd 4:0:2:0: [sdc] Attached SCSI disk
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 283, comm: blkid Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e5b0a>] ? touch_atime+0xea/0x130
 [<c10a23ee>] ? generic_file_aio_read+0x41e/0x6f0
 [<c10d3370>] ? do_sync_read+0x0/0x110
 [<c10d3446>] ? do_sync_read+0xd6/0x110
 [<c1057a30>] ? autoremove_wake_function+0x0/0x40
 [<c10e0ffc>] ? do_vfs_ioctl+0x6c/0x550
 [<c10f9c94>] ? block_llseek+0xb4/0xe0
 [<c10d3c5f>] ? vfs_read+0x8f/0x190
 [<c10d31b8>] ? vfs_llseek+0x38/0x50
 [<c10d3d9c>] ? sys_read+0x3c/0x70
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818c9 ]---
bdi-block not registered
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 283, comm: blkid Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e5b0a>] ? touch_atime+0xea/0x130
 [<c10a23ee>] ? generic_file_aio_read+0x41e/0x6f0
 [<c10d3370>] ? do_sync_read+0x0/0x110
 [<c10d3446>] ? do_sync_read+0xd6/0x110
 [<c1057a30>] ? autoremove_wake_function+0x0/0x40
 [<c10e0ffc>] ? do_vfs_ioctl+0x6c/0x550
 [<c10f9c94>] ? block_llseek+0xb4/0xe0
 [<c10d3c5f>] ? vfs_read+0x8f/0x190
 [<c10d31b8>] ? vfs_llseek+0x38/0x50
 [<c10d3d9c>] ? sys_read+0x3c/0x70
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818ca ]---
bdi-block not registered
sd 4:0:4:0: [sde] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
sd 4:0:4:0: [sde] Write Protect is off
sd 4:0:4:0: [sde] Mode Sense: cf 00 00 08
sd 4:0:4:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 329, comm: mdev Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e753b>] ? inode_setattr+0xab/0x170
 [<c10e73a8>] ? inode_change_ok+0xa8/0x190
 [<c10e77c0>] ? notify_change+0x1c0/0x330
 [<c10d2c09>] ? sys_fchmodat+0xb9/0xe0
 [<c10d2c50>] ? sys_chmod+0x20/0x30
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818cb ]---
bdi-block not registered
 sde: sde1 sde2 sde3 sde4 < sde5 sde6
scsi 4:0:8:0: Processor         IBM      32P0032a S320  1 1    PQ: 0 ANSI: 2
scsi target4:0:8: Beginning Domain Validation
scsi target4:0:8: Ending Domain Validation
scsi target4:0:8: asynchronous
 sde7 >
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:1122 __mark_inode_dirty+0xd4/0x130()
Hardware name: eserver xSeries 345 -[867052G]-
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi usb_storage e1000 ohci_hcd pata_serverworks libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 369, comm: mdev Tainted: G        W  2.6.32-i686 #2.6.32.50
Call Trace:
 [<c103e83e>] ? warn_slowpath_common+0x6e/0xb0
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c103e893>] ? warn_slowpath_null+0x13/0x20
 [<c10ef314>] ? __mark_inode_dirty+0xd4/0x130
 [<c10e753b>] ? inode_setattr+0xab/0x170
 [<c10e73a8>] ? inode_change_ok+0xa8/0x190
 [<c10e77c0>] ? notify_change+0x1c0/0x330
 [<c10d2c09>] ? sys_fchmodat+0xb9/0xe0
 [<c10d2c50>] ? sys_chmod+0x20/0x30
 [<c1002d38>] ? sysenter_do_call+0x12/0x2c
---[ end trace 440816db81b818cc ]---
bdi-block not registered
sd 4:0:3:0: [sdd] Attached SCSI disk
mptspi 0000:08:07.1: PCI INT B -> GSI 28 (level, low) -> IRQ 28
mptbase: ioc1: Initiating bringup
ioc1: LSI53C1030 B2: Capabilities={Initiator}
sd 4:0:4:0: [sde] Attached SCSI disk

These warnings is what prompted me to try a more
recent kernel actually, plus the fact that 2.6.32
is reaching its end of line (so to say).  These
warnings aren't always shown, sometimes it boots
fine.

Here's a dmesg from 2.6.38 kernel, which shows no
issues whatsoever:

[    2.910215] Fusion MPT base driver 3.04.18
[    2.910299] Copyright (c) 1999-2008 LSI Corporation
[    2.922747] Fusion MPT SPI Host driver 3.04.18
[    2.922912] mptspi 0000:08:07.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
[    2.923145] mptbase: ioc0: Initiating bringup
[    3.340016] ioc0: LSI53C1030 B2: Capabilities={Initiator}
[    4.230644] scsi4 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=27
[    4.601148] scsi 4:0:0:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S25J PQ: 0 ANSI: 3
[    4.601257] scsi target4:0:0: Beginning Domain Validation
[    4.612026] scsi target4:0:0: Ending Domain Validation
[    4.612155] scsi target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[    4.614638] sd 4:0:0:0: [sdb] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[    4.616258] sd 4:0:0:0: [sdb] Write Protect is off
[    4.616341] sd 4:0:0:0: [sdb] Mode Sense: cb 00 00 08
[    4.616524] scsi 4:0:1:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
[    4.616653] scsi target4:0:1: Beginning Domain Validation
[    4.618073] sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.627985] scsi target4:0:1: Ending Domain Validation
[    4.628122] scsi target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[    4.630165] sd 4:0:1:0: [sdc] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[    4.631535] sd 4:0:1:0: [sdc] Write Protect is off
[    4.631626] sd 4:0:1:0: [sdc] Mode Sense: cb 00 00 08
[    4.632327] scsi 4:0:2:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
[    4.632524] scsi target4:0:2: Beginning Domain Validation
[    4.633594] sd 4:0:1:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.644183] scsi target4:0:2: Ending Domain Validation
[    4.645739] scsi target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[    4.648020] sd 4:0:2:0: [sdd] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[    4.649041] sd 4:0:2:0: [sdd] Write Protect is off
[    4.649133] sd 4:0:2:0: [sdd] Mode Sense: cb 00 00 08
[    4.650478] scsi 4:0:3:0: Direct-Access     IBM-ESXS DTN073C3UCDY10FN S27M PQ: 0 ANSI: 3
[    4.650618]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
[    4.650650] scsi target4:0:3: Beginning Domain Validation
[    4.651796] sd 4:0:2:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.661785]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 >
[    4.663819] scsi target4:0:3: Ending Domain Validation
[    4.664108] scsi target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS HMCS (6.25 ns, offset 127)
[    4.665724] sd 4:0:0:0: [sdb] Attached SCSI disk
[    4.684535] sd 4:0:3:0: [sde] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[    4.685537] sd 4:0:3:0: [sde] Write Protect is off
[    4.685649] sd 4:0:3:0: [sde] Mode Sense: cb 00 00 08
[    4.686944] sd 4:0:3:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.687854]  sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 sdd7 >
[    4.702237] scsi 4:0:4:0: Direct-Access     IBM-ESXS MAW3073NC     FN C206 PQ: 0 ANSI: 4
[    4.702392] scsi target4:0:4: Beginning Domain Validation
[    4.716211] sd 4:0:1:0: [sdc] Attached SCSI disk
[    4.724526]  sde: sde1 sde2 sde3 sde4 < sde5 sde6 sde7 >
[    4.727350] scsi target4:0:4: Ending Domain Validation
[    4.727559] scsi target4:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU HMCS (6.25 ns, offset 127)
[    4.737932] sd 4:0:2:0: [sdd] Attached SCSI disk
[    4.746930] sd 4:0:4:0: [sdf] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
[    4.749646] sd 4:0:4:0: [sdf] Write Protect is off
[    4.749743] sd 4:0:4:0: [sdf] Mode Sense: cf 00 00 08
[    4.751182] sd 4:0:4:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.255072] scsi 4:0:8:0: Processor         IBM      32P0032a S320  1 1    PQ: 0 ANSI: 2
[    5.255205] scsi target4:0:8: Beginning Domain Validation
[    5.255937] scsi target4:0:8: Ending Domain Validation
[    5.256065] scsi target4:0:8: asynchronous
[    6.261554]  sdf: sdf1 sdf2 sdf3 sdf4 < sdf5 sdf6 sdf7 >
[    7.015879] mptspi 0000:08:07.1: PCI INT B -> GSI 28 (level, low) -> IRQ 28
[    7.016573] mptbase: ioc1: Initiating bringup
[    7.423346] ioc1: LSI53C1030 B2: Capabilities={Initiator}
[    8.340889] sd 4:0:3:0: [sde] Attached SCSI disk
[    8.344413] scsi5 : ioc1: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=28
[    8.351396] sd 4:0:4:0: [sdf] Attached SCSI disk

The warnings shown in 2.6.32 dmesg above aren't always
shown, sometimes (more often than not) it boots without
any warnings, like this 2.6.38 dmesg.

Here's the controller in question, from lspci:

08:07.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
	Subsystem: IBM Device 026c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 27
	Region 0: I/O ports at 2600 [size=256]
	Region 1: Memory at f9ff0000 (64-bit, non-prefetchable) [size=64K]
	Region 3: Memory at f9fe0000 (64-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at a0100000 [disabled] [size=1M]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [68] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=1
		Status: Dev=08:07.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Kernel driver in use: mptspi

08:07.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
	Subsystem: IBM Device 026c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 28
	Region 0: I/O ports at 2700 [size=256]
	Region 1: Memory at f9fd0000 (64-bit, non-prefetchable) [size=64K]
	Region 3: Memory at f9fc0000 (64-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at a0200000 [disabled] [size=1M]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [68] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=1
		Status: Dev=08:07.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Kernel driver in use: mptspi

(Only one port from the two is in use).

Are there any other guesses about all this?

Thank you!

/mjt
