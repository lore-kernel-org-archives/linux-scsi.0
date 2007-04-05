From: Andrew Burgess <aab@cichlid.com>
Subject: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10
Date: Thu, 5 Apr 2007 09:45:11 -0700
Message-ID: <200704051645.l35GjB1p014806@cichlid.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl-63-249-106-23.cruzio.com ([63.249.106.23]:33998 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXDEQwm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2007 12:52:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: aab@cichlid.com

The machine is x86_64 SMP. I also got the oops in the Fedora kernels: 
2.6.20-1.2933.fc6 and 2.6.20-1.3017.fc7. The system isn't locked solid but 
it seems anything touching the scsi disks hangs. I also twice got this early 
in the boot and it stopped booting.

Anything I can do to help just ask.

The backtrace claims my kernel is tainted due to a machine check execption
but I can find no message in the logs using 'egrep -i 'mce|machine|check|exception'. 
It only claims the kernels that I compile are tainted, not the Fedora ones.

root@athlon:log # (zcat messages.2.gz messages.1.gz ; cat messages)|grep -i taint
Mar 28 02:38:48 cichlid kernel: Pid: 393, comm: scsi_eh_0 Not tainted 2.6.20-1.2933.fc6 #1
Mar 28 02:38:55 cichlid kernel: Pid: 395, comm: scsi_eh_2 Not tainted 2.6.20-1.2933.fc6 #1
Mar 28 08:56:05 cichlid kernel: Pid: 384, comm: scsi_eh_4 Not tainted 2.6.20-1.3017.fc7 #1
Apr  1 00:30:18 cichlid kernel: Pid: 386, comm: scsi_eh_1 Tainted: G   M   2.6.21-rc5-git6-1 #1
Apr  2 15:51:24 cichlid kernel: Pid: 386, comm: scsi_eh_1 Tainted: G   M   2.6.21-rc5-git7-1 #1
Apr  2 18:20:13 cichlid kernel: Pid: 388, comm: scsi_eh_1 Tainted: G   M   2.6.21-rc5-git7-4 #4
Apr  4 15:27:53 cichlid kernel: Pid: 386, comm: scsi_eh_1 Not tainted 2.6.21-rc5-git9-1 #1
Apr  5 04:00:08 cichlid kernel: Pid: 386, comm: scsi_eh_0 Tainted: G   M 2.6.21-rc5-git10-1-slab-debug #1
Apr  5 04:00:08 cichlid kernel: Pid: 390, comm: scsi_eh_2 Tainted: G   M 2.6.21-rc5-git10-1-slab-debug #1
Apr  5 08:25:41 cichlid kernel: Pid: 386, comm: scsi_eh_0 Tainted: G   M 2.6.21-rc5-git10-1-slab-debug #1

The Oops seems to be the memcpy in scsi_send_eh_cmnd. The BUG appears to be in the oops handler 
itself. Earlier oopsen happened in kfree so I turned on slab debugging. 

Apr  5 03:45:16 cichlid kernel: 3w-xxxx: scsi2: Command failed: status = 0xc7, flags = 0x7f, unit #4.
Apr  5 03:45:20 cichlid kernel: 3w-xxxx: scsi2: Command failed: status = 0xc7, flags = 0x80, unit #4.
Apr  5 03:47:20 cichlid kernel: 3w-xxxx: scsi0: Command failed: status = 0xc7, flags = 0x80, unit #0.
Apr  5 03:47:20 cichlid kernel: 3w-xxxx: scsi0: Command failed: status = 0xc7, flags = 0x80, unit #1.
Apr  5 04:00:08 cichlid kernel: 3w-xxxx: scsi0: Command failed: status = 0xc7, flags = 0x80, unit #0.
Apr  5 04:00:08 cichlid kernel: BUG: using smp_processor_id() in preemptible [00000001] code: scsi_eh_0/386
Apr  5 04:00:08 cichlid kernel: caller is oops_begin+0xc/0x80
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: Call Trace:
Apr  5 04:00:08 cichlid kernel:  [debug_smp_processor_id+181/208] debug_smp_processor_id+0xb5/0xd0
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8034de35>] debug_smp_processor_id+0xb5/0xd0
Apr  5 04:00:08 cichlid kernel:  [oops_begin+12/128] oops_begin+0xc/0x80
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80272dbc>] oops_begin+0xc/0x80
Apr  5 04:00:08 cichlid kernel:  [die+41/112] die+0x29/0x70
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80273559>] die+0x29/0x70
Apr  5 04:00:08 cichlid kernel:  [do_general_protection+284/304] do_general_protection+0x11c/0x130
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8027437c>] do_general_protection+0x11c/0x130
Apr  5 04:00:08 cichlid kernel:  [error_exit+0/150] error_exit+0x0/0x96
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026ef7d>] error_exit+0x0/0x96
Apr  5 04:00:08 cichlid kernel:  [memcpy_c+11/32] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026a7cb>] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel:  [_end+123674792/2126102956] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88055efc>] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [thread_return+230/301] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026b699>] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [_end+123678124/2126102956] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88056c00>] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [keventd_create_kthread+0/144] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [<ffffffff802a21c0>] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [kthread+218/272] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237b1a>] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+10/18] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268ea8>] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [schedule_tail+124/240] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8022b90c>] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [restore_args+0/48] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268590>] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [kthread+0/272] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237a40>] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+0/18] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268e9e>] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: general protection fault: 0000 [1] PREEMPT SMP 
Apr  5 04:00:08 cichlid kernel: CPU 1 
Apr  5 04:00:08 cichlid kernel: Modules linked in: dm_multipath multipath linear raid456 xor raid1 md_mod act_police sch_ingress sch_sfq sch_cbq ipt_TOS cls_u32 sch_htb ipt_MASQUERADE ipt_LOG xt_multiport nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat emi26 w83627hf hwmon_vid i2c_isa sunrpc ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables x_tables freq_table sr_mod loop dm_mirror dm_mod video thermal sbs processor i2c_ec fan dock button battery asus_acpi ac parport_pc lp parport floppy nvram snd_usb_audio snd_ice1712 snd_ice17xx_ak4xxx snd_via82xx sg gameport snd_seq_dummy pcspkr snd_ak4xxx_adda snd_cs8427 snd_via82xx_modem snd_seq_oss snd_ac97_codec sata_via snd_i2c snd_seq_midi_event snd_seq skge i2c_viapro snd_mpu401_uart i2c_core k8temp ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc dsbr100 snd_usb_lib
  snd_rawmidi compat_ioctl32 snd_seq_device videodev v4l2_common v4l1_compat snd_hwdep snd!
  soundcore sisusbvga ftdi_sio usb_stor
