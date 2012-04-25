From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43161] New: kernel panic upon inserting a USB harddisk
Date: Wed, 25 Apr 2012 15:32:09 GMT
Message-ID: <bug-43161-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:58432 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2DYPcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2012 11:32:09 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3PFW9KK018647
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2012 15:32:09 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43161

           Summary: kernel panic upon inserting a USB harddisk
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.4.0-rc1+ (linus git tree)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: htmldeveloper@gmail.com
        Regression: No


I got a kernel crash upon inserting USB harddisk:


[100023.229073] BUG: unable to handle kernel NULL pointer dereference at
000001fc
[100023.229150] IP: [<c0465e9d>] scsi_send_eh_cmnd+0x2d/0x300
[100023.229193] *pde = 00000000 
[100023.229214] Oops: 0000 [#1] SMP 
[100023.229239] Modules linked in: aes_i586 aes_generic des_generic md4 cifs
btrfs zlib_deflate crc32c libcrc32c bfs isofs nls_iso8859_1 nls_cp437 vfat fat
usb_storage snd_hrtimer binfmt_misc pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) nfsd kvm_intel kvm nfs lockd parport_pc ppdev fscache
auth_rpcgss nfs_acl sunrpc xfs exportfs arc4 iwlwifi i915 mac80211
snd_hda_codec_conexant drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq tpm_tis pcmcia
snd_timer snd_seq_device intel_agp i2c_algo_bit psmouse tpm coretemp tpm_bios
intel_gtt yenta_socket pcmcia_rsrc lp agpgart thinkpad_acpi video serio_raw
pcmcia_core nvram snd microcode soundcore parport cfg80211 snd_page_alloc
reiserfs usbhid hid firewire_ohci e1000e firewire_core crc_itu_t ahci libahci
[100023.229826] 
[100023.229837] Pid: 24117, comm: scsi_eh_15 Tainted: G           O 3.4.0-rc1+
#15 LENOVO 7440A82/7440A82
[100023.229895] EIP: 0060:[<c0465e9d>] EFLAGS: 00010246 CPU: 1
[100023.229928] EIP is at scsi_send_eh_cmnd+0x2d/0x300
[100023.229955] EAX: 00000000 EBX: eece20c0 ECX: 00000006 EDX: f0c95ea0
[100023.229991] ESI: 00000001 EDI: f0c95e90 EBP: f0c95f00 ESP: f0c95e74
[100023.230027]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[100023.230045] CR0: 8005003b CR2: 000001fc CR3: 31abd000 CR4: 000407d0
[100023.230045] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[100023.230045] DR6: ffff0ff0 DR7: 00000400
[100023.230045] Process scsi_eh_15 (pid: 24117, ti=f0c94000 task=f4b9a5b0
task.ti=f0c94000)
[100023.230045] Stack:
[100023.230045]  f0c95e8c c014095c f35184bc 7fffffff f35184c0 00000006 c0a38248
f0c95ef4
[100023.230045]  c0627d4d c0997600 05f1a70a 00000092 f42a8c80 f48ea500 00010061
f0c95ec4
[100023.230045]  c04ca1f4 f48ea500 f42a8c80 f48ea510 f0c95ed4 f0c95ed4 00000092
00000000
[100023.230045] Call Trace:
[100023.230045]  [<c014095c>] ? lock_timer_base+0x2c/0x60
[100023.230045]  [<c0627d4d>] ? schedule_timeout+0x19d/0x260
[100023.230045]  [<c04ca1f4>] ? start_unlink_async+0x94/0x100
[100023.230045]  [<c04ca61a>] ? ehci_urb_dequeue+0x7a/0xe0
[100023.230045]  [<c062a448>] ? _raw_spin_lock_irq+0x18/0x20
[100023.230045]  [<c046621b>] scsi_eh_tur+0x3b/0xa0
[100023.230045]  [<c04662e4>] scsi_eh_test_devices+0x64/0x140
[100023.230045]  [<fa01a901>] ? device_reset+0x31/0x50 [usb_storage]
[100023.230045]  [<c0467228>] scsi_error_handler+0x458/0x610
[100023.230045]  [<c0466dd0>] ? scsi_eh_get_sense+0x1d0/0x1d0
[100023.230045]  [<c0151a0c>] kthread+0x7c/0x90
[100023.230045]  [<c0151990>] ? kthread_freezable_should_stop+0x60/0x60
[100023.230045]  [<c063167e>] kernel_thread_helper+0x6/0x10
[100023.230045] Code: e5 57 56 53 83 c4 80 3e 8d 74 26 00 89 c3 65 a1 14 00 00
00 89 45 f0 31 c0 8b 43 54 8d 7d 90 89 55 8c 8d 55 a0 89 4d 88 8b 40 68 <8b> 80
fc 01 00 00 8b 00 89 45 84 8b 03 8b 30 8d 45 98 89 45 98 
[100023.230045] EIP: [<c0465e9d>] scsi_send_eh_cmnd+0x2d/0x300 SS:ESP
0068:f0c95e74
[100023.230045] CR2: 00000000000001fc

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
