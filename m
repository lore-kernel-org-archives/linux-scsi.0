From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: PROBLEM: kernel BUG at block/cfq-iosched.c:3402
Date: Tue, 2 Mar 2010 00:04:54 +0000 (UTC)
Message-ID: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 18 Mar 2010 22:31:29 -0700
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, Eddie Williams <Eddie.Williams@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hugh Daschbach <hdasch@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Apologies in advance if this seems like nagging.  I've posted this
before, but never saw it pass through the mailing list.

For long trespass CDBs, the EMC multipath device handler (in
get_req()) allocates a "struct request" with READ specified in the I/O
direction flag.  It then changes this to a WRITE before
send_trespass_cmd() calls blk_execute_rq().  This provokes a BUG() in
cfq_put_request() after the I/O completes and the request is released.

cfq_set_request() and cfq_put_request() count READ and WRITE requests
separately.  Changing the I/O request direction after blk_get_request()
allocates the request throws off this CFQ accounting.

Here's a traceback of the BUG.

Dec 28 15:06:07 ------------[ cut here ]------------
kernel BUG at block/cfq-iosched.c:3402!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.1/irq
CPU 1
Modules linked in: dm_round_robin scsi_dh_emc bnx2fc libfcoe libfc scsi_transport_fc cnic 8021q nfs fscache nfsd lockd bridge nfs_acl auth_rpcgss exportfs stp bnep sco l2cap crc16 bluetooth sunrpc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 loop dm_multipath scsi_dh uinput sr_mod cdrom bnx2x ata_piix mdio serio_raw pcspkr rtc_cmos libata rtc_core rtc_lib bnx2 sg button joydev dcdbas dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod shpchp mptsas mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 1645, comm: kmpath_handlerd Tainted: G        W  2.6.32-next #33 PowerEdge T710
RIP: 0010:[<ffffffff81168581>]  [<ffffffff81168581>] cfq_put_request+0x28/0x66
RSP: 0018:ffff880128e4dc50  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8800ace10ea0 RCX: ffff880128ded1e0
RDX: 0000000000000001 RSI: ffff8800ace10ea0 RDI: ffff8800ace10ea0
RBP: ffff880128e4dc60 R08: ffff880128e4db90 R09: ffff880128ded218
R10: ffff880128e4dbe0 R11: ffffffff8115d3d9 R12: ffff880091b37ee0
R13: ffff8801124f3460 R14: 0000000000002000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88002f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000931000 CR3: 000000010f220000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kmpath_handlerd (pid: 1645, threadinfo ffff880128e4c000, task ffff880128decb40)
Stack:
 ffff8800ace10ea0 0000000001282c4f ffff880128e4dc70 ffffffff8115667d
<0> ffff880128e4dca0 ffffffff8115ce21 ffff8801124f3460 ffff8800ace10ea0
<0> 0000000000000282 ffff8801124f27f0 ffff880128e4dcd0 ffffffff8115d3e7
Call Trace:
 [<ffffffff8115667d>] elv_put_request+0x19/0x1b
 [<ffffffff8115ce21>] __blk_put_request+0x88/0xb9
 [<ffffffff8115d3e7>] blk_put_request+0x2e/0x46
 [<ffffffffa00206ed>] send_trespass_cmd+0x24e/0x260 [scsi_dh_emc]
 [<ffffffffa0020d9b>] clariion_activate+0x55/0x13e [scsi_dh_emc]
 [<ffffffff81062818>] ? trace_hardirqs_on_caller+0x113/0x13e
 [<ffffffffa0268cd7>] ? pg_init_done+0x0/0x187 [dm_multipath]
 [<ffffffffa01767ec>] scsi_dh_activate+0x70/0xbd [scsi_dh]
 [<ffffffffa0268cd7>] ? pg_init_done+0x0/0x187 [dm_multipath]
 [<ffffffffa026a4c1>] ? activate_path+0x0/0x2b [dm_multipath]
 [<ffffffffa026a4ea>] activate_path+0x29/0x2b [dm_multipath]
 [<ffffffff810519eb>] worker_thread+0x1af/0x2ae
 [<ffffffff81051992>] ? worker_thread+0x156/0x2ae
 [<ffffffff812f1a9a>] ? schedule+0x8e6/0x996
 [<ffffffff810549e4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8105183c>] ? worker_thread+0x0/0x2ae
 [<ffffffff810548eb>] kthread+0x7d/0x86
 [<ffffffff810038fa>] child_rip+0xa/0x20
 [<ffffffff812f487c>] ? restore_args+0x0/0x30
 [<ffffffff81179e0b>] ? debug_object_activate+0x38/0xd8
 [<ffffffff81058de1>] ? sched_clock_cpu+0x42/0xc7
 [<ffffffff8105486e>] ? kthread+0x0/0x86
 [<ffffffff810038f0>] ? child_rip+0x0/0x20
Code: 5c c9 c3 55 48 89 e5 41 54 53 4c 8b a7 a8 00 00 00 48 89 fb 4d 85 e4 74 4b 8b 47 48 83 e0 01 48 63 d0 41 8b 44 94 68 85 c0 75 04 <0f> 0b eb fe ff c8 41 89 44 94 68 48 8b 87 a0 00 00 00 48 8b 78
RIP  [<ffffffff81168581>] cfq_put_request+0x28/0x66
 RSP <ffff880128e4dc50>
---[ end trace fd0fef9ed4a171a1 ]---

Hugh Daschbach (1):
  Don't change direction flags in struct request.

 drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