Apr  5 04:00:08 cichlid kernel: ge serio_raw emi62 usbserial asix usbnet ata_piix 3w_xxxx ata_generic pata_via libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Apr  5 04:00:08 cichlid kernel: Pid: 386, comm: scsi_eh_0 Tainted: G   M   2.6.21-rc5-git10-1-slab-debug #1
Apr  5 04:00:08 cichlid kernel: RIP: 0010:[memcpy_c+11/32]  [memcpy_c+11/32] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel: RIP: 0010:[<ffffffff8026a7cb>]  [<ffffffff8026a7cb>] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel: RSP: 0000:ffff8100beebbce8  EFLAGS: 00010246
Apr  5 04:00:08 cichlid kernel: RAX: ffff8100b4978140 RBX: 0000000000002003 RCX: 000000000000000c
Apr  5 04:00:08 cichlid kernel: RDX: 0000000000000000 RSI: 6ddaa59200000000 RDI: ffff8100b4978140
Apr  5 04:00:08 cichlid kernel: RBP: ffff8100beebbe20 R08: 0000000000000002 R09: 0000000000000001
Apr  5 04:00:08 cichlid kernel: R10: 0000000000000000 R11: 00000000ffffffff R12: ffff8100b4978140
Apr  5 04:00:08 cichlid kernel: R13: ffffffff8807a1ce R14: ffff8100b4978058 R15: ffff8100beebc000
Apr  5 04:00:08 cichlid kernel: FS:  00002b615f4dc240(0000) GS:ffff8100bffae4c8(0000) knlGS:00000000f795eb90
Apr  5 04:00:08 cichlid kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Apr  5 04:00:08 cichlid kernel: CR2: 00002b615f4b9000 CR3: 00000000a25ad000 CR4: 00000000000006e0
Apr  5 04:00:08 cichlid kernel: Process scsi_eh_0 (pid: 386, threadinfo ffff8100beeba000, task ffff8100bedd0100)
Apr  5 04:00:08 cichlid kernel: Stack:  ffffffff88055efc 0000271000000001 ffff8100b49780b4 ffff8100bef94508
Apr  5 04:00:08 cichlid kernel:  0000000200000002 000010000a240001 ffff810013404c78 0000000000000000
Apr  5 04:00:08 cichlid kernel:  ffff810000000001 ffffffffdead4ead ffffffffffffffff 0000000000000000
Apr  5 04:00:08 cichlid kernel: Call Trace:
Apr  5 04:00:08 cichlid kernel:  [_end+123674792/2126102956] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88055efc>] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [thread_return+230/301] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026b699>] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [_end+123678124/2126102956] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88056c00>] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [keventd_create_kthread+0/144] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [<ffffffff802a21c0>] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [kthread+218/272] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237b1a>] kthread+0xda/0x110
Apr  5 04:00:08 cichlid autoblacklist[9591]: src= proto= srcport= destport= srcname= destportname= srcportname= icmptype= icmpcode=
Apr  5 04:00:08 cichlid kernel:  [child_rip+10/18] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268ea8>] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [schedule_tail+124/240] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8022b90c>] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [restore_args+0/48] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268590>] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [kthread+0/272] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237a40>] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+0/18] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268e9e>] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: Code: f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 0f 1f 80 00 00 00 
Apr  5 04:00:08 cichlid kernel: RIP  [memcpy_c+11/32] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel: RIP  [<ffffffff8026a7cb>] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel:  RSP <ffff8100beebbce8>
Apr  5 04:00:08 cichlid kernel: 3w-xxxx: scsi2: Command failed: status = 0xc7, flags = 0x80, unit #7.
Apr  5 04:00:08 cichlid kernel: BUG: using smp_processor_id() in preemptible [00000001] code: scsi_eh_2/390
Apr  5 04:00:08 cichlid kernel: caller is oops_begin+0xc/0x80
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: Call Trace:
Apr  5 04:00:08 cichlid kernel:  [debug_smp_processor_id+181/208] debug_smp_processor_id+0xb5/0xd0
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8034de35>] debug_smp_processor_id+0xb5/0xd0
Apr  5 04:00:08 cichlid kernel:  [oops_begin+12/128] oops_begin+0xc/0x80
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80272dbc>] oops_begin+0xc/0x80
Apr  5 04:00:08 cichlid kernel:  [die+41/112] die+0x29/0x70
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80273559>] die+0x29/0x70
Apr  5 04:00:08 cichlid kernel:  [do_general_protection+284/304] do_general_protection+0x11c/0x130
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8027437c>] do_general_protection+0x11c/0x130
Apr  5 04:00:08 cichlid kernel:  [error_exit+0/150] error_exit+0x0/0x96
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026ef7d>] error_exit+0x0/0x96
Apr  5 04:00:08 cichlid kernel:  [memcpy_c+11/32] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026a7cb>] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel:  [_end+123674792/2126102956] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88055efc>] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [thread_return+230/301] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026b699>] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [_end+123678124/2126102956] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88056c00>] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [keventd_create_kthread+0/144] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [<ffffffff802a21c0>] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [kthread+218/272] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237b1a>] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+10/18] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268ea8>] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [schedule_tail+124/240] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8022b90c>] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [restore_args+0/48] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268590>] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [kthread+0/272] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237a40>] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+0/18] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268e9e>] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: general protection fault: 0000 [2] PREEMPT SMP 
Apr  5 04:00:08 cichlid kernel: CPU 1 
Apr  5 04:00:08 cichlid kernel: Modules linked in: dm_multipath multipath linear raid456 xor raid1 md_mod act_police sch_ingress sch_sfq sch_cbq ipt_TOS cls_u32 sch_htb ipt_MASQUERADE ipt_LOG xt_multiport nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat emi26 w83627hf hwmon_vid i2c_isa sunrpc ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables x_tables freq_table sr_mod loop dm_mirror dm_mod video thermal sbs processor i2c_ec fan dock button battery asus_acpi ac parport_pc lp parport floppy nvram snd_usb_audio snd_ice1712 snd_ice17xx_ak4xxx snd_via82xx sg gameport snd_seq_dummy pcspkr snd_ak4xxx_adda snd_cs8427 snd_via82xx_modem snd_seq_oss snd_ac97_codec sata_via snd_i2c snd_seq_midi_event snd_seq skge i2c_viapro snd_mpu401_uart i2c_core k8temp ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc dsbr100 snd_usb_lib
  snd_rawmidi compat_ioctl32 snd_seq_device videodev v4l2_common v4l1_compat snd_hwdep snd!
  soundcore sisusbvga ftdi_sio usb_stor
