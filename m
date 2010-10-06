From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] scsi: Fix race when removing SCSI devices
Date: Wed, 6 Oct 2010 13:19:44 +0200
Message-ID: <20101006111944.GA7064@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39237 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0JFLTv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 07:19:51 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o96BJlx6000676
	for <linux-scsi@vger.kernel.org>; Wed, 6 Oct 2010 11:19:47 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o96BJjrI1556552
	for <linux-scsi@vger.kernel.org>; Wed, 6 Oct 2010 12:19:47 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o96BJjdi007327
	for <linux-scsi@vger.kernel.org>; Wed, 6 Oct 2010 12:19:45 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Removing SCSI devices through
echo 1 > /sys/bus/scsi/devices/ ... /delete

while the FC transport class removes the SCSI target can lead to an
oops:

Unable to handle kernel pointer dereference at virtual kernel address 00000000b6815000
Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 qeth ccwgroup [last unloaded: scsi_wait_scan]
CPU: 1 Not tainted 2.6.35.5-45.x.20100924-s390xdefault #1
Process fc_wq_0 (pid: 861, task: 00000000b7331240, ksp: 00000000b735bac0)
Krnl PSW : 0704200180000000 00000000003ff6e4 (__scsi_remove_device+0x24/0xd0)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000001 0000000000000000 00000000b6815000 00000000bc24a8c0
           00000000003ff7c8 000000000056dbb8 0000000000000002 0000000000835d80
           ffffffff00000000 0000000000001000 00000000b6815000 00000000bc24a7f0
           00000000b68151a0 00000000b6815000 00000000b735bc20 00000000b735bbf8
Krnl Code: 00000000003ff6d6: a7840001            brc 8,3ff6d8
           00000000003ff6da: a7fbffd8            aghi %r15,-40
           00000000003ff6de: e3e0f0980024        stg %r14,152(%r15)
          >00000000003ff6e4: e31021200004        lg %r1,288(%r2)
           00000000003ff6ea: a71f0000            cghi    %r1,0
           00000000003ff6ee: a7a40011            brc 10,3ff710
           00000000003ff6f2: a7390003            lghi    %r3,3
           00000000003ff6f6: c0e5ffffc8b1        brasl %r14,3f8858
Call Trace:
([<0000000000001000>] 0x1000)
 [<00000000003ff7d2>] scsi_remove_device+0x42/0x54
 [<00000000003ff8ba>] __scsi_remove_target+0xca/0xfc
 [<00000000003ff99a>] __remove_child+0x3a/0x48
 [<00000000003e3246>] device_for_each_child+0x72/0xbc
 [<00000000003ff93a>] scsi_remove_target+0x4e/0x74
 [<0000000000406586>] fc_rport_final_delete+0xb2/0x23c
 [<000000000015d080>] worker_thread+0x200/0x344
 [<000000000016330c>] kthread+0xa0/0xa8
 [<0000000000106c1a>] kernel_thread_starter+0x6/0xc
 [<0000000000106c14>] kernel_thread_starter+0x0/0xc
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<00000000003ff7cc>] scsi_remove_device+0x3c/0x54

The function __scsi_remove_target iterates through the SCSI devices on
the host, but it drops the host_lock before calling
scsi_remove_device. When the SCSI device is deleted from another
thread, the pointer to the SCSI device in scsi_remove_device can
become invalid. Fix this by getting a reference to the SCSI device
before dropping the host_lock to keep the SCSI device alive for the
call to scsi_remove_device.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -962,10 +962,11 @@ static void __scsi_remove_target(struct
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
-		    sdev->sdev_state == SDEV_DEL)
+		    scsi_device_get(sdev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
 		goto restart;
 	}
