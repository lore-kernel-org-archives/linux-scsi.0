From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Thu, 19 Jun 2014 09:02:57 +0200
Message-ID: <53A28B21.7070500@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:35395 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaFSHI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 03:08:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>, Lars Ellenberg <lars.ellenberg@linbit.com>

Hi,

while using vanilla 3.10.44 with drbd on top of a md raid1.

I'm pretty often hitting the followin kernel bug.

It reminds me of:
http://lists.openwall.net/linux-kernel/2014/02/19/428

But i don't use bcache.

[sched_delayed] sched: RT throttling activated
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8128105c>] blk_add_request_payload+0xc/0x90
PGD 0
Oops: 0002 [#1] SMP
Modules linked in: vhost_net tun macvtap macvlan dlm sctp netconsole
drbd lru_cache xt_multiport iptable_filter ip_tables x_tables iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi nfsd auth_rpcgss oid_registry
bonding ext2 8021q garp fuse acpi_cpufreq mperf coretemp kvm_intel kvm
microcode i2c_i801 i7core_edac edac_core button dm_mod raid1 md_mod
usb_storage ohci_hcd usbhid sg sd_mod uhci_hcd ehci_pci ehci_hcd ahci
libahci usbcore ixgbe(O) usb_common igb i2c_algo_bit mpt2sas i2c_core
raid_class ptp scsi_transport_sas pps_core
CPU: 0 PID: 636 Comm: md124_raid1 Tainted: G O 3.10.41+76-ph #1
Hardware name: Supermicro X8DT3/X8DT3, BIOS 2.1 03/17/2012
task: ffff880811e16400 ti: ffff88081324c000 task.ti: ffff88081324c000
RIP: 0010:[<ffffffff8128105c>] [<ffffffff8128105c>]
blk_add_request_payload+0xc/0x90
RSP: 0018:ffff88081324dac8 EFLAGS: 00010086
RAX: ffff88080b686b40 RBX: ffff88080af19028 RCX: 0000000000000000
RDX: 0000000000000018 RSI: ffffea00202b7200 RDI: ffff88080af19028
RBP: ffff88081324dac8 R08: ffffea00202b7200 R09: 00000000006f4a62
R10: 000000000000243d R11: 0000000000000000 R12: ffff8808145b9400
R13: ffff8810139a6000 R14: 0000000004400000 R15: ffff88080adc8000
FS: 0000000000000000(0000) GS:ffff88081fc00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a0b000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400Stack:
ffff88081324db18 ffffffffa01b515f ffffea00202b7200 000000000b637800
ffff88081324db18 ffff88080af19028 ffff880812f18818 ffff88081324dca8
ffff8810139a6000 ffff8808145b9800 ffff88081324db88 ffffffffa01b5318
Call Trace:
[<ffffffffa01b515f>] sd_setup_discard_cmnd+0x13f/0x260 [sd_mod]
[<ffffffffa01b5318>] sd_prep_fn+0x98/0xbb0 [sd_mod]
[<ffffffff812b1750>] ? merge+0x50/0xa0
[<ffffffff81281180>] ? blk_start_plug+0x50/0x50
[<ffffffff81286eb2>] blk_peek_request+0x132/0x250
[<ffffffff8138ae96>] scsi_request_fn+0x46/0x520
[<ffffffff81285a62>] __blk_run_queue+0x32/0x40
[<ffffffff81285b34>] queue_unplugged+0x34/0xb0
[<ffffffff81287343>] blk_flush_plug_list+0x183/0x220
[<ffffffff812873f3>] blk_finish_plug+0x13/0x50
[<ffffffffa008ac56>] raid1d+0x706/0xee0 [raid1]
[<ffffffff81057ada>] ? try_to_del_timer_sync+0x4a/0x60
[<ffffffff81057b42>] ? del_timer_sync+0x52/0x60
[<ffffffff81056e10>] ? usleep_range+0x40/0x40
[<ffffffffa00d5abd>] md_thread+0x11d/0x170 [md_mod]
[<ffffffff8106ca20>] ? finish_wait+0x80/0x80


Stefan
