From: Sudhakar <ssudhakarp@gmail.com>
Subject: race condition between scsi device add/remove code paths in 2.6.28
Date: Sat, 24 Jan 2009 05:38:27 +0530
Message-ID: <8b62ef2d0901231608y8df423ema178ae8700173ea1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:15278 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZAXAI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 19:08:28 -0500
Received: by rv-out-0506.google.com with SMTP id k40so4955538rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 16:08:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

In our labs, we encountered a kernel crash, while stressing scsi
device add/remove code path of 2.6.28 kernel. lsscsi output on my
machine looks like this:

*******Start******

[root@IMIT2S005 ~]# lsscsi
[0:0:0:0]    disk    ATA      ST3250620NS      3BKS  -
[0:0:1:0]    disk    ATA      ST3250620NS      3BKS  -
[0:0:2:0]    disk    ATA      ST3250620NS      3BKS  -
[0:0:3:0]    disk    ATA      ST3250620NS      3BKS  -
[0:1:0:0]    disk    Dell     VIRTUAL DISK     1028  /dev/sda
[1:0:0:0]    cd/dvd  Optiarc  DVD RW AD-7190S  1.00  /dev/scd0
[5:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb

*******End*********

I have written script which would recursively add/remove the lone lun
of scsi_debug device. My script looks like this:

********Start******

[root@IMIT2S005 temp]# cat s.sh
while [ true ]
do
        echo "scsi remove-single-device 5 0 0 0" > /proc/scsi/scsi
        echo "scsi add-single-device 5 0 0 0" > /proc/scsi/scsi
done
[root@IMIT2S005 temp]#

********End********

When the above script is run for approximately 10 seconds, we started
to see the following messages and finally NULL pointer dereference.

********Start*******

Jan 24 00:13:12 IMIT2S005 kernel: ------------[ cut here ]------------
Jan 24 00:13:12 IMIT2S005 kernel: WARNING: at fs/sysfs/dir.c:462
sysfs_add_one+0x33/0x39()
Jan 24 00:13:12 IMIT2S005 kernel: sysfs: duplicate filename '5:0:0:0'
can not be created
Jan 24 00:13:12 IMIT2S005 kernel: Modules linked in: scsi_debug ipv6
autofs4 hidp rfcomm

l2cap bluetooth sunrpc dm_round_robin dm_multipath rfkill
input_polldev sbs sbshc battery

acpi_memhotplug ac parport_pc lp parport floppy sg qla2xxx tg3
scsi_transport_fc libphy

rtc_cmos sr_mod button rtc_core i2c_i801 cdrom dcdbas i2c_core
serio_raw rtc_lib pcspkr

shpchp dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
ata_piix libata mptsas

mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd
ohci_hcd uhci_hcd

[last unloaded: microcode]
Jan 24 00:13:12 IMIT2S005 kernel: Pid: 3830, comm: sh Tainted: G
 W  2.6.28 #1
Jan 24 00:13:12 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80237a69>] warn_slowpath+0xb4/0xd2
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032c3f2>] vsnprintf+0x66e/0x6bd
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032bd25>] string+0x34/0x93
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032c0f2>] vsnprintf+0x36e/0x6bd
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032b556>] number+0x106/0x1f9
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327034>]
idr_get_empty_slot+0x171/0x24b
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327034>]
idr_get_empty_slot+0x171/0x24b
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327204>]
ida_get_new_above+0xf6/0x187
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802dd02c>]
sysfs_ilookup_test+0x0/0xf
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802dd228>]
sysfs_find_dirent+0x1b/0x2f
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802dd2de>] sysfs_add_one+0x33/0x39
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802dd7eb>] create_dir+0x4f/0x87
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802dd858>]
sysfs_create_dir+0x35/0x4b
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327d01>]
kobject_add_internal+0xc5/0x180
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803281cb>] kobject_add+0x74/0x7c
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80238692>] printk+0x4e/0x56
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327c37>] kobject_get+0x12/0x17
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803a26f7>] get_device+0x17/0x1f
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803a2d1f>] device_add+0xb5/0x5d5
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803a7034>]

