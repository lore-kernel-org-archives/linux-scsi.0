Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01FCC11D3D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 20:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913BD24699
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 20:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgB0UAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:00:19 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41976 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgB0UAT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Feb 2020 15:00:19 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 8B0CE28EE39;
        Thu, 27 Feb 2020 20:00:17 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     lduncan@suse.com
Cc:     cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        Frank Mayhar <fmayhar@google.com>, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH RESEND v2] iscsi: Add support for asynchronous iSCSI session destruction
Date:   Thu, 27 Feb 2020 14:59:45 -0500
Message-Id: <20200227195945.761719-1-krisman@collabora.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Frank Mayhar <fmayhar@google.com>

iSCSI session destruction can be arbitrarily slow, since it might
require network operations and serialization inside the scsi layer.
This patch adds a new user event to trigger the destruction work
asynchronously, releasing the rx_queue_mutex as soon as the operation is
queued and before it is performed.  This change allow other operations
to run in other sessions in the meantime, removing one of the major
iSCSI bottlenecks for us.

To prevent the session from being used after the destruction request, we
remove it immediately from the sesslist. This simplifies the locking
required during the asynchronous removal.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Frank Mayhar <fmayhar@google.com>
Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
changes since v1:
  - Add -ENOMEM error return code

 drivers/scsi/scsi_transport_iscsi.c | 38 +++++++++++++++++++++++++++++
 include/scsi/iscsi_if.h             |  1 +
 include/scsi/scsi_transport_iscsi.h |  1 +
 3 files changed, 40 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f3f0ecdb09a2..17a45716a0fe 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -95,6 +95,8 @@ static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
+static struct workqueue_struct *iscsi_destroy_workq;
+
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -1615,6 +1617,7 @@ static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
 static LIST_HEAD(sesslist);
+static LIST_HEAD(sessdestroylist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
 static LIST_HEAD(connlist_err);
@@ -2035,6 +2038,14 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
 }
 
+static void __iscsi_destroy_session(struct work_struct *work)
+{
+	struct iscsi_cls_session *session =
+		container_of(work, struct iscsi_cls_session, destroy_work);
+
+	session->transport->destroy_session(session);
+}
+
 struct iscsi_cls_session *
 iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 		    int dd_size)
@@ -2057,6 +2068,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	INIT_WORK(&session->block_work, __iscsi_block_session);
 	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
 	INIT_WORK(&session->scan_work, iscsi_scan_session);
+	INIT_WORK(&session->destroy_work, __iscsi_destroy_session);
 	spin_lock_init(&session->lock);
 
 	/* this is released in the dev's release function */
@@ -3631,6 +3643,23 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		else
 			transport->destroy_session(session);
 		break;
+	case ISCSI_UEVENT_DESTROY_SESSION_ASYNC:
+		session = iscsi_session_lookup(ev->u.d_session.sid);
+		if (!session)
+			err = -EINVAL;
+		else if (iscsi_session_has_conns(ev->u.d_session.sid))
+			err = -EBUSY;
+		else {
+			unsigned long flags;
+
+			/* Prevent this session from being found again */
+			spin_lock_irqsave(&sesslock, flags);
+			list_move(&session->sess_list, &sessdestroylist);
+			spin_unlock_irqrestore(&sesslock, flags);
+
+			queue_work(iscsi_destroy_workq, &session->destroy_work);
+		}
+		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
 		if (session)
@@ -4676,8 +4705,16 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
+	iscsi_destroy_workq = create_singlethread_workqueue("iscsi_destroy");
+	if (!iscsi_destroy_workq) {
+		err = -ENOMEM;
+		goto destroy_wq;
+	}
+
 	return 0;
 
+destroy_wq:
+	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4699,6 +4736,7 @@ static __init int iscsi_transport_init(void)
 
 static void __exit iscsi_transport_exit(void)
 {
+	destroy_workqueue(iscsi_destroy_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 92b11c7e0b4f..deacaee53e61 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -60,6 +60,7 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_LOGOUT_FLASHNODE_SID	= UEVENT_BASE + 30,
 	ISCSI_UEVENT_SET_CHAP		= UEVENT_BASE + 31,
 	ISCSI_UEVENT_GET_HOST_STATS	= UEVENT_BASE + 32,
+	ISCSI_UEVENT_DESTROY_SESSION_ASYNC	= UEVENT_BASE + 33,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 2129dc9e2dec..fa8814245796 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -226,6 +226,7 @@ struct iscsi_cls_session {
 	struct work_struct unblock_work;
 	struct work_struct scan_work;
 	struct work_struct unbind_work;
+	struct work_struct destroy_work;
 
 	/* recovery fields */
 	int recovery_tmo;
-- 
2.25.0

