From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] scsi:libsas: fix oops caused by assigning a freed task to ->lldd_task
Date: Wed, 6 Jul 2016 16:28:44 +0800
Message-ID: <1467793724-21815-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:26583 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbcGFIV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 04:21:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org, Wei Fang <fangwei1@huawei.com>

A freed task has been assigned to ->lldd_task when lldd_execute_task()
failed in sas_ata_qc_issue(), and access of ->lldd_task will cause
an oops:

Call trace:
[<ffffffc000641f64>] sas_ata_post_internal+0x6c/0x150
[<ffffffc0006c0d64>] ata_exec_internal_sg+0x32c/0x588
[<ffffffc0006c1048>] ata_exec_internal+0x88/0xe8
[<ffffffc0006c13b4>] ata_dev_read_id+0x204/0x5e0
[<ffffffc0006c17f0>] ata_dev_reread_id+0x60/0xc8
[<ffffffc0006c3098>] ata_dev_revalidate+0x88/0x1e0
[<ffffffc0006cf828>] ata_eh_recover+0xcf8/0x13a8
[<ffffffc0006d075c>] ata_do_eh+0x5c/0xe0
[<ffffffc0006d0828>] ata_std_error_handler+0x48/0x98
[<ffffffc0006d042c>] ata_scsi_port_error_handler+0x474/0x658
[<ffffffc000641b78>] async_sas_ata_eh+0x50/0x80
[<ffffffc0000ca664>] async_run_entry_fn+0x64/0x180
[<ffffffc0000c085c>] process_one_work+0x164/0x438
[<ffffffc0000c0c74>] worker_thread+0x144/0x4b0
[<ffffffc0000c70fc>] kthread+0xfc/0x110

Fix this by reassigning NULL to ->lldd_task in error path.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 935c430..33c7c66 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -253,6 +253,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		if (qc->scsicmd)
 			ASSIGN_SAS_TASK(qc->scsicmd, NULL);
 		sas_free_task(task);
+		qc->lldd_task = task;
 		ret = AC_ERR_SYSTEM;
 	}
 
-- 
1.7.1

