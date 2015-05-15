From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 6/6] Fix unsafe fw_event_list usage
Date: Thu, 14 May 2015 20:42:02 -0700
Message-ID: <1431661322-3097935-7-git-send-email-calvinowens@fb.com>
References: <20150506184852.GA1007288@mail.thefacebook.com>
 <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

Since the fw_event deletes itself from the list, cleanup_queue() can
walk onto garbage pointers or walk off into freed memory.

This refactors the code in _scsih_fw_event_cleanup_queue() to not
iterate over the fw_event_list without a lock. 

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 8d8c814..f504e28 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2939,6 +2939,23 @@ mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc)
 	fw_event_work_put(fw_event);
 }
 
+static struct fw_event_work *dequeue_next_fw_event(struct MPT2SAS_ADAPTER *ioc)
+{
+	unsigned long flags;
+	struct fw_event_work *fw_event = NULL;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	if (!list_empty(&ioc->fw_event_list)) {
+		fw_event = list_first_entry(&ioc->fw_event_list,
+				struct fw_event_work, list);
+		list_del_init(&fw_event->list);
+		fw_event_work_get(fw_event);
+	}
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+
+	return fw_event;
+}
+
 /**
  * _scsih_fw_event_cleanup_queue - cleanup event queue
  * @ioc: per adapter object
@@ -2951,17 +2968,18 @@ mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc)
 static void
 _scsih_fw_event_cleanup_queue(struct MPT2SAS_ADAPTER *ioc)
 {
-	struct fw_event_work *fw_event, *next;
+	struct fw_event_work *fw_event;
 
 	if (list_empty(&ioc->fw_event_list) ||
 	     !ioc->firmware_event_thread || in_interrupt())
 		return;
 
-	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
+	while ((fw_event = dequeue_next_fw_event(ioc))) {
 		if (cancel_delayed_work_sync(&fw_event->delayed_work)) {
 			_scsih_fw_event_free(ioc, fw_event);
 			continue;
 		}
+		fw_event_work_put(fw_event);
 	}
 }
 
-- 
1.8.1
