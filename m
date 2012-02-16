From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] New: Kernel ooops when disconnecting the USB flash disk,
 in which I've just modified partition table
Date: Thu, 16 Feb 2012 14:50:35 GMT
Message-ID: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:60940 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2BPOuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 09:50:35 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1GEoZuf032176
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2012 14:50:35 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783

           Summary: Kernel ooops when disconnecting the USB flash disk, in
                    which I've just modified partition table
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.2.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: wzab@ise.pw.edu.pl
        Regression: No


I have added the "boot" flag to the /dev/sdb1 partition in the flash disk.
After that I ran the "sync" command, and after a few seconds I have unplugged
the USB stick from the PC. It resulted in the ooops report shown below:


Feb 16 15:33:31 WZLap kernel: [ 4477.732803] scsi 7:0:0:0: Direct-Access    
Kingston DataTraveler 2.0 PMAP PQ: 0 ANSI: 0 CCS
Feb 16 15:33:32 WZLap kernel: [ 4477.976629] sd 7:0:0:0: [sdb] 1953792 512-byte
logical blocks: (1.00 GB/954 MiB)
Feb 16 15:33:32 WZLap kernel: [ 4477.977198] sd 7:0:0:0: [sdb] Write Protect is
off
Feb 16 15:33:32 WZLap kernel: [ 4477.981242]  sdb: sdb1
Feb 16 15:33:32 WZLap kernel: [ 4477.983462] sd 7:0:0:0: [sdb] Attached SCSI
removable disk
Feb 16 15:37:23 WZLap kernel: [ 4709.469769]  sdb: sdb1
Feb 16 15:38:00 WZLap kernel: [ 4745.877869] FAT-fs (sdb1): utf8 is not a
recommended IO charset for FAT filesystems, filesystem will be case sensitive!
Feb 16 15:42:06 WZLap kernel: [ 4991.280695]  sdb: sdb1
Feb 16 15:42:36 WZLap kernel: [ 5021.465121] usb 4-1.3: USB disconnect, device
number 4
Feb 16 15:42:36 WZLap kernel: [ 5021.465800] scsi 7:0:0:0: killing request
Feb 16 15:42:36 WZLap kernel: [ 5021.466008] PGD 1b9242067 PUD 1b3401067 PMD 0 
Feb 16 15:42:36 WZLap kernel: [ 5021.466093] CPU 3 
Feb 16 15:42:36 WZLap kernel: [ 5021.466110] Modules linked in: nls_utf8
nls_cp437 vfat fat snd_hrtimer tun ebtable_nat ebtables acpi_cpufreq mperf
cpufreq_conservative cpufreq_userspace cpufreq_stats cpufreq_powersave ipx
p8023 hidp hid parport_pc ppdev lp parport rfcomm bnep binfmt_misc uinput fuse
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc kvm_intel kvm ip6table_filter
ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp
xt_owner iptable_filter ip_tables x_tables loop sha256_generic cryptd
aes_x86_64 aes_generic cbc dm_crypt snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep joydev snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event uvcvideo arc4 snd_seq snd_timer snd_seq_device
snd videodev media v4l2_compat_ioctl32 iwlwifi i915 nouveau ttm drm_kms_helper
drm dell_laptop mac80211 soundcore snd_page_alloc btusb psmouse(O) bluetooth
dell_wmi cfg80211 pcspkr mxm_wmi intel_agp i2c_algo_bit intel_gtt agpgart
iTCO_wdt dcdbas i2c_i801 sparse_keymap i
Feb 16 15:42:36 WZLap kernel: 2c_core serio_raw evdev iTCO_vendor_support
rfkill battery button ac power_supply wmi processor video ext4 mbcache jbd2
crc16 dm_mod sr_mod sd_mod cdrom crc_t10dif ums_realtek usb_storage uas ahci
libahci libata xhci_hcd r8169 ehci_hcd mii scsi_mod usbcore usb_common thermal
thermal_sys [last unloaded: scsi_wait_scan]
Feb 16 15:42:36 WZLap kernel: [ 5021.467497] 
Feb 16 15:42:36 WZLap kernel: [ 5021.467523] Pid: 3826, comm: hald-addon-stor
Tainted: G           O 3.2.2 #1 Dell Inc.          Dell System Vostro
3750/0VP036
Feb 16 15:42:36 WZLap kernel: [ 5021.467673] RIP: 0010:[<ffffffffa00bf7f4>] 
[<ffffffffa00bf7f4>] sd_revalidate_disk+0x39/0x1603 [sd_mod]
Feb 16 15:42:36 WZLap kernel: [ 5021.467802] RSP: 0018:ffff8801b35c3ae8 
EFLAGS: 00010246
Feb 16 15:42:36 WZLap kernel: [ 5021.467866] RAX: 0000000000000000 RBX:
ffff880230fd4080 RCX: 0000000000000002
Feb 16 15:42:36 WZLap kernel: [ 5021.467945] RDX: 0000000000000002 RSI:
ffff8802310e38c0 RDI: ffff8801d1e3d000
Feb 16 15:42:36 WZLap kernel: [ 5021.468030] RBP: 0000000000000000 R08:
00000008ffffffff R09: 0000000000000005
Feb 16 15:42:36 WZLap kernel: [ 5021.468114] R10: dead000000200200 R11:
dead000000200200 R12: ffff8801d1e3d000
Feb 16 15:42:36 WZLap kernel: [ 5021.468195] R13: 0000000000000000 R14:
ffff880230fd4098 R15: ffff880230fd4080
Feb 16 15:42:36 WZLap kernel: [ 5021.468263] FS:  00007faf5642b7a0(0000)
GS:ffff88023fac0000(0000) knlGS:0000000000000000
Feb 16 15:42:36 WZLap kernel: [ 5021.468360] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb 16 15:42:36 WZLap kernel: [ 5021.468430] CR2: 0000000000000008 CR3:
0000000211fe5000 CR4: 00000000000406e0
Feb 16 15:42:36 WZLap kernel: [ 5021.468518] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb 16 15:42:36 WZLap kernel: [ 5021.468606] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb 16 15:42:36 WZLap kernel: [ 5021.468696] Process hald-addon-stor (pid:
3826, threadinfo ffff8801b35c2000, task ffff8801b9166a10)
Feb 16 15:42:36 WZLap kernel: [ 5021.468824]  ffff8801b35c3b44 ffffffff8110dfcf
dead000000200200 ffffffff8103dbd5
Feb 16 15:42:36 WZLap kernel: [ 5021.468928]  0000000000000001 ffffffff8133677d
0000000000000000 ffffffff81333cf0
Feb 16 15:42:36 WZLap kernel: [ 5021.469034]  ffff8801b35c3b44 ffff8801d1e3d000
ffff880230fd4080 ffff880230fd4080
Feb 16 15:42:36 WZLap kernel: [ 5021.469185]  [<ffffffff8110dfcf>] ?
iget5_locked+0x61/0x13e
Feb 16 15:42:36 WZLap kernel: [ 5021.469261]  [<ffffffff8103dbd5>] ?
get_parent_ip+0x9/0x1b
Feb 16 15:42:36 WZLap kernel: [ 5021.469336]  [<ffffffff8133677d>] ?
sub_preempt_count+0x83/0x94
Feb 16 15:42:36 WZLap kernel: [ 5021.469416]  [<ffffffff81333cf0>] ?
_raw_spin_unlock+0x23/0x2f
Feb 16 15:42:36 WZLap kernel: [ 5021.469496]  [<ffffffff81149eeb>] ?
rescan_partitions+0xac/0x419
Feb 16 15:42:36 WZLap kernel: [ 5021.469578]  [<ffffffff811235fb>] ?
__blkdev_get+0x1a6/0x37e
Feb 16 15:42:36 WZLap kernel: [ 5021.469665]  [<ffffffff81123a8d>] ?
blkdev_get+0x2ba/0x2ba
Feb 16 15:42:36 WZLap kernel: [ 5021.469736]  [<ffffffff811239a3>] ?
blkdev_get+0x1d0/0x2ba
Feb 16 15:42:36 WZLap kernel: [ 5021.469807]  [<ffffffff8103dbd5>] ?
get_parent_ip+0x9/0x1b
Feb 16 15:42:36 WZLap kernel: [ 5021.469881]  [<ffffffff8133677d>] ?
sub_preempt_count+0x83/0x94
Feb 16 15:42:36 WZLap kernel: [ 5021.469956]  [<ffffffff81333cf0>] ?
_raw_spin_unlock+0x23/0x2f
Feb 16 15:42:36 WZLap kernel: [ 5021.470036]  [<ffffffff81123a8d>] ?
blkdev_get+0x2ba/0x2ba
Feb 16 15:42:36 WZLap kernel: [ 5021.470110]  [<ffffffff810f90d8>] ?
__dentry_open+0x231/0x351
Feb 16 15:42:36 WZLap kernel: [ 5021.470181]  [<ffffffff811026a2>] ?
dget+0x22/0x29
Feb 16 15:42:36 WZLap kernel: [ 5021.470239]  [<ffffffff81105d73>] ?
do_last+0x552/0x58c
Feb 16 15:42:36 WZLap kernel: [ 5021.470294]  [<ffffffff81105ea2>] ?
path_openat+0xce/0x31c
Feb 16 15:42:36 WZLap kernel: [ 5021.470339]  [<ffffffff811061b2>] ?
do_filp_open+0x2a/0x6e
Feb 16 15:42:36 WZLap kernel: [ 5021.470385]  [<ffffffff8103dbd5>] ?
get_parent_ip+0x9/0x1b
Feb 16 15:42:36 WZLap kernel: [ 5021.470434]  [<ffffffff8133677d>] ?
sub_preempt_count+0x83/0x94
Feb 16 15:42:36 WZLap kernel: [ 5021.470483]  [<ffffffff81333cf0>] ?
_raw_spin_unlock+0x23/0x2f
Feb 16 15:42:36 WZLap kernel: [ 5021.470529]  [<ffffffff8110f317>] ?
alloc_fd+0x109/0x11b
Feb 16 15:42:36 WZLap kernel: [ 5021.470573]  [<ffffffff810f9fdd>] ?
do_sys_open+0x5e/0xe5
Feb 16 15:42:36 WZLap kernel: [ 5021.470617]  [<ffffffff81338312>] ?
system_call_fastpath+0x16/0x1b
Feb 16 15:42:36 WZLap kernel: [ 5021.477498]  RSP <ffff8801b35c3ae8>
Feb 16 15:42:36 WZLap kernel: [ 5021.544336] ---[ end trace d653b87055b29f7a
]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
