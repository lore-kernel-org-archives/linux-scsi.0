From: David Ellingsworth <david@identd.dyndns.org>
Subject: OOPS: gdth
Date: Tue, 11 Oct 2011 19:21:28 -0400
Message-ID: <CAK28g5LLQk955fxt+o=9TwkpB6yP8w089he_OfXNd_PSb9dXkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48599 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1JKXVa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Oct 2011 19:21:30 -0400
Received: by bkbzt4 with SMTP id zt4so154549bkb.19
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2011 16:21:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I received the following oops upon booting with Debian kernel 3.0.0-2-686-pae.

[    3.886222] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    3.886358] gdth 0000:01:08.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.910896] e1000 0000:04:05.1: eth1: (PCI:33MHz:64-bit) 00:03:47:32:02:1f
[    3.910968] e1000 0000:04:05.1: eth1: Intel(R) PRO/1000 Network Connection
[    3.949661] Configuring GDT-PCI HA at 1/8 IRQ 18
[    3.969991] aic79xx 0000:03:04.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    4.009557] [PCI 1/8]
[    4.031554] BUG: unable to handle kernel NULL pointer dereference at 00000089
[    4.031743] IP: [<f84d7bcf>] __gdth_interrupt+0x53e/0xa4f [gdth]
[    4.031853] *pdpt = 00000000347d7001 *pde = 0000000000000000
[    4.031993] Oops: 0000 [#1] SMP
[    4.032003] Modules linked in: aic79xx(+) scsi_transport_spi
gdth(+) snd_seq ssb mmc_core pcmcia pcmcia_core rfkill snd_timer
ata_generic eeprom_93cx6 snd_seq_device ata_piix snd e1000 evdev
parport_pc soundcore parport e7xxx_edac uhci_hcd ehci_hcd usbcore
i2c_i801 i2c_core pcspkr edac_core rng_core floppy tpm_tis tpm
tpm_bios processor button thermal_sys reiserfs dm_mod sd_mod
crc_t10dif sata_sil libata scsi_mod shpchp pci_hotplug
[    4.032003]
[    4.032003] Pid: 367, comm: modprobe Not tainted 3.0.0-2-686-pae #1
Intel                        /SE7501HG2
[    4.032003] EIP: 0060:[<f84d7bcf>] EFLAGS: 00010297 CPU: 1
[    4.032003] EIP is at __gdth_interrupt+0x53e/0xa4f [gdth]
[    4.032003] EAX: 0000000b EBX: c0c003b4 ECX: 00000003 EDX: 0000000b
[    4.032003] ESI: fffffffd EDI: 00000001 EBP: f4731d8c ESP: f4731d60
[    4.032003]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    4.032003] Process modprobe (pid: 367, ti=f4730000 task=f466edd0
task.ti=f4730000)
[    4.032003] Stack:
[    4.032003]  00000000 000000e0 ffffff10 000b82f6 00000060 00000246
00000002 000186a0
[    4.032003]  c0c003b4 00000001 f84d810b 00000003 c0c003e4 c0c003b4
00000000 00000000
[    4.032003]  f84d8d95 00000002 00000000 09731e20 0001869f 001a0000
00000000 c0c003b4
[    4.032003] Call Trace:
[    4.032003]  [<f84d810b>] ? gdth_wait+0x2b/0x64 [gdth]
[    4.032003]  [<f84d8d95>] ? gdth_internal_cmd+0x18a/0x1d7 [gdth]
[    4.032003]  [<f84db3e6>] ? gdth_search_drives+0xac/0xae9 [gdth]
[    4.032003]  [<f84dc7ab>] ? gdth_pci_init_one+0x988/0xbd2 [gdth]
[    4.032003]  [<c1169b92>] ? local_pci_probe+0x2c/0x56
[    4.032003]  [<c1169fb8>] ? pci_device_probe+0x43/0x65
[    4.032003]  [<c11e74a3>] ? driver_probe_device+0x93/0x113
[    4.032003]  [<c11e7563>] ? __driver_attach+0x40/0x5b
[    4.032003]  [<c11e6a2b>] ? bus_for_each_dev+0x37/0x59
[    4.032003]  [<c11e723c>] ? driver_attach+0x11/0x13
[    4.032003]  [<c11e7523>] ? driver_probe_device+0x113/0x113
[    4.032003]  [<c11e6f5c>] ? bus_add_driver+0x83/0x1bd
[    4.032003]  [<c1152bb9>] ? kset_find_obj_hinted+0x43/0x76
[    4.032003]  [<c11e791f>] ? driver_register+0x75/0xca
[    4.032003]  [<c116a18b>] ? __pci_register_driver+0x33/0x89
[    4.032003]  [<f841a808>] ? gdth_init+0x5ca/0xdc2 [gdth]
[    4.032003]  [<c1023b4d>] ? set_memory_ro+0x13/0x17
[    4.032003]  [<f841a23e>] ? option_setup+0x23e/0x23e [gdth]
[    4.032003]  [<c100312c>] ? do_one_initcall+0x68/0x110
[    4.032003]  [<c105ffe4>] ? sys_init_module+0x140a/0x15d7
[    4.032003]  [<c12b26df>] ? sysenter_do_call+0x12/0x28
[    4.032003] Code: 05 83 fe fe 75 20 80 3d a8 03 4e f8 00 0f 85 1c
05 00 00 8b 14 24 8d 83 e8 4a 00 00 e8 72 61 dd c8 e9 09 05 00 00 0f
b7 44 24 0e <8b> ae 8c 00 00 00 8b bb 08 02 00 00 83 f8 0b 89 44 24 10
0f 85
[    4.032003] EIP: [<f84d7bcf>] __gdth_interrupt+0x53e/0xa4f [gdth]
SS:ESP 0068:f4731d60
[    4.032003] CR2: 0000000000000089
[    4.040164] ---[ end trace b682122307c5c727 ]---

Regards,

David Ellingsworth
