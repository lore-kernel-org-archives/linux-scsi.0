From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux 2.6.37-rc1 (scsi_debug: list corruption)
Date: Wed, 3 Nov 2010 16:20:15 -0700
Message-ID: <20101103162015.99475a0b.randy.dunlap@oracle.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, scsi <linux-scsi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



[  102.555847] calling  scsi_debug_init+0x0/0x704 [scsi_debug] @ 3337
Nov  3 16:06:12 control kernel: [  102.555847] calling  scsi_deb[  102.622974] scsi_debug: host protection
[  102.627513] scsi4 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
Nov  3 16:06:13 control kernel: [  102.639095] initcall scsi_debug_init+0x0/0x704 [scsi_debug] returned 0 after 75039 usecs
Nov  3 16:06:13 [  102.651072] ------------[ cut here ]------------
[  102.657373] WARNING: at /local/linsrc/lnx-2637-rc1/lib/list_debug.c:26 __list_add+0x4d/0xa5()
[  102.666012] Hardware name: OptiPlex GX620               
[  102.671396] list_add corruption. next->prev should be prev (ffffffff81ae5e50), but was 6b6b6b6b6b6b6b6b. (next=ffff88006c880590).
[  102.683509] Modules linked in: scsi_debug ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device usbkbd snd_pcm usbmouse led_class snd_timer usbhid iTCO_wdt hid tg3 snd sr_mod iTCO_vendor_support dcdbas cdrom pcspkr i2c_i801 sg soundcore rtc_cmos parport_pc rng_core evdev snd_page_alloc shpchp rtc_core parport rtc_lib
  mac_hid 8250_pnp pci_hotplug unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_clas!
 s ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[  102.787884] Pid: 3349, comm: scsi_scan_4 Not tainted 2.6.37-rc1 #10
[  102.794602] Call Trace:
[  102.797152]  [<ffffffff8107e1ed>] warn_slowpath_common+0xc6/0xf3
[  102.803270]  [<ffffffff812d3582>] ? __percpu_counter_init+0x9e/0xdf
[  102.809973]  [<ffffffff8107e30a>] warn_slowpath_fmt+0x5b/0x6b
[  102.815846]  [<ffffffff812cf38b>] __list_add+0x4d/0xa5
Nov  3 16:06:13 [  102.821109]  [<ffffffff812d359f>] __percpu_counter_init+0xbb/0xdf
control kernel: [  102.829046]  [<ffffffff8117c577>] bdi_init+0x13f/0x1c2
[  102.651072] -[  102.835171]  [<ffffffff81411c7c>] ? scsi_request_fn+0x0/0x6f4
-----------[ cut[  102.842260]  [<ffffffff81411c7c>] ? scsi_request_fn+0x0/0x6f4
 here ]---------[  102.849903]  [<ffffffff812a7444>] blk_alloc_queue_node+0x8f/0x220
