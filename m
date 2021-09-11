Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9057C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 13:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0BBA611AD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 13:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbhIKN4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 09:56:34 -0400
Received: from mail-m17642.qiye.163.com ([59.111.176.42]:37164 "EHLO
        mail-m17642.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKN4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 09:56:33 -0400
Received: from localhost.localdomain (unknown [113.116.176.115])
        by mail-m17642.qiye.163.com (Hmail) with ESMTPA id 42E20220148;
        Sat, 11 Sep 2021 21:55:19 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH v2] scsi: libiscsi: move init ehwait to iscsi_session_setup()
Date:   Sat, 11 Sep 2021 21:51:59 +0800
Message-Id: <20210911135159.20543-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRlJTRlWH00YQkhCGRhDGh
        lKVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mkk6FQw5MD4XDhxCQxcpMRIp
        NTkwCTVVSlVKTUhKSE1DTkpCQ0pJVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpNVUpMTVVKSk5ZV1kIAVlBSUhMTzcG
X-HM-Tid: 0a7bd5241f57d998kuws42e20220148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit ec29d0ac29be ("scsi: iscsi: Fix conn use after free during
resets") move member ehwait from conn to session, but left init ehwait
in iscsi_conn_setup().

Although a session can only have 1 conn currently, it is better to
do init ehwait in iscsi_session_setup() to prevent reinit by mistake,
also in case we can handle multiple conns in the future.

Fixes: ec29d0ac29be ("scsi: iscsi: Fix conn use after free during resets")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
v2:
  update commit log
 
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4683c183e9d4..712a45368385 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2947,6 +2947,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->tmf_state = TMF_INITIAL;
 	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
 	mutex_init(&session->eh_mutex);
+	init_waitqueue_head(&session->ehwait);
 
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
@@ -3074,8 +3075,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		goto login_task_data_alloc_fail;
 	conn->login_task->data = conn->data = data;
 
-	init_waitqueue_head(&session->ehwait);
-
 	return cls_conn;
 
 login_task_data_alloc_fail:
-- 
2.17.1

