From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] sched/wait: Add wait_event_lock_irq_timeout for TASK_UNINTERRUPTIBLE usage
Date: Wed, 10 Oct 2018 03:23:09 +0000
Message-ID: <1539141790-13557-2-git-send-email-nab@linux-iscsi.org>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Short of reverting commit 00d909a107 for v4.19, target-core needs a
wait_event_t marco can be executed using TASK_UNINTERRUPTIBLE to
function correctly with existing fabric drivers that expect to run
with signals pending during session shutdown and active se_cmd I/O
quiesce.

The most notable is iscsi-target/iser-target, while ibmvscsi_tgt invokes
session shutdown logic from userspace via configfs attribute that could
also potentially have signals pending.

So go ahead and introduce wait_event_lock_irq_timeout() to achieve this,
and update + rename __wait_event_lock_irq_timeout() to make it accept
'state' as a parameter.

Fixes: 00d909a107 ("scsi: target: Make the session shutdown code also wait for commands that are being aborted")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/wait.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index d9f131e..ed7c122 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1052,10 +1052,9 @@ void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
 	__ret;									\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq_head, condition,		\
-						    lock, timeout)		\
+#define __wait_event_lock_irq_timeout(wq_head, condition, lock, timeout, state)	\
 	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
-		      TASK_INTERRUPTIBLE, 0, timeout,				\
+		      state, 0, timeout,					\
 		      spin_unlock_irq(&lock);					\
 		      __ret = schedule_timeout(__ret);				\
 		      spin_lock_irq(&lock));
@@ -1089,8 +1088,19 @@ void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
 ({										\
 	long __ret = timeout;							\
 	if (!___wait_cond_timeout(condition))					\
-		__ret = __wait_event_interruptible_lock_irq_timeout(		\
-					wq_head, condition, lock, timeout);	\
+		__ret = __wait_event_lock_irq_timeout(				\
+					wq_head, condition, lock, timeout,	\
+					TASK_INTERRUPTIBLE);			\
+	__ret;									\
+})
+
+#define wait_event_lock_irq_timeout(wq_head, condition, lock, timeout)		\
+({										\
+	long __ret = timeout;							\
+	if (!___wait_cond_timeout(condition))					\
+		__ret = __wait_event_lock_irq_timeout(				\
+					wq_head, condition, lock, timeout,	\
+					TASK_UNINTERRUPTIBLE);			\
 	__ret;									\
 })
 
-- 
1.9.1
