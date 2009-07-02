From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi
 device handler
Date: Thu, 02 Jul 2009 15:34:59 -0400
Message-ID: <1246563299.8018.9.camel@eddie-laptop>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o144.mxlogic.net ([208.65.145.77]:37440 "EHLO
	p02c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZGBTfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 15:35:03 -0400
In-Reply-To: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com


I have tried to set this up but have run into a problem probably due to
my error.  It has been a while since I have had to build kernels...

I pulled 2.6.31-rc1, applied the two patches below and then applied the
3 patches for the interface.  The new kernel loads fine but when a
trespass command is sent I get an panic.  I am looking though how I
built the kernel and perhaps build with your 3 patches to see if it
happened before.  

Here is the data:

Jul  2 14:57:57 bullwinkle kernel: kernel BUG at
block/cfq-iosched.c:2273!
Jul  2 14:57:57 bullwinkle kernel: invalid opcode: 0000 [#1] SMP 
Jul  2 14:57:57 bullwinkle kernel: last sysfs
file: /sys/kernel/uevent_seqnum
Jul  2 14:57:57 bullwinkle kernel: CPU 1 
Jul  2 14:57:57 bullwinkle kernel: Modules linked in: scsi_dh_emc
dm_round_robin dm_multipath scsi_dh microcode fuse loop dm_mod i5k_amb
iTCO_wdt iTCO_vendor_support i2c_i801 ibmpex i5000_edac ses rtc_cmos
ibmaem bnx2 ipmi_msghandler sr_mod rtc_core enclosure i2c_core pcspkr
edac_core cdrom serio_raw rtc_lib joydev shpchp pci_hotplug button sg
usbhid hid uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache
jbd fan ide_pci_generic ide_core ata_generic ata_piix libata lpfc
scsi_transport_fc scsi_tgt aacraid scsi_mod thermal processor
thermal_sys hwmon
Jul  2 14:57:57 bullwinkle kernel: Pid: 4509, comm: kmpath_handlerd
Tainted: G        W  2.6.31-rc1-0.1-default #1 IBM System x3650
-[7979A2U]-
Jul  2 14:57:57 bullwinkle kernel: RIP: 0010:[<ffffffff81174b36>]
[<ffffffff81174b36>] cfq_put_request+0x29/0x67
Jul  2 14:57:57 bullwinkle kernel: RSP: 0018:ffff8804a5ce1c70  EFLAGS:
00010046
Jul  2 14:57:57 bullwinkle kernel: RAX: 0000000000000000 RBX:
ffff88049ec891f0 RCX: 0000000000000579
Jul  2 14:57:57 bullwinkle kernel: RDX: 0000000000000019 RSI:
ffff88049ec891f0 RDI: ffff88049ec891f0
Jul  2 14:57:57 bullwinkle kernel: RBP: ffff8804a5ce1c80 R08:
ffff8804a5ce0000 R09: 0000000000000000
Jul  2 14:57:57 bullwinkle kernel: R10: ffffffffa002bb0d R11:
0000000000000000 R12: ffff8804a356a5d0
Jul  2 14:57:57 bullwinkle kernel: R13: ffff8804a54d6b08 R14:
ffff8804a5052400 R15: ffff8804a5052400
Jul  2 14:57:57 bullwinkle kernel: FS:  0000000000000000(0000)
GS:ffff880028050000(0000) knlGS:0000000000000000
Jul  2 14:57:57 bullwinkle kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jul  2 14:57:57 bullwinkle kernel: CR2: 0000000000617b48 CR3:
0000000492c72000 CR4: 00000000000006e0
Jul  2 14:57:57 bullwinkle kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jul  2 14:57:57 bullwinkle kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jul  2 14:57:57 bullwinkle kernel: Process kmpath_handlerd (pid: 4509,
threadinfo ffff8804a5ce0000, task ffff8804a4d2a100)
Jul  2 14:57:57 bullwinkle kernel: Stack:
Jul  2 14:57:57 bullwinkle kernel:  ffff88049ec891f0 0000000001282c4f
ffff8804a5ce1c90 ffffffff811615f7
Jul  2 14:57:57 bullwinkle kernel: <0> ffff8804a5ce1cc0 ffffffff81166d45
0000000000000055 ffff8804a54d6b08
Jul  2 14:57:57 bullwinkle kernel: <0> ffff88049ec891f0 0000000000000282
ffff8804a5ce1cf0 ffffffff81167272
Jul  2 14:57:57 bullwinkle kernel: Call Trace:
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff811615f7>] elv_put_request
+0x19/0x1b
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff81166d45>]
__blk_put_request+0x87/0xbd
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff81167272>] blk_put_request
+0x2e/0x45
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffffa02dd52a>]
send_trespass_cmd+0x250/0x262 [scsi_dh_emc]
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffffa02dd573>] ?
clariion_send_inquiry+0x37/0x200 [scsi_dh_emc]
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffffa02dd88e>]
clariion_activate+0x4d/0x131 [scsi_dh_emc]
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffffa02b37e4>]
scsi_dh_activate+0x87/0xa4 [scsi_dh]
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffffa02d81d3>] activate_path
+0x32/0x151 [dm_multipath]
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff81054424>] worker_thread
+0x172/0x20c
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffffa02d81a1>] ? activate_path
+0x0/0x151 [dm_multipath]
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff81058774>] ?
autoremove_wake_function+0x0/0x38
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff810542b2>] ? worker_thread
+0x0/0x20c
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff81058406>] kthread
+0x88/0x90
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff8100ca3a>] child_rip
+0xa/0x20
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff8105837e>] ? kthread
+0x0/0x90
Jul  2 14:57:57 bullwinkle kernel:  [<ffffffff8100ca30>] ? child_rip
+0x0/0x20
Jul  2 14:57:57 bullwinkle kernel: Code: c9 c3 55 48 89 e5 41 54 53 4c
8b a7 a8 00 00 00 48 89 fb 4d 85 e4 74 4c 8b 47 48 83 e0 01 48 8d 50 18
41 8b 44 94 08 85 c0 75 04 <0f> 0b eb fe ff c8 41 89 44 94 08 48 8b 87
a0 00 00 00 48 8b 78 
Jul  2 14:57:57 bullwinkle kernel: RIP  [<ffffffff81174b36>]
cfq_put_request+0x29/0x67
Jul  2 14:57:57 bullwinkle kernel:  RSP <ffff8804a5ce1c70>
Jul  2 14:57:57 bullwinkle kernel: ---[ end trace 4eaa2a86a8e2da24 ]---

On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:
> Hello,
> 
> Last week, Eddie Williams reported a regression w.r.t scsi_dh
> (http://www.redhat.com/archives/dm-devel/2009-June/msg00285.html).
> Parameter setting part of dm multipath handler has been removed
> when we moved to scsi device handler.
> 
> This set of patches adds an new interface to scsi_dh and uses it.
> 
> This patch set applies on 2.6.31-rc1 and the following 2 patches:
> 	(1) http://patchwork.kernel.org/patch/32646/raw/
> 	(2) http://patchwork.kernel.org/patch/32647/raw/
> 
> This interface part of the patch has been tested.
> 
> Eddie,
> 
> If you can test it on an EMC storage and respond with your
> findings it will be of great help.
> 
> Thanks,
> 
> chandra
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

