Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E711862;
	Wed, 28 May 2025 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748393682; cv=none; b=IQ/JP75u/Ynt0GFbG8AfT++PrJ25X7hCgR3x7HRfig1g1y5blYtkrnjRORh5PmZg4Rcg8XSYQgRRY2KSSlxmsKMrpleR4Z9eVd/M2RKgw2ICvBIAYrB5LjRyk/9WG/EteswUu+9XQSgIKQuV+ZdicgBzwtyb/bdwv/LVR6G2NEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748393682; c=relaxed/simple;
	bh=gd4xfLncHNUyQzg2P69vjaMSh6/QXK433Ho/ho8ZwVA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uhgA2F1FAIbP/5yDRZRl31v1hlLOvLv5shR4EF255v+yYYC9BKH90/q5lnKT5sIbWlVI+OohPZmzHa75kvisfGeU6V6eRY+tL6/vg2kD3KbBGe4qRvGGuG/QipeaOq7zDqsglt5Twe74ryAtDNUD+bscaaaE1N/SLFa30QtkMLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b6WHK5hTWzYQv4N;
	Wed, 28 May 2025 08:54:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E3A701A178F;
	Wed, 28 May 2025 08:54:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2DKXjZomuPmNg--.45313S4;
	Wed, 28 May 2025 08:54:36 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH v2] scsi: mpt3sas: fix uaf in _scsih_fw_event_cleanup_queue() during hard reset
Date: Wed, 28 May 2025 08:49:35 +0800
Message-Id: <20250528004935.2000196-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2DKXjZomuPmNg--.45313S4
X-Coremail-Antispam: 1UD129KBjvJXoW3AF4kAw18Gr18tw15Gr17Wrg_yoW3Zw43pr
	95Ca43tws8WFyIgrsxWw1UX3WrA39Yqr1DGFW0g3Z3Ar43u34UtF18CFyYgF15Gr93Zasr
	JayDt393CFWUJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU17KsUUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Changes in v2:

  1. Reference counting: Ensuring the fw_event_work has proper reference
    counting so it's not freed while still in use
  2. Read-write locks: Protecting access to ioc->current_event with locks
     to prevent race conditions between readers and writers

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

==================================================================
BUG: KASAN: slab-use-after-free in __cancel_work_timer+0x172/0x3e0
Read of size 8 at addr ffff88be08e72610 by task scsi_eh_10/980

CPU: 50 PID: 980 Comm: scsi_eh_10 Kdump: loaded Not tainted 6.6.0+ #24
Call Trace:
 <TASK>
 __cancel_work_timer+0x172/0x3e0
 _scsih_fw_event_cleanup_queue+0x2a2/0x570 [mpt3sas]
 mpt3sas_scsih_clear_outstanding_scsi_tm_commands+0x171/0x2c0 [mpt3sas]
 mpt3sas_base_hard_reset_handler+0x2e8/0x9d0 [mpt3sas]
 mpt3sas_scsih_issue_tm+0xaa1/0xc10 [mpt3sas]
 scsih_target_reset+0x344/0x7f0 [mpt3sas]
 scsi_try_target_reset+0xa7/0x1f0
 scsi_eh_target_reset+0x4e8/0xc50
 scsi_eh_ready_devs+0xc8/0x5b0
 scsi_unjam_host+0x2fa/0x700
 scsi_error_handler+0x434/0x700
 kthread+0x2d1/0x3b0
 ret_from_fork+0x2b/0x70
 ret_from_fork_asm+0x1b/0x30
 </TASK>

Allocated by task 980:
 mpt3sas_scsih_reset_done_handler+0x575/0x7f0 [mpt3sas]
 mpt3sas_base_hard_reset_handler+0x7a7/0x9d0 [mpt3sas]
 mpt3sas_scsih_issue_tm+0xaa1/0xc10 [mpt3sas]
 scsih_dev_reset+0x354/0x8e0 [mpt3sas]
 scsi_eh_bus_device_reset+0x255/0x7a0
 scsi_eh_ready_devs+0xb6/0x5b0
 scsi_unjam_host+0x2fa/0x700
 scsi_error_handler+0x434/0x700
 kthread+0x2d1/0x3b0
 ret_from_fork+0x2b/0x70
 ret_from_fork_asm+0x1b/0x30

Freed by task 660838:
 __kmem_cache_free+0x174/0x370
 _mpt3sas_fw_work+0x269/0x2510 [mpt3sas]
 process_one_work+0x578/0xc60
 worker_thread+0x6c0/0xc90
 kthread+0x2d1/0x3b0
 ret_from_fork+0x2b/0x70
 ret_from_fork_asm+0x1b/0x30

