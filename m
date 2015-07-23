From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101841] New: iommu memory handling cause mmblock devices stop
 working
Date: Thu, 23 Jul 2015 09:10:48 +0000
Message-ID: <bug-101841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbbGWJKx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jul 2015 05:10:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE76F20651
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 09:10:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 11FDC2073C
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 09:10:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101841

            Bug ID: 101841
           Summary: iommu memory handling cause mmblock devices stop
                    working
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.0.x, 4.1.x
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: dront78@gmail.com
        Regression: No

copying from transcend 16Gb sdhc I card on laptop slowdowns after 100-300Mb

dmesg repeatedly spam about 

[  336.101876] DMA: Out of SW-IOMMU space for 65536 bytes at device
0000:16:00.0
[  336.106637] DMA: Out of SW-IOMMU space for 65536 bytes at device
0000:16:00.0
[  336.106637] ------------[ cut here ]------------
[  336.106637] WARNING: CPU: 2 PID: 0 at drivers/mmc/host/sdhci.c:856
sdhci_send_command+0x8e4/0xc30 [sdhci]()
[  336.106637] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat mmc_block
fuse xt_multiport xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
v4l2_common videodev media joydev arc4 brcmsmac nvidia(PO) cordic brcmutil
mac80211 cfg80211 snd_hda_codec_hdmi rfkill r8169 mousedev ir_lirc_codec drm
snd_hda_codec_realtek snd_hda_codec_generic lirc_dev snd_hda_intel
snd_hda_controller evdev mac_hid snd_hda_codec snd_hda_core mii bcma
ir_rc6_decoder ir_sanyo_decoder ir_nec_decoder jmb38x_ms i2c_core
ir_sharp_decoder ir_mce_kbd_decoder
[  336.106637]  ir_jvc_decoder ir_rc5_decoder ir_xmp_decoder ir_sony_decoder
memstick rc_rc6_mce ene_ir rc_core coretemp crc32c_intel snd_hwdep psmouse
snd_pcm snd_timer snd serio_raw toshiba_haps toshiba_bluetooth mei_me soundcore
mei shpchp battery ac video button sch_fq_codel msr sparse_keymap loop
kvm_intel kvm cpuid cpufreq_stats cpufreq_userspace cpufreq_conservative
cpufreq_powersave acpi_cpufreq processor ip_tables x_tables ext4 crc16 mbcache
jbd2 sr_mod cdrom sd_mod atkbd libps2 ahci libahci libata scsi_mod ehci_pci
ehci_hcd sdhci_pci sdhci led_class usbcore mmc_core usb_common i8042 serio lz4
lz4_compress
[  336.106637] CPU: 2 PID: 0 Comm: swapper/2 Tainted: P        W  O   
4.1.2-2-ARCH #1
[  336.106637] Hardware name: TOSHIBA Satellite A660/NWQAA, BIOS 1.60 07/23/10
[  336.106637]  0000000000000000 1c0fa02e044d6e83 ffff88023bc83d18
ffffffff81585c8e
[  336.106637]  0000000000000000 0000000000000000 ffff88023bc83d58
ffffffff81078c9a
[  336.106637]  ffff880231cff4c0 ffff880231cff4c0 ffff88020fcf8290
ffff88020fcf8310
[  336.106637] Call Trace:
[  336.106637]  <IRQ>  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
[  336.106637]  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
[  336.106637]  [<ffffffff81078dca>] warn_slowpath_null+0x1a/0x20
[  336.106637]  [<ffffffffa004f0b4>] sdhci_send_command+0x8e4/0xc30 [sdhci]
[  336.106637]  [<ffffffff810ec6f7>] ? ktime_get+0x37/0xb0
[  336.106637]  [<ffffffffa004fe3c>] sdhci_finish_command+0x15c/0x170 [sdhci]
[  336.106637]  [<ffffffffa0050249>] sdhci_irq+0x329/0x990 [sdhci]
[  336.106637]  [<ffffffff810e6359>] ? enqueue_hrtimer+0x29/0xa0
[  336.106637]  [<ffffffff810d4d9e>] handle_irq_event_percpu+0x3e/0x1f0
[  336.106637]  [<ffffffff810d4f91>] handle_irq_event+0x41/0x70
[  336.106637]  [<ffffffff810d8212>] handle_fasteoi_irq+0x82/0x130
[  336.106637]  [<ffffffff810181a2>] handle_irq+0x22/0x40
[  336.106637]  [<ffffffff8158e08f>] do_IRQ+0x4f/0xf0
[  336.106637]  [<ffffffff8158c0ae>] common_interrupt+0x6e/0x6e
[  336.106637]  <EOI>  [<ffffffff8143f40f>] ? cpuidle_enter_state+0x8f/0x240
[  336.106637]  [<ffffffff8143f3e4>] ? cpuidle_enter_state+0x64/0x240
[  336.106637]  [<ffffffff8143f5f7>] cpuidle_enter+0x17/0x20
[  336.106637]  [<ffffffff810bccac>] cpu_startup_entry+0x31c/0x450
[  336.106637]  [<ffffffff81050066>] start_secondary+0x196/0x1e0
[  336.106637] ---[ end trace 9cf1bf48caa4616d ]---

swiotlb=131072 make it works a bit longer. just about 1Gb without such logs,
but than return back to error state

GRUB_CMDLINE_LINUX="resume=/dev/sda2 nomodeset notsc clocksource=acpi_pm
nmi_watchdog=0 numa=off fastboot usbhid.mousepoll=2
init=/usr/lib/systemd/systemd enable_mtrr_cleanup intel_pstate=disable
zswap.enabled=1 zswap.max_pool_percent=27 zswap.compressor=lz4
drm.vblankoffdelay=1 audit=0 pcie_aspm=powersave pcie_ports=native
drm_kms_helper.poll=0 intel_iommu=on swiotlb=131072"

-- 
You are receiving this mail because:
You are the assignee for the bug.