attribute_container_device_trigger+0x9c/0xa7
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0083415>]
scsi_sysfs_add_sdev+0xa5/0x1f6

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0081595>]
scsi_probe_and_add_lun+0x9b3/0xaf5

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0080842>]
scsi_alloc_target+0x25c/0x29e

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80276173>]
zone_statistics+0x3a/0x5d
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa00818f0>]
__scsi_scan_target+0x8f/0x5c9

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8047d396>] klist_put+0x4c/0x76
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa007a01c>]
__scsi_host_match+0x0/0x10

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0081f87>]
scsi_scan_host_selected+0xed/0x10a

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0084a18>]
proc_scsi_write+0x158/0x257

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802d1bf1>] proc_reg_write+0x73/0x8e
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80295ad6>] vfs_write+0xad/0x136
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80295f5e>] sys_write+0x45/0x6e
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8020bc8b>]
system_call_fastpath+0x16/0x1b
Jan 24 00:13:12 IMIT2S005 kernel: ---[ end trace 154731c779d9800a ]---
Jan 24 00:13:12 IMIT2S005 kernel: kobject_add_internal failed for
5:0:0:0 with -EEXIST,

don't try to register things with the same name in the same directory.
Jan 24 00:13:12 IMIT2S005 kernel: Pid: 3830, comm: sh Tainted: G
 W  2.6.28 #1
Jan 24 00:13:12 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327d7d>]
kobject_add_internal+0x141/0x180
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803281cb>] kobject_add+0x74/0x7c
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80238692>] printk+0x4e/0x56
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80327c37>] kobject_get+0x12/0x17
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803a26f7>] get_device+0x17/0x1f
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803a2d1f>] device_add+0xb5/0x5d5
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff803a7034>]

attribute_container_device_trigger+0x9c/0xa7
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0083415>]
scsi_sysfs_add_sdev+0xa5/0x1f6

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0081595>]
scsi_probe_and_add_lun+0x9b3/0xaf5

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0080842>]
scsi_alloc_target+0x25c/0x29e

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80276173>]
zone_statistics+0x3a/0x5d
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa00818f0>]
__scsi_scan_target+0x8f/0x5c9

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8047d396>] klist_put+0x4c/0x76
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa007a01c>]
__scsi_host_match+0x0/0x10

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0081f87>]
scsi_scan_host_selected+0xed/0x10a

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffffa0084a18>]
proc_scsi_write+0x158/0x257

[scsi_mod]
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff802d1bf1>] proc_reg_write+0x73/0x8e
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80295ad6>] vfs_write+0xad/0x136
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80295f5e>] sys_write+0x45/0x6e
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8020bc8b>]
system_call_fastpath+0x16/0x1b
Jan 24 00:13:12 IMIT2S005 kernel: error 1
Jan 24 00:13:12 IMIT2S005 kernel: scsi 5:0:0:0: Direct-Access
Linux    scsi_debug

0004 PQ: 0 ANSI: 5
Jan 24 00:13:12 IMIT2S005 kernel: ------------[ cut here ]------------
Jan 24 00:13:12 IMIT2S005 kernel: WARNING: at fs/sysfs/dir.c:462
sysfs_add_one+0x33/0x39()
Jan 24 00:13:12 IMIT2S005 kernel: sysfs: duplicate filename '5:0:0:0'
can not be created
Jan 24 00:13:12 IMIT2S005 kernel: Modules linked in: scsi_debug ipv6
autofs4 hidp rfcomm

l2cap bluetooth sunrpc dm_round_robin dm_multipath rfkill
input_polldev sbs sbshc battery

acpi_memhotplug ac parport_pc lp parport floppy sg qla2xxx tg3
scsi_transport_fc libphy

rtc_cmos sr_mod button rtc_core i2c_i801 cdrom dcdbas i2c_core
serio_raw rtc_lib pcspkr

shpchp dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
ata_piix libata mptsas

mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd
ohci_hcd uhci_hcd

[last unloaded: microcode]
Jan 24 00:13:12 IMIT2S005 kernel: Pid: 3830, comm: sh Tainted: G
 W  2.6.28 #1
