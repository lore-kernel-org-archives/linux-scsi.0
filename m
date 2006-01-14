From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 7/8] iscsi: fix 4k stack iscsi setups
Date: Fri, 13 Jan 2006 18:05:53 -0600
Message-ID: <1137197153.2720.40.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33460 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423157AbWANAG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:06:26 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E06PVk021739
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:06:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Mike Christie <michaelc@cs.wisc.edu>:

This v2 of the patch. This version has been rediffed so that is applies
cleanly.

When we run the xmit code from queuecomand the stack trace
gets too deep. The patch runs the xmit code from the scsi_host
work queue. This fixes 4k stack and xfs support and should
fix the st and sg stack usage bugs.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f81f305..c77b991 100644
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
@@ -2942,8 +2934,7 @@ iscsi_conn_send_generic(struct iscsi_con
 	else
 	        __kfifo_put(conn->mgmtqueue, (void*)&mtask, sizeof(void*));
 
-	schedule_work(&conn->xmitwork);
-
+	scsi_queue_work(session->host, &conn->xmitwork);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 45e3163..59a1c9d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -379,6 +379,7 @@ iscsi_transport_create_session(struct sc
 	shost->max_lun = transport->max_lun;
 	shost->max_cmd_len = transport->max_cmd_len;
 	shost->transportt = scsit;
+	shost->transportt->create_work_queue = 1;
 
 	if (scsi_add_host(shost, NULL))
 		goto free_host;


