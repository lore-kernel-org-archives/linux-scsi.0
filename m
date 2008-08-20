From: greg@enjellic.com
Subject: Who do we point to?
Date: Wed, 20 Aug 2008 14:11:29 -0500
Message-ID: <200808201911.m7KJBTik015082@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([209.243.13.15]:33881 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYHTTM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 15:12:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel@lists.sourceforge.net, vst@vlnb.net
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linuxraid@amcc.com, neilb@suse.de, linux-raid@vger.kernel.org

Good morning hope the day is going well for everyone.

Apologies for the large broadcast domain on this.  I wanted to make
sure everyone who may have an interest in this is involved.

Some feedback on another issue we encountered with Linux in a
production initiator/target environment with SCST.  I'm including logs
below from three separate systems involved in the incident.  I've gone
through them with my team and we are currently unsure on what
triggered all this, hence mail to everyone who may be involved.

The system involved is SCST 1.0.0.0 running on a Linux 2.6.24.7 target
platform using the qla_isp driver module.  The target machine has two
9650 eight port 3Ware controller cards driving a total of 16 750
gigabyte Seagate NearLine drives.  Firmware on the 3ware and Qlogic
cards should all be current.  There are two identical servers in two
geographically separated data-centers.

The drives on each platform are broken into four 3+1 RAID5 devices
with software RAID.  Each RAID5 volume is a physical volume for an LVM
volume group. There is currently one logical volume exported from each
of four RAID5 volumes as a target device.  A total of four initiators
are thus accessing the target server, each accessing different RAID5
volumes.

The initiators are running a stock 2.6.26.2 kernel with a RHEL5
userspace.  Access to the SAN is via a 2462 dual-port Qlogic card.
The initiators see a block device from each of the two target servers
through separate ports/paths.  The block devices form a software RAID1
device (with bitmaps) which is the physical volume for an LVM volume
group.  The production filesystem is supported by a single logical
volume allocated from that volume group.

A drive failure occured last Sunday afternoon on one of the RAID5
volumes.  The target kernel recognized the failure, failed the device
and kept going.

Unfortunately three of the four initiators picked up a device failure
which caused the SCST exported volume to be faulted out of the RAID1
device.  One of the initiators noted an incident was occurring, issued
a target reset and continued forward with no issues.

The initiator which got things 'right' was not accessing the RAID5
volume on the target which experienced the error.  Two of the three
initiators which faulted out their volumes were not accessing the
compromised RAID5 volume.  The initiator accessing the volume faulted
out its device.

In the logs below the 'init1' initiator was the one which did not fail
its device.  The init2 log is an example log from the initiators which
failed out their devices, behavior seemed to be identical on all the
initiators which faulted their block devices.  The log labelled target
are the log entries from the event on the SCST server.  All three
servers from which logs were abstracted were NTP time synchronized so
log timings are directly correlatable.

Some items to note:

---
The following log message from the 3Ware driver seems bogus with
respect to the port number.  Doubtfull this has anything to do with
the incident but may be of interest to the 3Ware people copied on this
note:

Aug 17 17:55:16 scst-target kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x000A): Drive error detected:unit=2, port=-2147483646.

---
The initiators which received I/O errors had the Qlogic driver attempt
a 'DEVICE RESET' which failed and was then retried.  The second reset
attempt succeeded.

The 3Ware driver elected to reset the card at 17:55:32.  A period of
44 seconds elapses from that message until end_request picks up on the
I/O error which causes the RAID5 driver to fault the affected drive.
The initiators which failed their 'DEVICE RESET' issued their failed
requests during this time window.

Of interest to Vlad may be the following log entry(s):

Aug 17 17:56:07 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): DEVICE RESET FAILED: Task management failed.

The initiator which had its 'DEVICE RESET' succeed issued the reset
after the above window with a timestamp identical to that of the
end_request I/O error message on the target.

---
Of interest to NeilB and why I copied him as well is the following.

Precisely one minute after the second attempt to reset the target
succeeeds the kernel indicates the involved RAID1 kthread has blocked
for more than 120 seconds.  The call trace indicates the thread was
waiting on a RAID superblock update.

Immediately after the kernel finishes issueing the message and stack
trace the Qlogic driver attempts to abort a SCSI command which results
in end_request getting an I/O error which causes the device to be
faulted from the RAID1 device.

This occurs one full minute AFTER the target RAID5 device has had its
device evicted and is continuing in normal but degraded operation.
---


Empirically it would seem the initiators which were 'unlucky' happened
to issue their 'DEVICE RESET' requests while the SCST service thread
they were assigned to was blocked waiting for the 3Ware card to reset.
What is unclear is why the initiator I/O error was generated after the
reset succeeded the second time, a minute after the incident was
completely over as far as the SCST target server was concerned.