Jan 24 00:13:12 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80237a69>] warn_slowpath+0xb4/0xd2
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8024bc26>] down_trylock+0x26/0x2c
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8020bc8b>]
system_call_fastpath+0x16/0x1b
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8024bc26>] down_trylock+0x26/0x2c
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032bd25>] string+0x34/0x93
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032bd25>] string+0x34/0x93
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032c0f2>] vsnprintf+0x36e/0x6bd
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff80237ff0>]
try_acquire_console_sem+0x10/0x31
Jan 24 00:13:12 IMIT2S005 kernel:  [<ffffffff8032b556>] number+0x106/0x1f9
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80327034>]
idr_get_empty_slot+0x171/0x24b
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80327204>]
ida_get_new_above+0xf6/0x187
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802dd02c>]
sysfs_ilookup_test+0x0/0xf
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802dd228>]
sysfs_find_dirent+0x1b/0x2f
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802dd2de>] sysfs_add_one+0x33/0x39
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802dd7eb>] create_dir+0x4f/0x87
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802dd858>]
sysfs_create_dir+0x35/0x4b
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80327d01>]
kobject_add_internal+0xc5/0x180
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803281cb>] kobject_add+0x74/0x7c
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80238692>] printk+0x4e/0x56
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80327c37>] kobject_get+0x12/0x17
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803a26f7>] get_device+0x17/0x1f
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803a2d1f>] device_add+0xb5/0x5d5
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803a7034>]

attribute_container_device_trigger+0x9c/0xa7
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0083415>]
scsi_sysfs_add_sdev+0xa5/0x1f6

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0081595>]
scsi_probe_and_add_lun+0x9b3/0xaf5

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0080842>]
scsi_alloc_target+0x25c/0x29e

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80276173>]
zone_statistics+0x3a/0x5d
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa00818f0>]
__scsi_scan_target+0x8f/0x5c9

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff8047d396>] klist_put+0x4c/0x76
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa007a01c>]
__scsi_host_match+0x0/0x10

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0081f87>]
scsi_scan_host_selected+0xed/0x10a

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0084a18>]
proc_scsi_write+0x158/0x257

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802d1bf1>] proc_reg_write+0x73/0x8e
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80295ad6>] vfs_write+0xad/0x136
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80295f5e>] sys_write+0x45/0x6e
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff8020bc8b>]
system_call_fastpath+0x16/0x1b
Jan 24 00:13:13 IMIT2S005 kernel: ---[ end trace 154731c779d9800a ]---
Jan 24 00:13:13 IMIT2S005 kernel: kobject_add_internal failed for
5:0:0:0 with -EEXIST,

don't try to register things with the same name in the same directory.
Jan 24 00:13:13 IMIT2S005 kernel: Pid: 3830, comm: sh Tainted: G
 W  2.6.28 #1
Jan 24 00:13:13 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80327d7d>]
kobject_add_internal+0x141/0x180
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803281cb>] kobject_add+0x74/0x7c
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80238692>] printk+0x4e/0x56
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80327c37>] kobject_get+0x12/0x17
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803a26f7>] get_device+0x17/0x1f
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803a2d1f>] device_add+0xb5/0x5d5
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff803a7034>]

attribute_container_device_trigger+0x9c/0xa7
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0083415>]
scsi_sysfs_add_sdev+0xa5/0x1f6

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0081595>]
scsi_probe_and_add_lun+0x9b3/0xaf5

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0080842>]
scsi_alloc_target+0x25c/0x29e

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80276173>]
zone_statistics+0x3a/0x5d
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa00818f0>]
__scsi_scan_target+0x8f/0x5c9

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff8047d396>] klist_put+0x4c/0x76
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa007a01c>]
__scsi_host_match+0x0/0x10

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0081f87>]
scsi_scan_host_selected+0xed/0x10a

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffffa0084a18>]
proc_scsi_write+0x158/0x257

[scsi_mod]
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff802d1bf1>] proc_reg_write+0x73/0x8e
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80295ad6>] vfs_write+0xad/0x136
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff80295f5e>] sys_write+0x45/0x6e
Jan 24 00:13:13 IMIT2S005 kernel:  [<ffffffff8020bc8b>]
system_call_fastpath+0x16/0x1b
Jan 24 00:13:13 IMIT2S005 kernel: error 1

Jan 24 00:13:15 IMIT2S005 kernel: BUG: unable to handle kernel NULL
pointer dereference at

