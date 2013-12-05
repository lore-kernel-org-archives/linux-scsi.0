From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] iscsi_target: race condition on shutdown
Date: Thu,  5 Dec 2013 14:54:25 +0100
Message-ID: <1386251665-39173-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When shutting down a target there is a race condition between
iscsit_del_np() and __iscsi_target_login_thread().
The latter sets the thread pointer to NULL, and the former
tries to issue kthread_stop() on that pointer without any
synchronization.

This patchs adds proper synchronization pointer between those
calls to ensure that a) the thread is correctly terminate and
b) kthread_stop() isn't called with a NULL pointer.

In the long run iscsi_target_login_thread() should be converted
into a workqueue.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/iscsi/iscsi_target.c       | 12 +++++++++---
 drivers/target/iscsi/iscsi_target_login.c |  9 ++++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index bf76fc4..c7bf3c9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -457,15 +457,21 @@ int iscsit_del_np(struct iscsi_np *np)
 	}
 	np->np_thread_state = ISCSI_NP_THREAD_SHUTDOWN;
 	spin_unlock_bh(&np->np_thread_lock);
-
-	if (np->np_thread) {
+	/* Give __iscsi_target_login_thread() a chance to run */
+	schedule();
+	spin_lock_bh(&np->np_thread_lock);
+	if ((np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN)
+	    && np->np_thread) {
+		np->np_thread_state = ISCSI_NP_THREAD_EXIT;
+		spin_unlock_bh(&np->np_thread_lock);
 		/*
 		 * We need to send the signal to wakeup Linux/Net
 		 * which may be sleeping in sock_accept()..
 		 */
 		send_sig(SIGINT, np->np_thread, 1);
 		kthread_stop(np->np_thread);
-	}
+	} else
+		spin_unlock_bh(&np->np_thread_lock);
 
 	np->np_transport->iscsit_free_np(np);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 4eb93b2..b375d26 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1405,7 +1405,8 @@ out:
 	stop = kthread_should_stop();
 	if (!stop && signal_pending(current)) {
 		spin_lock_bh(&np->np_thread_lock);
-		stop = (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN);
+		stop = (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN ||
+			np->np_thread_state == ISCSI_NP_THREAD_EXIT);
 		spin_unlock_bh(&np->np_thread_lock);
 	}
 	/* Wait for another socket.. */
@@ -1414,8 +1415,10 @@ out:
 exit:
 	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
-	np->np_thread_state = ISCSI_NP_THREAD_EXIT;
-	np->np_thread = NULL;
+	if (np->np_thread_state != ISCSI_NP_THREAD_EXIT) {
+		np->np_thread_state = ISCSI_NP_THREAD_EXIT;
+		np->np_thread = NULL;
+	}
 	spin_unlock_bh(&np->np_thread_lock);
 
 	return 0;
-- 
1.7.12.4
