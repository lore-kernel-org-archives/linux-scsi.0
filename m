From: Ben Guthro <ben@guthro.net>
Subject: [PATCH v2] megaraid_sas : Add locking to megasas_aen_polling
Date: Mon,  2 Nov 2015 07:18:58 -0500
Message-ID: <1446466738-8209-1-git-send-email-ben.guthro@simplivity.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35856 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbbKBMTi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 07:19:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: Glenn Watkins <Glenn.Watkins@simplivity.com>, Ben Guthro <ben.guthro@simplivity.com>, "Yang, Bo" <Bo.Yang@lsi.com>, stable@vger.kernel.org

From: Glenn Watkins <Glenn.Watkins@simplivity.com>

Under conditions of offlining drives, and rescanning the scsi host,
we can get into situations that the megasas_aen_polling kthread
can crash(GPF) in the megasas_aen_polling work queue:

[ 1206.568641] general protection fault: 0000 [#1] SMP
[ 1206.569479] Modules linked in: xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables coretemp crct10dif_pclmul crc32_pclmul aesni_intel ablk_helper cryptd psmouse lrw vmwgfx gf128mul serio_raw glue_helper aes_x86_64 ppdev ttm microcode vmw_balloon drm_kms_helper drm parport_pc parport fb_sys_fops sysimgblt sysfillrect syscopyarea vmw_vmci binfmt_misc floppy mptspi mptscsih vmw_pvscsi megaraid_sas pata_acpi mptbase vmxnet3
[ 1206.576488] CPU: 0 PID: 1157 Comm: kworker/0:2 Not tainted 4.3.0-rc7-svt1 #1
[ 1206.577520] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/14/2014
[ 1206.579101] Workqueue: events megasas_aen_polling [megaraid_sas]
[ 1206.580007] task: ffff8818bb7b8000 ti: ffff8818ca280000 task.ti: ffff8818ca280000
[ 1206.581104] RIP: 0010:[<ffffffff8118403d>]  [<ffffffff8118403d>] bdi_unregister+0x3d/0x1e0
[ 1206.582339] RSP: 0018:ffff8818ca283cb8  EFLAGS: 00010246
[ 1206.583131] RAX: dead000000000200 RBX: ffff8818bb603f08 RCX: ffff8818c6487800
[ 1206.584184] RDX: ffff8818bb603f08 RSI: 000000007fffffff RDI: ffffffff81f9aa68
[ 1206.585243] RBP: ffff8818ca283d18 R08: 0000000000000000 R09: 0000000000000000
[ 1206.586294] R10: 0000000fffffffe0 R11: dead000000000200 R12: ffff8818bb6042f0
[ 1206.587346] R13: ffff8818bb604530 R14: 00000000000000ae R15: 0000000000000080
[ 1206.588388] FS:  0000000000000000(0000) GS:ffff88193fc00000(0000) knlGS:0000000000000000
[ 1206.589598] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1206.590457] CR2: 0000000001a89000 CR3: 00000018c07f2000 CR4: 00000000000406f0
[ 1206.591545] Stack:
[ 1206.591870]  ffff8818bb6042f0 ffff8818bb603d78 00000000000000ae 0000000000000080
[ 1206.593098]  ffff8818ca283ce8 ffffffff8108f683 ffff8818ca283d18 ffffffff813332b0
[ 1206.594308]  ffff8818ca283d18 ffff8818bb603d78 ffff8818bb6042f0 ffff8818bb604530
[ 1206.595532] Call Trace:
[ 1206.595922]  [<ffffffff8108f683>] ? cancel_delayed_work_sync+0x13/0x20
[ 1206.596903]  [<ffffffff813332b0>] ? blk_sync_queue+0x80/0x90
[ 1206.597753]  [<ffffffff81336424>] blk_cleanup_queue+0x114/0x150
[ 1206.598645]  [<ffffffff814efe44>] __scsi_remove_device+0x54/0xd0
[ 1206.599556]  [<ffffffff814efeef>] scsi_remove_device+0x2f/0x50
[ 1206.600441]  [<ffffffffa003884d>] megasas_aen_polling+0x34d/0x670 [megaraid_sas]
[ 1206.601561]  [<ffffffff8108ddcc>] process_one_work+0x14c/0x400
[ 1206.602449]  [<ffffffff8108e6a7>] worker_thread+0x117/0x480
[ 1206.603295]  [<ffffffff8108e590>] ? create_worker+0x1c0/0x1c0
[ 1206.604160]  [<ffffffff81094bf9>] kthread+0xc9/0xe0
[ 1206.604898]  [<ffffffff81094b30>] ? flush_kthread_worker+0x90/0x90
[ 1206.605831]  [<ffffffff8171bf8f>] ret_from_fork+0x3f/0x70
[ 1206.606659]  [<ffffffff81094b30>] ? flush_kthread_worker+0x90/0x90
[ 1206.607585] Code: c7 c7 68 aa f9 81 48 83 ec 48 e8 bf 76 59 00 48 8b 43 08 48 8b 13 49 bb 00 02 00 00 00 00 ad de 48 c7 c7 68 aa f9 81 48 89 42 08 <48> 89 10 4c 89 5b 08 e8 27 76 59 00 e8 32 92 f4 ff 48 8d 7b 50
[ 1206.611938] RIP  [<ffffffff8118403d>] bdi_unregister+0x3d/0x1e0
[ 1206.612856]  RSP <ffff8818ca283cb8>

