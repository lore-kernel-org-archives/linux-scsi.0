Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FD9C2BBCA
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B431923110
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgLMDK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:10:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60542 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732770AbgLMDKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD33Y4N156184;
        Sun, 13 Dec 2020 03:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=remKnPQ1E9y7U30X3L8jpFzKJ7b5tNUKm3X8xslBbLM=;
 b=L8Zymd8IpqVMeZ+2zqN0XXT3g2WSWM93QWe7ot3XPpav89LPBDzXjhAf92AV1KqIAF9f
 /P3gpdGPBtziBt/Jmt5m6HLKHjaSJd9hMW2ui0loReP9WWotFl7dG/djAVlN/L+Powig
 mzdHSbF2yCgWFTbm5SgQY27+zam3+XPivbW+qgBYj9EDi+PGUUM/Z16Excz82+K4onms
 l0lfJTO41JJ/jMKofmV5qWQWIyFkFXMl9ftXbd8Sn2MdfMBok5GxbYGNXpnM7JooGJjq
 rgkabaD1HFSDg350y9DhbjVQCnwUt19upkkUE6IRZ868zU08eSVCGzT8tZqnuHa8fe9J Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb1ph1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD351EO107824;
        Sun, 13 Dec 2020 03:09:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35d7ejakh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BD392J3010503;
        Sun, 13 Dec 2020 03:09:02 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:02 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 07/18] libiscsi: add task prealloc/free callouts
Date:   Sat, 12 Dec 2020 21:08:35 -0600
Message-Id: <1607828926-3658-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some drivers need to allocate resources that functions
like dma_alloc* that can't be allocated with the iscsi_task struct.
The next patches have the iscsi drivers use the block/scsi mq cmd
allocators for scsi tasks and the drivers can use the init_cmd_priv
callout to allocate these extra resource for scsi tasks there. For
mgmt tasks, drivers can use the callouts added in this patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             | 21 +++++++++++++++++++--
 include/scsi/scsi_transport_iscsi.h |  5 +++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ae8b755..6621a69 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2885,10 +2885,15 @@ struct iscsi_cls_session *
 		task->itt = cmd_i;
 		task->state = ISCSI_TASK_FREE;
 		INIT_LIST_HEAD(&task->running);
+
+		if (iscsit->alloc_task_priv) {
+			if (iscsit->alloc_task_priv(session, task))
+				goto free_task_priv;
+		}
 	}
 
 	if (!try_module_get(iscsit->owner))
-		goto module_get_fail;
+		goto free_task_priv;
 
 	if (iscsi_add_session(cls_session, id))
 		goto cls_session_fail;
@@ -2897,7 +2902,12 @@ struct iscsi_cls_session *
 
 cls_session_fail:
 	module_put(iscsit->owner);
-module_get_fail:
+free_task_priv:
+	for (cmd_i--; cmd_i >= 0; cmd_i--) {
+		if (iscsit->free_task_priv)
+			iscsit->free_task_priv(session, session->cmds[cmd_i]);
+	}
+
 	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
 	iscsi_free_session(cls_session);
@@ -2916,6 +2926,13 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *session = cls_session->dd_data;
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
+	int cmd_i;
+
+	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
+		if (session->tt->free_task_priv)
+			session->tt->free_task_priv(session,
+						    session->cmds[cmd_i]);
+	}
 
 	iscsi_pool_free(&session->cmdpool);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2f..cdd358e 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -22,6 +22,7 @@
 struct scsi_cmnd;
 struct iscsi_cls_conn;
 struct iscsi_conn;
+struct iscsi_session;
 struct iscsi_task;
 struct sockaddr;
 struct iscsi_iface;
@@ -106,6 +107,10 @@ struct iscsi_transport {
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
 
+	int (*alloc_task_priv) (struct iscsi_session *session,
+				struct iscsi_task *task);
+	void (*free_task_priv) (struct iscsi_session *session,
+				struct iscsi_task *task);
 	int (*init_task) (struct iscsi_task *task);
 	int (*xmit_task) (struct iscsi_task *task);
 	void (*cleanup_task) (struct iscsi_task *task);
-- 
1.8.3.1

