Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B51C5C96
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 06:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904471; cv=none; b=TSk1pIQRN5l8zlEfqlMy621zmVkq0e7jA8f5UQ2eLt+x4da/HjBdmjVPVew71fQpFltoIYa+XBl+mYL/aZ64vGcaADQN8VRHMzR0pd31dEaVSnuNgnwmO9niQh5THp9zuTyN2JpL/XJwnw+waRFAlO7AHEPmXRZ8hgAE1fh3MiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904471; c=relaxed/simple;
	bh=xw17tTBVt3kJfbobrnAghRfhOrVBDekhpneQng7RV14=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIV8YJoL2jdhwStOzpFYRQF2LeTALBEGJSKw0lwBcMmaq1BkntjV7rzuEgT8xy0Pj9aPYoe+bSyYA93a4OuwvWp63ji1xgIttKdIVRXjChaFQmbbYKcJ3zrnKAJEqjEYPWD9xVUe53MegQiyr7ZSLcFu7sjGagIgbppMH7fMmaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4TJKnw6WKhzsWKD;
	Mon, 22 Jan 2024 14:20:04 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id E1CEA18007B;
	Mon, 22 Jan 2024 14:20:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Jan 2024 14:20:49 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 1/4] scsi: hisi_sas: Fix a deadlock issue related to automatic dump
Date: Mon, 22 Jan 2024 14:25:44 +0800
Message-ID: <1705904747-62186-2-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
References: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500025.china.huawei.com (7.221.188.170)

From: Yihang Li <liyihang9@huawei.com>

If we issue a disabling PHY command, the device attached with it will go
offline, if a 2 bit ECC error occurs at the same time, a hung task may be
found:

[ 4613.652388] INFO: task kworker/u256:0:165233 blocked for more than 120 seconds.
[ 4613.666297] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4613.674809] task:kworker/u256:0  state:D stack:    0 pid:165233 ppid:     2 flags:0x00000208
[ 4613.683959] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain [libsas]
[ 4613.691518] Call trace:
[ 4613.694678]  __switch_to+0xf8/0x17c
[ 4613.698872]  __schedule+0x660/0xee0
[ 4613.703063]  schedule+0xac/0x240
[ 4613.706994]  schedule_timeout+0x500/0x610
[ 4613.711705]  __down+0x128/0x36c
[ 4613.715548]  down+0x240/0x2d0
[ 4613.719221]  hisi_sas_internal_abort_timeout+0x1bc/0x260 [hisi_sas_main]
[ 4613.726618]  sas_execute_internal_abort+0x144/0x310 [libsas]
[ 4613.732976]  sas_execute_internal_abort_dev+0x44/0x60 [libsas]
[ 4613.739504]  hisi_sas_internal_task_abort_dev.isra.0+0xbc/0x1b0 [hisi_sas_main]
[ 4613.747499]  hisi_sas_dev_gone+0x174/0x250 [hisi_sas_main]
[ 4613.753682]  sas_notify_lldd_dev_gone+0xec/0x2e0 [libsas]
[ 4613.759781]  sas_unregister_common_dev+0x4c/0x7a0 [libsas]
[ 4613.765962]  sas_destruct_devices+0xb8/0x120 [libsas]
[ 4613.771709]  sas_do_revalidate_domain.constprop.0+0x1b8/0x31c [libsas]
[ 4613.778930]  sas_revalidate_domain+0x60/0xa4 [libsas]
[ 4613.784716]  process_one_work+0x248/0x950
[ 4613.789424]  worker_thread+0x318/0x934
[ 4613.793878]  kthread+0x190/0x200
[ 4613.797810]  ret_from_fork+0x10/0x18
[ 4613.802121] INFO: task kworker/u256:4:316722 blocked for more than 120 seconds.
[ 4613.816026] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4613.824538] task:kworker/u256:4  state:D stack:    0 pid:316722 ppid:     2 flags:0x00000208
[ 4613.833670] Workqueue: 0000:74:02.0 hisi_sas_rst_work_handler [hisi_sas_main]
[ 4613.841491] Call trace:
[ 4613.844647]  __switch_to+0xf8/0x17c
[ 4613.848852]  __schedule+0x660/0xee0
[ 4613.853052]  schedule+0xac/0x240
[ 4613.856984]  schedule_timeout+0x500/0x610
[ 4613.861695]  __down+0x128/0x36c
[ 4613.865542]  down+0x240/0x2d0
[ 4613.869216]  hisi_sas_controller_prereset+0x58/0x1fc [hisi_sas_main]
[ 4613.876324]  hisi_sas_rst_work_handler+0x40/0x8c [hisi_sas_main]
[ 4613.883019]  process_one_work+0x248/0x950
[ 4613.887732]  worker_thread+0x318/0x934
[ 4613.892204]  kthread+0x190/0x200
[ 4613.896118]  ret_from_fork+0x10/0x18
[ 4613.900423] INFO: task kworker/u256:1:348985 blocked for more than 121 seconds.
[ 4613.914341] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4613.922852] task:kworker/u256:1  state:D stack:    0 pid:348985 ppid:     2 flags:0x00000208
[ 4613.931984] Workqueue: 0000:74:02.0_event_q sas_port_event_worker [libsas]
[ 4613.939549] Call trace:
[ 4613.942702]  __switch_to+0xf8/0x17c
[ 4613.946892]  __schedule+0x660/0xee0
[ 4613.951083]  schedule+0xac/0x240
[ 4613.955015]  schedule_timeout+0x500/0x610
[ 4613.959725]  wait_for_common+0x200/0x610
[ 4613.964349]  wait_for_completion+0x3c/0x5c
[ 4613.969146]  flush_workqueue+0x198/0x790
[ 4613.973776]  sas_porte_broadcast_rcvd+0x1e8/0x320 [libsas]
[ 4613.979960]  sas_port_event_worker+0x54/0xa0 [libsas]
[ 4613.985708]  process_one_work+0x248/0x950
[ 4613.990420]  worker_thread+0x318/0x934
[ 4613.994868]  kthread+0x190/0x200
[ 4613.998800]  ret_from_fork+0x10/0x18

This is because when the device goes offline, we obtain the hisi_hba
semaphore and send the ABORT_DEV command to the device. However, the
internal abort timed out due to the 2 bit ECC error and triggers automatic
dump. In addition, since the hisi_hba semaphore has been obtained, the
dump cannot be executed and the controller cannot be reset.

Therefore, the deadlocks occur on the following circular dependencies:
hisi_sas_dev_gone() -> down() -> hisi_sas_internal_task_abort_dev() -> ...
-> hisi_sas_internal_abort_timeout() -> down().

The deadlock is triggered only when the timeout occurs during device goes
offline. To fix this issue, use .rst_ha_timeout to distinguish the
scenario where a device goes offline from other scenarios.

Fixes: 2ff07b5c6fe9 ("scsi: hisi_sas: Directly call register snapshot instead of using workqueue")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index bbb7b2d..1abc62b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1962,9 +1962,17 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_sas_internal_abort_data *timeout = data;
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
-		down(&hisi_hba->sem);
+		/*
+		 * If timeout occurs in device gone scenario, to avoid
+		 * circular dependency like:
+		 * hisi_sas_dev_gone() -> down() -> ... ->
+		 * hisi_sas_internal_abort_timeout() -> down().
+		 */
+		if (!timeout->rst_ha_timeout)
+			down(&hisi_hba->sem);
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
-		up(&hisi_hba->sem);
+		if (!timeout->rst_ha_timeout)
+			up(&hisi_hba->sem);
 	}
 
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-- 
2.8.1