0000000000000038
Jan 24 00:13:15 IMIT2S005 kernel: IP: [<ffffffff802dd30a>]
sysfs_addrm_start+0x26/0xa1
Jan 24 00:13:15 IMIT2S005 kernel: PGD 1094a8067 PUD 10a861067 PMD 0
Jan 24 00:13:15 IMIT2S005 kernel: Oops: 0000 [#1] SMP
Jan 24 00:13:15 IMIT2S005 kernel: last sysfs file:

/sys/devices/pseudo_0/adapter0/host5/target5:0:0/5:0:0:0/timeout
Jan 24 00:13:15 IMIT2S005 kernel: CPU 0
Jan 24 00:13:15 IMIT2S005 kernel: Modules linked in: scsi_debug ipv6
autofs4 hidp rfcomm

l2cap bluetooth sunrpc dm_round_robin dm_multipath rfkill
input_polldev sbs sbshc battery

acpi_memhotplug ac parport_pc lp parport floppy sg qla2xxx tg3
scsi_transport_fc libphy

rtc_cmos sr_mod button rtc_core i2c_i801 cdrom dcdbas i2c_core
serio_raw rtc_lib pcspkr

shpchp dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
ata_piix libata mptsas

mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd
ohci_hcd uhci_hcd

[last unloaded: microcode]
Jan 24 00:13:15 IMIT2S005 kernel: Pid: 3830, comm: sh Tainted: G
 W  2.6.28 #1
Jan 24 00:13:15 IMIT2S005 kernel: RIP: 0010:[<ffffffff802dd30a>]
[<ffffffff802dd30a>]

sysfs_addrm_start+0x26/0xa1
Jan 24 00:13:15 IMIT2S005 kernel: RSP: 0018:ffff880109409a58  EFLAGS: 00010246
Jan 24 00:13:15 IMIT2S005 kernel: RAX: ffff880109408000 RBX:
0000000000000000 RCX:

0000000000000000
Jan 24 00:13:15 IMIT2S005 kernel: RDX: 00001c70094c4420 RSI:
0000000000000000 RDI:

ffffffff80622f60
Jan 24 00:13:15 IMIT2S005 kernel: RBP: ffff880109409a78 R08:
00000000000001c0 R09:

ffff880109408000
Jan 24 00:13:15 IMIT2S005 kernel: R10: 00001c70094c4420 R11:
0000000000000000 R12:

00000000fffffff4
Jan 24 00:13:15 IMIT2S005 kernel: R13: 0000000000000000 R14:
ffff880109409ad0 R15:

ffff88011c882160
Jan 24 00:13:15 IMIT2S005 kernel: FS:  00007fbd4a55e6f0(0000)
GS:ffffffff8078ea00(0000)

knlGS:0000000000000000
Jan 24 00:13:15 IMIT2S005 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jan 24 00:13:15 IMIT2S005 kernel: CR2: 0000000000000038 CR3:
00000001094af000 CR4:

00000000000006e0
Jan 24 00:13:15 IMIT2S005 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2:

0000000000000000
Jan 24 00:13:15 IMIT2S005 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7:

0000000000000400
Jan 24 00:13:16 IMIT2S005 kernel: Process sh (pid: 3830, threadinfo
ffff880109408000, task

ffff88011c9cf020)
Jan 24 00:13:16 IMIT2S005 kernel: Stack:
Jan 24 00:13:16 IMIT2S005 kernel:  00000000fffffff4 ffff8800de4d7a10
ffff88010a9fdc30

ffffffff802dd7e0
Jan 24 00:13:16 IMIT2S005 kernel:  0000000000000000 0000000000000000
0000000000000000

0000000000000000
Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
 0000000000000000

0000000000000000 0000000000000000 0000000000000000Message from
syslogd@ at Sat Jan 24

00:13:16 2009 ...IMIT2S005 kernel:  ffff8800de4d7a10 ffff8800de4d7920
00000000fffffffe

ffff8800de4d7a50Message from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel: Call

Trace:Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:

[<ffffffff802dd7e0>] ? create_dir+0x44/0x87Message from syslogd@ at
Sat Jan 24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff802dd858>] ?
sysfs_create_dir+0x35/0x4bMessage from syslogd@

at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff80327d01>] ?

kobject_add_internal+0xc5/0x180Message from syslogd@ at Sat Jan 24
00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff803281cb>] ?
kobject_add+0x74/0x7cMessage from syslogd@ at

Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff80328900>] ?

kref_get+0x1a/0x1fMessage from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel:

