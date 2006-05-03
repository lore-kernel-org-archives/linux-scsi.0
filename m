From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/5] iscsi: align printks
Date: Tue, 02 May 2006 19:46:43 -0500
Message-ID: <1146617203.2601.16.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:62125 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965057AbWECAoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 20:44:34 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k430iXsQ010716
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 19:44:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

from or:

align printk output

Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ac507da..41f4bb5 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2585,7 +2585,8 @@ static int __init
 iscsi_tcp_init(void)
 {
 	if (iscsi_max_lun < 1) {
-		printk(KERN_ERR "Invalid max_lun value of %u\n", iscsi_max_lun);
+		printk(KERN_ERR "iscsi_tcp: Invalid max_lun value of %u\n",
+		       iscsi_max_lun);
 		return -EINVAL;
 	}
 	iscsi_tcp_transport.max_lun = iscsi_max_lun;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8c51f6c..a99f2ef 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -235,8 +235,8 @@ static int iscsi_scsi_cmd_rsp(struct isc
 
 		if (datalen < 2) {
 invalid_datalen:
-			printk(KERN_ERR "Got CHECK_CONDITION but invalid "
-			       "data buffer size of %d\n", datalen);
+			printk(KERN_ERR "iscsi: Got CHECK_CONDITION but "
+			       "invalid data buffer size of %d\n", datalen);
 			sc->result = DID_BAD_TARGET << 16;
 			goto out;
 		}
@@ -441,7 +441,7 @@ int iscsi_verify_itt(struct iscsi_conn *
 	if (hdr->itt != cpu_to_be32(ISCSI_RESERVED_TAG)) {
 		if ((hdr->itt & ISCSI_AGE_MASK) !=
 		    (session->age << ISCSI_AGE_SHIFT)) {
-			printk(KERN_ERR "iscsi_tcp: received itt %x expected "
+			printk(KERN_ERR "iscsi: received itt %x expected "
 				"session age (%x)\n", hdr->itt,
 				session->age & ISCSI_AGE_MASK);
 			return ISCSI_ERR_BAD_ITT;
@@ -449,7 +449,7 @@ int iscsi_verify_itt(struct iscsi_conn *
 
 		if ((hdr->itt & ISCSI_CID_MASK) !=
 		    (conn->id << ISCSI_CID_SHIFT)) {
-			printk(KERN_ERR "iscsi_tcp: received itt %x, expected "
+			printk(KERN_ERR "iscsi: received itt %x, expected "
 				"CID (%x)\n", hdr->itt, conn->id);
 			return ISCSI_ERR_BAD_ITT;
 		}
@@ -461,14 +461,14 @@ int iscsi_verify_itt(struct iscsi_conn *
 		ctask = session->cmds[itt];
 
 		if (!ctask->sc) {
-			printk(KERN_INFO "iscsi_tcp: dropping ctask with "
+			printk(KERN_INFO "iscsi: dropping ctask with "
 			       "itt 0x%x\n", ctask->itt);
 			/* force drop */
 			return ISCSI_ERR_NO_SCSI_CMD;
 		}
 
 		if (ctask->sc->SCp.phase != session->age) {
-			printk(KERN_ERR "iscsi_tcp: ctask's session age %d, "
+			printk(KERN_ERR "iscsi: ctask's session age %d, "
 				"expected %d\n", ctask->sc->SCp.phase,
 				session->age);
 			return ISCSI_ERR_SESSION_FAILED;
@@ -686,7 +686,7 @@ reject:
 
 fault:
 	spin_unlock(&session->lock);
-	printk(KERN_ERR "iscsi_tcp: cmd 0x%x is not queued (%d)\n",
+	printk(KERN_ERR "iscsi: cmd 0x%x is not queued (%d)\n",
 	       sc->cmnd[0], reason);
 	sc->result = (DID_NO_CONNECT << 16);
 	sc->resid = sc->request_bufflen;
@@ -857,7 +857,7 @@ failed:
 
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_LOGGED_IN)
-		printk(KERN_INFO "host reset succeeded\n");
+		printk(KERN_INFO "iscsi: host reset succeeded\n");
 	else
 		goto failed;
 	spin_unlock_bh(&session->lock);
@@ -1042,8 +1042,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	/* what should we do here ? */
 	if (conn->ctask == ctask) {
-		printk(KERN_INFO "sc %p itt 0x%x partially sent. Failing "
-		       "abort\n", sc, ctask->itt);
+		printk(KERN_INFO "iscsi: sc %p itt 0x%x partially sent. "
+		       "Failing abort\n", sc, ctask->itt);
 		goto failed;
 	}
 
@@ -1441,8 +1441,9 @@ void iscsi_conn_teardown(struct iscsi_cl
 		}
 		spin_unlock_irqrestore(session->host->host_lock, flags);
 		msleep_interruptible(500);
-		printk("conn_destroy(): host_busy %d host_failed %d\n",
-			session->host->host_busy, session->host->host_failed);
+		printk(KERN_INFO "iscsi: scsi conn_destroy(): host_busy %d "
+		       "host_failed %d\n", session->host->host_busy,
+		       session->host->host_failed);
 		/*
 		 * force eh_abort() to unblock
 		 */
@@ -1662,7 +1663,7 @@ void iscsi_conn_stop(struct iscsi_cls_co
 		mutex_unlock(&conn->xmitmutex);
 		break;
 	default:
-		printk(KERN_ERR "invalid stop flag %d\n", flag);
+		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
 	}
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
@@ -1679,7 +1680,7 @@ int iscsi_conn_bind(struct iscsi_cls_ses
 		if (tmp == conn) {
 			if (conn->c_stage != ISCSI_CONN_STOPPED ||
 			    conn->stop_stage == STOP_CONN_TERM) {
-				printk(KERN_ERR "iscsi_tcp: can't bind "
+				printk(KERN_ERR "iscsi: can't bind "
 				       "non-stopped connection (%d:%d)\n",
 				       conn->c_stage, conn->stop_stage);
 				spin_unlock_bh(&session->lock);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7b7a194..1b96f7c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -266,8 +266,8 @@ static void session_recovery_timedout(vo
 {
 	struct iscsi_cls_session *session = data;
 
-	dev_printk(KERN_INFO, &session->dev, "session recovery timed out "
-		  "after %d secs\n", session->recovery_tmo);
+	dev_printk(KERN_INFO, &session->dev, "iscsi: session recovery timed "
+		  "out after %d secs\n", session->recovery_tmo);
 
 	if (session->transport->session_recovery_timedout)
 		session->transport->session_recovery_timedout(session);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 830700a..2dba929 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -41,7 +41,7 @@ struct iscsi_nopin;
 
 /* #define DEBUG_SCSI */
 #ifdef DEBUG_SCSI
-#define debug_scsi(fmt...) printk(KERN_INFO "scsi: " fmt)
+#define debug_scsi(fmt...) printk(KERN_INFO "iscsi: " fmt)
 #else
 #define debug_scsi(fmt...)
 #endif


