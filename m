Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661356FC3;
	Sat, 24 May 2025 07:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748073071; cv=none; b=gVJrZzfDb5ctC0cYCVmDLNQhZtxtEXLvSQM4eNUldK20mpxrrJj5I8UUG4oeVY3j1P9N2eTrgTx0e/nLjhjpIhtJMRZ56HJSC4SHhE6LDyvSZn30VqblKuopPzgF7PNYz10sjGwO0/d4/ucj2dMsJpIhfwZc0CdoVUrzKdkuUwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748073071; c=relaxed/simple;
	bh=t0zO1yGFpeFv6G1FrqVHDoNm/q9T1yvCFTqklCzAnFs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EkdZb65qLWfLQtyQbkFsgiiWWoN1DWRoh0NiMMUd+oL4yJXsDSvlfuyPubX9jO2+KqNVv+U+AyUmV2hgHi/LdiTqP5MLL9I5Pyr/TLD1WXvVREuk2cGM+kTdSLA+jYyg9774ajA6GjgwJvUsM9N7KSZKN2OIda/QoTjG7shAOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4b4DhT3HHSz1jB8k;
	Sat, 24 May 2025 15:50:01 +0800 (CST)
Received: from kwepemh100003.china.huawei.com (unknown [7.202.181.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 1EDAD1800B2;
	Sat, 24 May 2025 15:50:57 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemh100003.china.huawei.com
 (7.202.181.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 24 May
 2025 15:50:56 +0800
From: Zheng Qixing <zhengqixing@huawei.com>
To: <sathya.prakash@broadcom.com>, <sreekanth.reddy@broadcom.com>,
	<suganath-prabu.subramani@broadcom.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, <zhengqixing@huawei.com>
Subject: [PATCH] scsi: mpt3sas: fix uaf in _scsih_fw_event_cleanup_queue() during hard reset
Date: Sat, 24 May 2025 15:46:09 +0800
Message-ID: <20250524074609.358032-1-zhengqixing@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemh100003.china.huawei.com (7.202.181.85)

During mpt3sas hard reset, there are two asynchronous execution paths that
can lead to use-after-free issues:

Path A (cleanup):
  _base_clear_outstanding_commands()
    mpt3sas_scsih_clear_outstanding_scsi_tm_commands()
      _scsih_fw_event_cleanup_queue()
	cancel_work_sync // UAF!

Path B (recovery):
  _base_reset_done_handler()
    mpt3sas_scsih_reset_done_handler()
      _scsih_error_recovery_delete_devices()
        alloc_fw_event_work()
        _scsih_fw_event_add()
          _firmware_event_work()
            _mpt3sas_fw_work() // free fw_event

Here is a use-after-free issue during hard reset:

[17235.331337] ==================================================================
[17235.331472] BUG: KASAN: slab-use-after-free in __cancel_work_timer+0x172/0x3e0
[17235.331598] Read of size 8 at addr ffff88be08e72610 by task scsi_eh_10/980
[17235.331713]
[17235.331798] CPU: 50 PID: 980 Comm: scsi_eh_10 Kdump: loaded Not tainted 6.6.0+ #24
[17235.332033] Call Trace:
[17235.332120]  <TASK>
[17235.332209]  dump_stack_lvl+0x32/0x50
[17235.332307]  print_address_description.constprop.0+0x6b/0x3d0
[17235.332408]  ? __cancel_work_timer+0x172/0x3e0
[17235.332502]  print_report+0xbe/0x280
[17235.332594]  ? __cancel_work_timer+0x172/0x3e0
[17235.332690]  kasan_report+0x9c/0xd0
[17235.332776]  ? __cancel_work_timer+0x172/0x3e0
[17235.332871]  kasan_check_range+0xfc/0x1b0
[17235.332962]  __cancel_work_timer+0x172/0x3e0
[17235.333055]  ? __pfx___cancel_work_timer+0x10/0x10
[17235.333151]  ? _printk+0xae/0xe0
[17235.333244]  ? _raw_spin_lock_irqsave+0x82/0xe0
[17235.333341]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[17235.333434]  ? _raw_spin_lock_irqsave+0x82/0xe0
[17235.333528]  _scsih_fw_event_cleanup_queue+0x2a2/0x570 [mpt3sas]
[17235.333666]  mpt3sas_scsih_clear_outstanding_scsi_tm_commands+0x171/0x2c0 [mpt3sas]
[17235.333812]  mpt3sas_base_hard_reset_handler+0x2e8/0x9d0 [mpt3sas]
[17235.333933]  mpt3sas_scsih_issue_tm+0xaa1/0xc10 [mpt3sas]
[17235.334051]  scsih_target_reset+0x344/0x7f0 [mpt3sas]
[17235.334172]  scsi_try_target_reset+0xa7/0x1f0
[17235.334268]  scsi_eh_target_reset+0x4e8/0xc50
[17235.334363]  ? __pfx_scsi_eh_target_reset+0x10/0x10
[17235.334460]  scsi_eh_ready_devs+0xc8/0x5b0
[17235.334554]  ? finish_task_switch.isra.0+0x151/0x7a0
[17235.334651]  ? __pfx_scsi_eh_ready_devs+0x10/0x10
[17235.334743]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[17235.334840]  scsi_unjam_host+0x2fa/0x700
[17235.334929]  ? _raw_spin_lock_irqsave+0x82/0xe0
[17235.335024]  ? __pfx_scsi_unjam_host+0x10/0x10
[17235.335117]  ? __pm_runtime_resume+0x7a/0x110
[17235.335213]  scsi_error_handler+0x434/0x700
[17235.335306]  ? __pfx_scsi_error_handler+0x10/0x10
[17235.335400]  kthread+0x2d1/0x3b0
[17235.335492]  ? __pfx_kthread+0x10/0x10
[17235.335583]  ret_from_fork+0x2b/0x70
[17235.335680]  ? __pfx_kthread+0x10/0x10
[17235.335775]  ret_from_fork_asm+0x1b/0x30
[17235.335873]  </TASK>
[17235.335959]
[17235.336043] Allocated by task 980:
[17235.336130]  kasan_save_stack+0x21/0x40
[17235.336137]  kasan_set_track+0x21/0x30
[17235.336141]  __kasan_kmalloc+0x8b/0x90
[17235.336145]  mpt3sas_scsih_reset_done_handler+0x575/0x7f0 [mpt3sas]
[17235.336177]  mpt3sas_base_hard_reset_handler+0x7a7/0x9d0 [mpt3sas]
[17235.336204]  mpt3sas_scsih_issue_tm+0xaa1/0xc10 [mpt3sas]
[17235.336233]  scsih_dev_reset+0x354/0x8e0 [mpt3sas]
[17235.336262]  scsi_eh_bus_device_reset+0x255/0x7a0
[17235.336267]  scsi_eh_ready_devs+0xb6/0x5b0
[17235.336272]  scsi_unjam_host+0x2fa/0x700
[17235.336277]  scsi_error_handler+0x434/0x700
[17235.336281]  kthread+0x2d1/0x3b0
[17235.336285]  ret_from_fork+0x2b/0x70
[17235.336290]  ret_from_fork_asm+0x1b/0x30
[17235.336294]
[17235.336374] Freed by task 660838:
[17235.336463]  kasan_save_stack+0x21/0x40
[17235.336467]  kasan_set_track+0x21/0x30
[17235.336471]  kasan_save_free_info+0x27/0x40
[17235.336477]  __kasan_slab_free+0x106/0x180
[17235.336481]  __kmem_cache_free+0x174/0x370
[17235.336485]  _mpt3sas_fw_work+0x269/0x2510 [mpt3sas]
[17235.336514]  process_one_work+0x578/0xc60
[17235.336520]  worker_thread+0x6c0/0xc90
[17235.336524]  kthread+0x2d1/0x3b0
[17235.336528]  ret_from_fork+0x2b/0x70
[17235.336532]  ret_from_fork_asm+0x1b/0x30
[17235.336538]
[17235.336621] Last potentially related work creation:
[17235.336712]  kasan_save_stack+0x21/0x40
[17235.336716]  __kasan_record_aux_stack+0x94/0xa0
[17235.336721]  insert_work+0x24/0x230
[17235.336725]  __queue_work.part.0+0x3d2/0x840
[17235.336730]  queue_work_on+0x4b/0x60
[17235.336734]  _scsih_fw_event_add.part.0+0x20e/0x2c0 [mpt3sas]
[17235.336763]  mpt3sas_scsih_reset_done_handler+0x64b/0x7f0 [mpt3sas]
[17235.336791]  mpt3sas_base_hard_reset_handler+0x7a7/0x9d0 [mpt3sas]
[17235.336818]  mpt3sas_scsih_issue_tm+0xaa1/0xc10 [mpt3sas]
[17235.336847]  scsih_dev_reset+0x354/0x8e0 [mpt3sas]
[17235.336875]  scsi_eh_bus_device_reset+0x255/0x7a0
[17235.336880]  scsi_eh_ready_devs+0xb6/0x5b0
[17235.336884]  scsi_unjam_host+0x2fa/0x700
[17235.336889]  scsi_error_handler+0x434/0x700
[17235.336894]  kthread+0x2d1/0x3b0
[17235.336897]  ret_from_fork+0x2b/0x70
[17235.336902]  ret_from_fork_asm+0x1b/0x30
[17235.336907]
[17235.336993] Second to last potentially related work creation:
[17235.337083]  kasan_save_stack+0x21/0x40
[17235.337088]  __kasan_record_aux_stack+0x94/0xa0
[17235.337093]  kvfree_call_rcu+0x25/0xa20
[17235.337098]  kernfs_unlink_open_file+0x2dd/0x410
[17235.337104]  kernfs_fop_release+0xc4/0x320
[17235.337108]  __fput+0x35e/0xa10
[17235.337113]  __se_sys_close+0x4f/0xa0
[17235.337119]  do_syscall_64+0x55/0x100
[17235.337128]  entry_SYSCALL_64_after_hwframe+0x78/0xe2

After commit 991df3dd5144 ("scsi: mpt3sas: Fix use-after-free warning"),
a race condition exists in _scsih_fw_event_cleanup_queue(). When Path A
dequeues a fw_event and Path B concurrently processes the same fw_event,
the reference count can drop to zero before cancel_work_sync() is called
in Path A, leading to use-after-free when accessing the already freed
fw_event structure.

Fix this by moving the fw_event_work_put() call from dequeue_next_fw_event()
to the caller, ensuring fw_event remains valid during cancel_work_sync().

Fixes: 991df3dd5144 ("scsi: mpt3sas: Fix use-after-free warning")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 508861e88d9f..073cdedf0d68 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3659,7 +3659,6 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
-		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -3679,6 +3678,7 @@ static void
 _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
+	bool from_queue;
 
 	if ((list_empty(&ioc->fw_event_list) && !ioc->current_event) ||
 	    !ioc->firmware_event_thread)
@@ -3693,8 +3693,17 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		ioc->current_event->ignore = 1;
 
 	ioc->fw_events_cleanup = 1;
-	while ((fw_event = dequeue_next_fw_event(ioc)) ||
-	     (fw_event = ioc->current_event)) {
+	while (true) {
+		from_queue = false;
+
+		fw_event = dequeue_next_fw_event(ioc);
+		if (fw_event) {
+			from_queue = true;
+		} else {
+			fw_event = ioc->current_event;
+			if (!fw_event)
+				break;
+		}
 
 		/*
 		 * Don't call cancel_work_sync() for current_event
@@ -3713,6 +3722,8 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (fw_event == ioc->current_event &&
 		    ioc->current_event->event !=
 		    MPT3SAS_REMOVE_UNRESPONDING_DEVICES) {
+			if (from_queue)
+				fw_event_work_put(fw_event);
 			ioc->current_event = NULL;
 			continue;
 		}
@@ -3741,6 +3752,8 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
+		if (from_queue)
+			fw_event_work_put(fw_event);
 	}
 	ioc->fw_events_cleanup = 0;
 }
-- 
2.39.2

