From: Thomas Gleixner <tglx@linutronix.de>
Subject: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
 scsi-sgpool)objects
Date: Tue, 3 Mar 2009 23:07:14 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>  <49ACF8FE.2020904@panasas.com>  <1236093718.3263.3.camel@localhost.localdomain>  <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain>
 <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:56586 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbZCCWHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 17:07:33 -0500
In-Reply-To: <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, 3 Mar 2009, Thomas Gleixner wrote:
> My bad. I was playing with that to get rid of the aic7xxx wreckage on
> one of my test boxen and forgot to remove it.

While the one below is definitey not my fault. It's on Linus latest:

 commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66

While compiling a kernel I triggerred the BUG below. Not so nice as it
took a whole filesystem with it. fsck took more than 20 min to recover
the leftovers :(

Thanks,

	tglx


------------[ cut here ]------------
kernel BUG at /home/tglx/work/kernel/git/linux-2.6/drivers/scsi/scsi_lib.c:1141!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:03:00.0/irq
CPU 0 
Modules linked in: ext2 ipt_MASQUERADE iptable_nat nf_nat bridge stp autofs4 coretemp lm85 hwmon_vid hwmon nfs lockd nfs_acl auth_rpcgss fuse sunrpc 8139too mii ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT ip6t_ipv6header xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath dm_mod raid0 kvm_intel kvm uinput snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd ppdev i2c_i801 firewire_ohci soundcore parport_pc i82975x_edac e1000e firewire_core snd_page_alloc i2c_core iTCO_wdt sr_mod edac_core parport sg floppy crc_itu_t iTCO_vendor_support pcspkr serio_raw c
 drom ata_piix sata_sil ahci libata sd_mod scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
Pid: 16556, comm: cc1 Not tainted 2.6.29-rc6 #155         
RIP: 0010:[<ffffffffa00ad30b>]  [<ffffffffa00ad30b>] scsi_init_sgtable+0x51/0x9f [scsi_mod]
RSP: 0000:ffffffff8163cb40  EFLAGS: 00010002
RAX: 000000000000002d RBX: ffff88004b7a3590 RCX: 00000000ffffffff
RDX: 000000000000000b RSI: ffff880034b4d0a0 RDI: 0000000000002000
RBP: ffffffff8163cb50 R08: ffff880001017b50 R09: ffffffff8163cb90
R10: ffff88007d281000 R11: 0000000000000000 R12: ffff88003b323c58
R13: 00000000082b73a7 R14: ffffffff8163cc48 R15: 00000000000003f0
FS:  00007fe47f3ea6f0(0000) GS:ffffffff81645080(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe47a37f000 CR3: 00000000443a8000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 16556, threadinfo ffff88001c332000, task ffff880008398000)
Stack:
 ffff88003b323c00 ffff88007d281000 ffffffff8163cb70 ffffffffa00ad550
 ffff88004b7a3590 ffff88007d281000 ffffffff8163cba0 ffffffffa00ad6b1
 ffff88007d1f1410 ffff88007d1f0000 ffff88004b7a3590 ffff88007d281000
Call Trace:
 <IRQ> <0> [<ffffffffa00ad550>] scsi_init_io+0x1f/0xc9 [scsi_mod]
 [<ffffffffa00ad6b1>] scsi_setup_fs_cmnd+0xb7/0xbf [scsi_mod]
 [<ffffffffa00d5175>] sd_prep_fn+0x65/0x81c [sd_mod]
 [<ffffffffa00a768c>] ? scsi_done+0x0/0x12 [scsi_mod]
 [<ffffffffa00a768c>] ? scsi_done+0x0/0x12 [scsi_mod]
 [<ffffffff8114345e>] elv_next_request+0xd7/0x19e
 [<ffffffffa00acc45>] scsi_request_fn+0x90/0x4cf [scsi_mod]
 [<ffffffff81144e86>] blk_invoke_request_fn+0x75/0x14a
 [<ffffffff8114547a>] __blk_run_queue+0x25/0x29
 [<ffffffff8114549f>] blk_run_queue+0x21/0x35
 [<ffffffffa00ac4f3>] scsi_run_queue+0x2e3/0x37d [scsi_mod]
 [<ffffffffa00ad2aa>] scsi_next_command+0x36/0x46 [scsi_mod]
 [<ffffffffa00addd7>] scsi_io_completion+0x3df/0x423 [scsi_mod]
 [<ffffffffa00df3ad>] ? __ata_qc_complete+0xc0/0xc9 [libata]
 [<ffffffffa00e1011>] ? ata_qc_complete+0x1ea/0x1f3 [libata]
 [<ffffffffa00a7683>] scsi_finish_command+0xe9/0xf2 [scsi_mod]
 [<ffffffffa00adf45>] scsi_softirq_done+0x11a/0x123 [scsi_mod]
 [<ffffffff81149275>] blk_done_softirq+0x69/0x79
 [<ffffffff810412b7>] __do_softirq+0x83/0x144
 [<ffffffff8100d23c>] call_softirq+0x1c/0x28
 [<ffffffff8100e17c>] do_softirq+0x34/0x76
 [<ffffffff81040fd1>] irq_exit+0x3f/0x79
 [<ffffffff8100e43f>] do_IRQ+0x130/0x155
 [<ffffffff8100cb13>] ret_from_intr+0x0/0xa
 <EOI> <0>Code: 80 00 00 00 4c 89 e7 e8 0a 0d 0b e1 85 c0 74 45 48 c7 c2 59 d3 0a a0 be 80 00 00 00 4c 89 e7 e8 78 09 0b e1 b8 02 00 00 00 eb 25 <0f> 0b eb fe 41 89 44 24 08 83 7b 4c 02 75 08 8b 83 18 01 00 00 
RIP  [<ffffffffa00ad30b>] scsi_init_sgtable+0x51/0x9f [scsi_mod]
 RSP <ffffffff8163cb40>
---[ end trace 1b0175d9b3d81293 ]---
