Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67D0C43463
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 15:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69123208B8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 15:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgISPFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 11:05:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:48136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgISPFU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Sep 2020 11:05:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0E0EFAD20;
        Sat, 19 Sep 2020 15:05:53 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 80B1650D8B5; Sat, 19 Sep 2020 08:05:16 -0700 (PDT)
From:   <lduncan@suse.com>
To:     linux-scsi@vger.kernel.org
Cc:     open-iscsi@googlegroups.com, Lee Duncan <lduncan@suse.com>
Subject: [RESEND] [PATCH] scsi: libiscsi: fix NOP race condition
Date:   Sat, 19 Sep 2020 08:05:09 -0700
Message-Id: <20200919150509.1284-1-lduncan@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

iSCSI NOPs are sometimes "lost", mistakenly sent to the
user-land iscsid daemon instead of handled in the kernel,
as they should be, resulting in a message from the daemon like:

> iscsid: Got nop in, but kernel supports nop handling.

This can occur because of the new forward- and back-locks,
and the fact that an iSCSI NOP response can occur before
processing of the NOP send is complete. This can result
in "conn->ping_task" being NULL in iscsi_nop_out_rsp(),
when the pointer is actually in the process of being set.

To work around this, we add a new state to the "ping_task"
pointer. In addition to NULL (not assigned) and a pointer
(assigned), we add the state "being set", which is signaled
with an INVALID pointer (using "-1").

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 11 ++++++++++-
 include/scsi/libiscsi.h |  3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1e9c3171fa9f..5eb064787ee2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
+	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
+		WRITE_ONCE(conn->ping_task, task);
+
 	if (!ihost->workq) {
 		if (iscsi_prep_mgmt_task(conn, task))
 			goto free_task;
@@ -941,6 +944,11 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
         struct iscsi_nopout hdr;
 	struct iscsi_task *task;
 
+	if (!rhdr) {
+		if (READ_ONCE(conn->ping_task))
+			return -EINVAL;
+		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
+	}
 	if (!rhdr && conn->ping_task)
 		return -EINVAL;
 
@@ -957,11 +965,12 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 
 	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
 	if (!task) {
+		if (!rhdr)
+			WRITE_ONCE(conn->ping_task, NULL);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
 		/* only track our nops */
-		conn->ping_task = task;
 		conn->last_ping = jiffies;
 	}
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c25fb86ffae9..b3bbd10eb3f0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -132,6 +132,9 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
+/* invalid scsi_task pointer */
+#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
+
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
2.26.2

