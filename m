From: Marc MERLIN <marc@merlins.org>
Subject: 4.13.12: frequent AACraid crash with a drive
Date: Mon, 27 Nov 2017 07:21:47 -0800
Message-ID: <20171127152147.b4buun2oknt4634i@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37589 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdK0PVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Nov 2017 10:21:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Howdy,

https://www.kernel.org/doc/Documentation/scsi/aacraid.txt
mentions that I should Email here.

This is not a new problem with a new kernel, I just switched to an
adaptec 16 port SATA card, and one of the drives (apparently always the
same) is causing the card to crash apparently due to not handling a
communication fault.

Adaptec aacraid driver 1.2.1[50834]-custom
aacraid 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
aacraid: Comm Interface type2 enabled
aacraid 0000:02:00.0: 64 Bit DAC enabled
scsi host10: aacraid

I'm assuming it doesn't like my green drive:
Model Family:     Western Digital Caviar Green
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY1362941
LU WWN Device Id: 5 0014ee 258fc61f7
Firmware Version: 01.00A01
User Capacity:    2,000,398,934,016 bytes [2.00 TB]

I have 5 of them (although they're not exactly the same) and only this
one seems to be causing problems.

when the kernel crashes, the drive does not get kicked out of the array, and things seem to work aftere reboot.
Time between reboots are nconsistent. Since last night:
Sun Nov 26 21:07:18 PST 2017
Sun Nov 26 21:25:38 PST 2017
Sun Nov 26 23:27:12 PST 2017
Mon Nov 27 02:20:47 PST 2017
Mon Nov 27 07:12:31 PST 2017
Mon Nov 27 07:12:31 PST 2017

Crash log:
aacraid: Host adapter abort request.
aacraid: Outstanding commands on (6,1,0,0):
aacraid: Host adapter reset request. SCSI hang ?
aacraid 0000:02:00.0: outstanding cmd: midlevel-0
aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
aacraid 0000:02:00.0: outstanding cmd: error handler-1
aacraid 0000:02:00.0: outstanding cmd: firmware-0
aacraid 0000:02:00.0: outstanding cmd: kernel-0
aacraid 0000:02:00.0: Controller reset type is 3
aacraid 0000:02:00.0: Issuing IOP reset
aacraid 0000:02:00.0: IOP reset failed
aacraid 0000:02:00.0: ARC Reset attempt failed
aacraid: Host adapter abort request.
aacraid: Outstanding commands on (6,1,0,0):
aacraid: Host adapter reset request. SCSI hang ?
aacraid 0000:02:00.0: Adapter health - -3
aacraid 0000:02:00.0: outstanding cmd: midlevel-0
aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
aacraid 0000:02:00.0: outstanding cmd: error handler-1
aacraid 0000:02:00.0: outstanding cmd: firmware-0
aacraid 0000:02:00.0: outstanding cmd: kernel-3
------------[ cut here ]------------
WARNING: CPU: 6 PID: 366 at kernel/kthread.c:71 to_kthread+0xa/0x15
Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass eeepc_wmi snd_cmipci asus_wmi snd_mpu401_uart sparse_keymap snd_opl3_lib rfkill snd_rawmidi asix snd_hda_codec_realtek snd_hda_codec_generic tpm_infineon tpm_tis usbnet wmi_bmof hwmon tpm_tis_core
 snd_seq_device usbserial libphy wmi tpm lpc_ich battery i915 rc_ati_x10 snd_hda_intel snd_hda_codec ati_remote snd_hda_core i2c_i801 snd_hwdep pcspkr snd_pcm input_leds mei_me rc_core snd_timer parport_pc parport evdev snd soundcore e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd r8169 aacraid sata_sil24 usbcore mii thermal fan [last unloaded: ftdi_sio]
CPU: 6 PID: 366 Comm: scsi_eh_6 Tainted: G     U          4.13.12-amd64-stkreg-sysrq-20171018 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
task: ffff9830b57da000 task.stack: ffffa804c3cbc000
RIP: 0010:to_kthread+0xa/0x15
RSP: 0018:ffffa804c3cbfb90 EFLAGS: 00210246
RAX: 000000000000016e RBX: ffff9828dbc8c180 RCX: 00000000ffffffff
RDX: ffff9828dbc8c180 RSI: 0000000000200286 RDI: ffff9828dbc8c180
RBP: ffffa804c3cbfb90 R08: 0000000000000000 R09: 0000000000000000
R10: ffffa804c3cbfbd8 R11: ffffffff94899a20 R12: ffff9830b9f88000
R13: 0000000000000002 R14: ffff9830b9f88000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff9830de380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000df76a000 CR3: 0000000143c09000 CR4: 00000000001406e0
Call Trace:
 kthread_stop+0x53/0xf4
 aac_reset_adapter+0x186/0x700 [aacraid]
 aac_eh_reset+0x396/0x3aa [aacraid]
 scsi_try_host_reset+0x5d/0xb1
 scsi_send_eh_cmnd+0x296/0x2dc
 ? __call_rcu.constprop.44+0x10d/0x188
 ? schedule_timeout+0xca/0x101
 scsi_eh_try_stu+0x53/0x7a
 scsi_eh_test_devices+0xcd/0x16e
 scsi_eh_ready_devs+0x824/0x8c4
 scsi_error_handler+0x291/0x523
 ? __schedule+0x4f5/0x5c5
 ? scsi_eh_get_sense+0x1a9/0x1a9
 kthread+0xfb/0x100
 ? init_completion+0x24/0x24
 ? do_fast_syscall_32+0xb7/0xfe
 ret_from_fork+0x25/0x30
Code: 8b 4f 40 48 89 d0 be 00 10 00 00 48 c7 c2 35 d8 ab 94 48 89 c7 48 89 e5 e8 9c 83 6c 00 5d 48 98 c3 f6 47 4e 20 55 48 89 e5 75 02 <0f> ff 48 8b 87 50 06 00 00 5d c3 0f 1f 44 00 00 55 65 48 8b 3c
---[ end trace ca49830eeaa195ad ]---
general protection fault: 0000 [#1] PREEMPT SMP
Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass eeepc_wmi snd_cmipci asus_wmi snd_mpu401_uart sparse_keymap snd_opl3_lib rfkill snd_rawmidi asix snd_hda_codec_realtek snd_hda_codec_generic tpm_infineon tpm_tis usbnet wmi_bmof hwmon tpm_tis_core
 snd_seq_device usbserial libphy wmi tpm lpc_ich battery i915 rc_ati_x10 snd_hda_intel snd_hda_codec ati_remote snd_hda_core i2c_i801 snd_hwdep pcspkr snd_pcm input_leds mei_me rc_core snd_timer parport_pc parport evdev snd soundcore e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd r8169 aacraid sata_sil24 usbcore mii thermal fan [last unloaded: ftdi_sio]
CPU: 6 PID: 366 Comm: scsi_eh_6 Tainted: G     U  W       4.13.12-amd64-stkreg-sysrq-20171018 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
task: ffff9830b57da000 task.stack: ffffa804c3cbc000
RIP: 0010:kthread_stop+0x56/0xf4
RSP: 0018:ffffa804c3cbfba0 EFLAGS: 00210246
RAX: bcff0043c6bb2f8c RBX: ffff9828dbc8c180 RCX: 00000000ffffffff
RDX: ffff9828dbc8c180 RSI: 0000000000200286 RDI: ffff9828dbc8c180
RBP: ffffa804c3cbfbb0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffa804c3cbfbd8 R11: ffffffff94899a20 R12: bcff0043c6bb2f8c
R13: 0000000000000002 R14: ffff9830b9f88000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff9830de380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000df76a000 CR3: 0000000143c09000 CR4: 00000000001406e0
Call Trace:
 aac_reset_adapter+0x186/0x700 [aacraid]
 aac_eh_reset+0x396/0x3aa [aacraid]
 scsi_try_host_reset+0x5d/0xb1
 scsi_send_eh_cmnd+0x296/0x2dc
 ? __call_rcu.constprop.44+0x10d/0x188
 ? schedule_timeout+0xca/0x101
 scsi_eh_try_stu+0x53/0x7a
 scsi_eh_test_devices+0xcd/0x16e
 scsi_eh_ready_devs+0x824/0x8c4
 scsi_error_handler+0x291/0x523
 ? __schedule+0x4f5/0x5c5
 ? scsi_eh_get_sense+0x1a9/0x1a9
 kthread+0xfb/0x100
 ? init_completion+0x24/0x24
 ? do_fast_syscall_32+0xb7/0xfe
 ret_from_fork+0x25/0x30
Code: fb ff ff eb 17 49 8b 7c 24 08 48 89 de 41 ff 14 24 49 83 c4 18 49 83 3c 24 00 eb e0 f0 ff 43 48 48 89 df e8 6a fb ff ff 49 89 c4 <f0> 80 08 02 48 89 df e8 3b ff ff ff 48 89 df e8 c9 8c 00 00 49
RIP: kthread_stop+0x56/0xf4 RSP: ffffa804c3cbfba0
---[ end trace ca49830eeaa195ae ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x13000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
Rebooting in 20 seconds..
ACPI MEMORY or I/O RESET_REG.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
