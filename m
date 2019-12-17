Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D48C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 01:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 616AF24655
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 01:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLQB3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 20:29:10 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38908 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfLQB3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 20:29:09 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::647])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id C6505291DF6;
        Tue, 17 Dec 2019 01:29:07 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     mchristi@redhat.com, martin.petersen@oracle.com, cleech@redhat.com
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel@collabora.com, Lee Duncan <LDuncan@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v2] iscsi: Perform connection failure entirely in kernel space
Date:   Mon, 16 Dec 2019 20:29:04 -0500
Message-Id: <20191217012904.3834747-1-krisman@collabora.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bharath Ravi <rbharath@google.com>

Connection failure processing depends on a daemon being present to (at
least) stop the connection and start recovery.  This is a problem on a
multipath scenario, where if the daemon failed for whatever reason, the
SCSI path is never marked as down, multipath won't perform the
failover and IO to the device will be forever waiting for that
connection to come back.

This patch implements an optional feature in the iscsi module, to
perform the connection failure inside the kernel.  This way, the
failover can happen and pending IO can continue even if the daemon is
dead. Once the daemon comes alive again, it can perform recovery
procedures if applicable.

Changes since v1:
  - Remove module parameter.
  - Always do kernel-side stop work.
  - Block recovery timeout handler if system is dying.
  - send a CONN_TERM stop if the system is dying.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Lee Duncan <LDuncan@suse.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Co-developed-by: Dave Clausen <dclausen@google.com>
Signed-off-by: Dave Clausen <dclausen@google.com>
Co-developed-by: Nick Black <nlb@google.com>
Signed-off-by: Nick Black <nlb@google.com>
Co-developed-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Co-developed-by: Anatol Pomazau <anatol@google.com>
Signed-off-by: Anatol Pomazau <anatol@google.com>
Co-developed-by: Tahsin Erdogan <tahsin@google.com>
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
Co-developed-by: Frank Mayhar <fmayhar@google.com>
Signed-off-by: Frank Mayhar <fmayhar@google.com>
Co-developed-by: Junho Ryu <jayr@google.com>
Signed-off-by: Junho Ryu <jayr@google.com>
Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Bharath Ravi <rbharath@google.com>
Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 51 +++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 52 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 417b868d8735..8da35ecad697 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -84,6 +84,12 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
+/* Worker to perform connection failure on unresponsive connections
+ * completely in kernel space.
+ */
+static void stop_conn_work_fn(struct work_struct *work);
+static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
+
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
@@ -1609,6 +1615,7 @@ static DEFINE_MUTEX(rx_queue_mutex);
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
+static LIST_HEAD(connlist_err);
 static DEFINE_SPINLOCK(connlock);
 
 static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
@@ -2245,6 +2252,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
+	INIT_LIST_HEAD(&conn->conn_list_err);
 	conn->transport = transport;
 	conn->cid = cid;
 
@@ -2291,6 +2299,7 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
+	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2405,6 +2414,42 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
 
+static void stop_conn_work_fn(struct work_struct *work)
+{
+	struct iscsi_cls_conn *conn, *tmp;
+	unsigned long flags;
+	LIST_HEAD(recovery_list);
+
+	spin_lock_irqsave(&connlock, flags);
+	if (list_empty(&connlist_err)) {
+		spin_unlock_irqrestore(&connlock, flags);
+		return;
+	}
+	list_splice_init(&connlist_err, &recovery_list);
+	spin_unlock_irqrestore(&connlock, flags);
+
+	mutex_lock(&rx_queue_mutex);
+	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
+		uint32_t sid = iscsi_conn_get_sid(conn);
+		struct iscsi_cls_session *session = iscsi_session_lookup(sid);
+
+		if (!session) {
+			list_del_init(&conn->conn_list_err);
+			continue;
+		}
+
+		if (system_state != SYSTEM_RUNNING) {
+			session->recovery_tmo = 0;
+			conn->transport->stop_conn(conn, STOP_CONN_TERM);
+		} else {
+			conn->transport->stop_conn(conn, STOP_CONN_RECOVER);
+		}
+
+		list_del_init(&conn->conn_list_err);
+	}
+	mutex_unlock(&rx_queue_mutex);
+}
+
 void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
@@ -2412,6 +2457,12 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
+	unsigned long flags;
+
+	spin_lock_irqsave(&connlock, flags);
+	list_add(&conn->conn_list_err, &connlist_err);
+	spin_unlock_irqrestore(&connlock, flags);
+	queue_work(system_unbound_wq, &stop_conn_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 325ae731d9ad..2129dc9e2dec 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -190,6 +190,7 @@ extern void iscsi_ping_comp_event(uint32_t host_no,
 
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
+	struct list_head conn_list_err;	/* item in connlist_err */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
-- 
2.24.0

