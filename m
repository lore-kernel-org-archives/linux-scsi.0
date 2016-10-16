From: ojab <ojab@ojab.ru>
Subject: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237
 sysfs_remove_group+0xa0/0xb0'
Date: Sun, 16 Oct 2016 14:33:28 +0000
Message-ID: <d24894f9-5943-a962-6614-9a199e563dd1@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32847 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753709AbcJPOeJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2016 10:34:09 -0400
Received: by mail-lf0-f67.google.com with SMTP id l131so18849722lfl.0
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2016 07:33:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org

Oh hai!

I have LSI SAS 9217-8i HBA and `rmmod mpt3sas` leads to multiple 
backtraces if any disks are connected to the HBA.
Reproducible on vanilla 4.7.5/4.8.1/4.9-rc1 kernels (haven't tested on 
another versions).

Full output (4.9-rc1 kernel, 3*Seagate ST3000NM0023 drives are 
connected) is rather long and can be found here: 
https://gist.github.com/ojab/f21ff778a378e88b227a4253d683c6ca

First backtrace for the reference:

Oct 16 13:12:30 ojab kernel: [   88.128184] mpt3sas version 13.100.00.00 
unloading
Oct 16 13:12:30 ojab kernel: [   88.128838] mpt2sas_cm0: removing 
handle(0x000b), sas_addr(0x5000c500588f549d)
Oct 16 13:12:30 ojab kernel: [   88.128976] mpt2sas_cm0: removing : 
enclosure logical id(0x500605b005a6c320), slot(4)
Oct 16 13:12:30 ojab kernel: [   88.130608] mpt2sas_cm0: removing 
handle(0x0009), sas_addr(0x5000c500588f64e9)
Oct 16 13:12:30 ojab kernel: [   88.130720] mpt2sas_cm0: removing : 
enclosure logical id(0x500605b005a6c320), slot(6)
Oct 16 13:12:30 ojab kernel: [   88.131416] mpt2sas_cm0: removing 
handle(0x000a), sas_addr(0x5000c500588f3825)
Oct 16 13:12:30 ojab kernel: [   88.131518] mpt2sas_cm0: removing : 
enclosure logical id(0x500605b005a6c320), slot(5)
Oct 16 13:12:30 ojab kernel: [   88.132637] ------------[ cut here 
]------------
Oct 16 13:12:30 ojab kernel: [   88.132715] WARNING: CPU: 2 PID: 1578 at 
fs/sysfs/group.c:237 sysfs_remove_group+0xa0/0xb0
Oct 16 13:12:30 ojab kernel: [   88.132810] sysfs group 'power' not 
found for kobject '6:0:0:0'
Oct 16 13:12:30 ojab kernel: [   88.132875] Modules linked in: sit 
tunnel4 ip_tunnel af_packet bridge stp ipv6 llc ipt_MASQUERADE 
nf_nat_masquerade_ipv4 xt_REDIRECT nf_nat_redirect xt_tcpudp 
xt_conntrack iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_\
conntrack iptable_filter ip_tables x_tables sch_fq_codel joydev 
input_leds hid_generic usbhid hid btrfs xor raid6_pq pps_ldisc pps_core 
radeon evdev edac_core arc4 drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops ath9k kvm_amd ttm ath9k_common kvm ath9k_hw dr\
m snd_hda_codec_realtek mac80211 snd_hda_codec_generic irqbypass psmouse 
k10temp ohci_pci ath cfg80211 backlight 8250 snd_hda_intel 8250_base 
serial_core rtc_cmos ehci_pci ehci_hcd snd_hda_codec snd_hwdep 
snd_hda_core cfbfillrect snd_pcm i2c_piix4 cfbimgblt ohci_hcd mpt3\
sas(-) cfbcopyarea i2c_algo_bit
Oct 16 13:12:30 ojab kernel: [   88.135640]  usbcore snd_timer snd 
i2c_core soundcore usb_common r8169 acpi_cpufreq raid_class mii 
scsi_transport_sas button processor unix f71882fg hwmon fbcon bitblit 
softcursor fb fbdev font
Oct 16 13:12:30 ojab kernel: [   88.136514] CPU: 2 PID: 1578 Comm: rmmod 
Not tainted 4.9.0-rc1-ojab #40
Oct 16 13:12:30 ojab kernel: [   88.136581]  ffffac8a02f03c10 
ffffffff832e71a0 ffffac8a02f03c60 0000000000000000
Oct 16 13:12:30 ojab kernel: [   88.136792]  ffffac8a02f03c50 
ffffffff83049fb3 000000ed8321922f 0000000000000000
Oct 16 13:12:30 ojab kernel: [   88.137014]  ffffffff838a2840 
ffffa0dd15602410 ffffa0dd15400f88 ffffa0dd15400fd8
Oct 16 13:12:30 ojab kernel: [   88.137223] Call Trace:
Oct 16 13:12:30 ojab kernel: [   88.137294]  [<ffffffff832e71a0>] 
dump_stack+0x67/0x97
Oct 16 13:12:30 ojab kernel: [   88.137360]  [<ffffffff83049fb3>] 
__warn+0xe3/0x100
Oct 16 13:12:30 ojab kernel: [   88.137425]  [<ffffffff8304a01f>] 
warn_slowpath_fmt+0x4f/0x60
Oct 16 13:12:30 ojab kernel: [   88.137492]  [<ffffffff8321a09d>] ? 
kernfs_find_and_get_ns+0x4d/0x60
Oct 16 13:12:30 ojab kernel: [   88.137558]  [<ffffffff8321d2a0>] 
sysfs_remove_group+0xa0/0xb0
Oct 16 13:12:30 ojab kernel: [   88.137625]  [<ffffffff833aad40>] 
dpm_sysfs_remove+0x60/0x70
Oct 16 13:12:30 ojab kernel: [   88.137691]  [<ffffffff8339f539>] 
device_del+0x49/0x250
Oct 16 13:12:30 ojab kernel: [   88.137756]  [<ffffffff8339f752>] 
device_unregister+0x12/0x30
Oct 16 13:12:30 ojab kernel: [   88.137825]  [<ffffffff832d82de>] 
bsg_unregister_queue+0x5e/0xa0
Oct 16 13:12:30 ojab kernel: [   88.137893]  [<ffffffff833cd2ba>] 
__scsi_remove_device+0xaa/0xd0
Oct 16 13:12:30 ojab kernel: [   88.137969]  [<ffffffff833cb760>] 
scsi_forget_host+0x60/0x70
Oct 16 13:12:30 ojab kernel: [   88.138035]  [<ffffffff833c0c37>] 
scsi_remove_host+0x77/0x110
Oct 16 13:12:30 ojab kernel: [   88.138116]  [<ffffffffc02323c9>] 
scsih_remove+0x139/0x220 [mpt3sas]
Oct 16 13:12:30 ojab kernel: [   88.138184]  [<ffffffff8331e764>] 
pci_device_remove+0x44/0xd0
Oct 16 13:12:30 ojab kernel: [   88.138251]  [<ffffffff833a3efa>] 
__device_release_driver+0x9a/0x140
Oct 16 13:12:30 ojab kernel: [   88.138318]  [<ffffffff833a40a6>] 
driver_detach+0xa6/0xb0
Oct 16 13:12:30 ojab kernel: [   88.138384]  [<ffffffff833a2d9c>] 
bus_remove_driver+0x4c/0xa0
Oct 16 13:12:30 ojab kernel: [   88.138450]  [<ffffffff833a423c>] 
driver_unregister+0x2c/0x50
Oct 16 13:12:30 ojab kernel: [   88.138516]  [<ffffffff8331e243>] 
pci_unregister_driver+0x23/0x90
Oct 16 13:12:30 ojab kernel: [   88.138594]  [<ffffffffc0241a2b>] 
_mpt3sas_exit+0x25/0x38 [mpt3sas]
Oct 16 13:12:30 ojab kernel: [   88.138660]  [<ffffffff830c1ec1>] 
SyS_delete_module+0x181/0x1e0
Oct 16 13:12:30 ojab kernel: [   88.138728]  [<ffffffff834d8c6a>] 
entry_SYSCALL_64_fastpath+0x18/0xa8
Oct 16 13:12:30 ojab kernel: [   88.138811] ---[ end trace 
4bd02fa3ee990966 ]---

//wbr ojab
