From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/10] iscsi: fix 4k stack iscsi setups
Date: Thu, 12 Jan 2006 23:08:44 -0600
Message-ID: <1137128924.9508.41.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1968 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964926AbWAMFJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 00:09:22 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0D59Lq6016460
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 23:09:21 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Mike Christie <michaelc@cs.wisc.edu>:

When we run the xmit code from queuecomand the stack usage
gets too high. The patch runs the xmit code from the scsi_host
work queue. This fixes 4k stack and xfs support and should
fix the st and sg stack usage bugs.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_if.c b/drivers/scsi/iscsi_if.c
index 5fb6457..615bf56 100644
--- a/drivers/scsi/iscsi_if.c
+++ b/drivers/scsi/iscsi_if.c
@@ -442,6 +442,7 @@ iscsi_if_create_session(struct iscsi_int
 	shost->max_lun = transport->max_lun;
 	shost->max_cmd_len = transport->max_cmd_len;
 	shost->transportt = &priv->t;
+	shost->transportt->create_work_queue = 1;
 
 	err = scsi_add_host(shost, NULL);
 	if (err)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ccffd98..b17c121 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -525,7 +525,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 	__kfifo_put(ctask->r2tqueue, (void*)&r2t, sizeof(void*));
 	__kfifo_put(conn->writequeue, (void*)&ctask, sizeof(void*));
 
-	schedule_work(&conn->xmitwork);
+	scsi_queue_work(session->host, &conn->xmitwork);
 	conn->r2t_pdus_cnt++;
 	spin_unlock(&session->lock);
 
@@ -1267,7 +1267,7 @@ iscsi_write_space(struct sock *sk)
 	conn->old_write_space(sk);
 	debug_tcp("iscsi_write_space: cid %d\n", conn->id);
 	clear_bit(SUSPEND_BIT, &conn->suspend_tx);
-	schedule_work(&conn->xmitwork);
+	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
 static void
@@ -2275,7 +2275,7 @@ iscsi_xmitworker(void *data)
 	 */
 	mutex_lock(&conn->xmitmutex);
 	if (iscsi_data_xmit(conn))
-		schedule_work(&conn->xmitwork);
+		scsi_queue_work(conn->session->host, &conn->xmitwork);
 	mutex_unlock(&conn->xmitmutex);
 }
 
@@ -2340,15 +2340,7 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	spin_unlock(&session->lock);
 
-        if (!in_interrupt() && mutex_trylock(&conn->xmitmutex)) {
-		spin_unlock_irq(host->host_lock);
-		if (iscsi_data_xmit(conn))
-			schedule_work(&conn->xmitwork);
-		mutex_unlock(&conn->xmitmutex);
-		spin_lock_irq(host->host_lock);
-	} else
-		schedule_work(&conn->xmitwork);
-
+	scsi_queue_work(host, &conn->xmitwork);
 	return 0;
 
 reject:
@@ -2932,8 +2924,7 @@ iscsi_conn_send_generic(struct iscsi_con
 	else
 	        __kfifo_put(conn->mgmtqueue, (void*)&mtask, sizeof(void*));
 
-	schedule_work(&conn->xmitwork);
-
+	scsi_queue_work(session->host, &conn->xmitwork);
 	return 0;
 }
 


