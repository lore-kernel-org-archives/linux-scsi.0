From: Meelis Roos <mroos@linux.ee>
Subject: BUG on dpt_i2o module removal
Date: Wed, 25 May 2011 18:36:53 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1105251206580.19636@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

While trying to "rmmod dpt_i2o" in 1.6.39 with one unused DPT SmartRAID 
V card in the system, I got the following BUG:

[  776.979914] BUG: unable to handle kernel NULL pointer dereference at 00000004
[  776.980018] IP: [<c11845ea>] scsi_unregister+0xf/0x34
[  776.980018] *pde = 00000000 
[  776.980018] Oops: 0002 [#1] PREEMPT 
[  776.980018] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/class
[  776.980018] Modules linked in: snd_hrtimer ppdev lp uinput fuse nfsd nfs lockd auth_rpcgss nfs_acl sunrpc ipv6 adm1025 hwmon_vid smsc47m1 usb_storage usb_libusual udf crc_itu_t isofs zlib_inflate vfat fat eeprom ntfs i2o_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq sg snd_timer sr_mod snd_seq_device radeon cdrom snd ttm evdev uhci_hcd soundcore drm_kms_helper hwmon cfbcopyarea ehci_hcd snd_page_alloc dpt_i2o(-) cfbimgblt usbcore cfbfillrect parport_pc i2c_i801 parport processor button
[  776.980018] 
[  776.980018] Pid: 2051, comm: rmmod Not tainted 2.6.39 #373                  /D815EEA2                       
[  776.980018] EIP: 0060:[<c11845ea>] EFLAGS: 00210292 CPU: 0
[  776.980018] EIP is at scsi_unregister+0xf/0x34
[  776.980018] EAX: dea27000 EBX: dea27000 ECX: 00000000 EDX: 00000000
[  776.980018] ESI: 00000000 EDI: 00000880 EBP: d8ca9f4c ESP: d8ca9f4c
[  776.980018]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  776.980018] Process rmmod (pid: 2051, ti=d8ca8000 task=df791b40 task.ti=d8ca8000)
[  776.980018] Stack:
[  776.980018]  d8ca9f5c e083bc42 e083e164 00000000 d8ca9fac c1042d18 5f747064 006f3269
[  776.980018]  df70aa60 df79822c d8ca9f9c c106a12e ffffffff b785e000 b785d000 b785e000
[  776.980018]  df798e34 df70aa60 df70aa94 00000000 00ca9fac cff7145c bff033a0 bff033a0
[  776.980018] Call Trace:
[  776.980018]  [<e083bc42>] adpt_exit+0x39/0x3f7 [dpt_i2o]
[  776.980018]  [<c1042d18>] sys_delete_module+0x151/0x1ad
[  776.980018]  [<c106a12e>] ? do_munmap+0x183/0x19a
[  776.980018]  [<c1249777>] sysenter_do_call+0x12/0x26
[  776.980018] Code: a4 00 00 00 89 e5 e8 25 3b ff ff 5d c3 55 05 e0 00 00 00 89 e5 e8 16 3b ff ff 5d c3 55 8b 88 28 02 00 00 89 e5 8b 90 2c 02 00 00 
[  776.980018]  51 04 89 0a c7 80 28 02 00 00 00 01 10 00 c7 80 2c 02 00 00 
[  776.980018] EIP: [<c11845ea>] scsi_unregister+0xf/0x34 SS:ESP 0068:d8ca9f4c
[  776.980018] CR2: 0000000000000004
[  777.209807] ---[ end trace 3feb5860cd6a778d ]---

It seems list_del gets NULL shost->sht_legacy_list.

scsi_register is never called, this seems to be the reason why 
sht_legacy_list is not filled?

-- 
Meelis Roos (mroos@linux.ee)
