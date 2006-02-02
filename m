From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/9] iscsi update: rm conn lock
Date: Wed, 01 Feb 2006 21:07:03 -0600
Message-ID: <1138849623.3456.38.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31412 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423071AbWBBDH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>From erezz@voltaire.com:

rm conn->lock since it is not used anymore. The dataqueue is protected
by the session lock and xmitmutex.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 323fd19..7965c46 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -244,12 +244,10 @@ iscsi_ctask_cleanup(struct iscsi_conn *c
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		struct iscsi_data_task *dtask, *n;
 		/* WRITE: cleanup Data-Out's if any */
-		spin_lock(&conn->lock);
 		list_for_each_entry_safe(dtask, n, &ctask->dataqueue, item) {
 			list_del(&dtask->item);
 			mempool_free(dtask, ctask->datapool);
 		}
-		spin_unlock(&conn->lock);
 	}
 	ctask->xmstate = XMSTATE_IDLE;
 	ctask->r2t = NULL;
@@ -2453,8 +2451,6 @@ iscsi_conn_create(struct iscsi_cls_sessi
 	conn->data_size = DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH;
 	conn->max_recv_dlength = DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH;
 
-	spin_lock_init(&conn->lock);
-
 	/* initialize general xmit PDU commands queue */
 	conn->xmitqueue = kfifo_alloc(session->cmds_max * sizeof(void*),
 					GFP_KERNEL, NULL);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 6766b81..ba26741 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -146,7 +146,6 @@ struct iscsi_conn {
 	struct iscsi_mgmt_task	*login_mtask;	/* mtask used for login/text */
 	struct iscsi_mgmt_task	*mtask;		/* xmit mtask in progress */
 	struct iscsi_cmd_task	*ctask;		/* xmit ctask in progress */
-	spinlock_t		lock;		/* FIXME: to be removed */
 
 	/* old values for socket callbacks */
 	void			(*old_data_ready)(struct sock *, int);