[<ffffffff80327c37>] ? kobject_get+0x12/0x17Message from syslogd@ at
Sat Jan 24 00:13:16

2009 ...IMIT2S005 kernel:  [<ffffffff803a26f7>] ?
get_device+0x17/0x1fMessage from syslogd@

at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff803a2d1f>] ?

device_add+0xb5/0x5d5Message from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel:

[<ffffffff803a7034>] ?
attribute_container_device_trigger+0x9c/0xa7Message from syslogd@ at

Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffffa0083415>] ?

scsi_sysfs_add_sdev+0xa5/0x1f6 [scsi_mod]Message from syslogd@ at Sat
Jan 24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffffa0081595>] ?
scsi_probe_and_add_lun+0x9b3/0xaf5 [scsi_mod]

Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
 [<ffffffffa0080842>]

? scsi_alloc_target+0x25c/0x29e [scsi_mod]Message from syslogd@ at Sat
Jan 24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff80276173>] ?
zone_statistics+0x3a/0x5dMessage from syslogd@

at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffffa00818f0>] ?

__scsi_scan_target+0x8f/0x5c9 [scsi_mod]Message from syslogd@ at Sat
Jan 24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff8047d396>] ?
klist_put+0x4c/0x76Message from syslogd@ at Sat

Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffffa007a01c>] ?
__scsi_host_match+0x0/0x10

[scsi_mod]Message from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel:

[<ffffffffa0081f87>] ? scsi_scan_host_selected+0xed/0x10a
[scsi_mod]Message from syslogd@ at

Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffffa0084a18>] ?

proc_scsi_write+0x158/0x257 [scsi_mod]Message from syslogd@ at Sat Jan
24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff802d1bf1>] ?
proc_reg_write+0x73/0x8eMessage from syslogd@

at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff80295ad6>] ?

vfs_write+0xad/0x136Message from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel:

[<ffffffff80295f5e>] ? sys_write+0x45/0x6eMessage from syslogd@ at Sat
Jan 24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff8020bc8b>] ?
system_call_fastpath+0x16/0x1bMessage from

syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel: Code: 5b 89
e8 5d c3 55 31 c0 b9

08 00 00 00 fc 53 48 89 fd 48 89 f3 48 83 ec 08 f3 ab 48 89 75 00 48
c7 c7 60 2f 62 80 e8 ad

4f 1b 00 <48> 8b 73 38 48 8b 3d 13 12 5a 00 48 89 d9 48 c7 c2 2c d0 2d
80 Message from

syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel: CR2:
0000000000000038Jan 24

00:13:16 IMIT2S005 kernel:  ffff8800de4d7a10 ffff8800de4d7920 00000000fffffffe

ffff8800de4d7a50
Jan 24 00:13:16 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff802dd7e0>] ? create_dir+0x44/0x87
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff802dd858>] ?
sysfs_create_dir+0x35/0x4b
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80327d01>] ?
kobject_add_internal+0xc5/0x180
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff803281cb>] ? kobject_add+0x74/0x7c
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80328900>] ? kref_get+0x1a/0x1f
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80327c37>] ? kobject_get+0x12/0x17
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff803a26f7>] ? get_device+0x17/0x1f
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff803a2d1f>] ? device_add+0xb5/0x5d5
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff803a7034>] ?

attribute_container_device_trigger+0x9c/0xa7
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0083415>] ?
scsi_sysfs_add_sdev+0xa5/0x1f6

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0081595>] ?
scsi_probe_and_add_lun+0x9b3/0xaf5

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0080842>] ?
scsi_alloc_target+0x25c/0x29e

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80276173>] ?
zone_statistics+0x3a/0x5d
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa00818f0>] ?
__scsi_scan_target+0x8f/0x5c9

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8047d396>] ? klist_put+0x4c/0x76
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa007a01c>] ?
__scsi_host_match+0x0/0x10

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0081f87>] ?
scsi_scan_host_selected+0xed/0x10a

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0084a18>] ?
proc_scsi_write+0x158/0x257

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff802d1bf1>] ?
proc_reg_write+0x73/0x8e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80295ad6>] ? vfs_write+0xad/0x136
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80295f5e>] ? sys_write+0x45/0x6e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8020bc8b>] ?
system_call_fastpath+0x16/0x1b
Jan 24 00:13:16 IMIT2S005 kernel: Code: 5b 89 e8 5d c3 55 31 c0 b9 08
00 00 00 fc 53 48 89