Last potentially related work creation:
 insert_work+0x24/0x230
 __queue_work.part.0+0x3d2/0x840
 queue_work_on+0x4b/0x60
 _scsih_fw_event_add.part.0+0x20e/0x2c0 [mpt3sas]
 mpt3sas_scsih_reset_done_handler+0x64b/0x7f0 [mpt3sas]
 mpt3sas_base_hard_reset_handler+0x7a7/0x9d0 [mpt3sas]
 mpt3sas_scsih_issue_tm+0xaa1/0xc10 [mpt3sas]
 scsih_dev_reset+0x354/0x8e0 [mpt3sas]
 scsi_eh_bus_device_reset+0x255/0x7a0
 scsi_eh_ready_devs+0xb6/0x5b0
 scsi_unjam_host+0x2fa/0x700
 scsi_error_handler+0x434/0x700
 kthread+0x2d1/0x3b0
 ret_from_fork+0x2b/0x70
 ret_from_fork_asm+0x1b/0x30

Second to last potentially related work creation:
 kasan_save_stack+0x21/0x40
 __kasan_record_aux_stack+0x94/0xa0
 kvfree_call_rcu+0x25/0xa20
 kernfs_unlink_open_file+0x2dd/0x410
 kernfs_fop_release+0xc4/0x320
 __fput+0x35e/0xa10
 __se_sys_close+0x4f/0xa0
 do_syscall_64+0x55/0x100
 entry_SYSCALL_64_after_hwframe+0x78/0xe2

After commit 991df3dd5144 ("scsi: mpt3sas: Fix use-after-free warning"),
a race condition exists in _scsih_fw_event_cleanup_queue(). When Path A
dequeues a fw_event and Path B concurrently processes the same fw_event,
the reference count can drop to zero before cancel_work_sync() is called
in Path A, leading to use-after-free when accessing the already freed
fw_event structure.

Fix this by:
1. Protecting all accesses to ioc->current_event with ioc->fw_event_lock
2. Adding reference counting when accessing current_event
3. Moving the fw_event_work_put() call from dequeue_next_fw_event() to
   the caller, ensuring fw_event remains valid during cancel_work_sync()

Fixes: 991df3dd5144 ("scsi: mpt3sas: Fix use-after-free warning")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 40 +++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 508861e88d9f..a17963ce3f93 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3659,7 +3659,6 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
-		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -3679,10 +3678,15 @@ static void
 _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if ((list_empty(&ioc->fw_event_list) && !ioc->current_event) ||
-	    !ioc->firmware_event_thread)
+	    !ioc->firmware_event_thread) {
+		spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 		return;
+	}
+
 	/*
 	 * Set current running event as ignore, so that
 	 * current running event will exit quickly.
@@ -3691,10 +3695,21 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 	 */
 	if (ioc->shost_recovery && ioc->current_event)
 		ioc->current_event->ignore = 1;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
 	ioc->fw_events_cleanup = 1;
-	while ((fw_event = dequeue_next_fw_event(ioc)) ||
-	     (fw_event = ioc->current_event)) {
+	while (true) {
+		fw_event = dequeue_next_fw_event(ioc);
+
+		spin_lock_irqsave(&ioc->fw_event_lock, flags);
+		if (!fw_event) {
+			fw_event = ioc->current_event;
+			if (!fw_event) {
+				spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+				break;
+			}
+			fw_event_work_get(fw_event);
+		}
 
 		/*
 		 * Don't call cancel_work_sync() for current_event
@@ -3714,8 +3729,11 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->current_event->event !=
 		    MPT3SAS_REMOVE_UNRESPONDING_DEVICES) {
 			ioc->current_event = NULL;
+			spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+			fw_event_work_put(fw_event);
 			continue;
 		}
+		spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
 		/*
 		 * Driver has to clear ioc->start_scan flag when
@@ -3741,6 +3759,7 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
+		fw_event_work_put(fw_event);
 	}
 	ioc->fw_events_cleanup = 0;
 }
@@ -10690,15 +10709,16 @@ mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 static void
 _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	ioc->current_event = fw_event;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 	_scsih_fw_event_del_from_list(ioc, fw_event);
 
 	/* the queue is being flushed so ignore this event */
-	if (ioc->remove_host || ioc->pci_error_recovery) {
-		fw_event_work_put(fw_event);
-		ioc->current_event = NULL;
-		return;
-	}
+	if (ioc->remove_host || ioc->pci_error_recovery)
+		goto out;
 
 	switch (fw_event->event) {
 	case MPT3SAS_PROCESS_TRIGGER_DIAG:
@@ -10794,8 +10814,10 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		return;
 	}
 out:
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	fw_event_work_put(fw_event);
 	ioc->current_event = NULL;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
 /**
-- 
2.39.2

