From: Athlion <athlion@gmail.com>
Subject: Re: Kernel Ooops upon USB disconnect of a Western Digital My Passport
 1TB drive
Date: Tue, 3 Feb 2015 10:37:02 +0200
Message-ID: <CACfp432Vqiu2eeMyYupdkMxs=bNN83ayMgiDrZic54VjhM6aZw@mail.gmail.com>
References: <CACfp432AcTBGOdjLhb_id6j6TFdLPav9oofO3Qoibm3QL75eNA@mail.gmail.com>
 <Pine.LNX.4.44L0.1502021127110.1566-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:45936 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbbBCIhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 03:37:24 -0500
In-Reply-To: <Pine.LNX.4.44L0.1502021127110.1566-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Feb 2, 2015 at 7:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> Had you made any changes to the runtime suspend settings?
> blk_post_runtime_resume wouldn't be called unless the drive had gone
> into runtime suspend.  And even then, it's not likely to be called
> after you unplug the USB cable.
>
> Alan Stern

I have enabled SCSI ATA Bus power management with this udev rule:
ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*",
ATTR{link_power_management_policy}="min_power"
( And generally almost all of actions herein:
https://wiki.archlinux.org/index.php/Power_saving#Laptop_Mode )

Here's another with dynamic debugging on (and some of the stack trace):

[ 1565.610481] usb usb2: usb wakeup-resume
[ 1565.613019] usb usb2: usb auto-resume
[ 1565.615599] hub 2-0:1.0: hub_resume
[ 1565.617876] usb usb2-port1: status 0507 change 0000
[ 1565.620125] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 1565.623471] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 1565.650219] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0002
[ 1565.663520] usb 2-1: usb wakeup-resume
[ 1565.665518] usb 2-1: finish resume
[ 1565.667684] hub 2-1:1.0: hub_resume
[ 1565.669812] usb 2-1-port2: status 0101 change 0001
[ 1565.773645] usb usb2-port1: resume, status 0
[ 1565.776031] hub 2-1:1.0: state 7 ports 8 chg 0004 evt 0000
[ 1565.778664] usb 2-1-port2: status 0101, change 0000, 12 Mb/s
[ 1565.847291] usb 2-1.2: new high-speed USB device number 3 using ehci-pci
[ 1565.860480] usb 2-1-port2: not reset yet, waiting 10ms
[ 1565.945202] usb 2-1.2: default language 0x0409
[ 1565.947882] usb 2-1.2: udev 3, busnum 2, minor = 130
[ 1565.950384] usb 2-1.2: usb_probe_device
[ 1565.952704] usb 2-1.2: configuration #1 chosen from 1 choice
[ 1565.955145] usb 2-1.2: adding 2-1.2:1.0 (config #1, interface 0)
[ 1565.957630] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
[ 1566.005124] usb-storage 2-1.2:1.0: usb_probe_interface
[ 1566.006655] usb-storage 2-1.2:1.0: usb_probe_interface - got id
[ 1566.008169] usb-storage 2-1.2:1.0: USB Mass Storage device detected
[ 1566.010155] scsi host6: usb-storage 2-1.2:1.0
[ 1566.012149] usbcore: registered new interface driver usb-storage
[ 1566.016061] usbcore: registered new interface driver uas
[ 1567.015852] scsi 6:0:0:0: Direct-Access     WD       My Passport
0748 1016 PQ: 0 ANSI: 6
[ 1567.018966] scsi 6:0:0:1: Enclosure         WD       SES Device
  1016 PQ: 0 ANSI: 6
[ 1567.027072] scsi 6:0:0:1: scsi_runtime_idle
[ 1567.029695] sd 6:0:0:0: [sdb] Spinning up disk...
[ 1567.032764] scsi 6:0:0:1: scsi_runtime_suspend
[ 1568.031907] .ready
[ 1569.060225] sd 6:0:0:0: [sdb] 1953458176 512-byte logical blocks:
(1.00 TB/931 GiB)
[ 1569.063857] sd 6:0:0:0: [sdb] Write Protect is off
[ 1569.065613] ses 6:0:0:1: Attached Enclosure device
[ 1569.068492] sd 6:0:0:0: [sdb] Mode Sense: 47 00 10 08
[ 1569.071598] sd 6:0:0:0: [sdb] No Caching mode page found
[ 1569.073628] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 1569.087891]  sdb: sdb1
[ 1569.093382] sd 6:0:0:0: [sdb] Attached SCSI disk
[ 1615.830142] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
[ 1615.833066] usb 2-1-port2: status 0100, change 0001, 12 Mb/s
[ 1615.835764] usb 2-1.2: USB disconnect, device number 3
[ 1615.838471] usb 2-1.2: unregistering device
[ 1615.841199] usb 2-1.2: unregistering interface 2-1.2:1.0
[ 1615.844996] scsi target6:0:0: scsi_runtime_idle
[ 1615.848746] scsi target6:0:0: scsi_runtime_suspend
[ 1615.868925] scsi target6:0:0: scsi_runtime_resume
[ 1615.870975] ses 6:0:0:1: scsi_runtime_resume
[ 1615.872913] BUG: unable to handle kernel NULL pointer dereference
at 00000000000001a0
[ 1615.874896] IP: [<ffffffff812850d5>] blk_post_runtime_resume+0x65/0x80
[ 1615.876843] PGD 0
[ 1615.878765] Oops: 0002 [#1] PREEMPT SMP
[ 1615.880734] Modules linked in: ses enclosure uas usb_storage
netconsole joydev mousedev snd_hda_codec_hdmi snd_hda_codec_conexant
snd_hda_codec_generic coretemp intel_rapl x86_pkg_temp_thermal
intel_powerclamp kvm_intel kvm arc4 crct10dif_pclmul iwldvm
crc32_pclmul iTCO_wdt iTCO_vendor_support crc32c_intel mac80211
ghash_clmulni_intel ip6t_REJECT nf_reject_ipv6 aesni_intel xt_hl
aes_x86_64 lrw gf128mul ip6t_rt psmouse iwlwifi glue_helper
ablk_helper cryptd i2c_i801 serio_raw cfg80211 nf_conntrack_ipv6
nf_defrag_ipv6 snd_hda_intel wmi thinkpad_acpi nvram thermal rfkill
ipt_REJECT nf_reject_ipv4 hwmon tpm_tis ac tpm battery
snd_hda_controller snd_hda_codec snd_hwdep evdev snd_pcm mac_hid
xt_limit e1000e snd_timer xt_tcpudp mei_me snd mei ptp soundcore
shpchp pps_core lpc_ich processor xt_addrtype nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack at ffffffffffffffd8
[ 1616.064883] IP: [<ffffffff81091500>] kthread_data+0x10/0x20
[ 1616.068189] PGD 1814067 PUD 1816067 PMD 0
[ 1616.071462] Oops: 0000 [#2] PREEMPT SMP
[ 1616.074719] Modules linked in: ses enclosure uas usb_storage
netconsole joydev mousedev snd_hda_codec_hdmi snd_hda_codec_conexant
snd_hda_codec_generic coretemp intel_rapl x86_pkg_temp_thermal
intel_powerclamp kvm_intel kvm arc4 crct10dif_pclmul iwldvm
crc32_pclmul iTCO_wdt iTCO_vendor_support crc32c_intel mac80211
ghash_clmulni_intel ip6t_REJECT nf_reject_ipv6 aesni_intel xt_hl
aes_x86_64 lrw gf128mul ip6t_rt psmouse iwlwifi glue_helper
ablk_helper cryptd i2c_i801 serio_raw cfg80211 nf_conntrack_ipv6
nf_defrag_ipv6 snd_hda_intel wmi thinkpad_acpi nvram thermal rfkill
ipt_REJECT nf_reject_ipv4 hwmon tpm_tis ac tpm battery
snd_hda_controller snd_hda_codec snd_hwdep evdev snd_pcm mac_hid
xt_limit e1000e snd_timer xt_tcpudp mei_me snd mei ptp soundcore
shpchp pps_core lpc_ich processor xt_addrtype nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter ehci_pci led_class
ehci_hcd mmc_core usbcore usb_common i8042 serio i915 button intel_gtt
i2c_algo_bit video drm_kms_helper drm i2c_core
[ 1616.102986] CPU: 0 PID: 6951 Comm: kworker/0:0 Tainted: G UD    O
3.18.5-1-ARCH #1
[ 1616.107209] Hardware name: LENOVO 4177CTO/4177CTO, BIOS 83ET70WW
(1.40 ) 06/12/2012
[ 1616.111411] task: ffff8800d5e62840 ti: ffff8800cbc0c000 task.ti:
ffff8800cbc0c000
[ 1616.115629] RIP: 0010:[<ffffffff81091500>] [<ffffffff81091500>]
kthread_data+0x10/0x20
[ 1616.119869] RSP: 0018:ffff8800cbc0f3e8  EFLAGS: 00010092
[ 1616.124122] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1616.128400] RDX: 000000000000000f RSI: 0000000000000000 RDI: ffff8800d5e62840
[ 1616.132600] RBP: ffff8800cbc0f3e8 R08: 0000000000000000 R09: ffff88021583e600
[ 1616.136818] R10: ffff88021e216c60 R11: ffffea00032f6000 R12: ffff88021e213640
[ 1616.141026] R13: ffff88021e213640 R14: ffff8800d5e62840 R15: 0000000000000000
[ 1616.145204] FS:  0000000000000000(0000) GS:ffff88021e200000(0000)
knlGS:0000000000000000
[ 1616.149444] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1616.153723] CR2: 0000000000000028 CR3: 0000000001811000 CR4: 00000000000407f0
[ 1616.157994] Stack:
[ 1616.162279]  ffff8800cbc0f408 ffffffff8108c275 ffff8800cbc0f408
0000000000000000
[ 1616.166656]  ffff8800cbc0f528 ffffffff81550f55[ 1616.309784]
[<ffffffff813c4f63>] ? rpm_idle+0x23/0x340
[ 1616.313120]  [<ffffffff813bb28f>] __device_release_driver+0x7f/0xf0
[ 1616.316368]  [<ffffffff813bb323>] device_release_driver+0x23/0x30
[ 1616.319434]  [<ffffffff813babd8>] bus_remove_device+0x108/0x180
[ 1616.322384]  [<ffffffff813b6f19>] device_del+0x129/0x1f0
[ 1616.325183]  [<ffffffffa01b2d81>] usb_disable_device+0x91/0x290 [usbcore]
[ 1616.327934]  [<ffffffffa01a81b4>] usb_disconnect+0x94/0x2d0 [usbcore]
[ 1616.330617]  [<ffffffffa01aa3fa>] hub_event+0x66a/0x1640 [usbcore]
[ 1616.333259]  [<ffffffff81550bd8>] ? __schedule+0x3e8/0xa50
[ 1616.335908]  [<ffffffff8108b815>] process_one_work+0x145/0x400
[ 1616.338492]  [<ffffffff8108bddb>] worker_thread+0x6b/0x480
[ 1616.341075]  [<ffffffff8108bd70>] ? init_pwq.part.22+0x10/0x10
[ 1616.343573]  [<ffffffff81090e3a>] kthread+0xea/0x100
[ 1616.346135]  [<ffffffff81090d50>] ? kthread_create_on_node+0x1c0/0x1c0
[ 1616.348738]  [<ffffffff815552fc>] ret_from_fork+0x7c/0xb0
[ 1616.351304]  [<ffffffff81090d50>] ? kthread_create_on_node+0x1c0/0x1c0
[ 1616.353876] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 f0
