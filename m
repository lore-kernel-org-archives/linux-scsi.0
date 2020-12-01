Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D80BC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9932420870
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L/LLEoKO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgLAVdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:33:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728548AbgLAVdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:33:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LSx7G081112;
        Tue, 1 Dec 2020 21:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gUJQhfOD6F5BbtI4YaUIpIDrmKr6VtxIjpNoQYugrTw=;
 b=L/LLEoKO+Q3NfqU5m74noRRnMFsqthLy1vZifkJiBMmuluAyI1XHKOK0kIb6qupqQPDR
 7MEw/FMbC3qOv7kULQNPnUh52mXYJcsV+m48tg0AtOpUw2yxlfgSoAcPj2PN5Iywi3NL
 oDps5pIWYnmamJgmaN3gxTzE0XnPfJeNa2gfcgdw2DkgXldiNLMLNRIgHdNwnihO7mcW
 H4VvfG+iVtekVUp2IOApSI+4MxqXMstwjpNiPmMcW+VgLGIG5FX7n7MO/HuOID1KMk7z
 W+NYoh3Vanor+PGSQm8jHVkpkCcfhTQfq1HXbLMpj7Md1r0E8QR0M6jzDTc2C/vuNlxH DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkmwf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:32:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LUIqd131117;
        Tue, 1 Dec 2020 21:30:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540at23sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1LUFsO018440;
        Tue, 1 Dec 2020 21:30:15 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:15 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 15/15] libiscsi: convert ping_task to refcount handler
Date:   Tue,  1 Dec 2020 15:29:56 -0600
Message-Id: <1606858196-5421-16-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already. This
would happen with the ping_task code. To fix up the API so the
caller can access the task if it needs to like in the ping_task
case, this has conn_send_pdu grab a ref to the task for the
caller. We then move the ping_task clearing to when all the
refcounts are dropped, so we know the caller and a completion
do not race.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 39 +++++++++++++++++++++------------------
 include/scsi/libiscsi.h |  3 ---
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e020fba..79cec93 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -546,13 +546,16 @@ static void iscsi_free_task(struct iscsi_task *task)
 		return;
 
 	iscsi_free_itt(session, task);
-
+ 
 	if (session->win_opened && !work_pending(&conn->xmitwork)) {
 		session->win_opened = false;
 		iscsi_conn_queue_work(conn);
 	}
 
 	if (!sc) {
+		if (READ_ONCE(conn->ping_task) == task)
+			WRITE_ONCE(conn->ping_task, NULL);
+
 		spin_lock_bh(&session->mgmt_lock);
 		kfifo_in(&session->mgmt_pool.queue, (void*)&task, sizeof(void*));
 		spin_unlock_bh(&session->mgmt_lock);
@@ -603,9 +606,6 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
 
-	if (READ_ONCE(conn->ping_task) == task)
-		WRITE_ONCE(conn->ping_task, NULL);
-
 	/* release get from queueing */
 	iscsi_put_task(task);
 }
@@ -819,6 +819,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	task->sc = NULL;
 	INIT_LIST_HEAD(&task->running);
 	task->state = ISCSI_TASK_PENDING;
+	/* Take an extra ref so the caller can access the task */
+	iscsi_get_task(task);
 
 	if (data_size) {
 		memcpy(task->data, data, data_size);
@@ -846,9 +848,6 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
-
 	if (!ihost->workq) {
 		if (iscsi_prep_mgmt_task(conn, task))
 			goto free_task;
@@ -863,6 +862,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return task;
 
 free_task:
+	/* drop extra count taken for caller and count from allocation */
+	iscsi_put_task(task);
 	iscsi_put_task(task);
 	return NULL;
 }
@@ -872,11 +873,15 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
+	struct iscsi_task *task;
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	task = __iscsi_conn_send_pdu(conn, hdr, data, data_size);
+	if (!task)
 		err = -EPERM;
+	else
+		iscsi_put_task(task);
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
 }
@@ -1047,12 +1052,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
         struct iscsi_nopout hdr;
 	struct iscsi_task *task;
 
-	if (!rhdr) {
-		if (READ_ONCE(conn->ping_task))
-			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
-	}
-
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
 	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
 	hdr.flags = ISCSI_FLAG_CMD_FINAL;
@@ -1061,20 +1060,23 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 		hdr.lun = rhdr->lun;
 		hdr.ttt = rhdr->ttt;
 		hdr.itt = RESERVED_ITT;
-	} else
+	} else {
+		if (READ_ONCE(conn->ping_task))
+			return -EINVAL;
+
 		hdr.ttt = RESERVED_ITT;
+	}
 
 	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
 	if (!task) {
-		if (!rhdr)
-			WRITE_ONCE(conn->ping_task, NULL);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
 		/* only track our nops */
 		conn->last_ping = jiffies;
+		WRITE_ONCE(conn->ping_task, task);
 	}
-
+	iscsi_put_task(task);
 	return 0;
 }
 
@@ -1907,6 +1909,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		spin_lock_bh(&session->frwd_lock);
 		return -EPERM;
 	}
+	iscsi_put_task(task);
 	conn->tmfcmd_pdus_cnt++;
 	conn->tmf_timer.expires = timeout * HZ + jiffies;
 	add_timer(&conn->tmf_timer);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d0a6834..a17c551 100644
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

