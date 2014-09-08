From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84091] New: Unloading qla2xxx kernel module triggers
 segmentation fault
Date: Mon, 08 Sep 2014 15:03:11 +0000
Message-ID: <bug-84091-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49808 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaIHPDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 11:03:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 50CA120145
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2014 15:03:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 76E562012F
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2014 15:03:12 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=84091

            Bug ID: 84091
           Summary: Unloading qla2xxx kernel module triggers segmentation
                    fault
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.16.1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: bvanassche@acm.org
        Regression: No

After having upgraded the firmware of a QLE2562 adapter to version 07.03.00,
trying to unload (rmmod) the QLogic initiator driver kernel module triggers a
segmentation fault. This occurs at least with kernel versions 3.15.8 and 3.16.1
if memory poisoning has been enabled (CONFIG_SLUB_DEBUG_ON=y). From the system
log:

general protection fault: 0000 [#1] PREEMPT SMP 
Modules linked in: qla2xxx(-) scsi_transport_fc fuse ip6table_filter ip6_tables
iptable_filter ip_tables ebtable_nat ebtables x_tables 8021q garp bridge stp
llc rdma_ucm rdma_cm iw_cm af_packet ib_ipoib ib_cm ib_uverbs ib_umad mlx4_en
mlx4_ib ib_sa ib_mad ib_core ib_addr snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic x86_pkg_temp_thermal kvm_intel kvm crc32c_intel microcode
pcspkr sr_mod cdrom snd_hda_intel snd_hda_controller lpc_ich snd_hda_codec
snd_hwdep i2c_i801 mfd_core snd_pcm snd_seq mlx4_core snd_seq_device snd_timer
e1000e snd ptp soundcore pps_core wmi acpi_cpufreq button sg dm_mod autofs4
ext4 crc16 mbcache jbd2 xor lzo_compress raid6_pq sd_mod crc_t10dif
crct10dif_common hid_generic usbhid hid radeon i2c_algo_bit drm_kms_helper ahci
ttm libahci libata drm xhci_hcd ehci_pci agpgart ehci_hcd i2c_core usbcore
usb_common processor thermal_sys hwmon scsi_dh_alua scsi_dh scsi_mod
CPU: 4 PID: 4447 Comm: rmmod Not tainted 3.16.1-debug+ #1
Hardware name: MSI MS-7737/Big Bang-XPower II (MS-7737), BIOS V1.5 10/16/2012
task: ffff88082f900000 ti: ffff8807fbe80000 task.ti: ffff8807fbe80000
RIP: 0010:[<ffffffffa0831bcf>]  [<ffffffffa0831bcf>]
qla2x00_remove_one+0x11f/0x220 [qla2xxx]
RSP: 0018:ffff8807fbe83e00  EFLAGS: 00010282
RAX: ffff88082f900001 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000001
RDX: 0000000000000006 RSI: ffff88082f900828 RDI: ffff88082f900000
RBP: ffff8807fbe83e18 R08: ffff8807fd416930 R09: 0000000100180011
R10: 0000000000000000 R11: 0000000000000002 R12: ffff8807fe190000
R13: ffff880838c6a290 R14: ffffffffa08ac0e0 R15: 0000000000eaf010
FS:  00007fc26c717700(0000) GS:ffff88085fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002002470 CR3: 00000007fe218000 CR4: 00000000000407e0
Stack:
 ffff880838c6a328 ffff880838c6a290 ffff880838c6a388 ffff8807fbe83e38
 ffffffff8129f79d ffff880838c6a328 ffffffffa08ac068 ffff8807fbe83e58
 ffffffff8133ab09 ffff880838c6a328 ffffffffa08ac068 ffff8807fbe83e80
Call Trace:
 [<ffffffff8129f79d>] pci_device_remove+0x2d/0x60
 [<ffffffff8133ab09>] __device_release_driver+0x69/0xd0
 [<ffffffff8133b4d0>] driver_detach+0xc0/0xd0
 [<ffffffff8133a7e8>] bus_remove_driver+0x58/0xd0
 [<ffffffff8133b8dc>] driver_unregister+0x2c/0x50
 [<ffffffff8129f6ca>] pci_unregister_driver+0x2a/0x80
 [<ffffffffa0892b96>] qla2x00_module_exit+0x2c/0x9c [qla2xxx]
 [<ffffffff810d2452>] SyS_delete_module+0x142/0x1d0
 [<ffffffff814c3c43>] ? tracesys+0x71/0xd5
 [<ffffffff814c3ca2>] tracesys+0xd0/0xd5
Code: 00 48 8b 7b 68 e8 a2 3c fe ff 48 8b 7b 68 e8 29 12 7d ff 48 89 df e8 11
f1 ff ff 48 8b 7b 68 e8 38 16 7d ff 48 8b 9b d8 01 00 00 <8b> 83 58 01 00 00 a9
00 00 04 00 0f 85 cc 00 00 00 f6 c4 40 75 
RIP  [<ffffffffa0831bcf>] qla2x00_remove_one+0x11f/0x220 [qla2xxx]
 RSP <ffff8807fbe83e00>
---[ end trace f16db7305109991a ]---

gdb translates the crash address into the following:
(gdb) list *(qla2x00_remove_one+0x11f)
0x5bcf is in qla2x00_remove_one (drivers/scsi/qla2xxx/qla_os.c:3118).
3113    static void
3114    qla2x00_clear_drv_active(scsi_qla_host_t *vha)
3115    {
3116            struct qla_hw_data *ha = vha->hw;
3117
3118            if (IS_QLA8044(ha)) {
3119                    qla8044_idc_lock(ha);
3120                    qla8044_clear_drv_active(ha);
3121                    qla8044_idc_unlock(ha);
3122            } else if (IS_QLA82XX(ha)) {

>From the gdb "disassemble /m qla2x00_remove_one" output (0x11f = 287):

   0x0000000000005bc8 <+280>:   mov    0x1d8(%rbx),%rbx
   0x0000000000005bcf <+287>:   mov    0x158(%rbx),%eax
   0x0000000000005bd5 <+293>:   test   $0x40000,%eax

So it seems like qla2x00_clear_drv_active() is called with vha =
0x6b6b6b6b6b6b6b6b. I think this indicates a use-after-free.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