A question for Vlad.  The SCST target server is a dual-processor SMP
box with the default value of two kernel threads active.  Would it be
advantageous to increase this value to avoid situations like this?
Would an appropriate metric be to have the number of active threads
equal to the number of exported volumes or initiators?

I would be interested in any ideas the group may have.  Let me know if
I can provide additional information or documentation on any of this.

Best wishes for a productive remainder of the week.

GW

Logs follow.

init1 (good) --------------------------------------------------------------
Aug 17 17:56:02 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e334 2002.
Aug 17 17:56:08 init1 sshd[14485]: Did not receive identification string from 134.129.111.71
Aug 17 17:56:13 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e334 2002.
Aug 17 17:56:13 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e335 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e336 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e337 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e338 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e339 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e33a 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e33b 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e33c 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e33d 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e33e 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 2e33f 2002.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): DEVICE RESET ISSUED.
Aug 17 17:56:16 init1 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): DEVICE RESET SUCCEEDED.
---------------------------------------------------------------------------

init2 (bad) ---------------------------------------------------------------
Aug 17 17:55:37 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 3b848 2002.
Aug 17 17:55:47 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 3b848 2002.
Aug 17 17:55:47 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): DEVICE RESET ISSUED.
Aug 17 17:56:07 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): DEVICE RESET FAILED: Task management failed.
Aug 17 17:56:07 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): TARGET RESET ISSUED.
Aug 17 17:56:08 init2 sshd[15769]: Did not receive identification string from 134.129.111.71
Aug 17 17:56:16 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): TARGET RESET SUCCEEDED.
Aug 17 17:57:08 init2 sshd[15815]: Did not receive identification string from 134.129.111.71
Aug 17 17:57:16 init2 kernel: INFO: task md7_raid1:739 blocked for more than 120 seconds.
Aug 17 17:57:16 init2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 17 17:57:16 init2 kernel: md7_raid1     D ffff81025e405e00  5792   739      2
Aug 17 17:57:16 init2 kernel:  ffff81025d523c70 0000000000000046 000000000000ffff 000000003e7fff88
Aug 17 17:57:16 init2 kernel:  ffff81025d4cd140 ffff81025fe73000 ffff81025d4cd488 0000000400000000
Aug 17 17:57:16 init2 kernel:  ffff8101f81018c0 0000000000000000 ffff81025fdfaa80 ffffffff802a382c
Aug 17 17:57:16 init2 kernel: Call Trace:
Aug 17 17:57:16 init2 kernel:  [<ffffffff802a382c>] bio_alloc_bioset+0x89/0xd9
Aug 17 17:57:16 init2 kernel:  [<ffffffff803c4d64>] md_super_wait+0xa3/0xb7
Aug 17 17:57:16 init2 kernel:  [<ffffffff8023fbb4>] autoremove_wake_function+0x0/0x2e
Aug 17 17:57:16 init2 kernel:  [<ffffffff803cc017>] write_page+0x1bb/0x2a3
Aug 17 17:57:16 init2 kernel:  [<ffffffff80224c00>] find_busiest_group+0x25e/0x6c6
Aug 17 17:57:16 init2 kernel:  [<ffffffff803c7e9a>] super_90_sync+0x359/0x367
Aug 17 17:57:16 init2 kernel:  [<ffffffff803c5461>] md_update_sb+0x1be/0x291
Aug 17 17:57:16 init2 kernel:  [<ffffffff803c9841>] md_check_recovery+0x185/0x4c0
Aug 17 17:57:16 init2 kernel:  [<ffffffff80242434>] hrtimer_start+0xfc/0x11e
Aug 17 17:57:16 init2 kernel:  [<ffffffffa0044091>] :raid1:raid1d+0x25/0xc68
Aug 17 17:57:16 init2 kernel:  [<ffffffff80459e32>] thread_return+0x63/0xa4
Aug 17 17:57:16 init2 kernel:  [<ffffffff80236d9f>] lock_timer_base+0x26/0x4b
Aug 17 17:57:16 init2 kernel:  [<ffffffff80236e15>] try_to_del_timer_sync+0x51/0x5a
Aug 17 17:57:16 init2 kernel:  [<ffffffff80236e2a>] del_timer_sync+0xc/0x16
Aug 17 17:57:16 init2 kernel:  [<ffffffff8045a0ff>] schedule_timeout+0x92/0xad
Aug 17 17:57:16 init2 kernel:  [<ffffffff803cb2e9>] md_thread+0xd7/0xed
Aug 17 17:57:16 init2 kernel:  [<ffffffff8023fbb4>] autoremove_wake_function+0x0/0x2e
Aug 17 17:57:16 init2 kernel:  [<ffffffff803cb212>] md_thread+0x0/0xed
Aug 17 17:57:16 init2 kernel:  [<ffffffff8023fa95>] kthread+0x47/0x76
Aug 17 17:57:16 init2 kernel:  [<ffffffff8022aa03>] schedule_tail+0x28/0x5d
Aug 17 17:57:16 init2 kernel:  [<ffffffff8020cb78>] child_rip+0xa/0x12
Aug 17 17:57:16 init2 kernel:  [<ffffffff8023fa4e>] kthread+0x0/0x76
Aug 17 17:57:16 init2 kernel:  [<ffffffff8020cb6e>] child_rip+0x0/0x12
Aug 17 17:57:16 init2 kernel: 
Aug 17 17:57:17 init2 kernel: qla2xxx 0000:0c:00.0: scsi(3:0:0): Abort command issued -- 1 3b849 2002.
Aug 17 17:57:17 init2 kernel: end_request: I/O error, dev sdc, sector 1048575880
Aug 17 17:57:17 init2 kernel: md: super_written gets error=-5, uptodate=0
Aug 17 17:57:17 init2 kernel: raid1: Disk failure on sdc1, disabling device.
Aug 17 17:57:17 init2 kernel: raid1: Operation continuing on 1 devices.
Aug 17 17:57:17 init2 kernel: RAID1 conf printout:
Aug 17 17:57:17 init2 kernel:  --- wd:1 rd:2
Aug 17 17:57:17 init2 kernel:  disk 0, wo:1, o:0, dev:sdc1
Aug 17 17:57:17 init2 kernel:  disk 1, wo:0, o:1, dev:sdd1
Aug 17 17:57:17 init2 kernel: RAID1 conf printout:
Aug 17 17:57:17 init2 kernel:  --- wd:1 rd:2
Aug 17 17:57:17 init2 kernel:  disk 1, wo:0, o:1, dev:sdd1
---------------------------------------------------------------------------

