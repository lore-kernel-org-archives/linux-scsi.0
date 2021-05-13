Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5473CC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 04:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D9C561428
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 04:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhEMEu7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 00:50:59 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52709 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhEMEuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 00:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620881386; x=1652417386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mC3J6xd6F8cqz5s5oZlWzt8NB8NAGiGsrSq3jPZA06U=;
  b=Eg9Eht95xTB1lANDG93kUrq4TWhqMfVMmMjjyolp8ju6PjpnTmvAUia6
   3ydfWHeRdl1SG/c/sx8RG5KPXKoJ4OKtDC5AOwDWyaCOAaoxzG3+o4Ayj
   Vvnlv2XUzl/A9Gn4XtX317FzA5epGC8k506eL2jRyaFDX+x7NZiDzkySH
   0NgI3GdzrBZdEAAfb7tLD/tz6LJIHUXaLNZTF5R5rrPQYNR8+gG7rFVQN
   /EoaJ8U7TDLZQluo3awzYkCpio5FfalZcGbwnx1OW4WXswiYJT2DsKcri
   ay5uYjbIaTpC9ZfH1FBDr238kvb0GCgOQJtHP/E/rgYK3s0ha1sse07TN
   A==;
IronPort-SDR: KzqAkQHgagRAbdXF8tCOYD+sR0aR2yjNEO4BpdyKMjqXLEHYAA9htKXoKN4e6m0O970suEEKsX
 5mhYV0oMCdy59zR69jTjNbQoDDg9v4YXTfSqJS2D3IE/pZqrSH7XiuwwB/nU/BPSZUmAJWfSm7
 c/xPMvPeaGX+O8U6f4dFLTYr1E6KaY6CbCFbWHVncRCLQ3tv7D7XAFCXGpYA4CmnBiN4Jo1PJ8
 LtDYNsCUbYahFDvP+CdZmtZ6Vo0ZC6KU81CHcIKQCF7cEWfFulh9e7/dxUL1rYNhX5T20+YtoC
 0pc=
X-IronPort-AV: E=Sophos;i="5.82,296,1613404800"; 
   d="scan'208";a="172572688"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2021 12:49:46 +0800
IronPort-SDR: GBJ2N8TQ+TJVONctDMeKnafct2QqkVMz3qghPZcyGarQ4weNy6XCXYQN1UDGXPNLAuMeQmkOBU
 T45iE/U2MDnfLCfRBEN1VBKF8d+yc5ezHsc8EsZyZcm83XGBMDA31Gk5brSwx611CasZwiHovf
 1IpVuE1yxudLTFZZmGUBog8Zd1exI3Mr2LkHp2jVlCscEMjtxLFWoituztAoWXsyxJ6lF5JgR2
 ObRdPWugNYhLh/fAwnX2Ir/xklIH/R+I5NSpAy1X1rl0+cU3dMMvx5IpPNmkwWmz0fE2ANcl6a
 uYr8XqR9YMaDFn81ZBsNDunt
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 21:29:42 -0700
IronPort-SDR: naeMKPTxYUXGuSqSi6ZpuhTitUoXPauOLGHqQnPa1kABtY5XBloBOmXDvY2HkV+WZae2y7xRXa
 wQGF9rD9eH1uil0aDxth08OOMVqJ3+NkySrlcGBrIfZUtWfJ3hl3jMJuXiap7mCX9Zx2mHXlVw
 QfUmCk4mznmw3g4Nja41pGL7OdqTcGUWCJqtsWp3uNfXcAhdWi+ALopFKNUmj17L5kxyTr0WuQ
 w9KZcuolzQnPFPdYjZ2Cs9HOGMiKg687CkFE26fPIKEFRrenu6TWI/mlrZVijCG7UQ3f8j8XLs
 vRs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 May 2021 21:49:45 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible code
Date:   Thu, 13 May 2021 13:49:44 +0900
Message-Id: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The BUG message "BUG: using smp_processor_id() in preemptible [00000000]
code" was observed for TCMU devices with kernel config DEBUG_PREEMPT.

The message was observed when blktests block/005 was run on TCMU devices
with fileio backend or user:zbc backend [1]. The commit 1130b499b4a7
("scsi: target: tcm_loop: Use LIO wq cmd submission helper") triggered
the symptom. The commit modified work queue to handle commands and
changed 'current->nr_cpu_allowed' at smp_processor_id() call.

