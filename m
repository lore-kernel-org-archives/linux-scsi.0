From: Chuck Tuffli <ctuffli@gmail.com>
Subject: problem in sas_release_transport
Date: Sun, 22 Aug 2010 22:47:12 -0700
Message-ID: <AANLkTimTn6jH2Y68Lq55Pueui3cNV2wdpJ9JwVymWK3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38060 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0HWFrN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 01:47:13 -0400
Received: by qyk9 with SMTP id 9so2371874qyk.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Aug 2010 22:47:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi -

I ran across this issue in testing and was hoping someone could
comment. Note that the spc driver is one I'm writing, but the in tree
pm8001 driver exhibits the same problem.

The system is running openSUSE 11.3 (2.6.34-12-default) and is
connected to a SAS JBOD that issues PHY_VACANT during discovery. The
line causing the problem appears to be

	transport_container_unregister(&i->phy_attr_cont);

I believe the reason this would fail is if the container's linked list
was not empty. It appears that sas_set_ex_phy() calls sas_phy_alloc()
which would add the PHY to the container's linked list, but since the
response from the expander is PHY_VACANT, the code would return before
calling sas_phy_add(). While I don't completely understand the inner
workings, only PHY's added with sas_phy_add() are removed with
sas_phy_delete() which leaves the 4 vacant PHYs still allocated and in
the container's linked list, leading to the BUG during unregister.

Please CC me as I'm not a subscriber. Thanks!

---chuck

[ 1422.561562] ------------[ cut here ]------------
[ 1422.561568] kernel BUG at
/usr/src/packages/BUILD/kernel-default-2.6.34/linux-2.6.34/include/linux/transport_class.h:92!
[ 1422.561572] invalid opcode: 0000 [#1] SMP
[ 1422.561576] last sysfs file: /sys/bus/pci/drivers/spc/uevent
[ 1422.561579] CPU 3
[ 1422.561581] Modules linked in: ses enclosure spc(-) edd fuse loop
dm_mod libsas scsi_transport_sas iTCO_wdt iTCO_vendor_support sr_mod
ioatdma floppy shpchp i5400_edac edac_core sg dca i2c_i801 cdrom
e1000e i5k_amb thermal processor button container pci_hotplug pcspkr
thermal_sys sd_mod ata_generic uhci_hcd ata_piix ehci_hcd libata
scsi_mod usbcore reiserfs
[ 1422.561624]
[ 1422.561630] Pid: 2429, comm: rmmod Not tainted 2.6.34-12-default #1
X7DWE/X7DWE
[ 1422.561632] RIP: 0010:[<ffffffffa02b0136>]  [<ffffffffa02b0136>]
sas_release_transport+0x66/0x70 [scsi_transport_sas]
[ 1422.561649] RSP: 0018:ffff88007e431ec8  EFLAGS: 00010286
[ 1422.561652] RAX: 00000000fffffff0 RBX: ffff88007e90c000 RCX: ffff88007e5e5d40
[ 1422.561655] RDX: 000000000000101d RSI: ffffffff81241ee0 RDI: ffffffff81a494c0
[ 1422.561658] RBP: ffffffffa0329100 R08: 0000000000000000 R09: ffff88007e6186a0
[ 1422.561661] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000880
[ 1422.561663] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[ 1422.561666] FS:  00007f4f92585700(0000) GS:ffff880001f80000(0000)
knlGS:0000000000000000
[ 1422.561669] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1422.561672] CR2: 00007fa3269e8000 CR3: 000000007f07f000 CR4: 00000000000006e0
[ 1422.561675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1422.561678] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1422.561681] Process rmmod (pid: 2429, threadinfo ffff88007e430000,
task ffff88007e3ae140)
[ 1422.561684] Stack:
[ 1422.561685]  0000000000000880 ffffffffa0322837 0000000000000000
ffffffff8108a9df
[ 1422.561691] <0> ffff880000637073 ffffffff81102d5b ffff88007dbba0a0
ffff88007e5a5448
[ 1422.561697] <0> 000000057ada4180 ffff88007dbba088 00ff88007e39bac0
ffff88007e5a54a0
[ 1422.561704] Call Trace:
[ 1422.561736]  [<ffffffffa0322837>] spc_exit+0x31/0x4a [spc]
[ 1422.561753]  [<ffffffff8108a9df>] sys_delete_module+0x18f/0x2a0
[ 1422.561765]  [<ffffffff81002efb>] system_call_fastpath+0x16/0x1b
[ 1422.561778]  [<00007f4f920e8d77>] 0x7f4f920e8d77
[ 1422.561780] Code: 75 29 48 8d bb 88 08 00 00 e8 a7 40 05 e1 85 c0
75 19 48 8d bb f0 08 00 00 e8 97 40 05 e1 85 c0 75 09 48 89 df 5b e9
da e8 e6 e0 <0f> 0b 0f 1f 84 00 00 00 00 00 41 57 49 89 ff 41 56 41 55
49 89
[ 1422.561823] RIP  [<ffffffffa02b0136>]
sas_release_transport+0x66/0x70 [scsi_transport_sas]
[ 1422.561833]  RSP <ffff88007e431ec8>
[ 1422.561837] ---[ end trace d1ecf0a2aec32ee5 ]---
