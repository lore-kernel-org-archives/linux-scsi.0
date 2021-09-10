Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2379C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A0F610C9
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhIJBNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:13:33 -0400
Received: from mail-m17642.qiye.163.com ([59.111.176.42]:15866 "EHLO
        mail-m17642.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhIJBM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 21:12:59 -0400
Received: from localhost.localdomain (unknown [113.116.176.115])
        by mail-m17642.qiye.163.com (Hmail) with ESMTPA id 3ABC52200C7;
        Fri, 10 Sep 2021 09:03:01 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH 3/3] scsi: libiscsi: get ref to conn in iscsi_eh_device/target_reset()
Date:   Fri, 10 Sep 2021 09:02:20 +0800
Message-Id: <20210910010220.24073-4-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210910010220.24073-1-dinghui@sangfor.com.cn>
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRoaTEtWGR4eSEJOGU1DSx
        8YVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktITk9VS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OS46Mio*Sj4KEh4BFy0tSEIZ
        IxIKFDJVSlVKTUhKSUhOTENKQ09PVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpNVUpMTVVKSk5ZV1kIAVlBSE9CTTcG
X-HM-Tid: 0a7bcd3ab389d998kuws3abc52200c7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

like commit fda290c5ae98 ("scsi: iscsi: Get ref to conn during reset
handling"), because in iscsi_exec_task_mgmt_fn(), the eh_mutex and
frwd_lock will be unlock, the conn also can be released if we not
hold ref.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 drivers/scsi/libiscsi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 69b3b2148328..4d3b37c20f8a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2398,7 +2398,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
-	struct iscsi_conn *conn;
+	struct iscsi_conn *conn = NULL;
 	struct iscsi_tm *hdr;
 	int rc = FAILED;
 
@@ -2417,6 +2417,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
 		goto unlock;
 	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
 
 	/* only have one tmf outstanding at a time */
 	if (session->tmf_state != TMF_INITIAL)
@@ -2463,6 +2464,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 done:
 	ISCSI_DBG_EH(session, "dev reset result = %s\n",
 		     rc == SUCCESS ? "SUCCESS" : "FAILED");
+	if (conn)
+		iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
@@ -2560,7 +2563,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
-	struct iscsi_conn *conn;
+	struct iscsi_conn *conn = NULL;
 	struct iscsi_tm *hdr;
 	int rc = FAILED;
 
@@ -2579,6 +2582,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
 		goto unlock;
 	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
 
 	/* only have one tmf outstanding at a time */
 	if (session->tmf_state != TMF_INITIAL)
@@ -2625,6 +2629,8 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 done:
 	ISCSI_DBG_EH(session, "tgt %s reset result = %s\n", session->targetname,
 		     rc == SUCCESS ? "SUCCESS" : "FAILED");
+	if (conn)
+		iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
-- 
2.17.1

