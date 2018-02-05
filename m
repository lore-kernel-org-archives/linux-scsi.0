From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH] libiscsi: ensure session spin lock usage consistent
Date: Mon,  5 Feb 2018 11:13:23 -0800
Message-ID: <20180205191323.5274-1-lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbeBETOE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 14:14:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>, hare@suse.de, Lee Duncan <lduncan@suse.com>

The libiscsi code was using both spin_lock()/spin_unlock()
and spin_lock_bh()/spin_unlock_bh() on its session lock.
In addition, lock validation found that libiscsi.c was
taking a HARDIRQ-unsafe lock while holding an HARDIRQ-
irq-safe lock:

> [ 2528.738454] =====================================================
> [ 2528.744679] WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
> [ 2528.749891] 4.15.0-00006-g4548e6f42022-dirty #418 Not tainted
> [ 2528.754356] -----------------------------------------------------
> [ 2528.759643] kworker/0:1H/100 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [ 2528.764608]  (&(&session->frwd_lock)->rlock){+.-.}, at: [<0000000097d8de0f>] iscsi_eh_cmd_timed_out+0x3d/0x2b0
> [ 2528.769164]
>                and this task is already holding:
> [ 2528.771313]  (&(&q->__queue_lock)->rlock){-.-.}, at: [<00000000a105bf06>] blk_timeout_work+0x22/0x120
> [ 2528.773825] which would create a new lock dependency:
> [ 2528.775216]  (&(&q->__queue_lock)->rlock){-.-.} -> (&(&session->frwd_lock)->rlock){+.-.}
> [ 2528.777071]
>                but this new dependency connects a HARDIRQ-irq-safe lock:
> [ 2528.778945]  (&(&q->__queue_lock)->rlock){-.-.}
> [ 2528.778948]
>                ... which became HARDIRQ-irq-safe at:
> [ 2528.781204]   _raw_spin_lock_irqsave+0x3c/0x4b
> [ 2528.781966]   cfq_idle_slice_timer+0x2f/0x100
> [ 2528.782705]   __hrtimer_run_queues+0xdc/0x440
> [ 2528.783448]   hrtimer_interrupt+0xb1/0x210
> [ 2528.784149]   smp_apic_timer_interrupt+0x6d/0x260
> [ 2528.784954]   apic_timer_interrupt+0xac/0xc0
> [ 2528.785679]   native_safe_halt+0x2/0x10
> [ 2528.786280]   default_idle+0x1f/0x180
> [ 2528.786806]   do_idle+0x166/0x1e0
> [ 2528.787288]   cpu_startup_entry+0x6f/0x80
> [ 2528.787874]   start_secondary+0x186/0x1e0
> [ 2528.788448]   secondary_startup_64+0xa5/0xb0
> [ 2528.789070]
>                to a HARDIRQ-irq-unsafe lock:
> [ 2528.789913]  (&(&session->frwd_lock)->rlock){+.-.}
> [ 2528.789915]
>                ... which became HARDIRQ-irq-unsafe at:
> [ 2528.791548] ...
> [ 2528.791553]   _raw_spin_lock_bh+0x34/0x40
> [ 2528.792366]   iscsi_conn_setup+0x166/0x220
> [ 2528.792960]   iscsi_tcp_conn_setup+0x10/0x40
> [ 2528.793526]   iscsi_sw_tcp_conn_create+0x1b/0x160
> [ 2528.794111]   iscsi_if_rx+0xf9f/0x1580
> [ 2528.794542]   netlink_unicast+0x1f7/0x2f0
> [ 2528.795105]   netlink_sendmsg+0x2c9/0x3c0
> [ 2528.795636]   sock_sendmsg+0x30/0x40
> [ 2528.796068]   ___sys_sendmsg+0x269/0x2c0
> [ 2528.796544]   __sys_sendmsg+0x51/0x90
> [ 2528.797028]   entry_SYSCALL_64_fastpath+0x25/0x9c
> [ 2528.797595]
> ...

This commit avoids possible reverse deadlock.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4bc938..055357b2fe9e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1248,9 +1248,9 @@ int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	int rc;
 
-	spin_lock(&conn->session->lock);
+	spin_lock_bh(&conn->session->lock);
 	rc = __iscsi_complete_pdu(conn, hdr, data, datalen);
-	spin_unlock(&conn->session->lock);
+	spin_unlock_bh(&conn->session->lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
@@ -1749,14 +1749,14 @@ static void iscsi_tmf_timedout(unsigned long data)
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
 
-	spin_lock(&session->lock);
+	spin_lock_bh(&session->lock);
 	if (conn->tmf_state == TMF_QUEUED) {
 		conn->tmf_state = TMF_TIMEDOUT;
 		ISCSI_DBG_EH(session, "tmf timedout\n");
 		/* unblock eh_abort() */
 		wake_up(&conn->ehwait);
 	}
-	spin_unlock(&session->lock);
+	spin_unlock_bh(&session->lock);
 }
 
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
@@ -1908,7 +1908,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
-	spin_lock(&session->lock);
+	spin_lock_bh(&session->lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -2022,7 +2022,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 done:
 	if (task)
 		task->last_timeout = jiffies;
-	spin_unlock(&session->lock);
+	spin_unlock_bh(&session->lock);
 	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 		     "timer reset" : "nh");
 	return rc;
@@ -2034,7 +2034,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	struct iscsi_session *session = conn->session;
 	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
-	spin_lock(&session->lock);
+	spin_lock_bh(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
 		goto done;
 
@@ -2051,7 +2051,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 				  "last ping %lu, now %lu\n",
 				  conn->ping_timeout, conn->recv_timeout,
 				  last_recv, conn->last_ping, jiffies);
-		spin_unlock(&session->lock);
+		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		return;
 	}
@@ -2067,7 +2067,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	ISCSI_DBG_CONN(conn, "Setting next tmo %lu\n", next_timeout);
 	mod_timer(&conn->transport_timer, next_timeout);
 done:
-	spin_unlock(&session->lock);
+	spin_unlock_bh(&session->lock);
 }
 
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
-- 
2.13.6