The message was also observed at system shutdown when TCMU devices were
not cleaned up [2]. The function smp_processor_id() was called in SCSI
host work queue for abort handling, and triggered the BUG message. This
symptom was observed regardless of the commit 1130b499b4a7 ("scsi:
target: tcm_loop: Use LIO wq cmd submission helper").

To avoid the BUG message at smp_processor_id(), use get_cpu() and
put_cpu() instead which disable preemption.

[1]

[   56.468103] run blktests block/005 at 2021-05-12 14:16:38
[   57.369473] check_preemption_disabled: 85 callbacks suppressed
[   57.369480] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1511
[   57.369506] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1510
[   57.369512] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1506
[   57.369552] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
[   57.369606] CPU: 4 PID: 1506 Comm: fio Not tainted 5.13.0-rc1+ #34
[   57.369613] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
[   57.369617] Call Trace:
[   57.369621] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1507
[   57.369628]  dump_stack+0x6d/0x89
[   57.369642]  check_preemption_disabled+0xc8/0xd0
[   57.369628] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
[   57.369655]  __target_init_cmd+0x157/0x170 [target_core_mod]
[   57.369695]  target_init_cmd+0x76/0x90 [target_core_mod]
[   57.369732]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
[   57.369744]  scsi_queue_rq+0x38e/0xc40
[   57.369761]  __blk_mq_try_issue_directly+0x109/0x1c0
[   57.369779]  blk_mq_try_issue_directly+0x43/0x90
[   57.369790]  blk_mq_submit_bio+0x4e5/0x5d0
[   57.369812]  submit_bio_noacct+0x46e/0x4e0
[   57.369830]  __blkdev_direct_IO_simple+0x1a3/0x2d0
[   57.369859]  ? set_init_blocksize.isra.0+0x60/0x60
[   57.369880]  generic_file_read_iter+0x89/0x160
[   57.369898]  blkdev_read_iter+0x44/0x60
[   57.369906]  new_sync_read+0x102/0x170
[   57.369929]  vfs_read+0xd4/0x160
[   57.369941]  __x64_sys_pread64+0x6e/0xa0
[   57.369946]  ? lockdep_hardirqs_on+0x79/0x100
[   57.369958]  do_syscall_64+0x3a/0x70
[   57.369965]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   57.369973] RIP: 0033:0x7f7ed4c1399f
[   57.369979] Code: 08 89 3c 24 48 89 4c 24 18 e8 7d f3 ff ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 cd f3 ff ff 48 8b
[   57.369983] RSP: 002b:00007ffd7918c580 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
[   57.369990] RAX: ffffffffffffffda RBX: 00000000015b4540 RCX: 00007f7ed4c1399f
[   57.369993] RDX: 0000000000001000 RSI: 00000000015de000 RDI: 0000000000000009
[   57.369996] RBP: 00000000015b4540 R08: 0000000000000000 R09: 0000000000000001
[   57.369999] R10: 0000000000e5c000 R11: 0000000000000293 R12: 00007f7eb5269a70
[   57.370002] R13: 0000000000000000 R14: 0000000000001000 R15: 00000000015b4568
[   57.370031] CPU: 7 PID: 1507 Comm: fio Not tainted 5.13.0-rc1+ #34
[   57.370036] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
[   57.370039] Call Trace:
[   57.370045]  dump_stack+0x6d/0x89
[   57.370056]  check_preemption_disabled+0xc8/0xd0
[   57.370068]  __target_init_cmd+0x157/0x170 [target_core_mod]
[   57.370121]  target_init_cmd+0x76/0x90 [target_core_mod]
[   57.370178]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
[   57.370197]  scsi_queue_rq+0x38e/0xc40
[   57.370224]  __blk_mq_try_issue_directly+0x109/0x1c0
...

[2]

[  117.458597] BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u16:8
[  117.467279] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
[  117.473893] CPU: 1 PID: 418 Comm: kworker/u16:6 Not tainted 5.13.0-rc1+ #34
[  117.481150] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 8
[  117.481153] Workqueue: scsi_tmf_7 scmd_eh_abort_handler
[  117.481156] Call Trace:
[  117.481158]  dump_stack+0x6d/0x89
[  117.481162]  check_preemption_disabled+0xc8/0xd0
[  117.512575]  target_submit_tmr+0x41/0x150 [target_core_mod]
[  117.519705]  tcm_loop_issue_tmr+0xa7/0x100 [tcm_loop]
[  117.524913]  tcm_loop_abort_task+0x43/0x60 [tcm_loop]
[  117.530137]  scmd_eh_abort_handler+0x7b/0x230
[  117.534681]  process_one_work+0x268/0x580
[  117.538862]  worker_thread+0x55/0x3b0
[  117.542652]  ? process_one_work+0x580/0x580
[  117.548351]  kthread+0x143/0x160
[  117.551675]  ? kthread_create_worker_on_cpu+0x40/0x40
[  117.556873]  ret_from_fork+0x1f/0x30

Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: stable@vger.kernel.org # v5.11+
---
 drivers/target/target_core_transport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8fbfe75c5744..9ed5d234acd8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1415,8 +1415,10 @@ void __target_init_cmd(
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
 
-	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
-		cmd->cpuid = smp_processor_id();
+	if (!(cmd->se_cmd_flags & SCF_USE_CPUID)) {
+		cmd->cpuid = get_cpu();
+		put_cpu();
+	}
 
 	cmd->state_active = false;
 }
-- 
2.30.2

