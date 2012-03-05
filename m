From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [BUG] scsi_device.device == NULL in sd_revalidate_disk()
Date: Mon, 5 Mar 2012 15:41:33 -0800
Message-ID: <20120305234133.GA13690@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-fsdevel@vger.kernel.o..." <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I ran into a NULL dereference bug on USB key hot remove, which should
be caused by the below skdp->device reference

        static int sd_revalidate_disk(struct gendisk *disk)
        {       
                struct scsi_disk *sdkp = scsi_disk(disk);
==>             struct scsi_device *sdp = sdkp->device;

judging from the scripts/decodecode output:

All code
========
   0:   55                      push   %rbp
   1:   53                      push   %rbx
   2:   48 81 ec 88 00 00 00    sub    $0x88,%rsp
   9:   48 8b af 38 03 00 00    mov    0x338(%rdi),%rbp
  10:   65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
  17:   00 00
  19:   48 89 44 24 78          mov    %rax,0x78(%rsp)
  1e:   31 c0                   xor    %eax,%eax
  20:   8b 05 1c 9b 05 00       mov    0x59b1c(%rip),%eax        # 0x59b42
  26:   48 89 7c 24 48          mov    %rdi,0x48(%rsp)
  2b:*  4c 8b 7d 08             mov    0x8(%rbp),%r15     <-- trapping instruction
  2f:   c1 e8 15                shr    $0x15,%eax
  32:   83 e0 07                and    $0x7,%eax
  35:   83 f8 03                cmp    $0x3,%eax
  38:   76 43                   jbe    0x7d
  3a:   48                      rex.W
  3b:   8b                      .byte 0x8b
  3c:   8d                      .byte 0x8d
  3d:   88 02                   mov    %al,(%rdx)
        ...

or gdb disassemble /usr/lib/debug/lib/modules/3.2.0-1-amd64/kernel/drivers/scsi/sd_mod.ko:

Dump of assembler code for function sd_revalidate_disk:
   0x00000000000027da <+0>:     push   %r15
   0x00000000000027dc <+2>:     push   %r14
   0x00000000000027de <+4>:     push   %r13
   0x00000000000027e0 <+6>:     push   %r12
   0x00000000000027e2 <+8>:     push   %rbp
   0x00000000000027e3 <+9>:     push   %rbx
   0x00000000000027e4 <+10>:    sub    $0x88,%rsp
   0x00000000000027eb <+17>:    mov    0x338(%rdi),%rbp
   0x00000000000027f2 <+24>:    mov    %gs:0x28,%rax
   0x00000000000027fb <+33>:    mov    %rax,0x78(%rsp)
   0x0000000000002800 <+38>:    xor    %eax,%eax
   0x0000000000002802 <+40>:    mov    0x0(%rip),%eax        # 0x2808 <sd_revalidate_disk+46>
   0x0000000000002808 <+46>:    mov    %rdi,0x48(%rsp)
   0x000000000000280d <+51>:    mov    0x8(%rbp),%r15
   0x0000000000002811 <+55>:    shr    $0x15,%eax
   0x0000000000002814 <+58>:    and    $0x7,%eax
   0x0000000000002817 <+61>:    cmp    $0x3,%eax
   0x000000000000281a <+64>:    jbe    0x285f <sd_revalidate_disk+133>
   0x000000000000281c <+66>:    mov    0x288(%rbp),%rcx
   0x0000000000002823 <+73>:    lea    0x138(%r15),%rsi
   0x000000000000282a <+80>:    test   %rcx,%rcx

I'm not familiar with this code and wonder who can be clearing the
sdkp->device before sd_revalidate_disk()?

Thanks,
Fengguang

PS. the related dmesg

Mar  5 13:23:42 wfg-t420 kernel: [ 2402.297504] usb 1-1.1: new full-speed USB device number 7 using ehci_hcd
Mar  5 13:23:42 wfg-t420 kernel: [ 2402.391774] usb 1-1.1: New USB device found, idVendor=0421, idProduct=002d
Mar  5 13:23:42 wfg-t420 kernel: [ 2402.391779] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar  5 13:23:42 wfg-t420 kernel: [ 2402.391782] usb 1-1.1: Product: Nokia 6120 classic
Mar  5 13:23:42 wfg-t420 kernel: [ 2402.391784] usb 1-1.1: Manufacturer: Nokia
Mar  5 13:23:42 wfg-t420 kernel: [ 2402.391786] usb 1-1.1: SerialNumber: 359807018700505
Mar  5 13:23:42 wfg-t420 kernel: [ 2402.392907] scsi8 : usb-storage 1-1.1:1.0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.388301] scsi 8:0:0:0: Direct-Access     Nokia    S60              1.0  PQ: 0 ANSI: 0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.390374] sd 8:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.390384] sd 8:0:0:0: [sdd] 3987208 512-byte logical blocks: (2.04 GB/1.90 GiB)
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.391243] sd 8:0:0:0: [sdd] Write Protect is off
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.391248] sd 8:0:0:0: [sdd] Mode Sense: 03 00 00 00
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.392527] sd 8:0:0:0: [sdd] No Caching mode page present
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.392532] sd 8:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.394228] sd 8:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.395602] sd 8:0:0:0: [sdd] No Caching mode page present
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.395606] sd 8:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.649858]  sdd:
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.651779] sd 8:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.653390] sd 8:0:0:0: [sdd] No Caching mode page present
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.653394] sd 8:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.653397] sd 8:0:0:0: [sdd] Attached SCSI removable disk
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.926415] usb 1-1.1: USB disconnect, device number 7
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927327] scsi 8:0:0:0: [sdd] killing request
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927345] scsi 8:0:0:0: [sdd] Unhandled error code
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927348] scsi 8:0:0:0: [sdd]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927354] scsi 8:0:0:0: [sdd] CDB: Read(10): 28 00 00 00 01 98 00 00 08 00
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927367] end_request: I/O error, dev sdd, sector 408
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927371] Buffer I/O error on device sdd, logical block 51
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927469] Buffer I/O error on device sdd, logical block 51
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927493] Buffer I/O error on device sdd, logical block 0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927498] Buffer I/O error on device sdd, logical block 0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927513] Buffer I/O error on device sdd, logical block 2
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927518] Buffer I/O error on device sdd, logical block 2
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927524] Buffer I/O error on device sdd, logical block 0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927530] Buffer I/O error on device sdd, logical block 0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927539] Buffer I/O error on device sdd, logical block 0
Mar  5 13:23:43 wfg-t420 kernel: [ 2403.927549] Buffer I/O error on device sdd, logical block 512
Mar  5 13:23:43 wfg-t420 kernel: [ 2404.141318] usb 1-1.1: new full-speed USB device number 8 using ehci_hcd
Mar  5 13:23:44 wfg-t420 kernel: [ 2404.235932] usb 1-1.1: New USB device found, idVendor=0421, idProduct=002d
Mar  5 13:23:44 wfg-t420 kernel: [ 2404.235938] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar  5 13:23:44 wfg-t420 kernel: [ 2404.235941] usb 1-1.1: Product: Nokia 6120 classic
Mar  5 13:23:44 wfg-t420 kernel: [ 2404.235943] usb 1-1.1: Manufacturer: Nokia
Mar  5 13:23:44 wfg-t420 kernel: [ 2404.235945] usb 1-1.1: SerialNumber: 359807018700505
Mar  5 13:23:44 wfg-t420 kernel: [ 2404.237236] scsi9 : usb-storage 1-1.1:1.0
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.235887] scsi 9:0:0:0: Direct-Access     Nokia    S60              1.0  PQ: 0 ANSI: 0
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.239196] sd 9:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.239213] sd 9:0:0:0: [sdd] 3987208 512-byte logical blocks: (2.04 GB/1.90 GiB)
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.240071] sd 9:0:0:0: [sdd] Write Protect is off
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.240080] sd 9:0:0:0: [sdd] Mode Sense: 03 00 00 00
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.240807] sd 9:0:0:0: [sdd] No Caching mode page present
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.240817] sd 9:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.253385] sd 9:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.254768] sd 9:0:0:0: [sdd] No Caching mode page present
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.254771] sd 9:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.261000]  sdd:
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.262613] sd 9:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.266226] sd 9:0:0:0: [sdd] No Caching mode page present
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.266230] sd 9:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:23:45 wfg-t420 kernel: [ 2405.266233] sd 9:0:0:0: [sdd] Attached SCSI removable disk
Mar  5 13:23:48 wfg-t420 kernel: [ 2408.563885] FAT-fs (sdd): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.906115] usb 1-1.1: USB disconnect, device number 8
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.906525] scsi 9:0:0:0: killing request
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.907220] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.907323] IP: [<ffffffffa00737e9>] sd_revalidate_disk+0x33/0x1603 [sd_mod]
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.907412] PGD 97c09067 PUD ba197067 PMD 0 
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.907452] Oops: 0000 [#1] SMP 
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.907484] CPU 3 
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.907500] Modules linked in: nls_utf8 nls_cp437 vfat fat uas usb_storage xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 xts gf128mul ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables acpi_cpufreq mperf cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conservative input_polldev bnep rfcomm binfmt_misc fuse tun kvm_intel kvm xfs ext3 jbd reiserfs dm_crypt aesni_intel cryptd aes_x86_64 aes_generic snd_hda_codec_hdmi snd_hda_codec_conexant joydev btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm uvcvideo snd_seq_midi videodev media hid_logitech_dj v4l2_compat_ioctl32 snd_rawmidi arc4 snd_seq_midi_event snd_seq iwlwifi tpm_tis psmouse snd_timer tpm mac
 80211 pcspkr serio_raw i2c_i801 evdev thinkpad_acpi snd_seq_device tpm_bios ac battery nvram power_supply cfg80211 snd i915 rfkill drm_kms_helper soundcore snd_page_alloc drm i2c_algo_bit iTCO_wdt i2c_core iTCO_vendor_support wmi
