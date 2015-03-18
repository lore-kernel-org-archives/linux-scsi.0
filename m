From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH RESUBMIT] Enclosure: fix WARN ON when doing dlpar removing an adapter in dual patch devices
Date: Wed, 18 Mar 2015 17:18:21 -0500
Message-ID: <1426717101-26910-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:36398 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbbCRWWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2015 18:22:37 -0400
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@us.ibm.com>;
	Wed, 18 Mar 2015 19:22:34 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 66EFE1DC0051
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2015 18:21:33 -0400 (EDT)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2IMMjrC3371196
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2015 19:22:46 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2IMMTI6030772
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2015 18:22:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Hi James,

Our test teams still see lots of these errors in error log when dlpar removing
the adapter in dual configuration. So I re-submit the patch.

Thanks for your help!
Wendy

This issue is happened in dual path devices when we tried to do dlpar removing one of adapter in the system. We got the following error:

Dec 10 01:17:02 powerio-blue-lp5 : drmgr: -r -c phb -s PHB 32 -w 5 -d 1
Dec 10 01:17:02 powerio-blue-lp5 kernel: sysfs: can not remove 'device', no directory
Dec 10 01:17:02 powerio-blue-lp5 kernel: ------------[ cut here ]------------
Dec 10 01:17:02 powerio-blue-lp5 kernel: WARNING: at fs/sysfs/inode.c:324
Dec 10 01:17:02 powerio-blue-lp5 kernel: Modules linked in: ipr sg vfat fat isofs ext4 mbcache jbd2 cfg80211 rfkill ses enclosure pseries_rng xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp libata ibmveth scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipr]
Dec 10 01:17:02 powerio-blue-lp5 kernel: CPU: 10 PID: 2714 Comm: drmgr Not tainted 3.10.0-201.ael7a.ppc64le #1
Dec 10 01:17:02 powerio-blue-lp5 kernel: task: c0000003ec420000 ti: c0000003e9580000 task.ti: c0000003e9580000
Dec 10 01:17:02 powerio-blue-lp5 kernel: NIP: c000000000395e08 LR: c000000000395e04 CTR: 00000000006dac44
Dec 10 01:17:02 powerio-blue-lp5 kernel: REGS: c0000003e95831c0 TRAP: 0700   Not tainted  (3.10.0-201.ael7a.ppc64le)
Dec 10 01:17:02 powerio-blue-lp5 kernel: MSR: 8000000100029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28088424  XER: 20000000
Dec 10 01:17:02 powerio-blue-lp5 kernel: CFAR: c000000000911f34 SOFTE: 1
GPR00: c000000000395e04 c0000003e9583440 c0000000010adae8 000000000000002c
GPR04: c000000001885888 c0000000018964f8 000000000000004d 000000000000005d
GPR08: c000000000c6dae8 0000000000000000 0000000000000000 0000000000000080
GPR12: 0000000042088482 c000000007df2300 0000000000000000 0000000000000000
GPR16: c0000003f2cad828 0000000000000000 c0000003fe1a9000 0000000000000000
GPR20: 0000000000000000 0000000000000000 c0000003f2cad818 0000000000000000
GPR24: 0000000000000000 c00000000097a258 c0000003eefa89d0 c000000001031308
GPR28: c0000000010369c0 c0000003e47bd200 c0000003ecd082d8 0000000000000000
Dec 10 01:17:02 powerio-blue-lp5 kernel: NIP [c000000000395e08] sysfs_hash_and_remove+0xc8/0xe0
Dec 10 01:17:02 powerio-blue-lp5 kernel: LR [c000000000395e04] sysfs_hash_and_remove+0xc4/0xe0
Dec 10 01:17:02 powerio-blue-lp5 kernel: Call Trace:
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583440] [c000000000395e04] sysfs_hash_and_remove+0xc4/0xe0 (unreliable)
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95834d0] [c00000000039a5bc] sysfs_remove_link+0x2c/0x70
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95834f0] [d000000002e80e90] enclosure_component_release+0x90/0xe0 [enclosure]
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583560] [c0000000005ac608] device_release+0x58/0xf0
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95835e0] [c000000000478a9c] kobject_put+0x12c/0x360
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583670] [c0000000005ad7c4] device_unregister+0x44/0xa0
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95836e0] [d000000002e80768] enclosure_unregister+0x98/0xf0 [enclosure]
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583720] [d000000002ee0120] ses_intf_remove+0xb0/0x140 [ses]
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583750] [c0000000005ad5a4] device_del+0x164/0x340
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95837e0] [c0000000005ad7b4] device_unregister+0x34/0xa0
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583850] [c0000000005fc064] __scsi_remove_device+0x104/0x130
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583880] [c0000000005f8c94] scsi_forget_host+0x94/0xa0
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95838b0] [c0000000005e6008] scsi_remove_host+0x138/0x370
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583940] [d0000000060e1bc4] ipr_remove+0x84/0x100 [ipr]
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e95839c0] [c0000000004db224] pci_device_remove+0x64/0x100
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583a00] [c0000000005b4ec8] device_release_driver+0xe8/0x1b0
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583a40] [c0000000004caae8] pci_stop_bus_device+0x678/0x700
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583b40] [c0000000004cb48c] pci_stop_and_remove_bus_device+0x2c/0x120
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583b80] [c00000000004b80c] pcibios_remove_pci_devices+0x54c/0x790
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583ca0] [c0000000004fcb78] disable_slot+0x38/0x80
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583cd0] [c0000000004f7160] power_write_file+0xa0/0x190
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583d50] [c0000000004e8abc] pci_slot_attr_store+0x3c/0x60
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583d70] [c0000000003960c0] sysfs_write_file+0xf0/0x1d0
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583dd0] [c0000000002d4e28] SyS_write+0x148/0x390
Dec 10 01:17:02 powerio-blue-lp5 kernel: [c0000003e9583e30] [c00000000000a0fc] syscall_exit+0x0/0x7c

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/misc/enclosure.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 38552a3..0d20e19 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -209,6 +209,9 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
 	if (!cdev->dev->kobj.sd)
 		return;
 
+	if (!cdev->cdev.kobj.sd)
+		return;
+
 	enclosure_link_name(cdev, name);
 	sysfs_remove_link(&cdev->dev->kobj, name);
 	sysfs_remove_link(&cdev->cdev.kobj, "device");
-- 
1.7.1

