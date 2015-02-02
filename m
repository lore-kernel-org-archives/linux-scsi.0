From: Athlion <athlion@gmail.com>
Subject: Kernel Ooops upon USB disconnect of a Western Digital My Passport 1TB drive
Date: Mon, 2 Feb 2015 13:48:47 +0200
Message-ID: <CACfp430CWfCifjb-u6mAyErPxt2x9O45K9+m_=4hMzy_1MjrvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41278 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbBBLtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 06:49:09 -0500
Received: by mail-la0-f52.google.com with SMTP id ge10so39905208lab.11
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2015 03:49:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all.

On my Thunkpad T420i with 3.18.2 (possibly earlier as well but
definitely not 3.17.6), 3.18.3, 3.18.4 and 3.18.5 kernels, I can
reproduce the following behaviour 100% of the time:

1. Connect one of my (NTFS-formatted) WD 1TB 'My Passport' drives via USB.
2. Disconnect the cable.
3. Kernel Ooops.

Please note that the drive need not be mounted at all. In fact, this
even happens if I stop all graphical and automount services and
plug-in and then disconnect the cable. Also, other USB drives and USB
flash disks do not exhibit this behaviour... Go figure!

The oops as caught and reported by netconsole is the following:

[  169.827703] usb 2-1.2: new high-speed USB device number 3 using ehci-pci
[  169.980222] usb-storage 2-1.2:1.0: USB Mass Storage device detected
[  169.982264] scsi host6: usb-storage 2-1.2:1.0
[  169.984548] usbcore: registered new interface driver usb-storage
[  169.989296] usbcore: registered new interface driver uas
[  170.989458] scsi 6:0:0:0: Direct-Access     WD       My Passport
0748 1016 PQ: 0 ANSI: 6
[  170.992673] scsi 6:0:0:1: Enclosure         WD       SES Device
  1016 PQ: 0 ANSI: 6
[  171.002766] sd 6:0:0:0: [sdb] Spinning up disk...
[  172.009278] .ready
[  173.012719] sd 6:0:0:0: [sdb] 1953458176 512-byte logical blocks:
(1.00 TB/931 GiB)
[  173.016434] sd 6:0:0:0: [sdb] Write Protect is off
[  173.017780] ses 6:0:0:1: Attached Enclosure device
[  173.021519] sd 6:0:0:0: [sdb] Mode Sense: 47 00 10 08
[  173.024736] sd 6:0:0:0: [sdb] No Caching mode page found
[  173.026785] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  173.040339]  sdb: sdb1
[  173.045652] sd 6:0:0:0: [sdb] Attached SCSI disk
[  183.706124] usb 2-1.2: USB disconnect, device number 3
[  183.725921] BUG: unable to handle kernel NULL pointer dereference
at 00000000000001a0
[  183.728560] IP: [<ffffffff812850d5>] blk_post_runtime_resume+0x65/
0x80
[  183.730820] PGD 0
[  183.733038] Oops: 0002 [#1] PREEMPT SMP
[  183.735285] Modules linked in: ses enclosure uas usb_storage
netconsole joydev mousedev snd_hda_codec_hdmi snd_hda_codec_conexant
snd_hda_codec_generic coretemp arc4 intel_rapl x86_pkg_temp_thermal
intel_powerclamp kvm_intel iwldvm kvm mac80211 crct10dif_pclmul
crc32_pclmul crc32c_intel iTCO_wdt iTCO_vendor_support
ghash_clmulni_intel aesni_intel iwlwifi aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd psmouse serio_raw i2c_i801 cfg80211
ip6t_REJECT nf_reject_ipv6 thinkpad_acpi wmi nvram xt_hl rfkill
ip6t_rt hwmon battery ac snd_hda_intel tpm_tis snd_hda_controller tpm
snd_hda_codec snd_hwdep nf_conntrack_ipv6 snd_pcm nf_defrag_ipv6 evdev
snd_timer e1000e snd thermal mac_hid mei_me soundcore mei ptp
ipt_REJECT lpc_ich nf_reject_ipv4 pps_core shpchp processor xt_limit
xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
e1000e snd thermal mac_hid mei_me soundcore mei ptp ipt_REJECT lpc_ich
nf_reject_ipv4 pps_core shpchp processor xt_limit xt_tcpudp
xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
iptable_filter ip_tables x_tables sch_fq_codel vboxdrv(O) usbnet mii
tp_smapi(O) thinkpad_ec(O) nfs lockd grace sunrpc fscache
cpufreq_powersave acpi_call(O) ext4 crc16 mbcache jbd2 sd_mod atkbd
libps2 sdhci_pci sdhci led_class ahci libahci libata ehci_pci ehci_hcd
scsi_mod mmc_core usbcore usb_common i8042 serio i915 button intel_gtt
i2c_algo_bit video drm_kms_helper drm i2c_core
[  183.981709] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G     UD O
3.18.5-1-ARCH #1
[  183.985915] Hardware name: LENOVO 4177CTO/4177CTO, BIOS 83ET70WW
(1.40 ) 06/12/2012
[  183.990082] task: ffff880212941e30 ti: ffff88021296c000 task.ti:
ffff88021296c000
[  183.994203] RIP: 0010:[<ffffffff81091500>] [<ffffffff81091500>]
kthread_data+0x10/0x20
[  183.998426] RSP: 0018:ffff88021296f3e8  EFLAGS: 00010092
[  184.002645] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  184.006893] RDX: 000000000000000f RSI: 0000000000000000 RDI: ffff880212941e30
[  184.011063] RBP: ffff88021296f3e8 R08: 0000000000000000 R09: ffff880215803a00
[  184.015247] R10: ffff88021e216480 R11: ffffea000846fc40 R12: ffff88021e213640
[  184.019428] R13: ffff88021e213640 R14: ffff880212941e30 R15: 0000000000000000
[  184.023591] FS:  0000000000000000(0000) GS:ffff88021e200000(0000)
knlGS:0000000000000000
[  184.027820] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  184.032041] CR2: 0000000000000028 CR3: 0000000001811000 CR4: 00000000000407f0
[  184.036227] Stack:
[  184.040518]  ffff88021296f408 ffffffff8108c275 ffff88021296f408
0000000000000000
[  184.044910]  ffff88021296f528 ffffffff81550f55 ffff880212941e30
0000000000013640
[  184.235199]  [<ffffffff815552fc>] ret_from_fork+0x7c/0xb0
[  184.237699]  [<ffffffff81090d50>] ? kthread_create_on_node+0x1c0/0x1c0
[  184.240179] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01

What can I do to further debug this?
