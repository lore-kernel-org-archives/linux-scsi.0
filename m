Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B914AC76196
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCSB4j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCSB4g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279F52312C;
        Sat, 18 Mar 2023 18:56:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32J1uX5b013888;
        Sun, 19 Mar 2023 01:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=j4euk1gcVE9ECbI1zFtyWPtER0ZZeTvaCA+w2iILEP0=;
 b=UxXzElrjCTZA262OsO4MNr94IGTLwYdGrdamgfhIZY18o5LD793VjwX7fTftTlMU0wde
 hu6ucxSsAScueXDQopIgbWlOqVdsu6+SZgAfSiW6g9dwpjJmTHqbP9/kEXGTJON7RxW1
 QzewxNM5x2lZ12b1AhcTzCMmNRBZeH94d8/58RXZJdwiFyQk5/lmQhJHOO/U8OJLJ8vK
 w4GQkfUC1mXeK9J2WnGAntF6mcYyG4i221S9a3FcfsLaVBtzOka7fSuZnCoZZ2asFqU6
 CDgeCQLiDGfsTatTJ9aBWYMeOfEGsI1D7WL/fTJqGjhjZko40YwdMS2i+IfQ6rBUXsqo Wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3wg95u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32INXwcT031168;
        Sun, 19 Mar 2023 01:56:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaud5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5M014254;
        Sun, 19 Mar 2023 01:56:30 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-5;
        Sun, 19 Mar 2023 01:56:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 4/9] scsi: target: iscsit/isert: Alloc per conn cmd counter
Date:   Sat, 18 Mar 2023 20:56:15 -0500
Message-Id: <20230319015620.96006-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190014
X-Proofpoint-ORIG-GUID: Ek13pIDQZEiRP0J__KzlUHX5tkaVRLAG
X-Proofpoint-GUID: Ek13pIDQZEiRP0J__KzlUHX5tkaVRLAG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has iscsit allocate a per conn cmd counter and converts iscsit/isert
to use it instead of the per session one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c   |  4 ++--
 drivers/target/iscsi/iscsi_target.c       |  4 ++--
 drivers/target/iscsi/iscsi_target_login.c | 17 +++++++----------
 drivers/target/target_core_transport.c    |  9 ++++++---
 include/target/target_core_fabric.h       |  3 +++
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 75404885cf98..f290cd49698e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2506,8 +2506,8 @@ isert_wait4cmds(struct iscsit_conn *conn)
 	isert_info("iscsit_conn %p\n", conn);
 
 	if (conn->sess) {
-		target_stop_session(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
+		target_stop_cmd_counter(conn->cmd_cnt);
+		target_wait_for_cmds(conn->cmd_cnt);
 	}
 }
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 87927a36f90d..11115c207844 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1193,7 +1193,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
 			  cmd->data_direction, sam_task_attr,
 			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
-			  conn->sess->se_sess->cmd_cnt);
+			  conn->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2057,7 +2057,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
 			  scsilun_to_int(&hdr->lun),
-			  conn->sess->se_sess->cmd_cnt);
+			  conn->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 8ab6c0107d89..274bdd7845ca 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,18 +324,8 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
-	/*
-	 * This is temp for iser. It will be moved to per conn in later
-	 * patches for iscsi.
-	 */
-	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!sess->se_sess->cmd_cnt)
-		goto free_se_sess;
-
 	return 0;
 
-free_se_sess:
-	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
@@ -1157,8 +1147,14 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 		goto free_conn_cpumask;
 	}
 
+	conn->cmd_cnt = target_alloc_cmd_counter();
+	if (!conn->cmd_cnt)
+		goto free_conn_allowed_cpumask;
+
 	return conn;
 
+free_conn_allowed_cpumask:
+	free_cpumask_var(conn->allowed_cpumask);
 free_conn_cpumask:
 	free_cpumask_var(conn->conn_cpumask);
 free_conn_ops:
@@ -1172,6 +1168,7 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 void iscsit_free_conn(struct iscsit_conn *conn)
 {
+	target_free_cmd_counter(conn->cmd_cnt);
 	free_cpumask_var(conn->allowed_cpumask);
 	free_cpumask_var(conn->conn_cpumask);
 	kfree(conn->conn_ops);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c395606ab1a9..86adff2a86ed 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -254,7 +254,7 @@ struct target_cmd_counter *target_alloc_cmd_counter(void)
 }
 EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
-static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	/*
 	 * Drivers like loop do not call target_stop_session during session
@@ -265,6 +265,7 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 
 	percpu_ref_exit(&cmd_cnt->refcnt);
 }
+EXPORT_SYMBOL_GPL(target_free_cmd_counter);
 
 /**
  * transport_init_session - initialize a session object
@@ -3170,13 +3171,14 @@ static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
  * target_stop_cmd_counter - Stop new IO from being added to the counter.
  * @cmd_cnt: counter to stop
  */
-static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	pr_debug("Stopping command counter.\n");
 	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
 		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
 					    target_stop_cmd_counter_confirm);
 }
+EXPORT_SYMBOL_GPL(target_stop_cmd_counter);
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
@@ -3192,7 +3194,7 @@ EXPORT_SYMBOL(target_stop_session);
  * target_wait_for_cmds - Wait for outstanding cmds.
  * @cmd_cnt: counter to wait for active I/O for.
  */
-static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
@@ -3208,6 +3210,7 @@ static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+EXPORT_SYMBOL_GPL(target_wait_for_cmds);
 
 /**
  * target_wait_for_sess_cmds - Wait for outstanding commands
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d507e7885f17..b188b1e90e1e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,10 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt);
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt);
 struct target_cmd_counter *target_alloc_cmd_counter(void);
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt);
 
 void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
-- 
2.25.1