target --------------------------------------------------------------------
Aug 17 17:55:13 scst-target kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=2.
Aug 17 17:55:16 scst-target kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x000A): Drive error detected:unit=2, port=-2147483646.
Aug 17 17:55:18 scst-target kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=2.
Aug 17 17:55:29 scst-target last message repeated 2 times
Aug 17 17:55:32 scst-target kernel: sd 1:0:2:0: WARNING: (0x06:0x002C): Command (0x2a) timed out, resetting card.
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 66331127
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 37108159
Aug 17 17:56:16 scst-target kernel: raid5: Disk failure on sdk1, disabling device. Operation continuing on 3 devices
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 37109439
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 37108799
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 37108847
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 37109191
Aug 17 17:56:16 scst-target kernel: end_request: I/O error, dev sdk, sector 37109183
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37108687
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37108431
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37108423
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37108207
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37106855
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37107135
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37107391
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37107519
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37107775
Aug 17 17:56:17 scst-target kernel: end_request: I/O error, dev sdk, sector 37107823
Aug 17 17:56:18 scst-target kernel: end_request: I/O error, dev sdk, sector 151465351
Aug 17 17:56:18 scst-target kernel: RAID5 conf printout:
Aug 17 17:56:18 scst-target kernel:  --- rd:4 wd:3
Aug 17 17:56:18 scst-target kernel:  disk 0, o:1, dev:sdi1
Aug 17 17:56:18 scst-target kernel:  disk 1, o:1, dev:sdj1
Aug 17 17:56:18 scst-target kernel:  disk 2, o:0, dev:sdk1
Aug 17 17:56:18 scst-target kernel:  disk 3, o:1, dev:sdl1
Aug 17 17:56:18 scst-target kernel: RAID5 conf printout:
Aug 17 17:56:18 scst-target kernel:  --- rd:4 wd:3
Aug 17 17:56:18 scst-target kernel:  disk 0, o:1, dev:sdi1
Aug 17 17:56:18 scst-target kernel:  disk 1, o:1, dev:sdj1
Aug 17 17:56:18 scst-target kernel:  disk 3, o:1, dev:sdl1
Aug 17 19:37:16 scst-target sshd[4515]: refused connect from mon1 (::ffff:xxx.xx.xxx.xxx)
---------------------------------------------------------------------------

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"This patch causes a CONFIG_PREEMPT=y, CONFIG_PREEMPT_BKL=y,
 CONFIG_DEBUG_PREEMPT=y kernel on a ppc64 G5 to hang immediately after
 displaying the penguins, but apparently not before having set the
 hardware clock backwards 101 years."

"After having carefully reviewed the above description and having
 decided that these effects were not a part of the patch's design
 intent I have temporarily set it aside, thanks."
                                -- Andrew Morton
                                   linux-kernel
