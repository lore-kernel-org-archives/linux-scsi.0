From: Ralf Gerbig <rge@quengel.org>
Subject: Re: 2.6.36 Crash/Panik in scsi_eh
Date: Tue, 02 Nov 2010 18:11:25 +0100
Message-ID: <87pqunwszm.fsf@gerlin1.hsp-law.de>
References: <87fwvkm215.fsf@gerlin1.hsp-law.de>
	<1288710413.3056.256.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288710413.3056.256.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 02 Nov 2010 11:06:53 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

* James Bottomley writes:

> cc linux-scsi added
> On Tue, 2010-11-02 at 11:51 +0100, Ralf Gerbig wrote:
>> Hi all,
>> 
>> .36 crashed on me twice. First time dead, no sysrq, nothing in the logs
>> after two days, the second time, a day later, with the following log.
>> 
>> The system ran 2.6.36-rc8-00045-g51ea8a8 before for 5 days without
>> trouble.
>> 
>> The IMHO only relevant patches between those kernels are appended below.
>> 
>> (gcc version 4.4.5 (Gentoo 4.4.5 p1.0, pie-0.4.5)
>> 
>> Thanks,
>> 
>> Ralf
>> 
>> Nov  2 10:40:57 gerlin1 kernel: [45977.557733] general protection fault: 0000 [#1] PREEMPT SMP 

> This looks like it's missing the fault address, but a GPF is a bit
> unusual, it means the kernel derefed a junk pointer (or a free'd one if
> you have memory debugging turned on).

not that I know of.

CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_SLUB_DEBUG=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_ACPI_DEBUG=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_USB_WUSB_CBAF_DEBUG=y
CONFIG_USB_SERIAL_DEBUG=m
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y

>> Nov  2 10:40:57 gerlin1 kernel: [45977.557859] last sysfs file: /sys/devices/virtual/sound/timer/uevent
>> Nov  2 10:40:57 gerlin1 kernel: [45977.557974] CPU 2 
>> Nov  2 10:40:57 gerlin1 kernel: [45977.558012] Modules linked in: xt_state xt_tcpudp ipt_REJECT iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_mangle iptable_filter ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip_tables x_tables tun nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs pppoe pppox ppp_generic slhc it87 hwmon_vid ipv6 snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device powernow_k8 mperf snd_hda_codec_atihdmi usbhid hid snd_hda_codec_realtek snd_hda_intel snd_hda_codec dst dvb_bt8xx dvb_core bt878 bttv ir_lirc_codec lirc_dev usb_storage ir_sony_decoder ir_jvc_decoder snd_hwdep snd_pcm r8169 snd_timer radeon ir_rc6_decoder v4l2_co
 mmon videodev v4l2_compat_ioctl32 videobuf_dma_sg avmfritz videobuf_core mISDNipac btcx_risc ir_common mISDN_core ir_rc5_decoder ttm drm_kms_helper i2c_piix4 ir_nec_decoder snd firewire_ohci ppdev cfbcopyarea cfbimgblt cfbfillrect processor soundcore ir_core mii firewire_core snd_page_alloc ehci_hcd parport_pc k10temp evdev xhci_hcd hwmon tveeprom ohci_hcd crc_itu_t parport wmi thermal button
>> Nov  2 10:40:57 gerlin1 kernel: [45977.560231] 
>> Nov  2 10:40:57 gerlin1 kernel: [45977.560265] Pid: 600, comm: scsi_eh_16 Not tainted 2.6.36 #6 GA-770TA-UD3/GA-770TA-UD3
>> Nov  2 10:40:57 gerlin1 kernel: [45977.560407] RIP: 0010:[<ffffffff811d2290>]  [<ffffffff811d2290>] scsi_dispatch_cmd+0x92/0x22e

> This is the faulting location ... could you run addr2line on this
> address to map it to a line of source code?

addr2line id only say ??:0

I recompiled vmlinux with debugging symbols, and gdb says:

Reading symbols from /usr/src/linux-git/linux-2.6/vmlinux...done.
(gdb) l *(scsi_dispatch_cmd + 0x92)
0xffffffff811d2290 is in scsi_dispatch_cmd (drivers/scsi/scsi.c:707).
702              * We will wait MIN_RESET_DELAY clock ticks after the
last reset so
703              * we can avoid the drive not being ready.
704              */
705             timeout = host->last_reset + MIN_RESET_DELAY;
706
707             if (host->resetting && time_before(jiffies, timeout)) {
708                     int ticks_remaining = timeout - jiffies;
709                     /*
710                      * NOTE: This may be executed from within an interrupt
711                      * handler!  This is bad, but for now, it'll do. The irq
(gdb) 

>> Nov  2 10:40:57 gerlin1 kernel: [45977.560572] RSP: 0018:ffff88022ffa3d00  EFLAGS: 00010202
>> Nov  2 10:40:57 gerlin1 kernel: [45977.560669] RAX: 0000000000000001 RBX: ffff8801f7c94700 RCX: ffff88017699dd10
>> Nov  2 10:40:57 gerlin1 kernel: [45977.560796] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff8801f7c94700
>> Nov  2 10:40:57 gerlin1 kernel: [45977.560924] RBP: ffff88022fee9800 R08: ffff88022fe42901 R09: ffff88022fe42848
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561051] R10: ffff88022ec21b18 R11: ffff88022fee9800 R12: 8000000000100038
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561179] R13: ffff88022fe42848 R14: ffff8801f7c94700 R15: ffff88017699dc30
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561308] FS:  00007f23ccdb1700(0000) GS:ffff880001900000(0000) knlGS:00000000f73ef6c0
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561452] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561556] CR2: 00007f4403f2f000 CR3: 000000022a603000 CR4: 00000000000006e0
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] Process scsi_eh_16 (pid: 600, threadinfo ffff88022ffa2000, task ffff88022fcd6450)
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] Stack:
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  ffff88022fe42948 ffff88022fe42800 ffff88022fee9800 ffff88022eeb0908
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] <0> ffff88022fe42848 ffffffff811d7a75 0000000000000000 ffffffff812d8825
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] <0> ffff88022fe42938 ffff88022eeb0c68 ffff88022ffa4150 ffff88022eeb0908
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] Call Trace:
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff811d7a75>] ? scsi_request_fn+0x35b/0x4a6
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff812d8825>] ? _raw_spin_unlock_irqrestore+0x20/0x2e
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff81121f58>] ? __blk_run_queue+0x37/0x68
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff8112202f>] ? blk_run_queue+0x20/0x32
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff811d719f>] ? scsi_run_queue+0x2db/0x375
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff811d82bc>] ? scsi_run_host_queues+0x1a/0x33
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff811d683b>] ? scsi_error_handler+0x59b/0x61e
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff811d62a0>] ? scsi_error_handler+0x0/0x61e
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff811d62a0>] ? scsi_error_handler+0x0/0x61e
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff81047e72>] ? kthread+0x7a/0x82
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff81002c94>] ? kernel_thread_helper+0x4/0x10
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff81047df8>] ? kthread+0x0/0x82
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] Code: e9 91 01 00 00 8a 82 a1 00 00 00 84 c0 74 1c 3c 03 7f 18 48 8b 4f 50 8b 92 84 00 00 00 8a 41 01 c1 e2 05 83 e0 1f 09 d0 88 41 01 <41> 83 bc 24 e0 00 00 00 00 49 8b ac 24 e8 00 00 00 74 38 48 8b 
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634] RIP  [<ffffffff811d2290>] scsi_dispatch_cmd+0x92/0x22e
>> Nov  2 10:40:57 gerlin1 kernel: [45977.561634]  RSP <ffff88022ffa3d00>
>> Nov  2 10:40:57 gerlin1 kernel: [45977.607776] ---[ end trace 3ac2996f7ba1d17f ]---

> So you're right, the following are the only two commits.  However
> neither of them touches anything remotely connected to the area where
> the fault is.

thats what I feared.

Thanks,

Ralf
