From: ravi.anand@qlogic.com
Subject: [PATCH 06/11] Change semaphore usage to mutex.
Date: Tue, 7 Mar 2006 16:35:43 -0800
Message-ID: <11417781373685-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:22001 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964853AbWCHAfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:46 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_def.h |    6 +++---
 drivers/scsi/qla4xxx/ql4_mbx.c |    4 ++--
 drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

d31fabeaf8cc7ba8b9448cbe0d8db464fe04af05
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 98c5922..4d1653c 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -23,7 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -497,10 +497,10 @@ typedef struct scsi_qla_host {
 	PDU_ENTRY *free_pdu_bottom;
 	PDU_ENTRY pdu_queue[MAX_PDU_ENTRIES];
 
-	/* This semaphore protects several threads to do mailbox commands
+	/* This mutex protects several threads to do mailbox commands
 	 * concurrently.
 	 */
-	struct semaphore mbox_sem;
+	struct mutex  mbox_sem;
 	wait_queue_head_t mailbox_wait_queue;
 
 	/* temporary mailbox status registers */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0dd350b..823c4c2 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -51,7 +51,7 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
 	unsigned long flags = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	down(&ha->mbox_sem);
+	mutex_lock(&ha->mbox_sem);
 
 	/* Mailbox code active */
 	set_bit(AF_MBOX_COMMAND, &ha->flags);
@@ -175,7 +175,7 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
 mbox_exit:
 	clear_bit(AF_MBOX_COMMAND, &ha->flags);
 	clear_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
-	up(&ha->mbox_sem);
+	mutex_unlock(&ha->mbox_sem);
 
 	return status;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1271edf..27aabb9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -358,7 +358,7 @@ qla4xxx_probe_adapter(struct pci_dev *pd
 	INIT_LIST_HEAD(&ha->ddb_list);
 	INIT_LIST_HEAD(&ha->free_srb_q);
 
-	init_MUTEX(&ha->mbox_sem);
+	mutex_init(&ha->mbox_sem);
 	init_waitqueue_head(&ha->mailbox_wait_queue);
 
 	spin_lock_init(&ha->hardware_lock);
-- 
1.2.4.g9201-dirty