Apr  5 04:00:08 cichlid kernel: ge serio_raw emi62 usbserial asix usbnet ata_piix 3w_xxxx ata_generic pata_via libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Apr  5 04:00:08 cichlid kernel: Pid: 390, comm: scsi_eh_2 Tainted: G   M   2.6.21-rc5-git10-1-slab-debug #1
Apr  5 04:00:08 cichlid kernel: RIP: 0010:[memcpy_c+11/32]  [memcpy_c+11/32] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel: RIP: 0010:[<ffffffff8026a7cb>]  [<ffffffff8026a7cb>] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel: RSP: 0018:ffff8100be867ce8  EFLAGS: 00010246
Apr  5 04:00:08 cichlid kernel: RAX: ffff8100b4978300 RBX: 0000000000002003 RCX: 000000000000000c
Apr  5 04:00:08 cichlid kernel: RDX: 0000000000000000 RSI: 6ddaa59200000000 RDI: ffff8100b4978300
Apr  5 04:00:08 cichlid kernel: RBP: ffff8100be867e20 R08: 0000000000000002 R09: 0000000000000001
Apr  5 04:00:08 cichlid kernel: R10: 0000000000000000 R11: 00000000ffffffff R12: ffff8100b4978300
Apr  5 04:00:08 cichlid kernel: R13: ffffffff8807a1ce R14: ffff8100b4978218 R15: ffff8100be868000
Apr  5 04:00:08 cichlid kernel: FS:  00002b8ea24623b0(0000) GS:ffff8100bffae4c8(0000) knlGS:00000000f7ba0b90
Apr  5 04:00:08 cichlid kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Apr  5 04:00:08 cichlid kernel: CR2: 00002b8ea5956000 CR3: 00000000a5f17000 CR4: 00000000000006e0
Apr  5 04:00:08 cichlid kernel: Process scsi_eh_2 (pid: 390, threadinfo ffff8100be866000, task ffff810037d480c0)
Apr  5 04:00:08 cichlid kernel: Stack:  ffffffff88055efc 0000271000000001 ffff8100b4978274 ffff8100bee470f8
Apr  5 04:00:08 cichlid kernel:  0000000200000002 000010000a7f0001 ffff810064cd7ea8 0000000000000000
Apr  5 04:00:08 cichlid kernel:  ffff810000000001 ffffffffdead4ead ffffffffffffffff 0000000000000000
Apr  5 04:00:08 cichlid kernel: Call Trace:
Apr  5 04:00:08 cichlid kernel:  [_end+123674792/2126102956] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88055efc>] :scsi_mod:scsi_send_eh_cmnd+0x3fc/0x480
Apr  5 04:00:08 cichlid kernel:  [thread_return+230/301] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8026b699>] thread_return+0xe6/0x12d
Apr  5 04:00:08 cichlid kernel:  [_end+123678124/2126102956] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [<ffffffff88056c00>] :scsi_mod:scsi_error_handler+0x0/0x540
Apr  5 04:00:08 cichlid kernel:  [keventd_create_kthread+0/144] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [<ffffffff802a21c0>] keventd_create_kthread+0x0/0x90
Apr  5 04:00:08 cichlid kernel:  [kthread+218/272] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237b1a>] kthread+0xda/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+10/18] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268ea8>] child_rip+0xa/0x12
Apr  5 04:00:08 cichlid kernel:  [schedule_tail+124/240] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [<ffffffff8022b90c>] schedule_tail+0x7c/0xf0
Apr  5 04:00:08 cichlid kernel:  [restore_args+0/48] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268590>] restore_args+0x0/0x30
Apr  5 04:00:08 cichlid kernel:  [kthread+0/272] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80237a40>] kthread+0x0/0x110
Apr  5 04:00:08 cichlid kernel:  [child_rip+0/18] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel:  [<ffffffff80268e9e>] child_rip+0x0/0x12
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: 
Apr  5 04:00:08 cichlid kernel: Code: f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 0f 1f 80 00 00 00 
Apr  5 04:00:08 cichlid kernel: RIP  [memcpy_c+11/32] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel: RIP  [<ffffffff8026a7cb>] memcpy_c+0xb/0x20
Apr  5 04:00:08 cichlid kernel:  RSP <ffff8100be867ce8>
Apr  5 04:00:08 cichlid kernel: 3w-xxxx: scsi0: AEN: ERROR: Drive error: Port #0.


