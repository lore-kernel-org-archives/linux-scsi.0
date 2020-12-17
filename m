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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BFBC3526B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9302389F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgLQGn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44624 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgLQGnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6Uf0Z135223;
        Thu, 17 Dec 2020 06:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=sFBS8byEQv4BOZXnXQuxpIiDFfRauaoUgkk24sTKi+U=;
 b=GqfqaVktERGnylEk5wGxlFFNClSLl5ydic6WS9jz/b9DMIIMeE5+1hmHBpLJUGNDO38f
 Jv2PamqC5po04HRybfCFlU7ICnKRmplYVGHlsTi8VMBzfFVUiARVncxnjBKLAtpy5rFA
 E5hZIJaGLLc7W9RSnMMW8F1SOWPMuXnLzkSs+x9P42IpRqbArs6E/U3EpmeoxUuxhN1/
 j89v09yz91l+W/Ixf6K8swyWpTHRdwo+BpoT8FeyyJyZpvnaCat8v7PJtG2hu95D1fvc
 VmwsLCLWXxmwX48QB1FOdsHMfpAPl5swdlSiZO4+bPVzp1gTvLizVAdl3SGbwBV8rfSd aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9rkvqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VC31020026;
        Thu, 17 Dec 2020 06:42:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35e6esvfsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:29 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH6gRep021258;
        Thu, 17 Dec 2020 06:42:27 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:27 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 08/22] libiscsi: add task prealloc/free callouts
Date:   Thu, 17 Dec 2020 00:41:58 -0600
Message-Id: <1608187332-4434-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
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
index 65bcdcc..9833fc3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2904,10 +2904,15 @@ struct iscsi_cls_session *
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
@@ -2916,7 +2921,12 @@ struct iscsi_cls_session *
 
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
@@ -2935,6 +2945,13 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
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

