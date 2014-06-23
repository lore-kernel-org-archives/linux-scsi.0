From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] target: fix deadlock on unload
Date: Mon, 23 Jun 2014 13:42:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1406231329430.8277@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

target: fix deadlock on unload

On uniprocessor preemptible kernel, target core deadlocks on unload. The
following events happen:
* iscsit_del_np is called
* it calls send_sig(SIGINT, np->np_thread, 1);
* the scheduler switches to the np_thread
* the np_thread is woken up, it sees that kthread_should_stop() returns
  false, so it doesn't terminate
* the np_thread clears signals with flush_signals(current); and goes back
  to sleep in iscsit_accept_np
* the scheduler switches back to iscsit_del_np
* iscsit_del_np calls kthread_stop(np->np_thread);
* the np_thread is waiting in iscsit_accept_np and it doesn't respond to
  kthread_stop

The deadlock could be resolved if the administrator sends SIGINT signal to
the np_thread with killall -INT iscsi_np

The reproducible deadlock was introduced in commit
db6077fd0b7dd41dc6ff18329cec979379071f87, but the thread-stopping code was
racy even before.

This patch fixes the problem. Using kthread_should_stop to stop the
np_thread is unreliable, so we test np_thread_state instead. If
np_thread_state equals ISCSI_NP_THREAD_SHUTDOWN, the thread exits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/target/iscsi/iscsi_target_login.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-3.14.8/drivers/target/iscsi/iscsi_target_login.c
===================================================================
--- linux-3.14.8.orig/drivers/target/iscsi/iscsi_target_login.c	2014-06-19 00:10:44.634113370 +0200
+++ linux-3.14.8/drivers/target/iscsi/iscsi_target_login.c	2014-06-23 19:05:44.887437402 +0200
@@ -1196,7 +1196,7 @@ old_sess_out:
 static int __iscsi_target_login_thread(struct iscsi_np *np)
 {
 	u8 *buffer, zero_tsih = 0;
-	int ret = 0, rc, stop;
+	int ret = 0, rc;
 	struct iscsi_conn *conn = NULL;
 	struct iscsi_login *login;
 	struct iscsi_portal_group *tpg = NULL;
@@ -1210,6 +1210,9 @@ static int __iscsi_target_login_thread(s
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 		complete(&np->np_restart_comp);
+	} else if (np->np_thread_state == ISCSI_NP_THREAD_SHUTDOWN) {
+		spin_unlock_bh(&np->np_thread_lock);
+		goto exit;
 	} else {
 		np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 	}
@@ -1402,10 +1405,8 @@ old_sess_out:
 	}
 
 out:
-	stop = kthread_should_stop();
-	/* Wait for another socket.. */
-	if (!stop)
-		return 1;
+	return 1;
+
 exit:
 	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
@@ -1422,7 +1423,7 @@ int iscsi_target_login_thread(void *arg)
 
 	allow_signal(SIGINT);
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		ret = __iscsi_target_login_thread(np);
 		/*
 		 * We break and exit here unless another sock_accept() call
