From: Andrew Morton <akpm@linux-foundation.org>
Subject: ata/scsi crash on halt
Date: Sat, 12 May 2007 11:25:37 -0700
Message-ID: <20070512112537.4981f82d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This is current mainline plus a few patches which I've just sent to Linus:

loop_probe-fix-return-value.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
ntfs-use-zero_user_page.patch
tty-flush-flip-buffer-on-ldisc-input-queue-flush.patch
missing-include-file-in-tpm_atmelh.patch
maintainers-remove-invalid-list-address-for-tpm.patch
ipmi-fix-si-address-space-settings.patch
ipmi-add-ppc-openfirmware-unregister.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
slub-i386-support.patch

I did a `halt -pfn' on the Vaio.

[   48.356000] ipw2200: Failed to send WEP_KEY: Aborted due to RF kill switch.
[   50.304000] ipw2200: Failed to send WEP_KEY: Command timed out.
[   52.452000] ipw2200: Failed to send WEP_KEY: Command timed out.
[  715.196000] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  715.196000] sd 2:0:0:0: [sda] Stopping disk
[  715.196000] ata3.00: DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE SHUTDOWN UTILITY
[  715.196000] ata3.00: For more info, visit http://linux-ata.org/shutdown.html
[  715.196000] BUG: scheduling while atomic: swapper/0x00000100/0
[  715.196000]  [<c02e282d>] __sched_text_start+0x55/0x504
[  715.196000]  [<c0239faa>] scsi_done+0x0/0x1d
[  715.196000]  [<c02e32fb>] schedule_timeout+0x78/0x95
[  715.196000]  [<c011ffc2>] process_timeout+0x0/0x5
[  715.196000]  [<c011ff87>] msleep+0x10/0x18
[  715.196000]  [<c024d455>] ata_scsi_start_stop_xlat+0xe3/0x11b
[  715.196000]  [<c024d73f>] ata_scsi_translate+0xeb/0x150
[  715.196000]  [<c0239faa>] scsi_done+0x0/0x1d
[  715.196000]  [<c024f553>] ata_scsi_queuecmd+0x100/0x107
[  715.196000]  [<c024d372>] ata_scsi_start_stop_xlat+0x0/0x11b
[  715.196000]  [<c023a6f0>] scsi_dispatch_cmd+0x1b3/0x228
[  715.196000]  [<c023f451>] scsi_request_fn+0x250/0x2c2
[  715.196000]  [<c01be182>] blk_run_queue+0x2d/0x4f
[  715.196000]  [<c023e1c4>] scsi_next_command+0x25/0x2f
[  715.196000]  [<c023e349>] scsi_end_request+0x8f/0x9b
[  715.196000]  [<c023e4de>] scsi_io_completion+0x147/0x353
[  715.196000]  [<c02440e6>] sd_rw_intr+0x2df/0x311
[  715.196000]  [<c0249055>] ata_hsm_move+0x6f3/0x703
[  715.196000]  [<c0239f6a>] scsi_finish_command+0x7e/0x85
[  715.196000]  [<c011ffc2>] process_timeout+0x0/0x5
[  715.196000]  [<c01be0ad>] blk_done_softirq+0x4f/0x60
[  715.196000]  [<c011d51d>] __do_softirq+0x35/0x75
[  715.200000]  [<c011d582>] do_softirq+0x25/0x2b
[  715.200000]  [<c0105dc8>] do_IRQ+0x58/0x6c
[  715.200000]  [<c01044df>] common_interrupt+0x23/0x28
[  715.200000]  [<c0120000>] do_timer+0x30/0xa9
[  715.200000]  [<c0209671>] acpi_processor_idle+0x1d2/0x375
[  715.200000]  [<c0102336>] cpu_idle+0x42/0x57
[  715.200000]  [<c03b4a53>] start_kernel+0x263/0x26b
[  715.200000]  [<c03b43d7>] unknown_bootoption+0x0/0x202
[  715.200000]  =======================
[  715.200000] bad: scheduling from the idle thread!
[  715.200000]  [<c02e286d>] __sched_text_start+0x95/0x504
[  715.200000]  [<c0239faa>] scsi_done+0x0/0x1d
[  715.200000]  [<c02e32fb>] schedule_timeout+0x78/0x95
[  715.200000]  [<c011ffc2>] process_timeout+0x0/0x5
[  715.204000]  [<c011ff87>] msleep+0x10/0x18
[  715.208000]  [<c024d455>] ata_scsi_start_stop_xlat+0xe3/0x11b
[  715.212000]  [<c024d73f>] ata_scsi_translate+0xeb/0x150
[  715.216000]  [<c0239faa>] scsi_done+0x0/0x1d
[  715.220000]  [<c024f553>] ata_scsi_queuecmd+0x100/0x107
[  715.224000]  [<c024d372>] ata_scsi_start_stop_xlat+0x0/0x11b
[  715.228000]  [<c023a6f0>] scsi_dispatch_cmd+0x1b3/0x228
[  715.228000]  [<c023f451>] scsi_request_fn+0x250/0x2c2
[  715.232000]  [<c01be182>] blk_run_queue+0x2d/0x4f
[  715.236000]  [<c023e1c4>] scsi_next_command+0x25/0x2f
[  715.240000]  [<c023e349>] scsi_end_request+0x8f/0x9b
[  715.244000]  [<c023e4de>] scsi_io_completion+0x147/0x353
[  715.248000]  [<c02440e6>] sd_rw_intr+0x2df/0x311
[  715.252000]  [<c0249055>] ata_hsm_move+0x6f3/0x703
[  715.256000]  [<c0239f6a>] scsi_finish_command+0x7e/0x85
[  715.260000]  [<c011ffc2>] process_timeout+0x0/0x5
[  715.264000]  [<c01be0ad>] blk_done_softirq+0x4f/0x60
[  715.264000]  [<c011d51d>] __do_softirq+0x35/0x75
[  715.268000]  [<c011d582>] do_softirq+0x25/0x2b
[[  715.272000]  [<c0105dc8>] do_IRQ+0x58/0x6c
[  715.276000]  [<c01044df>] common_interrupt+0x23/0x28
[  715.280000]  [<c0120000>] do_timer+0x30/0xa9
[  715.284000]  [<c0209671>] acpi_processor_idle+0x1d2/0x375
[  715.288000]  [<c0102336>] cpu_idle+0x42/0x57
[  715.292000]  [<c03b4a53>] start_kernel+0x263/0x26b
[  715.292000]  [<c03b43d7>] unknown_bootoption+0x0/0x202
[  715.296000]  =======================
[  715.300000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  715.300000]  printing eip:
[  715.300000] c011654e
[  715.300000] *pde = 00000000
[  715.300000] Oops: 0002 [#1]
[  715.300000] Modules linked in: ipw2200 sonypi ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand video sbs button battery asus_acpi ac nvram ohci1394 ieee1394 ehci_hcd sg uhci_hcd joydev snd_hda_intel snd_seq_dummy sr_mod snd_seq_oss snd_seq_midi_event ieee80211 snd_seq cdrom snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm ieee80211_crypt snd_timer snd soundcore piix i2c_i801 snd_page_alloc i2c_core generic ext3 jbd ide_disk ide_core
[  715.300000] CPU:    0
[  715.300000] EIP:    0060:[<c011654e>]    Not tainted VLI
[  715.300000] EFLAGS: 00010002   (2.6.21 #16)
[  715.300000] EIP is at dequeue_task+0x7/0x38
[  715.300000] eax: c0385280   ebx: c0385280   ecx: 000000fa   edx: 00000000
[  715.300000] esi: 00000000   edi: 000000a6   ebp: c03b3c64   esp: c03b3c5c
[  715.300000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[  715.300000] Process swapper (pid: 0, ti=c03b2000 task=c0385280 task.ti=c03b2000)
[  715.300000] Stack: c0385280 8500e700 c03b3c70 c01165c5 c0385280 c03b3cc0 c02e2945 c033a09e 
[  715.300000]        c0385428 00000100 00000000 000002cb 00000001 8b33d100 000000a6 0632ea00 
[  715.300000]        c03853a0 00019a5a 00000286 c03b3d08 343c0000 20205b3e 00019a5a c03b3ce4 
[  715.300000] Call Trace:
[  715.300000]  [<c01165c5>] deactivate_task+0x18/0x22
[  715.300000]  [<c02e2945>] __sched_text_start+0x16d/0x504
[  715.300000]  [<c0239faa>] scsi_done+0x0/0x1d
[  715.300000]  [<c02e32fb>] schedule_timeout+0x78/0x95
[  715.300000]  [<c011ffc2>] process_timeout+0x0/0x5
[  715.300000]  [<c011ff87>] msleep+0x10/0x18
[  715.300000]  [<c024d455>] ata_scsi_start_stop_xlat+0xe3/0x11b
[  715.300000]  [<c024d73f>] ata_scsi_translate+0xeb/0x150
[  715.300000]  [<c0239faa>] scsi_done+0x0/0x1d
[  715.300000]  [<c024f553>] ata_scsi_queuecmd+0x100/0x107
[  715.300000]  [<c024d372>] ata_scsi_start_stop_xlat+0x0/0x11b
[  715.300000]  [<c023a6f0>] scsi_dispatch_cmd+0x1b3/0x228
[  715.300000]  [<c023f451>] scsi_request_fn+0x250/0x2c2
[  715.300000]  [<c01be182>] blk_run_queue+0x2d/0x4f
[  715.300000]  [<c023e1c4>] scsi_next_command+0x25/0x2f
[  715.300000]  [<c023e349>] scsi_end_request+0x8f/0x9b
[  715.300000]  [<c023e4de>] scsi_io_completion+0x147/0x353
[  715.300000]  [<c02440e6>] sd_rw_intr+0x2df/0x311
[  715.300000]  [<c0249055>] ata_hsm_move+0x6f3/0x703
[  715.300000]  [<c0239f6a>] scsi_finish_command+0x7e/0x85
[  715.300000]  [<c011ffc2>] process_timeout+0x0/0x5
[  715.300000]  [<c01be0ad>] blk_done_softirq+0x4f/0x60
[  715.300000]  [<c011d51d>] __do_softirq+0x35/0x75
[  715.300000]  [<c011d582>] do_softirq+0x25/0x2b
[  715.300000]  [<c0105dc8>] do_IRQ+0x58/0x6c
[  715.300000]  [<c01044df>] common_interrupt+0x23/0x28
[  715.300000]  [<c0120000>] do_timer+0x30/0xa9
[  715.300000]  [<c0209671>] acpi_processor_idle+0x1d2/0x375
[  715.300000]  [<c0102336>] cpu_idle+0x42/0x57
[  715.300000]  [<c03b4a53>] start_kernel+0x263/0x26b
[  715.300000]  [<c03b43d7>] unknown_bootoption+0x0/0x202
[  715.300000]  =======================
[  715.300000] Code: eb 1e b8 8c 00 00 00 29 d0 ba 14 00 00 00 6b c0 19 89 d1 99 f7 f9 ba 01 00 00 00 85 c0 0f 4f d0 5d 89 d0 c3 55 89 e5 56 89 d6 53 <ff> 0a 8d 58 28 8b 48 28 8b 53 04 89 0a 89 51 04 c7 43 04 00 02 
[  715.300000] EIP: [<c011654e>] dequeue_task+0x7/0x38 SS:ESP 0068:c03b3c5c
[  715.300000] Kernel panic - not syncing: Fatal exception in interrupt


I tried repeating it and I got the initial scheduling-while-atomic spew but
no oops this time.

