From: "Rustad, Mark D" <mark.d.rustad@intel.com>
Subject: Re: [PATCH] scsi: Avoid NULL dereferences in scsi_cmd_to_driver
Date: Thu, 21 Jun 2012 21:28:55 +0000
Message-ID: <DC87084E-F638-4F6B-81A0-53DCE1840812@intel.com>
References: <20120621192342.30692.9665.stgit@host1-mdrustad.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760432Ab2FUV25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 17:28:57 -0400
In-Reply-To: <20120621192342.30692.9665.stgit@host1-mdrustad.localdomain>
Content-Language: en-US
Content-ID: <EDBE9788147C1B489589E009C91BDCEE@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>

The patch fixes the kernel crash indicated by the following
log messages:

host3: Assigned Port ID 0c1601
scsi host3: libfc: Host reset succeeded on port (0c1601)
BUG: unable to handle kernel NULL pointer dereference at 0000000000000350
IP: [<ffffffff81352bb8>] scsi_send_eh_cmnd+0x58/0x3a0
<snip>
Process scsi_eh_3 (pid: 4144, threadinfo ffff88030920c000, task ffff880326b160c0)
Stack:
 000000010372e6ba 0000000000000282 000027100920dca0 ffffffffa0038ee0
 0000000000000000 0000000000030003 ffff88030920dc80 ffff88030920dc80
 00000002000e0000 0000000a00004000 ffff8803242f7760 ffff88031326ed80
Call Trace:
 [<ffffffff8105b590>] ? lock_timer_base+0x70/0x70
 [<ffffffff81352fbe>] scsi_eh_tur+0x3e/0xc0
 [<ffffffff81353a36>] scsi_eh_test_devices+0x76/0x170
 [<ffffffff81354125>] scsi_eh_host_reset+0x85/0x160
 [<ffffffff81354291>] scsi_eh_ready_devs+0x91/0x110
 [<ffffffff813543fd>] scsi_unjam_host+0xed/0x1f0
 [<ffffffff813546a8>] scsi_error_handler+0x1a8/0x200
 [<ffffffff81354500>] ? scsi_unjam_host+0x1f0/0x1f0
 [<ffffffff8106ec3e>] kthread+0x9e/0xb0
 [<ffffffff81509264>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106eba0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81509260>] ? gs_change+0x13/0x13
Code: 25 28 00 00 00 48 89 45 c8 31 c0 48 8b 87 80 00 00 00 48 8d b5 60 ff ff ff 89 d1 48 89 fb 41 89 d6 4c 89 fa 48 8b 80 b8 00 00 00
 <48> 8b 80 50 03 00 00 48 8b 00 48 89 85 38 ff ff ff 48 8b 07 4c
RIP  [<ffffffff81352bb8>] scsi_send_eh_cmnd+0x58/0x3a0
 RSP <ffff88030920dc50>
CR2: 0000000000000350

-- 
Mark Rustad, LAN Access Division, Intel Corporation

