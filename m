From: Joe Feise <jfeise@feise.com>
Subject: Kernel panic: 2.6.29.6 with Megaraid
Date: Fri, 24 Jul 2009 19:12:05 -0700
Message-ID: <4A6A69F5.4060803@feise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mda4.es.uci.edu ([128.200.80.7]:35976 "EHLO mda4.es.uci.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZGYCbV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2009 22:31:21 -0400
Received: from smtp2.es.uci.edu (smtp2.es.uci.edu [128.200.80.28])
	by mda4.es.uci.edu (8.13.1/8.13.1) with ESMTP id n6P2VJ6a001239
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2009 19:31:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[Note: please cc me on answers since I'm not subscribed to the list]

When running udevd, I get a kernel panic (the trace was copied by hand from the
screen):
Call Trace:
[<c012e307>] tasklet_action+0x85/0x10d
[<c012dde9>] __do_softirq+0x8f/0x12a
[<c01139ba>] ack_apic_level+0x5b/0x1ae
[<c012dedb>] do_softirq+0x57/0x59
[<c012e0b7>] irq_exit+0x43/0x45
[<c0104b17>] do_IRQ+0x61/0xba
[<c0167d56>] shmem_get_iode+0xa1/0x199
[<c05a75f3>] _spin_lock+0x14/0x17
[<c01037a7>] common_interrupt+0x27/0x2c
[<c01900d8>] fifo_open+0xda/0x212
[<c017efaf>] kmem_cache_free+0x3a/0x54
[<c018c3b2>] sys_mkdirat+0xa8/0xd0
[<c018c3f9>] sys_kndir+0x1f/0x23
[<c0103222>] syscall_call+0x7/0xb
Code: 0f b6 82 4c 46 00 00 d3 f8 a8 01 0f 84 cd fe ff ff 8b 44 24 34 8b 70 34 8b
 06 83 e0 fc 0f 84 68 01 00 00 e8 37 eb cf ff 8b 56 04 <f6> 04 10 1f 0f 85 a9 fe
 ff ff 0f b7 4b 24 0f b7 43 26 c1 e1 04
EIP: [<c046d1b9>] megaraid_mbox_dpc+0x24d/0x561 SS:ESP 0068:f59e1e00
---[ end trace bd6fcd56a304a4d0 ]---
Kernel panic - not syncing: Fatal exception in interrupt

The environment:
- Kernel 2.6.29.6, megaraid_mm and megaraid_mbox in the kernel (not modules,
since I boot from the raid disk.)
- Distribution: Slackware 12.2
- LSI Megaraid 320-2 2-channel SCSI RAID PCI card, firmware 1L49
- Attached to channel 1: 1 RAID 1, 1 RAID 0 disks
- Attached to channel 2: 1 DVD drive using a SCSI-to-IDE adapter
- Megaraid boot option: unconf_disks=1
- udevd version 135
- the udev file that triggers it: /etc/udev/rules.d/50-udev.rules (may be
Slackware-specific)
- the SCSI-related entries in the 50-uder.rules file:
# sysfs is populated after the event is sent
ACTION=="add", KERNEL=="[0-9]*:[0-9]*", SUBSYSTEM=="scsi",
WAIT_FOR_SYSFS="ioerr_cnt"

# permissions for SCSI sg/tape devices
SUBSYSTEMS=="scsi", KERNEL=="s[gt][0-9]*", ATTRS{type}=="5", NAME="%k",
GROUP="cdrom", MODE="0660"

# load modules to scsi disks, if they aren't in kernel
SUBSYSTEM=="scsi_device", ACTION=="add", ATTRS{type}=="0|7|14",
RUN+="/sbin/modprobe sd_mod"
SUBSYSTEM=="scsi_device", ACTION=="add", ATTRS{type}=="1",
ATTRS{vendor}=="On[sS]tream", RUN+="/sbin/modprobe osst"
SUBSYSTEM=="scsi_device", ACTION=="add", ATTRS{type}=="1", RUN+="/sbin/modprobe st"
SUBSYSTEM=="scsi_device", ACTION=="add", ATTRS{type}=="[45]",
RUN+="/sbin/modprobe sr_mod"
SUBSYSTEM=="scsi_device", ACTION=="add", RUN+="/sbin/modprobe sg"

ACTION!="add", GOTO="persistent_storage_end"

KERNEL=="nst[0-9]", SUBSYSTEMS=="scsi", ENV{ID_SERIAL}=="",
IMPORT{program}="scsi_id -g -x -s %p -d $tempnode"
KERNEL=="nst[0-9]", SUBSYSTEMS=="scsi", ENV{ID_SERIAL}=="",
IMPORT{program}="scsi_id -g -x -a -s %p -d $tempnode"
KERNEL=="nst[0-9]", SUBSYSTEMS=="scsi", ENV{ID_SERIAL}=="?*",
SYMLINK+="tape/by-id/$env{ID_BUS}-$env{ID_SERIAL}-nst"

# type 8 devices are "Medium Changers"
KERNEL=="sg*", SUBSYSTEMS=="scsi", ATTRS{type}=="8", ENV{ID_SERIAL}=="",
IMPORT{program}="scsi_id -g -x -s %p -d $tempno
de"
KERNEL=="sg*", SUBSYSTEMS=="scsi", ATTRS{type}=="8", ENV{ID_SERIAL}=="",
IMPORT{program}="scsi_id -g -x -a -s %p -d $tem
pnode"
KERNEL=="sg*", SUBSYSTEMS=="scsi", ATTRS{type}=="8", ENV{ID_SERIAL}=="?*",
SYMLINK+="tape/by-id/$env{ID_BUS}-$env{ID_SER
IAL}"

KERNEL=="sd*[!0-9]|sr*|st*", ENV{ID_SERIAL}=="", IMPORT{program}="scsi_id -g -x
-s %p -d $tempnode"
KERNEL=="sd*[!0-9]|sr*|st*", ENV{ID_SERIAL}=="", IMPORT{program}="scsi_id -g -x
-a -s %p -d $tempnode"

- If I comment out these entries, I don't get the kernel panic.
- Alternatively, if I disconnect the DVD on the Megaraid channel 2, I don't get
the kernel panic.
- This started happening after an upgrade of Slackware from 12.0 to 12.2. Same
kernel, but udev changed.

-Joe


