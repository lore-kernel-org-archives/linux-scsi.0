From: Bernhard Schmidt <berni@birkenwald.de>
Subject: MegaSAS - debugging a broken disk?
Date: Tue, 11 Oct 2011 20:48:25 +0000 (UTC)
Message-ID: <j72a2p$upe$1@dough.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50020 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1JKUuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2011 16:50:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1RDjH2-0005z8-4X
	for linux-scsi@vger.kernel.org; Tue, 11 Oct 2011 22:50:04 +0200
Received: from ppp-93-104-60-120.dynamic.mnet-online.de ([93.104.60.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2011 22:50:04 +0200
Received: from berni by ppp-93-104-60-120.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2011 22:50:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm not quite sure this is fully on-topic, apologies for the
disturbance. Maybe someone here has experience with this.

We've bought some new database servers with MegaSAS MR9260-4i. Attached
are two Seagate ST3600057SS (15k SAS disks) in a RAID1 configuration
(and a SSD in RAID0 = single disk, but that is not in use here). The
controller runs the most recent firmware (2.13).

We noticed absurdly slow write performance and kernel backtraces like

[ 2041.527947] INFO: task scsi_id:2915 blocked for more than 120
seconds.
[ 2041.527951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2041.527955] scsi_id         D ffffffff81609d40     0  2915   2804
0x00000004
[ 2041.527962]  ffff8803536a5b48 0000000000000082 ffff8803536a5a68
ffffffff00000000
[ 2041.527971]  ffff8803536a5fd8 ffff8803536a5fd8 ffff8803536a4000
0000000000013780
[ 2041.527975]  0000000000013780 ffff8803536a5fd8 ffffffff81a0b020
ffff8803536a2500
[ 2041.527978] Call Trace:
[ 2041.527986]  [<ffffffff81030a04>] ? do_page_fault+0x358/0x394
[ 2041.527990]  [<ffffffff814fa80e>] ? common_interrupt+0xe/0x13
[ 2041.527994]  [<ffffffff8104314b>] ? mutex_spin_on_owner+0x44/0x78
[ 2041.527998]  [<ffffffff814f8f9e>] __mutex_lock_slowpath+0x116/0x18b
[ 2041.528002]  [<ffffffff8112a4d8>] ? blkdev_open+0x0/0x6e
[ 2041.528004]  [<ffffffff814f8996>] mutex_lock+0x18/0x2f
[ 2041.528007]  [<ffffffff81129f5c>] __blkdev_get+0x73/0x348
[ 2041.528009]  [<ffffffff8112a4d8>] ? blkdev_open+0x0/0x6e
[ 2041.528012]  [<ffffffff8112a3f3>] blkdev_get+0x1c2/0x2a7
[ 2041.528016]  [<ffffffff81109d91>] ? do_lookup+0x1da/0x288
[ 2041.528020]  [<ffffffff81293035>] ? aufs_permission+0x27d/0x28f
[ 2041.528022]  [<ffffffff8112a4d8>] ? blkdev_open+0x0/0x6e
[ 2041.528025]  [<ffffffff8112a542>] blkdev_open+0x6a/0x6e
[ 2041.528028]  [<ffffffff810fe9aa>] __dentry_open.isra.15+0x1ce/0x2e5
[ 2041.528031]  [<ffffffff810ff700>] nameidata_to_filp+0x48/0x4f
[ 2041.528034]  [<ffffffff8110b9d7>] finish_open+0xa1/0x155
[ 2041.528037]  [<ffffffff8110aa8e>] ? do_path_lookup+0x69/0xcf
[ 2041.528039]  [<ffffffff8110bed9>] do_filp_open+0x178/0x609
[ 2041.528043]  [<ffffffff810da74f>] ? handle_mm_fault+0x262/0x275
[ 2041.528046]  [<ffffffff810dcb18>] ? unmap_region+0x138/0x16d
[ 2041.528049]  [<ffffffff811164ce>] ? alloc_fd+0x109/0x11b
[ 2041.528052]  [<ffffffff810ff767>] do_sys_open+0x60/0xf9
[ 2041.528054]  [<ffffffff810ff820>] sys_open+0x20/0x22
[ 2041.528058]  [<ffffffff8100ab82>] system_call_fastpath+0x16/0x1b

on one of the systems. mkfs.ext4 would take 20-30 minutes for the
creation of a 500GB filesystem, during which iostat would show 100%
utilization of the logical disk. The system was also extremely slow to
react, executing a program that had not run before (was not in the
cache) took up to 30 seconds during that mkfs run.

After some unsuccessful experiments with the IO scheduler I'm now
reasonably sure that one of the disks is faulty. 

RAID-0 out of [252:1]:	good
RAID-0 out of [252:2]:  bad
RAID-1 out of [252:1,252:2]:	bad
   ^	mark [252:2] offline:	good

In this case the detection was reasonably easy because the system wasn't
in production yet, but I can't just destroy a volume every time. Problem
is, I see exactly no hint anywhere that this particular disk might have
a problem. 

# ./megacli -PDList -a0
Enclosure Device ID: 252
Slot Number: 2
Device Id: 4
Sequence Number: 9
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SAS
[...]

There is nothing in the Event log, there is nothing visible in
-PhyErrorCounters. smartctl -d megaraid,0 /dev/sda does not work on this
platform either (INQUIRY failed, version 2011-06-09 r3365).

What would be the best way to debug such a problem in the future? I
could not yet look into the WebBIOS thingy because the machine is 50km
away and the IP-KVM is broken, but I don't expect to see much there.

Thanks,
Bernhard

