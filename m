From: Michael Reed <mdr@sgi.com>
Subject: 2.6.17-rc2: kobject_add failed
Date: Fri, 21 Apr 2006 11:05:55 -0500
Message-ID: <444902E3.2000901@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:54958 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932380AbWDUQGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 12:06:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James.Smart@Emulex.Com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, hare@suse.de, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

Hello,

I've observed with my fibre channel configuration using LSI
fibre channel cards that I occasionally discover that a
partition on a device "doesn't exist", even though it does.
The number varies from 0 to some relatively small positive
integer.  For the system boot associated with this email,
the number of missing partitions is eight.

With 2.6.17-rc2 I noticed the following dump_stack() in the
syslog.  There were eight of these dump stacks which appear to
correspond to the missing 8 partitions.

I generated these dump stacks by disabling my switch until
all the fibre channel targets were removed and then
enabled the switch to cause target rediscovery.

The "missing partitions" problem has been present in versions
of the kernel which did not include James Smart's recent
fixes to the transport so I believe that can be eliminated.
I waited to report this until James and I could get the
transport "stabilized".

Has anyone seen anything similar?  Any ideas about what
might be causing the missing partitions or how to go
about figuring it out?

Thanks,
 Mike


Apr 21 10:51:57 duck kernel: kobject_add failed for 3:0:24:0 with -EEXIST, don't try to register things
      with the same name in the same directory.
Apr 21 10:51:57 duck kernel:
Apr 21 10:51:57 duck kernel: Call Trace:
Apr 21 10:51:57 duck kernel:  [<a000000100012540>] show_stack+0x40/0xa0
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fa80 bsp=e0000034f6429350
Apr 21 10:51:57 duck kernel:  [<a0000001000125d0>] dump_stack+0x30/0x60
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fc50 bsp=e0000034f6429338
Apr 21 10:51:57 duck kernel:  [<a000000100408a80>] kobject_add+0x3a0/0x420
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fc50 bsp=e0000034f64292f8
Apr 21 10:51:57 duck kernel:  [<a0000001004de960>] device_add+0xe0/0x2e0
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fc50 bsp=e0000034f64292b8
Apr 21 10:51:57 duck kernel:  [<a0000001005605e0>] scsi_sysfs_add_sdev+0x60/0x520
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fc50 bsp=e0000034f6429270
Apr 21 10:51:57 duck kernel:  [<a00000010055c190>] scsi_probe_and_add_lun+0x11b0/0x1440
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fc50 bsp=e0000034f6429208
Apr 21 10:51:57 duck kernel:  [<a00000010055d7e0>] __scsi_scan_target+0x720/0xb60
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fc70 bsp=e0000034f6429198
Apr 21 10:51:57 duck kernel:  [<a00000010055e1d0>] scsi_scan_target+0xd0/0x100
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fcd0 bsp=e0000034f6429148
Apr 21 10:51:57 duck kernel:  [<a00000010056b3e0>] fc_scsi_scan_rport+0x180/0x240
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fcd0 bsp=e0000034f6429110
Apr 21 10:51:57 duck kernel:  [<a0000001000c9980>] run_workqueue+0x1c0/0x280
Apr 21 10:51:57 duck kernel:                                 sp=e0000034f642fcd0 bsp=e0000034f64290d0
Apr 21 10:51:57 duck kernel:  [<a0000001000cacd0>] worker_thread+0x1d0/0x260
Apr 21 10:51:58 duck kernel:                                 sp=e0000034f642fcd0 bsp=e0000034f64290a0
Apr 21 10:51:58 duck kernel:  [<a0000001000d2920>] kthread+0x220/0x2a0
Apr 21 10:51:58 duck kernel:                                 sp=e0000034f642fd50 bsp=e0000034f6429058
Apr 21 10:51:58 duck kernel:  [<a000000100010ad0>] kernel_thread_helper+0xd0/0x100
Apr 21 10:51:58 duck kernel:                                 sp=e0000034f642fe30 bsp=e0000034f6429030
Apr 21 10:51:58 duck kernel:  [<a000000100009140>] start_kernel_thread+0x20/0x40
Apr 21 10:51:58 duck kernel:                                 sp=e0000034f642fe30 bsp=e0000034f6429030
Apr 21 10:51:58 duck kernel: error 1
Apr 21 10:51:58 duck kernel: sddu: Write Protect is off
Apr 21 10:51:58 duck kernel: sddu: Mode Sense: ab 00 10 08
Apr 21 10:51:58 duck kernel:  3:0:24:0: Unexpected response from lun 0 while scanning, scan aborted