This can be readily reproduced by a pair of shell scripts - one of which loops on
onlining / offlining drives via MegaCli (or storcli, if you prefer)

    #!/bin/bash

    while [ 1 ]; do
        /opt/MegaRAID/MegaCli/MegaCli64 pdoffline physdrv[32:0] a0 &>2
        /opt/MegaRAID/MegaCli/MegaCli64 pdoffline physdrv[32:11] a0 &>2

        /opt/MegaRAID/MegaCli/MegaCli64 pdonline physdrv[32:0] a0 &>2
        /opt/MegaRAID/MegaCli/MegaCli64 pdonline physdrv[32:11] a0 &>2
    done

Meanwhile, the second script is looping on rescanning the scsi hosts:

    #!/bin/bash
    while [ 1 ]; do
        for (( l=0; l<4; l++ )); do
            echo - - - > /sys/class/scsi_host/host$l/scan
        done
    done

This was originally introduced in the following commit:

commit 7e8a75f4dfbff173977b2f58799c3eceb7b09afd
Author: Yang, Bo <Bo.Yang@lsi.com>
Date:   Tue Oct 6 14:50:17 2009 -0600

    [SCSI] megaraid_sas: Add the support for updating the OS after adding/removing the devices from FW

The fix for this is to add some locking around the AEN polling.
Since this affects all kernels since 2.6.33, I have also CC'ed the stable list.

--
Changes in v2:
  - Fix contents of sign-off area

Signed-off-by: Glenn Watkins <Glenn.Watkins@simplivity.com>
Signed-off-by: Ben Guthro <ben.guthro@simplivity.com>
Cc: Yang, Bo <Bo.Yang@lsi.com>
Cc: stable@vger.kernel.org

---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index eaa81e5..d203d9d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6640,6 +6640,7 @@ megasas_aen_polling(struct work_struct *work)
 	if (doscan) {
 		dev_info(&instance->pdev->dev, "scanning for scsi%d...\n",
 		       instance->host->host_no);
+		mutex_lock(&host->scan_mutex);
 		if (megasas_get_pd_list(instance) == 0) {
 			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
 				for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
@@ -6661,6 +6662,7 @@ megasas_aen_polling(struct work_struct *work)
 				}
 			}
 		}
+		mutex_unlock(&host->scan_mutex);
 
 		if (!instance->requestorId ||
 		    (instance->requestorId &&
-- 
1.7.9.5