Mar  5 13:29:42 wfg-t420 kernel: video button processor ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c dm_mod raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sd_mod crc_t10dif usbhid hid ahci libahci libata firewire_ohci scsi_mod ehci_hcd firewire_core crc_itu_t sdhci_pci sdhci mmc_core thermal thermal_sys usbcore usb_common e1000e [last unloaded: scsi_wait_scan]
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.908740] 
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.908755] Pid: 13846, comm: hald-addon-stor Not tainted 3.2.0-1-amd64 #1 LENOVO 4236L56/4236L56
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.908827] RIP: 0010:[<ffffffffa00737e9>]  [<ffffffffa00737e9>] sd_revalidate_disk+0x33/0x1603 [sd_mod]
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.908905] RSP: 0018:ffff880097fe7af8  EFLAGS: 00010246
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.908945] RAX: 0000000000000000 RBX: ffff8800426dd980 RCX: 0000000000000001
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.908999] RDX: 0000000000000001 RSI: ffff880097d6b640 RDI: ffff8800ba143800
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909051] RBP: 0000000000000000 R08: 00000008ffffffff R09: ffff88008ffe88a0
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909103] R10: ffff88008ffe88a0 R11: ffff88008ffe88a0 R12: ffff8800ba143800
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909156] R13: 0000000000000000 R14: ffff8800426dd998 R15: ffff8800426dd980
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909210] FS:  00007faae3ef37a0(0000) GS:ffff88011e2c0000(0000) knlGS:0000000000000000
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909276] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909337] CR2: 0000000000000008 CR3: 00000000b3bf8000 CR4: 00000000000406e0
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909415] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909495] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909571] Process hald-addon-stor (pid: 13846, threadinfo ffff880097fe6000, task ffff88008ffe88a0)
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909662] Stack:
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909685]  ffff88011964b800 ffffffff8110bb0b ffffffff8168cb00 ffff8800ba143848
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909770]  0000000000000000 ffff8800ba143800 000000000000001d ffff8800426dd998
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909855]  ffff8800426dd980 ffff8800ba143800 ffff8800426dd980 ffff8800426dd980
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909950] Call Trace:
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.909986]  [<ffffffff8110bb0b>] ? iget5_locked+0x5c/0x127
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910068]  [<ffffffff8114717d>] ? rescan_partitions+0xac/0x41b
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910075]  [<ffffffff81120a84>] ? __blkdev_get+0x1a6/0x37e
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910094]  [<ffffffff81120f03>] ? blkdev_get+0x2a7/0x2a7
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910098]  [<ffffffff81120e23>] ? blkdev_get+0x1c7/0x2a7
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910102]  [<ffffffff81120f03>] ? blkdev_get+0x2a7/0x2a7
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910106]  [<ffffffff810f7392>] ? __dentry_open+0x19c/0x2b3
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910110]  [<ffffffff81100748>] ? dget+0x12/0x1e
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910113]  [<ffffffff81103742>] ? do_last+0x552/0x58c
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910116]  [<ffffffff81103d74>] ? path_openat+0xce/0x31c
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910131]  [<ffffffffa00acfb1>] ? ioctl_internal_command.constprop.4+0x62/0x15c [scsi_mod]
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910136]  [<ffffffff81104084>] ? do_filp_open+0x2a/0x6e
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910143]  [<ffffffff8133f50f>] ? _cond_resched+0x7/0x1c
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910148]  [<ffffffff811b0f49>] ? __strncpy_from_user+0x18/0x48
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910152]  [<ffffffff8110cd2b>] ? alloc_fd+0x64/0x109
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910156]  [<ffffffff810f8254>] ? do_sys_open+0x5e/0xe5
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910161]  [<ffffffff813457d2>] ? system_call_fastpath+0x16/0x1b
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910164] Code: 55 53 48 81 ec 88 00 00 00 48 8b af 38 03 00 00 65 48 8b 04 25 28 00 00 00 48 89 44 24 78 31 c0 8b 05 1c 9b 05 00 48 89 7c 24 48 <4c> 8b 7d 08 c1 e8 15 83 e0 07 83 f8 03 76 43 48 8b 8d 88 02 00 
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910194] RIP  [<ffffffffa00737e9>] sd_revalidate_disk+0x33/0x1603 [sd_mod]
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910206]  RSP <ffff880097fe7af8>
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.910208] CR2: 0000000000000008
Mar  5 13:29:42 wfg-t420 kernel: [ 2761.983071] ---[ end trace f521706016199557 ]---
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.121024] usb 1-1.1: new full-speed USB device number 9 using ehci_hcd
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.215163] usb 1-1.1: New USB device found, idVendor=0421, idProduct=002d
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.215169] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.215172] usb 1-1.1: Product: Nokia 6120 classic
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.215174] usb 1-1.1: Manufacturer: Nokia
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.215176] usb 1-1.1: SerialNumber: 359807018700505
Mar  5 13:29:42 wfg-t420 kernel: [ 2762.216286] scsi10 : usb-storage 1-1.1:1.0
Mar  5 13:29:43 wfg-t420 kernel: [ 2762.494045] usb 1-1.1: USB disconnect, device number 9
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.457990] usb 1-1.1: new full-speed USB device number 10 using ehci_hcd
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.552227] usb 1-1.1: New USB device found, idVendor=0421, idProduct=002d
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.552232] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.552235] usb 1-1.1: Product: Nokia 6120 classic
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.552237] usb 1-1.1: Manufacturer: Nokia
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.552239] usb 1-1.1: SerialNumber: 359807018700505
Mar  5 13:29:44 wfg-t420 kernel: [ 2763.553231] scsi11 : usb-storage 1-1.1:1.0
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.548647] scsi 11:0:0:0: Direct-Access     Nokia    S60              1.0  PQ: 0 ANSI: 0
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.550847] sd 11:0:0:0: [sdd] Adjusting the sector count from its reported value: 3987209
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.550854] sd 11:0:0:0: [sdd] 3987208 512-byte logical blocks: (2.04 GB/1.90 GiB)
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.551589] sd 11:0:0:0: [sdd] Write Protect is off
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.551593] sd 11:0:0:0: [sdd] Mode Sense: 03 00 00 00
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.553627] sd 11:0:0:0: [sdd] No Caching mode page present
Mar  5 13:29:45 wfg-t420 kernel: [ 2764.553632] sd 11:0:0:0: [sdd] Assuming drive cache: write through
Mar  5 13:30:35 wfg-t420 kernel: [ 2814.560199] SysRq : Emergency Sync
Mar  5 13:30:37 wfg-t420 kernel: [ 2816.768298] Emergency Sync complete
