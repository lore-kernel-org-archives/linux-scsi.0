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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF25C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31D8E2310E
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388644AbgLMDKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:10:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389030AbgLMDKG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD347Mp025390;
        Sun, 13 Dec 2020 03:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=hix38S5zrAF9sL3tdxODzBgmtKmngs3KQCIBpcFCTkE=;
 b=pfmIaf8IL7a+5c78cnhY4OxbBTvTrfd1wYUuaQVoIiRaK1aPfv9KIXEp2OCcauwzlSF0
 1BAn4Rlzds4lv34WCDVUvbBz9C4YAF/Skp4tnekFm3g8IZpr1d9EV0EIJ1Fri91Xo9fU
 eR8O8TGZIWM2XD4Bq+Jg3lJrT3U40kGOo0ebsddG2SiRrvZy9kbrRbexedhraOtSfbDU
 ODOUV2NJQYqsQvkdAc+AoWiiySdLqGaaMMHCVPml9jlVEOAMo40t+M5N+oAKNhn/S8I8
 w/BGJwNA4567RAl6WzOio7P7KGlp4pqyUdVYwqnChSY2/aRXh0p+/QKaUrYHwbYNJjlo tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35cntkshbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD351dS107815;
        Sun, 13 Dec 2020 03:09:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35d7ejakkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:15 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BD39Diu010279;
        Sun, 13 Dec 2020 03:09:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:13 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 18/18] libiscsi: fix conn_send_pdu API
Date:   Sat, 12 Dec 2020 21:08:46 -0600
Message-Id: <1607828926-3658-19-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already so you can't
touch it. This patch splits the task allocation and transmission, so
functions like iscsi_send_nopout can access the task before its sent.
We then can remove that INVALID_SCSI_TASK dance.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 68 ++++++++++++++++++++++++++++++++++---------------
 include/scsi/libiscsi.h |  3 ---
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 05e329b..2592fe9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -759,11 +759,10 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 }
 
 static struct iscsi_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
@@ -854,25 +853,50 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
+	return task;
+
+free_task:
+	iscsi_put_task(task);
+	return NULL;
+}
+
+static int iscsi_send_mgmt_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
+	int rc = 0;
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
-			goto free_task;
+		rc = iscsi_prep_mgmt_task(conn, task);
+		if (rc)
+			return rc;
 
-		if (session->tt->xmit_task(task))
-			goto free_task;
+		rc = session->tt->xmit_task(task);
+		if (rc)
+			return rc;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_work(conn);
 	}
 
-	return task;
+	return 0;
+}
 
-free_task:
-	iscsi_put_task(task);
-	return NULL;
+static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				 char *data, uint32_t data_size)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
+	if (!task)
+		return -ENOMEM;
+
+	rc = iscsi_send_mgmt_task(task);
+	if (rc)
+		iscsi_put_task(task);
+	return rc;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -883,7 +907,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -1058,7 +1082,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -1072,10 +1095,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task) {
+	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
+		return -ENOMEM;
+
+	if (!rhdr)
+		WRITE_ONCE(conn->ping_task, task);
+
+	if (iscsi_send_mgmt_task(task)) {
 		if (!rhdr)
 			WRITE_ONCE(conn->ping_task, NULL);
+		iscsi_put_task(task);
+
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
@@ -1904,11 +1935,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 298ff70..aae77c1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -133,9 +133,6 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-/* invalid scsi_task pointer */
-#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
-
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
1.8.3.1