---
Nov  3 16:06[  102.856915]  [<ffffffff812a773b>] blk_init_queue_node+0x30/0x90
:13 control kern[  102.864592]  [<ffffffff812a77b3>] blk_init_queue+0x18/0x21
el: [  102.65737[  102.871037]  [<ffffffff8141239d>] __scsi_alloc_queue+0x2d/0x207
[  102.878377]  [<ffffffff8141259b>] scsi_alloc_queue+0x24/0x9c
Nov  3 16:06:13 [  102.884579]  [<ffffffff81414f27>] scsi_alloc_sdev+0x1de/0x31d
control kernel: [  102.891302]  [<ffffffff814162bb>] scsi_probe_and_add_lun+0x191/0x615
[  102.671396] l[  102.899044]  [<ffffffff813f9cde>] ? attribute_container_add_device+0x258/0x26e
ist_add corrupti[  102.908167]  [<ffffffff813eedda>] ? get_device+0x1e/0x36
on. next->prev s[  102.914335]  [<ffffffff81414c3b>] ? scsi_alloc_target+0x2d9/0x33e
hould be prev (f[  102.922209]  [<ffffffff814173c5>] ? scsi_scan_host_selected+0xec/0x1a7
fffffff81ae5e50)[  102.929769]  [<ffffffff814173c5>] ? scsi_scan_host_selected+0xec/0x1a7
, but was 6b6b6b[  102.938062]  [<ffffffff8141708b>] __scsi_scan_target+0xbe/0x25c
6b6b6b6b6b. (nex[  102.944996]  [<ffffffff8141729c>] scsi_scan_channel+0x73/0xb0
t=ffff88006c8805[  102.952467]  [<ffffffff8141742b>] scsi_scan_host_selected+0x152/0x1a7
90).
Nov  3 16:0[  102.959976]  [<fffffff141752d>] ? do_scan_async+0x0/0x3d
6:13 control ker[  102.966801]  [<ffffffff81417521>] do_scsi_scan_host+0xa1/0xad
nel: [  102.683509] Modules linked in: scsi_debu[  102.976609]  [<ffffffff8141754e>] do_scan_async+0x21/0x3d
g ipt_MASQUERADE iptable_nat nf_[  102.985889]  [<ffffffff8141752d>] ? do_scan_async+0x0/0x3d
nat af_packet nfsd lockd nfs_acl auth_rpcgss exp[  102.994412]  [<ffffffff810a77f6>] kthread+0xc3/0xd2
ortfs sco bridge stp llc bnep l2[  103.003098]  [<ffffffff8113785d>] ? trace_hardirqs_on_caller+0x18/0x48
Nov  3 16:06:13 control kernel: [  103.003098]  [  103.012765]  [<ffffffff8100f904>] kernel_thread_helper+0x4/0x10
[<ffffffff8113785d>] ? trace_har[  103.022542]  [<ffffffff81551210>] ? restore_args+0x0/0x30
dirqs_on_caller+0x18/0x48
Nov  3 16:06:13 contro[  103.031013]  [<ffffffff810a7733>] ? kthread+0x0/0xd2
l kernel: [  103.012765]  [<ffff[  103.039803]  [<ffffffff8100f900>] ? kernel_thread_helper+0x0/0x10
ffff8100f904>] kernel_thread_helper+0x4/0x10
Nov[  103.048967] ---[ end trace 0acaa11d0c3e9c22 ]---
  3 16:06:13 control kernel: [  103.022542]  [<ffffffff81551210>] ? restore_args+0x0/0x30
Nov  3 16:06:13 control kernel: [  103.031013]  [<ffffffff810a7733>] ? kthread+0x0/0xd[  103.070125] scsi 4:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
2
Nov  3 16:06:13 control kernel: [  103.039803]  [<ffffffff8100f900>] ? kernel_thread_helper+0x0/0x10
Nov  3 16:06:13 control kernel: [  103.048967] ---[ end trace 0acaa11d0c3e9c22 ]---
Nov  3 16:06:13 control kernel: [  103.070125] scsi 4:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[  103.110940] sd 4:0:0:0: Attached scsi generic sg2 type 0
Nov  3 16:06:13 control kernel: [  103.110940] sd 4:0:0:0: Attached scsi generic[  103.125754] sd 4:0:0:0: [sdb] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB)
 sg2 type 0
Nov  3 16:06:13 [  103.164255] sd 4:0:0:0: [sdb] Write Protect is off
[  103.171863] sd 4:0:0:0: [sdb] Mode Sense: 73 00 10 08
Nov  3 16:06:13 control kernel: Nov  3 16:06:13 control kernel: [  103.224509] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
Nov  3 16:06:13 control kernel: [  103.224509] sd 4:0:0:0: [sdb] Write cache: en[  103.284456]  sdb: unknown partition table
Nov  3 16:06:13 control kernel: [  103.284456]  sdb: unknown par[  103.308541] sd 4:0:0:0: [sdb] Attached SCSI disk
Nov  3 16:06:13 control kernel: [  103.308541] sd 4:0:0:0: [sdb]


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
