From: XinHong Zhu <zxh3737@163.com>
Subject: [PATCH] [scsi] pm8001 : fix panic when cat /sys/class/sas_phy/phy-8:0/running_disparity_error_count
Date: Wed,  9 Oct 2013 17:46:26 +0800
Message-ID: <1381311986-2200-1-git-send-email-zxh3737@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:34611 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab3JIJq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Oct 2013 05:46:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, XinHong Zhu <zxh3737@163.com>

There are only two bar memeory got ioremap ,when triggering pm8001_phy_control
got the following Oops
BUG: unable to handle kernel paging request at 0000000000001034
IP: [<ffffffffa02b9366>] pm8001_phy_control+0x1e6/0x2a0 [pm80xx]
PGD 16bf1f067 PUD 231368067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host8/phy-8:0/sas_phy/phy-8:0/running_disparity_error_count
CPU 0
Modules linked in: pm80xx(U) libsas scsi_transport_sas ses enclosure ipv6 sg iTCO_wdt iTCO_vendor_support e1000e i2c_i801 ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_kms_helper drm i2c_algo_bit i2c_core video output dm_mirror dm_region_hash dm_log dm_mod [last unloaded: pmspclx]

Pid: 9292, comm: cat Not tainted 2.6.32-358.el6.x86_64 #1 Sugon Perry/Perry
RIP: 0010:[<ffffffffa02b9366>]  [<ffffffffa02b9366>] pm8001_phy_control+0x1e6/0x2a0 [pm80xx]
RSP: 0018:ffff88017d7b1db8  EFLAGS: 00010002
RAX: ffff880236ea6800 RBX: ffff88017d368000 RCX: 00000000000007d8
RDX: 0000000000000246 RSI: 0000000000000012 RDI: ffff88017d368038
RBP: ffff88017d7b1e08 R08: ffffffff8164ec40 R09: ffff88023a3aec38
R10: 0000000000000001 R11: 0000000000000246 R12: ffff88017d368518
R13: 0000000000001034 R14: ffff88017d368038 R15: 0000000000000246
FS:  00007fd9365a5700(0000) GS:ffff88002c200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000001034 CR3: 00000001795b9000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process cat (pid: 9292, threadinfo ffff88017d7b0000, task ffff880237e66080)
Stack:
 0000001000000000 0000000000000000 ffff88017d7b1dc8 ffff88017d7b1dc8
<d> ffff880236ebc140 ffff880236dbc000 ffff880236ea6800 ffff880236ea6800
 0000000000008000 0000000001f1b000 ffff88017d7b1e28 ffffffffa029b027
Call Trace:
 [<ffffffffa029b027>] sas_get_linkerrors+0x97/0xa0 [libsas]
 [<ffffffffa01585a8>] show_sas_phy_running_disparity_error_count+0x58/0xa0 [scsi_transport_sas]
 [<ffffffff8135acb7>] dev_attr_show+0x27/0x50
 [<ffffffff81129c5e>] ? __get_free_pages+0xe/0x50
 [<ffffffff811f9981>] sysfs_read_file+0x111/0x1f0
 [<ffffffff811816c5>] vfs_read+0xb5/0x1a0
 [<ffffffff81181801>] sys_read+0x51/0x90
 [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
Code: 00 83 f8 ff 0f 84 bd 00 00 00 49 c1 e5 0e 49 8b 84 24 48 02 00 00 41 81 e5 00 c0 00 00 49 81 c5 34 10 00 00 4c 03 ab 80 00 00 00 <41> 8b 55 00 89 90 5c 02 00 00 41 8b 55 04 89 90 60 02 00 00 41
RIP  [<ffffffffa02b9366>] pm8001_phy_control+0x1e6/0x2a0 [pm80xx]
 RSP <ffff88017d7b1db8>
CR2: 0000000000001034

pm8008 pci bar 0 and 1 form io memory 0,bar 2 and 3 form io memory 1

Signed-off-by : XinHong Zhu <zxh3737@163.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a85d73d..431b531 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -222,7 +222,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		{
 			struct sas_phy *phy = sas_phy->phy;
 			uint32_t *qp = (uint32_t *)(((char *)
-				pm8001_ha->io_mem[2].memvirtaddr)
+				pm8001_ha->io_mem[1].memvirtaddr)
 				+ 0x1034 + (0x4000 * (phy_id & 3)));
 
 			phy->invalid_dword_count = qp[0];
-- 
1.7.9