fd 48 89 f3 48 83 ec 08 f3 ab 48 89 75 00 48 c7 c7 60 2f 62 80 e8 ad
4f 1b 00 <48> 8b 73 38

48 8b 3d 13 12 5a 00 48 89 d9 48 c7 c2 2c d0 2d 80
Jan 24 00:13:16 IMIT2S005 kernel: RIP  [<ffffffff802dd30a>]
sysfs_addrm_start+0x26/0xa1
Jan 24 00:13:16 IMIT2S005 kernel:  RSP <ffff880109409a58>
Jan 24 00:13:16 IMIT2S005 kernel: CR2: 0000000000000038
Jan 24 00:13:16 IMIT2S005 kernel: ---[ end trace 154731c779d9800a ]---
Jan 24 00:13:16 IMIT2S005 kernel: Buffer I/O error on device sdb,
logical block 2046
Jan 24 00:13:16 IMIT2S005 kernel: ------------[ cut here ]------------
Jan 24 00:13:16 IMIT2S005 kernel: WARNING: at lib/list_debug.c:48
list_del+0x30/0x7b()
Jan 24 00:13:16 IMIT2S005 kernel: list_del corruption. prev->next should be

ffff88010941a820, but was 00081e75077f1200
Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
Oops: 0000 [#2] SMP

Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
last sysfs file:

/sys/devices/pseudo_0/adapter0/host5/target5:0:0/5:0:0:0/timeoutJan 24
00:13:16 IMIT2S005

kernel: list_del corruption. prev->next should be ffff88010941a820,
but was 00081e75077f1200
Jan 24 00:13:16 IMIT2S005 kernel: Modules linked in: scsi_debug ipv6
autofs4 hidp rfcomm

l2cap bluetooth sunrpc dm_round_robin dm_multipath rfkill
input_polldev sbs sbshc battery

acpi_memhotplug ac parport_pc lp parport floppy sg qla2xxx tg3
scsi_transport_fc libphy

rtc_cmos sr_mod button rtc_core i2c_i801 cdrom dcdbas i2c_core
serio_raw rtc_lib pcspkr

shpchp dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
ata_piix libata mptsas

mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd
ohci_hcd uhci_hcd

[last unloaded: microcode]
Jan 24 00:13:16 IMIT2S005 kernel: Pid: 11374, comm: vol_id Tainted: G
    D W  2.6.28 #1
Jan 24 00:13:16 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80237a69>] warn_slowpath+0xb4/0xd2
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff802b04cf>] submit_bh+0xf2/0xf9
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80329fcc>]
radix_tree_delete+0x1a0/0x1b8
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8026ed8e>] __pagevec_free+0x21/0x2e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8026bd15>] find_get_pages+0x3c/0xbf
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8033004c>] list_del+0x30/0x7b
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0082ede>]

scsi_device_dev_release_usercontext+0x48/0x109 [scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80246884>]
execute_in_process_context+0x23/0x4b
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80327c0f>]
kobject_release+0x48/0x5e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80327bc7>] kobject_release+0x0/0x5e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff803288db>] kref_put+0x41/0x4c
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa00af793>]
scsi_disk_put+0x2e/0x3f [sd_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa00b216d>]
sd_release+0xb7/0xc1 [sd_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff802b5397>] __blkdev_put+0x73/0x145
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80296281>] __fput+0xd6/0x1a3
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80293c85>] filp_close+0x5e/0x66
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80294d5f>] sys_close+0x7e/0xb7
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8020bc8b>]
system_call_fastpath+0x16/0x1b
Jan 24 00:13:16 IMIT2S005 kernel: ---[ end trace 154731c779d9800a ]---
Jan 24 00:13:16 IMIT2S005 kernel: BUG: unable to handle kernel NULL
pointer dereference at

