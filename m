From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/10] iscsi: host locking fix
Date: Thu, 12 Jan 2006 23:08:30 -0600
Message-ID: <1137128910.9508.36.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:64943 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751499AbWAMFIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 00:08:45 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0D58h3Y016445
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 23:08:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From zhenyu.z.wang@intel.com:

We should be taking the host_lock instead of the conn lock when
checking host_busy.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 550ff66..cd1491e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2559,6 +2559,7 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 {
 	struct iscsi_conn *conn = iscsi_ptr(connh);
 	struct iscsi_session *session = conn->session;
+	unsigned long flags;
 
 	mutex_lock(&conn->xmitmutex);
 	set_bit(SUSPEND_BIT, &conn->suspend_tx);
@@ -2598,12 +2599,12 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 	 * time out or fail.
 	 */
 	for (;;) {
-		spin_lock_bh(&conn->lock);
+		spin_lock_irqsave(session->host->host_lock, flags);
 		if (!session->host->host_busy) { /* OK for ERL == 0 */
-			spin_unlock_bh(&conn->lock);
+			spin_unlock_irqrestore(session->host->host_lock, flags);
 			break;
 		}
-		spin_unlock_bh(&conn->lock);
+		spin_unlock_irqrestore(session->host->host_lock, flags);
 		msleep_interruptible(500);
 		printk("conn_destroy(): host_busy %d host_failed %d\n",
 			session->host->host_busy, session->host->host_failed);


