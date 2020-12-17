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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6124C2BBCF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82DE2389A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgLQGnW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgLQGnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UK1U135130;
        Thu, 17 Dec 2020 06:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ONAZO3j/OxUqtmYOKhNu0VOSf1e1ANVyV1Lm1HlJrRs=;
 b=jmfEhgw5BZDy2dTSjvs0QaGLQEQXZb+HelVhRD6TZN/tlyL8mpa2zgqP0V8iG6LnEUvP
 +B/gUAfEzvfktAfw0FF+96gLH6Dz7XMnadECGiPPo1f/c2aabsR+P1lZkiEcM6Q3v2rj
 DK4q1lXIHtyNF2SdkPSc4pRl9oL/gt7dg6ffy13U3aPICvLnFKh9rj23eM61YKXAAq9/
 gKhjBJlAhKfm51+Z6+ZghiLehkKGx6kcfdhTkhm1MWrmE+HqGFEeWhF8oHAjTE+xyxkO
 bI4E5QiaLUoOubjvrocpRJuzOzlqklyv0hk95lh7xr/givU67G9P+I1as/3wN4LsOmAf +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9rkvqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VCsQ020005;
        Thu, 17 Dec 2020 06:42:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6esvfru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:27 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH6gQNd018177;
        Thu, 17 Dec 2020 06:42:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:26 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 07/22] libiscsi: drop frwd lock for session state
Date:   Thu, 17 Dec 2020 00:41:57 -0600
Message-Id: <1608187332-4434-8-git-send-email-michael.christie@oracle.com>
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

This drops the frwd lock for the session state checks in queuecommand.
Like with the transport class case, we only need it as a hint since when
the session is cleaned up we will block the session which flushes the
queues, and then we clean up all running IO. So the locking just prevents
cleaning up extra cmds.

It is still needed:
1. when accessing suspend_tx in queuecomand because drivers that
implement ep_disconnect will set that bit from disconnect (called
before stop) and expect that no new commands will be queued to it.
Note that the comment for this was wrong and that is fixed in this
patch.

2. the list addition for the drivers that use the iscsi xmit wq.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 10 +++++++---
 include/scsi/libiscsi.h |  5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 012b7ea..65bcdcc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1702,7 +1702,6 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock_bh(&session->frwd_lock);
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
@@ -1759,7 +1758,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
+	spin_lock_bh(&session->frwd_lock);
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1767,6 +1768,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	task = iscsi_alloc_task(conn, sc);
 	if (!task) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_OOM;
 		goto reject;
 	}
@@ -1801,21 +1803,23 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	return 0;
 
 prepd_reject:
+	spin_unlock_bh(&session->frwd_lock);
+
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 reject:
-	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
+	spin_unlock_bh(&session->frwd_lock);
+
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 fault:
-	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 287e46b..2f99ad6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -326,8 +326,9 @@ struct iscsi_session {
 	 * can enclose the mutual exclusion zone protected by the backward lock
 	 * but not vice versa.
 	 */
-	spinlock_t		frwd_lock;	/* protects session state, *
-						 * cmdsn and session       *
+	spinlock_t		frwd_lock;	/* protects session state  *
+						 * in the eh paths, cmdsn  *
+						 * suspend bit and session *
 						 * resources:              *
 						 * - cmdpool kfifo_out ,   *
 						 * - mgmtpool, queues	   */
-- 
1.8.3.1