0000000000000152
Jan 24 00:13:16 IMIT2S005 kernel: IP: [<ffffffffa007a02e>]
scsi_is_host_device+0x2/0x11

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel: PGD de128067 PUD de56d067 PMD 0
Jan 24 00:13:16 IMIT2S005 kernel: Oops: 0000 [#2] SMP
Jan 24 00:13:16 IMIT2S005 kernel: last sysfs file:

/sys/devices/pseudo_0/adapter0/host5/target5:0:0/5:0:0:0/timeout
Jan 24 00:13:16 IMIT2S005 kernel: CPU 1
Jan 24 00:13:16 IMIT2S005 kernel: Modules linked in: scsi_debug ipv6
autofs4 hidp rfcomm

l2cap bluetooth sunrpc dm_round_robin dm_multipath rfkill
input_polldev sbs sbshc battery

acpi_memhotplug ac parport_pc lp parport floppy sg qla2xxx tg3
scsi_transport_fc libphy

rtc_cmos sr_mod button rtc_core i2c_i801 cdrom dcdbas i2c_core
serio_raw rtc_lib pcspkr

shpchp dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
ata_piix libata mptsas

mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd
ohci_hcd uhci_hcd

[last unloaded: microcode]
Jan 24 00:13:16 IMIT2S005 kernel: Pid: 11374, comm: vol_id Tainted: G
    D W  2.6.28 #1
Jan 24 00:13:16 IMIT2S005 kernel: RIP: 0010:[<ffffffffa007a02e>]
[<ffffffffa007a02e>]

scsi_is_host_device+0x2/0x11 [scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel: RSP: 0018:ffff8800de475dd0  EFLAGS: 00010246
Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
Stack:Message from

syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
ffffffffa0082f6d ffff88010941aa10

ffffffff8063ca40 ffff880108914280Message from syslogd@ at Sat Jan 24
00:13:16 2009

...IMIT2S005 kernel:  ffff8801038090d8 ffff88011fa74080 ffffffff80246884

ffff880108821d38Message from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel: Call

Trace:Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:

[<ffffffffa0081747>] ? scsi_target_reap+0x24/0xb4 [scsi_mod]Message
from syslogd@ at Sat Jan

24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffffa0082f6d>] ?

scsi_device_dev_release_usercontext+0xd7/0x109 [scsi_mod]Message from
syslogd@ at Sat Jan 24

00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff80246884>] ?

execute_in_process_context+0x23/0x4bMessage from syslogd@ at Sat Jan
24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff80327c0f>] ?
kobject_release+0x48/0x5eMessage from syslogd@

at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff80327bc7>] ?

kobject_release+0x0/0x5eMessage from syslogd@ at Sat Jan 24 00:13:16
2009 ...IMIT2S005

kernel:  [<ffffffff803288db>] ? kref_put+0x41/0x4cMessage from
syslogd@ at Sat Jan 24

00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffffa00af793>] ?
scsi_disk_put+0x2e/0x3f [sd_mod]

Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
 [<ffffffffa00b216d>]

? sd_release+0xb7/0xc1 [sd_mod]Message from syslogd@ at Sat Jan 24
00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff802b5397>] ?
__blkdev_put+0x73/0x145Message from syslogd@ at

Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:  [<ffffffff80296281>] ?

__fput+0xd6/0x1a3Message from syslogd@ at Sat Jan 24 00:13:16 2009
...IMIT2S005 kernel:

[<ffffffff80293c85>] ? filp_close+0x5e/0x66Message from syslogd@ at
Sat Jan 24 00:13:16 2009

...IMIT2S005 kernel:  [<ffffffff80294d5f>] ? sys_close+0x7e/0xb7Jan 24
00:13:16 IMIT2S005

kernel: RSP: 0018:ffff8800de475dd0  EFLAGS: 00010246
Jan 24 00:13:16 IMIT2S005 kernel: RAX: 0000000000000000 RBX:
0000000000000002 RCX:

000000000000003c
Jan 24 00:13:16 IMIT2S005 kernel: RDX: 0000000000000246 RSI:
ffff8800df11ece8 RDI:

0000000000000002
Jan 24 00:13:16 IMIT2S005 kernel: RBP: ffff880102cc2400 R08:
ffffffff80332e49 R09:

ffffffff80815200
Jan 24 00:13:16 IMIT2S005 kernel: R10: 0000000000000246 R11:
ffffffff80346119 R12:

ffff88010941a8d8
Jan 24 00:13:16 IMIT2S005 kernel: R13: 0000000000000246 R14:
ffff880102cc2428 R15:

