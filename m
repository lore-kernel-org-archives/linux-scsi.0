From: "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>
Subject: General protection fault with use_blk_mq=1.
Date: Wed, 28 Mar 2018 16:03:09 -0700
Message-ID: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I am not subscribed to any of the lists on the To list here, please CC
me on any replies.

I am encountering a fairly consistent crash anywhere from 15 minutes to
12 hours after boot with scsi_mod.use_blk_mq=1 dm_mod.use_blk_mq=1

The crash looks like:

[ 5466.075993] general protection fault: 0000 [#1] PREEMPT SMP PTI
[ 5466.075997] Modules linked in: esp4 xfrm4_mode_tunnel fuse usblp
uvcvideo pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack iptable_filter ip_tables x_tables intel_rapl
joydev serio_raw wmi_bmof iwldvm iwlwifi shpchp kvm_intel kvm irqbypass
autofs4 algif_skcipher nls_iso8859_1 nls_cp437 crc32_pclmul
ghash_clmulni_intel
[ 5466.076022] CPU: 3 PID: 10573 Comm: pool Tainted: G           O    
4.15.13-f1-dirty #148
[ 5466.076024] Hardware name: Hewlett-Packard HP EliteBook Folio
9470m/18DF, BIOS 68IBD Ver. F.44 05/22/2013
[ 5466.076029] RIP: 0010:percpu_counter_add_batch+0x2b/0xb0
[ 5466.076031] RSP: 0018:ffffa556c47afb58 EFLAGS: 00010002
[ 5466.076033] RAX: ffff95cda87ce018 RBX: ffff95cda87cdb68 RCX:
0000000000000000
[ 5466.076034] RDX: 000000003fffffff RSI: ffffffff896495c4 RDI:
ffffffff895b2bed
[ 5466.076036] RBP: 000000003fffffff R08: 0000000000000000 R09:
ffff95cb7d5f8148
[ 5466.076037] R10: 0000000000000200 R11: 0000000000000000 R12:
0000000000000001
[ 5466.076038] R13: ffff95cda87ce088 R14: ffff95cda6ebd100 R15:
ffffa556c47afc58
[ 5466.076040] FS:  00007f25f5305700(0000) GS:ffff95cdbeac0000(0000)
knlGS:0000000000000000
[ 5466.076042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5466.076043] CR2: 00007f25e807e0a8 CR3: 00000003ed5a6001 CR4:
00000000001606e0
[ 5466.076044] Call Trace:
[ 5466.076050]  bfqg_stats_update_io_add+0x58/0x100
[ 5466.076055]  bfq_insert_requests+0xec/0xd80
[ 5466.076059]  ? blk_rq_append_bio+0x8f/0xa0
[ 5466.076061]  ? blk_rq_map_user_iov+0xc3/0x1d0
[ 5466.076065]  blk_mq_sched_insert_request+0xa3/0x130
[ 5466.076068]  blk_execute_rq+0x3a/0x50
[ 5466.076070]  sg_io+0x197/0x3e0
[ 5466.076073]  ? dput+0xca/0x210
[ 5466.076077]  ? mntput_no_expire+0x11/0x1a0
[ 5466.076079]  scsi_cmd_ioctl+0x289/0x400
[ 5466.076082]  ? filename_lookup+0xe1/0x170
[ 5466.076085]  sd_ioctl+0xc7/0x1a0
[ 5466.076088]  blkdev_ioctl+0x4d4/0x8c0
[ 5466.076091]  block_ioctl+0x39/0x40
[ 5466.076094]  do_vfs_ioctl+0x92/0x5e0
[ 5466.076097]  ? __fget+0x73/0xc0
[ 5466.076099]  SyS_ioctl+0x74/0x80
[ 5466.076102]  do_syscall_64+0x60/0x110
[ 5466.076106]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[ 5466.076109] RIP: 0033:0x7f25f75fef47
[ 5466.076110] RSP: 002b:00007f25f53049a8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 5466.076112] RAX: ffffffffffffffda RBX: 000000000000000c RCX:
00007f25f75fef47
[ 5466.076114] RDX: 00007f25f53049b0 RSI: 0000000000002285 RDI:
000000000000000c
[ 5466.076115] RBP: 0000000000000010 R08: 00007f25e8007818 R09:
0000000000000200
[ 5466.076116] R10: 0000000000000001 R11: 0000000000000246 R12:
0000000000000000
[ 5466.076118] R13: 0000000000000000 R14: 00007f25f8a6b5e0 R15:
00007f25e80173e0
[ 5466.076120] Code: 41 55 49 89 fd bf 01 00 00 00 41 54 49 89 f4 55 89
d5 53 e8 18 e1 bb ff 48 c7 c7 c4 95 64 89 e8 dc e9 fb ff 49 8b 45 20 48
63 d5 <65> 8b 18 48 63 db 4c 01 e3 48 39 d3 7d 0a f7 dd 48 63 ed 48 39
[ 5466.076147] RIP: percpu_counter_add_batch+0x2b/0xb0 RSP: ffffa556c47afb58
[ 5466.076149] ---[ end trace 8d7eb80aafef4494 ]---
[ 5466.670153] note: pool[10573] exited with preempt_count 2

(I only have the one instance right this minute as a result of not
having remote syslog setup before now.)

This is clearly deep in the blk_mq code, and it goes away when I remove
the use_blk_mq kernel command line parameters.

My next obvious step is to try and disable the load of the vbox modules.

I can include the full dmesg output if it would be helpful.

The system is an older HP Ultrabook, and the root partition is, sda1 (a
SSD) -> a LUKS encrypted partition -> LVM -> BTRFS.

The kernel is a stock 4.15.11, however I only recently added the blk_mq
options, so while I can state that I have seen this on multiple kernels
in the 4.15.x series, I have not tested earlier kernels in this
configuration.

Looking through the code, I'd guess that this is dying inside
blkg_rwstat_add, which calls percpu_counter_add_batch, which is what RIP
is pointing at.

Regards,
Zephaniah E. Loss-Cutler-Hull.
