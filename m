From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] mpt3sas: Do scsi_remove_host() before deleting SAS PHY objects
Date: Fri, 13 May 2016 13:28:19 -0700
Message-ID: <41278f83ecb4de381ab49aeb94e341dc533fde8f.1463170969.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18969 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753520AbcEMU2i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 16:28:38 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4DKOBCv007794
	for <linux-scsi@vger.kernel.org>; Fri, 13 May 2016 13:28:37 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 22wndp83wj-14
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 May 2016 13:28:37 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)	by
 mx-out.facebook.com (10.223.101.97) with ESMTP	id
 40d35484194911e6ad4c24be0595f910-d03ddc50 for <linux-scsi@vger.kernel.org>;
	Fri, 13 May 2016 13:28:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, calvinowens@fb.com

On the hardware I'm testing on, simply removing the mpt3sas module
triggers a litany of WARNs culminating in an OOPS:

  ------------[ cut here ]------------
  WARNING: CPU: 5 PID: 13348 at lib/kobject.c:244 kobject_add_internal+0x359/0x8a0
  kobject_add_internal failed for ArrayDevice09 (error: -2 parent: 6:0:15:0)
  CPU: 5 PID: 13348 Comm: rmmod Not tainted 4.6.0-rc2-mpt3sas-debug-00001-g7e7e6f4 #2
  Hardware name: Wiwynn   HoneyBadger/PantherPlus, BIOS HBP6.6 11/20/2015
   ffffffff82b88ec0 ffff8806ce76f820 ffffffff81deff03 ffff8806ce76f898
   0000000000000000 ffff8806ce76f868 ffffffff811191e2 ffff880749819af8
   00000000000000f4 ffffed00d9cedf0f ffff880749819b08 ffff88074c9b8168
  Call Trace:
   [<ffffffff81deff03>] dump_stack+0x67/0x94
   [<ffffffff811191e2>] __warn+0x172/0x1b0
   [<ffffffff811192b7>] warn_slowpath_fmt+0x97/0xb0
   [<ffffffff81df72d9>] kobject_add_internal+0x359/0x8a0
   [<ffffffff81df792e>] kobject_add+0x10e/0x1c0
   [<ffffffff820b4cda>] device_add+0x30a/0x1490
   [<ffffffffa036a222>] enclosure_remove_device+0x172/0x1cc [enclosure]
   [<ffffffffa0390254>] ses_intf_remove+0x1c4/0x270 [ses]
   [<ffffffff820b1b3b>] device_del+0x2ab/0x680
   [<ffffffff820b1f22>] device_unregister+0x12/0x30
   [<ffffffff821264c5>] __scsi_remove_device+0x1d5/0x250
   [<ffffffff821225ec>] scsi_forget_host+0x12c/0x1e0
   [<ffffffff820ff4dc>] scsi_remove_host+0x10c/0x300
   [<ffffffffa0066c31>] scsih_remove+0x321/0x680 [mpt3sas]
   [<ffffffff81ebe5e0>] pci_device_remove+0x70/0x110
   [<ffffffff820bc7a0>] __device_release_driver+0x160/0x3a0
   [<ffffffff820bdd33>] driver_detach+0x183/0x200
   [<ffffffff820bbbbf>] bus_remove_driver+0xdf/0x200
   [<ffffffff820be847>] driver_unregister+0x67/0xa0
   [<ffffffff81ebc50e>] pci_unregister_driver+0x1e/0xe0
   [<ffffffffa0093e0a>] _mpt3sas_exit+0x23/0x219 [mpt3sas]
   [<ffffffff81291e7e>] SyS_delete_module+0x2ee/0x390
   [<ffffffff82924aa5>] entry_SYSCALL_64_fastpath+0x18/0xa8
  ---[ end trace fe163024b624f4af ]---

  general protection fault: 0000 [#1] SMP KASAN
  CPU: 6 PID: 17388 Comm: rmmod Tainted: G        W       4.6.0-rc2-00001-g7e7e6f4 #1
  Hardware name: Wiwynn   HoneyBadger/PantherPlus, BIOS HBP6.6 11/20/2015
  task: ffff880753731740 ti: ffff8806896f0000 task.ti: ffff8806896f0000
  RIP: 0010:[<ffffffff8290972f>]  [<ffffffff8290972f>] klist_put+0x1f/0x160
  RSP: 0018:ffff8806896f7a10  EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff880753731f48
  RDX: 000000000000000b RSI: 0000000000000001 RDI: 0000000000000058
  RBP: ffff8806896f7a30 R08: 0000000000000006 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff880752bec000
  R13: 0000000000000001 R14: dffffc0000000000 R15: ffff880752bec2b0
  FS:  00007feef8ea6700(0000) GS:ffff88075ef80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fe45044d020 CR3: 00000006f7092000 CR4: 00000000001006e0
  Stack:
   0000000000000000 ffff880752bec000 0000000000000000 dffffc0000000000
   ffff8806896f7a40 ffffffff8290987e ffff8806896f7b00 ffffffff820aa3bd
   ffff8806896f7aa0 1ffff100d12def4f ffff880752bec390 ffffffff829183ca
  Call Trace:
   [<ffffffff8290987e>] klist_del+0xe/0x10
   [<ffffffff820aa3bd>] device_del+0x12d/0x680
   [<ffffffff820aa922>] device_unregister+0x12/0x30
   [<ffffffffa0368bb0>] enclosure_unregister+0xe0/0x170 [enclosure]
   [<ffffffffa0390220>] ses_intf_remove+0x190/0x270 [ses]
   [<ffffffff820aa53b>] device_del+0x2ab/0x680
   [<ffffffff820aa922>] device_unregister+0x12/0x30
   [<ffffffff8211ed65>] __scsi_remove_device+0x1d5/0x250
   [<ffffffff8211ae8c>] scsi_forget_host+0x12c/0x1e0
   [<ffffffff820f7d6c>] scsi_remove_host+0x10c/0x300
   [<ffffffffa00668f1>] scsih_remove+0x321/0x680 [mpt3sas]
   [<ffffffff81eb7170>] pci_device_remove+0x70/0x110
   [<ffffffff820b51a0>] __device_release_driver+0x160/0x3a0
   [<ffffffff820b6733>] driver_detach+0x183/0x200
   [<ffffffff820b45bf>] bus_remove_driver+0xdf/0x200
   [<ffffffff820b7247>] driver_unregister+0x67/0xa0
   [<ffffffff81eb509e>] pci_unregister_driver+0x1e/0xe0
   [<ffffffffa009359a>] _mpt3sas_exit+0x23/0xa89 [mpt3sas]
   [<ffffffff81291e7e>] SyS_delete_module+0x2ee/0x390
   [<ffffffff8291d1e5>] entry_SYSCALL_64_fastpath+0x18/0xa8

The issue is that enclosure_remove_device() expects to be able to re-add
the device that was previously enclosured: so with SES running, the order
we unwind things matters in a way it otherwise wouldn't.

Since mpt3sas deletes the SAS objects before the SCSI hosts, enclosure
ends up trying to re-parent the SCSI device from the enclosure to the SAS
PHY which has already been deleted. This obviously ends in sadness.

The fix appears to be simple: just call scsi_remove_host() before we call
sas_port_delete() and/or sas_remove_host().

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e0e4920..4aa128a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8149,6 +8149,8 @@ void scsih_remove(struct pci_dev *pdev)
 		_scsih_raid_device_remove(ioc, raid_device);
 	}
 
+	scsi_remove_host(shost);
+
 	/* free ports attached to the sas_host */
 	list_for_each_entry_safe(mpt3sas_port, next_port,
 	   &ioc->sas_hba.sas_port_list, port_list) {
@@ -8172,7 +8174,6 @@ void scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
-	scsi_remove_host(shost);
 	mpt3sas_base_detach(ioc);
 	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
-- 
2.8.0.rc2