000000000000000d
Jan 24 00:13:16 IMIT2S005 kernel: FS:  0000000000686850(0063)
GS:ffff88011fa851c0(0000)

knlGS:0000000000000000
Jan 24 00:13:16 IMIT2S005 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jan 24 00:13:16 IMIT2S005 kernel: CR2: 0000000000000152 CR3:
00000000de557000 CR4:

00000000000006e0
Jan 24 00:13:16 IMIT2S005 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2:

0000000000000000
Jan 24 00:13:16 IMIT2S005 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7:

0000000000000400
Jan 24 00:13:16 IMIT2S005 kernel: Process vol_id (pid: 11374,
threadinfo ffff8800de474000,

task ffff88011f0d68d0)
Jan 24 00:13:16 IMIT2S005 kernel: Stack:
Jan 24 00:13:16 IMIT2S005 kernel:  ffffffffa0081747 ffff880102cc2400
ffff88010941a800

ffff88010941a8d8
Jan 24 00:13:16 IMIT2S005 kernel:  ffffffffa0082f6d ffff88010941aa10
ffffffff8063ca40

ffff880108914280
Jan 24 00:13:16 IMIT2S005 kernel:  ffff8801038090d8 ffff88011fa74080
ffffffff80246884

ffff880108821d38
Jan 24 00:13:16 IMIT2S005 kernel: Call Trace:
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0081747>] ?
scsi_target_reap+0x24/0xb4

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa0082f6d>] ?

scsi_device_dev_release_usercontext+0xd7/0x109 [scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80246884>] ?

execute_in_process_context+0x23/0x4b
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80327c0f>] ?
kobject_release+0x48/0x5e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80327bc7>] ?
kobject_release+0x0/0x5e
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff803288db>] ? kref_put+0x41/0x4c
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa00af793>] ?
scsi_disk_put+0x2e/0x3f [sd_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffffa00b216d>] ?
sd_release+0xb7/0xc1 [sd_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff802b5397>] ?
__blkdev_put+0x73/0x145
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80296281>] ? __fput+0xd6/0x1a3
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80293c85>] ? filp_close+0x5e/0x66
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff80294d5f>] ? sys_close+0x7e/0xb7
Jan 24 00:13:16 IMIT2S005 kernel:  [<ffffffff8020bc8b>] ?
system_call_fastpath+0x16/0x1b
Message from syslogd@ at Sat Jan 24 00:13:16 2009 ...IMIT2S005 kernel:
 [<ffffffff8020bc8b>]

? system_call_fastpath+0x16/0x1bMessage from syslogd@ at Sat Jan 24
00:13:16 2009

...IMIT2S005 kernel: Code: 8b 43 10 0f 18 08 48 8d 43 10 4c 39 e0 75
c9 5b 5d 41 5c 41 5d 41

5e c3 90 0f b7 06 39 87 e4 fc ff ff 0f 94 c0 0f b6 c0 c3 31 c0 <48> 81
bf 50 01 00 00 c0 f4

09 a0 0f 94 c0 c3 48 83 ec 08 48 89 Message from syslogd@ at Sat Jan
24 00:13:16 2009

...IMIT2S005 kernel: CR2: 0000000000000152Jan 24 00:13:16 IMIT2S005
kernel: Code: 8b 43 10

0f 18 08 48 8d 43 10 4c 39 e0 75 c9 5b 5d 41 5c 41 5d 41 5e c3 90 0f
b7 06 39 87 e4 fc ff ff

0f 94 c0 0f b6 c0 c3 31 c0 <48> 81 bf 50 01 00 00 c0 f4 09 a0 0f 94 c0
c3 48 83 ec 08 48 89
Jan 24 00:13:16 IMIT2S005 kernel: RIP  [<ffffffffa007a02e>]
scsi_is_host_device+0x2/0x11

[scsi_mod]
Jan 24 00:13:16 IMIT2S005 kernel:  RSP <ffff8800de475dd0>
Jan 24 00:13:16 IMIT2S005 kernel: CR2: 0000000000000152
Jan 24 00:13:16 IMIT2S005 kernel: ---[ end trace 154731c779d9800a ]---

*******End********

This issue seem to be happening subsequently after when device_add()
fails in scsi_sysfs_add_sdev().

Thanks
Sudhakar
