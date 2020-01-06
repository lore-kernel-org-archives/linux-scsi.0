Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A96C33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E326208C4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgAFS6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:58:37 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35948 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgAFS6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 13:58:37 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5375929196F;
        Mon,  6 Jan 2020 18:58:35 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     gregkh@linuxfoundation.org
Cc:     rafael@kernel.org, lduncan@suse.com, cleech@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 3/3] iscsi: Fail session and connection on transport registration failure
Date:   Mon,  6 Jan 2020 13:58:17 -0500
Message-Id: <20200106185817.640331-4-krisman@collabora.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106185817.640331-1-krisman@collabora.com>
References: <20200106185817.640331-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the transport cannot be registered, the session/connection creation
needs to be failed early to let the initiator know.  Otherwise, the
system will have an outstanding connection that cannot be used nor
removed by open-iscsi. The result is similar to the error below,
triggered by injecting a failure in the transport's registration path.

openiscsi reports success:

root@debian-vm:~#  iscsiadm -m node -T iqn:lun1 -p 127.0.0.1 -l
Logging in to [iface: default, target: iqn:lun1, portal: 127.0.0.1,3260]
Login to [iface: default, target: iqn:lun1, portal:127.0.0.1,3260] successful.

But cannot remove the session afterwards, since the kernel is in an
inconsistent state.

root@debian-vm:~#  iscsiadm -m node -T iqn:lun1 -p 127.0.0.1 -u
iscsiadm: No matching sessions found

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ed8d9709b9b9..2b732b7a9a5b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2093,7 +2093,12 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 					 "could not register session's dev\n");
 		goto release_ida;
 	}
-	transport_register_device(&session->dev);
+	err = transport_register_device(&session->dev);
+	if (err) {
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "could not register transport's dev\n");
+		goto release_dev;
+	}
 
 	spin_lock_irqsave(&sesslock, flags);
 	list_add(&session->sess_list, &sesslist);
@@ -2103,6 +2108,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	ISCSI_DBG_TRANS_SESSION(session, "Completed session adding\n");
 	return 0;
 
+release_dev:
+	device_del(&session->dev);
 release_ida:
 	if (session->ida_used)
 		ida_simple_remove(&iscsi_sess_ida, session->target_id);
@@ -2263,7 +2270,12 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 					 "register connection's dev\n");
 		goto release_parent_ref;
 	}
-	transport_register_device(&conn->dev);
+	err = transport_register_device(&conn->dev);
+	if (err) {
+		iscsi_cls_session_printk(KERN_ERR, session, "could not "
+					 "register transport's dev\n");
+		goto release_conn_ref;
+	}
 
 	spin_lock_irqsave(&connlock, flags);
 	list_add(&conn->conn_list, &connlist);
@@ -2272,6 +2284,8 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 	ISCSI_DBG_TRANS_CONN(conn, "Completed conn creation\n");
 	return conn;
 
+release_conn_ref:
+	put_device(&conn->dev);
 release_parent_ref:
 	put_device(&session->dev);
 free_conn:
-- 
2.24.1

